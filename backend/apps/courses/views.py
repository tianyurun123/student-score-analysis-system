from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.db.models import Q
from django.utils import timezone
import logging


from apps.courses.models import Course, CourseClass, Enrollment, GradingPolicy
from apps.courses.serializers import (
    CourseSerializer, CourseClassSerializer, EnrollmentSerializer,
    GradingPolicySerializer
)
from apps.courses.permissions import IsTeacherOrAdmin
from utils.syllabus_parser import SyllabusParser
from utils.file_handler import FileHandler

logger = logging.getLogger(__name__)


class CourseViewSet(viewsets.ModelViewSet):
    """课程视图集"""
    permission_classes = [IsAuthenticated]
    queryset = Course.objects.all()
    serializer_class = CourseSerializer

    def get_queryset(self):
        """根据用户权限过滤查询集"""
        queryset = super().get_queryset()
        user = self.request.user

        # 如果是学生，只能查看自己选课的课程
        if user.user_type == 'student':
            queryset = queryset.filter(
                classes__students=user
            ).distinct()
        # 如果是教师，只能查看自己授课的课程
        elif user.user_type == 'teacher':
            queryset = queryset.filter(
                Q(teachers=user) | Q(classes__main_teacher=user)
            ).distinct()

        # 过滤参数
        year = self.request.query_params.get('year')
        if year:
            queryset = queryset.filter(year=int(year))

        semester = self.request.query_params.get('semester')
        if semester:
            queryset = queryset.filter(semester=semester)

        return queryset.select_related('grading_policy').prefetch_related('teachers', 'classes')

    def perform_create(self, serializer):
        """创建课程时，如果是教师用户，自动添加到 teachers 字段"""
        course = serializer.save()
        user = self.request.user
        
        # 如果是教师用户，自动添加到 teachers 字段
        if user.user_type == 'teacher' and user not in course.teachers.all():
            course.teachers.add(user)
        
        return course

    @action(detail=True, methods=['post'], url_path='upload-syllabus')
    def upload_syllabus(self, request, pk=None):
        """上传教学大纲"""
        course = self.get_object()

        parsed_data = {}
        saved_path = course.syllabus_file  # 默认使用现有文件路径
        
        # 如果有新文件，解析文件
        if 'file' in request.FILES:
            file = request.FILES['file']
            
            # 保存文件
            file_handler = FileHandler()
            saved_path = file_handler.save_uploaded_file(file, 'syllabus/')

            # 解析大纲
            parser = SyllabusParser()
            file_type = file.name.split('.')[-1].lower()
            parsed_data = parser.parse_syllabus(saved_path, file_type)
            
            # 更新文件路径
            course.syllabus_file = saved_path
        else:
            # 如果没有新文件，使用现有的解析数据或空数据
            parsed_data = {
                'course_info': {},
                'grading_info': {},
                'course_objectives': []
            }

        # 获取前端传来的修改后的数据（如果存在）
        import json
        course_info = {}
        grading_info = {}
        course_objectives = []
        
        # 解析 FormData 中的 JSON 字符串
        if 'course_info' in request.data:
            course_info_str = request.data.get('course_info')
            if isinstance(course_info_str, str):
                try:
                    course_info = json.loads(course_info_str)
                except json.JSONDecodeError:
                    pass
            else:
                course_info = course_info_str
        
        if 'grading_info' in request.data:
            grading_info_str = request.data.get('grading_info')
            if isinstance(grading_info_str, str):
                try:
                    grading_info = json.loads(grading_info_str)
                except json.JSONDecodeError:
                    pass
            else:
                grading_info = grading_info_str
        
        if 'course_objectives' in request.data:
            course_objectives_str = request.data.get('course_objectives')
            if isinstance(course_objectives_str, str):
                try:
                    course_objectives = json.loads(course_objectives_str)
                except json.JSONDecodeError:
                    pass
            else:
                course_objectives = course_objectives_str
        
        # 如果前端传了修改后的数据，使用前端数据；否则使用解析的数据
        if course_info:
            parsed_data['course_info'] = {**parsed_data.get('course_info', {}), **course_info}
        if grading_info:
            parsed_data['grading_info'] = {**parsed_data.get('grading_info', {}), **grading_info}
        if course_objectives:
            parsed_data['course_objectives'] = course_objectives

        # 更新课程信息
        course.syllabus_file = saved_path
        
        # 更新课程基本信息（如果解析或修改了）
        if 'course_info' in parsed_data:
            course_info_data = parsed_data['course_info']
            if course_info_data.get('course_name'):
                course.course_name = course_info_data['course_name']
            if course_info_data.get('credit') is not None:
                course.credit = course_info_data['credit']
            if course_info_data.get('hours') is not None:
                course.hours = course_info_data['hours']
        
        # 保存课程目标配置
        if 'course_objectives' in parsed_data:
            course.course_objectives = parsed_data['course_objectives']
        
        course.save()

        # 更新或创建评分政策
        if 'grading_info' in parsed_data:
            grading_info_data = parsed_data['grading_info']
            policy, created = GradingPolicy.objects.get_or_create(
                course=course,
                defaults={
                    'usual_weight': grading_info_data.get('usual_weight', 0.3),
                    'final_weight': grading_info_data.get('final_weight', 0.7),
                    'attendance_weight': grading_info_data.get('考勤_weight', 0.2),
                    'homework_weight': grading_info_data.get('作业_weight', 0.3),
                    'experiment_weight': grading_info_data.get('实验_weight', 0.3),
                    'review_note_weight': grading_info_data.get('复习笔记_weight', 0.2),
                }
            )
            
            # 如果已存在，更新权重
            if not created:
                policy.usual_weight = grading_info_data.get('usual_weight', policy.usual_weight)
                policy.final_weight = grading_info_data.get('final_weight', policy.final_weight)
                policy.attendance_weight = grading_info_data.get('考勤_weight', policy.attendance_weight)
                policy.homework_weight = grading_info_data.get('作业_weight', policy.homework_weight)
                policy.experiment_weight = grading_info_data.get('实验_weight', policy.experiment_weight)
                policy.review_note_weight = grading_info_data.get('复习笔记_weight', policy.review_note_weight)
                policy.save()

            # 解析公式
            if 'text' in grading_info_data:
                text = grading_info_data['text']
                # 提取公式
                from utils.calculator import ScoreCalculator
                usual_formula = ScoreCalculator.parse_formula_from_text(text)
                final_formula = ScoreCalculator.parse_formula_from_text(text)
                
                if usual_formula or final_formula:
                    policy.grading_scale = {
                        'usual_formula': usual_formula,
                        'final_formula': final_formula,
                    }
                    policy.save()

        return Response({
            'message': '大纲上传成功',
            'parsed_data': parsed_data,
            'suggested_fields': self._extract_suggested_fields(parsed_data)
        })

    def _extract_suggested_fields(self, parsed_data: dict) -> list:
        """从解析结果中提取建议的字段"""
        suggested = []
        
        # 从成绩评定信息中提取
        if 'grading_info' in parsed_data:
            text = parsed_data['grading_info'].get('text', '')
            # 查找可能的字段名
            import re
            fields = re.findall(r'[考勤作业实验笔记作品报告点名电子笔记]+', text)
            suggested.extend(fields)

        return list(set(suggested))

    @action(detail=True, methods=['get'], url_path='suggested-fields')
    def suggested_fields(self, request, pk=None):
        """获取建议的成绩字段"""
        course = self.get_object()
        
        # 从大纲中提取
        suggested = []
        if course.syllabus_file:
            parser = SyllabusParser()
            file_type = course.syllabus_file.name.split('.')[-1].lower()
            parsed_data = parser.parse_syllabus(course.syllabus_file.path, file_type)
            suggested = self._extract_suggested_fields(parsed_data)

        # 从已有成绩中提取
        from apps.scores.models import Score
        scores = Score.objects.filter(course_class__course=course)
        for score in scores:
            if score.extra_scores:
                suggested.extend(score.extra_scores.keys())

        return Response({
            'suggested_fields': list(set(suggested))
        })


