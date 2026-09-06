<template>
  <el-container class="layout-container">
    <el-aside width="200px" class="sidebar">
      <div class="logo">
        <img src="@/assets/images/logo.png" alt="Logo" class="logo-img" />
        <h5>计算机图形学课程目标达成度分析系统</h5>
      </div>
      <el-menu
        :default-active="activeMenu"
        router
        class="sidebar-menu"
        background-color="#304156"
        text-color="#bfcbd9"
        active-text-color="#409EFF"
      >
        <el-menu-item index="/dashboard">
          <el-icon><Odometer /></el-icon>
          <span>仪表盘</span>
        </el-menu-item>
        <el-menu-item index="/courses">
          <el-icon><Document /></el-icon>
          <span>课程管理</span>
        </el-menu-item>
        <el-menu-item index="/classes">
          <el-icon><UserFilled /></el-icon>
          <span>班级管理</span>
        </el-menu-item>
        <el-menu-item index="/teachers">
          <el-icon><Avatar /></el-icon>
          <span>教师管理</span>
        </el-menu-item>
        <el-sub-menu index="score-management">
          <template #title>
            <el-icon><Trophy /></el-icon>
            <span>成绩管理</span>
          </template>
          <el-menu-item index="/scores">
          <el-icon><Document /></el-icon>
          <span>图形学成绩</span>
        </el-menu-item>
      </el-sub-menu>
        <el-sub-menu index="score-analysis">
          <template #title>
            <el-icon><DataAnalysis /></el-icon>
            <span>成绩分析</span>
          </template>
          <el-menu-item index="/score-analysis/quality">
            <el-icon><TrendCharts /></el-icon>
            <span>质量分析</span>
          </el-menu-item>
          <el-menu-item index="/score-analysis/achievement">
            <el-icon><PieChart /></el-icon>
            <span>达成情况</span>
          </el-menu-item>
        </el-sub-menu>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header class="header">
        <div class="header-left">
          <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>{{ currentRouteName }}</el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        <div class="header-right">
          <el-dropdown @command="handleCommand">
            <span class="user-info">
              <el-icon><User /></el-icon>
              {{ userInfo?.first_name || userInfo?.username || '用户' }}
              <el-icon class="el-icon--right"><ArrowDown /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>
      <el-main class="main-content">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { ElMessage } from 'element-plus'
import { Odometer, Document, UserFilled, Avatar, Trophy, DataAnalysis, TrendCharts, PieChart, User, ArrowDown } from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()

const activeMenu = computed(() => route.path)
const currentRouteName = computed(() => route.meta?.title || '首页')
const userInfo = computed(() => authStore.user)

const handleCommand = (command) => {
  if (command === 'logout') {
    authStore.logout()
    router.push({ name: 'Login' })
    ElMessage.success('已退出登录')
  }
}
</script>

<style scoped>
.layout-container {
  height: 100vh;
}

.sidebar {
  background-color: #304156;
  height: 100vh;
  overflow-y: auto;
}

.logo {
  min-height: 60px;
  padding: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  background-color: #2b3a4a;
  color: white;
  flex-wrap: nowrap;
}

.logo-img {
  height: 40px;
  width: auto;
  flex-shrink: 0;
}

.logo h2 {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  line-height: 1.5;
  text-align: left;
  word-break: break-word;
  white-space: normal;
  flex: 1;
}

.sidebar-menu {
  border-right: none;
}

.header {
  background-color: white;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.header-left {
  flex: 1;
}

.header-right {
  display: flex;
  align-items: center;
}

.user-info {
  display: flex;
  align-items: center;
  cursor: pointer;
  padding: 0 10px;
}

.main-content {
  background-color: #f5f7fa;
  padding: 20px;
  overflow-y: auto;
}
</style>

