<template>
  <div class="quality-analysis">
    <div class="page-header">
      <h1 class="page-title">质量分析</h1>
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
            placeholder="请选择算法课程班级"
            filterable
            style="width: 300px"
            @change="handleSearch"
          >
            <el-option
              v-for="cls in algorithmClasses"
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
          <el-descriptions-item label="教师姓名">
            <el-input v-model="basicInfo.teacher_name" style="width: 100%" />
          </el-descriptions-item>
          <el-descriptions-item label="所在院(系)">{{ basicInfo.department }}</el-descriptions-item>
          <el-descriptions-item label="授课班级">{{ basicInfo.class_name }}</el-descriptions-item>
          <el-descriptions-item label="课程学时">{{ basicInfo.hours }}</el-descriptions-item>
          <el-descriptions-item label="考试人数">{{ basicInfo.exam_count }}</el-descriptions-item>
          <el-descriptions-item label="考试性质">{{ basicInfo.exam_nature }}</el-descriptions-item>
          <el-descriptions-item label="考试方法">{{ basicInfo.exam_method }}</el-descriptions-item>
          <el-descriptions-item label="考试时间">
            <el-date-picker
              v-model="basicInfo.exam_date"
              type="date"
              format="YYYY.M.D"
              value-format="YYYY.M.D"
              placeholder="选择考试时间"
              style="width: 100%"
            />
          </el-descriptions-item>
          <el-descriptions-item label="试题来源" :span="3">{{ basicInfo.question_source }}</el-descriptions-item>
        </el-descriptions>
      </el-card>

      <!-- 考试成绩分布 -->
      <el-card style="margin-top: 20px">
        <template #header>
          <span>考试成绩分布</span>
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

      <!-- 考试质量分析 -->
      <el-card style="margin-top: 20px">
        <template #header>
          <span>考试质量分析</span>
        </template>
        
        <!-- 试题质量分析 -->
        <div style="margin-bottom: 25px;">
          <div style="font-weight: 600; margin-bottom: 10px; font-size: 16px;">试题质量分析</div>
          <el-input
            v-model="analysisTexts.question_quality"
            type="textarea"
            :rows="5"
            placeholder="请输入试题质量分析内容..."
          />
        </div>

        <!-- 考试(卷面)成绩分析 -->
        <div style="margin-bottom: 25px;">
          <div style="font-weight: 600; margin-bottom: 10px; font-size: 16px;">考试(卷面)成绩分析</div>
          <el-input
            v-model="analysisTexts.exam_score_analysis"
            type="textarea"
            :rows="5"
            placeholder="请输入考试(卷面)成绩分析内容..."
          />
        </div>

        <!-- 教学效果分析及改进措施 -->
        <div>
          <div style="font-weight: 600; margin-bottom: 10px; font-size: 16px;">教学效果分析及改进措施</div>
          <el-input
            v-model="analysisTexts.teaching_effectiveness"
            type="textarea"
            :rows="5"
            placeholder="请输入教学效果分析及改进措施..."
          />
        </div>
      </el-card>

      <!-- 评价工作小组意见 -->
      <el-card style="margin-top: 20px">
        <template #header>
          <span>评价工作小组意见</span>
        </template>
        <el-input
          v-model="analysisTexts.group_opinion"
          type="textarea"
          :rows="4"
          placeholder="请输入评价工作小组意见..."
        />
        <div style="margin-top: 20px; display: flex; justify-content: space-between;">
          <div>
            <strong>负责人签字：</strong>
            <el-input v-model="analysisTexts.signer" style="width: 200px; margin-left: 10px;" placeholder="请输入负责人姓名" />
          </div>
          <div>
            <strong>日期：</strong>
            <el-date-picker
              v-model="analysisTexts.sign_date"
              type="date"
              format="YYYY年M月D日"
              value-format="YYYY年M月D日"
              placeholder="选择日期"
              style="margin-left: 10px;"
            />
          </div>
        </div>
      </el-card>
    </div>

    <el-empty v-else description="请选择算法课程班级查看质量分析数据" />
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Download } from '@element-plus/icons-vue'
import { getClassesWithAlgorithmScores, getAlgorithmScores } from '@/api/scores'
import { getClass } from '@/api/courses'
import { exportQualityAnalysis } from '@/api/analysis'

const loading = ref(false)
const algorithmClasses = ref([])
const analysisData = ref(null)

const searchForm = reactive({
  course_class_id: null
})

const basicInfo = reactive({
  course_name: '',
  teacher_name: '',
  department: '',
  class_name: '',
  hours: '',
  exam_count: 0,
  exam_nature: '考试',
  exam_method: '闭卷',
  exam_date: '',
  question_source: '自主命题'
})

