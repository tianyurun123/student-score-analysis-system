<template>
  <div class="score-list">
    <div class="page-header">
      <h1 class="page-title">图形学成绩管理</h1>
      <div class="page-actions">
        <el-button type="primary" @click="$router.push('/scores/import')">
          <el-icon><Upload /></el-icon>
          导入成绩
        </el-button>
        <el-button type="success" @click="handleExport" :disabled="!searchForm.course_class_id">
          <el-icon><Download /></el-icon>
          导出成绩
        </el-button>
        <el-button type="info" @click="handleRecalculate" :disabled="!searchForm.course_class_id" :loading="recalculating">
          <el-icon><Refresh /></el-icon>
          重新计算
        </el-button>
      </div>
    </div>

    <!-- 班级列表卡片 -->
    <el-card style="margin-bottom: 20px">
      <template #header>
        <div style="display: flex; justify-content: space-between; align-items: center">
          <span>有成绩的班级</span>
          <el-button type="text" @click="loadClassesWithScores">
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
        <el-table-column label="成绩数" width="100">
          <template #default="{ row }">
            {{ row.score_count || 0 }}
          </template>
        </el-table-column>
        <el-table-column label="学生数" width="100">
          <template #default="{ row }">
            {{ row.students_count || 0 }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="300" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="handleViewScores(row)">查看成绩</el-button>
            <el-button type="success" size="small" @click="handleExportClass(row)">
              导出成绩
            </el-button>
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
              style="width: 200px"
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
            <el-button type="success" @click="handleAdd" :disabled="!searchForm.course_class_id">
              <el-icon><Plus /></el-icon>
              新增成绩
            </el-button>
            <el-button 
              type="danger" 
              @click="handleBatchDelete" 
              :disabled="selectedScores.length === 0"
            >
              <el-icon><Delete /></el-icon>
              批量删除 ({{ selectedScores.length }})
            </el-button>
          </el-form-item>
        </el-form>
      </div>

      <!-- 完整成绩表格 -->
      <div v-if="scoreList.length > 0" class="score-table-container">
        <el-table
          :data="scoreList"
          border
          v-loading="loading"
          style="width: 100%"
          :max-height="600"
          @selection-change="handleSelectionChange"
        >
          <!-- 复选框列 -->
          <el-table-column type="selection" width="55" fixed="left" />
          <!-- 基本信息列 -->
          <el-table-column prop="student_id" label="学号" width="120" fixed="left" />
          <el-table-column prop="student_name" label="姓名" width="100" fixed="left" />
          
          <!-- 原始成绩列 -->
          <el-table-column prop="attendance_score" label="点名" width="80" />
          <el-table-column label="电子笔记" width="100">
            <template #default="{ row }">
              {{ row.extra_scores && row.extra_scores['电子笔记'] ? row.extra_scores['电子笔记'].toFixed(1) : '-' }}
            </template>
          </el-table-column>
          <el-table-column prop="homework_score" label="作业成绩" width="100" />
          <el-table-column prop="usual_total" label="平时成绩" width="100">
            <template #default="{ row }">
              {{ row.usual_total ? Math.round(row.usual_total) : '-' }}
            </template>
          </el-table-column>
          
          <el-table-column prop="experiment_score" label="实验" width="80" />
          <el-table-column label="作品" width="80">
            <template #default="{ row }">
              {{ row.extra_scores && row.extra_scores['作品'] ? row.extra_scores['作品'].toFixed(1) : '-' }}
            </template>
          </el-table-column>
          <el-table-column label="报告" width="80">
            <template #default="{ row }">
              {{ row.extra_scores && row.extra_scores['报告'] ? row.extra_scores['报告'].toFixed(1) : '-' }}
            </template>
          </el-table-column>
          <el-table-column prop="final_total" label="期末平均" width="100">
            <template #default="{ row }">
              {{ row.final_total !== null && row.final_total !== undefined ? Math.floor(row.final_total) : '-' }}
            </template>
          </el-table-column>

          <!-- 课程目标1 -->
          <el-table-column label="课程目标1" align="center">
            <el-table-column label="平时" width="80">
              <template #default="{ row }">
                {{ getObjectiveValue(row, 1, 'usual') }}
              </template>
            </el-table-column>
            <el-table-column label="实验" width="80">
              <template #default="{ row }">
                {{ getObjectiveValue(row, 1, 'experiment') }}
              </template>
            </el-table-column>
            <el-table-column label="期末" width="80">
              <template #default="{ row }">
                {{ getObjectiveValue(row, 1, 'final') }}
              </template>
            </el-table-column>
            <el-table-column label="达成情况" width="100">
              <template #default="{ row }">
                {{ getObjectiveValue(row, 1, 'achievement') }}
              </template>
            </el-table-column>
            <el-table-column label="达成度" width="100">
              <template #default="{ row }">
                {{ getObjectiveValue(row, 1, 'degree') }}
              </template>
            </el-table-column>
          </el-table-column>

          <!-- 课程目标2 -->
          <el-table-column label="课程目标2" align="center">
            <el-table-column label="平时" width="80">
              <template #default="{ row }">
                {{ getObjectiveValue(row, 2, 'usual') }}
              </template>
            </el-table-column>
            <el-table-column label="实验" width="80">
              <template #default="{ row }">
                {{ getObjectiveValue(row, 2, 'experiment') }}
              </template>
            </el-table-column>
            <el-table-column label="期末" width="80">
              <template #default="{ row }">
                {{ getObjectiveValue(row, 2, 'final') }}
              </template>
            </el-table-column>
            <el-table-column label="达成情况" width="100">
              <template #default="{ row }">
                {{ getObjectiveValue(row, 2, 'achievement') }}
              </template>
            </el-table-column>
            <el-table-column label="达成度" width="100">
              <template #default="{ row }">
                {{ getObjectiveValue(row, 2, 'degree') }}
              </template>
            </el-table-column>
          </el-table-column>

          <!-- 课程目标3 -->
          <el-table-column label="课程目标3" align="center">
            <el-table-column label="平时" width="80">
              <template #default="{ row }">
                {{ getObjectiveValue(row, 3, 'usual') }}
              </template>
            </el-table-column>
            <el-table-column label="实验" width="80">
              <template #default="{ row }">
                {{ getObjectiveValue(row, 3, 'experiment') }}
              </template>
            </el-table-column>
            <el-table-column label="期末" width="80">
              <template #default="{ row }">
                {{ getObjectiveValue(row, 3, 'final') }}
              </template>
            </el-table-column>
            <el-table-column label="达成情况" width="100">
              <template #default="{ row }">
                {{ getObjectiveValue(row, 3, 'achievement') }}
              </template>
            </el-table-column>
            <el-table-column label="达成度" width="100">
              <template #default="{ row }">
                {{ getObjectiveValue(row, 3, 'degree') }}
              </template>
            </el-table-column>
            <el-table-column label="总分值" width="100">
              <template #default="{ row }">
                {{ getTotalScore(row) }}
              </template>
            </el-table-column>
          </el-table-column>

          <!-- 最终成绩 -->
          <el-table-column prop="usual_entry" label="平时录入" width="100">
            <template #default="{ row }">
              {{ row.usual_entry !== null && row.usual_entry !== undefined ? Math.round(row.usual_entry) : '-' }}
            </template>
          </el-table-column>
          <el-table-column prop="final_entry" label="期末录入" width="100">
            <template #default="{ row }">
              {{ row.final_entry !== null && row.final_entry !== undefined ? Math.round(row.final_entry) : '-' }}
            </template>
          </el-table-column>
          <el-table-column prop="final_grade" label="最终成绩" width="100" fixed="right">
            <template #default="{ row }">
              <span :style="{ color: getGradeColor(row.final_grade) }">
                {{ row.final_grade ? Math.round(row.final_grade) : '-' }}
              </span>
            </template>
          </el-table-column>

          <el-table-column label="操作" width="200" fixed="right">
            <template #default="{ row }">
              <el-button type="primary" size="small" @click="handleEdit(row)">编辑</el-button>
              <el-button type="danger" size="small" @click="handleDelete(row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>

        <!-- 班级整体达成度统计 -->
        <el-card style="margin-top: 20px">
          <template #header>
            <span>达成度计算</span>
          </template>
          <el-table :data="statisticsTable" border style="width: 100%">
            <el-table-column prop="objective" label="课程目标" width="150" />
            <el-table-column prop="achievement_score" label="达成分值" width="150">
              <template #default="{ row }">
                {{ row.achievement_score.toFixed(2) }}
              </template>
            </el-table-column>
            <el-table-column prop="achievement_degree" label="达成度" width="150">
              <template #default="{ row }">
                {{ row.achievement_degree.toFixed(2) }}
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </div>

      <el-empty v-else description="请选择课程班级查看成绩" />
    </el-card>

    <!-- 新增/编辑对话框 -->
    <el-dialog
      v-model="editDialogVisible"
      :title="editForm.id ? '编辑成绩' : '新增成绩'"
      width="800px"
    >
      <el-form
        ref="editFormRef"
        :model="editForm"
        :rules="editRules"
        label-width="120px"
      >
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="学号" prop="student_id">
              <el-input 
                v-model="editForm.student_id" 
                :disabled="!!editForm.id"
                placeholder="请输入学号"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="姓名" prop="student_name">
              <el-input 
                v-model="editForm.student_name" 
                :disabled="!!editForm.id"
                placeholder="请输入姓名"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="点名" prop="attendance_score">
              <el-input-number
                v-model="editForm.attendance_score"
                :min="0"
                :max="100"
                :precision="1"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="电子笔记">
              <el-input-number
                v-model="editForm.extra_scores['电子笔记']"
                :min="0"
                :max="100"
                :precision="1"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="作业成绩" prop="homework_score">
              <el-input-number
                v-model="editForm.homework_score"
                :min="0"
                :max="100"
                :precision="1"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="实验" prop="experiment_score">
              <el-input-number
                v-model="editForm.experiment_score"
                :min="0"
                :max="100"
                :precision="1"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="作品">
              <el-input-number
                v-model="editForm.extra_scores['作品']"
                :min="0"
                :max="100"
                :precision="1"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="报告">
              <el-input-number
                v-model="editForm.extra_scores['报告']"
                :min="0"
                :max="100"
                :precision="1"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="平时录入">
              <el-input-number
                v-model="editForm.usual_entry"
                :min="0"
                :max="100"
                :precision="1"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="期末录入">
              <el-input-number
                v-model="editForm.final_entry"
                :min="0"
                :max="100"
                :precision="1"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <template #footer>
        <el-button @click="editDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSave" :loading="saving">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Upload, Download, Refresh, ArrowDown, Plus, Delete } from '@element-plus/icons-vue'
