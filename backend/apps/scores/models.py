from django.db import models
from django.utils.translation import gettext_lazy as _
from apps.users.models import User
from apps.courses.models import CourseClass, GradingPolicy


class Score(models.Model):
    """成绩模型"""
    student = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='scores',
        verbose_name='学生'
    )
    course_class = models.ForeignKey(
        CourseClass,
        on_delete=models.CASCADE,
        related_name='scores',
        verbose_name='课程班级'
    )
    grading_policy = models.ForeignKey(
        GradingPolicy,
        on_delete=models.SET_NULL,
        null=True,
        verbose_name='评分政策'
    )

    # 平时分各项 - 支持动态字段
    attendance_score = models.FloatField(
        null=True,
        blank=True,
        verbose_name='考勤成绩'
    )
    homework_score = models.FloatField(
        null=True,
        blank=True,
        verbose_name='作业成绩'
    )
    experiment_score = models.FloatField(
        null=True,
        blank=True,
        verbose_name='实验成绩'
    )
    review_note_score = models.FloatField(
        null=True,
        blank=True,
        verbose_name='复习笔记成绩'
    )
    # 支持其他动态字段（如电子笔记、作品、报告等）
    extra_scores = models.JSONField(
        default=dict,
        verbose_name='额外成绩字段',
        help_text='存储动态成绩字段，如电子笔记、作品、报告等'
    )

    # 期末成绩
    final_score = models.FloatField(
        null=True,
        blank=True,
        verbose_name='期末成绩'
    )

    # 计算后成绩
    usual_total = models.FloatField(
        null=True,
        blank=True,
        verbose_name='平时总分'
    )
    final_total = models.FloatField(
        null=True,
        blank=True,
        verbose_name='期末总分'
    )
    # 手动录入的成绩（用于最终成绩计算）
    usual_entry = models.FloatField(
        null=True,
        blank=True,
        verbose_name='平时录入',
        help_text='手动录入的平时成绩，用于最终成绩计算'
    )
    final_entry = models.FloatField(
        null=True,
        blank=True,
        verbose_name='期末录入',
        help_text='手动录入的期末成绩，用于最终成绩计算'
    )
    final_grade = models.FloatField(
        null=True,
        blank=True,
        verbose_name='最终成绩'
    )
    grade_point = models.FloatField(
        null=True,
        blank=True,
        verbose_name='绩点'
    )
    grade_level = models.CharField(
        max_length=10,
        null=True,
        blank=True,
        verbose_name='等级'
    )

    # 状态
    is_published = models.BooleanField(
        default=False,
        verbose_name='是否已发布'
    )
    published_at = models.DateTimeField(
        null=True,
        blank=True,
        verbose_name='发布时间'
    )
    is_verified = models.BooleanField(
        default=False,
        verbose_name='是否已验证'
    )

    # 审计字段
    created_by = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        related_name='created_scores',
        verbose_name='创建人'
    )
    updated_by = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        related_name='updated_scores',
        verbose_name='更新人'
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
        verbose_name = '成绩记录'
        verbose_name_plural = '成绩记录'
        unique_together = ['student', 'course_class']
        ordering = ['-updated_at']

    def __str__(self):
        return f"{self.student.username} - {self.course_class}"

    def calculate_grade(self):
        """计算最终成绩"""
        # 检查是否是图形学课程
        is_graphics_course = False
        try:
            if hasattr(self.course_class, 'course') and self.course_class.course:
                is_graphics_course = '图形学' in self.course_class.course.course_name
        except:
            pass

        # 获取评分公式配置
        grading_scale = {}
        usual_formula = None
        final_formula = None
        
        if self.grading_policy:
            grading_scale = self.grading_policy.grading_scale or {}
            usual_formula = grading_scale.get('usual_formula')
            final_formula = grading_scale.get('final_formula')

        # 如果有自定义公式，使用自定义公式计算
        if usual_formula:
            self.usual_total = self._calculate_with_formula(usual_formula)
        else:
            # 默认计算方式：平时成绩 = (点名*0.05+电子笔记*0.05+作业成绩*0.1)/0.2
            attendance = self.attendance_score or 0  # 点名
            e_notes = self.extra_scores.get('电子笔记', 0) or 0  # 电子笔记
            homework = self.homework_score or 0  # 作业成绩

            if (attendance + e_notes + homework) > 0:
                self.usual_total = (attendance * 0.05 + e_notes * 0.05 + homework * 0.1) / 0.2
            else:
                # 如果没有这些数据，使用旧的加权平均方式
                usual_scores = {
                    'attendance': self.attendance_score or 0,
                    'homework': self.homework_score or 0,
                    'experiment': self.experiment_score or 0,
                    'review_note': self.review_note_score or 0,
                }
                if self.extra_scores:
                    usual_scores.update(self.extra_scores)

                weights = {
                    'attendance': self.grading_policy.attendance_weight if self.grading_policy else 0.2,
                    'homework': self.grading_policy.homework_weight if self.grading_policy else 0.3,
                    'experiment': self.grading_policy.experiment_weight if self.grading_policy else 0.3,
                    'review_note': self.grading_policy.review_note_weight if self.grading_policy else 0.2,
                }

                total_weight = sum(weights.values())
                if total_weight > 0:
                    self.usual_total = sum(
                        score * weights.get(key, 0)
                        for key, score in usual_scores.items()
                    ) / total_weight
                else:
                    self.usual_total = sum(usual_scores.values()) / len(usual_scores) if usual_scores else 0

        # 计算期末分
        if final_formula:
            self.final_total = self._calculate_with_formula(final_formula)
        elif is_graphics_course:
            # 图形学课程：期末成绩 = (系统 + 报告) / 2，直接使用gradebook传入的final_score
            if self.final_score is not None:
                self.final_total = self.final_score
            else:
                self.final_total = 0
        else:
            # 默认期末平均计算公式：(实验*0.2+作品*0.3+报告*0.3)/0.8，直接取整（不四舍五入）
            experiment = self.experiment_score or 0
            work = self.extra_scores.get('作品', 0) or 0
            report = self.extra_scores.get('报告', 0) or 0

            if experiment > 0 or work > 0 or report > 0:
                self.final_total = int((experiment * 0.2 + work * 0.3 + report * 0.3) / 0.8)
            else:
                self.final_total = int(self.final_score) if self.final_score else 0

        # 计算平时录入和期末录入（总是重新计算）
        # 平时录入 = (平时成绩*0.2 + 实验*0.2) / 0.4，取整数
        experiment = self.experiment_score or 0
        if self.usual_total is not None:
            self.usual_entry = round((self.usual_total * 0.2 + experiment * 0.2) / 0.4)
        else:
            self.usual_entry = None

        # 期末录入 = 期末成绩（直接取整）
        if self.final_total is not None:
            self.final_entry = round(self.final_total)
        else:
            self.final_entry = None

        # 计算最终成绩
        # 最终成绩 = 平时录入*0.4 + 期末录入*0.6，取整数
        if self.usual_entry is not None and self.final_entry is not None:
            self.final_grade = round(self.usual_entry * 0.4 + self.final_entry * 0.6)
        else:
            # 如果没有录入值，使用计算值
            if self.usual_total is not None and self.final_total is not None:
                self.final_grade = round(self.usual_total * 0.4 + self.final_total * 0.6)
            else:
                self.final_grade = None

        # 计算绩点和等级
        self.calculate_grade_point()

        return self.final_grade

    def _calculate_with_formula(self, formula: str) -> float:
        """使用公式计算成绩"""
        try:
            from utils.calculator import ScoreCalculator
            
            # 构建变量字典
            variables = {
                '点名': self.attendance_score or 0,
                '考勤': self.attendance_score or 0,
                'attendance': self.attendance_score or 0,
                '电子笔记': self.extra_scores.get('电子笔记', 0) or 0,
                '作业成绩': self.homework_score or 0,
                '作业': self.homework_score or 0,
                'homework': self.homework_score or 0,
                '实验': self.experiment_score or 0,
                'experiment': self.experiment_score or 0,
                '复习笔记': self.review_note_score or 0,
                'review_note': self.review_note_score or 0,
                '作品': self.extra_scores.get('作品', 0) or 0,
                '报告': self.extra_scores.get('报告', 0) or 0,
                '期末': self.final_score or 0,
                'final': self.final_score or 0,
            }
            # 合并所有额外字段
            if self.extra_scores:
                for key, value in self.extra_scores.items():
                    if key not in variables:
                        variables[key] = value or 0

            # 使用计算器计算
            return ScoreCalculator._calculate_with_formula(variables, formula)

        except Exception as e:
            import logging
            logger = logging.getLogger(__name__)
            logger.error(f"公式计算失败: {formula}, 错误: {str(e)}")
            return 0.0

    def calculate_grade_point(self):
        """计算绩点和等级"""
        if not self.final_grade:
            return

        # 常见的绩点计算方法（可根据需要调整）
        if self.final_grade >= 90:
            self.grade_point = 4.0
            self.grade_level = 'A'
        elif self.final_grade >= 85:
            self.grade_point = 3.7
            self.grade_level = 'A-'
        elif self.final_grade >= 82:
            self.grade_point = 3.3
            self.grade_level = 'B+'
        elif self.final_grade >= 78:
            self.grade_point = 3.0
            self.grade_level = 'B'
        elif self.final_grade >= 75:
            self.grade_point = 2.7
            self.grade_level = 'B-'
        elif self.final_grade >= 72:
            self.grade_point = 2.3
            self.grade_level = 'C+'
        elif self.final_grade >= 68:
            self.grade_point = 2.0
            self.grade_level = 'C'
        elif self.final_grade >= 64:
            self.grade_point = 1.5
            self.grade_level = 'C-'
        elif self.final_grade >= 60:
            self.grade_point = 1.0
            self.grade_level = 'D'
        else:
            self.grade_point = 0.0
            self.grade_level = 'F'

    def save(self, *args, **kwargs):
        """保存时自动计算成绩和课程目标达成度"""
        # 检查是否跳过计算（用于批量导入优化）
        skip_calculation = kwargs.pop('skip_objective_calculation', False)
        
        # 无论是创建还是更新，都重新计算成绩（包括usual_entry和final_entry）
        self.calculate_grade()
        super().save(*args, **kwargs)
        
        # 计算课程目标达成度（可以跳过以优化批量导入性能）
        if not skip_calculation:
            try:
                from utils.objective_calculator import ObjectiveCalculator
                ObjectiveCalculator.save_objective_achievements(self)
            except Exception as e:
                import logging
                logger = logging.getLogger(__name__)
                logger.error(f"计算课程目标达成度失败: {str(e)}")


