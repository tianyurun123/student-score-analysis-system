from rest_framework import permissions


class IsTeacherOrAdmin(permissions.BasePermission):
    """教师或管理员权限"""
    
    def has_permission(self, request, view):
        if not request.user or not request.user.is_authenticated:
            return False
        
        return request.user.user_type in ['teacher', 'admin']


class IsStudentOrTeacher(permissions.BasePermission):
    """学生或教师权限"""
    
    def has_permission(self, request, view):
        if not request.user or not request.user.is_authenticated:
            return False
        
        return request.user.user_type in ['student', 'teacher', 'admin']

