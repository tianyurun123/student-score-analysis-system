<template>
  <div class="score-import">
    <div class="page-header">
      <h1 class="page-title">成绩导入</h1>
      <p class="page-description">支持Excel文件导入，系统会自动识别学生和成绩列</p>
    </div>

    <el-card>
      <el-steps :active="currentStep" finish-status="success">
        <el-step title="选择文件" />
        <el-step title="预览数据" />
        <el-step title="确认导入" />
      </el-steps>

      <div class="step-content" style="margin-top: 30px">
        <!-- 步骤1: 选择文件 -->
        <div v-if="currentStep === 0">
          <el-form :model="importForm" label-width="120px">
            <el-form-item label="选择课程班级" required>
              <el-select
                v-model="importForm.course_class_id"
                placeholder="请选择课程班级"
                filterable
                style="width: 100%"
                @change="handleClassChange"
              >
                <el-option
                  v-for="cls in classes"
                  :key="cls.id"
                  :label="`${cls.course_name} - ${cls.class_name}`"
                  :value="cls.id"
                />
              </el-select>
            </el-form-item>
            <el-form-item label="上传Excel文件" required>
              <el-upload
                ref="uploadRef"
                :auto-upload="false"
                :on-change="handleFileChange"
                :limit="1"
                accept=".xlsx,.xls"
                drag
              >
                <el-icon class="el-icon--upload"><upload-filled /></el-icon>
                <div class="el-upload__text">
                  将文件拖到此处，或<em>点击上传</em>
                </div>
                <template #tip>
                  <div class="el-upload__tip">
                    支持 .xlsx 和 .xls 格式，文件大小不超过10MB
                  </div>
                </template>
              </el-upload>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="handlePreview" :disabled="!canPreview">
                预览数据
              </el-button>
            </el-form-item>
          </el-form>
        </div>

        <!-- 步骤2: 预览数据 -->
        <div v-if="currentStep === 1">
          <div v-if="previewData">
            <el-alert
              :title="`共识别到 ${previewData.total_count} 条数据`"
              type="info"
              :closable="false"
              style="margin-bottom: 20px"
            />
            
            <div v-if="previewData.suggested_fields && previewData.suggested_fields.length > 0">
              <el-alert
                :title="`检测到以下成绩字段：${previewData.suggested_fields.join('、')}`"
                type="success"
                :closable="false"
                style="margin-bottom: 20px"
              />
            </div>

            <el-table :data="previewData.data" border max-height="400">
              <el-table-column prop="student_id" label="学号" width="120" />
              <el-table-column prop="student_name" label="姓名" width="100" />
              <el-table-column prop="class_name" label="班级" width="120" />
              <el-table-column prop="attendance" label="考勤" width="80" />
              <el-table-column prop="homework" label="作业" width="80" />
              <el-table-column prop="experiment" label="实验" width="80" />
              <el-table-column prop="review_note" label="笔记" width="80" />
              <el-table-column
                v-for="field in extraFields"
                :key="field"
                :label="field"
                width="100"
              >
                <template #default="{ row }">
                  {{ row.extra_scores && row.extra_scores[field] ? row.extra_scores[field] : '-' }}
                </template>
              </el-table-column>
              <el-table-column prop="final" label="期末" width="80" />
            </el-table>

            <div v-if="previewData.errors && previewData.errors.length > 0" style="margin-top: 20px">
              <el-alert
                title="数据验证错误"
                type="warning"
                :closable="false"
              >
                <ul>
                  <li v-for="(error, index) in previewData.errors.slice(0, 10)" :key="index">
                    {{ error }}
                  </li>
                </ul>
              </el-alert>
            </div>

            <div style="margin-top: 20px; text-align: right">
              <el-button @click="currentStep = 0">上一步</el-button>
              <el-button type="primary" @click="handleImport" :loading="importing">
                确认导入
              </el-button>
            </div>
          </div>
        </div>

        <!-- 步骤3: 导入结果 -->
        <div v-if="currentStep === 2">
          <el-result
            :icon="importResult.success ? 'success' : 'error'"
            :title="importResult.success ? '导入成功' : '导入失败'"
            :sub-title="importResult.message"
          >
            <template #extra>
              <div v-if="importResult.success">
                <p>成功导入：{{ importResult.data?.success_count || 0 }} 条</p>
                <p>失败：{{ importResult.data?.failed_count || 0 }} 条</p>
              </div>
              <el-button type="primary" @click="handleReset">继续导入</el-button>
              <el-button @click="$router.push('/scores')">返回成绩列表</el-button>
            </template>
          </el-result>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getClasses } from '@/api/courses'
