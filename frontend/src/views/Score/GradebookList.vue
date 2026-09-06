<template>
  <div class="gradebook-list">
    <div class="page-header">
      <h1 class="page-title">图形学记分册管理</h1>
      <div class="page-actions">
        <el-button type="primary" @click="handleImport" :disabled="!searchForm.course_class_id">
          <el-icon><Upload /></el-icon>
          导入记分册
        </el-button>
        <el-button 
          type="success" 
          @click="handleExport" 
          :disabled="!searchForm.course_class_id"
        >
          <el-icon><Download /></el-icon>
          导出记分册
        </el-button>
        <el-button type="info" @click="handleAdd" :disabled="!searchForm.course_class_id">
          <el-icon><Plus /></el-icon>
          新增记录
        </el-button>
      </div>
    </div>

    <el-card style="margin-bottom: 20px">
      <template #header>
        <div style="display: flex; justify-content: space-between; align-items: center">
          <span>图形学课程班级</span>
          <el-button type="text" @click="loadGraphicsClasses">
            <el-icon><Refresh /></el-icon>
            刷新
          </el-button>
        </div>
      </template>
      <el-table :data="classesWithScores" border v-loading="loadingClasses" style="width: 100%">
        <el-table-column prop="course_code" label="课程代码" width="120" />
        <el-table-column prop="course_name" label="课程名称" width="200" />
        <el-table-column prop="class_name" label="班级名称" width="150" />
        <el-table-column prop="main_teacher_name" label="主讲教师" width="120" />
        <el-table-column label="记分册数" width="100">
          <template #default="{ row }">
            {{ row.score_count || 0 }}
          </template>
        </el-table-column>
        <el-table-column label="学生数" width="100">
          <template #default="{ row }">
            {{ row.students_count || 0 }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="searchForm.course_class_id = row.id; handleSearch()">查看</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-card>
      <div class="table-toolbar">
        <el-form :inline="true" :model="searchForm" class="search-form">
          <el-form-item label="课程班级">
            <el-select
              v-model="searchForm.course_class_id"
              placeholder="请选择"
              clearable
              filterable
              style="width: 300px"
              @change="handleSearch"
            >
              <el-option
                v-for="cls in classes"
                :key="cls.id"
                :label="`${cls.course_name} - ${cls.class_name}`"
                :value="cls.id"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="学号">
            <el-input
              v-model="searchForm.student_id"
              placeholder="请输入学号"
              clearable
              @keyup.enter="handleSearch"
            />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="handleSearch">查询</el-button>
            <el-button @click="handleReset">重置</el-button>
          </el-form-item>
        </el-form>
      </div>

      <el-table
        :data="gradebookList"
        border
        v-loading="loading"
        style="width: 100%"
        :max-height="600"
      >
        <el-table-column type="selection" width="55" />
        <el-table-column prop="student_id" label="学号" width="120" />
        <el-table-column prop="student_name" label="姓名" width="100" />
        <el-table-column prop="homework1" label="作业1" width="80" />
        <el-table-column prop="homework2" label="作业2" width="80" />
        <el-table-column prop="homework3" label="作业3" width="80" />
        <el-table-column prop="homework4" label="作业4" width="80" />
        <el-table-column prop="homework5" label="作业5" width="80" />
        <el-table-column prop="experiment1" label="实验1" width="80" />
        <el-table-column prop="experiment2" label="实验2" width="80" />
        <el-table-column prop="attendance1" label="考勤1" width="80" />
        <el-table-column prop="attendance2" label="考勤2" width="80" />
        <el-table-column prop="attendance3" label="考勤3" width="80" />
        <el-table-column prop="attendance4" label="考勤4" width="80" />
        <el-table-column prop="attendance5" label="考勤5" width="80" />
        <el-table-column prop="review_note" label="复习笔记" width="100" />
        <el-table-column prop="system_score" label="系统" width="80" />
        <el-table-column prop="report_score" label="报告" width="80" />
        <el-table-column prop="usual_score" label="平时" width="80">
          <template #default="{ row }">
            {{ row.usual_score !== null && row.usual_score !== undefined ? Math.round(row.usual_score) : '' }}
          </template>
        </el-table-column>
        <el-table-column prop="final_score" label="期末" width="80" />
        <el-table-column prop="total_score" label="总评" width="80">
          <template #default="{ row }">
            {{ row.total_score !== null && row.total_score !== undefined ? Math.round(row.total_score) : '' }}
          </template>
        </el-table-column>
        <el-table-column prop="conclusion" label="结论" width="80" />
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button size="small" type="danger" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination-container">
        <el-pagination
          v-model:current-page="pagination.page"
          v-model:page-size="pagination.pageSize"
          :total="pagination.total"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handlePageChange"
        />
      </div>
    </el-card>

    <el-dialog v-model="editDialogVisible" title="编辑记分册" width="700px">
      <el-form ref="editFormRef" :model="editForm" label-width="100px">
        <el-form-item label="学号" required>
          <el-input v-model="editForm.student_id" disabled />
        </el-form-item>
        <el-form-item label="姓名" required>
          <el-input v-model="editForm.student_name" disabled />
        </el-form-item>
        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="作业1">
              <el-input-number v-model="editForm.homework1" :min="0" :max="100" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="作业2">
              <el-input-number v-model="editForm.homework2" :min="0" :max="100" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="作业3">
              <el-input-number v-model="editForm.homework3" :min="0" :max="100" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="作业4">
              <el-input-number v-model="editForm.homework4" :min="0" :max="100" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="作业5">
              <el-input-number v-model="editForm.homework5" :min="0" :max="100" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="复习笔记">
              <el-input-number v-model="editForm.review_note" :min="0" :max="100" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="实验1">
              <el-input-number v-model="editForm.experiment1" :min="0" :max="100" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="实验2">
              <el-input-number v-model="editForm.experiment2" :min="0" :max="100" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="6">
            <el-form-item label="考勤1">
              <el-input-number v-model="editForm.attendance1" :min="0" :max="100" />
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="考勤2">
              <el-input-number v-model="editForm.attendance2" :min="0" :max="100" />
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="考勤3">
              <el-input-number v-model="editForm.attendance3" :min="0" :max="100" />
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="考勤4">
              <el-input-number v-model="editForm.attendance4" :min="0" :max="100" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="6">
            <el-form-item label="考勤5">
              <el-input-number v-model="editForm.attendance5" :min="0" :max="100" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="系统">
              <el-input-number v-model="editForm.system_score" :min="0" :max="100" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="报告">
              <el-input-number v-model="editForm.report_score" :min="0" :max="100" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="期末成绩">
          <el-input-number v-model="editForm.final_score" :min="0" :max="100" style="width: 200px" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="editDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSave">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="importDialogVisible" title="导入记分册" width="600px">
      <el-form :model="importForm" label-width="100px">
        <el-form-item label="课程班级" required>
          <el-select v-model="importForm.course_class_id" placeholder="请选择">
            <el-option
              v-for="cls in classes"
              :key="cls.id"
              :label="`${cls.course_name} - ${cls.class_name}`"
              :value="cls.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="Excel文件" required>
          <el-upload
            ref="uploadRef"
            :auto-upload="false"
            :on-change="handleFileChange"
            :file-list="fileList"
            accept=".xlsx,.xls"
            drag
          >
            <el-icon class="el-icon--upload"><Upload /></el-icon>
            <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
            <template #tip>
              <div class="el-upload__tip">支持.xlsx和.xls格式的Excel文件</div>
            </template>
          </el-upload>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="importDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handlePreview" :disabled="!importForm.course_class_id || fileList.length === 0">预览</el-button>
        <el-button type="success" @click="handleDoImport" :disabled="!importForm.course_class_id || fileList.length === 0">导入</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="previewVisible" title="导入预览" width="900px">
      <div v-loading="previewing">
        <el-table :data="previewData" border style="width: 100%" :max-height="500">
          <el-table-column prop="student_id" label="学号" width="120" />
          <el-table-column prop="student_name" label="姓名" width="100" />
          <el-table-column prop="homework1" label="作业1" width="80" />
          <el-table-column prop="homework2" label="作业2" width="80" />
          <el-table-column prop="homework3" label="作业3" width="80" />
          <el-table-column prop="homework4" label="作业4" width="80" />
          <el-table-column prop="homework5" label="作业5" width="80" />
          <el-table-column prop="experiment1" label="实验1" width="80" />
          <el-table-column prop="experiment2" label="实验2" width="80" />
          <el-table-column prop="attendance1" label="考勤1" width="80" />
          <el-table-column prop="attendance2" label="考勤2" width="80" />
          <el-table-column prop="attendance3" label="考勤3" width="80" />
          <el-table-column prop="attendance4" label="考勤4" width="80" />
          <el-table-column prop="attendance5" label="考勤5" width="80" />
          <el-table-column prop="review_note" label="复习笔记" width="100" />
          <el-table-column prop="system_score" label="系统" width="80" />
          <el-table-column prop="report_score" label="报告" width="80" />
          <el-table-column prop="usual_score" label="平时" width="80" />
          <el-table-column prop="final_score" label="期末" width="80" />
          <el-table-column prop="total_score" label="总评" width="80" />
          <el-table-column prop="conclusion" label="结论" width="80" />
        </el-table>
        <div v-if="previewData.length > 0" style="margin-top: 10px">
          <span>共 {{ previewData.length }} 条记录</span>
        </div>
      </div>
      <template #footer>
        <el-button @click="previewVisible = false">关闭</el-button>
        <el-button type="success" @click="handleDoImport">确认导入</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Upload, Download, Plus, Refresh } from '@element-plus/icons-vue'
