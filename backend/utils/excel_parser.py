# Excel 解析器
import pandas as pd
import numpy as np
from io import BytesIO
from typing import Dict, List, Tuple, Optional
import logging

logger = logging.getLogger(__name__)


class ExcelScoreParser:
    """Excel 成绩解析器"""

    def __init__(self):
        self.supported_formats = ['.xlsx', '.xls']
        self.required_columns = {
            'student_id': ['学号', 'student_id', 'student', 'id'],
            'student_name': ['姓名', 'name', 'student_name'],
            'attendance': ['考勤', 'attendance', '出勤'],
            'homework': ['作业', 'homework', '作业成绩'],
            'experiment': ['实验', 'experiment', '实验成绩'],
            'review_note': ['复习笔记', 'review', '笔记'],
            'final': ['期末', 'final', '期末成绩', '考试成绩'],
        }

    def parse_excel(self, file_content: bytes, course_id: int) -> Tuple[List[Dict], List[str]]:
        """
        解析Excel文件
        Returns: (成功数据列表, 错误信息列表)
        """
        try:
            # 读取Excel文件
            df = pd.read_excel(BytesIO(file_content))

            # 验证列名
            column_mapping = self._map_columns(df.columns)
            missing_columns = self._check_required_columns(column_mapping)

            if missing_columns:
                return [], [f"缺少必要列: {', '.join(missing_columns)}"]

            # 清洗数据
            df_cleaned = self._clean_data(df, column_mapping)

            # 验证数据
            valid_data, errors = self._validate_data(df_cleaned, column_mapping)

            return valid_data, errors

        except Exception as e:
            logger.error(f"解析Excel文件失败: {str(e)}")
            return [], [f"文件解析失败: {str(e)}"]

    def _map_columns(self, columns: pd.Index) -> Dict[str, str]:
        """映射列名到标准字段名"""
        mapping = {}
        for col in columns:
            col_str = str(col).strip().lower()
            for field, aliases in self.required_columns.items():
                for alias in aliases:
                    if alias.lower() in col_str:
                        mapping[field] = col
                        break
        return mapping

    def _check_required_columns(self, mapping: Dict) -> List[str]:
        """检查必要列"""
        missing = []
        for field in ['student_id', 'student_name']:
            if field not in mapping:
                missing.append(field)
        return missing

    def _clean_data(self, df: pd.DataFrame, mapping: Dict) -> pd.DataFrame:
        """清洗数据"""
        df_cleaned = df.copy()

        # 重命名列
        reverse_mapping = {v: k for k, v in mapping.items()}
        df_cleaned = df_cleaned.rename(columns=reverse_mapping)

        # 处理空值
        df_cleaned = df_cleaned.dropna(subset=['student_id', 'student_name'])

        # 转换数据类型
        numeric_columns = ['attendance', 'homework', 'experiment', 'review_note', 'final']
        for col in numeric_columns:
            if col in df_cleaned.columns:
                df_cleaned[col] = pd.to_numeric(df_cleaned[col], errors='coerce')

        return df_cleaned

    def _validate_data(self, df: pd.DataFrame, mapping: Dict) -> Tuple[List[Dict], List[str]]:
        """验证数据"""
        valid_data = []
        errors = []

        for idx, row in df.iterrows():
            row_errors = []
            data = {'row': idx + 2}  # Excel行号从2开始

            # 验证学号
            student_id = str(row.get('student_id', '')).strip()
            if not student_id:
                row_errors.append('学号不能为空')
            else:
                data['student_id'] = student_id

            # 验证姓名
            student_name = str(row.get('student_name', '')).strip()
            if not student_name:
                row_errors.append('姓名不能为空')
            else:
                data['student_name'] = student_name

            # 验证成绩（0-100）
            score_fields = ['attendance', 'homework', 'experiment', 'review_note', 'final']
            for field in score_fields:
                if field in df.columns:
                    score = row.get(field)
                    if pd.isna(score):
                        score = None
                    elif not (0 <= score <= 100):
                        row_errors.append(f'{field} 成绩必须在0-100之间')
                    else:
                        data[field] = float(score)

            if row_errors:
                errors.append(f"第{idx + 2}行: {'; '.join(row_errors)}")
            else:
                valid_data.append(data)

        return valid_data, errors