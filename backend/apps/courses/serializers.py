from rest_framework import serializers
from apps.courses.models import Course, CourseClass, Enrollment, GradingPolicy
from apps.users.models import User


class GradingPolicySerializer(serializers.ModelSerializer):
    """评分政策序列化器"""
    course_name = serializers.CharField(source='course.course_name', read_only=True)

    class Meta:
        model = GradingPolicy
        fields = [
            'id', 'course', 'course_name',
            'usual_weight', 'final_weight',
            'attendance_weight', 'homework_weight',
            'experiment_weight', 'review_note_weight',
            'grading_scale', 'created_at'
        ]
        read_only_fields = ['created_at']


class CourseSerializer(serializers.ModelSerializer):
    """课程序列化器"""
    teachers_info = serializers.SerializerMethodField()
    classes_count = serializers.SerializerMethodField()
    has_grading_policy = serializers.SerializerMethodField()
    grading_policy = GradingPolicySerializer(read_only=True)
    teachers = serializers.PrimaryKeyRelatedField(
        many=True,
        queryset=User.objects.filter(user_type='teacher'),
        required=False,
        allow_null=True,
        allow_empty=True
    )

    class Meta:
        model = Course
        fields = [
            'id', 'course_code', 'course_name', 'english_name',
            'credit', 'hours', 'department', 'semester', 'year',
            'teachers', 'teachers_info', 'is_required', 'description',
            'syllabus_file', 'course_objectives', 'classes_count', 'has_grading_policy',
            'grading_policy', 'created_at', 'updated_at'
        ]
        read_only_fields = ['created_at', 'updated_at', 'syllabus_file']

    def get_teachers_info(self, obj):
        """获取教师信息"""
        return [{
            'id': t.id,
            'name': t.first_name or t.username,
            'username': t.username
        } for t in obj.teachers.all()]

    def get_classes_count(self, obj):
        """获取班级数量"""
        return obj.classes.count()

    def get_has_grading_policy(self, obj):
        """是否有评分政策"""
        return hasattr(obj, 'grading_policy')

    def validate_course_code(self, value):
        """验证课程代码唯一性"""
        if self.instance and self.instance.course_code == value:
            return value
        if Course.objects.filter(course_code=value).exists():
            raise serializers.ValidationError("课程代码已存在")
        return value


class CourseClassSerializer(serializers.ModelSerializer):
    """课程班级序列化器"""
    course_name = serializers.CharField(source='course.course_name', read_only=True)
    course_code = serializers.CharField(source='course.course_code', read_only=True)
    course_department = serializers.CharField(source='course.department', read_only=True)
    course_hours = serializers.IntegerField(source='course.hours', read_only=True)
    main_teacher_name = serializers.SerializerMethodField()
    students_count = serializers.SerializerMethodField()
    assistant_teachers_info = serializers.SerializerMethodField()

    def get_main_teacher_name(self, obj):
        """获取主讲教师姓名"""
        if obj.main_teacher:
            return obj.main_teacher.first_name or obj.main_teacher.username or ''
        return ''

    class Meta:
        model = CourseClass
        fields = [
            'id', 'course', 'course_name', 'course_code', 'course_department', 'course_hours',
            'class_name', 'main_teacher', 'main_teacher_name',
            'assistant_teachers', 'assistant_teachers_info',
            'students', 'students_count', 'max_students',
            'class_time', 'classroom'
        ]

    def get_students_count(self, obj):
        """获取学生数量"""
        return obj.students.count()

    def get_assistant_teachers_info(self, obj):
        """获取助教信息"""
        return [{
            'id': t.id,
            'name': t.first_name or t.username,
            'username': t.username
        } for t in obj.assistant_teachers.all()]


class EnrollmentSerializer(serializers.ModelSerializer):
    """选课记录序列化器"""
    student_name = serializers.CharField(source='student.first_name', read_only=True)
    student_id = serializers.SerializerMethodField()
    course_name = serializers.CharField(source='course_class.course.course_name', read_only=True)
    class_name = serializers.CharField(source='course_class.class_name', read_only=True)
    student_info = serializers.SerializerMethodField()

    class Meta:
        model = Enrollment
        fields = [
            'id', 'student', 'student_name', 'student_id', 'student_info',
            'course_class', 'course_name', 'class_name',
            'enrolled_at', 'is_active'
        ]
        read_only_fields = ['enrolled_at']

    def get_student_id(self, obj):
        """获取学号"""
        try:
            if hasattr(obj.student, 'student_profile') and obj.student.student_profile:
                return obj.student.student_profile.student_id
        except:
            pass
        return obj.student.employee_id or obj.student.username

    def get_student_info(self, obj):
        """获取学生详细信息"""
        try:
            if hasattr(obj.student, 'student_profile') and obj.student.student_profile:
                profile = obj.student.student_profile
                return {
                    'student_id': profile.student_id,
                    'major': profile.major,
                    'grade': profile.grade,
                    'class_name': profile.class_name
                }
        except:
            pass
        return {
            'student_id': obj.student.employee_id or obj.student.username,
            'major': '',
            'grade': None,
            'class_name': ''
        }

