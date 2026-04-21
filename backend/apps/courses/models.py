from django.db import models
from django.utils.translation import gettext_lazy as _
from apps.users.models import User


class Course(models.Model):
    """课程模型"""
    SEMESTER_CHOICES = (
        ('spring', '春季学期'),
        ('autumn', '秋季学期'),
        ('summer', '夏季学期'),
        ('winter', '冬季学期'),
    )

    course_code = models.CharField(
        max_length=50,
        unique=True,
        verbose_name='课程代码'
    )
    course_name = models.CharField(
        max_length=200,
        verbose_name='课程名称'
    )
    english_name = models.CharField(
        max_length=200,
        null=True,
        blank=True,
        verbose_name='英文名称'
    )
    credit = models.FloatField(
        verbose_name='学分'
    )
    hours = models.IntegerField(
        verbose_name='学时'
    )
    department = models.CharField(
        max_length=100,
        verbose_name='开课院系'
    )
    semester = models.CharField(
        max_length=20,
        choices=SEMESTER_CHOICES,
        verbose_name='开课学期'
    )
    year = models.IntegerField(
        verbose_name='开课年份'
    )
    teachers = models.ManyToManyField(
        User,
        related_name='courses_taught',
        limit_choices_to={'user_type': 'teacher'},
        verbose_name='授课教师'
    )
    is_required = models.BooleanField(
        default=True,
        verbose_name='是否必修'
    )
    description = models.TextField(
        null=True,
        blank=True,
        verbose_name='课程描述'
    )
    syllabus_file = models.FileField(
        upload_to='syllabus/',
        null=True,
        blank=True,
        verbose_name='教学大纲文件'
    )
    # 课程目标配置
    course_objectives = models.JSONField(
        default=list,
        verbose_name='课程目标配置',
        help_text='存储课程目标1、2、3的配置信息，包括权重、计算公式等'
    )
    created_at = models.DateTimeField(
        auto_now_add=True,
        verbose_name='创建时间'
    )
    updated_at = models.DateTimeField(
        auto_now=True,
        verbose_name='更新时间'
    )

    class Meta:
        verbose_name = '课程'
        verbose_name_plural = '课程管理'
        ordering = ['-year', 'semester', 'course_code']

    def __str__(self):
        return f"{self.course_code} - {self.course_name}"


class CourseClass(models.Model):
    """课程班级关系"""
    course = models.ForeignKey(
        Course,
        on_delete=models.CASCADE,
        related_name='classes'
    )
    class_name = models.CharField(
        max_length=50,
        verbose_name='班级名称'
    )
    main_teacher = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        related_name='main_classes',
        verbose_name='主讲教师'
    )
    assistant_teachers = models.ManyToManyField(
        User,
        related_name='assistant_classes',
        blank=True,
        verbose_name='助教'
    )
    students = models.ManyToManyField(
        User,
        through='Enrollment',
        related_name='enrolled_classes',
        verbose_name='选课学生'
    )
    max_students = models.IntegerField(
        default=100,
        verbose_name='最大学生数'
    )
    class_time = models.CharField(
        max_length=200,
        null=True,
        blank=True,
        verbose_name='上课时间'
    )
    classroom = models.CharField(
        max_length=100,
        null=True,
        blank=True,
        verbose_name='教室'
    )

    class Meta:
        verbose_name = '课程班级'
        verbose_name_plural = '课程班级'
        unique_together = ['course', 'class_name']

    def __str__(self):
        return f"{self.course.course_name} - {self.class_name}"


class Enrollment(models.Model):
    """学生选课记录"""
    student = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        verbose_name='学生'
    )
    course_class = models.ForeignKey(
        CourseClass,
        on_delete=models.CASCADE,
        verbose_name='课程班级'
    )
    enrolled_at = models.DateTimeField(
        auto_now_add=True,
        verbose_name='选课时间'
    )
    is_active = models.BooleanField(
        default=True,
        verbose_name='是否在修'
    )

    class Meta:
        verbose_name = '选课记录'
        verbose_name_plural = '选课记录'
        unique_together = ['student', 'course_class']

    def __str__(self):
        return f"{self.student.username} - {self.course_class}"


class GradingPolicy(models.Model):
    """成绩评定政策"""
    course = models.OneToOneField(
        Course,
        on_delete=models.CASCADE,
        related_name='grading_policy'
    )
    # 平时分比例（0-1）
    usual_weight = models.FloatField(
        default=0.3,
        verbose_name='平时分比例'
    )
    # 期末分比例
    final_weight = models.FloatField(
        default=0.7,
        verbose_name='期末分比例'
    )
    # 平时分内部构成
    attendance_weight = models.FloatField(
        default=0.2,
        verbose_name='考勤权重'
    )
    homework_weight = models.FloatField(
        default=0.3,
        verbose_name='作业权重'
    )
    experiment_weight = models.FloatField(
        default=0.3,
        verbose_name='实验权重'
    )
    review_note_weight = models.FloatField(
        default=0.2,
        verbose_name='复习笔记权重'
    )
    # 评分标准
    grading_scale = models.JSONField(
        default=dict,
        verbose_name='评分标准'
    )
    created_at = models.DateTimeField(
        auto_now_add=True,
        verbose_name='创建时间'
    )

    class Meta:
        verbose_name = '成绩评定政策'
        verbose_name_plural = '成绩评定政策'

    def __str__(self):
        return f"{self.course.course_name} 评定政策"


class CourseObjectiveAchievement(models.Model):
    """课程目标达成度记录"""
    score = models.ForeignKey(
        'scores.Score',
        on_delete=models.CASCADE,
        related_name='objective_achievements',
        verbose_name='成绩记录'
    )
    objective_number = models.IntegerField(
        choices=[(1, '课程目标1'), (2, '课程目标2'), (3, '课程目标3')],
        verbose_name='课程目标编号'
    )
    # 各组成部分得分
    usual_score = models.FloatField(
        default=0,
        verbose_name='平时得分'
    )
    experiment_score = models.FloatField(
        default=0,
        verbose_name='实验得分'
    )
    final_score = models.FloatField(
        default=0,
        verbose_name='期末得分'
    )
    # 达成情况（总分）
    achievement_score = models.FloatField(
        default=0,
        verbose_name='达成情况'
    )
    # 达成度（0-1之间的小数）
    achievement_degree = models.FloatField(
        default=0,
        verbose_name='达成度'
    )
    # 目标满分（用于计算达成度）
    max_score = models.FloatField(
        default=31,
        verbose_name='目标满分'
    )
    created_at = models.DateTimeField(
        auto_now_add=True,
        verbose_name='创建时间'
    )
    updated_at = models.DateTimeField(
        auto_now=True,
        verbose_name='更新时间'
    )

    class Meta:
        verbose_name = '课程目标达成度'
        verbose_name_plural = '课程目标达成度'
        unique_together = ['score', 'objective_number']
        ordering = ['objective_number']

    def __str__(self):
        return f"{self.score.student.username} - 课程目标{self.objective_number}"