import { previewExcel, importExcel } from '@/api/scores'

const currentStep = ref(0)
const classes = ref([])
const uploadRef = ref(null)
const selectedFile = ref(null)
const previewData = ref(null)
const importing = ref(false)
const importResult = ref({})

const importForm = reactive({
  course_class_id: null
})

const canPreview = computed(() => {
  return importForm.course_class_id && selectedFile.value
})

const extraFields = computed(() => {
  if (!previewData.value?.data || previewData.value.data.length === 0) return []
  const firstRow = previewData.value.data[0]
  if (firstRow.extra_scores) {
    return Object.keys(firstRow.extra_scores)
  }
  return []
})

onMounted(async () => {
  try {
    const response = await getClasses()
    classes.value = response.results || response
  } catch (error) {
    ElMessage.error('加载班级列表失败')
  }
})

const handleClassChange = () => {
  // 重置文件选择
  if (uploadRef.value) {
    uploadRef.value.clearFiles()
  }
  selectedFile.value = null
  previewData.value = null
}

const handleFileChange = (file) => {
  selectedFile.value = file.raw
}

const handlePreview = async () => {
  if (!selectedFile.value) {
    ElMessage.warning('请先选择文件')
    return
  }

  try {
    const response = await previewExcel(selectedFile.value)
    previewData.value = response
    if (response.success) {
      currentStep.value = 1
      if (response.errors && response.errors.length > 0) {
        ElMessage.warning(`解析成功，但有 ${response.errors.length} 个警告`)
      }
    } else {
      // 显示详细错误信息
      const errorMsg = response.error || response.message || '文件解析失败，请检查文件格式'
      let detailMsg = errorMsg
      if (response.errors && response.errors.length > 0) {
        detailMsg += '\n' + response.errors.slice(0, 3).join('\n')
      }
      ElMessage.error(detailMsg)
      console.error('预览失败详情:', response)
    }
  } catch (error) {
    const errorMsg = error.response?.data?.error || error.response?.data?.message || error.message || '预览失败'
    ElMessage.error(errorMsg)
    console.error('预览失败:', error)
  }
}

const handleImport = async () => {
  if (!selectedFile.value || !importForm.course_class_id) {
    ElMessage.warning('请完成必要步骤')
    return
  }

  importing.value = true
  try {
    const formData = new FormData()
    formData.append('file', selectedFile.value)
    formData.append('course_class_id', importForm.course_class_id)

    const response = await importExcel(formData)
    importResult.value = {
      success: response.success,
      message: response.message,
      data: response.data
    }
    currentStep.value = 2
    ElMessage.success('导入完成')
  } catch (error) {
    importResult.value = {
      success: false,
      message: error.response?.data?.message || '导入失败'
    }
    currentStep.value = 2
  } finally {
    importing.value = false
  }
}

const handleReset = () => {
  currentStep.value = 0
  importForm.course_class_id = null
  selectedFile.value = null
  previewData.value = null
  importResult.value = {}
  if (uploadRef.value) {
    uploadRef.value.clearFiles()
  }
}
</script>

<style scoped>
.score-import {
  padding: 20px;
}

.step-content {
  min-height: 400px;
}
</style>

