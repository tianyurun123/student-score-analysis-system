# Excel 处理逻辑
import pandas as pd
import numpy as np
from io import BytesIO
from typing import Dict, List, Tuple, Optional
import logging
from django.core.files.uploadedfile import UploadedFile

logger = logging.getLogger(__name__)


class ExcelScoreHandler:
    """Excel成绩处理类"""

    def __init__(self):
        self.supported_formats = ['.xlsx', '.xls']
        # 标准字段映射
        self.standard_fields = {
            'student_id': ['学号', 'student_id', 'student', 'id', '学号/工号'],
            'student_name': ['姓名', 'name', 'student_name', '学生姓名'],
            'class_name': ['班级', 'class', 'class_name', '班级名称'],
        }
        # 成绩字段映射（支持多种命名）
        self.score_fields = {
            'attendance': ['考勤', 'attendance', '出勤', '点名', '考勤成绩'],
            'homework': ['作业', 'homework', '作业成绩'],
            'experiment': ['实验', 'experiment', '实验成绩'],
            'review_note': ['复习笔记', 'review', '笔记', '复习笔记成绩', '电子笔记'],
            'final': ['期末', 'final', '期末成绩', '考试成绩', '期末考试', '期末作品', '作品'],
        }

    def parse_excel(self, file: UploadedFile, course_id: int = None) -> Dict:
        """
        解析Excel文件
        Returns: {
            'success': bool,
            'data': List[Dict],  # 成功解析的数据
            'errors': List[str],  # 错误信息
            'columns': List[str],  # 原始列名
            'column_mapping': Dict,  # 列映射关系
            'suggested_fields': List[str],  # 建议的字段名
        }
        """
        try:
            # 读取Excel文件
            file_content = file.read()
            if not file_content:
                return {
                    'success': False,
                    'data': [],
                    'errors': ['文件内容为空'],
                    'columns': [],
                    'column_mapping': {},
                    'suggested_fields': [],
                }
            
            # 先读取前几行，检查是否是说明行
            try:
                df_first = pd.read_excel(BytesIO(file_content), engine='openpyxl', nrows=3, header=None)
            except Exception as e:
                logger.error(f"读取Excel前几行失败: {str(e)}")
                return {
                    'success': False,
                    'data': [],
                    'errors': [f'无法读取Excel文件，请检查文件格式是否正确: {str(e)}'],
                    'columns': [],
                    'column_mapping': {},
                    'suggested_fields': [],
                }
            
            first_row_is_header = False
            
            # 检查第一行是否是说明行（包含"考勤"、"电子笔记"、"作业成绩"等关键词）
            if len(df_first) > 0:
                first_row_values = []
                for val in df_first.iloc[0].values:
                    if pd.notna(val):
                        first_row_values.append(str(val).strip())
                header_keywords = ['考勤', '电子笔记', '作业成绩', '实验', '期末作品', '作品', '总分', '作业', '期末']
                first_row_text = ' '.join(first_row_values)
                if any(keyword in first_row_text for keyword in header_keywords):
                    first_row_is_header = True
                    logger.info(f"检测到第一行是说明行: {first_row_values}")
            
            # 如果第一行是说明行，从第二行开始读取
            try:
                if first_row_is_header:
                    df = pd.read_excel(BytesIO(file_content), engine='openpyxl', header=1)
                    # 使用第一行的值作为列名的一部分（如果原始列名是Unnamed）
                    for i, col in enumerate(df.columns):
                        if str(col).startswith('Unnamed') and i < len(df_first.columns):
                            first_row_val = str(df_first.iloc[0, i]).strip()
                            if first_row_val and first_row_val != 'nan' and first_row_val:
                                # 尝试用第一行的值更新列名
                                if pd.notna(df_first.iloc[0, i]):
                                    df.columns.values[i] = first_row_val
                else:
                    df = pd.read_excel(BytesIO(file_content), engine='openpyxl')
            except Exception as e:
                logger.error(f"读取Excel文件失败: {str(e)}")
                return {
                    'success': False,
                    'data': [],
                    'errors': [f'读取Excel文件失败: {str(e)}'],
                    'columns': [],
                    'column_mapping': {},
                    'suggested_fields': [],
                }
            
            if df.empty:
                return {
                    'success': False,
                    'data': [],
                    'errors': ['Excel文件为空，没有数据'],
                    'columns': [],
                    'column_mapping': {},
                    'suggested_fields': [],
                }

            # 获取原始列名
            original_columns = df.columns.tolist()

            # 映射列名
            column_mapping = self._map_columns(df.columns)
            
            # 识别所有可能的成绩列
            all_score_columns = self._identify_all_score_columns(df.columns)

            # 验证必要列
            missing_required = self._check_required_columns(column_mapping)
            if missing_required:
                # 提供更详细的错误信息
                error_msg = f"缺少必要列: {', '.join(missing_required)}"
                error_msg += f"\n实际找到的列: {', '.join([str(c) for c in original_columns[:10]])}"
                if len(original_columns) > 10:
                    error_msg += f" ... (共{len(original_columns)}列)"
                error_msg += f"\n请确保Excel文件包含'学号'和'姓名'列"
                
                return {
                    'success': False,
                    'data': [],
                    'errors': [error_msg],
                    'columns': original_columns,
                    'column_mapping': column_mapping,
                    'suggested_fields': all_score_columns,
                }

            # 清洗数据
            df_cleaned = self._clean_data(df, column_mapping)

            # 验证数据
            valid_data, errors = self._validate_data(df_cleaned, column_mapping, all_score_columns)

            return {
                'success': len(valid_data) > 0,
                'data': valid_data,
                'errors': errors,
                'columns': original_columns,
                'column_mapping': column_mapping,
                'suggested_fields': all_score_columns,
            }

        except Exception as e:
            import traceback
            error_detail = traceback.format_exc()
            logger.error(f"解析Excel文件失败: {str(e)}\n{error_detail}")
            return {
                'success': False,
                'data': [],
                'errors': [f"文件解析失败: {str(e)}。请检查：1) 文件格式是否为.xlsx或.xls；2) 文件是否损坏；3) 是否包含必要列（学号、姓名）"],
                'columns': [],
                'column_mapping': {},
                'suggested_fields': [],
            }

    def _map_columns(self, columns: pd.Index) -> Dict[str, str]:
        """映射列名到标准字段名"""
        mapping = {}
        col_list = list(columns)
        
        for col in col_list:
            col_str = str(col).strip()
            col_lower = col_str.lower()
            
            # 跳过空列名
            if not col_str or col_str == 'nan' or col_str.startswith('Unnamed'):
                continue

            # 映射标准字段（学号、姓名、班级）
            for field, aliases in self.standard_fields.items():
                if field not in mapping:
                    for alias in aliases:
                        alias_lower = alias.lower()
                        # 更宽松的匹配：包含关键词或完全匹配
                        if (alias_lower in col_lower or 
                            col_lower in alias_lower or 
                            col_str == alias or
                            col_str.startswith(alias) or
                            alias in col_str):
                            mapping[field] = col
                            logger.debug(f"映射 {col_str} -> {field}")
                            break

            # 映射成绩字段（优先匹配更具体的名称）
            # 先检查特殊字段
            if '电子笔记' in col_str and 'review_note' not in mapping:
                mapping['review_note'] = col
                logger.debug(f"映射 {col_str} -> review_note (电子笔记)")
            elif ('期末作品' in col_str or '作品' in col_str) and 'final' not in mapping:
                mapping['final'] = col
                logger.debug(f"映射 {col_str} -> final (作品)")
            elif ('作业成绩' in col_str or ('作业' in col_str and '成绩' in col_str)) and 'homework' not in mapping:
                mapping['homework'] = col
                logger.debug(f"映射 {col_str} -> homework (作业)")
            else:
                # 标准映射
                for score_field, aliases in self.score_fields.items():
                    if score_field not in mapping:
                        for alias in aliases:
                            alias_lower = alias.lower()
                            if (alias_lower in col_lower or 
                                col_lower in alias_lower or
                                alias in col_str):
                                mapping[score_field] = col
                                logger.debug(f"映射 {col_str} -> {score_field}")
                                break
                        if score_field in mapping:
                            break

        logger.info(f"列映射结果: {mapping}")
        return mapping

    def _identify_all_score_columns(self, columns: pd.Index) -> List[str]:
        """识别所有可能的成绩列（包括未映射的）"""
        score_columns = []
        mapped_columns = set()

        # 获取已映射的列
        mapping = self._map_columns(columns)
        for col in columns:
            col_str = str(col).strip()
            col_lower = col_str.lower()

            # 跳过已映射的列
            if col in mapping.values():
                mapped_columns.add(col)
                continue

            # 跳过标准字段（学号、姓名、班级）
            if col_str in ['学号', '姓名', '班级', 'student_id', 'student_name', 'class_name', 
                          'name', 'id', 'class']:
                continue

            # 检查是否是成绩相关的列（包含数字或成绩相关关键词）
            score_keywords = ['成绩', '分', 'score', 'grade', 'point', '作业', '实验', '考勤', 
                            '点名', '笔记', '作品', '报告', '期末', '考试', '电子笔记', '复习笔记']
            if any(keyword in col_str for keyword in score_keywords):
                score_columns.append(col_str)
            # 或者检查列中是否包含数值数据
            else:
                # 这里会在验证阶段进一步检查
                pass

        return score_columns

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

        # 处理空值 - 删除学号和姓名都为空的行
        # 先确保列存在
        if 'student_id' in df_cleaned.columns and 'student_name' in df_cleaned.columns:
            # 删除学号和姓名都为空的行
            df_cleaned = df_cleaned.dropna(subset=['student_id', 'student_name'], how='all')
        elif 'student_id' in df_cleaned.columns:
            df_cleaned = df_cleaned.dropna(subset=['student_id'])
        elif 'student_name' in df_cleaned.columns:
            df_cleaned = df_cleaned.dropna(subset=['student_name'])

        # 转换数据类型
        numeric_columns = ['attendance', 'homework', 'experiment', 'review_note', 'final']
        for col in numeric_columns:
            if col in df_cleaned.columns:
                # 先转换为字符串，去除空格，再转换为数字
                df_cleaned[col] = df_cleaned[col].astype(str).str.strip()
                df_cleaned[col] = pd.to_numeric(df_cleaned[col], errors='coerce')

        return df_cleaned

    def _validate_data(self, df: pd.DataFrame, mapping: Dict, all_score_columns: List[str]) -> Tuple[List[Dict], List[str]]:
        """验证数据"""
        valid_data = []
        errors = []

        for idx, row in df.iterrows():
            row_errors = []
            data = {'row': idx + 2}  # Excel行号从2开始

            # 验证学号
            student_id = str(row.get('student_id', '')).strip()
            if not student_id or pd.isna(row.get('student_id')):
                row_errors.append('学号不能为空')
            else:
                data['student_id'] = student_id

            # 验证姓名
            student_name = str(row.get('student_name', '')).strip()
            if not student_name or pd.isna(row.get('student_name')):
                row_errors.append('姓名不能为空')
            else:
                data['student_name'] = student_name

            # 验证班级（可选）
            if 'class_name' in df.columns:
                class_name = str(row.get('class_name', '')).strip()
                if class_name and not pd.isna(row.get('class_name')):
                    data['class_name'] = class_name

            # 验证标准成绩字段（0-100）
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
                        # 特殊处理：如果字段是"电子笔记"，也保存到extra_scores
                        if field == 'review_note':
                            col_name = str(mapping.get('review_note', ''))
                            if '电子笔记' in col_name:
                                if 'extra_scores' not in data:
                                    data['extra_scores'] = {}
                                data['extra_scores']['电子笔记'] = float(score)
                        # 特殊处理：如果字段是"期末作品"或"作品"，也保存到extra_scores
                        if field == 'final':
                            col_name = str(mapping.get('final', ''))
                            if '作品' in col_name:
                                if 'extra_scores' not in data:
                                    data['extra_scores'] = {}
                                data['extra_scores']['作品'] = float(score)

            # 收集其他成绩列（动态字段）
            extra_scores = {}
            mapped_cols = set(mapping.values())
            
            # 遍历所有列，找出未映射的成绩列
            for orig_col in df.columns:
                col_str = str(orig_col).strip()
                
                # 跳过已映射的列和标准字段
                if orig_col in mapped_cols:
                    continue
                if col_str in ['学号', '姓名', '班级', 'student_id', 'student_name', 'class_name']:
                    continue
                
                # 检查是否是成绩列（在建议列表中，或包含成绩关键词）
                is_score_col = (
                    col_str in all_score_columns or
                    any(keyword in col_str for keyword in ['成绩', '分', 'score', 'grade', 'point', 
                                                          '作业', '实验', '考勤', '点名', '笔记', 
                                                          '作品', '报告', '期末', '考试'])
                )
                
                if is_score_col:
                    score = row.get(orig_col)
                    if not pd.isna(score) and score is not None:
                        try:
                            score_val = float(score)
                            if 0 <= score_val <= 100:
                                extra_scores[col_str] = score_val
                        except (ValueError, TypeError):
                            pass

            if extra_scores:
                data['extra_scores'] = extra_scores

            if row_errors:
                errors.append(f"第{idx + 2}行: {'; '.join(row_errors)}")
            else:
                valid_data.append(data)

        return valid_data, errors

    def import_scores(self, data: List[Dict], course_class_id: int, user_id: int, column_mapping: Dict = None) -> Dict:
        """
        导入成绩数据到数据库
        Returns: {
            'success': int,  # 成功数量
            'failed': int,   # 失败数量
            'errors': List[str]  # 错误信息
        }
        """
        from apps.scores.models import Score, ScoreImportLog
        from apps.courses.models import CourseClass, GradingPolicy
        from apps.users.models import User, StudentProfile
        from django.utils import timezone

        success_count = 0
        failed_count = 0
        errors = []

        try:
            from django.db import transaction
            
            course_class = CourseClass.objects.select_related('course', 'course__grading_policy').get(id=course_class_id)
            user = User.objects.get(id=user_id)
            grading_policy = course_class.course.grading_policy
            
            # 如果没有评分政策，创建一个默认的
            if not grading_policy:
                from apps.courses.models import GradingPolicy
                grading_policy = GradingPolicy.objects.create(
                    course=course_class.course,
                    usual_weight=0.3,
                    final_weight=0.7,
                    attendance_weight=0.2,
                    homework_weight=0.3,
                    experiment_weight=0.3,
                    review_note_weight=0.2
                )

            # 批量获取所有学号
            student_ids = [item.get('student_id') for item in data if item.get('student_id')]
            student_ids = list(set(student_ids))  # 去重
            
            # 批量查询已存在的学生
            existing_students = {}
            existing_profiles = StudentProfile.objects.filter(student_id__in=student_ids).select_related('user')
            for profile in existing_profiles:
                existing_students[profile.student_id] = profile.user
            
            existing_users = User.objects.filter(
                username__in=student_ids,
                user_type='student'
            )
            for user_obj in existing_users:
                if user_obj.employee_id and user_obj.employee_id not in existing_students:
                    existing_students[user_obj.employee_id] = user_obj
                if user_obj.username not in existing_students:
                    existing_students[user_obj.username] = user_obj

            # 批量创建新学生
            new_student_map = {}
            
            for item in data:
                student_id = item.get('student_id')
                if not student_id:
                    continue
                
                if student_id not in existing_students and student_id not in new_student_map:
                    new_student_map[student_id] = item

            # 批量创建用户（使用事务）
            if new_student_map:
                with transaction.atomic():
                    students_to_create = []
                    # 获取不可用密码的哈希值
                    from django.contrib.auth.hashers import make_password
                    unusable_password = make_password(None)  # None会生成不可用密码
                    
                    for student_id, item_data in new_student_map.items():
                        user_obj = User(
                            username=student_id,
                            first_name=item_data.get('student_name', student_id),
                            user_type='student',
                            employee_id=student_id,
                            password=unusable_password  # 直接设置不可用密码
                        )
                        students_to_create.append(user_obj)
                    
                    if students_to_create:
                        # 批量创建用户
                        User.objects.bulk_create(students_to_create, ignore_conflicts=True)
                        
                        # 重新查询创建的用户
                        created_usernames = [u.username for u in students_to_create]
                        created_users = User.objects.filter(
                            username__in=created_usernames,
                            user_type='student'
                        )
                        for user_obj in created_users:
                            existing_students[user_obj.username] = user_obj
                        
                        # 批量创建StudentProfile
                        profiles_to_create = []
                        for user_obj in created_users:
                            student_id = user_obj.username
                            item_data = new_student_map.get(student_id, {})
                            profile = StudentProfile(
                                user=user_obj,
                                student_id=student_id,
                                grade=timezone.now().year - 4,
                                class_name=item_data.get('class_name', ''),
                                major='',
                                enrollment_date=timezone.now().date(),
                                expected_graduation=timezone.now().date().replace(year=timezone.now().year + 4)
                            )
                            profiles_to_create.append(profile)
                        
                        if profiles_to_create:
                            StudentProfile.objects.bulk_create(profiles_to_create, ignore_conflicts=True)

            # 批量获取已存在的成绩记录
            student_user_ids = [s.id for s in existing_students.values() if s]
            existing_scores = {}
            if student_user_ids:
                scores = Score.objects.filter(
                    course_class=course_class,
                    student_id__in=student_user_ids
                ).select_related('student')
                for score in scores:
                    student_id = score.student.employee_id or score.student.username
                    existing_scores[student_id] = score

            # 处理成绩数据
            scores_to_update = []
            scores_to_create = []
            
            for item in data:
                try:
                    student_id = item.get('student_id')
                    if not student_id:
                        failed_count += 1
                        errors.append(f"第{item.get('row', '?')}行: 学号为空")
                        continue
                    
                    student = existing_students.get(student_id)
                    if not student:
                        failed_count += 1
                        errors.append(f"第{item.get('row', '?')}行: 无法找到或创建学生 {student_id}")
                        continue

                    # 准备extra_scores
                    extra_scores = item.get('extra_scores', {}).copy() if item.get('extra_scores') else {}
                    if 'review_note' in item and column_mapping and column_mapping.get('review_note'):
                        col_name = str(column_mapping['review_note'])
                        if '电子笔记' in col_name or '笔记' in col_name:
                            extra_scores['电子笔记'] = item['review_note']
                    if 'final' in item and column_mapping and column_mapping.get('final'):
                        col_name = str(column_mapping['final'])
                        if '作品' in col_name or '期末作品' in col_name:
                            extra_scores['作品'] = item['final']

                    # 检查是否已存在成绩记录
                    if student_id in existing_scores:
                        score = existing_scores[student_id]
                        # 更新成绩数据
                        if 'attendance' in item:
                            score.attendance_score = item['attendance']
                        if 'homework' in item:
                            score.homework_score = item['homework']
                        if 'experiment' in item:
                            score.experiment_score = item['experiment']
                        if 'review_note' in item:
                            score.review_note_score = item['review_note']
                        if 'final' in item:
                            score.final_score = item['final']
                        if extra_scores:
                            if not score.extra_scores:
                                score.extra_scores = {}
                            score.extra_scores.update(extra_scores)
                        score.updated_by = user
                        scores_to_update.append(score)
                    else:
                        # 创建新成绩记录
                        score = Score(
                            student=student,
                            course_class=course_class,
                            grading_policy=grading_policy,
                            attendance_score=item.get('attendance'),
                            homework_score=item.get('homework'),
                            experiment_score=item.get('experiment'),
                            review_note_score=item.get('review_note'),
                            final_score=item.get('final'),
                            extra_scores=extra_scores,
                            created_by=user,
                            updated_by=user
                        )
                        scores_to_create.append(score)

                except Exception as e:
                    failed_count += 1
                    errors.append(f"第{item.get('row', '?')}行: {str(e)}")
                    logger.error(f"处理成绩数据失败: {str(e)}")

            # 批量更新成绩（先更新数据，不触发计算）
            if scores_to_update:
                Score.objects.bulk_update(
                    scores_to_update,
                    ['attendance_score', 'homework_score', 'experiment_score', 
                     'review_note_score', 'final_score', 'extra_scores', 'updated_by'],
                    batch_size=100
                )
                # 批量计算成绩（分批处理，避免内存问题和超时）
                scores_to_recalculate = []
                batch_calc_size = 200  # 每批计算200条
                for i in range(0, len(scores_to_update), batch_calc_size):
                    batch = scores_to_update[i:i+batch_calc_size]
                    batch_recalculate = []
                    
                    for score in batch:
                        try:
                            # 确保grading_policy已加载
                            if not score.grading_policy:
                                score.grading_policy = grading_policy
                            # 直接计算成绩字段，不调用save
                            score.calculate_grade()
                            batch_recalculate.append(score)
                            success_count += 1
                        except Exception as e:
                            failed_count += 1
                            errors.append(f"计算成绩失败 {score.student.username}: {str(e)}")
                            logger.error(f"计算成绩失败: {str(e)}", exc_info=True)
                    
                    # 每批计算完后立即批量更新，避免内存积累
                    if batch_recalculate:
                        Score.objects.bulk_update(
                            batch_recalculate,
                            ['usual_total', 'final_total', 'usual_entry', 'final_entry', 'final_grade', 'grade_point', 'grade_level'],
                            batch_size=100
                        )
                        scores_to_recalculate.extend(batch_recalculate)
                
                # 课程目标达成度计算延迟到后台（避免阻塞导入）
                logger.info(f"已更新 {len(scores_to_recalculate)} 条成绩记录，课程目标达成度将在后台计算")

            # 批量创建成绩（分批处理，避免内存问题）
            if scores_to_create:
                # 分批计算和创建
                batch_create_size = 200  # 每批创建200条
                for i in range(0, len(scores_to_create), batch_create_size):
                    batch = scores_to_create[i:i+batch_create_size]
                    
                    # 先计算成绩字段
                    for score in batch:
                        try:
                            # 确保grading_policy已设置
                            if not score.grading_policy:
                                score.grading_policy = grading_policy
                            score.calculate_grade()
                        except Exception as e:
                            logger.warning(f"预计算成绩失败: {str(e)}")
                            # 即使计算失败，也继续创建记录
                    
                    # 批量创建（包含计算后的成绩字段）
                    Score.objects.bulk_create(batch, batch_size=100)
                    success_count += len(batch)
                
                # 课程目标达成度计算延迟到后台（避免阻塞导入）
                # 可以通过定时任务或异步任务批量计算
                logger.info(f"已创建 {len(scores_to_create)} 条成绩记录，课程目标达成度将在后台计算")

            return {
                'success': success_count,
                'failed': failed_count,
                'errors': errors[:50]  # 只返回前50个错误，避免响应过大
            }

        except Exception as e:
            logger.error(f"批量导入成绩失败: {str(e)}")
            return {
                'success': 0,
                'failed': len(data),
                'errors': [f"导入失败: {str(e)}"]
            }