import { getScores, createScore, updateScore, deleteScore, exportScores, exportAchievement, getClassesWithScores } from '@/api/scores'
import { getClasses } from '@/api/courses'
import { getObjectiveAchievement, recalculateObjectives } from '@/api/analysis'

const loading = ref(false)
const saving = ref(false)
const recalculating = ref(false)
const loadingClasses = ref(false)
const scoreList = ref([])
const classes = ref([])
const classesWithScores = ref([])
const editDialogVisible = ref(false)
const editFormRef = ref(null)
const objectiveData = ref({})

const searchForm = reactive({
  course_class_id: null,
  student_id: ''
})

const pagination = reactive({
  page: 1,
  pageSize: 20,
  total: 0
})

const selectedScores = ref([])

const editForm = reactive({
  id: null,
  student_id: '',
  student_name: '',
  attendance_score: null,
  homework_score: null,
  experiment_score: null,
  final_score: null,
  usual_entry: null,
  final_entry: null,
  extra_scores: {
    '电子笔记': null,
    '作品': null,
    '报告': null
  }
})

const editRules = {
  student_id: [
    { required: true, message: '请输入学号', trigger: 'blur' }
  ],
  student_name: [
    { required: true, message: '请输入姓名', trigger: 'blur' }
  ],
  attendance_score: [
    { type: 'number', min: 0, max: 100, message: '成绩必须在0-100之间', trigger: 'blur' }
  ],
  homework_score: [
    { type: 'number', min: 0, max: 100, message: '成绩必须在0-100之间', trigger: 'blur' }
  ],
  experiment_score: [
    { type: 'number', min: 0, max: 100, message: '成绩必须在0-100之间', trigger: 'blur' }
  ]
}

