<template>
  <div class="achievement-analysis">
    <div class="page-header">
      <h1 class="page-title">达成情况</h1>
      <div class="page-actions">
<!--        <el-button type="success" @click="handleExport" :disabled="!analysisData">-->
<!--          <el-icon><Download /></el-icon>-->
<!--          导出数据-->
<!--        </el-button>-->
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
              v-for="cls in allClasses"
              :key="cls.id"
              :label="`${cls.course_name} - ${cls.class_name}`"
              :value="cls.id"
            />
          </el-select>
        </el-form-item>
      </el-form>
    </el-card>

    <div v-if="analysisData" style="margin-top: 20px">
      <!-- 基本信息表格 -->
      <el-card>
        <template #header>
          <span>基本信息</span>
        </template>
        <el-descriptions :column="4" border>
          <el-descriptions-item label="课程名称">{{ basicInfo.course_name }}</el-descriptions-item>
          <el-descriptions-item label="教师姓名">{{ basicInfo.teacher_name }}</el-descriptions-item>
          <el-descriptions-item label="所在院(系)">{{ basicInfo.department }}</el-descriptions-item>
          <el-descriptions-item label="授课班级">{{ basicInfo.class_name }}</el-descriptions-item>
          <el-descriptions-item label="课程学时">{{ basicInfo.hours }}</el-descriptions-item>
          <el-descriptions-item label="考试人数" :span="3">{{ basicInfo.exam_count }}</el-descriptions-item>
        </el-descriptions>
      </el-card>

      <!-- 课程成绩分布 -->
      <el-card style="margin-top: 20px">
        <template #header>
          <span>课程成绩分布</span>
        </template>
        <el-table :data="scoreDistributionTableData" border style="width: 100%">
          <el-table-column prop="label" label="" width="120" align="center" fixed="left" />
          <el-table-column prop="不及格" label="不及格(0~59)" align="center">
            <template #default="{ row }">
              {{ row.不及格 }}
            </template>
          </el-table-column>
          <el-table-column prop="及格" label="及格(60~69)" align="center">
            <template #default="{ row }">
              {{ row.及格 }}
            </template>
          </el-table-column>
          <el-table-column prop="中等" label="中等(70~79)" align="center">
            <template #default="{ row }">
              {{ row.中等 }}
            </template>
          </el-table-column>
          <el-table-column prop="良好" label="良好(80~89)" align="center">
            <template #default="{ row }">
              {{ row.良好 }}
            </template>
          </el-table-column>
          <el-table-column prop="优秀" label="优秀(90~100)" align="center">
            <template #default="{ row }">
              {{ row.优秀 }}
            </template>
          </el-table-column>
        </el-table>
        <div style="margin-top: 20px; padding: 15px; background-color: #f5f7fa; border-radius: 4px;">
          <el-row :gutter="20">
            <el-col :span="6">
              <div><strong>最高分：</strong>{{ statistics.max_score }}</div>
            </el-col>
            <el-col :span="6">
              <div><strong>最低分：</strong>{{ statistics.min_score }}</div>
            </el-col>
            <el-col :span="6">
              <div><strong>平均分：</strong>{{ statistics.avg_score.toFixed(2) }}</div>
            </el-col>
            <el-col :span="6">
              <div><strong>标准差σ：</strong>{{ statistics.std_dev.toFixed(2) }}</div>
            </el-col>
          </el-row>
        </div>
      </el-card>

      <!-- 课程目标达成情况表格 -->
      <el-card style="margin-top: 20px">
        <template #header>
          <div class="card-header">
            <span>课程目标达成情况</span>
          </div>
        </template>
        <el-table
          :data="achievementTable"
          border
          style="width: 100%"
          v-loading="loading"
        >
          <el-table-column prop="objective_code" label="目标代号" width="100" align="center" />
          <el-table-column prop="expected_degree" label="期望达成度" width="120" align="center">
            <template #default="{ row }">
              {{ row.expected_degree.toFixed(1) }}
            </template>
          </el-table-column>
          <el-table-column prop="evaluated_degree" label="评估达成度" width="120" align="center">
            <template #default="{ row }">
              {{ row.evaluated_degree.toFixed(3) }}
            </template>
          </el-table-column>
          <el-table-column prop="achievement_rate" label="达成率(%)" width="120" align="center">
            <template #default="{ row }">
              {{ row.achievement_rate.toFixed(1) }}%
            </template>
          </el-table-column>
          <el-table-column prop="evaluation_text" label="达成评价、存在问题、改进措施" min-width="400" />
        </el-table>
      </el-card>
    </div>

    <el-empty v-else description="请选择课程班级查看达成情况数据" />
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Download } from '@element-plus/icons-vue'
import { getClassesWithScores, getClassesWithAlgorithmScores } from '@/api/scores'
import { getAchievementAnalysis } from '@/api/analysis'

