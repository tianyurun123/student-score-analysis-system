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
    """记分册模型 - 用于计算机图形学课程"""
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
        """保存时自动计算成绩，并自动创建或更新Score"""
        self.calculate_scores()
        super().save(*args, **kwargs)

        # 自动创建或更新Score
        try:
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

            attendance_scores = [self.attendance1, self.attendance2, self.attendance3, self.attendance4, self.attendance5]
            attendance_scores = [s for s in attendance_scores if s is not None]
            attendance_avg = sum(attendance_scores) / len(attendance_scores) if attendance_scores else 0
            score.attendance_score = attendance_avg if attendance_avg > 0 else None

            score.review_note_score = self.review_note
            if '电子笔记' not in score.extra_scores:
                score.extra_scores['电子笔记'] = {}
            score.extra_scores['电子笔记'] = self.review_note

            homework_scores = [self.homework1, self.homework2, self.homework3, self.homework4, self.homework5]
            homework_scores = [s for s in homework_scores if s is not None]
            homework_avg = sum(homework_scores) / len(homework_scores) if homework_scores else 0
            score.homework_score = homework_avg if homework_avg > 0 else None

            experiment_scores = [self.experiment1, self.experiment2]
            experiment_scores = [s for s in experiment_scores if s is not None]
            experiment_avg = sum(experiment_scores) / len(experiment_scores) if experiment_scores else 0
            score.experiment_score = experiment_avg if experiment_avg > 0 else None

            score.final_score = self.final_score

            if '作品' not in score.extra_scores:
                score.extra_scores['作品'] = {}
            score.extra_scores['作品'] = self.system_score

            if '报告' not in score.extra_scores:
                score.extra_scores['报告'] = {}
            score.extra_scores['报告'] = self.report_score

            score.save(skip_objective_calculation=True)

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