class ScoreImportLog(models.Model):
    """成绩导入日志"""
    IMPORT_STATUS = (
        ('pending', '等待中'),
        ('processing', '处理中'),
        ('completed', '已完成'),
        ('failed', '失败'),
        ('partial', '部分成功'),
    )

    file_name = models.CharField(
        max_length=255,
        verbose_name='文件名'
    )
    file_path = models.CharField(
        max_length=500,
        verbose_name='文件路径'
    )
    course_class = models.ForeignKey(
        CourseClass,
        on_delete=models.SET_NULL,
        null=True,
        verbose_name='课程班级'
    )
    imported_by = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        verbose_name='导入人'
    )
    total_rows = models.IntegerField(
        default=0,
        verbose_name='总行数'
    )
    success_rows = models.IntegerField(
        default=0,
        verbose_name='成功行数'
    )
    failed_rows = models.IntegerField(
        default=0,
        verbose_name='失败行数'
    )
    error_log = models.TextField(
        null=True,
        blank=True,
        verbose_name='错误日志'
    )
    column_mapping = models.JSONField(
        default=dict,
        verbose_name='列映射关系',
        help_text='存储Excel列名到系统字段的映射'
    )
    status = models.CharField(
        max_length=20,
        choices=IMPORT_STATUS,
        default='pending',
        verbose_name='状态'
    )
    created_at = models.DateTimeField(
        auto_now_add=True,
        verbose_name='导入时间'
    )
    completed_at = models.DateTimeField(
        null=True,
        blank=True,
        verbose_name='完成时间'
    )

    class Meta:
        verbose_name = '成绩导入日志'
        verbose_name_plural = '成绩导入日志'
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.file_name} - {self.get_status_display()}"