import {
  getGradebookList,
  createGradebook,
  updateGradebook,
  deleteGradebook,
  exportGradebook,
  importGradebookPreview,
  importGradebookConfirm,
  getClassesWithScores,
  getCourseClasses
} from '@/api/scores'

const loading = ref(false)
const loadingClasses = ref(false)
const saving = ref(false)
const importing = ref(false)
const previewing = ref(false)

const editDialogVisible = ref(false)
const importDialogVisible = ref(false)
const previewVisible = ref(false)

const editFormRef = ref(null)
const uploadRef = ref(null)

const gradebookList = ref([])
const classesWithScores = ref([])
const classes = ref([])
const fileList = ref([])
const previewData = ref([])

const searchForm = reactive({
  course_class_id: null,
  student_id: ''
})

const pagination = reactive({
  page: 1,
  pageSize: 20,
  total: 0
})

const editForm = reactive({
  id: null,
  student_id: '',
  student_name: '',
  homework1: null,
  homework2: null,
  homework3: null,
  homework4: null,
  homework5: null,
  experiment1: null,
  experiment2: null,
  attendance1: null,
  attendance2: null,
  attendance3: null,
  attendance4: null,
  attendance5: null,
  review_note: null,
  system_score: null,
  report_score: null,
  final_score: null
})

