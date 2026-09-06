<template>
  <div class="course-list">
    <div class="page-header">
      <h1 class="page-title">课程管理</h1>
      <div class="page-actions">
        <el-button type="primary" @click="handleCreate">
          <el-icon><Plus /></el-icon>
          新建课程
        </el-button>
      </div>
    </div>

    <el-card>
      <el-table :data="courseList" border v-loading="loading" style="width: 100%">
        <el-table-column prop="course_code" label="课程代码" width="120" />
        <el-table-column prop="course_name" label="课程名称" width="200" />
        <el-table-column prop="credit" label="学分" width="80" />
        <el-table-column prop="hours" label="学时" width="80" />
        <el-table-column prop="department" label="开课院系" width="150" />
        <el-table-column prop="semester" label="学期" width="100">
          <template #default="{ row }">
            {{ getSemesterText(row.semester) }}
          </template>
        </el-table-column>
        <el-table-column prop="year" label="年份" width="80" />
        <el-table-column label="操作" width="400" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button type="success" size="small" @click="handleUploadSyllabus(row)">上传大纲</el-button>
            <el-button type="info" size="small" @click="handleViewSyllabus(row)">查看大纲</el-button>
            <el-button type="danger" size="small" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination">
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

    <!-- 创建/编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="600px"
    >
      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-width="120px"
      >
        <el-form-item label="课程代码" prop="course_code">
          <el-input v-model="form.course_code" />
        </el-form-item>
        <el-form-item label="课程名称" prop="course_name">
          <el-input v-model="form.course_name" />
        </el-form-item>
        <el-form-item label="英文名称">
          <el-input v-model="form.english_name" />
        </el-form-item>
        <el-form-item label="学分" prop="credit">
          <el-input-number v-model="form.credit" :min="0" :precision="1" style="width: 100%" />
        </el-form-item>
        <el-form-item label="学时" prop="hours">
          <el-input-number v-model="form.hours" :min="0" style="width: 100%" />
        </el-form-item>
        <el-form-item label="开课院系" prop="department">
          <el-input v-model="form.department" />
        </el-form-item>
        <el-form-item label="学期" prop="semester">
          <el-select v-model="form.semester" style="width: 100%">
            <el-option label="春季学期" value="spring" />
            <el-option label="秋季学期" value="autumn" />
            <el-option label="夏季学期" value="summer" />
            <el-option label="冬季学期" value="winter" />
          </el-select>
        </el-form-item>
        <el-form-item label="年份" prop="year">
          <el-input-number v-model="form.year" :min="2000" :max="2100" style="width: 100%" />
        </el-form-item>
        <el-form-item label="是否必修">
          <el-switch v-model="form.is_required" />
        </el-form-item>
        <el-form-item label="课程描述">
          <el-input v-model="form.description" type="textarea" :rows="3" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSave" :loading="saving">保存</el-button>
      </template>
    </el-dialog>

    <!-- 上传大纲对话框 -->
    <el-dialog
      v-model="syllabusDialogVisible"
      title="上传教学大纲"
      width="700px"
    >
      <el-upload
        ref="uploadRef"
        :auto-upload="false"
        :on-change="handleSyllabusFileChange"
        :limit="1"
        accept=".pdf,.doc,.docx"
        drag
      >
        <el-icon class="el-icon--upload"><upload-filled /></el-icon>
        <div class="el-upload__text">
          将文件拖到此处，或<em>点击上传</em>
        </div>
        <template #tip>
          <div class="el-upload__tip">
            支持 .pdf、.doc、.docx 格式，文件大小不超过10MB
          </div>
        </template>
      </el-upload>

      <div v-if="syllabusPreview" style="margin-top: 20px">
        <el-divider>解析结果</el-divider>
        <el-form label-width="150px">
          <!-- 大纲若无课程代码则不显示输入框 -->
          <el-form-item v-if="syllabusPreview.course_info?.course_code" label="课程代码">
            <el-input v-model="syllabusPreview.course_info.course_code" />
          </el-form-item>
          <el-form-item label="课程名称">
            <el-input v-model="syllabusPreview.course_info.course_name" />
          </el-form-item>
          <el-form-item label="学分">
            <el-input-number v-model="syllabusPreview.course_info.credit" :precision="1" style="width: 100%" />
          </el-form-item>
          <el-form-item label="学时">
            <el-input-number v-model="syllabusPreview.course_info.hours" style="width: 100%" />
          </el-form-item>
        </el-form>

        <el-divider>成绩评定比例</el-divider>
        <el-form label-width="150px">
          <el-form-item label="平时成绩比例">
            <el-input-number
              v-model="syllabusPreview.grading_info.usual_weight"
              :min="0"
              :max="1"
              :step="0.1"
              :precision="2"
              style="width: 100%"
            />
          </el-form-item>
          <el-form-item label="期末成绩比例">
            <el-input-number
              v-model="syllabusPreview.grading_info.final_weight"
              :min="0"
              :max="1"
              :step="0.1"
              :precision="2"
              style="width: 100%"
            />
          </el-form-item>
        </el-form>

        <el-divider>课程目标配置</el-divider>
        <el-table :data="syllabusPreview.course_objectives || []" border style="width: 100%">
          <el-table-column prop="objective_name" label="课程目标" width="150" />
          <el-table-column prop="usual_weight" label="平时权重" width="100">
            <template #default="{ row }">
              <el-input-number v-model="row.usual_weight" :min="0" :max="1" :step="0.01" :precision="2" size="small" />
            </template>
          </el-table-column>
          <el-table-column prop="experiment_weight" label="实验权重" width="100">
            <template #default="{ row }">
              <el-input-number v-model="row.experiment_weight" :min="0" :max="1" :step="0.01" :precision="2" size="small" />
            </template>
          </el-table-column>
          <el-table-column prop="final_weight" label="期末权重" width="100">
            <template #default="{ row }">
              <el-input-number v-model="row.final_weight" :min="0" :max="1" :step="0.01" :precision="2" size="small" />
            </template>
          </el-table-column>
          <el-table-column prop="max_score" label="满分" width="100">
            <template #default="{ row }">
              <el-input-number v-model="row.max_score" :min="0" :precision="1" size="small" />
            </template>
          </el-table-column>
        </el-table>
      </div>

      <template #footer>
        <el-button @click="syllabusDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSaveSyllabus" :loading="uploading">保存</el-button>
      </template>
    </el-dialog>

    <!-- 查看大纲对话框 -->
    <el-dialog
      v-model="viewSyllabusDialogVisible"
      title="教学大纲详情"
      width="700px"
    >
      <div v-if="syllabusPreview">
        <el-form label-width="150px">
          <!-- 大纲若无课程代码则不显示输入框 -->
          <el-form-item v-if="syllabusPreview.course_info?.course_code" label="课程代码">
            <el-input v-model="syllabusPreview.course_info.course_code" />
          </el-form-item>
          <el-form-item label="课程名称">
            <el-input v-model="syllabusPreview.course_info.course_name" />
          </el-form-item>
          <el-form-item label="学分">
            <el-input-number v-model="syllabusPreview.course_info.credit" :precision="1" style="width: 100%" />
          </el-form-item>
          <el-form-item label="学时">
            <el-input-number v-model="syllabusPreview.course_info.hours" style="width: 100%" />
          </el-form-item>
        </el-form>

        <el-divider>成绩评定比例</el-divider>
        <el-form label-width="150px">
          <el-form-item label="平时成绩比例">
            <el-input-number
              v-model="syllabusPreview.grading_info.usual_weight"
              :min="0"
              :max="1"
              :step="0.1"
              :precision="2"
              style="width: 100%"
            />
          </el-form-item>
          <el-form-item label="期末成绩比例">
            <el-input-number
              v-model="syllabusPreview.grading_info.final_weight"
              :min="0"
              :max="1"
              :step="0.1"
              :precision="2"
              style="width: 100%"
            />
          </el-form-item>
        </el-form>

        <el-divider>课程目标配置</el-divider>
        <el-table :data="syllabusPreview.course_objectives || []" border style="width: 100%">
          <el-table-column prop="objective_name" label="课程目标" width="150" />
          <el-table-column prop="usual_weight" label="平时权重" width="100">
            <template #default="{ row }">
              <el-input-number v-model="row.usual_weight" :min="0" :max="1" :step="0.01" :precision="2" size="small" />
            </template>
          </el-table-column>
          <el-table-column prop="experiment_weight" label="实验权重" width="100">
            <template #default="{ row }">
              <el-input-number v-model="row.experiment_weight" :min="0" :max="1" :step="0.01" :precision="2" size="small" />
            </template>
          </el-table-column>
          <el-table-column prop="final_weight" label="期末权重" width="100">
            <template #default="{ row }">
              <el-input-number v-model="row.final_weight" :min="0" :max="1" :step="0.01" :precision="2" size="small" />
            </template>
          </el-table-column>
          <el-table-column prop="max_score" label="满分" width="100">
            <template #default="{ row }">
              <el-input-number v-model="row.max_score" :min="0" :precision="1" size="small" />
            </template>
          </el-table-column>
        </el-table>
      </div>

      <template #footer>
        <el-button @click="viewSyllabusDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSaveViewSyllabus" :loading="uploading">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, UploadFilled } from '@element-plus/icons-vue'