class ScoreAdjustment(models.Model):
    """成绩调整记录"""
    ADJUSTMENT_TYPES = (
        ('manual', '手动调整'),
        ('appeal', '成绩申诉'),
        ('error', '录入错误'),
        ('other', '其他'),
    )

    score = models.ForeignKey(
        Score,
        on_delete=models.CASCADE,
        related_name='adjustments',
        verbose_name='成绩记录'
    )
    adjustment_type = models.CharField(
        max_length=20,
        choices=ADJUSTMENT_TYPES,
        verbose_name='调整类型'
    )
    reason = models.TextField(
        verbose_name='调整原因'
    )
    original_value = models.JSONField(
        verbose_name='原始值'
    )
    new_value = models.JSONField(
        verbose_name='新值'
    )
    adjusted_by = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        verbose_name='调整人'
    )
    approved_by = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        related_name='approved_adjustments',
        verbose_name='批准人'
    )
    is_approved = models.BooleanField(
        default=False,
        verbose_name='是否批准'
    )
    created_at = models.DateTimeField(
        auto_now_add=True,
        verbose_name='申请时间'
    )
    updated_at = models.DateTimeField(
        auto_now=True,
        verbose_name='处理时间'
    )

    class Meta:
        verbose_name = '成绩调整记录'
        verbose_name_plural = '成绩调整记录'
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.score} - {self.get_adjustment_type_display()}"


