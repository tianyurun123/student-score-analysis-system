# 成绩计算器
from typing import Dict, Optional
import re
import logging

logger = logging.getLogger(__name__)


class ScoreCalculator:
    """成绩计算器"""

    @staticmethod
    def calculate_usual_score(score_data: Dict, formula: Optional[str] = None, weights: Optional[Dict] = None) -> float:
        """
        计算平时成绩
        
        Args:
            score_data: 成绩数据字典，如 {'点名': 90, '电子笔记': 85, '作业成绩': 88}
            formula: 自定义公式，如 "(点名*0.05+电子笔记*0.05+作业成绩*0.1)/0.2"
            weights: 权重字典，如 {'点名': 0.05, '电子笔记': 0.05, '作业成绩': 0.1}
        
        Returns:
            计算后的平时成绩
        """
        if formula:
            return ScoreCalculator._calculate_with_formula(score_data, formula)
        elif weights:
            return ScoreCalculator._calculate_with_weights(score_data, weights)
        else:
            # 默认平均分
            values = [v for v in score_data.values() if v is not None]
            return sum(values) / len(values) if values else 0.0

    @staticmethod
    def calculate_final_score(score_data: Dict, formula: Optional[str] = None) -> float:
        """
        计算期末成绩
        
        Args:
            score_data: 成绩数据字典，如 {'作品': 85, '报告': 90}
            formula: 自定义公式，如 "(作品+报告)/2"
        
        Returns:
            计算后的期末成绩
        """
        if formula:
            return ScoreCalculator._calculate_with_formula(score_data, formula)
        else:
            # 默认平均分
            values = [v for v in score_data.values() if v is not None]
            return sum(values) / len(values) if values else 0.0

    @staticmethod
    def calculate_total_score(usual_score: float, final_score: float, 
                             usual_weight: float = 0.3, final_weight: float = 0.7) -> float:
        """
        计算总成绩
        
        Args:
            usual_score: 平时成绩
            final_score: 期末成绩
            usual_weight: 平时成绩权重
            final_weight: 期末成绩权重
        
        Returns:
            总成绩
        """
        return usual_score * usual_weight + final_score * final_weight

    @staticmethod
    def _calculate_with_formula(score_data: Dict, formula: str) -> float:
        """
        使用公式计算成绩
        
        Args:
            score_data: 成绩数据字典
            formula: 计算公式字符串
        
        Returns:
            计算结果
        """
        try:
            # 清理公式中的空格
            formula = formula.replace(' ', '')
            
            # 验证公式安全性（只允许数字、运算符、括号和变量名）
            if not re.match(r'^[0-9+\-*/().\u4e00-\u9fa5a-zA-Z_]+$', formula):
                raise ValueError("公式包含非法字符")

            # 按变量名长度从长到短排序，避免短变量名被长变量名包含
            sorted_vars = sorted(score_data.keys(), key=len, reverse=True)
            
            # 替换变量
            formula_copy = formula
            for var_name in sorted_vars:
                var_value = score_data.get(var_name, 0) or 0
                # 替换所有出现的变量名
                formula_copy = formula_copy.replace(var_name, str(var_value))

            # 验证替换后的公式只包含数字和运算符
            if not re.match(r'^[0-9+\-*/().\s]+$', formula_copy):
                # 如果还有未替换的变量，记录警告但继续计算
                missing_vars = re.findall(r'[\u4e00-\u9fa5a-zA-Z_]+', formula_copy)
                if missing_vars:
                    logger.warning(f"公式中缺少变量: {missing_vars}, 公式: {formula}")
                    # 将缺失的变量替换为0
                    for var in missing_vars:
                        formula_copy = formula_copy.replace(var, '0')

            # 安全执行计算
            result = eval(formula_copy)
            return round(float(result), 2) if result else 0.0

        except Exception as e:
            logger.error(f"公式计算失败: {formula}, 错误: {str(e)}")
            return 0.0

    @staticmethod
    def _calculate_with_weights(score_data: Dict, weights: Dict) -> float:
        """
        使用权重计算加权平均
        
        Args:
            score_data: 成绩数据字典
            weights: 权重字典
        
        Returns:
            加权平均分
        """
        total_score = 0.0
        total_weight = 0.0

        for key, weight in weights.items():
            if key in score_data and score_data[key] is not None:
                total_score += score_data[key] * weight
                total_weight += weight

        if total_weight > 0:
            return total_score / total_weight
        else:
            return 0.0

    @staticmethod
    def parse_formula_from_text(text: str) -> Optional[str]:
        """
        从文本中解析公式
        例如："平时成绩=（点名*0.05+电子笔记*0.05+作业成绩*0.1）/0.2"
        返回: "(点名*0.05+电子笔记*0.05+作业成绩*0.1)/0.2"
        """
        # 查找等号后的部分
        match = re.search(r'[=：]\s*([^。\n]+)', text)
        if match:
            formula = match.group(1).strip()
            # 清理公式
            formula = formula.replace(' ', '')
            return formula
        return None

    @staticmethod
    def validate_formula(formula: str, available_variables: list) -> Dict:
        """
        验证公式的有效性
        
        Returns:
            {
                'valid': bool,
                'errors': List[str],
                'variables_used': List[str],
                'missing_variables': List[str]
            }
        """
        result = {
            'valid': True,
            'errors': [],
            'variables_used': [],
            'missing_variables': []
        }

        try:
            # 提取公式中的变量
            variables_in_formula = re.findall(r'[\u4e00-\u9fa5a-zA-Z_]+', formula)
            result['variables_used'] = list(set(variables_in_formula))

            # 检查缺失的变量
            for var in result['variables_used']:
                if var not in available_variables:
                    result['missing_variables'].append(var)

            # 检查公式语法
            # 替换变量为1进行语法检查
            test_formula = formula
            for var in result['variables_used']:
                test_formula = test_formula.replace(var, '1')

            # 尝试解析
            try:
                eval(test_formula)
            except Exception as e:
                result['valid'] = False
                result['errors'].append(f"公式语法错误: {str(e)}")

        except Exception as e:
            result['valid'] = False
            result['errors'].append(f"公式解析失败: {str(e)}")

        return result

    @staticmethod
    def calculate_statistics(scores: list) -> Dict:
        """
        计算成绩统计信息
        
        Args:
            scores: 成绩列表
        
        Returns:
            统计信息字典
        """
        if not scores:
            return {
                'count': 0,
                'average': 0,
                'max': 0,
                'min': 0,
                'median': 0,
                'std': 0,
                'pass_rate': 0,
                'excellent_rate': 0,
            }

        valid_scores = [s for s in scores if s is not None and 0 <= s <= 100]
        
        if not valid_scores:
            return {
                'count': 0,
                'average': 0,
                'max': 0,
                'min': 0,
                'median': 0,
                'std': 0,
                'pass_rate': 0,
                'excellent_rate': 0,
            }

        import statistics

        sorted_scores = sorted(valid_scores)
        count = len(valid_scores)
        average = sum(valid_scores) / count
        max_score = max(valid_scores)
        min_score = min(valid_scores)
        median = statistics.median(valid_scores)
        std = statistics.stdev(valid_scores) if count > 1 else 0
        pass_count = sum(1 for s in valid_scores if s >= 60)
        pass_rate = pass_count / count * 100
        excellent_count = sum(1 for s in valid_scores if s >= 90)
        excellent_rate = excellent_count / count * 100

        return {
            'count': count,
            'average': round(average, 2),
            'max': max_score,
            'min': min_score,
            'median': median,
            'std': round(std, 2),
            'pass_rate': round(pass_rate, 2),
            'excellent_rate': round(excellent_rate, 2),
        }
