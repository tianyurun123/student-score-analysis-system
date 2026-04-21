from rest_framework import serializers
from django.db.models import Q
from apps.scores.models import Score, ScoreImportLog, ScoreAdjustment, Gradebook, AlgorithmScore
from apps.courses.models import CourseClass, GradingPolicy
from apps.users.models import User, StudentProfile


class ScoreSerializer(serializers.ModelSerializer):
    """成绩序列化器"""
    student_name = serializers.CharField(source='student.first_name', read_only=True)
    student_id = serializers.SerializerMethodField()
    course_name = serializers.CharField(source='course_class.course.course_name', read_only=True)
    class_name = serializers.CharField(source='course_class.class_name', read_only=True)
    usual_entry = serializers.SerializerMethodField()
    final_entry = serializers.SerializerMethodField()

    class Meta:
        model = Score
        fields = [
            'id', 'student', 'student_name', 'student_id',
            'course_class', 'course_name', 'class_name',
            'grading_policy',
            'attendance_score', 'homework_score', 'experiment_score',
            'review_note_score', 'extra_scores', 'final_score',
            'usual_total', 'final_total', 'usual_entry', 'final_entry',
            'final_grade',
            'grade_point', 'grade_level',
            'is_published', 'published_at', 'is_verified',
            'created_by', 'updated_by', 'created_at', 'updated_at',
        ]
        read_only_fields = [
            'usual_total', 'final_total', 'final_grade',
            'grade_point', 'grade_level', 'created_at', 'updated_at',
        ]

    def get_student_id(self, obj):
        """获取学号"""
        try:
            return obj.student.student_profile.student_id
        except StudentProfile.DoesNotExist:
            return obj.student.employee_id or obj.student.username
    
    def get_usual_entry(self, obj):
        """计算平时录入"""
        if obj.usual_entry is not None:
            return obj.usual_entry
        
        # 如果数据库中没有，实时计算
        experiment = obj.experiment_score or 0
        if obj.usual_total is not None:
            return round((obj.usual_total * 0.2 + experiment * 0.2) / 0.4)
        return None
    
    def get_final_entry(self, obj):
        """计算期末录入"""
        if obj.final_entry is not None:
            return obj.final_entry
        
        # 如果数据库中没有，实时计算
        if obj.final_total is not None:
            return int(obj.final_total)
        return None


class ScoreCreateSerializer(serializers.ModelSerializer):
    """成绩创建序列化器"""
    student_id = serializers.CharField(write_only=True, required=False, help_text='学号（如果提供，将根据学号查找或创建学生）')
    student_name = serializers.CharField(write_only=True, required=False, help_text='姓名（如果提供，将用于创建新学生）')
    course_class_id = serializers.IntegerField(write_only=True, required=False, help_text='课程班级ID（如果提供，将根据ID查找班级）')
    
    class Meta:
        model = Score
        fields = [
            'student', 'course_class', 'grading_policy',
            'student_id', 'student_name', 'course_class_id',
            'attendance_score', 'homework_score', 'experiment_score',
            'review_note_score', 'extra_scores', 'final_score',
        ]

    def validate(self, attrs):
        """验证数据，支持通过student_id和course_class_id创建"""
        # 如果提供了student_id和course_class_id，需要查找或创建学生和班级
        student_id = attrs.pop('student_id', None)
        student_name = attrs.pop('student_name', None)
        course_class_id = attrs.pop('course_class_id', None)
        
        # 处理课程班级
        if course_class_id and not attrs.get('course_class'):
            try:
                course_class = CourseClass.objects.get(id=course_class_id)
                attrs['course_class'] = course_class
            except CourseClass.DoesNotExist:
                raise serializers.ValidationError({'course_class_id': '课程班级不存在'})
        
        # 处理学生
        if student_id and not attrs.get('student'):
            from django.utils import timezone
            
            student = None
            # 先尝试通过StudentProfile查找
            try:
                student_profile = StudentProfile.objects.get(student_id=student_id)
                student = student_profile.user
            except StudentProfile.DoesNotExist:
                # 再尝试通过User的employee_id或username查找
                try:
                    student = User.objects.get(
                        Q(employee_id=student_id) | Q(username=student_id),
                        user_type='student'
                    )
                except User.DoesNotExist:
                    # 创建新学生
                    student = User.objects.create_user(
                        username=student_id,
                        first_name=student_name or student_id,
                        user_type='student',
                        employee_id=student_id
                    )
                    # 创建StudentProfile
                    StudentProfile.objects.create(
                        user=student,
                        student_id=student_id,
                        grade=timezone.now().year - 4,
                        class_name='',
                        major='',
                        enrollment_date=timezone.now().date(),
                        expected_graduation=timezone.now().date().replace(year=timezone.now().year + 4)
                    )
            
            attrs['student'] = student
        
        # 如果没有提供student或course_class，报错
        if not attrs.get('student'):
            raise serializers.ValidationError({'student': '必须提供学生信息'})
        if not attrs.get('course_class'):
            raise serializers.ValidationError({'course_class': '必须提供课程班级信息'})
        
        # 验证成绩范围
        score_fields = ['attendance_score', 'homework_score', 'experiment_score',
                       'review_note_score', 'final_score']
        for field in score_fields:
            value = attrs.get(field)
            if value is not None and not (0 <= value <= 100):
                raise serializers.ValidationError({field: '成绩必须在0-100之间'})

        # 验证额外成绩字段
        if 'extra_scores' in attrs and attrs['extra_scores']:
            for key, value in attrs['extra_scores'].items():
                if value is not None and not (0 <= value <= 100):
                    raise serializers.ValidationError(
                        {'extra_scores': f'{key} 成绩必须在0-100之间'}
                    )

        return attrs


