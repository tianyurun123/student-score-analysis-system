<template>
  <div class="dashboard">
    <el-row :gutter="20" v-if="dashboardData">
      <el-col :span="8" v-for="stat in stats" :key="stat.label">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-left">
              <div class="stat-icon" :style="{ backgroundColor: stat.color }">
                <el-icon :size="30"><component :is="stat.icon" /></el-icon>
              </div>
              <div class="stat-info">
                <div class="stat-value">{{ stat.value }}</div>
                <div class="stat-label">{{ stat.label }}</div>
              </div>
            </div>
            <div class="stat-detail" v-if="stat.detail && stat.detail.length > 0">
              <div class="stat-detail-item" v-for="(item, index) in stat.detail" :key="index">
                <span class="detail-label">{{ item.label }}：</span>
                <span class="detail-value">{{ item.value }}</span>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 数据分析图表 -->
    <el-row :gutter="20" style="margin-top: 20px" v-if="dashboardData && dashboardData.user_type === 'teacher'">
      <el-col :span="24">
        <el-card>
          <template #header>
            <div style="display: flex; justify-content: space-between; align-items: center">
              <span>数据分析</span>
              <el-select
                v-model="selectedClassId"
                placeholder="请选择班级"
                clearable
                filterable
                style="width: 300px"
                @change="handleClassChange"
              >
                <el-option
                  v-for="cls in classesWithScores"
                  :key="cls.id"
                  :label="`${cls.course_name} - ${cls.class_name}`"
                  :value="cls.id"
                />
              </el-select>
            </div>
          </template>
          <div v-if="analysisLoading" style="text-align: center; padding: 40px;">
            <el-icon class="is-loading" :size="30"><Loading /></el-icon>
            <p>加载中...</p>
          </div>
          <div v-else-if="selectedClassId && analysisData">
            <el-row :gutter="20">
              <!-- 班级所有学生成绩分布图 -->
              <el-col :span="12">
                <div class="chart-container">
                  <h3>班级所有学生成绩分布</h3>
                  <div ref="gradeDistributionChart" style="width: 100%; height: 400px;"></div>
                </div>
              </el-col>
              <!-- 班级每个课程目标的达成度曲线 -->
              <el-col :span="12">
                <div class="chart-container">
                  <h3>课程目标达成度</h3>
                  <div ref="objectiveChart" style="width: 100%; height: 400px;"></div>
                </div>
              </el-col>
            </el-row>
          </div>
          <div v-else style="text-align: center; padding: 40px; color: #909399;">
            <p>请选择班级查看数据分析</p>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick } from 'vue'
import { useAuthStore } from '@/stores/auth'
import { getDashboard, getObjectiveAchievement } from '@/api/analysis'
import { getClassesWithScores, getScores } from '@/api/scores'
import { ElMessage } from 'element-plus'
import { Upload, Plus, Loading } from '@element-plus/icons-vue'
import * as echarts from 'echarts'

const authStore = useAuthStore()
const dashboardData = ref(null)
const analysisData = ref(null)
const analysisLoading = ref(false)
const classesWithScores = ref([])
const selectedClassId = ref(null)

const gradeDistributionChart = ref(null)
const objectiveChart = ref(null)

let gradeDistributionChartInstance = null
let objectiveChartInstance = null

const userInfo = computed(() => authStore.user)

const stats = computed(() => {
  if (!dashboardData.value) return []
  
  const data = dashboardData.value
  if (data.user_type === 'teacher') {
    // 课程数卡片详情：显示所有课程名称
    const courseDetail = data.course_names ? data.course_names.map(name => ({
      label: '',
      value: name
    })) : []
    
    // 班级数卡片详情：显示每个课程的班级数目
    const classDetail = []
    if (data.classes_by_course) {
      Object.keys(data.classes_by_course).forEach(courseName => {
        const classCount = data.classes_by_course[courseName].length
        classDetail.push({
          label: courseName,
          value: classCount
        })
      })
    }
    
    return [
      { 
        label: '课程数', 
        value: data.total_courses, 
        icon: 'Document', 
        color: '#409EFF',
        detail: courseDetail
      },
      { 
        label: '班级数', 
        value: data.total_classes, 
        icon: 'UserFilled', 
        color: '#67C23A',
        detail: classDetail
      },
      { 
        label: '学生数', 
        value: data.total_students, 
        icon: 'User', 
        color: '#E6A23C',
        detail: []
      }
    ]
  } else if (data.user_type === 'student') {
    return [
      { label: '已修课程', value: data.total_courses, icon: 'Document', color: '#409EFF', detail: [] },
      { label: '平均绩点', value: data.average_gpa, icon: 'Trophy', color: '#67C23A', detail: [] }
    ]
  }
  return []
})

