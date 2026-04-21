<template>
  <div class="objective-achievement">
    <div class="page-header">
      <h1 class="page-title">课程目标达成度分析</h1>
      <div class="page-actions">
        <el-button type="primary" @click="handleRecalculate" :loading="recalculating">
          <el-icon><Refresh /></el-icon>
          重新计算
        </el-button>
        <el-button type="success" @click="handleExport">
          <el-icon><Download /></el-icon>
          导出数据
        </el-button>
      </div>
    </div>

    <el-card>
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="选择课程班级">
          <el-select
            v-model="searchForm.course_class_id"
            placeholder="请选择课程班级"
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
      </el-form>
    </el-card>

    <div v-if="achievementData" style="margin-top: 20px">
      <!-- 班级统计 -->
      <el-card>
        <template #header>
          <div class="card-header">
            <span>达成度计算</span>
          </div>
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
              {{ (row.achievement_degree * 100).toFixed(2) }}%
            </template>
          </el-table-column>
        </el-table>
      </el-card>

      <!-- 学生详细数据 -->
      <el-card style="margin-top: 20px">
        <template #header>
          <div class="card-header">
            <span>学生课程目标达成度详情</span>
            <span style="font-size: 14px; color: #909399">
              共 {{ achievementData.student_achievements.length }} 名学生
            </span>
          </div>
        </template>
        <el-table
          :data="achievementData.student_achievements"
          border
          style="width: 100%"
          max-height="600"
        >
          <el-table-column prop="student_id" label="学号" width="120" fixed />
          <el-table-column prop="student_name" label="姓名" width="100" fixed />
          
          <!-- 课程目标1 -->
          <el-table-column label="课程目标1" align="center">
            <el-table-column prop="objective1.usual" label="平时" width="80" />
            <el-table-column prop="objective1.experiment" label="实验" width="80" />
            <el-table-column prop="objective1.final" label="期末" width="80" />
            <el-table-column prop="objective1.achievement" label="达成情况" width="100">
              <template #default="{ row }">
                {{ row.objective1.achievement.toFixed(2) }}
              </template>
            </el-table-column>
            <el-table-column prop="objective1.degree" label="达成度" width="100">
              <template #default="{ row }">
                {{ (row.objective1.degree * 100).toFixed(2) }}%
              </template>
            </el-table-column>
          </el-table-column>

          <!-- 课程目标2 -->
          <el-table-column label="课程目标2" align="center">
            <el-table-column prop="objective2.usual" label="平时" width="80" />
            <el-table-column prop="objective2.experiment" label="实验" width="80" />
            <el-table-column prop="objective2.final" label="期末" width="80" />
            <el-table-column prop="objective2.achievement" label="达成情况" width="100">
              <template #default="{ row }">
                {{ row.objective2.achievement.toFixed(2) }}
              </template>
            </el-table-column>
            <el-table-column prop="objective2.degree" label="达成度" width="100">
              <template #default="{ row }">
                {{ (row.objective2.degree * 100).toFixed(2) }}%
              </template>
            </el-table-column>
          </el-table-column>

          <!-- 课程目标3 -->
          <el-table-column label="课程目标3" align="center">
            <el-table-column prop="objective3.usual" label="平时" width="80" />
            <el-table-column prop="objective3.experiment" label="实验" width="80" />
            <el-table-column prop="objective3.final" label="期末" width="80" />
            <el-table-column prop="objective3.achievement" label="达成情况" width="100">
              <template #default="{ row }">
                {{ row.objective3.achievement.toFixed(2) }}
              </template>
            </el-table-column>
            <el-table-column prop="objective3.degree" label="达成度" width="100">
              <template #default="{ row }">
                {{ (row.objective3.degree * 100).toFixed(2) }}%
              </template>
            </el-table-column>
          </el-table-column>

          <el-table-column prop="total_achievement" label="达成情况总和" width="120">
            <template #default="{ row }">
              {{ row.total_achievement.toFixed(2) }}
            </template>
          </el-table-column>
          <el-table-column prop="usual_entry" label="平时录入" width="100" />
          <el-table-column prop="final_entry" label="期末录入" width="100" />
          <el-table-column prop="final_grade" label="最终成绩" width="100">
            <template #default="{ row }">
              <span :style="{ color: getGradeColor(row.final_grade) }">
                {{ row.final_grade.toFixed(1) }}
              </span>
            </template>
          </el-table-column>
        </el-table>
      </el-card>
    </div>

    <el-empty v-else description="请选择课程班级查看数据" />
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Refresh, Download } from '@element-plus/icons-vue'
import { getClasses } from '@/api/courses'
import { getObjectiveAchievement, recalculateObjectives } from '@/api/analysis'

const loading = ref(false)
const recalculating = ref(false)
const classes = ref([])
const achievementData = ref(null)

const searchForm = reactive({
  course_class_id: null
})

const statisticsTable = computed(() => {
  if (!achievementData.value?.class_statistics) return []
  
  const stats = achievementData.value.class_statistics
  return [
    {
      objective: '课程目标1',
      achievement_score: stats.objective1.achievement_score,
      achievement_degree: stats.objective1.achievement_degree
    },
    {
      objective: '课程目标2',
      achievement_score: stats.objective2.achievement_score,
      achievement_degree: stats.objective2.achievement_degree
    },
    {
      objective: '课程目标3',
      achievement_score: stats.objective3.achievement_score,
      achievement_degree: stats.objective3.achievement_degree
    }
  ]
})

onMounted(async () => {
  await loadClasses()
})

const loadClasses = async () => {
  try {
    const response = await getClasses()
    classes.value = response.results || response
  } catch (error) {
    ElMessage.error('加载班级列表失败')
  }
}

const handleSearch = async () => {
  if (!searchForm.course_class_id) {
    achievementData.value = null
    return
  }

  loading.value = true
  try {
    const response = await getObjectiveAchievement(searchForm.course_class_id)
    achievementData.value = response
  } catch (error) {
    ElMessage.error('加载数据失败')
    achievementData.value = null
  } finally {
    loading.value = false
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
    await handleSearch()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('重新计算失败')
    }
  } finally {
    recalculating.value = false
  }
}

const handleExport = () => {
  if (!achievementData.value) {
    ElMessage.warning('请先加载数据')
    return
  }

  // 导出为Excel的逻辑
  ElMessage.info('导出功能开发中')
}

const getGradeColor = (grade) => {
  if (!grade) return '#909399'
  if (grade >= 90) return '#67C23A'
  if (grade >= 80) return '#409EFF'
  if (grade >= 70) return '#E6A23C'
  if (grade >= 60) return '#F56C6C'
  return '#F56C6C'
}
</script>

<style scoped>
.objective-achievement {
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

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>


