# 文件处理工具
import os
from django.core.files.uploadedfile import UploadedFile
from django.conf import settings
import uuid
from pathlib import Path

class FileHandler:
    """文件处理类"""

    @staticmethod
    def save_uploaded_file(file: UploadedFile, subfolder: str = '') -> str:
        """
        保存上传的文件
        
        Args:
            file: 上传的文件对象
            subfolder: 子文件夹路径
        
        Returns:
            保存后的文件路径（相对于MEDIA_ROOT）
        """
        # 生成唯一文件名
        file_ext = os.path.splitext(file.name)[1]
        unique_filename = f"{uuid.uuid4()}{file_ext}"
        
        # 构建保存路径
        if subfolder:
            save_dir = os.path.join(settings.MEDIA_ROOT, subfolder)
        else:
            save_dir = settings.MEDIA_ROOT
        
        # 确保目录存在
        os.makedirs(save_dir, exist_ok=True)
        
        # 保存文件
        file_path = os.path.join(save_dir, unique_filename)
        with open(file_path, 'wb+') as destination:
            for chunk in file.chunks():
                destination.write(chunk)
        
        # 返回相对路径
        if subfolder:
            return os.path.join(subfolder, unique_filename)
        else:
            return unique_filename

    @staticmethod
    def delete_file(file_path: str) -> bool:
        """
        删除文件
        
        Args:
            file_path: 文件路径（相对于MEDIA_ROOT或绝对路径）
        
        Returns:
            是否删除成功
        """
        try:
            # 如果是相对路径，转换为绝对路径
            if not os.path.isabs(file_path):
                file_path = os.path.join(settings.MEDIA_ROOT, file_path)
            
            if os.path.exists(file_path):
                os.remove(file_path)
                return True
            return False
        except Exception as e:
            print(f"删除文件失败: {str(e)}")
            return False

    @staticmethod
    def get_file_size(file_path: str) -> int:
        """
        获取文件大小（字节）
        
        Args:
            file_path: 文件路径
        
        Returns:
            文件大小（字节）
        """
        try:
            if not os.path.isabs(file_path):
                file_path = os.path.join(settings.MEDIA_ROOT, file_path)
            
            if os.path.exists(file_path):
                return os.path.getsize(file_path)
            return 0
        except Exception:
            return 0

    @staticmethod
    def validate_file(file: UploadedFile, max_size: int = None, allowed_extensions: list = None) -> tuple:
        """
        验证文件
        
        Args:
            file: 上传的文件对象
            max_size: 最大文件大小（字节）
            allowed_extensions: 允许的文件扩展名列表
        
        Returns:
            (is_valid, error_message)
        """
        # 检查文件大小
        if max_size and file.size > max_size:
            return False, f"文件大小超过限制（最大 {max_size / 1024 / 1024}MB）"
        
        # 检查文件扩展名
        if allowed_extensions:
            file_ext = os.path.splitext(file.name)[1].lower()
            if file_ext not in allowed_extensions:
                return False, f"不支持的文件格式，允许的格式: {', '.join(allowed_extensions)}"
        
        return True, ""