const statisticsTable = computed(() => {
  if (!scoreList.value || scoreList.value.length === 0) return []
  
  // 计算每个课程目标的平均达成度和达成分值
  let obj1ScoreSum = 0
  let obj2ScoreSum = 0
  let obj3ScoreSum = 0
  let obj1DegreeSum = 0
  let obj2DegreeSum = 0
  let obj3DegreeSum = 0
  let obj1Count = 0
  let obj2Count = 0
  let obj3Count = 0
  
  scoreList.value.forEach(score => {
    const obj1 = score.objective_achievements?.objective1
    const obj2 = score.objective_achievements?.objective2
    const obj3 = score.objective_achievements?.objective3
    
    if (obj1 && obj1.achievement !== undefined && !isNaN(obj1.achievement) && obj1.degree !== undefined && !isNaN(obj1.degree)) {
      obj1ScoreSum += obj1.achievement
      obj1DegreeSum += obj1.degree
      obj1Count++
    }
    if (obj2 && obj2.achievement !== undefined && !isNaN(obj2.achievement) && obj2.degree !== undefined && !isNaN(obj2.degree)) {
      obj2ScoreSum += obj2.achievement
      obj2DegreeSum += obj2.degree
      obj2Count++
    }
    if (obj3 && obj3.achievement !== undefined && !isNaN(obj3.achievement) && obj3.degree !== undefined && !isNaN(obj3.degree)) {
      obj3ScoreSum += obj3.achievement
      obj3DegreeSum += obj3.degree
      obj3Count++
    }
  })
  
  const obj1ScoreAvg = obj1Count > 0 ? obj1ScoreSum / obj1Count : 0
  const obj2ScoreAvg = obj2Count > 0 ? obj2ScoreSum / obj2Count : 0
  const obj3ScoreAvg = obj3Count > 0 ? obj3ScoreSum / obj3Count : 0
  const obj1DegreeAvg = obj1Count > 0 ? obj1DegreeSum / obj1Count : 0
  const obj2DegreeAvg = obj2Count > 0 ? obj2DegreeSum / obj2Count : 0
  const obj3DegreeAvg = obj3Count > 0 ? obj3DegreeSum / obj3Count : 0
  
  return [
    {
      objective: '课程目标1',
      achievement_score: obj1ScoreAvg,
      achievement_degree: obj1DegreeAvg
    },
    {
      objective: '课程目标2',
      achievement_score: obj2ScoreAvg,
      achievement_degree: obj2DegreeAvg
    },
    {
      objective: '课程目标3',
      achievement_score: obj3ScoreAvg,
      achievement_degree: obj3DegreeAvg
    }
  ]
})

