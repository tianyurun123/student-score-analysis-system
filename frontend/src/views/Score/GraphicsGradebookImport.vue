<template>
  <div class="gradebook-import">
    <div class="page-header">
      <h1 class="page-title">图形学记分册导入</h1>
      <p class="page-description">导入包含作业、实验、考勤等原始成绩的记分册，系统将自动计算平时成绩、期末成绩和总评</p>
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
          <el-alert
            title="Excel文件要求"
            type="info"
            :closable="false"
            style="margin-bottom: 20px"
          >
            <ul style="margin: 10px 0; padding-left: 20px">
              <li>支持 .xlsx 和 .xls 格式</li>
              <li>必须包含学号和姓名列</li>
              <li>可选列：作业1~5、实验1~2、考勤1~5、复习笔记、系统、报告</li>
              <li>如果只有系统成绩没有报告，则期末=(系统+报告)/2计算</li>
            </ul>
          </el-alert>

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

            <el-alert
              title="计算公式说明"
              type="success"
              :closable="false"
              style="margin-bottom: 20px"
            >
              <ul style="margin: 10px 0; padding-left: 20px">
                <li>平时成绩 = (作业平均分×0.1 + 实验平均分×0.2 + 考勤平均分×0.05 + 复习笔记×0.05) / 0.4</li>
                <li>期末成绩 = (系统 + 报告) / 2</li>
                <li>总评 = 平时×0.4 + 期末×0.6</li>
                <li>结论：≥90优秀，≥80良好，≥70中等，≥60及格，&lt;60不及格</li>
              </ul>
            </el-alert>

            <div style="margin: 15px 0; display: flex; justify-content: space-between; align-items: center">
              <span style="color: #909399">共 {{ previewData.data?.length || 0 }} 条数据</span>
              <el-button type="success" @click="handleExportGradebook" :loading="exporting">
                <el-icon><Download /></el-icon>
                导出记分册
              </el-button>
            </div>

            <el-table :data="previewData.data" border max-height="500">
              <el-table-column prop="student_id" label="学号" width="100" fixed />
              <el-table-column prop="student_name" label="姓名" width="80" fixed />
              <el-table-column prop="homework1" label="作业1" width="70" />
              <el-table-column prop="homework2" label="作业2" width="70" />
              <el-table-column prop="homework3" label="作业3" width="70" />
              <el-table-column prop="homework4" label="作业4" width="70" />
              <el-table-column prop="homework5" label="作业5" width="70" />
              <el-table-column prop="experiment1" label="实验1" width="70" />
              <el-table-column prop="experiment2" label="实验2" width="70" />
              <el-table-column prop="attendance1" label="考勤1" width="70" />
              <el-table-column prop="attendance2" label="考勤2" width="70" />
              <el-table-column prop="attendance3" label="考勤3" width="70" />
              <el-table-column prop="attendance4" label="考勤4" width="70" />
              <el-table-column prop="attendance5" label="考勤5" width="70" />
              <el-table-column prop="review_note" label="复习笔记" width="80" />
              <el-table-column prop="system_score" label="系统" width="70" />
              <el-table-column prop="report_score" label="报告" width="70" />
              <el-table-column label="平时" width="70" fixed="right">
                <template #default="{ row }">
                  {{ row.usual_score !== undefined && row.usual_score !== null ? row.usual_score : '-' }}
                </template>
              </el-table-column>
              <el-table-column label="期末" width="70" fixed="right">
                <template #default="{ row }">
                  {{ row.final_score !== undefined && row.final_score !== null ? row.final_score : '-' }}
                </template>
              </el-table-column>
              <el-table-column label="总评" width="70" fixed="right">
                <template #default="{ row }">
                  {{ row.total_score !== undefined && row.total_score !== null ? row.total_score : '-' }}
                </template>
              </el-table-column>
              <el-table-column prop="conclusion" label="结论" width="80" fixed="right">
                <template #default="{ row }">
                  <el-tag v-if="row.conclusion" :type="getConclusionType(row.conclusion)" size="small">
                    {{ row.conclusion }}
                  </el-tag>
                  <span v-else>-</span>
                </template>
              </el-table-column>
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
              <el-button type="success" @click="handleExportGradebook" :loading="exporting">
                <el-icon><Download /></el-icon>
                导出记分册
              </el-button>
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
import { getClasses, getGraphicsGradebooks } from '@/api/courses'
import { previewGraphicsGradebook, importGraphicsGradebook, exportGradebookExcel } from '@/api/scores'

const currentStep = ref(0)
const classes = ref([])
const uploadRef = ref(null)
const selectedFile = ref(null)
const previewData = ref(null)
const importing = ref(false)
const exporting = ref(false)
const importResult = ref({})

const importForm = reactive({
  course_class_id: null
})

const canPreview = computed(() => {
  return importForm.course_class_id && selectedFile.value
})

const getConclusionType = (conclusion) => {
  switch (conclusion) {
    case '优秀': return 'success'
    case '良好': return 'primary'
    case '中等': return 'warning'
    case '及格': return 'info'
    case '不及格': return 'danger'
    default: return 'info'
  }
}

onMounted(async () => {
  try {
    const response = await getGraphicsGradebooks()
    classes.value = response.results || response
  } catch (error) {
    ElMessage.error('加载班级列表失败')
  }
})

const handleClassChange = () => {
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
    const formData = new FormData()
    formData.append('file', selectedFile.value)
    formData.append('course_class_id', importForm.course_class_id)

    const response = await previewGraphicsGradebook(formData)
    previewData.value = response

    if (response.success) {
      currentStep.value = 1
      if (response.errors && response.errors.length > 0) {
        ElMessage.warning(`解析成功，但有 ${response.errors.length} 个警告`)
      }
    } else {
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

    const response = await importGraphicsGradebook(formData)
    importResult.value = {
      success: response.success,
      message: response.message,
      data: response.data
    }
    currentStep.value = 2

    if (response.success) {
      ElMessage.success('导入完成')
    }
  } catch (error) {
    importResult.value = {
      success: false,
      message: error.response?.data?.message || error.response?.data?.error || '导入失败'
    }
    currentStep.value = 2
  } finally {
    importing.value = false
  }
}

const handleExportGradebook = async () => {
  if (!importForm.course_class_id) {
    ElMessage.warning('请选择班级')
    return
  }

  exporting.value = true
  try {
    const response = await exportGradebookExcel({ course_class_id: importForm.course_class_id })

    const blob = new Blob([response.data], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' })
    const url = window.URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = '记分册.xlsx'
    document.body.appendChild(a)
    a.click()
    window.URL.revokeObjectURL(url)
    document.body.removeChild(a)

    ElMessage.success('导出成功')
  } catch (error) {
    ElMessage.error('导出失败')
    console.error('导出失败:', error)
  } finally {
    exporting.value = false
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
.gradebook-import {
  padding: 20px;
}

.step-content {
  min-height: 400px;
}
</style>
