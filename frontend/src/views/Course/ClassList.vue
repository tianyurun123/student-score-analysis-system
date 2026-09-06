<template>
  <div class="class-list">
    <div class="page-header">
      <h1 class="page-title">班级管理</h1>
      <div class="page-actions">
        <el-button type="primary" @click="handleCreate">
          <el-icon><Plus /></el-icon>
          新建班级
        </el-button>
        <el-button type="success" @click="handleImportExcel">
          <el-icon><Upload /></el-icon>
          导入班级
        </el-button>
      </div>
    </div>

    <el-card>
      <el-table :data="classList" border v-loading="loading" style="width: 100%">
        <el-table-column prop="course_name" label="课程名称" width="200" />
        <el-table-column prop="class_name" label="班级名称" width="150" />
        <el-table-column prop="main_teacher_name" label="主讲教师" width="120" />
        <el-table-column label="学生数" width="100">
          <template #default="{ row }">
            {{ row.students_count || 0 }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="400" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button type="info" size="small" @click="handleViewStudents(row)">查看学生</el-button>
            <el-button type="success" size="small" @click="handleImportStudents(row)">导入学生</el-button>
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
        <el-form-item label="课程" prop="course_id">
          <el-select v-model="form.course_id" placeholder="请选择课程" filterable style="width: 100%">
            <el-option
              v-for="course in courses"
              :key="course.id"
              :label="`${course.course_code} - ${course.course_name}`"
              :value="course.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="班级名称" prop="class_name">
          <el-input v-model="form.class_name" />
        </el-form-item>
        <el-form-item label="主讲教师" prop="main_teacher_id">
          <el-select v-model="form.main_teacher_id" placeholder="请选择教师" filterable style="width: 100%">
            <el-option
              v-for="teacher in teachers"
              :key="teacher.id"
              :label="`${teacher.first_name || teacher.username}${teacher.employee_id ? ' (' + teacher.employee_id + ')' : ''}`"
              :value="teacher.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="最大学生数">
          <el-input-number v-model="form.max_students" :min="1" style="width: 100%" />
        </el-form-item>
        <el-form-item label="上课时间">
          <el-input v-model="form.class_time" />
        </el-form-item>
        <el-form-item label="教室">
          <el-input v-model="form.classroom" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSave" :loading="saving">保存</el-button>
      </template>
    </el-dialog>

    <!-- Excel导入对话框 -->
    <el-dialog
      v-model="importDialogVisible"
      title="导入班级"
      width="700px"
    >
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
            <br />
            Excel格式：课程代码（必填）、课程名称（可选）、班级名称（必填）、学号（必填）、姓名（可选）
            <br />
            <strong>说明：</strong>系统会自动创建不存在的课程和班级，并导入学生
          </div>
        </template>
      </el-upload>

      <div v-if="previewData && previewData.length > 0" style="margin-top: 20px">
        <el-divider>预览数据</el-divider>
        <el-table :data="previewData" border max-height="300">
          <el-table-column prop="course_code" label="课程代码" width="120" />
          <el-table-column prop="course_name" label="课程名称" width="150" />
          <el-table-column prop="class_name" label="班级名称" width="120" />
          <el-table-column prop="student_id" label="学号" width="120" />
          <el-table-column prop="student_name" label="姓名" width="100" />
        </el-table>
      </div>

      <template #footer>
        <el-button @click="importDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleConfirmImport" :loading="importing" :disabled="!previewData || previewData.length === 0">
          确认导入
        </el-button>
      </template>
    </el-dialog>

    <!-- 查看学生对话框 -->
    <el-dialog
      v-model="studentsDialogVisible"
      :title="`班级学生列表 - ${currentClassName || ''}`"
      width="1200px"
    >
      <div class="student-dialog-header">
        <el-button type="primary" @click="handleAddStudent">
          <el-icon><Plus /></el-icon>
          添加学生
        </el-button>
        <el-input
          v-model="studentSearchKeyword"
          placeholder="搜索学号或姓名"
          clearable
          style="width: 300px; margin-left: 10px"
          @input="handleSearchStudents"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
      </div>
      
      <div class="student-count-info" style="margin-bottom: 10px; text-align: right; color: #606266;">
        <span>共 <strong style="color: #409EFF;">{{ filteredStudentList.length }}</strong> 名学生</span>
      </div>
      
      <el-row :gutter="20" style="margin-top: 10px">
        <!-- 左列 -->
        <el-col :span="12">
          <el-card>
            <template #header>
              <div style="display: flex; justify-content: space-between; align-items: center;">
                <span>学生列表（左列）</span>
                <span style="color: #909399; font-size: 12px;">{{ leftColumnStudents.length }} 人</span>
              </div>
            </template>
            <el-table 
              :data="leftColumnStudents" 
              border 
              v-loading="loadingStudents" 
              style="width: 100%"
              :max-height="tableMaxHeight"
              empty-text="暂无学生"
            >
              <el-table-column type="index" label="序号" width="60" align="center" />
              <el-table-column prop="student_id" label="学号" width="150" />
              <el-table-column prop="student_name" label="姓名" width="120" />
              <el-table-column label="操作" width="200" fixed="right">
                <template #default="{ row }">
                  <el-button type="primary" size="small" @click="handleEditStudent(row)">编辑</el-button>
                  <el-button type="danger" size="small" @click="handleRemoveStudent(row)">移除</el-button>
                </template>
              </el-table-column>
            </el-table>
          </el-card>
        </el-col>
        
        <!-- 右列 -->
        <el-col :span="12">
          <el-card>
            <template #header>
              <div style="display: flex; justify-content: space-between; align-items: center;">
                <span>学生列表（右列）</span>
                <span style="color: #909399; font-size: 12px;">{{ rightColumnStudents.length }} 人</span>
              </div>
            </template>
            <el-table 
              :data="rightColumnStudents" 
              border 
              v-loading="loadingStudents" 
              style="width: 100%"
              :max-height="tableMaxHeight"
              empty-text="暂无学生"
            >
              <el-table-column type="index" label="序号" width="60" align="center" :index="getRightColumnIndex" />
              <el-table-column prop="student_id" label="学号" width="150" />
              <el-table-column prop="student_name" label="姓名" width="120" />
              <el-table-column label="操作" width="200" fixed="right">
                <template #default="{ row }">
                  <el-button type="primary" size="small" @click="handleEditStudent(row)">编辑</el-button>
                  <el-button type="danger" size="small" @click="handleRemoveStudent(row)">移除</el-button>
                </template>
              </el-table-column>
            </el-table>
          </el-card>
        </el-col>
      </el-row>
    </el-dialog>
    
    <!-- 添加/编辑学生对话框 -->
    <el-dialog
      v-model="studentEditDialogVisible"
      :title="studentEditForm.id ? '编辑学生' : '添加学生'"
      width="500px"
    >
      <el-form
        ref="studentFormRef"
        :model="studentEditForm"
        :rules="studentFormRules"
        label-width="100px"
      >
        <el-form-item label="学号" prop="student_id">
          <el-input 
            v-model="studentEditForm.student_id" 
            placeholder="请输入学号"
            :disabled="!!studentEditForm.id"
          />
        </el-form-item>
        <el-form-item label="姓名" prop="student_name">
          <el-input 
            v-model="studentEditForm.student_name" 
            placeholder="请输入姓名"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="studentEditDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSaveStudent" :loading="savingStudent">保存</el-button>
      </template>
    </el-dialog>

    <!-- 导入学生对话框 -->
    <el-dialog
      v-model="importStudentsDialogVisible"
      title="导入学生"
      width="600px"
    >
      <el-upload
        ref="importStudentsUploadRef"
        :auto-upload="false"
        :on-change="handleImportStudentsFileChange"
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
            <br />
            Excel格式：学号、姓名（学号为必填项）
          </div>
        </template>
      </el-upload>
      <template #footer>
        <el-button @click="importStudentsDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleConfirmImportStudents" :loading="importing" :disabled="!importStudentsFile">
          确认导入
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Upload, UploadFilled, Search, Edit, Delete } from '@element-plus/icons-vue'
import { getClasses, createClass, updateClass, deleteClass, addStudentsToClass, importStudentsToClass, importClass, getClassStudents } from '@/api/courses'
import { getCourses } from '@/api/courses'
import { getUsers, getTeachers } from '@/api/users'

