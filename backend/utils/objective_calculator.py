# 课程目标达成度计算器
from typing import Dict, List, Optional
import logging
from apps.scores.models import Score
from apps.courses.models import CourseObjectiveAchievement, Course

logger = logging.getLogger(__name__)


class ObjectiveCalculator:
    """课程目标达成度计算器"""

    DEFAULT_CONFIG = {
        'usual_score_formula': {
            'attendance_weight': 0.05,
            'e_notes_weight': 0.05,
            'homework_weight': 0.1,
            'total_weight': 0.2
        },
        'final_score_formula': {
            'experiment_weight': 0.2,
            'work_weight': 0.3,
            'report_weight': 0.3,
            'total_weight': 0.8
        },
        'final_grade_formula': {
            'usual_weight': 0.4,
            'final_weight': 0.6
        },
        'objectives': [
            {
                'number': 1,
                'name': '课程目标1',
                'usual_weight': 0.2,
                'usual_sub_weight': 0.5,
                'experiment_weight': 0,
                'experiment_sub_weight': 0,
                'final_weight': 0.6,
                'final_sub_weight': 0.35,
                'max_score': 31.0
            },
            {
                'number': 2,
                'name': '课程目标2',
                'usual_weight': 0.2,
                'usual_sub_weight': 0.3,
                'experiment_weight': 0.5,
                'experiment_sub_weight': 0.2,
                'final_weight': 0.6,
                'final_sub_weight': 0.35,
                'max_score': 37.0
            },
            {
                'number': 3,
                'name': '课程目标3',
                'usual_weight': 0.2,
                'usual_sub_weight': 0.2,
                'experiment_weight': 0.5,
                'experiment_sub_weight': 0.2,
                'final_weight': 0.6,
                'final_sub_weight': 0.3,
                'max_score': 32.0
            }
        ]
    }

    @staticmethod
    def get_course_config(course: Course) -> Dict:
        """
        获取课程的配置，如果没有配置则返回默认配置
        
        Args:
            course: 课程对象
            
        Returns:
            配置字典
        """
        if course.course_objectives and len(course.course_objectives) > 0:
            config = course.course_objectives
            if isinstance(config, dict) and 'objectives' in config:
                return config
        return ObjectiveCalculator.DEFAULT_CONFIG

    @staticmethod
    def calculate_objective_achievement(score: Score, config: Optional[Dict] = None) -> Dict:
        """
        计算单个学生的课程目标达成度
        
        Args:
            score: 成绩记录对象
            config: 配置字典，如果为None则使用默认配置
            
        Returns:
            包含三个课程目标达成度的字典
        """
        if config is None:
            config = ObjectiveCalculator.DEFAULT_CONFIG
        
        attendance = score.attendance_score or 0
        e_notes = score.extra_scores.get('电子笔记', 0) or 0
        homework = score.homework_score or 0
        experiment = score.experiment_score or 0
        work = score.extra_scores.get('作品', 0) or 0
        report = score.extra_scores.get('报告', 0) or 0
        
        usual_formula = config.get('usual_score_formula', ObjectiveCalculator.DEFAULT_CONFIG['usual_score_formula'])
        final_formula = config.get('final_score_formula', ObjectiveCalculator.DEFAULT_CONFIG['final_score_formula'])
        grade_formula = config.get('final_grade_formula', ObjectiveCalculator.DEFAULT_CONFIG['final_grade_formula'])
        
        usual_total_weight = usual_formula.get('total_weight', 0.2)
        usual_score = (
            attendance * usual_formula.get('attendance_weight', 0.05) +
            e_notes * usual_formula.get('e_notes_weight', 0.05) +
            homework * usual_formula.get('homework_weight', 0.1)
        ) / usual_total_weight if (attendance + e_notes + homework) > 0 else 0
        
        final_total_weight = final_formula.get('total_weight', 0.8)
        final_score = (
            experiment * final_formula.get('experiment_weight', 0.2) +
            work * final_formula.get('work_weight', 0.3) +
            report * final_formula.get('report_weight', 0.3)
        ) / final_total_weight if (experiment + work + report) > 0 else 0
        
        results = {}
        objectives = config.get('objectives', ObjectiveCalculator.DEFAULT_CONFIG['objectives'])
        
        for obj_config in objectives:
            obj_num = obj_config.get('number', 1)
            obj_name = f'objective{obj_num}'
            
            obj_usual_weight = obj_config.get('usual_weight', 0.2)
            obj_usual_sub_weight = obj_config.get('usual_sub_weight', 0.5)
            obj_experiment_weight = obj_config.get('experiment_weight', 0)
            obj_experiment_sub_weight = obj_config.get('experiment_sub_weight', 0)
            obj_final_weight = obj_config.get('final_weight', 0.6)
            obj_final_sub_weight = obj_config.get('final_sub_weight', 0.35)
            obj_max_score = obj_config.get('max_score', 31.0)
            
            obj_usual = usual_score * obj_usual_weight * obj_usual_sub_weight
            obj_experiment = experiment * obj_experiment_weight * obj_experiment_sub_weight
            obj_final = final_score * obj_final_weight * obj_final_sub_weight
            obj_achievement = obj_usual + obj_experiment + obj_final
            obj_degree = obj_achievement / obj_max_score if obj_max_score > 0 else 0
            
            results[obj_name] = {
                'usual': round(obj_usual, 2),
                'experiment': round(obj_experiment, 2),
                'final': round(obj_final, 2),
                'achievement': round(obj_achievement, 2),
                'degree': round(obj_degree, 4),
                'max_score': obj_max_score
            }
        
        final_grade = usual_score * grade_formula.get('usual_weight', 0.4) + final_score * grade_formula.get('final_weight', 0.6)
        total_achievement = sum(results[obj_name]['achievement'] for obj_name in results)
        
        return {
            **results,
            'usual_score': round(usual_score, 2),
            'final_score': round(final_score, 2),
            'total_achievement': round(total_achievement, 2),
            'final_grade': round(final_grade, 2)
        }

    @staticmethod
    def save_objective_achievements(score: Score, config: Optional[Dict] = None) -> List[CourseObjectiveAchievement]:
        """
        计算并保存课程目标达成度
        
        Args:
            score: 成绩记录对象
            config: 配置字典，如果为None则尝试从课程获取配置
            
        Returns:
            创建的CourseObjectiveAchievement对象列表
        """
        if config is None:
            try:
                course = score.course_class.course
                config = ObjectiveCalculator.get_course_config(course)
            except Exception as e:
                logger.warning(f"获取课程配置失败，使用默认配置: {str(e)}")
                config = ObjectiveCalculator.DEFAULT_CONFIG
        
        results = ObjectiveCalculator.calculate_objective_achievement(score, config)
        
        achievements = []
        objectives = config.get('objectives', ObjectiveCalculator.DEFAULT_CONFIG['objectives'])
        
        for obj_config in objectives:
            obj_num = obj_config.get('number', 1)
            obj_name = f'objective{obj_num}'
            obj_max_score = obj_config.get('max_score', 31.0)
            
            if obj_name in results:
                obj_data = results[obj_name]
                obj, created = CourseObjectiveAchievement.objects.update_or_create(
                    score=score,
                    objective_number=obj_num,
                    defaults={
                        'usual_score': obj_data['usual'],
                        'experiment_score': obj_data['experiment'],
                        'final_score': obj_data['final'],
                        'achievement_score': obj_data['achievement'],
                        'achievement_degree': obj_data['degree'],
                        'max_score': obj_max_score
                    }
                )
                achievements.append(obj)
        
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
        from apps.courses.models import CourseClass
        
        scores = Score.objects.filter(course_class_id=course_class_id)
        
        if not scores.exists():
            return {
                'objective1': {'achievement_score': 0, 'achievement_degree': 0},
                'objective2': {'achievement_score': 0, 'achievement_degree': 0},
                'objective3': {'achievement_score': 0, 'achievement_degree': 0}
            }
        
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
        
        obj1_avg_achievement = sum(obj1_achievements) / len(obj1_achievements) if obj1_achievements else 0
        obj2_avg_achievement = sum(obj2_achievements) / len(obj2_achievements) if obj2_achievements else 0
        obj3_avg_achievement = sum(obj3_achievements) / len(obj3_achievements) if obj3_achievements else 0
        
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