class Gradebook(models.Model):
    """记分册模型 - 用于算法分析与设计等课程"""
    student = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='gradebooks',
        verbose_name='学生'
    )
    course_class = models.ForeignKey(
        CourseClass,
        on_delete=models.CASCADE,
        related_name='gradebooks',
        verbose_name='课程班级'
    )
    
    # 作业成绩（1-5）
    homework1 = models.FloatField(null=True, blank=True, verbose_name='作业1')
    homework2 = models.FloatField(null=True, blank=True, verbose_name='作业2')
    homework3 = models.FloatField(null=True, blank=True, verbose_name='作业3')
    homework4 = models.FloatField(null=True, blank=True, verbose_name='作业4')
    homework5 = models.FloatField(null=True, blank=True, verbose_name='作业5')
    
    # 实验成绩（1-2）
    experiment1 = models.FloatField(null=True, blank=True, verbose_name='实验1')
    experiment2 = models.FloatField(null=True, blank=True, verbose_name='实验2')
    
    # 考勤成绩（1-5）
    attendance1 = models.FloatField(null=True, blank=True, verbose_name='考勤1')
    attendance2 = models.FloatField(null=True, blank=True, verbose_name='考勤2')
    attendance3 = models.FloatField(null=True, blank=True, verbose_name='考勤3')
    attendance4 = models.FloatField(null=True, blank=True, verbose_name='考勤4')
    attendance5 = models.FloatField(null=True, blank=True, verbose_name='考勤5')
    
    # 复习笔记
    review_note = models.FloatField(null=True, blank=True, verbose_name='复习笔记')

    # 系统成绩和报告（图形学课程用）
    system_score = models.FloatField(null=True, blank=True, verbose_name='系统')
    report_score = models.FloatField(null=True, blank=True, verbose_name='报告')

    # 期末成绩
    final_score = models.FloatField(null=True, blank=True, verbose_name='期末成绩')

    # 计算后的成绩
    usual_score = models.FloatField(null=True, blank=True, verbose_name='平时成绩')
    total_score = models.FloatField(null=True, blank=True, verbose_name='总评成绩')
    conclusion = models.CharField(max_length=20, null=True, blank=True, verbose_name='结论')
    
    # 审计字段
    created_by = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        related_name='created_gradebooks',
        verbose_name='创建人'
    )
    updated_by = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        related_name='updated_gradebooks',
        verbose_name='更新人'
    )
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='更新时间')
    
    class Meta:
        verbose_name = '记分册'
        verbose_name_plural = '记分册'
        unique_together = ['student', 'course_class']
        ordering = ['-updated_at']
    
    def __str__(self):
        return f"{self.student.username} - {self.course_class}"
    
    def calculate_scores(self):
        """计算平时成绩和总评成绩（图形学课程用）
        公式：
        - 平时 = (AVERAGE(作业一到作业五)*0.1 + AVERAGE(实验一到实验二)*0.2 + AVERAGE(考勤1到考勤5)*0.05 + 复习笔记*0.05) / 0.4
        - 期末 = (系统 + 报告) / 2
        - 总评 = 平时*0.4 + 期末*0.6
        - 结论：>=90优秀，>=80良好，>=70中等，>=60及格，<60不及格
        """

        def round_half_up(x):
            """四舍五入（标准数学舍入）"""
            if x is None:
                return None
            import math
            return math.floor(x + 0.5)

        # 作业平均分
        homework_scores = [self.homework1, self.homework2, self.homework3, self.homework4, self.homework5]
        homework_scores = [s for s in homework_scores if s is not None]
        homework_avg = sum(homework_scores) / len(homework_scores) if homework_scores else 0

        # 实验平均分
        experiment_scores = [self.experiment1, self.experiment2]
        experiment_scores = [s for s in experiment_scores if s is not None]
        experiment_avg = sum(experiment_scores) / len(experiment_scores) if experiment_scores else 0

        # 考勤平均分
        attendance_scores = [self.attendance1, self.attendance2, self.attendance3, self.attendance4, self.attendance5]
        attendance_scores = [s for s in attendance_scores if s is not None]
        attendance_avg = sum(attendance_scores) / len(attendance_scores) if attendance_scores else 0

        # 复习笔记
        review_note_score = self.review_note or 0

        # 计算平时成绩
        # 平时 = (AVERAGE(作业一到作业五)*0.1 + AVERAGE(实验一到实验二)*0.2 + AVERAGE(考勤1到考勤5)*0.05 + 复习笔记*0.05) / 0.4
        usual_score = (
            homework_avg * 0.1 +
            experiment_avg * 0.2 +
            attendance_avg * 0.05 +
            review_note_score * 0.05
        ) / 0.4

        # 平时成绩四舍五入取整
        self.usual_score = round_half_up(usual_score) if usual_score > 0 else None

        # 计算期末成绩
        # 期末 = (系统 + 报告) / 2，取整数
        system_score = self.system_score or 0
        report_score = self.report_score or 0
        if system_score > 0 or report_score > 0:
            self.final_score = round_half_up((system_score + report_score) / 2)
        else:
            self.final_score = None

        # 计算总评成绩
        # 总评 = 平时*0.4 + 期末*0.6
        if self.usual_score is not None and self.final_score is not None:
            self.total_score = round_half_up(self.usual_score * 0.4 + self.final_score * 0.6)
        else:
            self.total_score = None

        # 计算结论
        # 结论：>=90优秀，>=80良好，>=70中等，>=60及格，<60不及格
        if self.total_score is not None:
            if self.total_score >= 90:
                self.conclusion = '优秀'
            elif self.total_score >= 80:
                self.conclusion = '良好'
            elif self.total_score >= 70:
                self.conclusion = '中等'
            elif self.total_score >= 60:
                self.conclusion = '及格'
            else:
                self.conclusion = '不及格'
        else:
            self.conclusion = None

        return self.total_score
    
    def save(self, *args, **kwargs):
        """保存时自动计算成绩，如果是图形学课程，自动创建或更新Score；如果是算法分析与设计课程，自动创建或更新AlgorithmScore"""
        self.calculate_scores()
        super().save(*args, **kwargs)

        # 如果是图形学课程，自动创建或更新Score
        try:
            course_name = self.course_class.course.course_name if hasattr(self.course_class, 'course') and self.course_class.course else ''
            if '图形学' in course_name:
                from apps.scores.models import Score
                score, created = Score.objects.get_or_create(
                    student=self.student,
                    course_class=self.course_class,
                    defaults={
                        'created_by': self.created_by,
                        'updated_by': self.updated_by
                    }
                )
                if not created:
                    score.updated_by = self.updated_by

                # 计算各字段值
                # 点名 = (考勤1+考勤2+考勤3+考勤4+考勤5)/5
                attendance_scores = [self.attendance1, self.attendance2, self.attendance3, self.attendance4, self.attendance5]
                attendance_scores = [s for s in attendance_scores if s is not None]
                attendance_avg = sum(attendance_scores) / len(attendance_scores) if attendance_scores else 0
                score.attendance_score = attendance_avg if attendance_avg > 0 else None

                # 电子笔记 = 复习笔记
                score.review_note_score = self.review_note
                if '电子笔记' not in score.extra_scores:
                    score.extra_scores['电子笔记'] = {}
                score.extra_scores['电子笔记'] = self.review_note

                # 作业成绩 = (作业一+作业二+作业三+作业四+作业五)/5
                homework_scores = [self.homework1, self.homework2, self.homework3, self.homework4, self.homework5]
                homework_scores = [s for s in homework_scores if s is not None]
                homework_avg = sum(homework_scores) / len(homework_scores) if homework_scores else 0
                score.homework_score = homework_avg if homework_avg > 0 else None

                # 实验 = (实验一+实验二)/2
                experiment_scores = [self.experiment1, self.experiment2]
                experiment_scores = [s for s in experiment_scores if s is not None]
                experiment_avg = sum(experiment_scores) / len(experiment_scores) if experiment_scores else 0
                score.experiment_score = experiment_avg if experiment_avg > 0 else None

                # 期末平均 = 记分册生成的期末列
                score.final_score = self.final_score

                # 作品 = 系统
                if '作品' not in score.extra_scores:
                    score.extra_scores['作品'] = {}
                score.extra_scores['作品'] = self.system_score

                # 报告 = 报告
                if '报告' not in score.extra_scores:
                    score.extra_scores['报告'] = {}
                score.extra_scores['报告'] = self.report_score

                # 保存Score（跳过课程目标计算，由Score自己的save处理）
                score.save(skip_objective_calculation=True)

                # 重新计算课程目标达成度
                try:
                    from utils.objective_calculator import ObjectiveCalculator
                    ObjectiveCalculator.save_objective_achievements(score)
                except Exception as e:
                    import logging
                    logger = logging.getLogger(__name__)
                    logger.warning(f"计算课程目标达成度失败: {str(e)}")

        except Exception as e:
            import logging
            logger = logging.getLogger(__name__)
            logger.warning(f"自动创建/更新Score失败: {str(e)}")

        # 如果是算法分析与设计课程，自动创建或更新AlgorithmScore
        try:
            course_name = self.course_class.course.course_name if hasattr(self.course_class, 'course') and self.course_class.course else ''
            if '算法分析与设计' in course_name or '算法设计与分析' in course_name:
                from apps.scores.models import AlgorithmScore
                algorithm_score, created = AlgorithmScore.objects.get_or_create(
                    student=self.student,
                    course_class=self.course_class,
                    defaults={
                        'gradebook': self,
                        'created_by': self.created_by,
                        'updated_by': self.updated_by
                    }
                )
                if not created:
                    # 如果已存在，更新gradebook引用
                    algorithm_score.gradebook = self
                    algorithm_score.updated_by = self.updated_by

                # 重新计算所有成绩（从记分册计算平时成绩部分）
                algorithm_score.calculate_all()
                algorithm_score.save()
        except Exception as e:
            import logging
            logger = logging.getLogger(__name__)
            logger.warning(f"自动创建/更新AlgorithmScore失败: {str(e)}")