const importForm = reactive({
  course_class_id: null
})

const loadGraphicsClasses = async () => {
  loadingClasses.value = true
  try {
    const response = await getClassesWithScores()
    classesWithScores.value = response.data || []
  } catch (error) {
    ElMessage.error('加载班级列表失败')
  } finally {
    loadingClasses.value = false
  }
}

const loadClasses = async () => {
  try {
    const response = await getCourseClasses()
    classes.value = response.data || []
  } catch (error) {
    ElMessage.error('加载班级列表失败')
  }
}

const handleSearch = async () => {
  pagination.page = 1
  await fetchGradebookList()
}

const handleReset = () => {
  searchForm.course_class_id = null
  searchForm.student_id = ''
  pagination.page = 1
  fetchGradebookList()
}

const fetchGradebookList = async () => {
  loading.value = true
  try {
    const params = {
      page: pagination.page,
      page_size: pagination.pageSize,
      course_class_id: searchForm.course_class_id,
      student_id: searchForm.student_id
    }
    const response = await getGradebookList(params)
    gradebookList.value = response.data.results || []
    pagination.total = response.data.count || 0
  } catch (error) {
    ElMessage.error('获取记分册列表失败')
  } finally {
    loading.value = false
  }
}

const handleSizeChange = (size) => {
  pagination.pageSize = size
  pagination.page = 1
  fetchGradebookList()
}

const handlePageChange = (page) => {
  pagination.page = page
  fetchGradebookList()
}

const handleAdd = () => {
  Object.assign(editForm, {
    id: null,
    student_id: '',
    student_name: '',
    homework1: null,
    homework2: null,
    homework3: null,
    homework4: null,
    homework5: null,
    experiment1: null,
    experiment2: null,
    attendance1: null,
    attendance2: null,
    attendance3: null,
    attendance4: null,
    attendance5: null,
    review_note: null,
    system_score: null,
    report_score: null,
    final_score: null
  })
  editDialogVisible.value = true
}

