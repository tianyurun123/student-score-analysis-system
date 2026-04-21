# 教学大纲解析器
import re
from typing import Dict, List, Optional
import pdfplumber
from docx import Document
import logging

logger = logging.getLogger(__name__)


class SyllabusParser:
    """教学大纲解析器"""

    def __init__(self):
        self.keywords = {
            'course_code': ['课程代码', '课程编号', 'Course Code', 'Code'],
            'course_name': ['课程名称', '课程名', 'Course Name', 'Name'],
            'credit': ['学分', 'Credit', 'Credits'],
            'hours': ['学时', '课时', 'Hours', 'Class Hours'],
            'grading_policy': ['成绩评定', '评分方式', '考核方式', 'Grading Policy'],
            'attendance': ['考勤', '出勤', 'Attendance'],
            'homework': ['作业', 'Homework'],
            'experiment': ['实验', '实验成绩', 'Experiment'],
            'review_note': ['复习笔记', '笔记', 'Review Notes'],
            'final': ['期末考试', '期末考核', 'Final Exam'],
            'weight': ['比例', '权重', 'Weight', 'Percentage'],
        }

    def parse_syllabus(self, file_path: str, file_type: str) -> Dict:
        """解析教学大纲文件"""
        try:
            if file_type == 'pdf':
                return self._parse_pdf(file_path)
            elif file_type in ['doc', 'docx']:
                return self._parse_docx(file_path)
            else:
                return {'error': '不支持的文件格式'}

        except Exception as e:
            logger.error(f"解析教学大纲失败: {str(e)}")
            return {'error': f'解析失败: {str(e)}'}

    def _parse_pdf(self, file_path: str) -> Dict:
        """解析PDF文件"""
        result = {}
        full_text = ""

        with pdfplumber.open(file_path) as pdf:
            for page in pdf.pages:
                text = page.extract_text()
                if text:
                    full_text += text + "\n"

        return self._extract_info_from_text(full_text)

    def _parse_docx(self, file_path: str) -> Dict:
        """解析DOCX文件"""
        doc = Document(file_path)
        full_text = "\n".join([para.text for para in doc.paragraphs])

        return self._extract_info_from_text(full_text)

    def _extract_info_from_text(self, text: str) -> Dict:
        """从文本中提取信息"""
        result = {}

        # 提取课程基本信息
        result['course_info'] = self._extract_course_info(text)

        # 提取成绩评定信息
        result['grading_info'] = self._extract_grading_info(text)

        # 提取课程目标等其他信息
        result['other_info'] = self._extract_other_info(text)

        return result

    def _extract_course_info(self, text: str) -> Dict:
        """提取课程信息"""
        info = {}
        
        # 调试：记录文本的前500个字符，便于排查问题
        logger.debug(f"开始提取课程信息，文本前500字符: {text[:500]}")

        # 课程代码/编码（可选，若没有则返回 None）
        patterns = [
            r'课程代码\s*[：:：]\s*([A-Z0-9]+)',
            r'课程编码\s*[：:：]\s*([A-Z0-9]+)',
            r'Course Code\s*[：:：]\s*([A-Z0-9]+)',
            r'Code\s*[：:：]\s*([A-Z0-9]+)'
        ]
        info['course_code'] = self._find_pattern(patterns, text)

        # 课程名称 - 支持表格格式，字段名和值可能在同一行或不同行
        patterns = [
            # 标准格式：课程名称：值（支持中英文在同一行）
            r'课程名称\s*[：:：]\s*([^\n\r]+?)(?=\n|$|课程|学分|学时|编码|代码|开课|类别|性质)',
            # 表格格式：课程名称 值（用多个空格或制表符分隔，可能在同一行）
            r'课程名称[\s\t]{2,}([^\n\r]+?)(?=\n|$|课程|学分|学时|编码|代码|开课|类别|性质)',
            # 表格格式：课程名称 值（用单个空格分隔）
            r'课程名称\s+([^\n\r]+?)(?=\n|$|课程|学分|学时|编码|代码|开课|类别|性质)',
            # 跨行格式：课程名称在上一行，值在下一行
            r'课程名称\s*[：:：]?\s*\n\s*([^\n\r]+?)(?=\n|$|课程|学分|学时|编码|代码|开课|类别|性质)',
            # 英文格式
            r'Course Name\s*[：:：]\s*([^\n\r]+?)(?=\n|$|Course|Credit|Hours|Code)',
            r'Name\s*[：:：]\s*([^\n\r]+?)(?=\n|$|Course|Credit|Hours|Code)'
        ]
        course_name = self._find_pattern(patterns, text)
        if course_name:
            # 清理课程名称，去除多余的空白和特殊字符
            course_name = course_name.strip()
            # 如果包含中英文，可能用空格或制表符分隔，取第一个作为中文名
            # 但保留完整的名称（可能包含英文）
            if re.search(r'[a-zA-Z]', course_name) and re.search(r'[\u4e00-\u9fa5]', course_name):
                # 包含中英文，可能需要分割
                parts = re.split(r'[\s\t]+', course_name, 1)
                if len(parts) > 1 and re.search(r'[a-zA-Z]', parts[1]):
                    # 第二部分包含英文，保留第一部分作为中文名
                    course_name = parts[0]
                else:
                    # 中英文混在一起，保留全部
                    pass
            info['course_name'] = course_name

        # 学分 - 支持表格格式
        patterns = [
            # 标准格式：学分：值
            r'学分\s*[：:：]\s*([\d\.]+)',
            # 表格格式：学分 值（用多个空格或制表符分隔，可能在同一行）
            r'学分[\s\t]{2,}([\d\.]+)',
            # 表格格式：学分 值（用单个空格分隔）
            r'学分\s+([\d\.]+)',
            # 跨行格式：学分在上一行，值在下一行
            r'学分\s*[：:：]?\s*\n\s*([\d\.]+)',
            # 总学分
            r'总学分\s*[：:：]\s*([\d\.]+)',
            r'总学分[\s\t]{2,}([\d\.]+)',
            r'总学分\s+([\d\.]+)',
            # 英文格式
            r'Credit\s*[：:：]\s*([\d\.]+)',
            r'Credits\s*[：:：]\s*([\d\.]+)'
        ]
        credit = self._find_pattern(patterns, text)
        if credit:
            try:
                info['credit'] = float(credit)
            except ValueError:
                pass

        # 学时 - 支持表格格式
        patterns = [
            # 标准格式：学时：值
            r'学时\s*[：:：]\s*(\d+)',
            # 表格格式：学时 值（用多个空格或制表符分隔，可能在同一行）
            r'学时[\s\t]{2,}(\d+)',
            # 表格格式：学时 值（用单个空格分隔）
            r'学时\s+(\d+)',
            # 跨行格式：学时在上一行，值在下一行
            r'学时\s*[：:：]?\s*\n\s*(\d+)',
            # 总学时
            r'总学时\s*[：:：]\s*(\d+)',
            r'总学时[\s\t]{2,}(\d+)',
            r'总学时\s+(\d+)',
            # 课时
            r'课时\s*[：:：]\s*(\d+)',
            r'课时[\s\t]{2,}(\d+)',
            r'课时\s+(\d+)',
            # 英文格式
            r'Hours\s*[：:：]\s*(\d+)',
            r'Class Hours\s*[：:：]\s*(\d+)'
        ]
        hours = self._find_pattern(patterns, text)
        if hours:
            try:
                info['hours'] = int(hours)
            except ValueError:
                pass

        # 开课院系
        patterns = [
            r'开课院系\s*[：:：]\s*([^\n\r]+?)(?:\n|$|课程|学分|学时|编码|代码|类别|性质)',
            r'开课院系\s+([^\n\r]+?)(?:\n|$|课程|学分|学时|编码|代码|类别|性质)',
            r'Department\s*[：:：]\s*([^\n\r]+?)(?:\n|$|Course|Credit|Hours|Code)'
        ]
        department = self._find_pattern(patterns, text)
        if department:
            info['department'] = department.strip()

        return info

    def _extract_grading_info(self, text: str) -> Dict:
        """提取成绩评定信息"""
        grading = {}

        # 查找成绩评定部分
        start_patterns = [
            r'成绩评定[：:]',
            r'评分方式[：:]',
            r'考核方式[：:]',
            r'成绩评价[：:]',
            r'评分标准[：:]',
            r'Assessment[：:]',
            r'Grading Policy[：:]'
        ]

        for pattern in start_patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                start_pos = match.end()
                # 提取下一段文字
                next_section = text[start_pos:start_pos + 500]
                grading['text'] = next_section.strip()

                # 提取具体比例
                self._extract_grading_weights(next_section, grading)
                break

        # 如果上述片段未提取到比例，则在全文中再尝试一次
        if 'usual_weight' not in grading or 'final_weight' not in grading:
            self._extract_grading_weights(text, grading)

        return grading

    def _extract_grading_weights(self, text: str, grading: Dict):
        """提取各项成绩的比例"""
        # 平时分比例
        pattern = r'平时[成绩分]?[^\d]*(\d+\.?\d*)%'
        match = re.search(pattern, text)
        if match:
            grading['usual_weight'] = float(match.group(1)) / 100

        # 期末分比例
        pattern = r'期末[考试分]?[^\d]*(\d+\.?\d*)%'
        match = re.search(pattern, text)
        if match:
            grading['final_weight'] = float(match.group(1)) / 100

        # 各项平时分比例
        components = ['考勤', '作业', '实验', '复习笔记']
        for component in components:
            pattern = f'{component}[^\d]*(\d+\.?\d*)%'
            match = re.search(pattern, text)
            if match:
                grading[f'{component}_weight'] = float(match.group(1)) / 100

    def _extract_other_info(self, text: str) -> Dict:
        """提取其他信息"""
        info = {}

        # 提取课程目标
        pattern = r'课程目标[：:]([^。]+)'
        matches = re.findall(pattern, text)
        if matches:
            info['objectives'] = matches

        # 提取先修课程
        pattern = r'先修课程[：:]([^。]+)'
        match = re.search(pattern, text)
        if match:
            info['prerequisites'] = match.group(1).strip()

        return info

    def _find_pattern(self, patterns: List[str], text: str) -> Optional[str]:
        """查找匹配模式"""
        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                # 去掉常见的包裹字符（引号、书名号等）和多余空白
                value = match.group(1).strip()
                value = value.strip('“”"\'《》[]()（）')
                return value
        return None