class GradebookExcelHandler:
    """记分册Excel处理类"""

    def __init__(self):
        self.supported_formats = ['.xlsx', '.xls']
        # 字段映射（支持多种命名方式）
        self.field_mapping = {
            'student_id': ['学号', 'student_id', 'student', 'id', '学号/工号', 'studentid'],
            'student_name': ['姓名', 'name', 'student_name', '学生姓名', '姓名/名称'],
            'homework1': ['作业1', 'homework1', '作业一', 'hw1'],
            'homework2': ['作业2', 'homework2', '作业二', 'hw2'],
            'homework3': ['作业3', 'homework3', '作业三', 'hw3'],
            'homework4': ['作业4', 'homework4', '作业四', 'hw4'],
            'homework5': ['作业5', 'homework5', '作业五', 'hw5'],
            'experiment1': ['实验1', 'experiment1', '实验一', 'exp1'],
            'experiment2': ['实验2', 'experiment2', '实验二', 'exp2'],
            'attendance1': ['考勤1', 'attendance1', '考勤一', 'att1'],
            'attendance2': ['考勤2', 'attendance2', '考勤二', 'att2'],
            'attendance3': ['考勤3', 'attendance3', '考勤三', 'att3'],
            'attendance4': ['考勤4', 'attendance4', '考勤四', 'att4'],
            'attendance5': ['考勤5', 'attendance5', '考勤五', 'att5'],
            'review_note': ['复习笔记', 'review_note', '笔记', '复习', 'review'],
            'system_score': ['系统', 'system', '系统成绩', 'sys'],
            'report_score': ['报告', 'report', '报告成绩'],
            'final_score': ['期末成绩', 'final_score', '期末', 'final', '期末考试', '期末考'],
        }

    def parse_excel(self, file: UploadedFile, course_class_id: int = None) -> Dict:
        """解析记分册Excel文件"""
        try:
            file_content = file.read()
            if not file_content:
                return {
                    'success': False,
                    'data': [],
                    'errors': ['文件内容为空'],
                    'column_mapping': {},
                }

            # 先读取前10行，查找表头行
            try:
                df_preview = pd.read_excel(BytesIO(file_content), engine='openpyxl', header=None, nrows=10)
            except Exception as e:
                logger.error(f"读取Excel前几行失败: {str(e)}")
                return {
                    'success': False,
                    'data': [],
                    'errors': [f'无法读取Excel文件: {str(e)}'],
                    'column_mapping': {},
                }

            # 查找表头行（包含"学号"、"姓名"等关键词的行）
            header_row_index = None
            header_keywords = ['学号', '姓名', '作业', '实验', '考勤', '复习笔记', '期末']
            
            for idx in range(min(10, len(df_preview))):
                row_values = []
                for val in df_preview.iloc[idx].values:
                    if pd.notna(val):
                        row_values.append(str(val).strip())
                row_text = ' '.join(row_values)
                
                # 检查是否包含表头关键词
                keyword_count = sum(1 for keyword in header_keywords if keyword in row_text)
                if keyword_count >= 2:  # 至少包含2个关键词才认为是表头
                    header_row_index = idx
                    logger.info(f"找到表头行: 第{idx+1}行, 内容: {row_values[:5]}")
                    break

            if header_row_index is None:
                # 如果没找到表头，尝试使用第一行
                logger.warning("未找到明确的表头行，尝试使用第一行")
                header_row_index = 0

            # 读取Excel，使用找到的表头行
            try:
                df = pd.read_excel(BytesIO(file_content), engine='openpyxl', header=header_row_index)
                logger.info(f"读取Excel成功: 共{len(df)}行, 列数: {len(df.columns)}")
                logger.info(f"列名: {list(df.columns)[:10]}")
                
                # 删除所有列都为空的行
                df = df.dropna(how='all')
                logger.info(f"删除空行后: 共{len(df)}行")
                
                # 显示前几行数据用于调试
                if len(df) > 0:
                    logger.info(f"第一行数据: {df.iloc[0].to_dict()}")
            except Exception as e:
                logger.error(f"读取Excel文件失败: {str(e)}", exc_info=True)
                return {
                    'success': False,
                    'data': [],
                    'errors': [f'无法读取Excel文件: {str(e)}'],
                    'column_mapping': {},
                }
            
            # 识别列名（支持部分匹配和模糊匹配）
            column_mapping = {}
            for col in df.columns:
                col_str = str(col).strip()
                # 去除可能的空格、换行符和特殊字符
                col_str_clean = col_str.replace(' ', '').replace('\n', '').replace('\t', '').replace('\r', '')
                
                # 精确匹配
                matched = False
                for field, aliases in self.field_mapping.items():
                    # 检查原始字符串和清理后的字符串
                    if col_str in aliases or col_str_clean in aliases:
                        column_mapping[col] = field
                        matched = True
                        logger.debug(f"精确匹配: {col_str} -> {field}")
                        break
                
                # 如果精确匹配失败，尝试部分匹配（包含关系）
                if not matched:
                    for field, aliases in self.field_mapping.items():
                        for alias in aliases:
                            # 检查别名是否在列名中，或列名是否在别名中
                            if alias in col_str or col_str in alias or alias in col_str_clean or col_str_clean in alias:
                                column_mapping[col] = field
                                matched = True
                                logger.debug(f"部分匹配: {col_str} -> {field} (通过别名: {alias})")
                                break
                        if matched:
                            break
                
                # 如果还是没匹配，尝试更宽松的匹配（只检查关键词）
                if not matched:
                    col_lower = col_str.lower()
                    for field, aliases in self.field_mapping.items():
                        for alias in aliases:
                            alias_lower = alias.lower()
                            # 检查关键词是否在列名中
                            if len(alias_lower) >= 2 and (alias_lower in col_lower or col_lower in alias_lower):
                                # 避免重复匹配（如果已经有其他字段匹配了）
                                if col not in column_mapping:
                                    column_mapping[col] = field
                                    matched = True
                                    logger.debug(f"关键词匹配: {col_str} -> {field} (通过关键词: {alias})")
                                    break
                        if matched:
                            break
            
            logger.info(f"列名识别结果: {column_mapping}")
            logger.info(f"所有原始列名: {[str(col) for col in df.columns]}")
            
            # 检查是否识别到了学号和姓名
            if 'student_id' not in column_mapping.values():
                logger.error("未识别到学号列")
            if 'student_name' not in column_mapping.values():
                logger.error("未识别到姓名列")
                # 尝试手动查找姓名列
                for col in df.columns:
                    col_str = str(col).strip()
                    if '姓名' in col_str or 'name' in col_str.lower():
                        logger.warning(f"找到可能的姓名列: {col_str}, 但未匹配成功")
                        # 强制匹配
                        column_mapping[col] = 'student_name'
                        logger.info(f"强制匹配姓名列: {col_str} -> student_name")

            # 验证必需字段
            required_fields = ['student_id', 'student_name']
            missing_fields = []
            for field in required_fields:
                if field not in column_mapping.values():
                    missing_fields.append(field)

            if missing_fields:
                # 返回更详细的错误信息，包括实际列名
                actual_columns = [str(col) for col in df.columns]
                return {
                    'success': False,
                    'data': [],
                    'errors': [
                        f'缺少必需字段: {", ".join(missing_fields)}',
                        f'Excel文件中的列名: {", ".join(actual_columns[:10])}'
                    ],
                    'column_mapping': {},
                    'actual_columns': actual_columns,
                }

            # 解析数据
            data = []
            errors = []
            logger.info(f"开始解析数据，共{len(df)}行")
            
            for idx, row in df.iterrows():
                try:
                    record = {}
                    row_dict = row.to_dict()  # 保存原始行数据用于调试和备用查找
                    
                    for col, field in column_mapping.items():
                        value = row[col]
                        # 处理NaN和空值
                        if pd.isna(value) or (isinstance(value, str) and value.strip() == ''):
                            value = None
                        
                        if value is not None and value != '':
                            if field in ['homework1', 'homework2', 'homework3', 'homework4', 'homework5',
                                        'experiment1', 'experiment2',
                                        'attendance1', 'attendance2', 'attendance3', 'attendance4', 'attendance5',
                                        'review_note', 'final_score', 'system_score', 'report_score']:
                                try:
                                    # 尝试转换为浮点数
                                    if isinstance(value, str):
                                        value = value.strip()
                                        if value == '' or value.lower() in ['nan', 'none', 'null', '-']:
                                            record[field] = None
                                        else:
                                            record[field] = float(value)
                                    else:
                                        record[field] = float(value)
                                except (ValueError, TypeError) as e:
                                    logger.warning(f"第{idx+header_row_index+2}行 {field} 转换失败: {value}, 错误: {str(e)}")
                                    record[field] = None
                            else:
                                # 学号、姓名等文本字段
                                # 处理数字类型的学号
                                if field == 'student_id' and isinstance(value, (int, float)):
                                    record[field] = str(int(value))
                                else:
                                    record[field] = str(value).strip() if value else ''
                        else:
                            # 空值处理
                            if field in ['homework1', 'homework2', 'homework3', 'homework4', 'homework5',
                                        'experiment1', 'experiment2',
                                        'attendance1', 'attendance2', 'attendance3', 'attendance4', 'attendance5',
                                        'review_note', 'final_score']:
                                record[field] = None
                            else:
                                record[field] = ''
                    
                    # 如果姓名列没有识别到或值为空，尝试从原始数据中查找
                    if not record.get('student_name') or record.get('student_name', '').strip() == '':
                        for col_name, col_value in row_dict.items():
                            col_str = str(col_name).strip()
                            # 检查列名是否包含"姓名"
                            if ('姓名' in col_str or 'name' in col_str.lower()) and pd.notna(col_value):
                                col_value_str = str(col_value).strip()
                                if col_value_str and col_value_str.lower() not in ['nan', 'none', 'null', '']:
                                    record['student_name'] = col_value_str
                                    logger.info(f"第{idx+header_row_index+2}行: 从列 '{col_str}' 找到姓名: {col_value_str}")
                                    break

                    # 验证必需字段（学号和姓名不能为空）
                    student_id_raw = record.get('student_id', '')
                    student_name_raw = record.get('student_name', '')
                    
                    # 处理学号可能是数字类型的情况
                    if student_id_raw is None:
                        student_id = ''
                    elif isinstance(student_id_raw, (int, float)):
                        student_id = str(int(student_id_raw)).strip()
                    else:
                        student_id = str(student_id_raw).strip()
                    
                    # 处理姓名
                    if student_name_raw is None:
                        student_name = ''
                    else:
                        student_name = str(student_name_raw).strip()
                    
                    if not student_id or not student_name or student_id == 'nan' or student_name == 'nan':
                        # 输出更详细的调试信息
                        logger.warning(f"第{idx+header_row_index+2}行验证失败: 学号={student_id}, 姓名={student_name}")
                        logger.warning(f"原始记录: {record}")
                        logger.warning(f"原始行数据前5列: {dict(list(row_dict.items())[:5])}")
                        errors.append(f'第{idx+header_row_index+2}行: 学号或姓名为空 (学号: {student_id}, 姓名: {student_name})')
                        continue
                    
                    # 确保学号和姓名是字符串
                    record['student_id'] = student_id
                    record['student_name'] = student_name

                    data.append(record)
                    logger.debug(f"成功解析第{idx+header_row_index+2}行: 学号={student_id}, 姓名={student_name}")
                except Exception as e:
                    logger.error(f"第{idx+2}行解析失败: {str(e)}", exc_info=True)
                    errors.append(f'第{idx+2}行解析失败: {str(e)}')

            logger.info(f"解析记分册Excel成功: 识别到 {len(column_mapping)} 个字段, {len(data)} 条有效数据, {len(errors)} 个错误")
            if data:
                logger.info(f"第一条数据示例: {data[0]}")
            
            return {
                'success': True,
                'data': data,
                'errors': errors,
                'column_mapping': {str(k): v for k, v in column_mapping.items()},
            }

        except Exception as e:
            logger.error(f"解析记分册Excel失败: {str(e)}", exc_info=True)
            return {
                'success': False,
                'data': [],
                'errors': [f'解析Excel失败: {str(e)}'],
                'column_mapping': {},
            }

    def import_gradebooks(self, data: List[Dict], course_class_id: int, user_id: int) -> Dict:
        """导入记分册数据"""
        from apps.scores.models import Gradebook
        from apps.courses.models import CourseClass
        from apps.users.models import User, StudentProfile
        from django.utils import timezone
        from django.db.models import Q

        success_count = 0
        failed_count = 0
        errors = []

        try:
            from django.db import transaction

            course_class = CourseClass.objects.get(id=course_class_id)
            user = User.objects.get(id=user_id)

            with transaction.atomic():
                for item in data:
                    try:
                        student_id = str(item.get('student_id', '')).strip()
                        student_name = str(item.get('student_name', '')).strip()

                        if not student_id or not student_name:
                            errors.append(f'学号或姓名为空: {item}')
                            failed_count += 1
                            continue

                        # 查找或创建学生
                        student = None
                        try:
                            student_profile = StudentProfile.objects.get(student_id=student_id)
                            student = student_profile.user
                        except StudentProfile.DoesNotExist:
                            try:
                                student = User.objects.get(
                                    Q(employee_id=student_id) | Q(username=student_id),
                                    user_type='student'
                                )
                            except User.DoesNotExist:
                                student = User.objects.create_user(
                                    username=student_id,
                                    first_name=student_name,
                                    user_type='student',
                                    employee_id=student_id
                                )
                                StudentProfile.objects.create(
                                    user=student,
                                    student_id=student_id,
                                    grade=timezone.now().year - 4,
                                    class_name='',
                                    major='',
                                    enrollment_date=timezone.now().date(),
                                    expected_graduation=timezone.now().date().replace(year=timezone.now().year + 4)
                                )

                        # 创建或更新记分册记录
                        gradebook, created = Gradebook.objects.update_or_create(
                            student=student,
                            course_class=course_class,
                            defaults={
                                'homework1': item.get('homework1'),
                                'homework2': item.get('homework2'),
                                'homework3': item.get('homework3'),
                                'homework4': item.get('homework4'),
                                'homework5': item.get('homework5'),
                                'experiment1': item.get('experiment1'),
                                'experiment2': item.get('experiment2'),
                                'attendance1': item.get('attendance1'),
                                'attendance2': item.get('attendance2'),
                                'attendance3': item.get('attendance3'),
                                'attendance4': item.get('attendance4'),
                                'attendance5': item.get('attendance5'),
                                'review_note': item.get('review_note'),
                                'system_score': item.get('system_score'),
                                'report_score': item.get('report_score'),
                                'final_score': item.get('final_score'),
                                'updated_by': user,
                            }
                        )

                        if created:
                            gradebook.created_by = user
                            logger.info(f"创建记分册记录: 学生={student_id}, 班级={course_class.id} ({course_class.class_name})")

                        # 重新计算成绩并保存（会触发Score记录的创建/更新）
                        gradebook.calculate_scores()
                        gradebook.save()

                        success_count += 1
                    except Exception as e:
                        error_msg = f'导入失败 {item.get("student_id", "未知")}: {str(e)}'
                        errors.append(error_msg)
                        failed_count += 1
                        logger.error(error_msg, exc_info=True)

            # 验证导入的数据
            final_count = Gradebook.objects.filter(course_class_id=course_class_id).count()
            logger.info(f"导入完成: 成功{success_count}条, 失败{failed_count}条, 数据库中该班级共有{final_count}条记分册记录")

            return {
                'success': success_count,
                'failed': failed_count,
                'errors': errors,
            }

        except Exception as e:
            logger.error(f"导入记分册数据失败: {str(e)}", exc_info=True)
            return {
                'success': success_count,
                'failed': failed_count + len(data) - success_count,
                'errors': [f'导入失败: {str(e)}'] + errors,
            }