const analysisTexts = reactive({
  question_quality: '本次考试试题包括填空题、分析讨论题、算法理解题、算法分析与设计题等，考查了学生对基本概念、原理和方法的理解，对算法分析与设计的规范化方法掌握情况，以及对算法原理的综合分析和实现能力。试题符合教学大纲要求，涵盖了教学计划中所有章节的知识点，题量和难度适中。',
  exam_score_analysis: '成绩分布显示班级最高分93分，最低分40分，优秀3人，良好4人，中等7人，及格8人，不及格5人，平均分69.41分。算法理解题得分率较高，其次是填空题，最后是分析讨论题和算法分析与设计题。这表明学生在面对具体应用性题目时，具有良好的分析视角和实践设计能力，但对分析设计能力的掌握还需要加强。总体来说，教学目标的达成情况良好。',
  teaching_effectiveness: '结合课堂状态、实验实训和作业反馈的综合情况，学生在课堂上注意力集中，按时提交作业，按时完成实践作业。通过本课程的系统学习，学生基本掌握了算法分析与设计的基本概念、核心原理和常用方法，同时也具备了算法综合分析能力和实际实现能力，达到了教学大纲中对课程的基本要求。结合本次考试试卷答题情况分析，学生失分的核心原因在于对分析设计能力的掌握较弱。今后有必要重点加强对知识回忆能力和综合分析能力的培养。',
  group_opinion: '',
  signer: '',
  sign_date: ''
})

// 计算成绩分布表（三行格式）
const scoreDistributionTableData = computed(() => {
  if (!analysisData.value || !analysisData.value.students || analysisData.value.students.length === 0) {
    return [
      { label: '分数段', 不及格: '0~59', 及格: '60~69', 中等: '70~79', 良好: '80~89', 优秀: '90~100' },
      { label: '学生数', 不及格: '0', 及格: '0', 中等: '0', 良好: '0', 优秀: '0' },
      { label: '占总人数比例(%)', 不及格: '0.00', 及格: '0.00', 中等: '0.00', 良好: '0.00', 优秀: '0.00' }
    ]
  }

  const scores = analysisData.value.students
    .map(s => s.final_paper_score)
    .filter(s => s !== null && s !== undefined)
    .map(s => parseFloat(s))

  if (scores.length === 0) {
    return [
      { label: '分数段', 不及格: '0~59', 及格: '60~69', 中等: '70~79', 良好: '80~89', 优秀: '90~100' },
      { label: '学生数', 不及格: '0', 及格: '0', 中等: '0', 良好: '0', 优秀: '0' },
      { label: '占总人数比例(%)', 不及格: '0.00', 及格: '0.00', 中等: '0.00', 良好: '0.00', 优秀: '0.00' }
    ]
  }

  const total = scores.length

  const ranges = [
    { label: '不及格', min: 0, max: 59 },
    { label: '及格', min: 60, max: 69 },
    { label: '中等', min: 70, max: 79 },
    { label: '良好', min: 80, max: 89 },
    { label: '优秀', min: 90, max: 100 }
  ]

  const counts = {}
  const percentages = {}
  
  ranges.forEach(range => {
    const count = scores.filter(s => s >= range.min && s <= range.max).length
    counts[range.label] = count
    percentages[range.label] = ((count / total) * 100).toFixed(2)
  })

  return [
    { label: '分数段', 不及格: '0~59', 及格: '60~69', 中等: '70~79', 良好: '80~89', 优秀: '90~100' },
    { label: '学生数', 不及格: counts.不及格.toString(), 及格: counts.及格.toString(), 中等: counts.中等.toString(), 良好: counts.良好.toString(), 优秀: counts.优秀.toString() },
    { label: '占总人数比例(%)', 不及格: percentages.不及格, 及格: percentages.及格, 中等: percentages.中等, 良好: percentages.良好, 优秀: percentages.优秀 }
  ]
})

// 计算统计信息
const statistics = computed(() => {
  if (!analysisData.value || !analysisData.value.students || analysisData.value.students.length === 0) {
    return { max_score: 0, min_score: 0, avg_score: 0, std_dev: 0 }
  }

  const scores = analysisData.value.students
    .map(s => s.final_paper_score)
    .filter(s => s !== null && s !== undefined)
    .map(s => parseFloat(s))

  if (scores.length === 0) {
    return { max_score: 0, min_score: 0, avg_score: 0, std_dev: 0 }
  }

  const max = Math.max(...scores)
  const min = Math.min(...scores)
  const avg = scores.reduce((a, b) => a + b, 0) / scores.length
  
  // 计算标准差
  const variance = scores.reduce((sum, score) => sum + Math.pow(score - avg, 2), 0) / scores.length
  const stdDev = Math.sqrt(variance)

  return {
    max_score: max,
    min_score: min,
    avg_score: avg,
    std_dev: stdDev
  }
})

onMounted(async () => {
  await loadAlgorithmClasses()
})

