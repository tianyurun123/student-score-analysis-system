from django.urls import path, include
from rest_framework.routers import DefaultRouter
from apps.courses.views import (
    CourseViewSet, CourseClassViewSet, EnrollmentViewSet, GradingPolicyViewSet
)

router = DefaultRouter()
router.register(r'courses', CourseViewSet, basename='course')
router.register(r'classes', CourseClassViewSet, basename='course-class')
router.register(r'enrollments', EnrollmentViewSet, basename='enrollment')
router.register(r'grading-policies', GradingPolicyViewSet, basename='grading-policy')

urlpatterns = [
    path('', include(router.urls)),
]