class FinalPaperExcelHandler:
    """卷面成绩Excel处理类（用于算法分析与设计课程）"""
    
    def __init__(self):
        self.supported_formats = ['.xlsx', '.xls']
    
    def parse_excel(self, file: UploadedFile, course_class_id: int = None) -> Dict:
        """
        解析卷面成绩Excel文件
        格式：
        - 第1行：大题题号（如M1, M2, M3, M4）
        - 第2行：小题题号（如1, 2, 3）
        - 第3行：分值
        - 第4行开始：学生成绩（学号、姓名、大题题号、小题题号、卷面）
        """
        try:
            file_content = file.read()
            if not file_content:
                return {
                    'success': False,
                    'data': [],
                    'errors': ['文件内容为空'],
                    'question_structure': {},
                }
            
            # 读取前几行，获取题目结构
            try:
                df_structure = pd.read_excel(BytesIO(file_content), engine='openpyxl', header=None, nrows=3)
                logger.info(f"读取题目结构: {len(df_structure)}行, {len(df_structure.columns)}列")
            except Exception as e:
                logger.error(f"读取Excel前几行失败: {str(e)}")
                return {
                    'success': False,
                    'data': [],
                    'errors': [f'无法读取Excel文件: {str(e)}'],
                    'question_structure': {},
                }
            
            # 解析题目结构
            question_structure = {}
            # 第1行：大题题号（可能包含"学号"、"姓名"）
            major_questions = {}
            # 第2行：小题题号
            minor_questions = {}
            # 第3行：分值
            scores = {}
            
            # 识别学号和姓名列（在第1行）
            student_id_col = None
            student_name_col = None
            
            # 处理合并单元格：如果第1行为空，使用前一个非空单元格的值
            last_major_q = None
            for col_idx in range(len(df_structure.columns)):
                major_q_raw = df_structure.iloc[0, col_idx]
                major_q = str(major_q_raw).strip() if pd.notna(major_q_raw) else ''
                minor_q = str(df_structure.iloc[1, col_idx]).strip() if pd.notna(df_structure.iloc[1, col_idx]) else ''
                score_val = df_structure.iloc[2, col_idx]
                
                # 处理合并单元格：如果第1行为空，使用前一个非空值
                if not major_q or major_q == 'nan' or major_q == '':
                    major_q = last_major_q
                else:
                    last_major_q = major_q
                
                # 识别学号和姓名列
                if '学号' in major_q or (major_q.isdigit() and len(major_q) > 5) or (student_id_col is None and col_idx == 0):
                    if student_id_col is None:
                        student_id_col = col_idx
                        continue
                if '姓名' in major_q or (student_name_col is None and col_idx == 1):
                    if student_name_col is None:
                        student_name_col = col_idx
                        continue
                
                # 跳过学号和姓名列
                if col_idx == student_id_col or col_idx == student_name_col:
                    continue
                
                if pd.notna(score_val):
                    try:
                        score_val = float(score_val)
                    except (ValueError, TypeError):
                        score_val = None
                else:
                    score_val = None
                
                # 处理大题题号（支持"一"、"二"、"三"、"四"、"卷面"等格式）
                if major_q and major_q != 'nan' and major_q not in ['学号', '姓名']:
                    # 标准化大题题号（将"一"、"二"等转换为标准格式，或保持原样）
                    if major_q not in major_questions:
                        major_questions[major_q] = {}
                    if minor_q and minor_q != 'nan':
                        major_questions[major_q][minor_q] = {
                            'column': col_idx,
                            'score': score_val
                        }
                    # 即使没有小题题号，也记录大题（用于只有总分的情况）
                    elif not minor_q or minor_q == 'nan':
                        # 如果第2行没有小题题号，可能是总分列
                        if 'total' not in major_questions[major_q]:
                            major_questions[major_q]['total'] = {
                                'column': col_idx,
                                'score': score_val
                            }
            
            question_structure = major_questions
            logger.info(f"题目结构: {question_structure}, 学号列: {student_id_col}, 姓名列: {student_name_col}")
            
            # 从第4行开始读取学生成绩数据
            try:
                # 先读取所有数据，然后跳过前3行
                df_all = pd.read_excel(BytesIO(file_content), engine='openpyxl', header=None)
                df = df_all.iloc[3:].copy()  # 跳过前3行
                df.columns = range(len(df.columns))  # 重置列索引
                df = df.dropna(how='all')  # 删除所有列都为空的行
                logger.info(f"读取学生成绩数据: 共{len(df)}行")
            except Exception as e:
                logger.error(f"读取Excel文件失败: {str(e)}", exc_info=True)
                return {
                    'success': False,
                    'data': [],
                    'errors': [f'无法读取Excel文件: {str(e)}'],
                    'question_structure': {},
                }
            
            # 使用从题目结构中识别出的学号和姓名列
            # 如果之前没识别到，尝试从数据中识别
            if student_id_col is None or student_name_col is None:
                # 尝试识别学号和姓名列（通常是前两列）
                for col_idx in range(min(5, len(df.columns))):
                    col_data = df.iloc[:, col_idx].dropna()
                    if len(col_data) > 0:
                        # 检查是否是学号列（通常是数字或字符串）
                        sample_val = str(col_data.iloc[0]) if len(col_data) > 0 else ''
                        if student_id_col is None and (sample_val.isdigit() or len(sample_val) > 5):
                            student_id_col = col_idx
                        # 检查是否是姓名列
                        elif student_name_col is None and student_id_col is not None and col_idx == student_id_col + 1:
                            student_name_col = col_idx
                
                # 如果没找到，默认前两列是学号和姓名
                if student_id_col is None:
                    student_id_col = 0
                if student_name_col is None:
                    student_name_col = 1
            
            logger.info(f"学号列: {student_id_col}, 姓名列: {student_name_col}")
            
            # 解析学生成绩数据
            data = []
            errors = []
            student_scores = {}  # {student_id: {major_q: {minor_q: score}}}
            
            for idx, row in df.iterrows():
                try:
                    # 获取学号和姓名
                    student_id_raw = row.iloc[student_id_col] if student_id_col < len(row) else None
                    student_name_raw = row.iloc[student_name_col] if student_name_col < len(row) else None
                    
                    if pd.isna(student_id_raw) or pd.isna(student_name_raw):
                        continue
                    
                    student_id = str(int(student_id_raw)) if isinstance(student_id_raw, (int, float)) else str(student_id_raw).strip()
                    student_name = str(student_name_raw).strip()
                    
                    if not student_id or not student_name or student_id == 'nan' or student_name == 'nan':
                        continue
                    
                    # 初始化学生成绩字典，并根据题目结构初始化所有大题和子题
                    if student_id not in student_scores:
                        student_scores[student_id] = {
                            'student_id': student_id,
                            'student_name': student_name,
                            'scores': {}
                        }
                        # 根据题目结构初始化所有大题和子题
                        for major_q, minor_questions in question_structure.items():
                            student_scores[student_id]['scores'][major_q] = {}
                            for minor_q in minor_questions.keys():
                                student_scores[student_id]['scores'][major_q][minor_q] = None
                    
                    # 遍历所有列，查找题目成绩
                    # 处理合并单元格：如果第1行为空，使用前一个非空单元格的值
                    last_major_q = None
                    for col_idx in range(len(row)):
                        # 跳过学号和姓名列
                        if col_idx == student_id_col or col_idx == student_name_col:
                            continue
                        
                        if col_idx >= len(df_structure.columns):
                            continue
                        
                        major_q_raw = df_structure.iloc[0, col_idx]
                        major_q = str(major_q_raw).strip() if pd.notna(major_q_raw) else ''
                        minor_q_raw = df_structure.iloc[1, col_idx]
                        minor_q = str(minor_q_raw).strip() if pd.notna(minor_q_raw) else ''
                        score_val = row.iloc[col_idx]
                        
                        # 处理合并单元格：如果第1行为空，使用前一个非空值
                        if not major_q or major_q == 'nan' or major_q == '':
                            major_q = last_major_q
                        else:
                            last_major_q = major_q
                        
                        # 跳过学号和姓名列
                        if major_q in ['学号', '姓名']:
                            continue
                        
                        if major_q and major_q != 'nan' and major_q in question_structure:
                            try:
                                if pd.notna(score_val):
                                    score_val = float(score_val)
                                    if major_q not in student_scores[student_id]['scores']:
                                        student_scores[student_id]['scores'][major_q] = {}
                                    if minor_q and minor_q != 'nan':
                                        # 标准化小题题号：将"2.0"、"3.0"等转换为"2"、"3"
                                        # 但保留"total"等非数字键
                                        if minor_q.replace('.', '').replace('-', '').isdigit():
                                            # 如果是数字，转换为整数字符串（去掉小数点）
                                            try:
                                                minor_q_normalized = str(int(float(minor_q)))
                                            except (ValueError, TypeError):
                                                minor_q_normalized = minor_q
                                        else:
                                            minor_q_normalized = minor_q
                                        student_scores[student_id]['scores'][major_q][minor_q_normalized] = score_val
                                    else:
                                        # 如果没有小题，可能是总分
                                        if 'total' in student_scores[student_id]['scores'][major_q]:
                                            student_scores[student_id]['scores'][major_q]['total'] = score_val
                                        else:
                                            # 如果没有total键，创建一个
                                            if 'total' not in student_scores[student_id]['scores'][major_q]:
                                                student_scores[student_id]['scores'][major_q]['total'] = 0
                                            student_scores[student_id]['scores'][major_q]['total'] += score_val
                            except (ValueError, TypeError) as e:
                                logger.debug(f"第{idx+4}行第{col_idx+1}列解析分数失败: {str(e)}")
                                pass
                
                except Exception as e:
                    logger.warning(f"第{idx+4}行解析失败: {str(e)}")
                    errors.append(f'第{idx+4}行解析失败: {str(e)}')
            
            # 转换为标准格式
            for student_id, student_data in student_scores.items():
                # 使用学生实际成绩，但确保题目结构完整
                scores = student_data['scores'].copy()
                
                # 确保所有题目结构中的大题和子题都被包含（即使学生没有该题的成绩）
                for major_q, minor_questions in question_structure.items():
                    if major_q not in scores:
                        scores[major_q] = {}
                    # 确保所有子题都被包含
                    for minor_q in minor_questions.keys():
                        if minor_q not in scores[major_q]:
                            # 不设置None，让前端显示为'-'
                            pass
                
                record = {
                    'student_id': student_data['student_id'],
                    'student_name': student_data['student_name'],
                    'scores': scores
                }
                data.append(record)
            
            logger.info(f"解析卷面成绩Excel成功: {len(data)} 条有效数据, {len(errors)} 个错误")
            
            return {
                'success': True,
                'data': data,
                'errors': errors,
                'question_structure': question_structure,
            }
        
        except Exception as e:
            logger.error(f"解析卷面成绩Excel失败: {str(e)}", exc_info=True)
            return {
                'success': False,
                'data': [],
                'errors': [f'解析Excel失败: {str(e)}'],
                'question_structure': {},
            }
    
    def calculate_M_scores(self, student_scores: Dict) -> Dict:
        """
        根据学生成绩计算M1, M2, M3, M4
        M1/35 = 第一大题成绩 + 第三大题第一小题的成绩
        M2/20 = 第二大题第二小题的成绩 + 第二大题第三小题的成绩
        M3/35 = 第二大题成绩 + 第三大题第二小题的成绩 + 第三大题第三小题的成绩
        M4/10 = 第四大题成绩
        卷面 = M1 + M2 + M3 + M4
        """
        M1 = 0.0
        M2 = 0.0
        M3 = 0.0
        M4 = 0.0
        
        scores = student_scores.get('scores', {})
        
        # M1/35 = 第一大题成绩(M1大题所有小题之和) + 第三大题第一小题的成绩
        if 'M1' in scores:
            # M1大题的所有小题成绩之和
            m1_total = 0.0
            for key, value in scores['M1'].items():
                if key != 'total' and isinstance(value, (int, float)):
                    m1_total += value
            if 'total' in scores['M1']:
                m1_total = scores['M1']['total']
            else:
                m1_total = sum(v for k, v in scores['M1'].items() if k != 'total' and isinstance(v, (int, float)))
            M1 += m1_total
        
        # 第三大题第一小题
        if 'M3' in scores and '1' in scores['M3']:
            M1 += float(scores['M3']['1'])
        
        # M2/20 = 第二大题第二小题的成绩 + 第二大题第三小题的成绩
        if 'M2' in scores:
            if '2' in scores['M2']:
                M2 += float(scores['M2']['2'])
            if '3' in scores['M2']:
                M2 += float(scores['M2']['3'])
        
        # M3/35 = 第二大题成绩(M2大题所有小题之和) + 第三大题第二小题的成绩 + 第三大题第三小题的成绩
        if 'M2' in scores:
            # M2大题的所有小题成绩之和
            m2_total = 0.0
            if 'total' in scores['M2']:
                m2_total = scores['M2']['total']
            else:
                m2_total = sum(v for k, v in scores['M2'].items() if k != 'total' and isinstance(v, (int, float)))
            M3 += m2_total
        
        # 第三大题第二、三小题
        if 'M3' in scores:
            if '2' in scores['M3']:
                M3 += float(scores['M3']['2'])
            if '3' in scores['M3']:
                M3 += float(scores['M3']['3'])
        
        # M4/10 = 第四大题成绩
        if 'M4' in scores:
            if 'total' in scores['M4']:
                M4 = float(scores['M4']['total'])
            else:
                M4 = sum(v for k, v in scores['M4'].items() if k != 'total' and isinstance(v, (int, float)))
        
        # 卷面 = M1 + M2 + M3 + M4
        final_paper_score = round(M1 + M2 + M3 + M4, 2)
        
        return {
            'M1': round(M1, 2),
            'M2': round(M2, 2),
            'M3': round(M3, 2),
            'M4': round(M4, 2),
            'final_paper_score': final_paper_score
        }
    
    def import_final_paper_scores(self, data: List[Dict], course_class_id: int, user_id: int) -> Dict:
        """
        导入卷面成绩数据到AlgorithmScore模型
        """
        from apps.scores.models import AlgorithmScore, Gradebook
        from apps.users.models import User
        from apps.courses.models import CourseClass
        from django.db.models import Q
        
        try:
            course_class = CourseClass.objects.get(id=course_class_id)
        except CourseClass.DoesNotExist:
            return {
                'success': 0,
                'failed': 0,
                'errors': [f'课程班级 {course_class_id} 不存在']
            }
        
        success_count = 0
        failed_count = 0
        errors = []
        
        for record in data:
            try:
                student_id = record.get('student_id')
                if not student_id:
                    failed_count += 1
                    errors.append(f'学号为空')
                    continue
                
                # 查找学生
                try:
                    student = User.objects.get(
                        Q(employee_id=student_id) | Q(username=student_id),
                        user_type='student'
                    )
                except User.DoesNotExist:
                    failed_count += 1
                    errors.append(f'学号 {student_id} 对应的学生不存在')
                    continue
                except User.MultipleObjectsReturned:
                    student = User.objects.filter(
                        Q(employee_id=student_id) | Q(username=student_id),
                        user_type='student'
                    ).first()
                
                # 查找或创建记分册记录
                gradebook, created = Gradebook.objects.get_or_create(
                    student=student,
                    course_class=course_class,
                    defaults={'created_by_id': user_id, 'updated_by_id': user_id}
                )
                
                # 获取原始卷面成绩数据（各个小题的得分）
                raw_scores = record.get('scores', {})
                
                # 查找或创建AlgorithmScore记录
                algorithm_score, created = AlgorithmScore.objects.get_or_create(
                    student=student,
                    course_class=course_class,
                    defaults={
                        'gradebook': gradebook,
                        'created_by_id': user_id,
                        'updated_by_id': user_id
                    }
                )
                
                # 如果已存在，更新gradebook引用
                if not created:
                    algorithm_score.gradebook = gradebook
                    algorithm_score.updated_by_id = user_id
                
                # 保存原始卷面成绩数据（不计算M1-M4，等步骤3再计算）
                algorithm_score.raw_paper_scores = raw_scores
                
                # 不在这里计算M1-M4和课程目标，等步骤3重新计算时再计算
                # 只保存原始数据
                algorithm_score.save()
                
                # 验证保存是否成功
                algorithm_score.refresh_from_db()
                saved_scores = algorithm_score.raw_paper_scores
                logger.info(f"导入卷面成绩成功: student_id={student_id}, course_class_id={course_class_id}, algorithm_score_id={algorithm_score.id}")
                logger.info(f"保存的raw_paper_scores: {saved_scores}, 类型: {type(saved_scores)}")
                if not saved_scores or (isinstance(saved_scores, dict) and len(saved_scores) == 0):
                    logger.warning(f"警告: student_id={student_id} 的raw_paper_scores保存后为空!")
                success_count += 1
                
            except Exception as e:
                failed_count += 1
                error_msg = f"学号 {record.get('student_id', '未知')} 导入失败: {str(e)}"
                errors.append(error_msg)
                logger.error(error_msg, exc_info=True)
        
        return {
            'success': success_count,
            'failed': failed_count,
            'errors': errors
        }