import { getCourses, getCourse, createCourse, updateCourse, deleteCourse, uploadSyllabus } from '@/api/courses'

const loading = ref(false)
const saving = ref(false)
const uploading = ref(false)
const courseList = ref([])
const dialogVisible = ref(false)
const syllabusDialogVisible = ref(false)
const viewSyllabusDialogVisible = ref(false)
const formRef = ref(null)
const uploadRef = ref(null)
const selectedFile = ref(null)
const syllabusPreview = ref(null)
const currentCourseId = ref(null)

const pagination = reactive({
  page: 1,
  pageSize: 20,
  total: 0
})

const form = reactive({
  id: null,
  course_code: '',
  course_name: '',
  english_name: '',
  credit: 0,
  hours: 0,
  department: '',
  semester: 'spring',
  year: new Date().getFullYear(),
  is_required: true,
  description: ''
})

const rules = {
  course_code: [{ required: true, message: '请输入课程代码', trigger: 'blur' }],
  course_name: [{ required: true, message: '请输入课程名称', trigger: 'blur' }],
  credit: [{ required: true, message: '请输入学分', trigger: 'blur' }],
  hours: [{ required: true, message: '请输入学时', trigger: 'blur' }],
  department: [{ required: true, message: '请输入开课院系', trigger: 'blur' }]
}

