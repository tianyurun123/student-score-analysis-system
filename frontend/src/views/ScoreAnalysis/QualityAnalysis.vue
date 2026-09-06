<template>
  <div class="quality-analysis">
    <div class="page-header">
      <h1 class="page-title">质量分析</h1>
      <div class="page-actions">

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
              v-for="cls in graphicsClasses"
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

        <!-- 图形学课程的质量分析（单一文本框） -->
        <div>
          <el-input
            v-model="analysisTexts.graphics_analysis"
            type="textarea"
            :rows="12"
            placeholder="请输入考试质量分析内容..."
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

    <el-empty v-else description="请选择图形学课程班级查看质量分析数据" />
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Download } from '@element-plus/icons-vue'
import { getGraphicsClasses, getScores } from '@/api/scores'
import { getClass } from '@/api/courses'
import { exportQualityAnalysis } from '@/api/analysis'

const loading = ref(false)
const graphicsClasses = ref([])
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

const isGraphicsCourse = computed(() => {
  if (!searchForm.course_class_id) return false
  const selectedClass = graphicsClasses.value.find(
    cls => cls.id === searchForm.course_class_id
  )
  return selectedClass?.course_name?.includes('图形学') || false
})

const analysisTexts = reactive({
  group_opinion: '',
  signer: '',
  sign_date: '',
  graphics_analysis: ''
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
    .map(s => s.final_grade)
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
    .map(s => s.final_grade)
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
  await loadGraphicsClasses()
})

const loadGraphicsClasses = async () => {
  try {
    const response = await getGraphicsClasses()
    graphicsClasses.value = response.results || response.data || []
  } catch (error) {
    ElMessage.error('加载图形学班级列表失败')
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
    let classDetail = null
    try {
      classDetail = await getClass(searchForm.course_class_id)
    } catch (error) {
      console.warn('获取班级详情失败，使用默认值:', error)
    }

    const selectedClass = graphicsClasses.value.find(
      cls => cls.id === searchForm.course_class_id
    )

    await loadGraphicsCourseData(selectedClass, classDetail)
  } catch (error) {
    ElMessage.error('加载数据失败: ' + (error.response?.data?.error || error.message))
    console.error(error)
    analysisData.value = null
  } finally {
    loading.value = false
  }
}

const loadGraphicsCourseData = async (selectedClass, classDetail) => {
  // 获取图形学成绩数据（处理分页）
  let allScores = []
  let page = 1
  let hasMore = true

  while (hasMore) {
    const response = await getScores({
      course_class_id: searchForm.course_class_id,
      page_size: 1000,
      page: page
    })

    if (response.results) {
      allScores = allScores.concat(response.results)
      hasMore = response.next !== null
      page++
    } else if (response.data) {
      allScores = allScores.concat(response.data)
      hasMore = false
    } else if (Array.isArray(response)) {
      allScores = allScores.concat(response)
      hasMore = false
    } else {
      hasMore = false
    }
  }

  if (!allScores || allScores.length === 0) {
    analysisData.value = null
    ElMessage.warning('该班级暂无成绩数据')
    return
  }

  // 填充基本信息
  basicInfo.course_name = selectedClass?.course_name || ''
  basicInfo.class_name = selectedClass?.class_name || ''
  basicInfo.exam_count = allScores.length

  if (classDetail) {
    basicInfo.teacher_name = classDetail.main_teacher_name || (classDetail.main_teacher?.first_name || classDetail.main_teacher?.username || '')
    basicInfo.department = classDetail.course_department || ''
    basicInfo.hours = classDetail.course_hours || ''
  }

  // 计算成绩分布
  const finalGrades = allScores.map(s => s.final_grade).filter(s => s !== null && s !== undefined)
  const passCount = finalGrades.filter(s => s >= 60).length
  const failCount = finalGrades.filter(s => s < 60).length
  const excellentCount = finalGrades.filter(s => s >= 90).length
  const goodCount = finalGrades.filter(s => s >= 80 && s < 90).length
  const mediumCount = finalGrades.filter(s => s >= 70 && s < 80).length

  // 生成图形学课程默认分析文本
  analysisTexts.graphics_analysis = `班级课程考查过程分析，教学过程分析，课程教学效果，改进本课程教学的措施和意见等方面。本次考试的期末成绩由两个部分组成，分别为综合实验报告和小型绘图系统验收，各占50%的总成绩。学生需要在该系统中综合运用造型技术、用户接口技术、真实感技术等知识点，设计一个具备基本功能的绘图系统，并能独立分析、设计解决图形设计中的复杂问题。同时，还要掌握计算机图形学的原理，将理论知识与软件开发能力结合。考试涉及到的算法有基本的图形绘制算法、二维复合变换、三种工程自由曲线的绘制等，其中难度较高的是剪裁和填充算法。学生普遍能够实现多级菜单功能、鼠标和对话框的交互功能较弱，个别同学在实验报告中存在算法设计原理功能图错误、概念条理性弱问题。最终成绩为及格${passCount}人，中等成绩${mediumCount}人，良好成绩${goodCount}人，优秀成绩${excellentCount}人。获得优良成绩的学生在鼠标交互填充的部分实现较好。个别同学在编写实验报告存在书写凌乱问题。本轮教学改进:（1）针对学生算法编程能力弱的问题，在课堂上给学生讲解了多个案例教学。不论从系统实现还是最后的总结报告来看，都收到了一定的效果。（2）针对报告编写规范问题，本轮教学中，详细讲解了优秀报告模板，严格要求学生按照撰写规范完成大作业报告提交，加深学生对计算机图形学原理的理解。`

  // 提取成绩数据
  analysisData.value = {
    course_name: basicInfo.course_name,
    class_name: basicInfo.class_name,
    students: allScores.map(score => ({
      student_id: score.student_id,
      student_name: score.student_name,
      final_grade: score.final_grade
    }))
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
      is_graphics_course: isGraphicsCourse.value,
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
        sign_date: analysisTexts.sign_date,
        graphics_analysis: analysisTexts.graphics_analysis
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