const handleEdit = (row) => {
  Object.assign(editForm, {
    id: row.id,
    student_id: row.student_id,
    student_name: row.student_name,
    homework1: row.homework1,
    homework2: row.homework2,
    homework3: row.homework3,
    homework4: row.homework4,
    homework5: row.homework5,
    experiment1: row.experiment1,
    experiment2: row.experiment2,
    attendance1: row.attendance1,
    attendance2: row.attendance2,
    attendance3: row.attendance3,
    attendance4: row.attendance4,
    attendance5: row.attendance5,
    review_note: row.review_note,
    system_score: row.system_score,
    report_score: row.report_score,
    final_score: row.final_score
  })
  editDialogVisible.value = true
}

const handleSave = async () => {
  if (editFormRef.value) {
    await editFormRef.value.validate()
  }
  saving.value = true
  try {
    const data = {
      student_id: editForm.student_id,
      student_name: editForm.student_name,
      homework1: editForm.homework1,
      homework2: editForm.homework2,
      homework3: editForm.homework3,
      homework4: editForm.homework4,
      homework5: editForm.homework5,
      experiment1: editForm.experiment1,
      experiment2: editForm.experiment2,
      attendance1: editForm.attendance1,
      attendance2: editForm.attendance2,
      attendance3: editForm.attendance3,
      attendance4: editForm.attendance4,
      attendance5: editForm.attendance5,
      review_note: editForm.review_note,
      system_score: editForm.system_score,
      report_score: editForm.report_score,
      final_score: editForm.final_score,
      course_class_id: searchForm.course_class_id
    }
    if (editForm.id) {
      await updateGradebook(editForm.id, data)
      ElMessage.success('更新成功')
    } else {
      await createGradebook(data)
      ElMessage.success('创建成功')
    }
    editDialogVisible.value = false
    fetchGradebookList()
    loadGraphicsClasses()
  } catch (error) {
    ElMessage.error('保存失败')
  } finally {
    saving.value = false
  }
}

const handleDelete = (row) => {
  ElMessageBox.confirm('确定要删除这条记录吗？', '提示', {
    type: 'warning'
  }).then(async () => {
    try {
      await deleteGradebook(row.id)
      ElMessage.success('删除成功')
      fetchGradebookList()
      loadGraphicsClasses()
    } catch (error) {
      ElMessage.error('删除失败')
    }
  })
}

const handleImport = () => {
  importForm.course_class_id = searchForm.course_class_id
  fileList.value = []
  importDialogVisible.value = true
}

const handleFileChange = (file) => {
  fileList.value = [file]
}

const handlePreview = async () => {
  if (!fileList.value.length) return
  previewing.value = true
  try {
    const formData = new FormData()
    formData.append('file', fileList.value[0].raw)
    formData.append('course_class_id', importForm.course_class_id)
    const response = await importGradebookPreview(formData)
    previewData.value = response.data.data || []
    previewVisible.value = true
  } catch (error) {
    ElMessage.error('预览失败')
  } finally {
    previewing.value = false
  }
}

const handleDoImport = async () => {
  if (!fileList.value.length) return
  importing.value = true
  try {
    const formData = new FormData()
    formData.append('file', fileList.value[0].raw)
    formData.append('course_class_id', importForm.course_class_id)
    await importGradebookConfirm(formData)
    ElMessage.success('导入成功')
    importDialogVisible.value = false
    previewVisible.value = false
    fileList.value = []
    fetchGradebookList()
    loadGraphicsClasses()
  } catch (error) {
    ElMessage.error('导入失败')
  } finally {
    importing.value = false
  }
}

const handleExport = async () => {
  try {
    const response = await exportGradebook(searchForm.course_class_id)
    const blob = new Blob([response.data], { type: 'application/vnd.ms-excel' })
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = '图形学记分册.xlsx'
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    window.URL.revokeObjectURL(url)
    ElMessage.success('导出成功')
  } catch (error) {
    ElMessage.error('导出失败')
  }
}

onMounted(() => {
  loadGraphicsClasses()
  loadClasses()
})
</script>

<style scoped>
.gradebook-list {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-title {
  font-size: 20px;
  font-weight: bold;
  color: #303133;
  margin: 0;
}

.page-actions {
  display: flex;
  gap: 10px;
}

.table-toolbar {
  margin-bottom: 15px;
}

.search-form {
  display: flex;
  align-items: center;
  gap: 10px;
}

.pagination-container {
  display: flex;
  justify-content: flex-end;
  margin-top: 20px;
}

.tab-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.tab-actions {
  display: flex;
  gap: 10px;
}
</style>