const dialogTitle = computed(() => form.id ? '编辑课程' : '新建课程')

onMounted(() => {
  loadCourses()
})

const loadCourses = async () => {
  loading.value = true
  try {
    const response = await getCourses({
      page: pagination.page,
      page_size: pagination.pageSize
    })
    // 处理分页响应格式
    if (response && typeof response === 'object') {
      if (Array.isArray(response.results)) {
        // DRF 分页格式
        courseList.value = response.results
        pagination.total = response.count || response.results.length
      } else if (Array.isArray(response)) {
        // 直接数组格式
        courseList.value = response
        pagination.total = response.length
      } else {
        courseList.value = []
        pagination.total = 0
      }
    } else {
      courseList.value = []
      pagination.total = 0
    }
    console.log('课程列表加载成功:', { count: courseList.value.length, total: pagination.total })
  } catch (error) {
    console.error('加载课程列表失败:', error)
    ElMessage.error('加载课程列表失败: ' + (error.message || '未知错误'))
    courseList.value = []
    pagination.total = 0
  } finally {
    loading.value = false
  }
}

const getSemesterText = (semester) => {
  const map = {
    spring: '春季学期',
    autumn: '秋季学期',
    summer: '夏季学期',
    winter: '冬季学期'
  }
  return map[semester] || semester
}

const handleCreate = () => {
  Object.assign(form, {
    id: null,
    course_code: '',
    course_name: '',
    english_name: '',
    credit: 0,
    hours: 0,
    department: '',
    semester: 'spring',
    year: new Date().getFullYear(),
    is_required: true,
    description: ''
  })
  dialogVisible.value = true
}