class ScoreUpdateSerializer(serializers.ModelSerializer):
    """成绩更新序列化器"""
    class Meta:
        model = Score
        fields = [
            'attendance_score', 'homework_score', 'experiment_score',
            'review_note_score', 'extra_scores', 'final_score',
            'usual_entry', 'final_entry',
            'is_published', 'is_verified',
        ]

    def validate(self, attrs):
        """验证数据"""
        # 验证成绩范围
        score_fields = ['attendance_score', 'homework_score', 'experiment_score',
                       'review_note_score', 'final_score']
        for field in score_fields:
            value = attrs.get(field)
            if value is not None and not (0 <= value <= 100):
                raise serializers.ValidationError({field: '成绩必须在0-100之间'})

        # 验证额外成绩字段
        if 'extra_scores' in attrs and attrs['extra_scores']:
            for key, value in attrs['extra_scores'].items():
                if value is not None and not (0 <= value <= 100):
                    raise serializers.ValidationError(
                        {'extra_scores': f'{key} 成绩必须在0-100之间'}
                    )

        return attrs


class ScoreImportLogSerializer(serializers.ModelSerializer):
    """成绩导入日志序列化器"""
    imported_by_name = serializers.CharField(source='imported_by.first_name', read_only=True)
    course_name = serializers.CharField(source='course_class.course.course_name', read_only=True)
    class_name = serializers.CharField(source='course_class.class_name', read_only=True)

    class Meta:
        model = ScoreImportLog
        fields = [
            'id', 'file_name', 'file_path', 'course_class',
            'course_name', 'class_name', 'imported_by', 'imported_by_name',
            'total_rows', 'success_rows', 'failed_rows',
            'error_log', 'column_mapping', 'status',
            'created_at', 'completed_at',
        ]
        read_only_fields = [
            'total_rows', 'success_rows', 'failed_rows',
            'error_log', 'status', 'created_at', 'completed_at',
        ]


class ScoreAdjustmentSerializer(serializers.ModelSerializer):
    """成绩调整记录序列化器"""
    adjusted_by_name = serializers.CharField(source='adjusted_by.first_name', read_only=True)
    approved_by_name = serializers.CharField(source='approved_by.first_name', read_only=True)
    student_name = serializers.CharField(source='score.student.first_name', read_only=True)
    course_name = serializers.CharField(source='score.course_class.course.course_name', read_only=True)

    class Meta:
        model = ScoreAdjustment
        fields = [
            'id', 'score', 'student_name', 'course_name',
            'adjustment_type', 'reason',
            'original_value', 'new_value',
            'adjusted_by', 'adjusted_by_name',
            'approved_by', 'approved_by_name',
            'is_approved', 'created_at', 'updated_at',
        ]
        read_only_fields = ['created_at', 'updated_at']