class CourseClassViewSet(viewsets.ModelViewSet):
    """课程班级视图集"""
    permission_classes = [IsAuthenticated]
    queryset = CourseClass.objects.all()
    serializer_class = CourseClassSerializer

    def get_queryset(self):
        """根据用户权限过滤查询集"""
        queryset = super().get_queryset()
        user = self.request.user

        if user.user_type == 'student':
            queryset = queryset.filter(students=user)
        elif user.user_type == 'teacher':
            queryset = queryset.filter(
                Q(main_teacher=user) | Q(assistant_teachers=user) | Q(course__teachers=user)
            ).distinct()

        course_id = self.request.query_params.get('course_id')
        if course_id:
            queryset = queryset.filter(course_id=course_id)

        return queryset.select_related('course', 'main_teacher').prefetch_related('students', 'assistant_teachers')

    def perform_create(self, serializer):
        """创建班级时，如果是教师用户，自动设置为主讲教师"""
        course_class = serializer.save()
        user = self.request.user
        
        # 如果是教师用户且main_teacher未设置，设置为当前用户
        if user.user_type == 'teacher' and not course_class.main_teacher:
            course_class.main_teacher = user
            course_class.save()
        
        # 确保课程包含当前用户在teachers字段中
        if user.user_type == 'teacher' and user not in course_class.course.teachers.all():
            course_class.course.teachers.add(user)
        
        return course_class

    @action(detail=True, methods=['post'], url_path='add-students')
    def add_students(self, request, pk=None):
        """批量添加学生到班级"""
        course_class = self.get_object()
        student_ids = request.data.get('student_ids', [])

        if not student_ids:
            return Response({'error': '请提供学生ID列表'}, status=status.HTTP_400_BAD_REQUEST)

        from apps.users.models import User
        students = User.objects.filter(id__in=student_ids, user_type='student')

        added_count = 0
        for student in students:
            enrollment, created = Enrollment.objects.get_or_create(
                student=student,
                course_class=course_class
            )
            if created:
                added_count += 1

        return Response({
            'message': f'成功添加 {added_count} 名学生',
            'added_count': added_count
        })

    @action(detail=True, methods=['get'], url_path='statistics')
    def statistics(self, request, pk=None):
        """获取班级统计信息"""
        course_class = self.get_object()
        
        from apps.scores.models import Score
        scores = Score.objects.filter(course_class=course_class)
        
        total_students = course_class.students.count()
        scores_count = scores.count()
        
        stats = {
            'total_students': total_students,
            'scores_count': scores_count,
            'completion_rate': (scores_count / total_students * 100) if total_students > 0 else 0,
        }

        if scores_count > 0:
            from utils.calculator import ScoreCalculator
            final_grades = [s.final_grade for s in scores if s.final_grade is not None]
            grade_stats = ScoreCalculator.calculate_statistics(final_grades)
            stats.update(grade_stats)

        return Response(stats)

    @action(detail=True, methods=['post'], url_path='import-students')
    def import_students(self, request, pk=None):
        """从Excel导入学生到班级"""
        course_class = self.get_object()
        
        if 'file' not in request.FILES:
            return Response({'error': '请上传Excel文件'}, status=status.HTTP_400_BAD_REQUEST)
        
        file = request.FILES['file']
        
        try:
            import pandas as pd
            from io import BytesIO
            from apps.users.models import User, StudentProfile
            
            # 读取Excel文件
            file_content = file.read()
            df = pd.read_excel(BytesIO(file_content))
            
            # 映射列名（支持中英文）
            column_mapping = {}
            for col in df.columns:
                col_lower = str(col).lower().strip()
                if col_lower in ['学号', 'student_id', 'studentid', 'id']:
                    column_mapping['student_id'] = col
                elif col_lower in ['姓名', 'name', 'student_name', '姓名']:
                    column_mapping['student_name'] = col
            
            if 'student_id' not in column_mapping:
                return Response({'error': 'Excel文件必须包含"学号"列'}, status=status.HTTP_400_BAD_REQUEST)
            
            # 处理数据
            added_count = 0
            skipped_count = 0
            errors = []
            
            for idx, row in df.iterrows():
                try:
                    student_id = str(row[column_mapping['student_id']]).strip()
                    student_name = str(row[column_mapping.get('student_name', '')]).strip() if 'student_name' in column_mapping else ''
                    
                    if not student_id or pd.isna(row[column_mapping['student_id']]):
                        continue
                    
                    # 查找或创建学生
                    student = None
                    try:
                        student_profile = StudentProfile.objects.get(student_id=student_id)
                        student = student_profile.user
                    except StudentProfile.DoesNotExist:
                        try:
                            student = User.objects.get(username=student_id, user_type='student')
                        except User.DoesNotExist:
                            # 创建新学生
                            student = User.objects.create_user(
                                username=student_id,
                                first_name=student_name or student_id,
                                user_type='student',
                                employee_id=student_id
                            )
                            StudentProfile.objects.create(
                                user=student,
                                student_id=student_id,
                                grade=timezone.now().year - 4,
                                class_name='',
                                major='',
                                enrollment_date=timezone.now().date(),
                                expected_graduation=timezone.now().date().replace(year=timezone.now().year + 4)
                            )
                    
                    # 添加到班级
                    enrollment, created = Enrollment.objects.get_or_create(
                        student=student,
                        course_class=course_class,
                        defaults={'is_active': True}
                    )
                    # 如果已存在但is_active为False，激活它
                    if not created and not enrollment.is_active:
                        enrollment.is_active = True
                        enrollment.save(update_fields=['is_active'])
                        added_count += 1
                    elif created:
                        added_count += 1
                    else:
                        skipped_count += 1
                        
                except Exception as e:
                    errors.append(f"第{idx+2}行处理失败: {str(e)}")
            
            return Response({
                'message': f'导入完成：成功添加 {added_count} 名学生，跳过 {skipped_count} 名已存在学生',
                'added_count': added_count,
                'skipped_count': skipped_count,
                'errors': errors[:10]  # 只返回前10个错误
            })
            
        except Exception as e:
            logger.error(f"导入学生失败: {str(e)}")
            return Response({'error': f'导入失败: {str(e)}'}, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=False, methods=['post'], url_path='import-class')
    def import_class(self, request):
        """导入班级（自动创建班级并导入学生）"""
        if 'file' not in request.FILES:
            return Response({'error': '请上传Excel文件'}, status=status.HTTP_400_BAD_REQUEST)
        
        file = request.FILES['file']
        
        try:
            import pandas as pd
            from io import BytesIO
            from apps.users.models import User, StudentProfile
            
            # 读取Excel文件
            file_content = file.read()
            df = pd.read_excel(BytesIO(file_content))
            
            # 映射列名（支持中英文）
            column_mapping = {}
            for col in df.columns:
                col_lower = str(col).lower().strip()
                if col_lower in ['课程代码', 'course_code', 'coursecode']:
                    column_mapping['course_code'] = col
                elif col_lower in ['课程名称', 'course_name', 'coursename']:
                    column_mapping['course_name'] = col
                elif col_lower in ['班级名称', 'class_name', 'classname']:
                    column_mapping['class_name'] = col
                elif col_lower in ['学号', 'student_id', 'studentid', 'id']:
                    column_mapping['student_id'] = col
                elif col_lower in ['姓名', 'name', 'student_name']:
                    column_mapping['student_name'] = col
            
            # 验证必要列
            required_cols = ['course_code', 'class_name', 'student_id']
            missing_cols = [col for col in required_cols if col not in column_mapping]
            if missing_cols:
                return Response({
                    'error': f'Excel文件必须包含以下列: {", ".join(missing_cols)}'
                }, status=status.HTTP_400_BAD_REQUEST)
            
            # 按课程和班级分组
            class_groups = {}
            for idx, row in df.iterrows():
                try:
                    course_code = str(row[column_mapping['course_code']]).strip()
                    course_name = str(row[column_mapping.get('course_name', '')]).strip() if 'course_name' in column_mapping else ''
                    class_name = str(row[column_mapping['class_name']]).strip()
                    student_id = str(row[column_mapping['student_id']]).strip()
                    student_name = str(row[column_mapping.get('student_name', '')]).strip() if 'student_name' in column_mapping else ''
                    
                    if not course_code or not class_name or not student_id or pd.isna(row[column_mapping['student_id']]):
                        continue
                    
                    key = f"{course_code}_{class_name}"
                    if key not in class_groups:
                        class_groups[key] = {
                            'course_code': course_code,
                            'course_name': course_name,
                            'class_name': class_name,
                            'students': []
                        }
                    
                    class_groups[key]['students'].append({
                        'student_id': student_id,
                        'student_name': student_name
                    })
                except Exception as e:
                    logger.warning(f"处理第{idx+2}行时出错: {str(e)}")
                    continue
            
            # 创建班级并导入学生
            created_classes = []
            total_students = 0
            errors = []
            
            for key, class_data in class_groups.items():
                try:
                    # 查找课程
                    try:
                        course = Course.objects.get(course_code=class_data['course_code'])
                    except Course.DoesNotExist:
                        # 如果课程不存在，创建课程
                        course = Course.objects.create(
                            course_code=class_data['course_code'],
                            course_name=class_data['course_name'] or class_data['course_code'],
                            year=timezone.now().year,
                            semester='spring' if timezone.now().month < 7 else 'autumn',
                            credit=3.0,  # 默认学分
                            hours=48,  # 默认学时
                            department=getattr(request.user, 'department', None) or '未设置',  # 使用当前用户的院系
                            is_required=True
                        )
                        # 将当前用户添加到课程的teachers字段
                        course.teachers.add(request.user)
                    
                    # 查找或创建班级
                    course_class, created = CourseClass.objects.get_or_create(
                        course=course,
                        class_name=class_data['class_name'],
                        defaults={
                            'max_students': 100,
                            'main_teacher': request.user  # 设置当前用户为主讲教师
                        }
                    )
                    # 如果班级已存在但main_teacher为空，设置为当前用户
                    if not course_class.main_teacher:
                        course_class.main_teacher = request.user
                        course_class.save()
                    
                    # 导入学生
                    added_count = 0
                    for student_data in class_data['students']:
                        try:
                            student_id = student_data['student_id']
                            student_name = student_data['student_name']
                            
                            # 查找或创建学生
                            student = None
                            try:
                                student_profile = StudentProfile.objects.get(student_id=student_id)
                                student = student_profile.user
                            except StudentProfile.DoesNotExist:
                                try:
                                    student = User.objects.get(username=student_id, user_type='student')
                                except User.DoesNotExist:
                                    student = User.objects.create_user(
                                        username=student_id,
                                        first_name=student_name or student_id,
                                        user_type='student',
                                        employee_id=student_id
                                    )
                                    StudentProfile.objects.create(
                                        user=student,
                                        student_id=student_id,
                                        grade=timezone.now().year - 4,
                                        class_name='',
                                        major='',
                                        enrollment_date=timezone.now().date(),
                                        expected_graduation=timezone.now().date().replace(year=timezone.now().year + 4)
                                    )
                            
                            # 添加到班级
                            enrollment, created_enrollment = Enrollment.objects.get_or_create(
                                student=student,
                                course_class=course_class,
                                defaults={'is_active': True}
                            )
                            # 如果已存在但is_active为False，激活它
                            if not created_enrollment and not enrollment.is_active:
                                enrollment.is_active = True
                                enrollment.save(update_fields=['is_active'])
                                added_count += 1
                            elif created_enrollment:
                                added_count += 1
                        except Exception as e:
                            errors.append(f"班级 {class_data['class_name']} 学生 {student_id} 导入失败: {str(e)}")
                    
                    created_classes.append({
                        'course_code': class_data['course_code'],
                        'course_name': course.course_name,
                        'class_name': class_data['class_name'],
                        'class_id': course_class.id,
                        'students_added': added_count,
                        'is_new': created
                    })
                    total_students += added_count
                    
                except Exception as e:
                    errors.append(f"创建班级 {class_data['class_name']} 失败: {str(e)}")
            
            return Response({
                'message': f'导入完成：创建/更新 {len(created_classes)} 个班级，添加 {total_students} 名学生',
                'created_classes': created_classes,
                'total_students': total_students,
                'errors': errors[:20]  # 只返回前20个错误
            })
            
        except Exception as e:
            logger.error(f"导入班级失败: {str(e)}")
            return Response({'error': f'导入失败: {str(e)}'}, status=status.HTTP_400_BAD_REQUEST)