const loadClassesWithScores = async () => {
  try {
    const response = await getClassesWithScores()
    classesWithScores.value = response.results || response || []
  } catch (error) {
    console.error('加载班级列表失败:', error)
  }
}

const handleClassChange = async () => {
  if (!selectedClassId.value) {
    analysisData.value = null
    // 销毁图表
    if (gradeDistributionChartInstance) {
      gradeDistributionChartInstance.dispose()
      gradeDistributionChartInstance = null
    }
    if (objectiveChartInstance) {
      objectiveChartInstance.dispose()
      objectiveChartInstance = null
    }
    return
  }
  
  await loadAnalysisData()
}

const loadAnalysisData = async () => {
  if (!selectedClassId.value) return
  
  analysisLoading.value = true
  try {
    let scores = []
    
    // 获取图形学成绩数据（处理分页）
    let page = 1
    let hasMore = true
    while (hasMore) {
      const response = await getScores({ 
        course_class_id: selectedClassId.value,
        page_size: 1000,
        page: page
      })
      
      if (response.results) {
        scores = scores.concat(response.results)
        hasMore = response.next !== null
        page++
      } else if (response.data) {
        scores = scores.concat(response.data)
        hasMore = false
      } else if (Array.isArray(response)) {
        scores = scores.concat(response)
        hasMore = false
      } else {
        hasMore = false
      }
    }
    
    if (scores.length === 0) {
      analysisData.value = null
      analysisLoading.value = false
      return
    }
    
    // 获取课程目标达成度数据
    let objectiveData = {}
    try {
      const objResponse = await getObjectiveAchievement(selectedClassId.value)
      objectiveData = objResponse
      
      // 将课程目标数据合并到成绩列表中
      const achievementMap = {}
      if (objResponse.student_achievements) {
        objResponse.student_achievements.forEach(ach => {
          achievementMap[ach.student_id] = ach
        })
      }
      
      scores.forEach(score => {
        // 尝试多种方式匹配学生ID
        const studentId = score.student?.employee_id || score.student?.username || score.student_id
        score.objective_achievements = achievementMap[studentId] || {}
      })
    } catch (error) {
      console.error('加载课程目标达成度失败:', error)
    }
    
    // 处理数据
    analysisData.value = {
      scores,
      objectiveData
    }
    
    console.log('loadAnalysisData: Data loaded, scores:', scores.length)
    console.log('loadAnalysisData: objectiveData:', objectiveData)
    
    // 等待DOM更新后再渲染图表
    await nextTick()
    // 再等待一小段时间确保DOM完全渲染
    setTimeout(() => {
      console.log('loadAnalysisData: Rendering charts after delay')
      console.log('loadAnalysisData: gradeDistributionChart ref:', gradeDistributionChart.value)
      console.log('loadAnalysisData: objectiveChart ref:', objectiveChart.value)
      renderCharts()
    }, 200)
  } catch (error) {
    console.error('加载数据分析失败:', error)
    ElMessage.error('加载数据分析失败')
  } finally {
    analysisLoading.value = false
  }
}