onMounted(() => {
  loadClasses()
  loadClassesWithScores()
})

const loadClasses = async () => {
  try {
    const response = await getClasses()
    classes.value = response.results || response
  } catch (error) {
    console.error('加载班级列表失败:', error)
  }
}

const loadScores = async () => {
  if (!searchForm.course_class_id) {
    scoreList.value = []
    objectiveData.value = {}
    return
  }

  loading.value = true
  try {
    const params = {
      page: pagination.page,
      page_size: pagination.pageSize,
      ...searchForm
    }
    const response = await getScores(params)
    scoreList.value = response.results || response
    pagination.total = response.count || scoreList.value.length

    // 加载课程目标达成度数据
    try {
      const objResponse = await getObjectiveAchievement(searchForm.course_class_id)
      objectiveData.value = objResponse
      
      // 将课程目标数据合并到成绩列表中
      const achievementMap = {}
      if (objResponse.student_achievements) {
        objResponse.student_achievements.forEach(ach => {
          achievementMap[ach.student_id] = ach
        })
      }
      
      scoreList.value.forEach(score => {
        score.objective_achievements = achievementMap[score.student_id] || {}
      })
    } catch (error) {
      console.error('加载课程目标达成度失败:', error)
    }
  } catch (error) {
    ElMessage.error('加载成绩列表失败')
  } finally {
    loading.value = false
  }
}