const loading = ref(false)
const saving = ref(false)
const importing = ref(false)
const loadingStudents = ref(false)
const classList = ref([])
const courses = ref([])
const teachers = ref([])
const dialogVisible = ref(false)
const importDialogVisible = ref(false)
const studentsDialogVisible = ref(false)
const formRef = ref(null)
const uploadRef = ref(null)
const selectedFile = ref(null)
const previewData = ref([])
const studentList = ref([])
const currentClassId = ref(null)
const importStudentsDialogVisible = ref(false)
const importStudentsFile = ref(null)
const importStudentsClassId = ref(null)
const importStudentsUploadRef = ref(null)
const studentSearchKeyword = ref('')
const studentEditDialogVisible = ref(false)
const studentFormRef = ref(null)
const savingStudent = ref(false)
const currentClassName = ref('')

const studentEditForm = reactive({
  id: null,
  enrollment_id: null,
  student_id: '',
  student_name: ''
})

const studentFormRules = {
  student_id: [{ required: true, message: '请输入学号', trigger: 'blur' }],
  student_name: [{ required: true, message: '请输入姓名', trigger: 'blur' }]
}

const pagination = reactive({
  page: 1,
  pageSize: 20,
  total: 0
})

const form = reactive({
  id: null,
  course_id: null,
  class_name: '',
  main_teacher_id: null,
  max_students: 100,
  class_time: '',
  classroom: ''
})