const handleEdit = (row) => {
  Object.assign(form, {
    id: row.id,
    course_code: row.course_code,
    course_name: row.course_name,
    english_name: row.english_name,
    credit: row.credit,
    hours: row.hours,
    department: row.department,
    semester: row.semester,
    year: row.year,
    is_required: row.is_required,
    description: row.description
  })
  dialogVisible.value = true
}

const handleSave = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (valid) {
      saving.value = true
      try {
        // 准备数据，确保所有必填字段都有值
        const courseData = {
          course_code: form.course_code,
          course_name: form.course_name,
          english_name: form.english_name || '',
          credit: form.credit || 0,
          hours: form.hours || 0,
          department: form.department,
          semester: form.semester,
          year: form.year || new Date().getFullYear(),
          is_required: form.is_required !== undefined ? form.is_required : true,
          description: form.description || '',
          teachers: form.teachers || []
        }
        
        if (form.id) {
          await updateCourse(form.id, courseData)
          ElMessage.success('更新成功')
          dialogVisible.value = false
          loadCourses()
        } else {
          await createCourse(courseData)
          ElMessage.success('创建成功')
          dialogVisible.value = false
          // 新建课程后，重置到第一页以便看到新创建的课程
          pagination.page = 1
          await loadCourses()
        }
      } catch (error) {
        const errorMsg = error.response?.data?.detail || error.response?.data?.message || error.message || '保存失败'
        ElMessage.error(errorMsg)
        console.error('保存课程失败:', error.response?.data || error)
      } finally {
        saving.value = false
      }
    }
  })
}

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm('确定要删除该课程吗？', '提示', {
      type: 'warning'
    })
    await deleteCourse(row.id)
    ElMessage.success('删除成功')
    loadCourses()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

const handleUploadSyllabus = (row) => {
  currentCourseId.value = row.id
  selectedFile.value = null
  syllabusPreview.value = null
  if (uploadRef.value) {
    uploadRef.value.clearFiles()
  }
  syllabusDialogVisible.value = true
}

const handleSyllabusFileChange = async (file) => {
  selectedFile.value = file.raw
  if (!selectedFile.value) return

  try {
    uploading.value = true
    const formData = new FormData()
    formData.append('file', selectedFile.value)
    
    const response = await uploadSyllabus(currentCourseId.value, selectedFile.value)
    syllabusPreview.value = response.parsed_data || {}
    // 确保嵌套对象存在，避免模板取值时报 undefined
    if (!syllabusPreview.value.course_info) {
      syllabusPreview.value.course_info = {}
    }
    syllabusPreview.value.course_info.course_code = syllabusPreview.value.course_info.course_code || ''
    syllabusPreview.value.course_info.course_name = syllabusPreview.value.course_info.course_name || ''
    syllabusPreview.value.course_info.credit = syllabusPreview.value.course_info.credit || 0
    syllabusPreview.value.course_info.hours = syllabusPreview.value.course_info.hours || 0

    if (!syllabusPreview.value.grading_info) {
      syllabusPreview.value.grading_info = {
        usual_weight: 0,
        final_weight: 0
      }
    } else {
      syllabusPreview.value.grading_info.usual_weight = syllabusPreview.value.grading_info.usual_weight || 0
      syllabusPreview.value.grading_info.final_weight = syllabusPreview.value.grading_info.final_weight || 0
    }
    
    // 初始化课程目标配置（如果不存在）
    if (!syllabusPreview.value.course_objectives) {
      syllabusPreview.value.course_objectives = [
        { objective_name: '课程目标1', usual_weight: 0.1, experiment_weight: 0, final_weight: 0.7, max_score: 31 },
        { objective_name: '课程目标2', usual_weight: 0.06, experiment_weight: 0.25, final_weight: 0.7, max_score: 37 },
        { objective_name: '课程目标3', usual_weight: 0.04, experiment_weight: 0.25, final_weight: 0.6, max_score: 32 }
      ]
    }
    
    ElMessage.success('大纲解析成功')
  } catch (error) {
    ElMessage.error('解析大纲失败')
  } finally {
    uploading.value = false
  }
}