const loadAlgorithmClasses = async () => {
  try {
    const response = await getClassesWithAlgorithmScores()
    algorithmClasses.value = response.results || response.data || []
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
    // 获取课程班级详细信息
    let classDetail = null
    try {
      classDetail = await getClass(searchForm.course_class_id)
    } catch (error) {
      console.warn('获取班级详情失败，使用默认值:', error)
    }

    // 直接调用算法成绩接口获取步骤三的数据
    // 传递大的page_size以获取所有数据（质量分析需要获取全部学生成绩）
    const response = await getAlgorithmScores({
      course_class_id: searchForm.course_class_id,
      page_size: 1000,  // 设置足够大的值以获取所有数据
      page: 1
    })
    
    // 处理分页响应
    let scores = []
    if (response.results) {
      // 分页响应格式：{count, next, previous, results}
      scores = response.results
      const totalCount = response.count || scores.length
      let nextUrl = response.next
      
      // 如果有更多页面，继续获取所有数据
      let currentPage = 1
      while (nextUrl && scores.length < totalCount) {
        currentPage++
        try {
          const nextResponse = await getAlgorithmScores({
            course_class_id: searchForm.course_class_id,
            page_size: 1000,
            page: currentPage
          })
          if (nextResponse.results && nextResponse.results.length > 0) {
            scores = scores.concat(nextResponse.results)
            nextUrl = nextResponse.next
            if (!nextUrl) break
          } else {
            break
          }
        } catch (error) {
          console.warn('获取下一页数据失败:', error)
          break
        }
      }
    } else if (response.data) {
      // 直接数据响应
      scores = response.data
    } else if (Array.isArray(response)) {
      // 数组响应
      scores = response
    }
    
    if (!scores || scores.length === 0) {
      analysisData.value = null
      ElMessage.warning('该班级暂无成绩数据')
      return
    }

    // 获取课程和班级信息
    const selectedClass = algorithmClasses.value.find(cls => cls.id === searchForm.course_class_id)
    const firstScore = scores[0]
    
    // 填充基本信息
    basicInfo.course_name = selectedClass?.course_name || firstScore?.course_name || ''
    basicInfo.class_name = selectedClass?.class_name || firstScore?.class_name || ''
    basicInfo.exam_count = scores.length
    
    // 从班级详情获取更多信息
    if (classDetail) {
      basicInfo.teacher_name = classDetail.main_teacher_name || (classDetail.main_teacher?.first_name || classDetail.main_teacher?.username || '')
      // 从序列化器中获取课程信息
      basicInfo.department = classDetail.course_department || ''
      basicInfo.hours = classDetail.course_hours || ''
    }
    
    // 提取卷面成绩数据（M1, M2, M3, M4, final_paper_score）
    analysisData.value = {
      course_name: basicInfo.course_name,
      class_name: basicInfo.class_name,
      students: scores.map(score => ({
        student_id: score.student_id,
        student_name: score.student_name,
        M1: score.M1,
        M2: score.M2,
        M3: score.M3,
        M4: score.M4,
        final_paper_score: score.final_paper_score
      }))
    }
  } catch (error) {
    ElMessage.error('加载数据失败: ' + (error.response?.data?.error || error.message))
    console.error(error)
    analysisData.value = null
  } finally {
    loading.value = false
  }
}

const handleExport = async () => {
  if (!analysisData.value || !searchForm.course_class_id) {
    ElMessage.warning('请先加载数据')
    return
  }

  try {
    // 准备导出数据
    const exportData = {
      course_class_id: searchForm.course_class_id,
      basic_info: {
        course_name: basicInfo.course_name,
        teacher_name: basicInfo.teacher_name,
        department: basicInfo.department,
        class_name: basicInfo.class_name,
        hours: basicInfo.hours,
        exam_count: basicInfo.exam_count,
        exam_nature: basicInfo.exam_nature,
        exam_method: basicInfo.exam_method,
        exam_date: basicInfo.exam_date,
        question_source: basicInfo.question_source
      },
      analysis_texts: {
        question_quality: analysisTexts.question_quality,
        exam_score_analysis: analysisTexts.exam_score_analysis,
        teaching_effectiveness: analysisTexts.teaching_effectiveness,
        group_opinion: analysisTexts.group_opinion,
        signer: analysisTexts.signer,
        sign_date: analysisTexts.sign_date
      }
    }

    // 调用导出API
    const response = await exportQualityAnalysis(exportData)
    
    // 创建下载链接
    const blob = new Blob([response], {
      type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    })
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    
    // 设置文件名
    const filename = `${basicInfo.course_name}_${basicInfo.class_name}_质量分析.docx`
    link.setAttribute('download', filename)
    
    // 触发下载
    document.body.appendChild(link)
    link.click()
    
    // 清理
    document.body.removeChild(link)
    window.URL.revokeObjectURL(url)
    
    ElMessage.success('导出成功')
  } catch (error) {
    ElMessage.error('导出失败: ' + (error.response?.data?.error || error.message))
    console.error(error)
  }
}
</script>

<style scoped>
.quality-analysis {
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