const handleSearch = async () => {
  pagination.page = 1
  await loadScores()
}

const handleReset = () => {
  searchForm.course_class_id = null
  searchForm.student_id = ''
  handleSearch()
}

const handleSizeChange = () => {
  loadScores()
}

const handlePageChange = () => {
  loadScores()
}

const getObjectiveValue = (row, objectiveNum, field) => {
  const obj = row.objective_achievements?.[`objective${objectiveNum}`]
  if (!obj) return '-'
  
  if (field === 'degree') {
    return obj.degree.toFixed(2)
  }
  return obj[field]?.toFixed(2) || '-'
}

const getTotalScore = (row) => {
  const obj1 = row.objective_achievements?.objective1
  const obj2 = row.objective_achievements?.objective2
  const obj3 = row.objective_achievements?.objective3
  
  if (!obj1 || !obj2 || !obj3) return '-'
  
  const total = (obj1.achievement || 0) + (obj2.achievement || 0) + (obj3.achievement || 0)
  return total.toFixed(2)
}

const handleAdd = () => {
  if (!searchForm.course_class_id) {
    ElMessage.warning('请先选择课程班级')
    return
  }
  // 重置表单
  Object.assign(editForm, {
    id: null,
    student_id: '',
    student_name: '',
    attendance_score: null,
    homework_score: null,
    experiment_score: null,
    final_score: null,
    usual_entry: null,
    final_entry: null,
    extra_scores: {
      '电子笔记': null,
      '作品': null,
      '报告': null
    }
  })
  editDialogVisible.value = true
}

const handleEdit = (row) => {
  editForm.id = row.id
  editForm.student_id = row.student_id
  editForm.student_name = row.student_name
  editForm.attendance_score = row.attendance_score
  editForm.homework_score = row.homework_score
  editForm.experiment_score = row.experiment_score
  editForm.final_score = row.final_score
  editForm.usual_entry = row.usual_entry
  editForm.final_entry = row.final_entry
  editForm.extra_scores = {
    '电子笔记': row.extra_scores?.['电子笔记'] || null,
    '作品': row.extra_scores?.['作品'] || null,
    '报告': row.extra_scores?.['报告'] || null
  }
  editDialogVisible.value = true
}

