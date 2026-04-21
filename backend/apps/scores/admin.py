from django.contrib import admin
from apps.scores.models import Score, ScoreImportLog, ScoreAdjustment


@admin.register(Score)
class ScoreAdmin(admin.ModelAdmin):
    list_display = [
        'id', 'student', 'course_class', 'attendance_score', 'homework_score',
        'experiment_score', 'final_score', 'final_grade', 'grade_level',
        'is_published', 'created_at'
    ]
    list_filter = ['is_published', 'is_verified', 'grade_level', 'created_at']
    search_fields = ['student__username', 'student__first_name', 'course_class__course__course_name']
    readonly_fields = ['usual_total', 'final_total', 'final_grade', 'grade_point', 'grade_level', 'created_at', 'updated_at']
    fieldsets = (
        ('基本信息', {
            'fields': ('student', 'course_class', 'grading_policy')
        }),
        ('平时成绩', {
            'fields': ('attendance_score', 'homework_score', 'experiment_score', 'review_note_score', 'extra_scores')
        }),
        ('期末成绩', {
            'fields': ('final_score',)
        }),
        ('计算结果', {
            'fields': ('usual_total', 'final_total', 'final_grade', 'grade_point', 'grade_level')
        }),
        ('状态', {
            'fields': ('is_published', 'published_at', 'is_verified')
        }),
        ('审计信息', {
            'fields': ('created_by', 'updated_by', 'created_at', 'updated_at')
        }),
    )


@admin.register(ScoreImportLog)
class ScoreImportLogAdmin(admin.ModelAdmin):
    list_display = ['id', 'file_name', 'course_class', 'imported_by', 'total_rows', 'success_rows', 'failed_rows', 'status', 'created_at']
    list_filter = ['status', 'created_at']
    search_fields = ['file_name', 'course_class__course__course_name']
    readonly_fields = ['created_at', 'completed_at']


@admin.register(ScoreAdjustment)
class ScoreAdjustmentAdmin(admin.ModelAdmin):
    list_display = ['id', 'score', 'adjustment_type', 'adjusted_by', 'is_approved', 'approved_by', 'created_at']
    list_filter = ['adjustment_type', 'is_approved', 'created_at']
    search_fields = ['score__student__username', 'reason']