class EnrollmentViewSet(viewsets.ModelViewSet):
    """选课记录视图集"""
    permission_classes = [IsAuthenticated]
    queryset = Enrollment.objects.all()
    serializer_class = EnrollmentSerializer

    def get_queryset(self):
        """根据用户权限过滤查询集"""
        queryset = super().get_queryset()
        user = self.request.user

        if user.user_type == 'student':
            queryset = queryset.filter(student=user)

        course_class_id = self.request.query_params.get('course_class_id')
        if course_class_id:
            queryset = queryset.filter(course_class_id=course_class_id)

        return queryset.select_related('student', 'course_class', 'course_class__course').prefetch_related('student__student_profile')
    
    def list(self, request, *args, **kwargs):
        """重写list方法，支持获取所有数据（不分页）"""
        # 如果请求参数中包含 no_pagination=true，则不分页
        if request.query_params.get('no_pagination') == 'true':
            queryset = self.filter_queryset(self.get_queryset())
            serializer = self.get_serializer(queryset, many=True)
            return Response({
                'results': serializer.data,
                'count': queryset.count()
            })
        return super().list(request, *args, **kwargs)
    
    def destroy(self, request, *args, **kwargs):
        """删除选课记录时，同时删除对应的成绩记录"""
        enrollment = self.get_object()
        student = enrollment.student
        course_class = enrollment.course_class
        
        # 删除对应的成绩记录
        from apps.scores.models import Score
        scores_deleted = Score.objects.filter(
            student=student,
            course_class=course_class
        ).delete()
        
        logger.info(f"删除选课记录 {enrollment.id}，同时删除了 {scores_deleted[0]} 条成绩记录")
        
        # 删除选课记录
        return super().destroy(request, *args, **kwargs)