class ExcelUploadSerializer(serializers.Serializer):
    """Excel上传序列化器"""
    file = serializers.FileField(help_text='Excel文件')
    course_class_id = serializers.IntegerField(help_text='课程班级ID')
    column_mapping = serializers.DictField(
        required=False,
        help_text='列映射关系，如 {"点名": "attendance", "电子笔记": "extra_scores.电子笔记"}'
    )

    def validate_course_class_id(self, value):
        """验证课程班级ID"""
        if value is None:
            raise serializers.ValidationError('课程班级ID不能为空')
        try:
            # 如果是字符串，转换为整数
            if isinstance(value, str):
                value = int(value)
            return value
        except (ValueError, TypeError):
            raise serializers.ValidationError('课程班级ID必须是有效的整数')


class ScoreStatisticsSerializer(serializers.Serializer):
    """成绩统计序列化器"""
    count = serializers.IntegerField()
    average = serializers.FloatField()
    max = serializers.FloatField()
    min = serializers.FloatField()
    median = serializers.FloatField()
    std = serializers.FloatField()
    pass_rate = serializers.FloatField()
    excellent_rate = serializers.FloatField()


class GradebookSerializer(serializers.ModelSerializer):
    """记分册序列化器"""
    student_name = serializers.CharField(source='student.first_name', read_only=True)
    student_id = serializers.SerializerMethodField()
    course_name = serializers.CharField(source='course_class.course.course_name', read_only=True)
    class_name = serializers.CharField(source='course_class.class_name', read_only=True)

    class Meta:
        model = Gradebook
        fields = [
            'id', 'student', 'student_name', 'student_id',
            'course_class', 'course_name', 'class_name',
            'homework1', 'homework2', 'homework3', 'homework4', 'homework5',
            'experiment1', 'experiment2',
            'attendance1', 'attendance2', 'attendance3', 'attendance4', 'attendance5',
            'review_note', 'final_score',
            'usual_score', 'total_score',
            'created_by', 'updated_by', 'created_at', 'updated_at',
        ]
        read_only_fields = [
            'usual_score', 'total_score', 'created_at', 'updated_at',
        ]

    def get_student_id(self, obj):
        """获取学号"""
        try:
            return obj.student.student_profile.student_id
        except StudentProfile.DoesNotExist:
            return obj.student.employee_id or obj.student.username


class GradebookCreateSerializer(serializers.ModelSerializer):
    """记分册创建序列化器"""
    student_id = serializers.CharField(write_only=True, required=False, help_text='学号')
    student_name = serializers.CharField(write_only=True, required=False, help_text='姓名')
    course_class_id = serializers.IntegerField(write_only=True, required=False, help_text='课程班级ID')

    class Meta:
        model = Gradebook
        fields = [
            'student', 'course_class',
            'student_id', 'student_name', 'course_class_id',
            'homework1', 'homework2', 'homework3', 'homework4', 'homework5',
            'experiment1', 'experiment2',
            'attendance1', 'attendance2', 'attendance3', 'attendance4', 'attendance5',
            'review_note', 'final_score',
        ]

    def validate(self, attrs):
        """验证数据"""
        student_id = attrs.pop('student_id', None)
        student_name = attrs.pop('student_name', None)
        course_class_id = attrs.pop('course_class_id', None)

        # 处理课程班级
        if course_class_id and not attrs.get('course_class'):
            try:
                course_class = CourseClass.objects.get(id=course_class_id)
                attrs['course_class'] = course_class
            except CourseClass.DoesNotExist:
                raise serializers.ValidationError({'course_class_id': '课程班级不存在'})

        # 处理学生
        if student_id and not attrs.get('student'):
            from django.utils import timezone
            student = None
            try:
                student_profile = StudentProfile.objects.get(student_id=student_id)
                student = student_profile.user
            except StudentProfile.DoesNotExist:
                try:
                    student = User.objects.get(
                        Q(employee_id=student_id) | Q(username=student_id),
                        user_type='student'
                    )
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
            attrs['student'] = student

        if not attrs.get('student'):
            raise serializers.ValidationError({'student': '必须提供学生信息'})
        if not attrs.get('course_class'):
            raise serializers.ValidationError({'course_class': '必须提供课程班级信息'})

        # 验证成绩范围
        score_fields = [
            'homework1', 'homework2', 'homework3', 'homework4', 'homework5',
            'experiment1', 'experiment2',
            'attendance1', 'attendance2', 'attendance3', 'attendance4', 'attendance5',
            'review_note', 'final_score'
        ]
        for field in score_fields:
            value = attrs.get(field)
            if value is not None and not (0 <= value <= 100):
                raise serializers.ValidationError({field: '成绩必须在0-100之间'})

        return attrs