const renderCharts = () => {
  if (!analysisData.value) {
    console.log('renderCharts: analysisData is null')
    return
  }
  
  const { scores } = analysisData.value
  console.log('renderCharts: scores count:', scores.length)
  
  // 1. 班级所有学生成绩分布图（柱状图）
  if (!gradeDistributionChart.value) {
    console.error('renderCharts: gradeDistributionChart ref is null, retrying...')
    setTimeout(() => renderCharts(), 100)
    return
  }
  
  if (gradeDistributionChartInstance) {
    gradeDistributionChartInstance.dispose()
    gradeDistributionChartInstance = null
  }
  
  try {
    gradeDistributionChartInstance = echarts.init(gradeDistributionChart.value)
    console.log('renderCharts: gradeDistributionChart initialized')
    
    const grades = scores
      .filter(s => s.final_grade !== null && s.final_grade !== undefined)
      .map(s => Math.round(s.final_grade))
    
    console.log('renderCharts: grades:', grades.length, 'sample:', grades.slice(0, 5))
    
    // 按分数段统计
    const bins = [0, 60, 70, 80, 90, 100]
    const counts = new Array(bins.length - 1).fill(0)
    grades.forEach(grade => {
      for (let i = 0; i < bins.length - 1; i++) {
        if (grade >= bins[i] && (i === bins.length - 2 ? grade <= bins[i + 1] : grade < bins[i + 1])) {
          counts[i]++
          break
        }
      }
    })
    
    console.log('renderCharts: grade distribution counts:', counts)
    
    gradeDistributionChartInstance.setOption({
      title: { text: '', left: 'center' },
      tooltip: { 
        trigger: 'axis',
        formatter: '{b}<br/>{a}: {c}人'
      },
      xAxis: {
        type: 'category',
        data: ['0-59', '60-69', '70-79', '80-89', '90-100'],
        name: '成绩区间'
      },
      yAxis: { 
        type: 'value', 
        name: '人数'
      },
      series: [{
        name: '学生人数',
        data: counts,
        type: 'bar',
        itemStyle: { color: '#409EFF' },
        label: {
          show: true,
          position: 'top'
        }
      }]
    })
    
    console.log('renderCharts: gradeDistributionChart option set')
  } catch (error) {
    console.error('renderCharts: Failed to init gradeDistributionChart:', error)
    return
  }
  
  // 2. 班级每个课程目标的达成度曲线
  if (!objectiveChart.value) {
    console.error('renderCharts: objectiveChart ref is null, retrying...')
    setTimeout(() => renderCharts(), 100)
    return
  }
  
  if (objectiveChartInstance) {
    objectiveChartInstance.dispose()
    objectiveChartInstance = null
  }
  
  try {
    objectiveChartInstance = echarts.init(objectiveChart.value)
    console.log('renderCharts: objectiveChart initialized')
    
    // 从成绩数据中提取每个学生的课程目标达成度
    // 优先从objectiveData中获取数据（这是最可靠的数据源）
    const obj1Degrees = []
    const obj2Degrees = []
    const obj3Degrees = []
    const obj4Degrees = []
    
    if (analysisData.value.objectiveData && analysisData.value.objectiveData.student_achievements) {
      analysisData.value.objectiveData.student_achievements.forEach(ach => {
        if (ach.objective1 && ach.objective1.degree !== null && ach.objective1.degree !== undefined) {
          obj1Degrees.push(ach.objective1.degree * 100)
        }
        if (ach.objective2 && ach.objective2.degree !== null && ach.objective2.degree !== undefined) {
          obj2Degrees.push(ach.objective2.degree * 100)
        }
        if (ach.objective3 && ach.objective3.degree !== null && ach.objective3.degree !== undefined) {
          obj3Degrees.push(ach.objective3.degree * 100)
        }
        if (ach.objective4 && ach.objective4.degree !== null && ach.objective4.degree !== undefined) {
          obj4Degrees.push(ach.objective4.degree * 100)
        }
      })
    } else {
      // 备用方案：从scores中提取（如果数据已合并）
      scores.forEach(score => {
        const obj1 = score.objective_achievements?.objective1 || score.obj1_degree
        const obj2 = score.objective_achievements?.objective2 || score.obj2_degree
        const obj3 = score.objective_achievements?.objective3 || score.obj3_degree
        const obj4 = score.objective_achievements?.objective4 || score.obj4_degree
        
        if (obj1 && (typeof obj1 === 'object' ? obj1.degree : obj1) !== null && (typeof obj1 === 'object' ? obj1.degree : obj1) !== undefined) {
          obj1Degrees.push((typeof obj1 === 'object' ? obj1.degree : obj1) * 100)
        }
        if (obj2 && (typeof obj2 === 'object' ? obj2.degree : obj2) !== null && (typeof obj2 === 'object' ? obj2.degree : obj2) !== undefined) {
          obj2Degrees.push((typeof obj2 === 'object' ? obj2.degree : obj2) * 100)
        }
        if (obj3 && (typeof obj3 === 'object' ? obj3.degree : obj3) !== null && (typeof obj3 === 'object' ? obj3.degree : obj3) !== undefined) {
          obj3Degrees.push((typeof obj3 === 'object' ? obj3.degree : obj3) * 100)
        }
        if (obj4 && (typeof obj4 === 'object' ? obj4.degree : obj4) !== null && (typeof obj4 === 'object' ? obj4.degree : obj4) !== undefined) {
          obj4Degrees.push((typeof obj4 === 'object' ? obj4.degree : obj4) * 100)
        }
      })
    }
    
    console.log('renderCharts: extracted degrees - obj1:', obj1Degrees.length, 'obj2:', obj2Degrees.length, 'obj3:', obj3Degrees.length)
    if (obj1Degrees.length > 0) {
      console.log('renderCharts: sample obj1 degrees:', obj1Degrees.slice(0, 5))
      console.log('renderCharts: sample obj2 degrees:', obj2Degrees.slice(0, 5))
      console.log('renderCharts: sample obj3 degrees:', obj3Degrees.slice(0, 5))
    }
    
    console.log('renderCharts: objective degrees - obj1 count:', obj1Degrees.length, 'obj2 count:', obj2Degrees.length, 'obj3 count:', obj3Degrees.length)
    
    // 使用箱线图展示每个课程目标的达成度分布
    // 计算每个课程目标的统计信息（最小值、Q1、中位数、Q3、最大值）
    const calculateBoxplotData = (data) => {
      if (data.length === 0) return [0, 0, 0, 0, 0]
      const sorted = [...data].sort((a, b) => a - b)
      const min = sorted[0]
      const max = sorted[sorted.length - 1]
      const q1Index = Math.floor(sorted.length * 0.25)
      const medianIndex = Math.floor(sorted.length * 0.5)
      const q3Index = Math.floor(sorted.length * 0.75)
      const q1 = sorted[q1Index]
      const median = sorted[medianIndex]
      const q3 = sorted[q3Index]
      return [min, q1, median, q3, max]
    }
    
    const boxplotData1 = calculateBoxplotData(obj1Degrees)
    const boxplotData2 = calculateBoxplotData(obj2Degrees)
    const boxplotData3 = calculateBoxplotData(obj3Degrees)
    const boxplotData4 = calculateBoxplotData(obj4Degrees)
    
    const option2 = {
      title: { text: '', left: 'center' },
      tooltip: {
        trigger: 'item',
        formatter: function(params) {
          if (params.seriesType === 'boxplot') {
            const data = params.data
            return `${params.name}<br/>` +
              `最小值: ${data[0].toFixed(2)}%<br/>` +
              `Q1: ${data[1].toFixed(2)}%<br/>` +
              `中位数: ${data[2].toFixed(2)}%<br/>` +
              `Q3: ${data[3].toFixed(2)}%<br/>` +
              `最大值: ${data[4].toFixed(2)}%`
          } else if (params.seriesType === 'scatter') {
            return `${params.seriesName}<br/>` +
              `学生: ${params.data[0]}<br/>` +
              `达成度: ${params.data[1].toFixed(2)}%`
          }
          return ''
        }
      },
      legend: {
        data: ['课程目标1', '课程目标2', '课程目标3', '课程目标4'],
        top: 10
      },
      xAxis: {
        type: 'category',
        data: ['课程目标1', '课程目标2', '课程目标3', '课程目标4'],
        boundaryGap: true,
        nameGap: 30,
        splitArea: {
          show: false
        },
        splitLine: {
          show: false
        }
      },
      yAxis: {
        type: 'value',
        name: '达成度(%)',
        min: 0,
        max: 100,
        splitArea: {
          show: true
        }
      },
      series: [
        {
          name: '课程目标1',
          type: 'boxplot',
          data: [
            boxplotData1,
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0]
          ],
          itemStyle: {
            color: '#409EFF',
            borderColor: '#1f77b4'
          }
        },
        {
          name: '课程目标2',
          type: 'boxplot',
          data: [
            [0, 0, 0, 0, 0],
            boxplotData2,
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0]
          ],
          itemStyle: {
            color: '#67C23A',
            borderColor: '#2ca02c'
          }
        },
        {
          name: '课程目标3',
          type: 'boxplot',
          data: [
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            boxplotData3,
            [0, 0, 0, 0, 0]
          ],
          itemStyle: {
            color: '#E6A23C',
            borderColor: '#ff7f0e'
          }
        },
        {
          name: '课程目标4',
          type: 'boxplot',
          data: [
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            boxplotData4
          ],
          itemStyle: {
            color: '#F56C6C',
            borderColor: '#d62728'
          }
        },
        // 添加散点图显示所有数据点
        {
          name: '课程目标1数据点',
          type: 'scatter',
          data: obj1Degrees.map((degree, index) => [0, degree]),
          symbolSize: 6,
          itemStyle: {
            color: '#409EFF',
            opacity: 0.6
          }
        },
        {
          name: '课程目标2数据点',
          type: 'scatter',
          data: obj2Degrees.map((degree, index) => [1, degree]),
          symbolSize: 6,
          itemStyle: {
            color: '#67C23A',
            opacity: 0.6
          }
        },
        {
          name: '课程目标3数据点',
          type: 'scatter',
          data: obj3Degrees.map((degree, index) => [2, degree]),
          symbolSize: 6,
          itemStyle: {
            color: '#E6A23C',
            opacity: 0.6
          }
        },
        {
          name: '课程目标4数据点',
          type: 'scatter',
          data: obj4Degrees.map((degree, index) => [3, degree]),
          symbolSize: 6,
          itemStyle: {
            color: '#F56C6C',
            opacity: 0.6
          }
        }
      ]
    }
    
    objectiveChartInstance.setOption(option2)
    console.log('renderCharts: objectiveChart option set')
  } catch (error) {
    console.error('renderCharts: Failed to init objectiveChart:', error)
    return
  }
}

