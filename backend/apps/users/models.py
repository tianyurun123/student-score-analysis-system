# 数据模型
from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils.translation import gettext_lazy as _


class User(AbstractUser):
    """扩展用户模型"""
    USER_TYPE_CHOICES = (
        ('admin', '系统管理员'),
        ('teacher', '教师'),
        ('student', '学生'),
        ('department', '院系管理员'),
        ('counselor', '辅导员'),
    )

    user_type = models.CharField(
        max_length=20,
        choices=USER_TYPE_CHOICES,
        default='teacher',
        verbose_name='用户类型'
    )
    employee_id = models.CharField(
        max_length=50,
        unique=True,
        null=True,
        blank=True,
        verbose_name='工号/学号'
    )
    department = models.CharField(
        max_length=100,
        null=True,
        blank=True,
        verbose_name='所属院系'
    )
    phone = models.CharField(
        max_length=20,
        null=True,
        blank=True,
        verbose_name='联系电话'
    )
    avatar = models.ImageField(
        upload_to='avatars/',
        null=True,
        blank=True,
        verbose_name='头像'
    )
    is_verified = models.BooleanField(
        default=False,
        verbose_name='是否已验证'
    )
    last_login_ip = models.GenericIPAddressField(
        null=True,
        blank=True,
        verbose_name='最后登录IP'
    )
    login_count = models.IntegerField(
        default=0,
        verbose_name='登录次数'
    )

    class Meta:
        verbose_name = '用户'
        verbose_name_plural = '用户管理'
        ordering = ['-date_joined']

    def __str__(self):
        return f"{self.username} ({self.get_user_type_display()})"


class TeacherProfile(models.Model):
    """教师详细信息"""
    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name='teacher_profile'
    )
    title = models.CharField(
        max_length=50,
        null=True,
        blank=True,
        verbose_name='职称'
    )
    research_field = models.CharField(
        max_length=200,
        null=True,
        blank=True,
        verbose_name='研究方向'
    )
    office = models.CharField(
        max_length=100,
        null=True,
        blank=True,
        verbose_name='办公室'
    )

    class Meta:
        verbose_name = '教师信息'
        verbose_name_plural = '教师信息'

    def __str__(self):
        return f"{self.user.username} - {self.title or '教师'}"


class StudentProfile(models.Model):
    """学生详细信息"""
    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name='student_profile'
    )
    student_id = models.CharField(
        max_length=50,
        unique=True,
        verbose_name='学号'
    )
    grade = models.IntegerField(
        verbose_name='年级'
    )
    class_name = models.CharField(
        max_length=50,
        verbose_name='班级'
    )
    major = models.CharField(
        max_length=100,
        verbose_name='专业'
    )
    enrollment_date = models.DateField(
        verbose_name='入学日期'
    )
    expected_graduation = models.DateField(
        verbose_name='预计毕业日期'
    )

    class Meta:
        verbose_name = '学生信息'
        verbose_name_plural = '学生信息'
        ordering = ['grade', 'class_name', 'student_id']

    def __str__(self):
        return f"{self.student_id} - {self.user.username}"