class AlgorithmScore(models.Model):
    """算法分析与设计课程整合成绩模型"""
    gradebook = models.OneToOneField(
        Gradebook,
        on_delete=models.CASCADE,
        related_name='algorithm_score',
        verbose_name='记分册'
    )
    course_class = models.ForeignKey(
        CourseClass,
        on_delete=models.CASCADE,
        related_name='algorithm_scores',
        verbose_name='课程班级'
    )
    student = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='algorithm_scores',
        verbose_name='学生'
    )
    
    # 平时成绩组成部分（从记分册计算）
    class_performance = models.FloatField(null=True, blank=True, verbose_name='课堂表现（考勤平均）')
    note_score = models.FloatField(null=True, blank=True, verbose_name='笔记（复习笔记）')
    homework_avg = models.FloatField(null=True, blank=True, verbose_name='作业（作业平均）')
    experiment_avg = models.FloatField(null=True, blank=True, verbose_name='实验（实验平均）')
    usual_score = models.FloatField(null=True, blank=True, verbose_name='平时成绩')
    
    # 原始卷面成绩数据（存储各个小题的得分，JSON格式：{"M1": {"1": 10, "2": 15}, "M2": {"1": 8, "2": 6}, ...}）
    raw_paper_scores = models.JSONField(null=True, blank=True, default=dict, verbose_name='原始卷面成绩数据（小题得分）')
    
    # 期末成绩组成部分（从原始卷面成绩计算，在步骤3中计算）
    M1 = models.FloatField(null=True, blank=True, verbose_name='M1/35')
    M2 = models.FloatField(null=True, blank=True, verbose_name='M2/20')
    M3 = models.FloatField(null=True, blank=True, verbose_name='M3/35（存储35分制，计算时按31分制）')
    M4 = models.FloatField(null=True, blank=True, verbose_name='M4/10')
    final_paper_score = models.FloatField(null=True, blank=True, verbose_name='卷面成绩')
    
    # 课程目标1达成度
    obj1_classroom = models.FloatField(null=True, blank=True, verbose_name='课程目标1-课堂')
    obj1_note = models.FloatField(null=True, blank=True, verbose_name='课程目标1-笔记')
    obj1_homework = models.FloatField(null=True, blank=True, verbose_name='课程目标1-作业')
    obj1_experiment = models.FloatField(null=True, blank=True, verbose_name='课程目标1-实验')
    obj1_final = models.FloatField(null=True, blank=True, verbose_name='课程目标1-期末')
    obj1_achievement = models.FloatField(null=True, blank=True, verbose_name='课程目标1-达成情况')
    obj1_degree = models.FloatField(null=True, blank=True, verbose_name='课程目标1-达成度')
    
    # 课程目标2达成度
    obj2_classroom = models.FloatField(null=True, blank=True, verbose_name='课程目标2-课堂')
    obj2_note = models.FloatField(null=True, blank=True, verbose_name='课程目标2-笔记')
    obj2_homework = models.FloatField(null=True, blank=True, verbose_name='课程目标2-作业')
    obj2_experiment = models.FloatField(null=True, blank=True, verbose_name='课程目标2-实验')
    obj2_final = models.FloatField(null=True, blank=True, verbose_name='课程目标2-期末')
    obj2_achievement = models.FloatField(null=True, blank=True, verbose_name='课程目标2-达成情况')
    obj2_degree = models.FloatField(null=True, blank=True, verbose_name='课程目标2-达成度')
    
    # 课程目标3达成度
    obj3_classroom = models.FloatField(null=True, blank=True, verbose_name='课程目标3-课堂')
    obj3_note = models.FloatField(null=True, blank=True, verbose_name='课程目标3-笔记')
    obj3_homework = models.FloatField(null=True, blank=True, verbose_name='课程目标3-作业')
    obj3_experiment = models.FloatField(null=True, blank=True, verbose_name='课程目标3-实验')
    obj3_final = models.FloatField(null=True, blank=True, verbose_name='课程目标3-期末')
    obj3_achievement = models.FloatField(null=True, blank=True, verbose_name='课程目标3-达成情况')
    obj3_degree = models.FloatField(null=True, blank=True, verbose_name='课程目标3-达成度')
    
    # 课程目标4达成度
    obj4_classroom = models.FloatField(null=True, blank=True, verbose_name='课程目标4-课堂')
    obj4_note = models.FloatField(null=True, blank=True, verbose_name='课程目标4-笔记')
    obj4_homework = models.FloatField(null=True, blank=True, verbose_name='课程目标4-作业')
    obj4_experiment = models.FloatField(null=True, blank=True, verbose_name='课程目标4-实验')
    obj4_final = models.FloatField(null=True, blank=True, verbose_name='课程目标4-期末')
    obj4_achievement = models.FloatField(null=True, blank=True, verbose_name='课程目标4-达成情况')
    obj4_degree = models.FloatField(null=True, blank=True, verbose_name='课程目标4-达成度')
    
    # 总成绩和成绩录入
    total_score = models.FloatField(null=True, blank=True, verbose_name='总成绩')
    usual_entry = models.FloatField(null=True, blank=True, verbose_name='平时录入')
    final_entry = models.FloatField(null=True, blank=True, verbose_name='期末录入')
    final_grade = models.FloatField(null=True, blank=True, verbose_name='最终成绩')
    
    # 审计字段
    created_by = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        related_name='created_algorithm_scores',
        verbose_name='创建人'
    )
    updated_by = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        related_name='updated_algorithm_scores',
        verbose_name='更新人'
    )
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='更新时间')
    
    class Meta:
        verbose_name = '算法分析与设计成绩'
        verbose_name_plural = '算法分析与设计成绩'
        unique_together = ['student', 'course_class']
        ordering = ['-updated_at']
    
    def __str__(self):
        return f"{self.student.username} - {self.course_class}"
    
    def calculate_from_gradebook(self):
        """从记分册计算平时成绩组成部分"""
        if not self.gradebook:
            return
        
        # 课堂表现 = 五个考勤求平均值
        attendance_scores = [
            self.gradebook.attendance1,
            self.gradebook.attendance2,
            self.gradebook.attendance3,
            self.gradebook.attendance4,
            self.gradebook.attendance5
        ]
        attendance_scores = [s for s in attendance_scores if s is not None]
        self.class_performance = round(sum(attendance_scores) / len(attendance_scores), 2) if attendance_scores else None
        
        # 笔记 = 复习笔记
        self.note_score = round(self.gradebook.review_note, 2) if self.gradebook.review_note is not None else None
        
        # 作业 = 五个作业求平均值
        homework_scores = [
            self.gradebook.homework1,
            self.gradebook.homework2,
            self.gradebook.homework3,
            self.gradebook.homework4,
            self.gradebook.homework5
        ]
        homework_scores = [s for s in homework_scores if s is not None]
        self.homework_avg = round(sum(homework_scores) / len(homework_scores), 2) if homework_scores else None
        
        # 实验 = 两个实验求平均值
        experiment_scores = [self.gradebook.experiment1, self.gradebook.experiment2]
        experiment_scores = [s for s in experiment_scores if s is not None]
        self.experiment_avg = round(sum(experiment_scores) / len(experiment_scores), 2) if experiment_scores else None
        
        # 平时成绩 = 记分册中的平时成绩（已经是整数）
        self.usual_score = self.gradebook.usual_score
    
    def calculate_objectives(self):
        """计算课程目标1-4的达成度"""
        if not self.gradebook:
            return
        
        # 获取基础数据
        class_perf = self.class_performance or 0
        note = self.note_score or 0
        homework = self.homework_avg or 0
        experiment = self.experiment_avg or 0
        
        # 课程目标1
        self.obj1_classroom = round(class_perf * 0.05 * 0.4, 2)
        self.obj1_note = round(note * 0.05 * 0.4, 2)
        self.obj1_homework = round(homework * 0.1 * 0.4, 2)
        self.obj1_experiment = 0.0
        self.obj1_final = round((self.M1 or 0) * 0.6, 2)
        self.obj1_achievement = round(
            self.obj1_classroom + self.obj1_note + self.obj1_homework + 
            self.obj1_experiment + self.obj1_final, 2
        )
        self.obj1_degree = round(self.obj1_achievement / 29, 2) if self.obj1_achievement else 0.0
        
        # 课程目标2
        self.obj2_classroom = round(class_perf * 0.05 * 0.3, 2)
        self.obj2_note = round(note * 0.05 * 0.3, 2)
        self.obj2_homework = round(homework * 0.1 * 0.3, 2)
        self.obj2_experiment = round(experiment * 0.2 * 0.4, 2)
        self.obj2_final = round((self.M2 or 0) * 0.6, 2)
        self.obj2_achievement = round(
            self.obj2_classroom + self.obj2_note + self.obj2_homework + 
            self.obj2_experiment + self.obj2_final, 2
        )
        self.obj2_degree = round(self.obj2_achievement / 26, 2) if self.obj2_achievement else 0.0
        
        # 课程目标3 - M3按31分制计算（用户需求：M3/31）
        self.obj3_classroom = round(class_perf * 0.05 * 0.3, 2)
        self.obj3_note = round(note * 0.05 * 0.3, 2)
        self.obj3_homework = round(homework * 0.1 * 0.3, 2)
        self.obj3_experiment = round(experiment * 0.2 * 0.2, 2)
        # M3实际存储是35分制，但计算时按31分制转换：M3/31*0.6
        # 如果M3是35分制，需要转换为31分制：M3_31 = M3 * 31 / 35
        m3_score = (self.M3 or 0) * 31 / 35 if self.M3 else 0  # 转换为31分制
        self.obj3_final = round(m3_score * 0.6, 2)
        self.obj3_achievement = round(
            self.obj3_classroom + self.obj3_note + self.obj3_homework + 
            self.obj3_experiment + self.obj3_final, 2
        )
        # 课程目标3满分是31分
        self.obj3_degree = round(self.obj3_achievement / 31.0, 2) if self.obj3_achievement else 0.0
        
        # 课程目标4
        self.obj4_classroom = 0.0
        self.obj4_note = 0.0
        self.obj4_homework = 0.0
        self.obj4_experiment = round(experiment * 0.2 * 0.4, 2)
        self.obj4_final = round((self.M4 or 0) * 0.6, 2)
        self.obj4_achievement = round(
            self.obj4_classroom + self.obj4_note + self.obj4_homework + 
            self.obj4_experiment + self.obj4_final, 2
        )
        self.obj4_degree = round(self.obj4_achievement / 14, 2) if self.obj4_achievement else 0.0
    
    def calculate_from_raw_paper_scores(self, m_config=None):
        """从原始卷面成绩数据计算M1, M2, M3, M4和卷面成绩
        支持通过m_config配置每个M对应的列
        
        默认配置：
        M1/35 = 第一大题成绩（"一"） + 第三大题第一小题的成绩（"三"的"1"）
        M2/20 = 第二大题第二小题的成绩（"二"的"2"） + 第二大题第三小题的成绩（"二"的"3"）
        M3/35 = 第二大题第一小题的成绩（"二"的"1"） + 第三大题第二小题的成绩（"三"的"2"） + 第三大题第三小题的成绩（"三"的"3"）
        M4/10 = 第四大题成绩（"四"）
        卷面 = 本地导入的表格的卷面（"卷面"字段） = M1/35 + M2/20 + M3/35 + M4/10
        
        m_config格式：{
            'M1': ['一-total', '三-1'],
            'M2': ['二-2', '二-3'],
            'M3': ['二-1', '三-2', '三-3'],
            'M4': ['四-total']
        }
        """
        if not self.raw_paper_scores:
            # 如果没有原始数据，清空M1-M4和卷面成绩
            self.M1 = None
            self.M2 = None
            self.M3 = None
            self.M4 = None
            self.final_paper_score = None
            return
        
        scores = self.raw_paper_scores
        
        # 如果没有配置，使用默认配置
        if m_config is None:
            m_config = {
                'M1': ['一-total', '三-1'],
                'M2': ['二-2', '二-3'],
                'M3': ['二-1', '三-2', '三-3'],
                'M4': ['四-total']
            }
        
        # 辅助函数：根据配置计算M值
        def calculate_m_value(m_config_list):
            """根据配置列表计算M值
            m_config_list格式：['一-total', '三-1'] 表示第一大题总分 + 第三大题第一小题
            """
            total = 0.0
            for config_item in m_config_list:
                # 解析配置项，格式：'一-total' 或 '三-1'
                parts = config_item.split('-')
                if len(parts) != 2:
                    continue
                section_key = parts[0]  # '一', '二', '三', '四'
                sub_key = parts[1]      # 'total', '1', '2', '3'
                
                if section_key not in scores:
                    continue
                
                section = scores[section_key]
                if isinstance(section, dict):
                    if sub_key == 'total':
                        if 'total' in section:
                            total += float(section['total'])
                        else:
                            # 如果没有total，计算所有小题之和
                            total += sum(float(v) for k, v in section.items() if isinstance(v, (int, float)))
                    else:
                        # 查找对应的小题（处理"1"、"1.0"等格式）
                        for key in section.keys():
                            key_str = str(key).strip()
                            try:
                                if float(key_str) == float(sub_key):
                                    total += float(section[key])
                                    break
                            except (ValueError, TypeError):
                                pass
                elif isinstance(section, (int, float)):
                    # 如果不是字典，直接使用值
                    total += float(section)
            return total
        
        # 根据配置计算M1-M4
        # 使用传入的配置，如果没有则使用默认值
        M1_config = m_config.get('M1', ['一-total', '三-1'])
        M2_config = m_config.get('M2', ['二-2', '二-3'])
        M3_config = m_config.get('M3', ['二-1', '三-2', '三-3'])
        M4_config = m_config.get('M4', ['四-total'])
        
        # 记录使用的配置（用于调试）
        import logging
        logger = logging.getLogger(__name__)
        logger.info(f"计算M值使用的配置 - M1: {M1_config}, M2: {M2_config}, M3: {M3_config}, M4: {M4_config}")
        
        M1 = calculate_m_value(M1_config)
        M2 = calculate_m_value(M2_config)
        M3 = calculate_m_value(M3_config)
        M4 = calculate_m_value(M4_config)
        
        # 卷面 = 本地导入的表格的卷面（"卷面"字段），如果不存在则使用计算值
        if '卷面' in scores:
            section_paper = scores['卷面']
            if isinstance(section_paper, dict):
                if 'total' in section_paper:
                    final_paper_score = float(section_paper['total'])
                else:
                    # 如果没有total，使用计算值
                    final_paper_score = round(M1 + M2 + M3 + M4, 2)
            elif isinstance(section_paper, (int, float)):
                final_paper_score = float(section_paper)
            else:
                # 如果格式不对，使用计算值
                final_paper_score = round(M1 + M2 + M3 + M4, 2)
        else:
            # 如果没有"卷面"字段，使用计算值
            final_paper_score = round(M1 + M2 + M3 + M4, 2)
        
        # 保存计算结果，限制M1-M4的最大值，确保不超过各自满分
        self.M1 = round(min(M1, 35.0), 2)  # M1满分35
        self.M2 = round(min(M2, 20.0), 2)  # M2满分20
        self.M3 = round(min(M3, 35.0), 2)  # M3满分35
        self.M4 = round(min(M4, 10.0), 2)  # M4满分10
        self.final_paper_score = round(final_paper_score, 2)
    
    def calculate_final_scores(self):
        """计算最终成绩"""
        # 总成绩 = 记分册中的总评
        self.total_score = self.gradebook.total_score if self.gradebook else None
        
        # 成绩录入
        self.usual_entry = self.usual_score  # 平时录入 = 平时成绩
        self.final_entry = self.final_paper_score  # 期末录入 = 卷面
        self.final_grade = self.total_score  # 最终成绩 = 总成绩
    
    def calculate_all(self, m_config=None):
        """计算所有成绩
        m_config: M列配置，格式：{
            'M1': ['一-total', '三-1'],
            'M2': ['二-2', '二-3'],
            'M3': ['二-1', '三-2', '三-3'],
            'M4': ['四-total']
        }
        """
        self.calculate_from_gradebook()
        # 从原始卷面成绩数据计算M1-M4和卷面成绩
        self.calculate_from_raw_paper_scores(m_config=m_config)
        self.calculate_objectives()
        self.calculate_final_scores()
    
    def save(self, *args, **kwargs):
        """保存时自动计算成绩（如果已有关键数据）
        
        如果 kwargs 中有 'skip_m_calculation' 为 True，则跳过M值的自动计算
        （用于手动计算时避免重复计算）
        """
        skip_m_calculation = kwargs.pop('skip_m_calculation', False)
        
        # 只有在有gradebook时才计算平时成绩部分
        if self.gradebook:
            self.calculate_from_gradebook()
        # 只有在有原始卷面成绩数据时才计算M1-M4（除非跳过）
        if self.raw_paper_scores and not skip_m_calculation:
            # 尝试从实例获取保存的m_config
            m_config = getattr(self, '_saved_m_config', None)
            self.calculate_from_raw_paper_scores(m_config=m_config)
        # 只有在有平时成绩和卷面成绩时才计算课程目标和最终成绩
        if self.gradebook and self.raw_paper_scores and self.M1 is not None:
            self.calculate_objectives()
            self.calculate_final_scores()
        super().save(*args, **kwargs)

