import os
import sys
import django

# 添加项目路径到 sys.path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
django.setup()

from apps.scores.models import Score

# 获取所有图形学课程的Score记录
graphics_scores = Score.objects.filter(course_class__course__course_name__contains='图形学')
print(f"找到 {graphics_scores.count()} 条图形学课程成绩记录")

# 重新计算每个学生的成绩
updated_count = 0
for score in graphics_scores:
    try:
        old_grade = score.final_grade
        score.calculate_grade()
        score.save()
        if score.final_grade != old_grade:
            print(f"学生 {score.student.username}: 旧成绩={old_grade}, 新成绩={score.final_grade}")
            updated_count += 1
    except Exception as e:
        print(f"计算学生 {score.student.username} 成绩时出错: {str(e)}")

print(f"共更新了 {updated_count} 条成绩记录")