from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.http import HttpResponse
from django.template.loader import render_to_string
from django.utils import timezone
import logging

from apps.scores.models import Score
from apps.courses.models import CourseClass, CourseObjectiveAchievement
from utils.calculator import ScoreCalculator

logger = logging.getLogger(__name__)


class ReportViewSet(viewsets.ViewSet):
    """报告生成视图集"""
    permission_classes = [IsAuthenticated]

    @action(detail=False, methods=['get'], url_path='course-report')
    def course_report(self, request):
        """课程成绩报告"""
        course_class_id = request.query_params.get('course_class_id')
        if not course_class_id:
            return Response({'error': '请提供course_class_id'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            course_class = CourseClass.objects.get(id=course_class_id)
        except CourseClass.DoesNotExist:
            return Response({'error': '课程班级不存在'}, status=status.HTTP_404_NOT_FOUND)

        scores = Score.objects.filter(course_class=course_class).select_related('student', 'course_class', 'course_class__course')

        # 统计数据
        final_grades = [s.final_grade for s in scores if s.final_grade is not None]
        stats = ScoreCalculator.calculate_statistics(final_grades)

        # 等级分布
        grade_distribution = {}
        for score in scores:
            if score.grade_level:
                grade_distribution[score.grade_level] = grade_distribution.get(score.grade_level, 0) + 1

        # 成绩列表
        score_list = []
        for score in scores.order_by('-final_grade'):
            score_list.append({
                'student_id': score.student.employee_id or score.student.username,
                'student_name': score.student.first_name or score.student.username,
                'attendance': score.attendance_score,
                'homework': score.homework_score,
                'experiment': score.experiment_score,
                'review_note': score.review_note_score,
                'final': score.final_score,
                'usual_total': score.usual_total,
                'final_total': score.final_total,
                'final_grade': score.final_grade,
                'grade_point': score.grade_point,
                'grade_level': score.grade_level,
            })

        return Response({
            'course_name': course_class.course.course_name,
            'class_name': course_class.class_name,
            'semester': f"{course_class.course.year}-{course_class.course.semester}",
            'statistics': stats,
            'grade_distribution': grade_distribution,
            'scores': score_list,
            'generated_at': timezone.now(),
        })

    @action(detail=False, methods=['get'], url_path='print-course-report')
    def print_course_report(self, request):
        """打印课程成绩报告（HTML格式）"""
        course_class_id = request.query_params.get('course_class_id')
        if not course_class_id:
            return Response({'error': '请提供course_class_id'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            course_class = CourseClass.objects.get(id=course_class_id)
        except CourseClass.DoesNotExist:
            return Response({'error': '课程班级不存在'}, status=status.HTTP_404_NOT_FOUND)

        scores = Score.objects.filter(course_class=course_class).select_related('student', 'course_class', 'course_class__course')

        # 统计数据
        final_grades = [s.final_grade for s in scores if s.final_grade is not None]
        stats = ScoreCalculator.calculate_statistics(final_grades)

        # 获取课程目标达成度统计
        from utils.objective_calculator import ObjectiveCalculator
        class_statistics = ObjectiveCalculator.calculate_class_statistics(int(course_class_id))

        # 成绩列表
        score_list = []
        for score in scores.order_by('-final_grade'):
            try:
                student_id = score.student.student_profile.student_id
            except:
                student_id = score.student.employee_id or score.student.username

            # 获取课程目标达成度
            achievements = CourseObjectiveAchievement.objects.filter(score=score).order_by('objective_number')
            obj1 = achievements.filter(objective_number=1).first()
            obj2 = achievements.filter(objective_number=2).first()
            obj3 = achievements.filter(objective_number=3).first()

            score_data = {
                'student_id': student_id,
                'student_name': score.student.first_name or score.student.username,
                'attendance': score.attendance_score or 0,
                'e_notes': score.extra_scores.get('电子笔记', 0) or 0,
                'homework': score.homework_score or 0,
                'usual_total': score.usual_total or 0,
                'experiment': score.experiment_score or 0,
                'work': score.extra_scores.get('作品', 0) or 0,
                'report': score.extra_scores.get('报告', 0) or 0,
                'final_total': score.final_total or 0,
                'usual_entry': score.usual_entry or 0,
                'final_entry': score.final_entry or 0,
                'final_grade': score.final_grade or 0,
                'objective1': {
                    'usual': obj1.usual_score if obj1 else 0,
                    'experiment': obj1.experiment_score if obj1 else 0,
                    'final': obj1.final_score if obj1 else 0,
                    'achievement': obj1.achievement_score if obj1 else 0,
                    'degree': obj1.achievement_degree if obj1 else 0
                },
                'objective2': {
                    'usual': obj2.usual_score if obj2 else 0,
                    'experiment': obj2.experiment_score if obj2 else 0,
                    'final': obj2.final_score if obj2 else 0,
                    'achievement': obj2.achievement_score if obj2 else 0,
                    'degree': obj2.achievement_degree if obj2 else 0
                },
                'objective3': {
                    'usual': obj3.usual_score if obj3 else 0,
                    'experiment': obj3.experiment_score if obj3 else 0,
                    'final': obj3.final_score if obj3 else 0,
                    'achievement': obj3.achievement_score if obj3 else 0,
                    'degree': obj3.achievement_degree if obj3 else 0
                }
            }
            score_list.append(score_data)

        # 生成HTML
        html_content = f"""
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <title>成绩报告 - {course_class.course.course_name}</title>
            <style>
                body {{
                    font-family: "Microsoft YaHei", Arial, sans-serif;
                    margin: 20px;
                }}
                h1 {{
                    text-align: center;
                    color: #333;
                }}
                .info {{
                    margin: 20px 0;
                    padding: 10px;
                    background-color: #f5f5f5;
                }}
                table {{
                    width: 100%;
                    border-collapse: collapse;
                    margin: 20px 0;
                }}
                th, td {{
                    border: 1px solid #ddd;
                    padding: 8px;
                    text-align: center;
                }}
                th {{
                    background-color: #4CAF50;
                    color: white;
                }}
                tr:nth-child(even) {{
                    background-color: #f2f2f2;
                }}
                .statistics {{
                    margin: 20px 0;
                    padding: 15px;
                    background-color: #e8f5e9;
                    border-radius: 5px;
                }}
                @media print {{
                    body {{
                        margin: 0;
                    }}
                    .no-print {{
                        display: none;
                    }}
                }}
            </style>
        </head>
        <body>
            <h1>{course_class.course.course_name} 成绩报告</h1>
            <div class="info">
                <p><strong>班级：</strong>{course_class.class_name}</p>
                <p><strong>学期：</strong>{course_class.course.year}-{course_class.course.semester}</p>
                <p><strong>生成时间：</strong>{timezone.now().strftime('%Y-%m-%d %H:%M:%S')}</p>
            </div>
            <div class="statistics">
                <h3>统计信息</h3>
                <p>总人数：{stats['count']} | 平均分：{stats['average']} | 最高分：{stats['max']} | 最低分：{stats['min']}</p>
                <p>及格率：{stats['pass_rate']}% | 优秀率：{stats['excellent_rate']}%</p>
            </div>
            <table>
                <thead>
                    <tr>
                        <th rowspan="2">序号</th>
                        <th rowspan="2">学号</th>
                        <th rowspan="2">姓名</th>
                        <th rowspan="2">点名</th>
                        <th rowspan="2">电子笔记</th>
                        <th rowspan="2">作业成绩</th>
                        <th rowspan="2">平时成绩</th>
                        <th rowspan="2">实验</th>
                        <th rowspan="2">作品</th>
                        <th rowspan="2">报告</th>
                        <th rowspan="2">期末平均</th>
                        <th colspan="5">课程目标1</th>
                        <th colspan="5">课程目标2</th>
                        <th colspan="5">课程目标3</th>
                        <th rowspan="2">平时录入</th>
                        <th rowspan="2">期末录入</th>
                        <th rowspan="2">最终成绩</th>
                    </tr>
                    <tr>
                        <th>平时</th><th>实验</th><th>期末</th><th>达成情况</th><th>达成度</th>
                        <th>平时</th><th>实验</th><th>期末</th><th>达成情况</th><th>达成度</th>
                        <th>平时</th><th>实验</th><th>期末</th><th>达成情况</th><th>达成度</th>
                    </tr>
                </thead>
                <tbody>
        """

        for idx, score in enumerate(score_list, 1):
            html_content += f"""
                    <tr>
                        <td>{idx}</td>
                        <td>{score['student_id']}</td>
                        <td>{score['student_name']}</td>
                        <td>{score['attendance']:.1f if score['attendance'] else '-'}</td>
                        <td>{score['e_notes']:.1f if score['e_notes'] else '-'}</td>
                        <td>{score['homework']:.1f if score['homework'] else '-'}</td>
                        <td>{score['usual_total']:.2f if score['usual_total'] else '-'}</td>
                        <td>{score['experiment']:.1f if score['experiment'] else '-'}</td>
                        <td>{score['work']:.1f if score['work'] else '-'}</td>
                        <td>{score['report']:.1f if score['report'] else '-'}</td>
                        <td>{score['final_total']:.2f if score['final_total'] else '-'}</td>
                        <td>{score['objective1']['usual']:.2f}</td>
                        <td>{score['objective1']['experiment']:.2f}</td>
                        <td>{score['objective1']['final']:.2f}</td>
                        <td>{score['objective1']['achievement']:.2f}</td>
                        <td>{(score['objective1']['degree'] * 100):.2f}%</td>
                        <td>{score['objective2']['usual']:.2f}</td>
                        <td>{score['objective2']['experiment']:.2f}</td>
                        <td>{score['objective2']['final']:.2f}</td>
                        <td>{score['objective2']['achievement']:.2f}</td>
                        <td>{(score['objective2']['degree'] * 100):.2f}%</td>
                        <td>{score['objective3']['usual']:.2f}</td>
                        <td>{score['objective3']['experiment']:.2f}</td>
                        <td>{score['objective3']['final']:.2f}</td>
                        <td>{score['objective3']['achievement']:.2f}</td>
                        <td>{(score['objective3']['degree'] * 100):.2f}%</td>
                        <td>{score['usual_entry']:.1f if score['usual_entry'] else '-'}</td>
                        <td>{score['final_entry']:.1f if score['final_entry'] else '-'}</td>
                        <td>{score['final_grade']:.1f if score['final_grade'] else '-'}</td>
                    </tr>
            """

        html_content += """
                </tbody>
            </table>
            
            <div class="statistics" style="margin-top: 30px;">
                <h3>达成度计算</h3>
                <table>
                    <thead>
                        <tr>
                            <th>课程目标</th>
                            <th>达成分值</th>
                            <th>达成度</th>
                        </tr>
                    </thead>
                    <tbody>
        """
        
        html_content += f"""
                        <tr>
                            <td>课程目标1</td>
                            <td>{class_statistics['objective1']['achievement_score']:.2f}</td>
                            <td>{(class_statistics['objective1']['achievement_degree'] * 100):.2f}%</td>
                        </tr>
                        <tr>
                            <td>课程目标2</td>
                            <td>{class_statistics['objective2']['achievement_score']:.2f}</td>
                            <td>{(class_statistics['objective2']['achievement_degree'] * 100):.2f}%</td>
                        </tr>
                        <tr>
                            <td>课程目标3</td>
                            <td>{class_statistics['objective3']['achievement_score']:.2f}</td>
                            <td>{(class_statistics['objective3']['achievement_degree'] * 100):.2f}%</td>
                        </tr>
        """
        
        html_content += """
                    </tbody>
                </table>
            </div>
            
            <div class="no-print" style="text-align: center; margin-top: 20px;">
                <button onclick="window.print()">打印</button>
            </div>
        </body>
        </html>
        """

        return HttpResponse(html_content, content_type='text/html')

    @action(detail=False, methods=['get'], url_path='student-transcript')
    def student_transcript(self, request):
        """学生成绩单"""
        student_id = request.query_params.get('student_id')
        if not student_id:
            return Response({'error': '请提供student_id'}, status=status.HTTP_400_BAD_REQUEST)

        from apps.users.models import User
        try:
            student = User.objects.get(id=student_id, user_type='student')
        except User.DoesNotExist:
            return Response({'error': '学生不存在'}, status=status.HTTP_404_NOT_FOUND)

        scores = Score.objects.filter(student=student).select_related('course_class', 'course_class__course')

        transcript = []
        for score in scores.order_by('course_class__course__year', 'course_class__course__semester'):
            transcript.append({
                'course_code': score.course_class.course.course_code,
                'course_name': score.course_class.course.course_name,
                'credit': score.course_class.course.credit,
                'semester': f"{score.course_class.course.year}-{score.course_class.course.semester}",
                'final_grade': score.final_grade,
                'grade_point': score.grade_point,
                'grade_level': score.grade_level,
            })

        # 计算总绩点
        total_credits = sum(t['credit'] for t in transcript)
        weighted_gpa = sum(t['credit'] * (t['grade_point'] or 0) for t in transcript)
        gpa = weighted_gpa / total_credits if total_credits > 0 else 0

        return Response({
            'student_id': student_id,
            'student_name': student.first_name or student.username,
            'transcript': transcript,
            'total_credits': total_credits,
            'gpa': round(gpa, 2),
        })