const handleSaveSyllabus = async () => {
  if (!currentCourseId.value) return

  try {
    uploading.value = true
    
    // 准备要保存的数据
    const formData = new FormData()
    
    // 如果有文件，添加文件
    if (selectedFile.value) {
      formData.append('file', selectedFile.value)
    }
    
    // 添加修改后的课程信息（即使没有文件也要保存修改的内容）
    if (syllabusPreview.value?.course_info) {
      formData.append('course_info', JSON.stringify(syllabusPreview.value.course_info))
    }
    
    // 添加修改后的成绩评定信息
    if (syllabusPreview.value?.grading_info) {
      formData.append('grading_info', JSON.stringify(syllabusPreview.value.grading_info))
    }
    
    // 添加课程目标配置
    if (syllabusPreview.value?.course_objectives) {
      formData.append('course_objectives', JSON.stringify(syllabusPreview.value.course_objectives))
    }
    
    // 调用API保存（即使没有文件也可以保存修改的内容）
    await uploadSyllabus(currentCourseId.value, formData)
    ElMessage.success('大纲保存成功')
    syllabusDialogVisible.value = false
    syllabusPreview.value = null
    selectedFile.value = null
    loadCourses() // 刷新列表以获取最新数据
  } catch (error) {
    console.error('保存大纲失败:', error)
    ElMessage.error('保存失败: ' + (error.response?.data?.error || error.message || '未知错误'))
  } finally {
    uploading.value = false
  }
}

const handleViewSyllabus = async (row) => {
  try {
    // 从后端获取最新的课程详情，包括大纲解析的内容
    const courseDetail = await getCourse(row.id)
    currentCourseId.value = row.id
    
    // 将后端数据转换为前端需要的格式
    // 后端返回的 course_objectives 是对象，前端期望的是数组
    const courseObjectives = courseDetail.course_objectives?.objectives || courseDetail.course_objectives || []
    
    syllabusPreview.value = {
      course_info: {
        course_code: courseDetail.course_code || '',
        course_name: courseDetail.course_name || '',
        credit: courseDetail.credit || 0,
        hours: courseDetail.hours || 0
      },
      grading_info: {
        usual_weight: courseDetail.grading_policy?.usual_weight || 0,
        final_weight: courseDetail.grading_policy?.final_weight || 0
      },
      course_objectives: courseObjectives
    }
    
    viewSyllabusDialogVisible.value = true
  } catch (error) {
    console.error('获取课程详情失败:', error)
    ElMessage.error('获取课程详情失败')
  }
}

const handleSaveViewSyllabus = async () => {
  if (!currentCourseId.value) return

  try {
    uploading.value = true
    
    // 准备要保存的数据（与handleSaveSyllabus相同的逻辑）
    const formData = new FormData()
    
    // 添加修改后的课程信息
    if (syllabusPreview.value?.course_info) {
      formData.append('course_info', JSON.stringify(syllabusPreview.value.course_info))
    }
    
    // 添加修改后的成绩评定信息
    if (syllabusPreview.value?.grading_info) {
      formData.append('grading_info', JSON.stringify(syllabusPreview.value.grading_info))
    }
    
    // 添加课程目标配置
    if (syllabusPreview.value?.course_objectives) {
      formData.append('course_objectives', JSON.stringify(syllabusPreview.value.course_objectives))
    }
    
    // 调用API保存（不传文件，只更新数据）
    await uploadSyllabus(currentCourseId.value, formData)
    ElMessage.success('大纲保存成功')
    viewSyllabusDialogVisible.value = false
    syllabusPreview.value = null
    loadCourses() // 刷新列表以获取最新数据
  } catch (error) {
    console.error('保存大纲失败:', error)
    ElMessage.error('保存失败: ' + (error.response?.data?.error || error.message || '未知错误'))
  } finally {
    uploading.value = false
  }
}

const handleSizeChange = () => {
  loadCourses()
}

const handlePageChange = () => {
  loadCourses()
}
</script>

