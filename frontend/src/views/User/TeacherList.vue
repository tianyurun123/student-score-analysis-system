<template>
  <div class="teacher-list">
    <div class="page-header">
      <h1 class="page-title">教师管理</h1>
      <div class="page-actions">
        <el-button type="primary" @click="handleCreate">
          <el-icon><Plus /></el-icon>
          新建教师
        </el-button>
      </div>
    </div>

    <el-card>
      <!-- 搜索栏 -->
      <div class="search-bar" style="margin-bottom: 20px">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索教师（姓名、工号、用户名）"
          style="width: 300px"
          clearable
          @clear="handleSearch"
          @keyup.enter="handleSearch"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
        <el-select
          v-model="searchDepartment"
          placeholder="选择院系"
          clearable
          style="width: 200px; margin-left: 10px"
          @change="handleSearch"
        >
          <el-option
            v-for="dept in departments"
            :key="dept"
            :label="dept"
            :value="dept"
          />
        </el-select>
        <el-button type="primary" style="margin-left: 10px" @click="handleSearch">
          搜索
        </el-button>
      </div>

      <el-table :data="teacherList" border v-loading="loading" style="width: 100%">
        <el-table-column prop="employee_id" label="工号" width="120" />
        <el-table-column prop="username" label="用户名" width="120" />
        <el-table-column prop="first_name" label="姓名" width="120" />
        <el-table-column prop="department" label="所属院系" width="150" />
        <el-table-column prop="phone" label="联系电话" width="120" />
        <el-table-column label="职称" width="120">
          <template #default="{ row }">
            {{ row.teacher_profile?.title || '-' }}
          </template>
        </el-table-column>
        <el-table-column label="授课课程数" width="120" align="center">
          <template #default="{ row }">
            {{ row.courses_count || 0 }}
          </template>
        </el-table-column>
        <el-table-column label="主讲班级数" width="120" align="center">
          <template #default="{ row }">
            {{ row.classes_count || 0 }}
          </template>
        </el-table-column>
        <el-table-column label="状态" width="80" align="center">
          <template #default="{ row }">
            <el-tag :type="row.is_active ? 'success' : 'danger'">
              {{ row.is_active ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="250" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button type="info" size="small" @click="handleViewDetail(row)">详情</el-button>
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
      width="700px"
    >
      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-width="120px"
      >
        <el-form-item label="用户名" prop="username">
          <el-input v-model="form.username" :disabled="!!form.id" />
        </el-form-item>
        <el-form-item label="密码" :prop="form.id ? '' : 'password'">
          <el-input v-model="form.password" type="password" show-password />
          <span v-if="form.id" style="color: #999; font-size: 12px">留空则不修改密码</span>
        </el-form-item>
        <el-form-item label="姓名" prop="first_name">
          <el-input v-model="form.first_name" />
        </el-form-item>
        <el-form-item label="工号" prop="employee_id">
          <el-input v-model="form.employee_id" />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="form.email" />
        </el-form-item>
        <el-form-item label="所属院系">
          <el-input v-model="form.department" />
        </el-form-item>
        <el-form-item label="联系电话">
          <el-input v-model="form.phone" />
        </el-form-item>
        <el-form-item label="职称">
          <el-input v-model="form.teacher_profile.title" />
        </el-form-item>
        <el-form-item label="研究方向">
          <el-input v-model="form.teacher_profile.research_field" type="textarea" :rows="2" />
        </el-form-item>
        <el-form-item label="办公室">
          <el-input v-model="form.teacher_profile.office" />
        </el-form-item>
        <el-form-item label="状态">
          <el-switch v-model="form.is_active" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSave" :loading="saving">保存</el-button>
      </template>
    </el-dialog>

    <!-- 详情对话框 -->
    <el-dialog
      v-model="detailDialogVisible"
      title="教师详情"
      width="600px"
    >
      <el-descriptions :column="2" border v-if="currentTeacher">
        <el-descriptions-item label="工号">{{ currentTeacher.employee_id || '-' }}</el-descriptions-item>
        <el-descriptions-item label="用户名">{{ currentTeacher.username }}</el-descriptions-item>
        <el-descriptions-item label="姓名">{{ currentTeacher.first_name || '-' }}</el-descriptions-item>
        <el-descriptions-item label="邮箱">{{ currentTeacher.email || '-' }}</el-descriptions-item>
        <el-descriptions-item label="所属院系">{{ currentTeacher.department || '-' }}</el-descriptions-item>
        <el-descriptions-item label="联系电话">{{ currentTeacher.phone || '-' }}</el-descriptions-item>
        <el-descriptions-item label="职称">{{ currentTeacher.teacher_profile?.title || '-' }}</el-descriptions-item>
        <el-descriptions-item label="研究方向">{{ currentTeacher.teacher_profile?.research_field || '-' }}</el-descriptions-item>
        <el-descriptions-item label="办公室">{{ currentTeacher.teacher_profile?.office || '-' }}</el-descriptions-item>
        <el-descriptions-item label="授课课程数">{{ currentTeacher.courses_count || 0 }}</el-descriptions-item>
        <el-descriptions-item label="主讲班级数">{{ currentTeacher.classes_count || 0 }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="currentTeacher.is_active ? 'success' : 'danger'">
            {{ currentTeacher.is_active ? '启用' : '禁用' }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="创建时间">
          {{ currentTeacher.date_joined ? new Date(currentTeacher.date_joined).toLocaleString() : '-' }}
        </el-descriptions-item>
        <el-descriptions-item label="最后登录">
          {{ currentTeacher.last_login ? new Date(currentTeacher.last_login).toLocaleString() : '-' }}
        </el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Search } from '@element-plus/icons-vue'
import { getTeachers, getTeacher, createTeacher, updateTeacher, deleteTeacher } from '@/api/users'

const loading = ref(false)
const saving = ref(false)
const teacherList = ref([])
const dialogVisible = ref(false)
const detailDialogVisible = ref(false)
const formRef = ref(null)
const currentTeacher = ref(null)
const searchKeyword = ref('')
const searchDepartment = ref('')
const departments = ref([])

const pagination = reactive({
  page: 1,
  pageSize: 20,
  total: 0
})

const form = reactive({
  id: null,
  username: '',
  password: '',
  first_name: '',
  employee_id: '',
  email: '',
  department: '',
  phone: '',
  is_active: true,
  teacher_profile: {
    title: '',
    research_field: '',
    office: ''
  }
})

const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
  first_name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  employee_id: [{ required: true, message: '请输入工号', trigger: 'blur' }]
}

const dialogTitle = computed(() => form.id ? '编辑教师' : '新建教师')

onMounted(() => {
  loadTeachers()
  loadDepartments()
})

const loadTeachers = async () => {
  loading.value = true
  try {
    const params = {
      page: pagination.page,
      page_size: pagination.pageSize
    }
    if (searchKeyword.value) {
      params.search = searchKeyword.value
    }
    if (searchDepartment.value) {
      params.department = searchDepartment.value
    }
    
    const response = await getTeachers(params)
    if (response && typeof response === 'object') {
      if (Array.isArray(response.results)) {
        teacherList.value = response.results
        pagination.total = response.count || response.results.length
      } else if (Array.isArray(response)) {
        teacherList.value = response
        pagination.total = response.length
      } else {
        teacherList.value = []
        pagination.total = 0
      }
    } else {
      teacherList.value = []
      pagination.total = 0
    }
  } catch (error) {
    console.error('加载教师列表失败:', error)
    ElMessage.error('加载教师列表失败')
    teacherList.value = []
    pagination.total = 0
  } finally {
    loading.value = false
  }
}

const loadDepartments = () => {
  // 从教师列表中提取所有院系
  const deptSet = new Set()
  teacherList.value.forEach(teacher => {
    if (teacher.department) {
      deptSet.add(teacher.department)
    }
  })
  departments.value = Array.from(deptSet).sort()
}

const handleSearch = () => {
  pagination.page = 1
  loadTeachers()
}

const handleCreate = () => {
  Object.assign(form, {
    id: null,
    username: '',
    password: '',
    first_name: '',
    employee_id: '',
    email: '',
    department: '',
    phone: '',
    is_active: true,
    teacher_profile: {
      title: '',
      research_field: '',
      office: ''
    }
  })
  dialogVisible.value = true
}

const handleEdit = (row) => {
  Object.assign(form, {
    id: row.id,
    username: row.username,
    password: '',
    first_name: row.first_name || '',
    employee_id: row.employee_id || '',
    email: row.email || '',
    department: row.department || '',
    phone: row.phone || '',
    is_active: row.is_active !== undefined ? row.is_active : true,
    teacher_profile: {
      title: row.teacher_profile?.title || '',
      research_field: row.teacher_profile?.research_field || '',
      office: row.teacher_profile?.office || ''
    }
  })
  dialogVisible.value = true
}

const handleSave = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (valid) {
      saving.value = true
      try {
        const teacherData = {
          username: form.username,
          first_name: form.first_name,
          employee_id: form.employee_id,
          email: form.email,
          department: form.department,
          phone: form.phone,
          is_active: form.is_active,
          teacher_profile: form.teacher_profile
        }
        
        // 只有新建或修改密码时才传递密码
        if (!form.id || form.password) {
          teacherData.password = form.password
        }
        
        if (form.id) {
          await updateTeacher(form.id, teacherData)
          ElMessage.success('更新成功')
        } else {
          await createTeacher(teacherData)
          ElMessage.success('创建成功')
        }
        dialogVisible.value = false
        loadTeachers()
        loadDepartments()
      } catch (error) {
        const errorMsg = error.response?.data?.detail || error.response?.data?.message || error.message || '保存失败'
        ElMessage.error(errorMsg)
        console.error('保存教师失败:', error.response?.data || error)
      } finally {
        saving.value = false
      }
    }
  })
}

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm('确定要删除该教师吗？', '提示', {
      type: 'warning'
    })
    await deleteTeacher(row.id)
    ElMessage.success('删除成功')
    loadTeachers()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

const handleViewDetail = async (row) => {
  try {
    const teacher = await getTeacher(row.id)
    currentTeacher.value = teacher
    detailDialogVisible.value = true
  } catch (error) {
    ElMessage.error('获取教师详情失败')
  }
}

const handleSizeChange = () => {
  loadTeachers()
}

const handlePageChange = () => {
  loadTeachers()
}
</script>

<style scoped>
.teacher-list {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.search-bar {
  display: flex;
  align-items: center;
}

.pagination {
  margin-top: 20px;
  text-align: right;
}
</style>