const rules = {
  course_id: [{ required: true, message: '请选择课程', trigger: 'change' }],
  class_name: [{ required: true, message: '请输入班级名称', trigger: 'blur' }]
}

const dialogTitle = computed(() => form.id ? '编辑班级' : '新建班级')

onMounted(() => {
  loadClasses()
  loadCourses()
  loadTeachers()
})

const loadClasses = async () => {
  loading.value = true
  try {
    const response = await getClasses({
      page: pagination.page,
      page_size: pagination.pageSize
    })
    classList.value = response.results || response
    pagination.total = response.count || classList.value.length
  } catch (error) {
    ElMessage.error('加载班级列表失败')
  } finally {
    loading.value = false
  }
}

const loadCourses = async () => {
  try {
    const response = await getCourses()
    courses.value = response.results || response
  } catch (error) {
    console.error('加载课程列表失败:', error)
  }
}

const loadTeachers = async () => {
  try {
    // 使用教师管理 API
    const response = await getTeachers()
    teachers.value = response.results || response || []
  } catch (error) {
    console.error('加载教师列表失败:', error)
    // 如果失败，尝试使用旧的 API
    try {
      const response = await getUsers({ user_type: 'teacher' })
      teachers.value = response.results || response || []
    } catch (err) {
      console.error('加载教师列表失败（备用方法）:', err)
      teachers.value = []
    }
  }
}

const handleCreate = () => {
  Object.assign(form, {
    id: null,
    course_id: null,
    class_name: '',
    main_teacher_id: null,
    max_students: 100,
    class_time: '',
    classroom: ''
  })
  dialogVisible.value = true
}

const handleEdit = (row) => {
  Object.assign(form, {
    id: row.id,
    course_id: row.course || row.course_id,
    class_name: row.class_name,
    main_teacher_id: row.main_teacher || row.main_teacher_id,
    max_students: row.max_students || 100,
    class_time: row.class_time || '',
    classroom: row.classroom || ''
  })
  dialogVisible.value = true
}

const handleSave = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (valid) {
      saving.value = true
      try {
        // 转换字段名以匹配后端序列化器
        const data = {
          course: form.course_id,
          class_name: form.class_name,
          main_teacher: form.main_teacher_id,
          max_students: form.max_students,
          class_time: form.class_time,
          classroom: form.classroom
        }
        
        if (form.id) {
          await updateClass(form.id, data)
          ElMessage.success('更新成功')
        } else {
          await createClass(data)
          ElMessage.success('创建成功')
        }
        dialogVisible.value = false
        loadClasses()
      } catch (error) {
        ElMessage.error('保存失败')
      } finally {
        saving.value = false
      }
    }
  })
}

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm('确定要删除该班级吗？', '提示', {
      type: 'warning'
    })
    await deleteClass(row.id)
    ElMessage.success('删除成功')
    loadClasses()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

const handleImportExcel = () => {
  selectedFile.value = null
  previewData.value = []
  if (uploadRef.value) {
    uploadRef.value.clearFiles()
  }
  importDialogVisible.value = true
}

const handleFileChange = async (file) => {
  selectedFile.value = file.raw
  if (!selectedFile.value) return

  try {
    // 这里应该调用预览API，暂时使用前端解析
    const XLSX = await import('xlsx')
    const reader = new FileReader()
    reader.onload = (e) => {
      const data = new Uint8Array(e.target.result)
      const workbook = XLSX.read(data, { type: 'array' })
      const sheetName = workbook.SheetNames[0]
      const worksheet = workbook.Sheets[sheetName]
      const jsonData = XLSX.utils.sheet_to_json(worksheet)
      
      // 处理数据
      previewData.value = jsonData.map(row => ({
        course_code: row['课程代码'] || row['course_code'] || '',
        course_name: row['课程名称'] || row['course_name'] || '',
        class_name: row['班级名称'] || row['class_name'] || '',
        student_id: row['学号'] || row['student_id'] || '',
        student_name: row['姓名'] || row['student_name'] || row['name'] || ''
      }))
    }
    reader.readAsArrayBuffer(selectedFile.value)
  } catch (error) {
    ElMessage.error('文件解析失败')
  }
}