class AlgorithmScoreSerializer(serializers.ModelSerializer):
    """算法分析与设计成绩序列化器"""
    student_name = serializers.SerializerMethodField()
    student_id = serializers.SerializerMethodField()
    course_name = serializers.SerializerMethodField()
    class_name = serializers.SerializerMethodField()

    class Meta:
        model = AlgorithmScore
        fields = [
            'id', 'gradebook', 'course_class', 'student', 'student_name', 'student_id',
            'course_name', 'class_name',
            'class_performance', 'note_score', 'homework_avg', 'experiment_avg', 'usual_score',
            'raw_paper_scores', 'M1', 'M2', 'M3', 'M4', 'final_paper_score',
            'obj1_classroom', 'obj1_note', 'obj1_homework', 'obj1_experiment', 'obj1_final',
            'obj1_achievement', 'obj1_degree',
            'obj2_classroom', 'obj2_note', 'obj2_homework', 'obj2_experiment', 'obj2_final',
            'obj2_achievement', 'obj2_degree',
            'obj3_classroom', 'obj3_note', 'obj3_homework', 'obj3_experiment', 'obj3_final',
            'obj3_achievement', 'obj3_degree',
            'obj4_classroom', 'obj4_note', 'obj4_homework', 'obj4_experiment', 'obj4_final',
            'obj4_achievement', 'obj4_degree',
            'total_score', 'usual_entry', 'final_entry', 'final_grade',
            'created_by', 'updated_by', 'created_at', 'updated_at',
        ]
        read_only_fields = [
            'class_performance', 'note_score', 'homework_avg', 'experiment_avg', 'usual_score',
            'obj1_classroom', 'obj1_note', 'obj1_homework', 'obj1_experiment', 'obj1_final',
            'obj1_achievement', 'obj1_degree',
            'obj2_classroom', 'obj2_note', 'obj2_homework', 'obj2_experiment', 'obj2_final',
            'obj2_achievement', 'obj2_degree',
            'obj3_classroom', 'obj3_note', 'obj3_homework', 'obj3_experiment', 'obj3_final',
            'obj3_achievement', 'obj3_degree',
            'obj4_classroom', 'obj4_note', 'obj4_homework', 'obj4_experiment', 'obj4_final',
            'obj4_achievement', 'obj4_degree',
            'total_score', 'usual_entry', 'final_entry', 'final_grade',
            'created_at', 'updated_at',
        ]

    def get_student_name(self, obj):
        """获取学生姓名"""
        try:
            return obj.student.first_name or obj.student.username
        except:
            return ''

    def get_student_id(self, obj):
        """获取学号"""
        try:
            if hasattr(obj.student, 'student_profile') and obj.student.student_profile:
                return obj.student.student_profile.student_id
            return obj.student.employee_id or obj.student.username
        except:
            try:
                return obj.student.employee_id or obj.student.username
            except:
                return ''
    
    def get_course_name(self, obj):
        """获取课程名称"""
        try:
            if obj.course_class and obj.course_class.course:
                return obj.course_class.course.course_name
            return ''
        except:
            return ''
    
    def get_class_name(self, obj):
        """获取班级名称"""
        try:
            if obj.course_class:
                return obj.course_class.class_name
            return ''
        except:
            return ''

