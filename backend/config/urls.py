"""
URL configuration for config project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""

from django.contrib import admin
from django.urls import path, include, re_path
from django.conf import settings
from django.conf.urls.static import static
from rest_framework import permissions
from drf_yasg.views import get_schema_view
from drf_yasg import openapi
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
    TokenVerifyView,
)

# API 文档配置
schema_view = get_schema_view(
    openapi.Info(
        title="成绩管理系统 API",
        default_version='v1',
        description="大学生成绩管理与分析系统",
        terms_of_service="https://www.example.com/terms/",
        contact=openapi.Contact(email="contact@example.com"),
        license=openapi.License(name="MIT License"),
    ),
    public=True,
    permission_classes=(permissions.AllowAny,),
)

urlpatterns = [
    # 管理员后台
    path('admin/', admin.site.urls),

    # API 文档
    path('swagger/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
    path('redoc/', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),
    path('swagger.json', schema_view.without_ui(cache_timeout=0), name='schema-json'),

    # JWT 认证
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('api/token/verify/', TokenVerifyView.as_view(), name='token_verify'),

    # API 路由
    path('api/auth/', include('apps.users.urls')),  # 用户认证
    path('api/users/', include('apps.users.api_urls')),  # 用户管理
    path('api/courses/', include('apps.courses.urls')),  # 课程管理
    path('api/scores/', include('apps.scores.urls')),  # 成绩管理
    path('api/analysis/', include('apps.analysis.urls')),  # 数据分析
    path('api/reports/', include('apps.reports.urls')),  # 报告生成

    # 公共 API
    path('api/common/', include('apps.common.urls')),
]

# 开发环境下的静态文件和媒体文件服务
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)

# 默认路由（可选）
urlpatterns += [
    path('', schema_view.with_ui('swagger', cache_timeout=0), name='home'),
]