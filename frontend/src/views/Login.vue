<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-header">
        <h2>学生成绩数据化分析管理系统</h2>
      </div>
      <el-form
        ref="loginFormRef"
        :model="loginForm"
        :rules="loginRules"
        class="login-form"
      >
        <el-form-item prop="username">
          <el-input
            v-model="loginForm.username"
            placeholder="请输入用户名"
            size="large"
            prefix-icon="User"
          />
        </el-form-item>
        <el-form-item prop="password">
          <el-input
            v-model="loginForm.password"
            type="password"
            placeholder="请输入密码"
            size="large"
            prefix-icon="Lock"
            @keyup.enter="handleLogin"
          />
        </el-form-item>
        <el-form-item>
          <div class="button-group">
            <el-button
              type="primary"
              :loading="loading"
              @click="handleLogin"
            >
              登录
            </el-button>
            <el-button
              @click="showRegisterDialog = true"
            >
              注册
            </el-button>
          </div>
        </el-form-item>
      </el-form>
      
      <!-- 注册对话框 -->
      <el-dialog
        v-model="showRegisterDialog"
        title="用户注册"
        width="450px"
        :close-on-click-modal="false"
      >
        <el-form
          ref="registerFormRef"
          :model="registerForm"
          :rules="registerRules"
          label-width="110px"
        >
          <el-form-item label="用户名：" prop="username">
            <el-input
              v-model="registerForm.username"
              placeholder="请输入用户名"
              size="large"
            />
          </el-form-item>
          <el-form-item label="密码：" prop="password">
            <el-input
              v-model="registerForm.password"
              type="password"
              placeholder="请输入密码（至少6位）"
              size="large"
            />
          </el-form-item>
          <el-form-item label="确认密码：" prop="confirmPassword">
            <el-input
              v-model="registerForm.confirmPassword"
              type="password"
              placeholder="请再次输入密码"
              size="large"
            />
          </el-form-item>
          <el-form-item label="邮箱：" prop="email">
            <el-input
              v-model="registerForm.email"
              placeholder="请输入邮箱（可选）"
              size="large"
            />
          </el-form-item>
          <el-form-item label="姓名：" prop="first_name">
            <el-input
              v-model="registerForm.first_name"
              placeholder="请输入姓名（可选）"
              size="large"
            />
          </el-form-item>
        </el-form>
        <template #footer>
          <el-button @click="showRegisterDialog = false">取消</el-button>
          <el-button type="primary" :loading="registering" @click="handleRegister">注册</el-button>
        </template>
      </el-dialog>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { register } from '@/api/auth'
import { ElMessage } from 'element-plus'

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()

const loginFormRef = ref(null)
const registerFormRef = ref(null)
const loading = ref(false)
const registering = ref(false)
const showRegisterDialog = ref(false)

const loginForm = reactive({
  username: '',
  password: ''
})

const registerForm = reactive({
  username: '',
  password: '',
  confirmPassword: '',
  email: '',
  first_name: ''
})

const validateConfirmPassword = (rule, value, callback) => {
  if (value !== registerForm.password) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}

const loginRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度不能少于6位', trigger: 'blur' }
  ]
}

const registerRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, message: '用户名长度不能少于3位', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度不能少于6位', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    { validator: validateConfirmPassword, trigger: 'blur' }
  ],
  email: [
    { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
  ]
}

const handleLogin = async () => {
  if (!loginFormRef.value) return
  
  await loginFormRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true
      try {
        await authStore.login(loginForm.username, loginForm.password)
        const redirect = route.query.redirect || '/dashboard'
        router.push(redirect)
      } catch (error) {
        console.error('登录失败:', error)
      } finally {
        loading.value = false
      }
    }
  })
}

const handleRegister = async () => {
  if (!registerFormRef.value) return
  
  await registerFormRef.value.validate(async (valid) => {
    if (valid) {
      registering.value = true
      try {
        const response = await register(
          registerForm.username,
          registerForm.password,
          registerForm.email,
          registerForm.first_name
        )
        ElMessage.success('注册成功，正在登录...')
        showRegisterDialog.value = false
        // 自动登录
        await authStore.login(registerForm.username, registerForm.password)
        const redirect = route.query.redirect || '/dashboard'
        router.push(redirect)
      } catch (error) {
        ElMessage.error(error.response?.data?.username?.[0] || error.response?.data?.message || '注册失败')
      } finally {
        registering.value = false
      }
    }
  })
}
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  position: relative;
  overflow: hidden;
  background-image: url('@/assets/images/background.png');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
}

.login-box {
  width: 400px;
  height: 300px;
  padding: 25px 25px 5px 25px;
  background: #e7f6ff;
  border-radius: 6px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.login-header {
  text-align: center;
  margin-bottom: 30px;
}

.login-header h2 {
  margin: 0px auto 30px auto;
  text-align: center;
  font-size: 24px;
  font-weight: bold;
  font-family: "Microsoft YaHei", sans-serif;

  background: linear-gradient(to right, #00e5ff, #4a9eff);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}

.login-form {
  margin-top: 0;
}

.login-form :deep(.el-form-item__label) {
  color: #606266;
  font-size: 16px;
  font-weight: 500;
  line-height: 40px;
  padding-right: 12px;
}

.login-form :deep(.el-input) {
  height: 40px;
}

.login-form :deep(.el-input__wrapper) {
  background: rgba(181, 218, 239, 0.5) !important;
  border: 1px solid rgba(0, 183, 255, 0.5) !important;
  border-radius: 4px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.login-form :deep(.el-input__inner) {
  color: #090909 !important;
  font-size: 16px;
  height: 40px;
  line-height: 40px;
}

.login-form :deep(.el-input__inner::placeholder) {
  color: #909399;
}

.login-form :deep(.el-input__wrapper.is-focus) {
  border-color: rgba(0, 183, 255, 0.6) !important;
}

.login-form :deep(.el-icon) {
  color: #4fc3f7;
}

.button-group {
  display: flex;
  gap: 12px;
  width: 100%;
}

.button-group .el-button {
  flex: 1;
  font-size: 16px;
  height: 40px;
}
</style>