const handleConfirmImport = async () => {
  if (!selectedFile.value) {
    ElMessage.warning('请先上传文件')
    return
  }

  importing.value = true
  try {
    const response = await importClass(selectedFile.value)
    ElMessage.success(response.message || '导入完成')
    importDialogVisible.value = false
    selectedFile.value = null
    previewData.value = []
    if (uploadRef.value) {
      uploadRef.value.clearFiles()
    }
    loadClasses()
  } catch (error) {
    const errorMsg = error.response?.data?.error || error.response?.data?.message || '导入失败'
    ElMessage.error(errorMsg)
  } finally {
    importing.value = false
  }
}

const handleImportStudents = (row) => {
  importStudentsClassId.value = row.id
  importStudentsFile.value = null
  if (importStudentsUploadRef.value) {
    importStudentsUploadRef.value.clearFiles()
  }
  importStudentsDialogVisible.value = true
}

const handleImportStudentsFileChange = (file) => {
  importStudentsFile.value = file.raw
}

const handleConfirmImportStudents = async () => {
  if (!importStudentsFile.value || !importStudentsClassId.value) {
    ElMessage.warning('请先上传文件')
    return
  }

  importing.value = true
  try {
    const response = await importStudentsToClass(importStudentsClassId.value, importStudentsFile.value)
    ElMessage.success(response.message || `导入完成：成功添加 ${response.added_count || 0} 名学生`)
    importStudentsDialogVisible.value = false
    importStudentsFile.value = null
    const classId = importStudentsClassId.value
    importStudentsClassId.value = null
    if (importStudentsUploadRef.value) {
      importStudentsUploadRef.value.clearFiles()
    }
    // 刷新班级列表以更新学生数
    await loadClasses()
    // 如果正在查看该班级的学生列表，刷新学生列表
    if (currentClassId.value === classId && studentsDialogVisible.value) {
      handleViewStudents({ id: classId })
    }
  } catch (error) {
    const errorMsg = error.response?.data?.error || error.response?.data?.message || '导入失败'
    ElMessage.error(errorMsg)
  } finally {
    importing.value = false
  }
}

// 计算左右两列的学生列表（动态分配，确保所有学生都能显示）
const leftColumnStudents = computed(() => {
  if (!studentList.value.length) return []
  const filtered = filteredStudentList.value
  // 动态计算中点：如果总数是奇数，左列多一个；如果是偶数，平均分配
  const mid = Math.ceil(filtered.length / 2)
  return filtered.slice(0, mid)
})

const rightColumnStudents = computed(() => {
  if (!studentList.value.length) return []
  const filtered = filteredStudentList.value
  // 右列从mid开始到结束
  const mid = Math.ceil(filtered.length / 2)
  return filtered.slice(mid)
})

// 计算表格最大高度（根据学生数量动态调整，确保所有学生都能显示）
const tableMaxHeight = computed(() => {
  const studentCount = Math.max(leftColumnStudents.value.length, rightColumnStudents.value.length)
  // 每行大约48px高度，表头约48px，加上一些边距
  // 动态计算：基础高度 + 每行高度 * 行数，但不超过800px（超出则启用滚动）
  const rowHeight = 48
  const headerHeight = 48
  const padding = 20
  const calculatedHeight = headerHeight + (rowHeight * studentCount) + padding
  
  // 最小高度400px，最大高度800px（超出则使用滚动）
  if (calculatedHeight < 400) {
    return 400
  } else if (calculatedHeight > 800) {
    return 800  // 超过800px时启用滚动
  } else {
    return calculatedHeight
  }
})

// 右列的序号计算（从leftColumnStudents.length + 1开始）
const getRightColumnIndex = (index) => {
  return leftColumnStudents.value.length + index + 1
}

// 过滤后的学生列表
const filteredStudentList = computed(() => {
  if (!studentSearchKeyword.value) return studentList.value
  const keyword = studentSearchKeyword.value.toLowerCase()
  return studentList.value.filter(student => 
    student.student_id.toLowerCase().includes(keyword) ||
    student.student_name.toLowerCase().includes(keyword)
  )
})