onMounted(async () => {
  try {
    const response = await getDashboard()
    dashboardData.value = response
    await loadClassesWithScores()
  } catch (error) {
    ElMessage.error('加载仪表盘数据失败')
    console.error(error)
  }
})

// 窗口大小改变时重新渲染图表
window.addEventListener('resize', () => {
  gradeDistributionChartInstance?.resize()
  objectiveChartInstance?.resize()
})
</script>

<style scoped>
.dashboard {
  padding: 20px;
}

.stat-card {
  margin-bottom: 20px;
}

.stat-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  min-height: 80px;
}

.stat-left {
  display: flex;
  align-items: center;
  flex: 1;
}

.stat-detail {
  flex: 1;
  margin-left: 20px;
  padding-left: 20px;
  border-left: 1px solid #ebeef5;
  display: flex;
  flex-direction: column;
  gap: 8px;
  justify-content: center;
}

.stat-detail-item {
  display: flex;
  align-items: center;
  font-size: 16px;
  line-height: 1.8;
  min-height: 28px;
}

.detail-label {
  font-weight: 600;
  color: #303133;
  margin-right: 8px;
  font-size: 16px;
}

.detail-value {
  font-weight: 600;
  color: #606266;
  font-size: 16px;
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  margin-right: 15px;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 24px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 5px;
}

.stat-label {
  font-size: 14px;
  color: #909399;
}

.chart-container {
  padding: 10px;
}

.chart-container h3 {
  margin: 0 0 15px 0;
  font-size: 16px;
  font-weight: 600;
  color: #303133;
  text-align: center;
}
</style>