const handleSelectionChange = (selection) => {
  selectedScores.value = selection
}

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除学生 ${row.student_name} (${row.student_id}) 的成绩记录吗？`,
      '提示',
      {
        type: 'warning'
      }
    )
    await deleteScore(row.id)
    ElMessage.success('删除成功')
    await loadScores()
    await loadClassesWithScores()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error(error.response?.data?.error || error.response?.data?.message || '删除失败')
    }
  }
}

const handleBatchDelete = async () => {
  if (selectedScores.value.length === 0) {
    ElMessage.warning('请选择要删除的成绩记录')
    return
  }
  
  try {
    await ElMessageBox.confirm(
      `确定要删除选中的 ${selectedScores.value.length} 条成绩记录吗？`,
      '提示',
      {
        type: 'warning'
      }
    )
    
    // 批量删除
    const deletePromises = selectedScores.value.map(score => deleteScore(score.id))
    await Promise.all(deletePromises)
    
    ElMessage.success(`成功删除 ${selectedScores.value.length} 条成绩记录`)
    selectedScores.value = []
    await loadScores()
    await loadClassesWithScores()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error(error.response?.data?.error || error.response?.data?.message || '批量删除失败')
    }
  }
}

const handleSave = async () => {
  if (!editFormRef.value) return
  
  await editFormRef.value.validate(async (valid) => {
    if (valid) {
      saving.value = true
      try {
        if (editForm.id) {
          // 编辑模式
          const data = {
            attendance_score: editForm.attendance_score,
            homework_score: editForm.homework_score,
            experiment_score: editForm.experiment_score,
            final_score: editForm.final_score,
            usual_entry: editForm.usual_entry,
            final_entry: editForm.final_entry,
            extra_scores: editForm.extra_scores
          }
          await updateScore(editForm.id, data)
          ElMessage.success('保存成功')
        } else {
          // 新增模式
          if (!searchForm.course_class_id) {
            ElMessage.warning('请先选择课程班级')
            saving.value = false
            return
          }
          
          const data = {
            student_id: editForm.student_id,
            student_name: editForm.student_name,
            course_class_id: searchForm.course_class_id,
            attendance_score: editForm.attendance_score,
            homework_score: editForm.homework_score,
            experiment_score: editForm.experiment_score,
            final_score: editForm.final_score,
            usual_entry: editForm.usual_entry,
            final_entry: editForm.final_entry,
            extra_scores: editForm.extra_scores
          }
          await createScore(data)
          ElMessage.success('新增成功')
        }
        editDialogVisible.value = false
        await loadScores()
        await loadClassesWithScores()
      } catch (error) {
        ElMessage.error(error.response?.data?.error || error.response?.data?.message || '操作失败')
      } finally {
        saving.value = false
      }
    }
  })
}

const handleExport = async () => {
  if (!searchForm.course_class_id) {
    ElMessage.warning('请先选择课程班级')
    return
  }
  
  try {
    const params = { course_class_id: searchForm.course_class_id }
    const response = await exportAchievement(params)
    const filename = `成绩表_${new Date().getTime()}.xlsx`
    
    const blob = new Blob([response.data], {
      type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    })
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = filename
    link.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success('导出成功')
  } catch (error) {
    ElMessage.error('导出失败: ' + (error.response?.data?.error || error.message))
  }
}

const handleRecalculate = async () => {
  if (!searchForm.course_class_id) {
    ElMessage.warning('请先选择课程班级')
    return
  }

  try {
    await ElMessageBox.confirm('确定要重新计算所有学生的课程目标达成度吗？', '提示', {
      type: 'warning'
    })
    
    recalculating.value = true
    await recalculateObjectives(searchForm.course_class_id)
    ElMessage.success('重新计算完成')
    await loadScores()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('重新计算失败')
    }
  } finally {
    recalculating.value = false
  }
}

const getGradeColor = (grade) => {
  if (!grade) return '#909399'
  if (grade >= 90) return '#67C23A'
  if (grade >= 80) return '#409EFF'
  if (grade >= 70) return '#E6A23C'
  if (grade >= 60) return '#F56C6C'
  return '#F56C6C'
}

const loadClassesWithScores = async () => {
  loadingClasses.value = true
  try {
    const response = await getClassesWithScores()
    classesWithScores.value = response.results || []
  } catch (error) {
    console.error('加载有成绩的班级列表失败:', error)
    ElMessage.error('加载班级列表失败')
  } finally {
    loadingClasses.value = false
  }
}

const handleViewScores = async (row) => {
  searchForm.course_class_id = row.id
  await handleSearch()
  // 查看成绩后刷新班级列表（因为可能为新学生创建了成绩记录）
  await loadClassesWithScores()
  // 滚动到成绩表格
  setTimeout(() => {
    const scoreTable = document.querySelector('.score-table-container')
    if (scoreTable) {
      scoreTable.scrollIntoView({ behavior: 'smooth' })
    }
  }, 100)
}

const handleExportClass = async (row) => {
  try {
    const params = { course_class_id: row.id }
    const response = await exportAchievement(params)
    const filename = `成绩表_${row.course_code}_${row.class_name}_${new Date().getTime()}.xlsx`
    
    const blob = new Blob([response.data], {
      type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    })
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = filename
    link.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success('导出成功')
  } catch (error) {
    ElMessage.error('导出失败: ' + (error.response?.data?.error || error.message))
  }
}
</script>

<style scoped>
.score-list {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-actions {
  display: flex;
  gap: 10px;
}

.score-table-container {
  margin-top: 20px;
}

.pagination {
  margin-top: 20px;
  text-align: right;
}
</style>
