# 课程目标达成度计算器
from typing import Dict, List
import logging
from apps.scores.models import Score
from apps.courses.models import CourseObjectiveAchievement

logger = logging.getLogger(__name__)


class ObjectiveCalculator:
    """课程目标达成度计算器"""

    @staticmethod
    def calculate_objective_achievement(score: Score) -> Dict:
        """
        计算单个学生的课程目标达成度
        
        Args:
            score: 成绩记录对象
            
        Returns:
            包含三个课程目标达成度的字典
        """
        # 获取成绩数据
        attendance = score.attendance_score or 0  # 点名
        e_notes = score.extra_scores.get('电子笔记', 0) or 0  # 电子笔记
        homework = score.homework_score or 0  # 作业成绩
        experiment = score.experiment_score or 0  # 实验
        work = score.extra_scores.get('作品', 0) or 0  # 作品
        report = score.extra_scores.get('报告', 0) or 0  # 报告
        
        # 计算平时成绩 = (点名*0.05+电子笔记*0.05+作业成绩*0.1)/0.2
        usual_score = (attendance * 0.05 + e_notes * 0.05 + homework * 0.1) / 0.2 if (attendance + e_notes + homework) > 0 else 0
        
        # 计算期末成绩 = (实验*0.2+作品*0.3+报告*0.3)/0.8
        final_score = (experiment * 0.2 + work * 0.3 + report * 0.3) / 0.8 if (experiment + work + report) > 0 else 0
        
        results = {}
        
        # 课程目标1
        # 平时 = 平时成绩*0.2*0.5
        obj1_usual = usual_score * 0.2 * 0.5
        # 实验 = 0（课程目标1与实验无关）
        obj1_experiment = 0
        # 期末 = 期末成绩*0.6*0.35
        obj1_final = final_score * 0.6 * 0.35
        # 达成情况 = 平时+期末
        obj1_achievement = obj1_usual + obj1_experiment + obj1_final
        # 达成度 = 达成情况/31
        obj1_degree = obj1_achievement / 31.0 if 31.0 > 0 else 0
        
        results['objective1'] = {
            'usual': round(obj1_usual, 2),
            'experiment': obj1_experiment,
            'final': round(obj1_final, 2),
            'achievement': round(obj1_achievement, 2),
            'degree': round(obj1_degree, 4)
        }
        
        # 课程目标2
        # 平时 = 平时成绩*0.2*0.3
        obj2_usual = usual_score * 0.2 * 0.3
        # 实验 = 实验*0.5*0.2
        obj2_experiment = experiment * 0.5 * 0.2
        # 期末 = 期末成绩*0.6*0.35
        obj2_final = final_score * 0.6 * 0.35
        # 达成情况 = 平时+实验+期末
        obj2_achievement = obj2_usual + obj2_experiment + obj2_final
        # 达成度 = 达成情况/37
        obj2_degree = obj2_achievement / 37.0 if 37.0 > 0 else 0
        
        results['objective2'] = {
            'usual': round(obj2_usual, 2),
            'experiment': round(obj2_experiment, 2),
            'final': round(obj2_final, 2),
            'achievement': round(obj2_achievement, 2),
            'degree': round(obj2_degree, 4)
        }
        
        # 课程目标3
        # 平时 = 平时成绩*0.2*0.2
        obj3_usual = usual_score * 0.2 * 0.2
        # 实验 = 实验*0.5*0.2
        obj3_experiment = experiment * 0.5 * 0.2
        # 期末 = 期末成绩*0.6*0.3
        obj3_final = final_score * 0.6 * 0.3
        # 达成情况 = 平时+实验+期末
        obj3_achievement = obj3_usual + obj3_experiment + obj3_final
        # 达成度 = 达成情况/32
        obj3_degree = obj3_achievement / 32.0 if 32.0 > 0 else 0
        
        results['objective3'] = {
            'usual': round(obj3_usual, 2),
            'experiment': round(obj3_experiment, 2),
            'final': round(obj3_final, 2),
            'achievement': round(obj3_achievement, 2),
            'degree': round(obj3_degree, 4)
        }
        
        # 最终成绩 = 平时成绩*0.4 + 期末成绩*0.6 = 三个目标达成情况之和
        final_grade = usual_score * 0.4 + final_score * 0.6
        total_achievement = obj1_achievement + obj2_achievement + obj3_achievement
        
        return {
            'objective1': results['objective1'],
            'objective2': results['objective2'],
            'objective3': results['objective3'],
            'usual_score': round(usual_score, 2),
            'final_score': round(final_score, 2),
            'total_achievement': round(total_achievement, 2),
            'final_grade': round(final_grade, 2)
        }

    @staticmethod
    def save_objective_achievements(score: Score) -> List[CourseObjectiveAchievement]:
        """
        计算并保存课程目标达成度
        
        Returns:
            创建的CourseObjectiveAchievement对象列表
        """
        results = ObjectiveCalculator.calculate_objective_achievement(score)
        
        achievements = []
        
        # 保存课程目标1
        obj1, created = CourseObjectiveAchievement.objects.update_or_create(
            score=score,
            objective_number=1,
            defaults={
                'usual_score': results['objective1']['usual'],
                'experiment_score': results['objective1']['experiment'],
                'final_score': results['objective1']['final'],
                'achievement_score': results['objective1']['achievement'],
                'achievement_degree': results['objective1']['degree'],
                'max_score': 31.0
            }
        )
        achievements.append(obj1)
        
        # 保存课程目标2
        obj2, created = CourseObjectiveAchievement.objects.update_or_create(
            score=score,
            objective_number=2,
            defaults={
                'usual_score': results['objective2']['usual'],
                'experiment_score': results['objective2']['experiment'],
                'final_score': results['objective2']['final'],
                'achievement_score': results['objective2']['achievement'],
                'achievement_degree': results['objective2']['degree'],
                'max_score': 37.0
            }
        )
        achievements.append(obj2)
        
        # 保存课程目标3
        obj3, created = CourseObjectiveAchievement.objects.update_or_create(
            score=score,
            objective_number=3,
            defaults={
                'usual_score': results['objective3']['usual'],
                'experiment_score': results['objective3']['experiment'],
                'final_score': results['objective3']['final'],
                'achievement_score': results['objective3']['achievement'],
                'achievement_degree': results['objective3']['degree'],
                'max_score': 32.0
            }
        )
        achievements.append(obj3)
        
        # 更新最终成绩（跳过课程目标计算以避免递归）
        if results.get('final_grade'):
            score.final_grade = results['final_grade']
            score.save(update_fields=['final_grade'], skip_objective_calculation=True)
        
        return achievements

    @staticmethod
    def calculate_class_statistics(course_class_id: int) -> Dict:
        """
        计算班级整体的课程目标达成度统计
        
        Args:
            course_class_id: 课程班级ID
            
        Returns:
            包含三个课程目标统计信息的字典
        """
        from apps.scores.models import Score
        
        scores = Score.objects.filter(course_class_id=course_class_id)
        
        if not scores.exists():
            return {
                'objective1': {'achievement_score': 0, 'achievement_degree': 0},
                'objective2': {'achievement_score': 0, 'achievement_degree': 0},
                'objective3': {'achievement_score': 0, 'achievement_degree': 0}
            }
        
        # 收集所有学生的达成度数据
        obj1_achievements = []
        obj1_degrees = []
        obj2_achievements = []
        obj2_degrees = []
        obj3_achievements = []
        obj3_degrees = []
        
        for score in scores:
            achievements = CourseObjectiveAchievement.objects.filter(score=score)
            for ach in achievements:
                if ach.objective_number == 1:
                    obj1_achievements.append(ach.achievement_score)
                    obj1_degrees.append(ach.achievement_degree)
                elif ach.objective_number == 2:
                    obj2_achievements.append(ach.achievement_score)
                    obj2_degrees.append(ach.achievement_degree)
                elif ach.objective_number == 3:
                    obj3_achievements.append(ach.achievement_score)
                    obj3_degrees.append(ach.achievement_degree)
        
        # 计算平均值
        obj1_avg_achievement = sum(obj1_achievements) / len(obj1_achievements) if obj1_achievements else 0
        obj2_avg_achievement = sum(obj2_achievements) / len(obj2_achievements) if obj2_achievements else 0
        obj3_avg_achievement = sum(obj3_achievements) / len(obj3_achievements) if obj3_achievements else 0
        
        # 计算达成度（达成度超过0.6的人数/总数）
        total_count = len(scores)
        obj1_pass_count = sum(1 for d in obj1_degrees if d >= 0.6)
        obj2_pass_count = sum(1 for d in obj2_degrees if d >= 0.6)
        obj3_pass_count = sum(1 for d in obj3_degrees if d >= 0.6)
        
        obj1_degree_rate = obj1_pass_count / total_count if total_count > 0 else 0
        obj2_degree_rate = obj2_pass_count / total_count if total_count > 0 else 0
        obj3_degree_rate = obj3_pass_count / total_count if total_count > 0 else 0
        
        return {
            'objective1': {
                'achievement_score': round(obj1_avg_achievement, 2),
                'achievement_degree': round(obj1_degree_rate, 4)
            },
            'objective2': {
                'achievement_score': round(obj2_avg_achievement, 2),
                'achievement_degree': round(obj2_degree_rate, 4)
            },
            'objective3': {
                'achievement_score': round(obj3_avg_achievement, 2),
                'achievement_degree': round(obj3_degree_rate, 4)
            },
            'total_students': total_count
        }


