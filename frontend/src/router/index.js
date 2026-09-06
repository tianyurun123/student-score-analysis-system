import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue'),
    meta: { requiresAuth: false }
  },
  {
    path: '/',
    component: () => import('@/components/common/Layout.vue'),
    redirect: '/dashboard',
    meta: { requiresAuth: true },
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: () => import('@/views/Dashboard.vue'),
        meta: { title: '仪表盘', icon: 'Odometer' }
      },
      {
        path: 'courses',
        name: 'Courses',
        component: () => import('@/views/Course/CourseList.vue'),
        meta: { title: '课程管理', icon: 'Document' }
      },
      {
        path: 'courses/:id',
        name: 'CourseDetail',
        component: () => import('@/views/Course/CourseDetail.vue'),
        meta: { title: '课程详情', hidden: true }
      },
      {
        path: 'classes',
        name: 'Classes',
        component: () => import('@/views/Course/ClassList.vue'),
        meta: { title: '班级管理', icon: 'UserFilled' }
      },
      {
        path: 'teachers',
        name: 'Teachers',
        component: () => import('@/views/User/TeacherList.vue'),
        meta: { title: '教师管理', icon: 'Avatar' }
      },
      {
        path: 'scores',
        name: 'Scores',
        component: () => import('@/views/Score/ScoreList.vue'),
        meta: { title: '图形学成绩管理', icon: 'Trophy' }
      },
      {
        path: 'scores/import',
        name: 'ScoreImport',
        component: () => import('@/views/Score/ScoreImport.vue'),
        meta: { title: '成绩导入', hidden: true }
      },
      {
        path: 'scores/gradebook-import',
        name: 'GraphicsGradebookImport',
        component: () => import('@/views/Score/GraphicsGradebookImport.vue'),
        meta: { title: '导入记分册', hidden: true }
      },
      {
        path: 'students',
        name: 'Students',
        component: () => import('@/views/User/StudentList.vue'),
        meta: { title: '学生管理', icon: 'User' }
      },
      {
        path: 'analysis',
        name: 'Analysis',
        component: () => import('@/views/Analysis/AnalysisDashboard.vue'),
        meta: { title: '数据分析', icon: 'DataAnalysis' }
      },
      {
        path: 'analysis/objective-achievement',
        name: 'ObjectiveAchievement',
        component: () => import('@/views/Analysis/ObjectiveAchievement.vue'),
        meta: { title: '课程目标达成度', icon: 'DataAnalysis' }
      },
      {
        path: 'score-analysis/quality',
        name: 'QualityAnalysis',
        component: () => import('@/views/ScoreAnalysis/QualityAnalysis.vue'),
        meta: { title: '质量分析', icon: 'DataAnalysis' }
      },
      {
        path: 'score-analysis/achievement',
        name: 'AchievementAnalysis',
        component: () => import('@/views/ScoreAnalysis/AchievementAnalysis.vue'),
        meta: { title: '达成情况', icon: 'DataAnalysis' }
      },
      {
        path: 'courses/grading-formula',
        name: 'GradingFormula',
        component: () => import('@/views/Course/GradingFormula.vue'),
        meta: { title: '公式配置', icon: 'Edit' }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const authStore = useAuthStore()
  
  if (to.meta.requiresAuth && !authStore.isAuthenticated) {
    next({ name: 'Login', query: { redirect: to.fullPath } })
  } else if (to.name === 'Login' && authStore.isAuthenticated) {
    next({ name: 'Dashboard' })
  } else {
    next()
  }
})

export default router

