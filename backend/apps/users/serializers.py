# 序列化器
from rest_framework import serializers
from django.contrib.auth import authenticate
from .models import User, TeacherProfile, StudentProfile


class UserRegisterSerializer(serializers.Serializer):
    """用户注册序列化器"""
    username = serializers.CharField(required=True, max_length=150)
    password = serializers.CharField(required=True, write_only=True, min_length=6)
    email = serializers.EmailField(required=False, allow_blank=True)
    first_name = serializers.CharField(required=False, allow_blank=True, max_length=150)
    
    def validate_username(self, value):
        """验证用户名唯一性"""
        if User.objects.filter(username=value).exists():
            raise serializers.ValidationError('用户名已存在')
        return value
    
    def create(self, validated_data):
        """创建用户"""
        password = validated_data.pop('password')
        # 确保新注册的用户是teacher类型，可以访问所有功能
        validated_data['user_type'] = 'teacher'
        user = User.objects.create_user(password=password, **validated_data)
        return user


class UserLoginSerializer(serializers.Serializer):
    """用户登录序列化器"""
    username = serializers.CharField()
    password = serializers.CharField(write_only=True)

    def validate(self, data):
        username = data.get('username')
        password = data.get('password')

        user = authenticate(username=username, password=password)

        if not user:
            raise serializers.ValidationError('用户名或密码错误')

        if not user.is_active:
            raise serializers.ValidationError('用户已被禁用')

        data['user'] = user
        return data


class UserSerializer(serializers.ModelSerializer):
    """用户基本信息序列化器"""
    user_type_display = serializers.CharField(
        source='get_user_type_display',
        read_only=True
    )

    class Meta:
        model = User
        fields = [
            'id', 'username', 'email', 'user_type',
            'user_type_display', 'first_name', 'last_name',
            'department', 'phone', 'avatar', 'is_active',
            'date_joined', 'last_login'
        ]
        read_only_fields = ['date_joined', 'last_login']


class TeacherProfileSerializer(serializers.ModelSerializer):
    """教师信息序列化器"""
    user = UserSerializer(read_only=True)

    class Meta:
        model = TeacherProfile
        fields = ['id', 'user', 'title', 'research_field', 'office']
        read_only_fields = ['id', 'user']


class StudentProfileSerializer(serializers.ModelSerializer):
    """学生信息序列化器"""
    user = UserSerializer(read_only=True)

    class Meta:
        model = StudentProfile
        fields = '__all__'


class TeacherListSerializer(serializers.ModelSerializer):
    """教师列表序列化器（用于教师管理）"""
    user_type_display = serializers.CharField(
        source='get_user_type_display',
        read_only=True
    )
    teacher_profile = TeacherProfileSerializer(required=False, allow_null=True)
    courses_count = serializers.SerializerMethodField()
    classes_count = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = [
            'id', 'username', 'email', 'user_type', 'user_type_display',
            'first_name', 'last_name', 'employee_id', 'department', 'phone',
            'avatar', 'is_active', 'date_joined', 'last_login',
            'teacher_profile', 'courses_count', 'classes_count'
        ]
        read_only_fields = ['date_joined', 'last_login', 'user_type']

    def get_courses_count(self, obj):
        """获取授课课程数量"""
        return obj.courses_taught.count()

    def get_classes_count(self, obj):
        """获取主讲班级数量"""
        return obj.main_classes.count()


class TeacherCreateSerializer(serializers.ModelSerializer):
    """教师创建序列化器"""
    password = serializers.CharField(write_only=True, required=True)
    teacher_profile = TeacherProfileSerializer(required=False)

    class Meta:
        model = User
        fields = [
            'username', 'email', 'password', 'first_name', 'last_name',
            'employee_id', 'department', 'phone', 'avatar', 'is_active',
            'teacher_profile'
        ]

    def create(self, validated_data):
        """创建教师用户"""
        teacher_profile_data = validated_data.pop('teacher_profile', None)
        password = validated_data.pop('password')
        
        # 设置用户类型为教师
        validated_data['user_type'] = 'teacher'
        
        # 创建用户
        user = User.objects.create_user(password=password, **validated_data)
        
        # 创建教师详细信息
        if teacher_profile_data:
            TeacherProfile.objects.create(user=user, **teacher_profile_data)
        
        return user


class TeacherUpdateSerializer(serializers.ModelSerializer):
    """教师更新序列化器"""
    password = serializers.CharField(write_only=True, required=False)
    teacher_profile = TeacherProfileSerializer(required=False)

    class Meta:
        model = User
        fields = [
            'username', 'email', 'password', 'first_name', 'last_name',
            'employee_id', 'department', 'phone', 'avatar', 'is_active',
            'teacher_profile'
        ]

    def update(self, instance, validated_data):
        """更新教师用户"""
        teacher_profile_data = validated_data.pop('teacher_profile', None)
        password = validated_data.pop('password', None)
        
        # 更新用户基本信息
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        
        # 更新密码
        if password:
            instance.set_password(password)
        
        instance.save()
        
        # 更新或创建教师详细信息
        if teacher_profile_data:
            profile, created = TeacherProfile.objects.get_or_create(
                user=instance,
                defaults=teacher_profile_data
            )
            if not created:
                for attr, value in teacher_profile_data.items():
                    setattr(profile, attr, value)
                profile.save()
        
        return instance