const loading = ref(false)
const allClasses = ref([])
const analysisData = ref(null)

const searchForm = reactive({
  course_class_id: null
})

const scoreDistributionTableData = computed(() => {
  if (!analysisData.value || !analysisData.value.distribution) {
    return [
      { label: '分数段', 不及格: '0~59', 及格: '60~69', 中等: '70~79', 良好: '80~89', 优秀: '90~100' },
      { label: '学生数', 不及格: '0', 及格: '0', 中等: '0', 良好: '0', 优秀: '0' },
      { label: '占总人数比例(%)', 不及格: '0.00', 及格: '0.00', 中等: '0.00', 良好: '0.00', 优秀: '0.00' }
    ]
  }
  
  const counts = {
    不及格: 0,
    及格: 0,
    中等: 0,
    良好: 0,
    优秀: 0
  }
  
  const percentages = {
    不及格: '0.00',
    及格: '0.00',
    中等: '0.00',
    良好: '0.00',
    优秀: '0.00'
  }
  
  let total = 0
  analysisData.value.distribution.forEach(dist => {
    const label = dist.label
    if (counts[label] !== undefined) {
      counts[label] = dist.count
      total += dist.count
    }
  })
  
  analysisData.value.distribution.forEach(dist => {
    const label = dist.label
    if (percentages[label] !== undefined) {
      const percentage = total > 0 ? (dist.count / total * 100) : 0
      percentages[label] = percentage.toFixed(2)
    }
  })
  
  return [
    { label: '分数段', 不及格: '0~59', 及格: '60~69', 中等: '70~79', 良好: '80~89', 优秀: '90~100' },
    { label: '学生数', 不及格: counts.不及格.toString(), 及格: counts.及格.toString(), 中等: counts.中等.toString(), 良好: counts.良好.toString(), 优秀: counts.优秀.toString() },
    { label: '占总人数比例(%)', 不及格: percentages.不及格, 及格: percentages.及格, 中等: percentages.中等, 良好: percentages.良好, 优秀: percentages.优秀 }
  ]
})

const basicInfo = computed(() => {
  return analysisData.value?.basic_info || {
    course_name: '',
    teacher_name: '',
    department: '',
    class_name: '',
    hours: 0,
    exam_count: 0
  }
})

const statistics = computed(() => {
  return analysisData.value?.statistics || {
    max_score: 0,
    min_score: 0,
    avg_score: 0,
    std_dev: 0
  }
})

const achievementTable = computed(() => {
  return analysisData.value?.achievement_data || []
})

onMounted(async () => {
  await loadAllClasses()
})

const loadAllClasses = async () => {
  try {
    const response = await getClassesWithScores()
    allClasses.value = response.results || response || []
  } catch (error) {
    ElMessage.error('加载班级列表失败')
    console.error(error)
  }
}

const handleSearch = async () => {
  if (!searchForm.course_class_id) {
    analysisData.value = null
    return
  }

  loading.value = true
  try {
    const response = await getAchievementAnalysis(searchForm.course_class_id)
    
    if (!response.achievement_data || response.achievement_data.length === 0) {
      analysisData.value = null
      ElMessage.warning('该班级暂无达成情况数据')
      return
    }

    analysisData.value = response
  } catch (error) {
    ElMessage.error('加载数据失败: ' + (error.response?.data?.error || error.message))
    console.error(error)
    analysisData.value = null
  } finally {
    loading.value = false
  }
}

const handleExport = async () => {
  if (!analysisData.value) {
    ElMessage.warning('请先加载数据')
    return
  }

  try {
    // TODO: 实现导出Word功能，样式与文档一致
    ElMessage.info('导出功能开发中')
  } catch (error) {
    ElMessage.error('导出失败')
    console.error(error)
  }
}
</script>

<style scoped>
.achievement-analysis {
  padding: 20px;
  max-width: 1400px;
  margin: 0 auto;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-title {
  margin: 0;
  font-size: 24px;
  font-weight: 600;
  color: #303133;
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
