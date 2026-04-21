# 用户管理API路由
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import UserViewSet, TeacherProfileViewSet, StudentProfileViewSet, TeacherViewSet

router = DefaultRouter()
router.register(r'users', UserViewSet, basename='user')
router.register(r'teacher-profiles', TeacherProfileViewSet, basename='teacher-profile')
router.register(r'teachers', TeacherViewSet, basename='teacher')
router.register(r'students', StudentProfileViewSet, basename='student')

urlpatterns = [
    path('', include(router.urls)),
]