import { createApp } from 'vue'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import zhCn from 'element-plus/dist/locale/zh-cn.mjs'
import App from './App.vue'
import router from './router'
import './assets/css/main.css'

// 抑制 ResizeObserver 的警告（这是 Element Plus 的已知问题，不影响功能）
const resizeObserverLoopErrRe = /ResizeObserver.*loop.*(completed|limit|exceeded)/i

// 在最早阶段捕获错误，避免 webpack-dev-server overlay 显示
const originalError = console.error
const originalWarn = console.warn
const originalErrorHandler = window.onerror
const originalUnhandledRejection = window.onunhandledrejection

// 重写 console.error
console.error = (...args) => {
  const message = args[0]?.toString() || ''
  if (resizeObserverLoopErrRe.test(message)) {
    return
  }
  originalError.apply(console, args)
}

// 重写 console.warn
console.warn = (...args) => {
  const message = args[0]?.toString() || ''
  if (resizeObserverLoopErrRe.test(message)) {
    return
  }
  originalWarn.apply(console, args)
}

// 捕获全局错误（在 webpack-dev-server overlay 之前）
window.onerror = (message, source, lineno, colno, error) => {
  const errorMessage = message?.toString() || error?.message || ''
  if (resizeObserverLoopErrRe.test(errorMessage)) {
    return true // 阻止默认错误处理
  }
  if (originalErrorHandler) {
    return originalErrorHandler(message, source, lineno, colno, error)
  }
  return false
}

// 捕获未处理的 Promise rejection
window.addEventListener('unhandledrejection', (e) => {
  const reason = e.reason?.message || e.reason?.toString() || ''
  if (resizeObserverLoopErrRe.test(reason)) {
    e.stopImmediatePropagation()
    e.preventDefault()
    return false
  }
}, true) // 使用捕获阶段，更早拦截

// 捕获错误事件（备用）
window.addEventListener('error', (e) => {
  const errorMessage = e.message || e.error?.message || ''
  if (resizeObserverLoopErrRe.test(errorMessage)) {
    e.stopImmediatePropagation()
    e.preventDefault()
    return false
  }
}, true) // 使用捕获阶段

const app = createApp(App)
const pinia = createPinia()

// 注册所有图标
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}

app.use(pinia)
app.use(router)
app.use(ElementPlus, {
  locale: zhCn,
})

app.mount('#app')

