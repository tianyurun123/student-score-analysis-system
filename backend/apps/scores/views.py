from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.db.models import Q, Avg, Max, Min, Count
from django.utils import timezone
from django.http import HttpResponse
import json
import logging

from apps.scores.models import Score, ScoreImportLog, ScoreAdjustment, Gradebook, AlgorithmScore
from apps.scores.serializers import (
    ScoreSerializer, ScoreCreateSerializer, ScoreUpdateSerializer,
    ScoreImportLogSerializer, ScoreAdjustmentSerializer,
    ExcelUploadSerializer, ScoreStatisticsSerializer,
    GradebookSerializer, GradebookCreateSerializer, AlgorithmScoreSerializer
)
from apps.scores.excel_handlers import ExcelScoreHandler, FinalPaperExcelHandler
from apps.courses.models import CourseClass, GradingPolicy
from apps.users.models import User
from utils.calculator import ScoreCalculator
from apps.scores.permissions import IsTeacherOrAdmin

logger = logging.getLogger(__name__)


class ScoreViewSet(viewsets.ModelViewSet):
    """成绩视图集"""
    permission_classes = [IsAuthenticated, IsTeacherOrAdmin]
    queryset = Score.objects.all()

    def get_serializer_class(self):
        if self.action == 'create':
            return ScoreCreateSerializer
        elif self.action in ['update', 'partial_update']:
            return ScoreUpdateSerializer
        return ScoreSerializer

    def get_queryset(self):
        """根据用户权限过滤查询集"""
        queryset = super().get_queryset()
        user = self.request.user

        # 如果是学生，只能查看自己的成绩
        if user.user_type == 'student':
            queryset = queryset.filter(student=user)
        # 如果是教师，只能查看自己授课的课程成绩
        elif user.user_type == 'teacher':
            queryset = queryset.filter(
                Q(course_class__main_teacher=user) |
                Q(course_class__assistant_teachers=user) |
                Q(course_class__course__teachers=user)
            ).distinct()

        # 过滤参数
        course_class_id = self.request.query_params.get('course_class_id')
        if course_class_id:
            queryset = queryset.filter(course_class_id=course_class_id)

        student_id = self.request.query_params.get('student_id')
        if student_id:
            queryset = queryset.filter(student__employee_id=student_id)

        is_published = self.request.query_params.get('is_published')
        if is_published is not None:
            queryset = queryset.filter(is_published=is_published.lower() == 'true')

        return queryset.select_related('student', 'course_class', 'course_class__course', 'grading_policy')

    def perform_create(self, serializer):
        """创建成绩时设置创建人，并确保学生已加入班级"""
        score = serializer.save(
            created_by=self.request.user,
            updated_by=self.request.user
        )
        
        # 确保学生已加入该班级（创建Enrollment记录）
        from apps.courses.models import Enrollment
        enrollment, created = Enrollment.objects.get_or_create(
            student=score.student,
            course_class=score.course_class,
            defaults={'is_active': True}
        )
        
        if created:
            logger.info(f"为新增成绩记录自动创建了选课记录: student={score.student.id}, class={score.course_class.id}")
        
        # 计算成绩
        try:
            score.calculate_grade()
            score.save()
        except Exception as e:
            logger.warning(f"计算新成绩记录失败: {str(e)}")

    def perform_update(self, serializer):
        """更新成绩时设置更新人"""
        serializer.save(updated_by=self.request.user)
    
    def list(self, request, *args, **kwargs):
        """列表查询，序列化器会实时计算usual_entry和final_entry
        同时检查是否有新增的学生（有Enrollment但没有Score），如果有则创建Score记录
        """
        course_class_id = request.query_params.get('course_class_id')
        
        # 如果指定了course_class_id，检查是否有新增的学生需要创建成绩记录
        if course_class_id:
            try:
                course_class = CourseClass.objects.get(id=course_class_id)
                # 获取该班级的所有学生（Enrollment）
                from apps.courses.models import Enrollment
                enrollments = Enrollment.objects.filter(
                    course_class=course_class,
                    is_active=True
                ).select_related('student')
                
                # 获取该班级已有的成绩记录
                existing_scores = Score.objects.filter(
                    course_class=course_class
                ).values_list('student_id', flat=True)
                
                # 找出没有成绩记录的学生
                students_without_scores = [
                    enrollment.student for enrollment in enrollments
                    if enrollment.student.id not in existing_scores
                ]
                
                # 为新增的学生创建成绩记录
                if students_without_scores:
                    # 获取评分政策
                    grading_policy = course_class.course.grading_policy if hasattr(course_class.course, 'grading_policy') else None
                    
                    new_scores = []
                    for student in students_without_scores:
                        score = Score.objects.create(
                            student=student,
                            course_class=course_class,
                            grading_policy=grading_policy,
                            created_by=request.user,
                            updated_by=request.user
                        )
                        new_scores.append(score)
                    
                    if new_scores:
                        logger.info(f"为班级 {course_class_id} 的 {len(new_scores)} 名新增学生创建了成绩记录")
                        
                        # 批量计算新创建的成绩（如果需要）
                        for score in new_scores:
                            try:
                                score.calculate_grade()
                                score.save()
                            except Exception as e:
                                logger.warning(f"计算新成绩记录 {score.id} 失败: {str(e)}")
            
            except CourseClass.DoesNotExist:
                pass
            except Exception as e:
                logger.error(f"检查新增学生时出错: {str(e)}")
        
        # 序列化器已经可以实时计算这些字段，不需要在这里更新
        # 为了性能，可以异步批量更新数据库中的值（可选）
        return super().list(request, *args, **kwargs)
    
    @action(detail=False, methods=['post'], url_path='batch-recalculate-entries')
    def batch_recalculate_entries(self, request):
        """批量重新计算平时录入和期末录入（后台任务）"""
        course_class_id = request.data.get('course_class_id')
        if not course_class_id:
            return Response({'error': '请提供course_class_id'}, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            queryset = self.get_queryset().filter(course_class_id=course_class_id)
            scores_needing_update = queryset.filter(
                Q(usual_entry__isnull=True) | Q(final_entry__isnull=True)
            )
            
            updated_count = 0
            batch_size = 100
            scores_to_update = []
            
            for score in scores_needing_update:
                try:
                    score.calculate_grade()
                    scores_to_update.append(score)
                    
                    # 每批更新一次
                    if len(scores_to_update) >= batch_size:
                        Score.objects.bulk_update(
                            scores_to_update,
                            ['usual_entry', 'final_entry', 'final_grade', 'grade_point', 'grade_level'],
                            batch_size=batch_size
                        )
                        updated_count += len(scores_to_update)
                        scores_to_update = []
                except Exception as e:
                    logger.error(f"重新计算成绩失败 {score.id}: {str(e)}")
            
            # 更新剩余的记录
            if scores_to_update:
                Score.objects.bulk_update(
                    scores_to_update,
                    ['usual_entry', 'final_entry', 'final_grade', 'grade_point', 'grade_level'],
                    batch_size=batch_size
                )
                updated_count += len(scores_to_update)
            
            return Response({
                'message': f'成功重新计算 {updated_count} 条成绩记录的平时录入和期末录入',
                'updated_count': updated_count
            })
        except Exception as e:
            logger.error(f"批量重新计算失败: {str(e)}")
            return Response({'error': f'批量重新计算失败: {str(e)}'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @action(detail=False, methods=['post'], url_path='import-excel')
    def import_excel(self, request):
        """导入Excel成绩"""
        serializer = ExcelUploadSerializer(data=request.data)
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        file = serializer.validated_data['file']
        course_class_id = serializer.validated_data['course_class_id']
        column_mapping = serializer.validated_data.get('column_mapping', {})

        try:
            # 解析Excel
            handler = ExcelScoreHandler()
            result = handler.parse_excel(file, course_class_id)

            if not result['success']:
                return Response({
                    'success': False,
                    'message': 'Excel解析失败',
                    'errors': result['errors'],
                    'suggested_fields': result['suggested_fields'],
                }, status=status.HTTP_400_BAD_REQUEST)

            # 创建导入日志
            import_log = ScoreImportLog.objects.create(
                file_name=file.name,
                file_path='',
                course_class_id=course_class_id,
                imported_by=request.user,
                total_rows=len(result['data']),
                column_mapping=result['column_mapping'],
                status='processing'
            )

            # 导入数据
            import_result = handler.import_scores(
                result['data'],
                course_class_id,
                request.user.id,
                result['column_mapping']
            )

            # 更新导入日志
            import_log.success_rows = import_result['success']
            import_log.failed_rows = import_result['failed']
            import_log.error_log = '\n'.join(import_result['errors'])
            import_log.status = 'completed' if import_result['failed'] == 0 else 'partial'
            import_log.completed_at = timezone.now()
            import_log.save()

            return Response({
                'success': True,
                'message': f'导入完成：成功 {import_result["success"]} 条，失败 {import_result["failed"]} 条',
                'data': {
                    'success_count': import_result['success'],
                    'failed_count': import_result['failed'],
                    'errors': import_result['errors'][:10],  # 只返回前10个错误
                },
                'import_log_id': import_log.id,
            })

        except Exception as e:
            logger.error(f"导入Excel失败: {str(e)}")
            return Response({
                'success': False,
                'message': f'导入失败: {str(e)}'
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @action(detail=False, methods=['post'], url_path='preview-excel')
    def preview_excel(self, request):
        """预览Excel文件（不导入）"""
        if 'file' not in request.FILES:
            return Response({
                'success': False,
                'error': '请上传文件',
                'errors': ['请上传Excel文件']
            }, status=status.HTTP_400_BAD_REQUEST)

        file = request.FILES['file']
        
        # 检查文件扩展名
        if not file.name.endswith(('.xlsx', '.xls')):
            return Response({
                'success': False,
                'error': '文件格式不正确',
                'errors': ['只支持.xlsx和.xls格式的Excel文件']
            }, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            handler = ExcelScoreHandler()
            result = handler.parse_excel(file)
            
            # 如果解析失败，返回更详细的错误信息
            if not result['success']:
                error_msg = '文件解析失败，请检查文件格式'
                if result.get('errors'):
                    error_msg += f"。错误：{'; '.join(result['errors'][:3])}"
                
                return Response({
                    'success': False,
                    'error': error_msg,
                    'data': [],
                    'total_count': 0,
                    'columns': result.get('columns', []),
                    'column_mapping': result.get('column_mapping', {}),
                    'suggested_fields': result.get('suggested_fields', []),
                    'errors': result.get('errors', []),
                })
            
            return Response({
                'success': True,
                'data': result['data'][:20],  # 只返回前20条预览
                'total_count': len(result['data']),
                'columns': result['columns'],
                'column_mapping': result['column_mapping'],
                'suggested_fields': result['suggested_fields'],
                'errors': result['errors'][:10],  # 只返回前10个错误
            })
        except Exception as e:
            logger.error(f"预览Excel文件失败: {str(e)}", exc_info=True)
            return Response({
                'success': False,
                'error': f'预览失败: {str(e)}',
                'errors': [f'预览失败: {str(e)}']
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @action(detail=True, methods=['post'])
    def publish(self, request, pk=None):
        """发布成绩"""
        score = self.get_object()
        score.is_published = True
        score.published_at = timezone.now()
        score.save()

        return Response({
            'message': '成绩已发布',
            'published_at': score.published_at
        })

    @action(detail=True, methods=['post'])
    def unpublish(self, request, pk=None):
        """取消发布成绩"""
        score = self.get_object()
        score.is_published = False
        score.published_at = None
        score.save()

        return Response({'message': '成绩已取消发布'})

    @action(detail=False, methods=['get'], url_path='statistics')
    def statistics(self, request):
        """获取成绩统计信息"""
        course_class_id = request.query_params.get('course_class_id')
        if not course_class_id:
            return Response({'error': '请提供course_class_id'}, status=status.HTTP_400_BAD_REQUEST)

        queryset = self.get_queryset().filter(course_class_id=course_class_id)
        scores = [s.final_grade for s in queryset if s.final_grade is not None]

        stats = ScoreCalculator.calculate_statistics(scores)
        serializer = ScoreStatisticsSerializer(stats)

        return Response(serializer.data)

    @action(detail=False, methods=['get'], url_path='export')
    def export(self, request):
        """导出成绩为Excel（标准格式）"""
        import pandas as pd
        from io import BytesIO

        queryset = self.get_queryset()
        course_class_id = request.query_params.get('course_class_id')
        if course_class_id:
            queryset = queryset.filter(course_class_id=course_class_id)

        # 构建数据
        data = []
        for score in queryset:
            row = {
                '学号': score.student.employee_id or score.student.username,
                '姓名': score.student.first_name,
                '考勤': score.attendance_score,
                '作业': score.homework_score,
                '实验': score.experiment_score,
                '复习笔记': score.review_note_score,
                '期末': score.final_score,
                '平时总分': score.usual_total,
                '期末总分': score.final_total,
                '最终成绩': score.final_grade,
                '绩点': score.grade_point,
                '等级': score.grade_level,
            }
            # 添加额外成绩字段
            if score.extra_scores:
                row.update(score.extra_scores)
            data.append(row)

        # 创建DataFrame
        df = pd.DataFrame(data)

        # 导出为Excel
        output = BytesIO()
        with pd.ExcelWriter(output, engine='openpyxl') as writer:
            df.to_excel(writer, index=False, sheet_name='成绩表')

        output.seek(0)
        response = HttpResponse(
            output.read(),
            content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        )
        response['Content-Disposition'] = 'attachment; filename="scores.xlsx"'
        return response

    @action(detail=False, methods=['get'], url_path='classes-with-scores')
    def classes_with_scores(self, request):
        """获取有成绩的班级列表"""
        # 获取有成绩的班级
        queryset = CourseClass.objects.filter(
            scores__isnull=False
        ).distinct().select_related('course', 'main_teacher')
        
        # 根据用户权限过滤
        user = request.user
        if user.user_type == 'teacher':
            queryset = queryset.filter(
                Q(main_teacher=user) |
                Q(assistant_teachers=user) |
                Q(course__teachers=user)
            ).distinct()
        
        # 统计每个班级的成绩数量
        classes_data = []
        for course_class in queryset:
            score_count = Score.objects.filter(course_class=course_class).count()
            classes_data.append({
                'id': course_class.id,
                'course_code': course_class.course.course_code,
                'course_name': course_class.course.course_name,
                'class_name': course_class.class_name,
                'main_teacher_name': course_class.main_teacher.first_name if course_class.main_teacher else '',
                'score_count': score_count,
                'students_count': course_class.enrollment_set.filter(is_active=True).count()
            })
        
        return Response({
            'results': classes_data,
            'count': len(classes_data)
        })

    @action(detail=False, methods=['get'], url_path='export-achievement')
    def export_achievement(self, request):
        """导出课程目标达成度计算表（目标格式）"""
        from io import BytesIO
        import pandas as pd
        from openpyxl import Workbook
        from openpyxl.styles import Font, Alignment, Border, Side
        from openpyxl.utils import get_column_letter
        from apps.courses.models import CourseClass, CourseObjectiveAchievement
        from utils.objective_calculator import ObjectiveCalculator

        course_class_id = request.query_params.get('course_class_id')
        if not course_class_id:
            return Response({'error': '请提供course_class_id'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            course_class = CourseClass.objects.select_related('course').get(id=course_class_id)
        except CourseClass.DoesNotExist:
            return Response({'error': '课程班级不存在'}, status=status.HTTP_404_NOT_FOUND)

        # 获取成绩数据
        scores = self.get_queryset().filter(course_class_id=course_class_id).select_related(
            'student', 'student__student_profile'
        ).prefetch_related('objective_achievements')

        if not scores.exists():
            return Response({'error': '该班级没有成绩数据'}, status=status.HTTP_400_BAD_REQUEST)

        # 创建Workbook
        wb = Workbook()
        ws = wb.active
        ws.title = course_class.class_name

        # 设置样式
        header_font = Font(bold=True, size=11)
        center_align = Alignment(horizontal='center', vertical='center')
        border = Border(
            left=Side(style='thin'),
            right=Side(style='thin'),
            top=Side(style='thin'),
            bottom=Side(style='thin')
        )

        # 第一行：基本信息（先赋值，再合并）
        # 院系专业
        cell_a1 = ws.cell(row=1, column=1, value='院系专业')
        cell_a1.font = header_font
        cell_a1.alignment = center_align
        ws.merge_cells('A1:B1')
        
        # 开课学院
        cell_c1 = ws.cell(row=1, column=3, value=course_class.course.department or '计算机学院')
        cell_c1.alignment = center_align
        ws.merge_cells('C1:E1')
        
        # 课程名称
        cell_f1 = ws.cell(row=1, column=6, value='课程名称：' + course_class.course.course_name)
        cell_f1.font = header_font
        cell_f1.alignment = center_align
        ws.merge_cells('F1:J1')
        
        # 专业班级
        cell_k1 = ws.cell(row=1, column=11, value='专业班级：' + course_class.class_name)
        cell_k1.alignment = center_align
        ws.merge_cells('K1:O1')

        # 第二行：表头（合并单元格的标题）
        # 学号、姓名
        ws.cell(row=2, column=1, value='学号').font = header_font
        ws.cell(row=2, column=1).alignment = center_align
        ws.cell(row=2, column=1).border = border
        ws.cell(row=2, column=2, value='姓名').font = header_font
        ws.cell(row=2, column=2).alignment = center_align
        ws.cell(row=2, column=2).border = border
        
        # 平时成绩（合并C2:E2，包含点名、电子笔记、作业成绩）
        ws.cell(row=2, column=3, value='平时成绩').font = header_font
        ws.cell(row=2, column=3).alignment = center_align
        ws.cell(row=2, column=3).border = border
        
        # 平时成绩（整数，F2）
        ws.cell(row=2, column=6, value='平时成绩').font = header_font
        ws.cell(row=2, column=6).alignment = center_align
        ws.cell(row=2, column=6).border = border
        
        # 实验（G2）
        ws.cell(row=2, column=7, value='实验').font = header_font
        ws.cell(row=2, column=7).alignment = center_align
        ws.cell(row=2, column=7).border = border
        
        # 期末作品（合并H2:J2，包含作品、报告、期末平均）
        ws.cell(row=2, column=8, value='期末作品').font = header_font
        ws.cell(row=2, column=8).alignment = center_align
        ws.cell(row=2, column=8).border = border
        
        # 课程目标1（合并K2:O2，包含平时、实验、期末、达成情况、达成度）
        ws.cell(row=2, column=11, value='课程目标1').font = header_font
        ws.cell(row=2, column=11).alignment = center_align
        ws.cell(row=2, column=11).border = border
        
        # 课程目标2（合并P2:T2，包含平时、实验、期末、达成情况、达成度）
        ws.cell(row=2, column=16, value='课程目标2').font = header_font
        ws.cell(row=2, column=16).alignment = center_align
        ws.cell(row=2, column=16).border = border
        
        # 课程目标3（合并U2:Y2，包含平时、实验、期末、达成情况、达成度）
        ws.cell(row=2, column=21, value='课程目标3').font = header_font
        ws.cell(row=2, column=21).alignment = center_align
        ws.cell(row=2, column=21).border = border
        
        # 总分值（Z2）
        ws.cell(row=2, column=26, value='总分值').font = header_font
        ws.cell(row=2, column=26).alignment = center_align
        ws.cell(row=2, column=26).border = border
        
        # 平时录入（AA2）
        ws.cell(row=2, column=27, value='平时录入').font = header_font
        ws.cell(row=2, column=27).alignment = center_align
        ws.cell(row=2, column=27).border = border
        
        # 期末录入（AB2）
        ws.cell(row=2, column=28, value='期末录入').font = header_font
        ws.cell(row=2, column=28).alignment = center_align
        ws.cell(row=2, column=28).border = border
        
        # 最终成绩（AC2）
        ws.cell(row=2, column=29, value='最终成绩').font = header_font
        ws.cell(row=2, column=29).alignment = center_align
        ws.cell(row=2, column=29).border = border

        # 第三行：详细表头（必须与数据行的列数完全一致）
        headers_row3 = ['', '', '点名', '电子笔记', '作业成绩', '', '', '作品', '报告', '期末平均',
                       '平时', '实验', '期末', '达成情况', '达成度',
                       '平时', '实验', '期末', '达成情况', '达成度',
                       '平时', '实验', '期末', '达成情况', '达成度', '', '', '', '']
        for col_idx, header in enumerate(headers_row3, 1):
            cell = ws.cell(row=3, column=col_idx, value=header)
            cell.font = header_font
            cell.alignment = center_align
            cell.border = border
            cell.font = header_font
            cell.alignment = center_align
            cell.border = border

        # 合并单元格（先赋值，再合并）
        # 确保所有单元格都已赋值后再合并
        ws.merge_cells('A2:A3')  # 学号
        ws.merge_cells('B2:B3')  # 姓名
        ws.merge_cells('C2:E2')  # 平时成绩（点名、电子笔记、作业成绩）
        ws.merge_cells('F2:F3')  # 平时成绩（整数）
        ws.merge_cells('G2:G3')  # 实验
        ws.merge_cells('H2:J2')  # 期末作品（作品、报告、期末平均）
        ws.merge_cells('K2:O2')  # 课程目标1（平时、实验、期末、达成情况、达成度）
        ws.merge_cells('P2:T2')  # 课程目标2（平时、实验、期末、达成情况、达成度）
        ws.merge_cells('U2:Y2')  # 课程目标3（平时、实验、期末、达成情况、达成度）
        ws.merge_cells('Z2:Z3')  # 总分值
        ws.merge_cells('AA2:AA3')  # 平时录入
        ws.merge_cells('AB2:AB3')  # 期末录入
        ws.merge_cells('AC2:AC3')  # 最终成绩
        

        # 填充数据
        row_num = 4
        for score in scores.order_by('student__employee_id', 'student__username'):
            # 确保重新计算成绩（包括usual_entry和final_entry）
            score.calculate_grade()
            
            # 确保计算了课程目标达成度
            achievements = CourseObjectiveAchievement.objects.filter(score=score).order_by('objective_number')
            if not achievements.exists():
                ObjectiveCalculator.save_objective_achievements(score)
                achievements = CourseObjectiveAchievement.objects.filter(score=score).order_by('objective_number')
            
            obj1 = achievements.filter(objective_number=1).first()
            obj2 = achievements.filter(objective_number=2).first()
            obj3 = achievements.filter(objective_number=3).first()

            # 获取成绩数据
            attendance = score.attendance_score or 0
            e_notes = score.extra_scores.get('电子笔记', 0) or 0
            homework = score.homework_score or 0
            experiment = score.experiment_score or 0
            work = score.extra_scores.get('作品', 0) or 0
            report = score.extra_scores.get('报告', 0) or 0

            # 计算平时成绩和期末平均（取整数）
            usual_total = round(score.usual_total) if score.usual_total is not None else 0
            final_total = int(score.final_total) if score.final_total is not None else 0  # 期末平均直接取整，不四舍五入
            
            # 计算总分值 = 课程目标1达成情况 + 课程目标2达成情况 + 课程目标3达成情况
            total_score = (obj1.achievement_score if obj1 else 0) + (obj2.achievement_score if obj2 else 0) + (obj3.achievement_score if obj3 else 0)
            
            # 使用计算后的值
            usual_entry = score.usual_entry if score.usual_entry is not None else 0
            final_entry = score.final_entry if score.final_entry is not None else 0

            # 填充数据（严格按照表头列顺序）
            # 填充数据（严格按照表头第三行的列顺序，共29列）
            # 表头第三行：'', '', '点名', '电子笔记', '作业成绩', '', '', '作品', '报告', '期末平均',
            #            '平时', '实验', '期末', '达成情况', '达成度', (课程目标1)
            #            '平时', '实验', '期末', '达成情况', '达成度', (课程目标2)
            #            '平时', '实验', '期末', '达成情况', '达成度', '', '', '', '' (课程目标3)
            data_row = [
                '',  # A1: 空（学号在第二行）
                '',  # B2: 空（姓名在第二行）
                attendance,  # C3: 点名
                e_notes,  # D4: 电子笔记
                homework,  # E5: 作业成绩
                '',  # F6: 空（平时成绩在第二行）
                '',  # G7: 空（实验在第二行）
                work,  # H8: 作品
                report,  # I9: 报告
                final_total,  # J10: 期末平均（整数，在报告右侧）
                # 课程目标1（K11-O15）
                round(obj1.usual_score, 2) if obj1 else 0.00,  # K11: 平时
                round(obj1.experiment_score, 2) if obj1 else 0.00,  # L12: 实验
                round(obj1.final_score, 2) if obj1 else 0.00,  # M13: 期末
                round(obj1.achievement_score, 2) if obj1 else 0.00,  # N14: 达成情况
                round(obj1.achievement_degree, 2) if obj1 else 0.00,  # O15: 达成度
                # 课程目标2（P16-T20）
                round(obj2.usual_score, 2) if obj2 else 0.00,  # P16: 平时
                round(obj2.experiment_score, 2) if obj2 else 0.00,  # Q17: 实验
                round(obj2.final_score, 2) if obj2 else 0.00,  # R18: 期末
                round(obj2.achievement_score, 2) if obj2 else 0.00,  # S19: 达成情况
                round(obj2.achievement_degree, 2) if obj2 else 0.00,  # T20: 达成度
                # 课程目标3（U21-Y25）
                round(obj3.usual_score, 2) if obj3 else 0.00,  # U21: 平时
                round(obj3.experiment_score, 2) if obj3 else 0.00,  # V22: 实验
                round(obj3.final_score, 2) if obj3 else 0.00,  # W23: 期末
                round(obj3.achievement_score, 2) if obj3 else 0.00,  # X24: 达成情况
                round(obj3.achievement_degree, 2) if obj3 else 0.00,  # Y25: 达成度
                '',  # Z26: 空（总分值在第二行）
                '',  # AA27: 空（平时录入在第二行）
                '',  # AB28: 空（期末录入在第二行）
                '',  # AC29: 空（最终成绩在第二行）
            ]

            # 先填充第三行对应的数据（data_row）
            for col_idx, value in enumerate(data_row, 1):
                cell = ws.cell(row=row_num, column=col_idx, value=value)
                cell.alignment = center_align
                cell.border = border
            
            # 再单独填充第二行合并单元格对应的值（这些列在第三行是空的）
            ws.cell(row=row_num, column=1, value=score.student.employee_id or score.student.username).alignment = center_align
            ws.cell(row=row_num, column=1).border = border
            ws.cell(row=row_num, column=2, value=score.student.first_name or score.student.username).alignment = center_align
            ws.cell(row=row_num, column=2).border = border
            ws.cell(row=row_num, column=6, value=usual_total).alignment = center_align
            ws.cell(row=row_num, column=6).border = border
            ws.cell(row=row_num, column=7, value=experiment).alignment = center_align
            ws.cell(row=row_num, column=7).border = border
            ws.cell(row=row_num, column=26, value=round(total_score, 2)).alignment = center_align
            ws.cell(row=row_num, column=26).border = border
            ws.cell(row=row_num, column=27, value=int(usual_entry) if usual_entry is not None else 0).alignment = center_align
            ws.cell(row=row_num, column=27).border = border
            ws.cell(row=row_num, column=28, value=int(final_entry) if final_entry is not None else 0).alignment = center_align
            ws.cell(row=row_num, column=28).border = border
            ws.cell(row=row_num, column=29, value=int(score.final_grade) if score.final_grade is not None else 0).alignment = center_align
            ws.cell(row=row_num, column=29).border = border

            row_num += 1

        # 在表格最下面添加达成度计算表
        stats_start_row = row_num + 2  # 空一行
        
        # 标题行："达成度计算"居中放在表头正上方
        title_cell = ws.cell(row=stats_start_row, column=2, value='达成度计算')
        title_cell.font = header_font
        title_cell.alignment = center_align
        ws.merge_cells(f'B{stats_start_row}:D{stats_start_row}')  # 合并B、C、D列，居中显示
        
        # 表头行（在标题下方）
        header_row = stats_start_row + 1
        ws.cell(row=header_row, column=2, value='课程目标').font = header_font
        ws.cell(row=header_row, column=2).alignment = center_align
        ws.cell(row=header_row, column=2).border = border
        ws.cell(row=header_row, column=3, value='达成分值').font = header_font
        ws.cell(row=header_row, column=3).alignment = center_align
        ws.cell(row=header_row, column=3).border = border
        ws.cell(row=header_row, column=4, value='达成度').font = header_font
        ws.cell(row=header_row, column=4).alignment = center_align
        ws.cell(row=header_row, column=4).border = border
        
        # 计算班级平均达成度（与前端计算方式一致）
        # 计算每个课程目标的平均达成度和达成分值
        obj1_scores = []
        obj1_degrees = []
        obj2_scores = []
        obj2_degrees = []
        obj3_scores = []
        obj3_degrees = []
        
        for score in scores:
            achievements = CourseObjectiveAchievement.objects.filter(score=score).order_by('objective_number')
            obj1 = achievements.filter(objective_number=1).first()
            obj2 = achievements.filter(objective_number=2).first()
            obj3 = achievements.filter(objective_number=3).first()
            
            if obj1:
                obj1_scores.append(obj1.achievement_score)
                obj1_degrees.append(obj1.achievement_degree)
            if obj2:
                obj2_scores.append(obj2.achievement_score)
                obj2_degrees.append(obj2.achievement_degree)
            if obj3:
                obj3_scores.append(obj3.achievement_score)
                obj3_degrees.append(obj3.achievement_degree)
        
        # 计算平均值（保留两位小数）
        obj1_avg_score = round(sum(obj1_scores) / len(obj1_scores), 2) if obj1_scores else 0.00
        obj1_avg_degree = round(sum(obj1_degrees) / len(obj1_degrees), 2) if obj1_degrees else 0.00  # 不乘以100，保持小数格式
        obj2_avg_score = round(sum(obj2_scores) / len(obj2_scores), 2) if obj2_scores else 0.00
        obj2_avg_degree = round(sum(obj2_degrees) / len(obj2_degrees), 2) if obj2_degrees else 0.00  # 不乘以100，保持小数格式
        obj3_avg_score = round(sum(obj3_scores) / len(obj3_scores), 2) if obj3_scores else 0.00
        obj3_avg_degree = round(sum(obj3_degrees) / len(obj3_degrees), 2) if obj3_degrees else 0.00  # 不乘以100，保持小数格式
        
        # 填充达成度计算数据（与前端界面一致：达成分值保留两位小数，达成度保留两位小数，不显示百分号）
        stats_data = [
            ('课程目标1', obj1_avg_score, obj1_avg_degree),
            ('课程目标2', obj2_avg_score, obj2_avg_degree),
            ('课程目标3', obj3_avg_score, obj3_avg_degree),
        ]
        
        for idx, (objective, score, degree) in enumerate(stats_data, 1):
            row = header_row + idx
            ws.cell(row=row, column=1, value='').border = border
            ws.cell(row=row, column=2, value=objective).border = border
            ws.cell(row=row, column=2).alignment = center_align
            ws.cell(row=row, column=3, value=score).border = border
            ws.cell(row=row, column=3).alignment = center_align
            ws.cell(row=row, column=4, value=degree).border = border  # 不添加%符号，直接显示小数
            ws.cell(row=row, column=4).alignment = center_align

        # 设置列宽
        column_widths = {
            'A': 15, 'B': 10, 'C': 8, 'D': 10, 'E': 10, 'F': 10, 'G': 8,
            'H': 8, 'I': 8, 'J': 10, 'K': 5,
            'L': 8, 'M': 8, 'N': 8, 'O': 10, 'P': 10,
            'Q': 8, 'R': 8, 'S': 8, 'T': 10, 'U': 10,
            'V': 8, 'W': 8, 'X': 8, 'Y': 10, 'Z': 10,
            'AA': 10, 'AB': 10, 'AC': 10, 'AD': 10
        }
        for col, width in column_widths.items():
            ws.column_dimensions[col].width = width

        # 保存到BytesIO
        output = BytesIO()
        wb.save(output)
        output.seek(0)

        response = HttpResponse(
            output.read(),
            content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        )
        filename = f"{course_class.course.course_name}_{course_class.class_name}_达成度计算.xlsx"
        response['Content-Disposition'] = f'attachment; filename="{filename}"'
        return response


class ScoreImportLogViewSet(viewsets.ReadOnlyModelViewSet):
    """成绩导入日志视图集"""
    permission_classes = [IsAuthenticated, IsTeacherOrAdmin]
    queryset = ScoreImportLog.objects.all()
    serializer_class = ScoreImportLogSerializer

    def get_queryset(self):
        queryset = super().get_queryset()
        user = self.request.user

        if user.user_type == 'teacher':
            queryset = queryset.filter(
                Q(course_class__main_teacher=user) |
                Q(course_class__assistant_teachers=user) |
                Q(imported_by=user)
            ).distinct()

        return queryset.select_related('course_class', 'course_class__course', 'imported_by')


class ScoreAdjustmentViewSet(viewsets.ModelViewSet):
    """成绩调整记录视图集"""
    permission_classes = [IsAuthenticated, IsTeacherOrAdmin]
    queryset = ScoreAdjustment.objects.all()
    serializer_class = ScoreAdjustmentSerializer

    def get_queryset(self):
        queryset = super().get_queryset()
        user = self.request.user

        if user.user_type == 'teacher':
            queryset = queryset.filter(
                Q(score__course_class__main_teacher=user) |
                Q(score__course_class__assistant_teachers=user)
            ).distinct()

        return queryset.select_related('score', 'score__student', 'adjusted_by', 'approved_by')

    def perform_create(self, serializer):
        serializer.save(adjusted_by=self.request.user)


class GradebookViewSet(viewsets.ModelViewSet):
    """记分册视图集"""
    permission_classes = [IsAuthenticated, IsTeacherOrAdmin]
    queryset = Gradebook.objects.all()

    def get_serializer_class(self):
        if self.action == 'create':
            return GradebookCreateSerializer
        return GradebookSerializer

    def get_queryset(self):
        """根据用户权限过滤查询集"""
        queryset = super().get_queryset()
        user = self.request.user
        course_class_id = self.request.query_params.get('course_class_id')

        logger.info(f"Gradebook查询 - 用户: {user.username}, 类型: {user.user_type}, course_class_id: {course_class_id}")

        # 处理course_class_id参数（可能是字符串）
        if course_class_id:
            try:
                course_class_id = int(course_class_id)
                queryset = queryset.filter(course_class_id=course_class_id)
                logger.info(f"过滤course_class_id={course_class_id}后，查询集数量: {queryset.count()}")
            except (ValueError, TypeError):
                logger.warning(f"无效的course_class_id: {course_class_id}")

        # 权限过滤
        if user.user_type == 'student':
            queryset = queryset.filter(student=user)
            logger.info(f"学生权限过滤后，查询集数量: {queryset.count()}")
        elif user.user_type == 'teacher':
            # 教师只能查看自己作为主讲教师或助教的班级的记分册
            queryset = queryset.filter(
                Q(course_class__main_teacher=user) |
                Q(course_class__assistant_teachers=user)
            ).distinct()
            logger.info(f"教师权限过滤后，查询集数量: {queryset.count()}")

        result = queryset.select_related('student', 'course_class', 'course_class__course').order_by('student__username')
        logger.info(f"最终查询集数量: {result.count()}")
        return result

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user, updated_by=self.request.user)

    def perform_update(self, serializer):
        serializer.save(updated_by=self.request.user)

    @action(detail=False, methods=['post'], url_path='import-excel')
    def import_excel(self, request):
        """导入记分册Excel"""
        from apps.scores.excel_handlers import GradebookExcelHandler

        serializer = ExcelUploadSerializer(data=request.data)
        if not serializer.is_valid():
            logger.error(f"导入记分册验证失败: {serializer.errors}")
            return Response({
                'success': False,
                'message': '数据验证失败',
                'errors': serializer.errors,
            }, status=status.HTTP_400_BAD_REQUEST)

        file = serializer.validated_data['file']
        course_class_id = serializer.validated_data['course_class_id']

        try:
            handler = GradebookExcelHandler()
            result = handler.parse_excel(file, course_class_id)

            logger.info(f"Excel解析结果: success={result.get('success')}, data_count={len(result.get('data', []))}, errors_count={len(result.get('errors', []))}")

            if not result['success']:
                return Response({
                    'success': False,
                    'message': 'Excel解析失败',
                    'errors': result['errors'],
                }, status=status.HTTP_400_BAD_REQUEST)

            # 检查是否有数据
            if not result.get('data') or len(result['data']) == 0:
                logger.warning("Excel解析成功但没有数据")
                return Response({
                    'success': False,
                    'message': 'Excel解析成功但没有找到有效数据',
                    'errors': result.get('errors', []) + ['未找到有效的数据行，请检查Excel文件格式'],
                }, status=status.HTTP_400_BAD_REQUEST)

            # 创建导入日志
            import_log = ScoreImportLog.objects.create(
                file_name=file.name,
                file_path='',
                course_class_id=course_class_id,
                imported_by=request.user,
                total_rows=len(result['data']),
                column_mapping=result.get('column_mapping', {}),
                status='processing'
            )

            # 导入数据
            logger.info(f"开始导入 {len(result['data'])} 条数据")
            import_result = handler.import_gradebooks(
                result['data'],
                course_class_id,
                request.user.id
            )
            logger.info(f"导入完成: 成功 {import_result['success']} 条, 失败 {import_result['failed']} 条")

            # 更新导入日志
            import_log.success_rows = import_result['success']
            import_log.failed_rows = import_result['failed']
            import_log.error_log = '\n'.join(import_result['errors'])
            import_log.status = 'completed' if import_result['failed'] == 0 else 'partial'
            import_log.completed_at = timezone.now()
            import_log.save()

            return Response({
                'success': True,
                'message': f'导入完成：成功 {import_result["success"]} 条，失败 {import_result["failed"]} 条',
                'data': {
                    'success_count': import_result['success'],
                    'failed_count': import_result['failed'],
                    'errors': import_result['errors'][:10],
                },
                'import_log_id': import_log.id,
            })

        except Exception as e:
            logger.error(f"导入记分册失败: {str(e)}", exc_info=True)
            return Response({
                'success': False,
                'message': f'导入失败: {str(e)}',
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @action(detail=False, methods=['get'], url_path='export-excel')
    def export_excel(self, request):
        """导出记分册Excel"""
        from openpyxl import Workbook
        from openpyxl.styles import Font, Alignment, Border, Side
        from io import BytesIO

        course_class_id = request.query_params.get('course_class_id')
        if not course_class_id:
            return Response({'error': '请提供课程班级ID'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            course_class = CourseClass.objects.select_related('course').get(id=course_class_id)
            gradebooks = self.get_queryset().filter(course_class_id=course_class_id).order_by('student__username')

            wb = Workbook()
            ws = wb.active
            ws.title = '记分册'

            # 设置标题
            ws.merge_cells('A1:Q1')
            ws['A1'] = f'{course_class.course.course_name} - {course_class.class_name} 记分册'
            ws['A1'].font = Font(size=16, bold=True)
            ws['A1'].alignment = Alignment(horizontal='center', vertical='center')

            # 表头
            headers = [
                '学号', '姓名',
                '作业1', '作业2', '作业3', '作业4', '作业5',
                '实验1', '实验2',
                '考勤1', '考勤2', '考勤3', '考勤4', '考勤5',
                '复习笔记', '期末成绩', '平时', '期末', '总评'
            ]
            for col, header in enumerate(headers, 1):
                cell = ws.cell(row=2, column=col, value=header)
                cell.font = Font(bold=True)
                cell.alignment = Alignment(horizontal='center', vertical='center')

            # 数据行
            for row_idx, gradebook in enumerate(gradebooks, 3):
                try:
                    student_id = gradebook.student.student_profile.student_id
                except:
                    student_id = gradebook.student.employee_id or gradebook.student.username

                row_data = [
                    student_id,
                    gradebook.student.first_name or '',
                    gradebook.homework1 or '',
                    gradebook.homework2 or '',
                    gradebook.homework3 or '',
                    gradebook.homework4 or '',
                    gradebook.homework5 or '',
                    gradebook.experiment1 or '',
                    gradebook.experiment2 or '',
                    gradebook.attendance1 or '',
                    gradebook.attendance2 or '',
                    gradebook.attendance3 or '',
                    gradebook.attendance4 or '',
                    gradebook.attendance5 or '',
                    gradebook.review_note or '',
                    gradebook.final_score or '',
                    round(gradebook.usual_score) if gradebook.usual_score is not None else '',
                    gradebook.final_score or '',
                    round(gradebook.total_score) if gradebook.total_score is not None else '',
                ]
                for col, value in enumerate(row_data, 1):
                    ws.cell(row=row_idx, column=col, value=value)

            # 设置列宽
            column_widths = [15, 10, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 10, 8, 8, 8]
            for col, width in enumerate(column_widths, 1):
                ws.column_dimensions[chr(64 + col)].width = width

            # 保存到BytesIO
            output = BytesIO()
            wb.save(output)
            output.seek(0)

            response = HttpResponse(
                output.read(),
                content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
            )
            filename = f"{course_class.course.course_name}_{course_class.class_name}_记分册.xlsx"
            response['Content-Disposition'] = f'attachment; filename="{filename}"'
            return response

        except CourseClass.DoesNotExist:
            return Response({'error': '课程班级不存在'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            logger.error(f"导出记分册失败: {str(e)}", exc_info=True)
            return Response({'error': f'导出失败: {str(e)}'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class AlgorithmScoreViewSet(viewsets.ModelViewSet):
    """算法分析与设计成绩视图集"""
    permission_classes = [IsAuthenticated, IsTeacherOrAdmin]
    queryset = AlgorithmScore.objects.all()
    serializer_class = AlgorithmScoreSerializer

    def get_queryset(self):
        """根据用户权限过滤查询集"""
        queryset = super().get_queryset()
        user = self.request.user
        course_class_id = self.request.query_params.get('course_class_id')

        if course_class_id:
            queryset = queryset.filter(course_class_id=course_class_id)
            logger.info(f"get_queryset: 过滤course_class_id={course_class_id}, 过滤前数量={queryset.count()}")

        if user.user_type == 'student':
            queryset = queryset.filter(student=user)
            logger.info(f"get_queryset: 学生过滤后数量={queryset.count()}")
        elif user.user_type == 'teacher':
            # 教师只能查看自己作为主讲教师或助教的班级的算法成绩
            # 注意：新注册的用户需要通过创建/导入班级来关联数据
            queryset = queryset.filter(
                Q(course_class__main_teacher=user) |
                Q(course_class__assistant_teachers=user)
            ).distinct()
            logger.info(f"get_queryset: 教师过滤后数量={queryset.count()}, user_id={user.id}")

        # 使用select_related优化查询
        # gradebook是一对一关系，使用select_related，即使不存在也不会报错
        queryset = queryset.select_related(
            'student', 
            'gradebook', 
            'course_class', 
            'course_class__course'
        )
        final_count = queryset.count()
        logger.info(f"get_queryset: 最终查询结果数量={final_count}")
        return queryset.order_by('student__username', 'student__employee_id')

    def list(self, request, *args, **kwargs):
        """列表查询，添加错误处理"""
        try:
            course_class_id = request.query_params.get('course_class_id')
            logger.info(f"AlgorithmScore list请求: course_class_id={course_class_id}, user={request.user.id}")
            
            # 如果有course_class_id，检查是否存在记分册但没有AlgorithmScore的记录，自动创建
            if course_class_id:
                try:
                    from apps.scores.models import Gradebook
                    from apps.courses.models import CourseClass
                    
                    course_class = CourseClass.objects.select_related('course').get(id=course_class_id)
                    course_name = course_class.course.course_name if course_class.course else ''
                    logger.info(f"课程名称: {course_name}, course_class_id={course_class_id}")
                    
                    # 移除课程名称限制，只要有course_class_id就处理
                    # 因为导入时已经指定了course_class_id，说明用户知道这是算法课程
                    # 查找所有有记分册的学生
                    gradebooks = Gradebook.objects.filter(
                        course_class_id=course_class_id
                    ).select_related('student', 'created_by', 'updated_by')
                    logger.info(f"找到 {gradebooks.count()} 条记分册记录")
                    
                    # 获取所有已有AlgorithmScore的学生ID
                    existing_student_ids = set(
                        AlgorithmScore.objects.filter(
                            course_class_id=course_class_id
                        ).values_list('student_id', flat=True)
                    )
                    logger.info(f"已有 {len(existing_student_ids)} 条AlgorithmScore记录")
                    
                    # 为缺失的记录创建AlgorithmScore
                    created_count = 0
                    for gradebook in gradebooks:
                        if gradebook.student_id not in existing_student_ids:
                            try:
                                algorithm_score, created = AlgorithmScore.objects.get_or_create(
                                    student=gradebook.student,
                                    course_class=gradebook.course_class,
                                    defaults={
                                        'gradebook': gradebook,
                                        'created_by': gradebook.created_by if gradebook.created_by else request.user,
                                        'updated_by': gradebook.updated_by if gradebook.updated_by else request.user
                                    }
                                )
                                if created:
                                    # 重新计算所有成绩（从记分册计算平时成绩部分）
                                    algorithm_score.calculate_all()
                                    algorithm_score.save()
                                    logger.info(f"自动创建AlgorithmScore记录: student={gradebook.student.id}, gradebook={gradebook.id}")
                                    created_count += 1
                                else:
                                    # 如果已存在，更新gradebook引用（以防万一）
                                    if algorithm_score.gradebook_id != gradebook.id:
                                        algorithm_score.gradebook = gradebook
                                        algorithm_score.calculate_all()
                                        algorithm_score.save()
                            except Exception as e:
                                logger.warning(f"自动创建AlgorithmScore失败: student={gradebook.student.id}, error={str(e)}", exc_info=True)
                    
                    if created_count > 0:
                        logger.info(f"自动创建了 {created_count} 条AlgorithmScore记录")
                    
                    # 检查是否有已导入的卷面成绩数据
                    existing_scores = AlgorithmScore.objects.filter(
                        course_class_id=course_class_id
                    ).exclude(raw_paper_scores__isnull=True).exclude(raw_paper_scores={})
                    logger.info(f"已导入卷面成绩的记录数: {existing_scores.count()}")
                    if existing_scores.count() > 0:
                        logger.info(f"示例记录: student_id={existing_scores.first().student_id}, raw_paper_scores={existing_scores.first().raw_paper_scores}")
                except CourseClass.DoesNotExist:
                    logger.warning(f"课程班级不存在: course_class_id={course_class_id}")
                    pass
                except Exception as e:
                    logger.warning(f"检查并创建AlgorithmScore记录时出错: {str(e)}", exc_info=True)
            
            # 获取过滤后的查询集
            queryset = self.filter_queryset(self.get_queryset())
            logger.info(f"AlgorithmScore查询: course_class_id={course_class_id}, 查询结果数量={queryset.count()}")
            
            # 检查查询结果中是否有raw_paper_scores
            if queryset.count() > 0:
                sample = queryset.first()
                logger.info(f"示例查询结果: student_id={sample.student_id if hasattr(sample, 'student_id') else 'N/A'}, has_raw_paper_scores={bool(sample.raw_paper_scores) if hasattr(sample, 'raw_paper_scores') else 'N/A'}")
            
            # 尝试分页，如果没有配置分页器则返回所有数据
            page = self.paginate_queryset(queryset)
            if page is not None:
                serializer = self.get_serializer(page, many=True)
                logger.info(f"AlgorithmScore分页返回: {len(serializer.data)} 条数据")
                return self.get_paginated_response(serializer.data)

            # 如果没有配置分页，返回所有数据
            serializer = self.get_serializer(queryset, many=True)
            logger.info(f"AlgorithmScore非分页返回: {len(serializer.data)} 条数据")
            return Response({
                'count': queryset.count(),
                'next': None,
                'previous': None,
                'results': serializer.data
            })
        except Exception as e:
            logger.error(f"获取算法分析与设计成绩列表失败: {str(e)}", exc_info=True)
            import traceback
            logger.error(traceback.format_exc())
            return Response({
                'error': f'获取成绩列表失败: {str(e)}',
                'detail': str(e),
                'count': 0,
                'results': []
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user, updated_by=self.request.user)

    def perform_update(self, serializer):
        serializer.save(updated_by=self.request.user)

    @action(detail=False, methods=['post'], url_path='preview-final-paper')
    def preview_final_paper(self, request):
        """预览卷面成绩Excel（不导入，只解析显示）"""
        from apps.scores.excel_handlers import FinalPaperExcelHandler

        serializer = ExcelUploadSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({
                'success': False,
                'message': '数据验证失败',
                'errors': serializer.errors,
            }, status=status.HTTP_400_BAD_REQUEST)

        file = serializer.validated_data['file']
        course_class_id = serializer.validated_data.get('course_class_id')

        try:
            handler = FinalPaperExcelHandler()
            result = handler.parse_excel(file, course_class_id)

            if not result['success']:
                return Response({
                    'success': False,
                    'message': 'Excel解析失败',
                    'errors': result['errors'],
                    'data': [],
                    'question_structure': {},
                }, status=status.HTTP_400_BAD_REQUEST)

            return Response({
                'success': True,
                'message': f'解析成功，共 {len(result.get("data", []))} 条数据',
                'data': result.get('data', []),
                'question_structure': result.get('question_structure', {}),
                'errors': result.get('errors', []),
            })

        except Exception as e:
            logger.error(f"预览卷面成绩失败: {str(e)}", exc_info=True)
            return Response({
                'success': False,
                'message': f'预览失败: {str(e)}',
                'data': [],
                'question_structure': {},
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @action(detail=False, methods=['post'], url_path='import-final-paper')
    def import_final_paper(self, request):
        """导入卷面成绩Excel"""
        from apps.scores.excel_handlers import FinalPaperExcelHandler

        serializer = ExcelUploadSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({
                'success': False,
                'message': '数据验证失败',
                'errors': serializer.errors,
            }, status=status.HTTP_400_BAD_REQUEST)

        file = serializer.validated_data['file']
        course_class_id = serializer.validated_data['course_class_id']

        try:
            handler = FinalPaperExcelHandler()
            result = handler.parse_excel(file, course_class_id)

            if not result['success']:
                return Response({
                    'success': False,
                    'message': 'Excel解析失败',
                    'errors': result['errors'],
                }, status=status.HTTP_400_BAD_REQUEST)

            if not result.get('data') or len(result['data']) == 0:
                return Response({
                    'success': False,
                    'message': 'Excel解析成功但没有找到有效数据',
                    'errors': result.get('errors', []) + ['未找到有效的数据行，请检查Excel文件格式'],
                }, status=status.HTTP_400_BAD_REQUEST)

            # 导入数据（只保存原始数据，不计算M1-M4）
            import_result = handler.import_final_paper_scores(
                result['data'],
                course_class_id,
                request.user.id
            )

            return Response({
                'success': True,
                'message': f'导入完成：成功 {import_result["success"]} 条，失败 {import_result["failed"]} 条。请到步骤3点击"重新计算"生成最终成绩。',
                'data': {
                    'success_count': import_result['success'],
                    'failed_count': import_result['failed'],
                    'errors': import_result['errors'][:10],
                },
            })

        except Exception as e:
            logger.error(f"导入卷面成绩失败: {str(e)}", exc_info=True)
            return Response({
                'success': False,
                'message': f'导入失败: {str(e)}',
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @action(detail=False, methods=['post'], url_path='recalculate')
    def recalculate(self, request):
        """重新计算算法分析与设计成绩（整合记分册和卷面成绩）"""
        course_class_id = request.data.get('course_class_id')
        if not course_class_id:
            return Response({'error': '请提供course_class_id'}, status=status.HTTP_400_BAD_REQUEST)

        # 获取M列配置（前端传递）
        m_config_raw = request.data.get('m_config', {})
        logger.info(f"=== 重新计算开始 ===")
        logger.info(f"接收到M列配置（原始）: {m_config_raw}, 类型: {type(m_config_raw)}")
        logger.info(f"request.data完整内容: {request.data}")
        
        # 如果没有配置或配置为空，使用默认配置
        if not m_config_raw or not isinstance(m_config_raw, dict) or len(m_config_raw) == 0:
            m_config = {
                'M1': ['一-total', '三-1'],
                'M2': ['二-2', '二-3'],
                'M3': ['二-1', '三-2', '三-3'],
                'M4': ['四-total']
            }
            logger.warning(f"配置为空或无效，使用默认M列配置: {m_config}")
        else:
            m_config = {}
            # 确保配置格式正确：每个M的值应该是列表
            for key in ['M1', 'M2', 'M3', 'M4']:
                if key not in m_config_raw:
                    logger.warning(f"配置中缺少{key}，使用默认值")
                    default_configs = {
                        'M1': ['一-total', '三-1'],
                        'M2': ['二-2', '二-3'],
                        'M3': ['二-1', '三-2', '三-3'],
                        'M4': ['四-total']
                    }
                    m_config[key] = default_configs.get(key, [])
                elif not isinstance(m_config_raw[key], list):
                    logger.warning(f"配置中{key}格式不正确（不是列表，是{type(m_config_raw[key])}），使用默认值")
                    default_configs = {
                        'M1': ['一-total', '三-1'],
                        'M2': ['二-2', '二-3'],
                        'M3': ['二-1', '三-2', '三-3'],
                        'M4': ['四-total']
                    }
                    m_config[key] = default_configs.get(key, [])
                else:
                    m_config[key] = m_config_raw[key]
                    logger.info(f"配置中{key}有效: {m_config[key]} (类型: {type(m_config[key])}, 长度: {len(m_config[key])})")
        
        logger.info(f"最终使用的M列配置: {m_config}")
        
        # 打印配置详情，确保每个M列的配置都正确
        logger.info(f"M1配置: {m_config.get('M1', [])}, 类型: {type(m_config.get('M1', []))}")
        logger.info(f"M2配置: {m_config.get('M2', [])}, 类型: {type(m_config.get('M2', []))}")
        logger.info(f"M3配置: {m_config.get('M3', [])}, 类型: {type(m_config.get('M3', []))}")
        logger.info(f"M4配置: {m_config.get('M4', [])}, 类型: {type(m_config.get('M4', []))}")

        try:
            queryset = self.get_queryset().filter(course_class_id=course_class_id)
            updated_count = 0
            
            for algorithm_score in queryset:
                try:
                    # 重新计算所有成绩，传入M列配置
                    logger.info(f"重新计算成绩 {algorithm_score.id} (student_id={algorithm_score.student_id})，使用配置: {m_config}")
                    # 确保配置正确传递
                    if m_config:
                        logger.info(f"传递给calculate_all的配置: {m_config}")
                        # 将配置保存到实例变量中，供save()方法使用
                        algorithm_score._saved_m_config = m_config
                    algorithm_score.calculate_all(m_config=m_config)
                    # 保存前记录M值
                    logger.info(f"保存前 - M1={algorithm_score.M1}, M2={algorithm_score.M2}, M3={algorithm_score.M3}, M4={algorithm_score.M4}")
                    # 保存时跳过M值的自动计算（因为已经手动计算过了）
                    algorithm_score.save(skip_m_calculation=True)
                    # 清除临时配置
                    if hasattr(algorithm_score, '_saved_m_config'):
                        delattr(algorithm_score, '_saved_m_config')
                    # 保存后再次读取，确保保存成功
                    algorithm_score.refresh_from_db()
                    logger.info(f"保存后 - M1={algorithm_score.M1}, M2={algorithm_score.M2}, M3={algorithm_score.M3}, M4={algorithm_score.M4}")
                    updated_count += 1
                except Exception as e:
                    logger.error(f"重新计算成绩失败 {algorithm_score.id}: {str(e)}", exc_info=True)
            
            return Response({
                'message': f'成功重新计算 {updated_count} 条成绩记录',
                'updated_count': updated_count
            })
        except Exception as e:
            logger.error(f"批量重新计算失败: {str(e)}")
            return Response({'error': f'批量重新计算失败: {str(e)}'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @action(detail=False, methods=['get'], url_path='classes-with-scores')
    def classes_with_scores(self, request):
        """获取有算法成绩的班级列表"""
        from apps.courses.models import CourseClass
        from django.db.models import Q
        
        # 获取有算法成绩的班级（算法分析与设计课程）
        queryset = CourseClass.objects.filter(
            algorithm_scores__isnull=False,
            course__course_name__in=['算法分析与设计', '算法设计与分析']
        ).distinct().select_related('course', 'main_teacher')
        
        # 根据用户权限过滤
        user = request.user
        if user.user_type == 'teacher':
            queryset = queryset.filter(
                Q(main_teacher=user) |
                Q(assistant_teachers=user) |
                Q(course__teachers=user)
            ).distinct()
        
        # 统计每个班级的成绩数量和学生数量
        classes_data = []
        for course_class in queryset:
            score_count = AlgorithmScore.objects.filter(course_class=course_class).count()
            students_count = course_class.enrollment_set.filter(is_active=True).count()
            classes_data.append({
                'id': course_class.id,
                'course_code': course_class.course.course_code,
                'course_name': course_class.course.course_name,
                'class_name': course_class.class_name,
                'main_teacher_name': course_class.main_teacher.first_name if course_class.main_teacher else '',
                'score_count': score_count,
                'students_count': students_count
            })
        
        return Response({
            'results': classes_data,
            'count': len(classes_data)
        })

    @action(detail=False, methods=['get'], url_path='export-excel')
    def export_excel(self, request):
        """导出算法分析与设计成绩Excel（包含所有列和达成度计算）"""
        from io import BytesIO
        from openpyxl import Workbook
        from openpyxl.styles import Font, Alignment, Border, Side
        from apps.courses.models import CourseClass

        course_class_id = request.query_params.get('course_class_id')
        if not course_class_id:
            return Response({'error': '请提供course_class_id'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            course_class = CourseClass.objects.select_related('course').get(id=course_class_id)
        except CourseClass.DoesNotExist:
            return Response({'error': '课程班级不存在'}, status=status.HTTP_404_NOT_FOUND)

        # 获取成绩数据
        scores = self.get_queryset().filter(course_class_id=course_class_id).select_related(
            'student', 'gradebook', 'course_class', 'course_class__course'
        ).order_by('student__employee_id', 'student__username')

        if not scores.exists():
            return Response({'error': '该班级没有成绩数据'}, status=status.HTTP_400_BAD_REQUEST)

        # 创建Workbook
        wb = Workbook()
        ws = wb.active
        ws.title = course_class.class_name

        # 设置样式
        header_font = Font(bold=True, size=11)
        center_align = Alignment(horizontal='center', vertical='center')
        border = Border(
            left=Side(style='thin'),
            right=Side(style='thin'),
            top=Side(style='thin'),
            bottom=Side(style='thin')
        )

        # 第一行：基本信息
        ws.merge_cells('A1:B1')
        cell_a1 = ws.cell(row=1, column=1, value='院系专业')
        cell_a1.font = header_font
        cell_a1.alignment = center_align
        
        ws.merge_cells('C1:E1')
        cell_c1 = ws.cell(row=1, column=3, value=course_class.course.department or '计算机学院')
        cell_c1.alignment = center_align
        
        ws.merge_cells('F1:J1')
        cell_f1 = ws.cell(row=1, column=6, value='课程名称：' + course_class.course.course_name)
        cell_f1.font = header_font
        cell_f1.alignment = center_align
        
        ws.merge_cells('K1:O1')
        cell_k1 = ws.cell(row=1, column=11, value='专业班级：' + course_class.class_name)
        cell_k1.alignment = center_align

        # 第二行：表头（合并单元格的标题）
        # 学号、姓名
        ws.cell(row=2, column=1, value='学号').font = header_font
        ws.cell(row=2, column=1).alignment = center_align
        ws.cell(row=2, column=1).border = border
        ws.cell(row=2, column=2, value='姓名').font = header_font
        ws.cell(row=2, column=2).alignment = center_align
        ws.cell(row=2, column=2).border = border
        
        # 平时（合并C2:F2，包含课堂表现、笔记、作业、实验）
        ws.cell(row=2, column=3, value='平时').font = header_font
        ws.cell(row=2, column=3).alignment = center_align
        ws.cell(row=2, column=3).border = border
        ws.merge_cells('C2:F2')
        
        # 平时成绩（G2）
        ws.cell(row=2, column=7, value='平时成绩').font = header_font
        ws.cell(row=2, column=7).alignment = center_align
        ws.cell(row=2, column=7).border = border
        
        # 期末（合并H2:L2，包含M1/35、M2/20、M3/35、M4/10、卷面）
        ws.cell(row=2, column=8, value='期末').font = header_font
        ws.cell(row=2, column=8).alignment = center_align
        ws.cell(row=2, column=8).border = border
        ws.merge_cells('H2:L2')
        
        # 课程目标1-4（每个合并7列）
        ws.cell(row=2, column=13, value='课程目标1').font = header_font
        ws.cell(row=2, column=13).alignment = center_align
        ws.cell(row=2, column=13).border = border
        ws.merge_cells('M2:S2')
        
        ws.cell(row=2, column=20, value='课程目标2').font = header_font
        ws.cell(row=2, column=20).alignment = center_align
        ws.cell(row=2, column=20).border = border
        ws.merge_cells('T2:Z2')
        
        ws.cell(row=2, column=27, value='课程目标3').font = header_font
        ws.cell(row=2, column=27).alignment = center_align
        ws.cell(row=2, column=27).border = border
        ws.merge_cells('AA2:AG2')
        
        ws.cell(row=2, column=34, value='课程目标4').font = header_font
        ws.cell(row=2, column=34).alignment = center_align
        ws.cell(row=2, column=34).border = border
        ws.merge_cells('AH2:AN2')
        
        # 总成绩（AO2）
        ws.cell(row=2, column=41, value='总成绩').font = header_font
        ws.cell(row=2, column=41).alignment = center_align
        ws.cell(row=2, column=41).border = border
        
        # 成绩录入（合并AP2:AR2，包含平时录入、期末录入、最终成绩）
        ws.cell(row=2, column=42, value='成绩录入').font = header_font
        ws.cell(row=2, column=42).alignment = center_align
        ws.cell(row=2, column=42).border = border
        ws.merge_cells('AP2:AR2')

        # 第三行：详细表头
        headers_row3 = [
            '', '',  # A-B: 学号、姓名（已合并到第二行）
            '课堂表现', '笔记', '作业', '实验',  # C-F: 平时
            '',  # G: 平时成绩（已合并到第二行）
            'M1/35', 'M2/20', 'M3/35', 'M4/10', '卷面',  # H-L: 期末
            # M-S: 课程目标1
            '课堂', '笔记', '作业', '实验', '期末', '达成情况', '达成度',
            # T-Z: 课程目标2
            '课堂', '笔记', '作业', '实验', '期末', '达成情况', '达成度',
            # AA-AG: 课程目标3
            '课堂', '笔记', '作业', '实验', '期末', '达成情况', '达成度',
            # AH-AN: 课程目标4
            '课堂', '笔记', '作业', '实验', '期末', '达成情况', '达成度',
            '',  # AO: 总成绩（已合并到第二行）
            '平时录入', '期末录入', '最终成绩'  # AP-AR: 成绩录入
        ]
        
        for col_idx, header in enumerate(headers_row3, 1):
            cell = ws.cell(row=3, column=col_idx, value=header)
            cell.font = header_font
            cell.alignment = center_align
            cell.border = border

        # 合并单元格
        ws.merge_cells('A2:A3')  # 学号
        ws.merge_cells('B2:B3')  # 姓名
        ws.merge_cells('C2:F2')  # 平时
        ws.merge_cells('G2:G3')  # 平时成绩
        ws.merge_cells('H2:L2')  # 期末
        ws.merge_cells('M2:S2')  # 课程目标1
        ws.merge_cells('T2:Z2')  # 课程目标2
        ws.merge_cells('AA2:AG2')  # 课程目标3
        ws.merge_cells('AH2:AN2')  # 课程目标4
        ws.merge_cells('AO2:AO3')  # 总成绩
        ws.merge_cells('AP2:AR2')  # 成绩录入

        # 填充数据
        row_num = 4
        for score in scores:
            # 确保重新计算成绩
            score.calculate_all()
            
            # 获取学生信息
            try:
                student_id = score.student.student_profile.student_id
            except:
                student_id = score.student.employee_id or score.student.username
            student_name = score.student.first_name or score.student.username

            # 填充数据（严格按照表头列顺序）
            data_row = [
                student_id,  # A: 学号
                student_name,  # B: 姓名
                round(score.class_performance or 0, 2),  # C: 课堂表现
                round(score.note_score or 0, 2),  # D: 笔记
                round(score.homework_avg or 0, 2),  # E: 作业
                round(score.experiment_avg or 0, 2),  # F: 实验
                int(score.usual_score or 0),  # G: 平时成绩
                round(score.M1 or 0, 2),  # H: M1/35
                round(score.M2 or 0, 2),  # I: M2/20
                round(score.M3 or 0, 2),  # J: M3/35
                round(score.M4 or 0, 2),  # K: M4/10
                round(score.final_paper_score or 0, 2),  # L: 卷面
                # M-S: 课程目标1
                round(score.obj1_classroom or 0, 2),
                round(score.obj1_note or 0, 2),
                round(score.obj1_homework or 0, 2),
                round(score.obj1_experiment or 0, 2),
                round(score.obj1_final or 0, 2),
                round(score.obj1_achievement or 0, 2),
                round(score.obj1_degree or 0, 2),
                # T-Z: 课程目标2
                round(score.obj2_classroom or 0, 2),
                round(score.obj2_note or 0, 2),
                round(score.obj2_homework or 0, 2),
                round(score.obj2_experiment or 0, 2),
                round(score.obj2_final or 0, 2),
                round(score.obj2_achievement or 0, 2),
                round(score.obj2_degree or 0, 2),
                # AA-AG: 课程目标3
                round(score.obj3_classroom or 0, 2),
                round(score.obj3_note or 0, 2),
                round(score.obj3_homework or 0, 2),
                round(score.obj3_experiment or 0, 2),
                round(score.obj3_final or 0, 2),
                round(score.obj3_achievement or 0, 2),
                round(score.obj3_degree or 0, 2),
                # AH-AN: 课程目标4
                round(score.obj4_classroom or 0, 2),
                round(score.obj4_note or 0, 2),
                round(score.obj4_homework or 0, 2),
                round(score.obj4_experiment or 0, 2),
                round(score.obj4_final or 0, 2),
                round(score.obj4_achievement or 0, 2),
                round(score.obj4_degree or 0, 2),
                int(score.total_score or 0),  # AO: 总成绩
                int(score.usual_entry or 0),  # AP: 平时录入
                int(score.final_entry or 0),  # AQ: 期末录入
                int(score.final_grade or 0),  # AR: 最终成绩
            ]

            for col_idx, value in enumerate(data_row, 1):
                cell = ws.cell(row=row_num, column=col_idx, value=value)
                cell.alignment = center_align
                cell.border = border

            row_num += 1

        # 在表格最下面添加达成度计算表
        stats_start_row = row_num + 2
        
        # 标题行："达成度计算"
        title_cell = ws.cell(row=stats_start_row, column=2, value='达成度计算')
        title_cell.font = header_font
        title_cell.alignment = center_align
        ws.merge_cells(f'B{stats_start_row}:D{stats_start_row}')
        
        # 表头行
        header_row = stats_start_row + 1
        ws.cell(row=header_row, column=2, value='课程目标').font = header_font
        ws.cell(row=header_row, column=2).alignment = center_align
        ws.cell(row=header_row, column=2).border = border
        ws.cell(row=header_row, column=3, value='达成分值').font = header_font
        ws.cell(row=header_row, column=3).alignment = center_align
        ws.cell(row=header_row, column=3).border = border
        ws.cell(row=header_row, column=4, value='达成度%').font = header_font
        ws.cell(row=header_row, column=4).alignment = center_align
        ws.cell(row=header_row, column=4).border = border
        
        # 计算班级平均达成度
        obj1_scores = []
        obj1_degrees = []
        obj2_scores = []
        obj2_degrees = []
        obj3_scores = []
        obj3_degrees = []
        obj4_scores = []
        obj4_degrees = []
        
        for score in scores:
            if score.obj1_achievement is not None:
                obj1_scores.append(score.obj1_achievement)
            if score.obj1_degree is not None:
                obj1_degrees.append(score.obj1_degree)
            if score.obj2_achievement is not None:
                obj2_scores.append(score.obj2_achievement)
            if score.obj2_degree is not None:
                obj2_degrees.append(score.obj2_degree)
            if score.obj3_achievement is not None:
                obj3_scores.append(score.obj3_achievement)
            if score.obj3_degree is not None:
                obj3_degrees.append(score.obj3_degree)
            if score.obj4_achievement is not None:
                obj4_scores.append(score.obj4_achievement)
            if score.obj4_degree is not None:
                obj4_degrees.append(score.obj4_degree)
        
        # 计算平均值（保留两位小数）
        obj1_avg_score = round(sum(obj1_scores) / len(obj1_scores), 2) if obj1_scores else 0.00
        obj1_avg_degree = round(sum(obj1_degrees) / len(obj1_degrees), 2) if obj1_degrees else 0.00
        obj2_avg_score = round(sum(obj2_scores) / len(obj2_scores), 2) if obj2_scores else 0.00
        obj2_avg_degree = round(sum(obj2_degrees) / len(obj2_degrees), 2) if obj2_degrees else 0.00
        obj3_avg_score = round(sum(obj3_scores) / len(obj3_scores), 2) if obj3_scores else 0.00
        obj3_avg_degree = round(sum(obj3_degrees) / len(obj3_degrees), 2) if obj3_degrees else 0.00
        obj4_avg_score = round(sum(obj4_scores) / len(obj4_scores), 2) if obj4_scores else 0.00
        obj4_avg_degree = round(sum(obj4_degrees) / len(obj4_degrees), 2) if obj4_degrees else 0.00
        
        # 填充达成度计算数据
        stats_data = [
            ('课程目标1', obj1_avg_score, obj1_avg_degree),
            ('课程目标2', obj2_avg_score, obj2_avg_degree),
            ('课程目标3', obj3_avg_score, obj3_avg_degree),
            ('课程目标4', obj4_avg_score, obj4_avg_degree),
        ]
        
        for idx, (objective, score_val, degree) in enumerate(stats_data, 1):
            row = header_row + idx
            ws.cell(row=row, column=1, value='').border = border
            ws.cell(row=row, column=2, value=objective).border = border
            ws.cell(row=row, column=2).alignment = center_align
            ws.cell(row=row, column=3, value=score_val).border = border
            ws.cell(row=row, column=3).alignment = center_align
            ws.cell(row=row, column=4, value=degree).border = border
            ws.cell(row=row, column=4).alignment = center_align

        # 设置列宽
        column_widths = {
            'A': 15, 'B': 10, 'C': 10, 'D': 10, 'E': 10, 'F': 10, 'G': 10,
            'H': 10, 'I': 10, 'J': 10, 'K': 10, 'L': 10,
            'M': 8, 'N': 8, 'O': 8, 'P': 8, 'Q': 8, 'R': 10, 'S': 10,
            'T': 8, 'U': 8, 'V': 8, 'W': 8, 'X': 8, 'Y': 10, 'Z': 10,
            'AA': 8, 'AB': 8, 'AC': 8, 'AD': 8, 'AE': 8, 'AF': 10, 'AG': 10,
            'AH': 8, 'AI': 8, 'AJ': 8, 'AK': 8, 'AL': 8, 'AM': 10, 'AN': 10,
            'AO': 10, 'AP': 10, 'AQ': 10, 'AR': 10
        }
        for col, width in column_widths.items():
            ws.column_dimensions[col].width = width

        # 保存到BytesIO
        output = BytesIO()
        wb.save(output)
        output.seek(0)

        response = HttpResponse(
            output.read(),
            content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        )
        filename = f"{course_class.course.course_name}_{course_class.class_name}_达成度计算.xlsx"
        response['Content-Disposition'] = f'attachment; filename="{filename}"'
        return response