class GradingPolicyViewSet(viewsets.ModelViewSet):
    """评分政策视图集"""
    permission_classes = [IsAuthenticated, IsTeacherOrAdmin]
    queryset = GradingPolicy.objects.all()
    serializer_class = GradingPolicySerializer

    def get_queryset(self):
        """根据用户权限过滤查询集"""
        queryset = super().get_queryset()
        user = self.request.user

        if user.user_type == 'teacher':
            queryset = queryset.filter(
                Q(course__teachers=user) | Q(course__classes__main_teacher=user)
            ).distinct()

        course_id = self.request.query_params.get('course_id')
        if course_id:
            queryset = queryset.filter(course_id=course_id)

        return queryset.select_related('course')

    @action(detail=True, methods=['post'], url_path='set-formula')
    def set_formula(self, request, pk=None):
        """设置计算公式"""
        policy = self.get_object()
        usual_formula = request.data.get('usual_formula')
        final_formula = request.data.get('final_formula')

        if not policy.grading_scale:
            policy.grading_scale = {}

        if usual_formula:
            policy.grading_scale['usual_formula'] = usual_formula
        if final_formula:
            policy.grading_scale['final_formula'] = final_formula

        policy.save()

        # 重新计算所有相关成绩
        from apps.scores.models import Score
        scores = Score.objects.filter(course_class__course=policy.course)
        for score in scores:
            score.save()  # 会自动重新计算

        return Response({
            'message': '公式设置成功，已重新计算所有成绩',
            'grading_scale': policy.grading_scale
        })

