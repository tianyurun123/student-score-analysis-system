import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { login, logout as logoutApi, getCurrentUser } from '@/api/auth'
import { ElMessage } from 'element-plus'

export const useAuthStore = defineStore('auth', () => {
  const token = ref(localStorage.getItem('token') || '')
  const user = ref(null)

  const isAuthenticated = computed(() => !!token.value)

  async function loginAction(username, password) {
    try {
      const response = await login(username, password)
      token.value = response.access
      user.value = response.user
      localStorage.setItem('token', response.access)
      localStorage.setItem('refresh', response.refresh)
      ElMessage.success('登录成功')
      return response
    } catch (error) {
      ElMessage.error(error.response?.data?.message || '登录失败')
      throw error
    }
  }

  async function logoutAction() {
    // 先清除本地状态，避免后续请求使用已失效的token
    token.value = ''
    user.value = null
    localStorage.removeItem('token')
    localStorage.removeItem('refresh')
    
    // 然后尝试调用API（即使失败也没关系，因为状态已经清除）
    try {
      await logoutApi()
    } catch (error) {
      // 静默处理错误，不输出日志（401是预期的）
    }
  }

  async function fetchUser() {
    try {
      const response = await getCurrentUser()
      user.value = response
      return response
    } catch (error) {
      console.error('获取用户信息失败:', error)
      throw error
    }
  }

  return {
    token,
    user,
    isAuthenticated,
    login: loginAction,
    logout: logoutAction,
    fetchUser
  }
})