const handleViewStudents = async (row) => {
  currentClassId.value = row.id
  currentClassName.value = `${row.course_name || ''} - ${row.class_name || ''}`
  studentSearchKeyword.value = ''
  await loadStudents()
  studentsDialogVisible.value = true
}

const loadStudents = async () => {
  if (!currentClassId.value) return
  
  loadingStudents.value = true
  try {
    // 使用 no_pagination=true 参数获取所有学生，不分页
    const response = await getClassStudents(currentClassId.value, { no_pagination: true })
    const enrollments = response.results || response.data || response || []
    
    studentList.value = enrollments.map(item => {
      // 使用student_info字段（如果存在），否则使用其他字段
      const studentInfo = item.student_info || {}
      
      return {
        id: item.id || item.enrollment_id,
        enrollment_id: item.id,
        student_id: item.student_id || studentInfo.student_id || '',
        student_name: item.student_name || item.student?.first_name || '',
        class_name: item.class_name || studentInfo.class_name || '',
        major: studentInfo.major || '',
        grade: studentInfo.grade || '',
        student: item.student
      }
    })
    
    console.log(`成功加载 ${studentList.value.length} 名学生`)
  } catch (error) {
    console.error('加载学生列表失败:', error)
    ElMessage.error('加载学生列表失败: ' + (error.response?.data?.detail || error.message))
    studentList.value = []
  } finally {
    loadingStudents.value = false
  }
}

const handleSearchStudents = () => {
  // 搜索功能由computed属性自动处理
}

const handleAddStudent = () => {
  Object.assign(studentEditForm, {
    id: null,
    enrollment_id: null,
    student_id: '',
    student_name: ''
  })
  studentEditDialogVisible.value = true
}

const handleEditStudent = (row) => {
  Object.assign(studentEditForm, {
    id: row.id,
    enrollment_id: row.enrollment_id,
    student_id: row.student_id,
    student_name: row.student_name
  })
  studentEditDialogVisible.value = true
}

const handleSaveStudent = async () => {
  if (!studentFormRef.value) return
  
  await studentFormRef.value.validate(async (valid) => {
    if (valid) {
      savingStudent.value = true
      try {
        if (studentEditForm.id) {
          // 编辑：更新学生信息
          // 注意：Enrollment模型本身不存储学生姓名，姓名在User模型中
          // 这里我们只能更新Enrollment的is_active等字段
          // 如果需要更新学生姓名，需要调用用户API更新User
          ElMessage.warning('编辑功能：学生姓名需要从用户管理界面修改')
          studentEditDialogVisible.value = false
        } else {
          // 添加：使用导入学生API，后端会根据学号自动查找或创建用户
          const { importStudentsToClass } = await import('@/api/courses')
          // 创建一个临时的Excel数据格式
          const XLSX = await import('xlsx')
          const wb = XLSX.utils.book_new()
          const ws = XLSX.utils.json_to_sheet([{
            '学号': studentEditForm.student_id,
            '姓名': studentEditForm.student_name
          }])
          XLSX.utils.book_append_sheet(wb, ws, 'Sheet1')
          const excelBuffer = XLSX.write(wb, { type: 'array', bookType: 'xlsx' })
          const blob = new Blob([excelBuffer], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' })
          const file = new File([blob], 'temp.xlsx', { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' })
          await importStudentsToClass(currentClassId.value, file)
          ElMessage.success('添加成功')
        }
        studentEditDialogVisible.value = false
        await loadStudents()
        // 刷新班级列表以更新学生数
        await loadClasses()
      } catch (error) {
        ElMessage.error(error.response?.data?.error || error.response?.data?.message || '操作失败')
      } finally {
        savingStudent.value = false
      }
    }
  })
}

const handleRemoveStudent = async (row) => {
  try {
    await ElMessageBox.confirm(`确定要移除学生 ${row.student_name} (${row.student_id}) 吗？`, '提示', {
      type: 'warning'
    })
    // 调用API移除学生（删除Enrollment记录）
    const { deleteEnrollment } = await import('@/api/courses')
    await deleteEnrollment(row.enrollment_id || row.id)
    ElMessage.success('移除成功')
    await loadStudents()
    // 刷新班级列表以更新学生数
    await loadClasses()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error(error.response?.data?.error || error.response?.data?.message || '移除失败')
    }
  }
}

const handleSizeChange = () => {
  loadClasses()
}

const handlePageChange = () => {
  loadClasses()
}
</script>

