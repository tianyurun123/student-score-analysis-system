# 视图函数
from rest_framework import viewsets, status, permissions
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import authenticate
from django.db.models import Q
from .models import User, TeacherProfile, StudentProfile
from .serializers import (
    UserLoginSerializer, UserRegisterSerializer, UserSerializer,
    TeacherProfileSerializer, StudentProfileSerializer,
    TeacherListSerializer, TeacherCreateSerializer, TeacherUpdateSerializer
)
from .permissions import IsAdminUser, IsTeacherOrAdmin


class AuthViewSet(viewsets.GenericViewSet):
    """认证视图集"""
    permission_classes = [permissions.AllowAny]

    @action(detail=False, methods=['post'])
    def login(self, request):
        """用户登录"""
        serializer = UserLoginSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        user = serializer.validated_data['user']

        # 更新登录信息
        user.login_count += 1
        user.last_login_ip = self.get_client_ip(request)
        user.save()

        # 生成 JWT token
        refresh = RefreshToken.for_user(user)

        return Response({
            'user': UserSerializer(user).data,
            'access': str(refresh.access_token),
            'refresh': str(refresh)
        })

    @action(detail=False, methods=['post'], permission_classes=[permissions.AllowAny])
    def logout(self, request):
        """用户登出"""
        # JWT 无需服务器端处理，客户端丢弃 token 即可
        # 允许未认证用户调用，因为token可能已失效
        return Response({'message': '登出成功'})
    
    @action(detail=False, methods=['post'])
    def register(self, request):
        """用户注册"""
        serializer = UserRegisterSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        
        # 生成 JWT token
        refresh = RefreshToken.for_user(user)
        
        return Response({
            'user': UserSerializer(user).data,
            'access': str(refresh.access_token),
            'refresh': str(refresh),
            'message': '注册成功'
        }, status=status.HTTP_201_CREATED)

    def get_client_ip(self, request):
        """获取客户端 IP"""
        x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
        if x_forwarded_for:
            ip = x_forwarded_for.split(',')[0]
        else:
            ip = request.META.get('REMOTE_ADDR')
        return ip


class UserViewSet(viewsets.ModelViewSet):
    """用户管理视图集"""
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAdminUser]

    def get_permissions(self):
        """根据动作调整权限"""
        if self.action in ['retrieve', 'update', 'partial_update']:
            return [permissions.IsAuthenticated()]
        elif self.action in ['create', 'destroy', 'list']:
            return [IsAdminUser()]
        return super().get_permissions()

    @action(detail=False, methods=['get'])
    def me(self, request):
        """获取当前用户信息"""
        serializer = self.get_serializer(request.user)
        return Response(serializer.data)

    @action(detail=False, methods=['put'])
    def update_profile(self, request):
        """更新当前用户信息"""
        user = request.user
        serializer = self.get_serializer(user, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data)


class TeacherProfileViewSet(viewsets.ModelViewSet):
    """教师信息管理"""
    queryset = TeacherProfile.objects.all()
    serializer_class = TeacherProfileSerializer
    permission_classes = [IsTeacherOrAdmin]


class StudentProfileViewSet(viewsets.ModelViewSet):
    """学生信息管理"""
    queryset = StudentProfile.objects.all()
    serializer_class = StudentProfileSerializer
    permission_classes = [IsAdminUser]

    def get_queryset(self):
        """根据用户权限过滤查询集"""
        queryset = super().get_queryset()
        user = self.request.user

        if user.user_type == 'teacher':
            # 教师只能查看自己授课班级的学生
            # 这里需要根据课程关系过滤
            pass
        elif user.user_type == 'counselor':
            # 辅导员只能查看自己管理班级的学生
            queryset = queryset.filter(class_name=user.managed_class)

        return queryset


class TeacherViewSet(viewsets.ModelViewSet):
    """教师管理视图集"""
    queryset = User.objects.filter(user_type='teacher')
    
    def get_permissions(self):
        """根据动作调整权限"""
        # 查看列表和详情：教师和管理员都可以
        if self.action in ['list', 'retrieve']:
            return [permissions.IsAuthenticated()]
        # 创建、修改、删除：只有管理员可以
        elif self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [IsAdminUser()]
        return super().get_permissions()

    def get_serializer_class(self):
        """根据动作选择序列化器"""
        if self.action == 'create':
            return TeacherCreateSerializer
        elif self.action in ['update', 'partial_update']:
            return TeacherUpdateSerializer
        return TeacherListSerializer

    def get_queryset(self):
        """根据查询参数过滤"""
        queryset = super().get_queryset()
        
        # 搜索过滤
        search = self.request.query_params.get('search')
        if search:
            queryset = queryset.filter(
                Q(username__icontains=search) |
                Q(first_name__icontains=search) |
                Q(employee_id__icontains=search) |
                Q(department__icontains=search)
            )
        
        # 院系过滤
        department = self.request.query_params.get('department')
        if department:
            queryset = queryset.filter(department=department)
        
        return queryset.select_related('teacher_profile').prefetch_related(
            'courses_taught', 'main_classes'
        )