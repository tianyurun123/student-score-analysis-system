from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.db.models import Q, Avg, Max, Min, Count, F
from django.utils import timezone
import logging

from apps.scores.models import Score
from apps.courses.models import Course, CourseClass, CourseObjectiveAchievement
from utils.calculator import ScoreCalculator
from utils.objective_calculator import ObjectiveCalculator

logger = logging.getLogger(__name__)


class AnalysisViewSet(viewsets.ViewSet):
    """数据分析视图集"""
    permission_classes = [IsAuthenticated]

    @action(detail=False, methods=['get'], url_path='course-statistics')
    def course_statistics(self, request):
        """课程成绩统计"""
        course_id = request.query_params.get('course_id')
        course_class_id = request.query_params.get('course_class_id')

        if not course_id and not course_class_id:
            return Response({'error': '请提供course_id或course_class_id'}, status=status.HTTP_400_BAD_REQUEST)

        if course_class_id:
            scores = Score.objects.filter(course_class_id=course_class_id)
        else:
            scores = Score.objects.filter(course_class__course_id=course_id)

        # 基础统计
        final_grades = [s.final_grade for s in scores if s.final_grade is not None]
        stats = ScoreCalculator.calculate_statistics(final_grades)

        # 等级分布
        grade_distribution = scores.values('grade_level').annotate(count=Count('id')).order_by('grade_level')

        # 各分数段分布
        score_ranges = {
            '优秀(90-100)': scores.filter(final_grade__gte=90).count(),
            '良好(80-89)': scores.filter(final_grade__gte=80, final_grade__lt=90).count(),
            '中等(70-79)': scores.filter(final_grade__gte=70, final_grade__lt=80).count(),
            '及格(60-69)': scores.filter(final_grade__gte=60, final_grade__lt=70).count(),
            '不及格(<60)': scores.filter(final_grade__lt=60).count(),
        }

        return Response({
            'statistics': stats,
            'grade_distribution': list(grade_distribution),
            'score_ranges': score_ranges,
        })

    @action(detail=False, methods=['get'], url_path='student-progress')
    def student_progress(self, request):
        """学生成绩趋势分析"""
        student_id = request.query_params.get('student_id')
        if not student_id:
            return Response({'error': '请提供student_id'}, status=status.HTTP_400_BAD_REQUEST)

        from apps.users.models import User
        try:
            student = User.objects.get(id=student_id, user_type='student')
        except User.DoesNotExist:
            return Response({'error': '学生不存在'}, status=status.HTTP_404_NOT_FOUND)

        scores = Score.objects.filter(student=student).select_related('course_class', 'course_class__course')

        # 按学期分组
        progress_data = []
        for score in scores:
            progress_data.append({
                'course_name': score.course_class.course.course_name,
                'course_code': score.course_class.course.course_code,
                'semester': f"{score.course_class.course.year}-{score.course_class.course.semester}",
                'final_grade': score.final_grade,
                'grade_point': score.grade_point,
                'grade_level': score.grade_level,
            })

        # 计算平均绩点
        grade_points = [s.grade_point for s in scores if s.grade_point is not None]
        avg_gpa = sum(grade_points) / len(grade_points) if grade_points else 0

        return Response({
            'student_id': student_id,
            'student_name': student.first_name or student.username,
            'average_gpa': round(avg_gpa, 2),
            'progress': progress_data,
        })

    @action(detail=False, methods=['get'], url_path='class-comparison')
    def class_comparison(self, request):
        """班级对比分析"""
        course_id = request.query_params.get('course_id')
        if not course_id:
            return Response({'error': '请提供course_id'}, status=status.HTTP_400_BAD_REQUEST)

        classes = CourseClass.objects.filter(course_id=course_id)
        comparison_data = []

        for cls in classes:
            scores = Score.objects.filter(course_class=cls)
            final_grades = [s.final_grade for s in scores if s.final_grade is not None]
            
            if final_grades:
                stats = ScoreCalculator.calculate_statistics(final_grades)
                comparison_data.append({
                    'class_name': cls.class_name,
                    'student_count': cls.students.count(),
                    'statistics': stats,
                })

        return Response({
            'course_id': course_id,
            'comparison': comparison_data,
        })

    @action(detail=False, methods=['get'], url_path='score-distribution')
    def score_distribution(self, request):
        """成绩分布分析"""
        course_class_id = request.query_params.get('course_class_id')
        if not course_class_id:
            return Response({'error': '请提供course_class_id'}, status=status.HTTP_400_BAD_REQUEST)

        scores = Score.objects.filter(course_class_id=course_class_id)
        final_grades = [s.final_grade for s in scores if s.final_grade is not None]

        # 按10分一段统计
        distribution = {}
        for i in range(0, 101, 10):
            range_start = i
            range_end = i + 9 if i < 100 else 100
            count = sum(1 for g in final_grades if range_start <= g <= range_end)
            distribution[f'{range_start}-{range_end}'] = count

        return Response({
            'distribution': distribution,
            'total_count': len(final_grades),
        })

    @action(detail=False, methods=['get'], url_path='component-analysis')
    def component_analysis(self, request):
        """成绩构成分析"""
        course_class_id = request.query_params.get('course_class_id')
        if not course_class_id:
            return Response({'error': '请提供course_class_id'}, status=status.HTTP_400_BAD_REQUEST)

        scores = Score.objects.filter(course_class_id=course_class_id)

        components = {
            'attendance': [s.attendance_score for s in scores if s.attendance_score is not None],
            'homework': [s.homework_score for s in scores if s.homework_score is not None],
            'experiment': [s.experiment_score for s in scores if s.experiment_score is not None],
            'review_note': [s.review_note_score for s in scores if s.review_note_score is not None],
            'final': [s.final_score for s in scores if s.final_score is not None],
        }

        analysis = {}
        for component, values in components.items():
            if values:
                analysis[component] = ScoreCalculator.calculate_statistics(values)

        return Response({
            'components': analysis,
        })

    @action(detail=False, methods=['get'], url_path='dashboard')
    def dashboard(self, request):
        """仪表盘数据"""
        try:
            from apps.users.models import User
            user = request.user

            if not hasattr(user, 'user_type'):
                return Response({
                    'user_type': 'admin',
                    'total_courses': 0,
                    'total_classes': 0,
                    'total_students': 0,
                    'recent_scores': []
                })

            if user.user_type == 'teacher':
                # 教师仪表盘
                courses = Course.objects.filter(
                    Q(teachers=user) | Q(classes__main_teacher=user)
                ).distinct().select_related('grading_policy')

                total_courses = courses.count()
                
                classes = CourseClass.objects.filter(
                    Q(main_teacher=user) | Q(assistant_teachers=user) | Q(course__teachers=user)
                ).distinct().select_related('course', 'main_teacher')
                
                total_classes = classes.count()

                # 计算学生数：每个班级学生数的总和（不去重，与班级列表保持一致）
                total_students = 0
                for cls in classes:
                    total_students += cls.students.count()
                
                # 构建课程列表（课程名称）
                course_names = [course.course_name for course in courses]
                
                # 构建班级列表（按课程分组：课程名称 -> 班级列表）
                classes_by_course = {}
                for cls in classes:
                    course_name = cls.course.course_name
                    if course_name not in classes_by_course:
                        classes_by_course[course_name] = []
                    classes_by_course[course_name].append(cls.class_name)

                return Response({
                    'user_type': 'teacher',
                    'total_courses': total_courses,
                    'total_classes': total_classes,
                    'total_students': total_students,
                    'course_names': course_names,
                    'classes_by_course': classes_by_course,
                })

            elif user.user_type == 'student':
                # 学生仪表盘
                scores = Score.objects.filter(student=user).select_related('course_class', 'course_class__course')
                total_courses = scores.count()
                
                grade_points = [s.grade_point for s in scores if s.grade_point is not None]
                avg_gpa = sum(grade_points) / len(grade_points) if grade_points else 0

                recent_scores = scores.order_by('-updated_at')[:10]

                return Response({
                    'user_type': 'student',
                    'total_courses': total_courses,
                    'average_gpa': round(avg_gpa, 2),
                    'recent_scores': [
                        {
                            'course_name': s.course_class.course.course_name,
                            'final_grade': s.final_grade,
                            'grade_level': s.grade_level,
                            'updated_at': s.updated_at.strftime('%Y-%m-%d %H:%M:%S') if s.updated_at else None,
                        }
                        for s in recent_scores
                    ],
                })

            # 默认返回空数据
            return Response({
                'user_type': user.user_type if hasattr(user, 'user_type') else 'unknown',
                'total_courses': 0,
                'total_classes': 0,
                'total_students': 0,
                'recent_scores': []
            })
        except Exception as e:
            logger.error(f"获取仪表盘数据失败: {str(e)}", exc_info=True)
            return Response({
                'error': f'获取数据失败: {str(e)}',
                'user_type': 'unknown',
                'total_courses': 0,
                'total_classes': 0,
                'total_students': 0,
                'recent_scores': []
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @action(detail=False, methods=['get'], url_path='objective-achievement')
    def objective_achievement(self, request):
        """课程目标达成度分析"""
        course_class_id = request.query_params.get('course_class_id')
        if not course_class_id:
            return Response({'error': '请提供course_class_id'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            course_class = CourseClass.objects.get(id=course_class_id)
            
            # 权限检查：管理员和超级用户可以访问所有班级，教师只能查看自己作为主讲教师或助教的班级
            user = request.user
            if user.user_type != 'admin' and not user.is_superuser:
                if user.user_type == 'teacher':
                    if (course_class.main_teacher != user and 
                        user not in course_class.assistant_teachers.all()):
                        return Response({'error': '您没有权限查看该班级的数据'}, status=status.HTTP_403_FORBIDDEN)
        except CourseClass.DoesNotExist:
            return Response({'error': '课程班级不存在'}, status=status.HTTP_404_NOT_FOUND)

        scores = Score.objects.filter(course_class=course_class).select_related('student', 'course_class', 'course_class__course')
        
        # 批量获取所有已存在的课程目标达成度
        score_ids = [score.id for score in scores]
        existing_achievements = CourseObjectiveAchievement.objects.filter(
            score_id__in=score_ids
        ).select_related('score').order_by('score_id', 'objective_number')
        
        # 构建已存在的达成度映射 {score_id: {1: obj1, 2: obj2, 3: obj3}}
        achievement_map = {}
        for ach in existing_achievements:
            if ach.score_id not in achievement_map:
                achievement_map[ach.score_id] = {}
            achievement_map[ach.score_id][ach.objective_number] = ach
        
        # 批量计算缺失的课程目标达成度
        scores_to_calculate = []
        for score in scores:
            if score.id not in achievement_map or len(achievement_map[score.id]) < 3:
                scores_to_calculate.append(score)
        
        # 批量计算并保存缺失的达成度
        if scores_to_calculate:
            from django.db import transaction
            with transaction.atomic():
                for score in scores_to_calculate:
                    try:
                        # 计算并保存达成度，返回创建的achievement对象
                        achievements = ObjectiveCalculator.save_objective_achievements(score)
                        # 将新创建的达成度添加到映射中
                        if score.id not in achievement_map:
                            achievement_map[score.id] = {}
                        for ach in achievements:
                            achievement_map[score.id][ach.objective_number] = ach
                    except Exception as e:
                        logger.error(f"计算课程目标达成度失败 (score_id={score.id}): {str(e)}")
        
        # 构建返回数据
        student_achievements = []
        for score in scores:
            achievements = achievement_map.get(score.id, {})
            
            obj_data = {
                'student_id': score.student.employee_id or score.student.username,
                'student_name': score.student.first_name or score.student.username,
                'objective1': {},
                'objective2': {},
                'objective3': {},
                'total_achievement': 0,
                'final_grade': score.final_grade or 0,
                'usual_entry': score.usual_entry,
                'final_entry': score.final_entry
            }
            
            for obj_num in [1, 2, 3]:
                ach = achievements.get(obj_num)
                if ach:
                    obj_key = f'objective{obj_num}'
                    obj_data[obj_key] = {
                        'usual': ach.usual_score,
                        'experiment': ach.experiment_score,
                        'final': ach.final_score,
                        'achievement': ach.achievement_score,
                        'degree': ach.achievement_degree
                    }
                    obj_data['total_achievement'] += ach.achievement_score
            
            student_achievements.append(obj_data)
        
        # 计算班级整体统计
        class_statistics = ObjectiveCalculator.calculate_class_statistics(course_class_id)
        
        return Response({
            'course_name': course_class.course.course_name,
            'class_name': course_class.class_name,
            'student_achievements': student_achievements,
            'class_statistics': class_statistics
        })

    @action(detail=False, methods=['post'], url_path='recalculate-objectives')
    def recalculate_objectives(self, request):
        """重新计算课程目标达成度"""
        course_class_id = request.data.get('course_class_id')
        if not course_class_id:
            return Response({'error': '请提供course_class_id'}, status=status.HTTP_400_BAD_REQUEST)

        scores = Score.objects.filter(course_class_id=course_class_id)
        count = 0
        
        for score in scores:
            try:
                ObjectiveCalculator.save_objective_achievements(score)
                count += 1
            except Exception as e:
                logger.error(f"重新计算课程目标达成度失败 (score_id={score.id}): {str(e)}")
        
        return Response({
            'message': f'成功重新计算 {count} 个学生的课程目标达成度',
            'count': count
        })



    @action(detail=False, methods=['post'], url_path='export-quality-analysis')
    def export_quality_analysis(self, request):
        """导出质量分析Word文档"""
        from apps.scores.models import Score
        from apps.courses.models import CourseClass
        from apps.analysis.export_quality import generate_quality_analysis_doc
        from io import BytesIO
        from django.http import HttpResponse
        import math

        course_class_id = request.data.get('course_class_id')

        if not course_class_id:
            return Response({'error': '请提供course_class_id'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            course_class = CourseClass.objects.select_related('course').get(id=course_class_id)

            # 权限检查：管理员和超级用户可以访问所有班级，教师只能查看自己作为主讲教师或助教的班级
            user = request.user
            if user.user_type != 'admin' and not user.is_superuser:
                if user.user_type == 'teacher':
                    if (course_class.main_teacher != user and
                        user not in course_class.assistant_teachers.all()):
                        return Response({'error': '您没有权限查看该班级的数据'}, status=status.HTTP_403_FORBIDDEN)

            # 获取成绩数据
            scores = Score.objects.filter(course_class=course_class).select_related('student')

            basic_info = request.data.get('basic_info', {})
            analysis_texts_raw = request.data.get('analysis_texts', {})

            # 辅助函数：安全地将值转换为字符串
            def safe_str(value, default=''):
                if value is None:
                    return default
                if isinstance(value, dict):
                    # 如果是对象，尝试提取文本内容
                    if 'value' in value:
                        return safe_str(value['value'], default)
                    elif 'text' in value:
                        return safe_str(value['text'], default)
                    elif 'content' in value:
                        return safe_str(value['content'], default)
                    else:
                        # 如果无法提取，返回默认值而不是 "[object Object]"
                        return default
                if isinstance(value, (list, tuple)):
                    # 如果是列表或元组，尝试连接
                    return ' '.join([safe_str(item, '') for item in value])
                try:
                    result = str(value)
                    # 如果结果是 "[object Object]"，返回默认值
                    if result == '[object Object]' or result.startswith('<'):
                        return default
                    return result
                except Exception:
                    return default

            # 确保analysis_texts中的所有值都是字符串
            analysis_texts = {}
            for key, value in analysis_texts_raw.items():
                analysis_texts[key] = safe_str(value, '')

            teacher_name = safe_str(basic_info.get('teacher_name')) or safe_str(course_class.main_teacher.first_name if course_class.main_teacher else '')
            department = safe_str(basic_info.get('department')) or safe_str(course_class.course.department if course_class.course.department else '')
            class_name = safe_str(basic_info.get('class_name')) or course_class.class_name

            # 确保hours是字符串
            hours_value = basic_info.get('hours')
            if hours_value is None or hours_value == '':
                hours_value = str(course_class.course.hours) if course_class.course.hours else ''
            else:
                hours_value = safe_str(hours_value)

            # 确保exam_count是整数
            exam_count_value = basic_info.get('exam_count')
            if exam_count_value is None:
                exam_count_value = scores.count()
            else:
                try:
                    if isinstance(exam_count_value, (int, float)):
                        exam_count_value = int(exam_count_value)
                    else:
                        exam_count_value = int(safe_str(exam_count_value, '0') or '0')
                except (ValueError, TypeError):
                    exam_count_value = scores.count()

            exam_nature = safe_str(basic_info.get('exam_nature'), '考试')
            exam_method = safe_str(basic_info.get('exam_method'), '闭卷')
            exam_date = safe_str(basic_info.get('exam_date'))
            question_source = safe_str(basic_info.get('question_source'), '自主命题')

            basic_info_dict = {
                'course_name': safe_str(course_name),
                'teacher_name': safe_str(teacher_name),
                'department': safe_str(department),
                'class_name': safe_str(class_name),
                'hours': safe_str(hours_value),
                'exam_count': exam_count_value,
                'exam_nature': safe_str(exam_nature, '考试'),
                'exam_method': safe_str(exam_method, '闭卷'),
                'exam_date': safe_str(exam_date),
                'question_source': safe_str(question_source, '自主命题')
            }

            # 获取成绩分数（根据课程类型）
            if is_graphics_course:
                final_scores = [s.final_grade for s in scores if s.final_grade is not None]
            else:
                final_scores = [s.final_paper_score for s in scores if s.final_paper_score is not None]

            if not final_scores:
                return Response({'error': '该班级暂无成绩数据'}, status=status.HTTP_400_BAD_REQUEST)

            total_count = len(final_scores)

            ranges = [
                {'label': '不及格', 'min': 0, 'max': 59},
                {'label': '及格', 'min': 60, 'max': 69},
                {'label': '中等', 'min': 70, 'max': 79},
                {'label': '良好', 'min': 80, 'max': 89},
                {'label': '优秀', 'min': 90, 'max': 100}
            ]

            distribution = []
            for r in ranges:
                count = len([s for s in final_scores if r['min'] <= s <= r['max']])
                percentage = (count / total_count * 100) if total_count > 0 else 0
                distribution.append({
                    'label': r['label'],
                    'range': f"{r['min']}~{r['max']}",
                    'count': count,
                    'percentage': percentage
                })

            max_score = max(final_scores)
            min_score = min(final_scores)
            avg_score = sum(final_scores) / len(final_scores)
            variance = sum([(s - avg_score) ** 2 for s in final_scores]) / len(final_scores)
            std_dev = math.sqrt(variance)

            statistics = {
                'max_score': max_score,
                'min_score': min_score,
                'avg_score': avg_score,
                'std_dev': std_dev
            }

            # 确保数据类型正确
            if not isinstance(distribution, list):
                logger.error(f"distribution类型错误: {type(distribution)}, 值: {distribution}")
                distribution = []
            if not isinstance(statistics, dict):
                logger.error(f"statistics类型错误: {type(statistics)}, 值: {statistics}")
                statistics = {}
            if not isinstance(basic_info_dict, dict):
                logger.error(f"basic_info_dict类型错误: {type(basic_info_dict)}, 值: {basic_info_dict}")
                basic_info_dict = {}
            if not isinstance(analysis_texts, dict):
                logger.error(f"analysis_texts类型错误: {type(analysis_texts)}, 值: {analysis_texts}")
                analysis_texts = {}

            # 调试日志：打印数据类型
            logger.info(f"准备生成Word文档 - basic_info_dict类型: {type(basic_info_dict)}, analysis_texts类型: {type(analysis_texts)}")
            logger.info(f"basic_info_dict键: {list(basic_info_dict.keys()) if isinstance(basic_info_dict, dict) else 'N/A'}")
            logger.info(f"analysis_texts键: {list(analysis_texts.keys()) if isinstance(analysis_texts, dict) else 'N/A'}")

            doc = generate_quality_analysis_doc(basic_info_dict, analysis_texts, distribution, statistics, True)

            output = BytesIO()
            doc.save(output)
            output.seek(0)

            response = HttpResponse(
                output.read(),
                content_type='application/vnd.openxmlformats-officedocument.wordprocessingml.document'
            )
            filename = f"{course_name}_{class_name}_质量分析.docx"
            response['Content-Disposition'] = f'attachment; filename="{filename}"'
            return response

        except CourseClass.DoesNotExist:
            return Response({'error': '课程班级不存在'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            import traceback
            logger.error(f"导出质量分析Word文档失败: {str(e)}\n{traceback.format_exc()}", exc_info=True)
            return Response({'error': f'导出失败: {str(e)}'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @action(detail=False, methods=['get'], url_path='achievement-analysis')
    def achievement_analysis(self, request):
        """达成情况分析（图形学课程3个目标）"""
        from apps.scores.models import Score
        from apps.courses.models import CourseClass
        import math
        
        course_class_id = request.query_params.get('course_class_id')
        if not course_class_id:
            return Response({'error': '请提供course_class_id'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            course_class = CourseClass.objects.select_related('course', 'main_teacher').get(id=course_class_id)
            
            # 权限检查：管理员和超级用户可以访问所有班级，教师只能查看自己作为主讲教师或助教的班级
            user = request.user
            if user.user_type != 'admin' and not user.is_superuser:
                if user.user_type == 'teacher':
                    if (course_class.main_teacher != user and 
                        user not in course_class.assistant_teachers.all()):
                        return Response({'error': '您没有权限查看该班级的数据'}, status=status.HTTP_403_FORBIDDEN)
            
            course_name = course_class.course.course_name
            
            expected_degree = 0.6  # 期望达成度
            
            # 图形学课程：3个目标
            scores = Score.objects.filter(course_class=course_class).select_related('student')
            
            if not scores.exists():
                return Response({'error': '该班级暂无成绩数据'}, status=status.HTTP_400_BAD_REQUEST)
            
            # 计算总成绩分布（使用final_grade）
            final_grades = [s.final_grade for s in scores if s.final_grade is not None]
            
            if not final_grades:
                return Response({'error': '该班级暂无总成绩数据'}, status=status.HTTP_400_BAD_REQUEST)
            
            total_count = len(final_grades)
            
            # 成绩分布
            ranges = [
                {'label': '不及格', 'min': 0, 'max': 59},
                {'label': '及格', 'min': 60, 'max': 69},
                {'label': '中等', 'min': 70, 'max': 79},
                {'label': '良好', 'min': 80, 'max': 89},
                {'label': '优秀', 'min': 90, 'max': 100}
            ]
            
            distribution = []
            for r in ranges:
                count = len([s for s in final_grades if r['min'] <= s <= r['max']])
                percentage = (count / total_count * 100) if total_count > 0 else 0
                distribution.append({
                    'label': r['label'],
                    'range': f"{r['min']}~{r['max']}",
                    'count': count,
                    'percentage': percentage
                })
            
            # 统计信息
            max_score = max(final_grades)
            min_score = min(final_grades)
            avg_score = sum(final_grades) / len(final_grades)
            variance = sum([(s - avg_score) ** 2 for s in final_grades]) / len(final_grades)
            std_dev = math.sqrt(variance)
            
            statistics = {
                'max_score': max_score,
                'min_score': min_score,
                'avg_score': avg_score,
                'std_dev': std_dev
            }
            
            # 获取或计算课程目标达成度
            score_ids = [score.id for score in scores]
            existing_achievements = CourseObjectiveAchievement.objects.filter(
                score_id__in=score_ids
            ).select_related('score').order_by('score_id', 'objective_number')
            
            achievement_map = {}
            for ach in existing_achievements:
                if ach.score_id not in achievement_map:
                    achievement_map[ach.score_id] = {}
                achievement_map[ach.score_id][ach.objective_number] = ach
            
            # 批量计算缺失的达成度
            scores_to_calculate = []
            for score in scores:
                if score.id not in achievement_map or len(achievement_map[score.id]) < 3:
                    scores_to_calculate.append(score)
            
            if scores_to_calculate:
                from django.db import transaction
                with transaction.atomic():
                    for score in scores_to_calculate:
                        try:
                            achievements = ObjectiveCalculator.save_objective_achievements(score)
                            if score.id not in achievement_map:
                                achievement_map[score.id] = {}
                            for ach in achievements:
                                achievement_map[score.id][ach.objective_number] = ach
                        except Exception as e:
                            logger.error(f"计算课程目标达成度失败 (score_id={score.id}): {str(e)}")
            
            # 提取达成度数据
            obj1_degrees = []
            obj2_degrees = []
            obj3_degrees = []
            
            for score in scores:
                achievements = achievement_map.get(score.id, {})
                if 1 in achievements:
                    obj1_degrees.append(achievements[1].achievement_degree)
                if 2 in achievements:
                    obj2_degrees.append(achievements[2].achievement_degree)
                if 3 in achievements:
                    obj3_degrees.append(achievements[3].achievement_degree)
            
            def calculate_achievement(degrees, count):
                if len(degrees) == 0:
                    return {'evaluated': 0.0, 'rate': 0.0}
                evaluated = sum(degrees) / len(degrees)
                pass_count = len([d for d in degrees if d >= expected_degree])
                rate = (pass_count / count * 100) if count > 0 else 0.0
                return {'evaluated': evaluated, 'rate': rate}
            
            obj1 = calculate_achievement(obj1_degrees, total_count)
            obj2 = calculate_achievement(obj2_degrees, total_count)
            obj3 = calculate_achievement(obj3_degrees, total_count)
            
            # 总和：三个目标的平均值
            total_evaluated = (obj1['evaluated'] + obj2['evaluated'] + obj3['evaluated']) / 3.0
            total_rate = (obj1['rate'] + obj2['rate'] + obj3['rate']) / 3.0
            
            def get_evaluation(evaluated):
                if evaluated >= expected_degree:
                    return '达成'
                elif evaluated >= expected_degree * 0.8:
                    return '基本达成'
                else:
                    return '未达成'
            
            def get_evaluation_text(obj_code, evaluated, rate):
                """根据达成度生成评价文本"""
                if obj_code == '课程目标1':
                    if evaluated >= expected_degree:
                        return '该课程目标达成度较高，说明学生对于图形学基本概念和原理的掌握较好。'
                    else:
                        return '该课程目标达成度不高，说明学生对于图形学基本概念和原理的掌握有待加强。'
                elif obj_code == '课程目标2':
                    if evaluated >= expected_degree:
                        return '该课程目标达成度较高，说明学生对于图形学算法实现能力较好。'
                    else:
                        return '该课程目标达成度不高，说明学生对于图形学算法实现能力有待加强。'
                elif obj_code == '课程目标3':
                    if evaluated >= expected_degree:
                        return '该课程目标达成度较高，说明学生对于图形学综合应用能力较好。'
                    else:
                        return '该课程目标达成度不高，说明学生对于图形学综合应用能力有待加强。'
                elif obj_code == '总和':
                    if evaluated >= expected_degree:
                        return '课程目标达成。'
                    else:
                        return '课程目标未完全达成，需要进一步改进教学方法和内容。'
            
            achievement_data = [
                {
                    'objective_code': '课程目标1',
                    'expected_degree': expected_degree,
                    'evaluated_degree': obj1['evaluated'],
                    'achievement_rate': obj1['rate'],
                    'evaluation_text': get_evaluation_text('课程目标1', obj1['evaluated'], obj1['rate']),
                    'problems': '',
                    'improvements': ''
                },
                {
                    'objective_code': '课程目标2',
                    'expected_degree': expected_degree,
                    'evaluated_degree': obj2['evaluated'],
                    'achievement_rate': obj2['rate'],
                    'evaluation_text': get_evaluation_text('课程目标2', obj2['evaluated'], obj2['rate']),
                    'problems': '',
                    'improvements': ''
                },
                {
                    'objective_code': '课程目标3',
                    'expected_degree': expected_degree,
                    'evaluated_degree': obj3['evaluated'],
                    'achievement_rate': obj3['rate'],
                    'evaluation_text': get_evaluation_text('课程目标3', obj3['evaluated'], obj3['rate']),
                    'problems': '',
                    'improvements': ''
                },
                {
                    'objective_code': '总和',
                    'expected_degree': expected_degree,
                    'evaluated_degree': total_evaluated,
                    'achievement_rate': total_rate,
                    'evaluation_text': get_evaluation_text('总和', total_evaluated, total_rate),
                    'problems': '',
                    'improvements': ''
                }
            ]
            
            return Response({
                'course_name': course_name,
                'class_name': course_class.class_name,
                'distribution': distribution,
                'statistics': statistics,
                    'achievement_data': achievement_data,
                    'basic_info': {
                        'course_name': course_class.course.course_name,
                        'teacher_name': course_class.main_teacher.first_name if course_class.main_teacher else '',
                        'department': course_class.course.department or '',
                        'class_name': course_class.class_name,
                        'hours': course_class.course.hours or 0,
                        'exam_count': total_count
                    }
                })
        except CourseClass.DoesNotExist:
            return Response({'error': '课程班级不存在'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            logger.error(f"获取达成情况数据失败: {str(e)}", exc_info=True)
            return Response({'error': f'获取数据失败: {str(e)}'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
