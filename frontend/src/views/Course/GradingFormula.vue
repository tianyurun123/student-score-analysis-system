<template>
  <div class="grading-formula">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>成绩计算公式配置</span>
          <el-button type="primary" @click="handleSave" :loading="saving">
            保存配置
          </el-button>
        </div>
      </template>

      <el-form :model="formulaForm" label-width="150px">
        <el-alert
          title="公式说明"
          type="info"
          :closable="false"
          style="margin-bottom: 20px"
        >
          <p>1. 公式支持变量名（如：点名、电子笔记、作业成绩、作品、报告等）</p>
          <p>2. 支持基本数学运算：+、-、*、/、()</p>
          <p>3. 示例：平时成绩=（点名*0.05+电子笔记*0.05+作业成绩*0.1）/0.2</p>
          <p>4. 示例：期末平均=（作品+报告）/2</p>
        </el-alert>

        <el-form-item label="课程">
          <el-select
            v-model="formulaForm.course_id"
            placeholder="请选择课程"
            filterable
            style="width: 100%"
            @change="handleCourseChange"
          >
            <el-option
              v-for="course in courses"
              :key="course.id"
              :label="`${course.course_code} - ${course.course_name}`"
              :value="course.id"
            />
          </el-select>
        </el-form-item>

        <el-divider />

        <el-form-item label="平时成绩公式">
          <el-input
            v-model="formulaForm.usual_formula"
            type="textarea"
            :rows="3"
            placeholder="例如：(点名*0.05+电子笔记*0.05+作业成绩*0.1)/0.2"
          />
          <div class="formula-help">
            <p>可用变量：{{ availableVariables.join('、') }}</p>
            <p v-if="formulaForm.usual_formula" class="formula-preview">
              公式预览：{{ formulaForm.usual_formula }}
            </p>
          </div>
        </el-form-item>

        <el-form-item label="期末成绩公式">
          <el-input
            v-model="formulaForm.final_formula"
            type="textarea"
            :rows="3"
            placeholder="例如：(作品+报告)/2"
          />
          <div class="formula-help">
            <p>可用变量：{{ availableVariables.join('、') }}</p>
            <p v-if="formulaForm.final_formula" class="formula-preview">
              公式预览：{{ formulaForm.final_formula }}
            </p>
          </div>
        </el-form-item>

        <el-form-item label="成绩权重">
          <el-row :gutter="20">
            <el-col :span="12">
              <el-input-number
                v-model="formulaForm.usual_weight"
                :min="0"
                :max="1"
                :step="0.1"
                :precision="2"
                style="width: 100%"
              />
              <div class="weight-label">平时成绩权重</div>
            </el-col>
            <el-col :span="12">
              <el-input-number
                v-model="formulaForm.final_weight"
                :min="0"
                :max="1"
                :step="0.1"
                :precision="2"
                style="width: 100%"
              />
              <div class="weight-label">期末成绩权重</div>
            </el-col>
          </el-row>
          <div class="weight-tip">
            <p>权重总和应为 1.0（当前：{{ (formulaForm.usual_weight + formulaForm.final_weight).toFixed(2) }}）</p>
          </div>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="handleTestFormula">测试公式</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 测试结果对话框 -->
      <el-dialog v-model="testDialogVisible" title="公式测试结果" width="600px">
        <el-form label-width="120px">
          <el-form-item
            v-for="(value, key) in testData"
            :key="key"
            :label="key"
          >
            <el-input-number
              v-model="testData[key]"
              :min="0"
              :max="100"
              :precision="1"
              style="width: 100%"
            />
          </el-form-item>
        </el-form>
        <el-divider />
        <div class="test-result">
          <p><strong>平时成绩：</strong>{{ testResult.usual_score.toFixed(2) }}</p>
          <p><strong>期末成绩：</strong>{{ testResult.final_score.toFixed(2) }}</p>
          <p><strong>最终成绩：</strong>{{ testResult.total_score.toFixed(2) }}</p>
        </div>
        <template #footer>
          <el-button @click="testDialogVisible = false">关闭</el-button>
        </template>
      </el-dialog>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { getCourses } from '@/api/courses'
import { getGradingPolicies, setGradingFormula } from '@/api/courses'

const saving = ref(false)
const courses = ref([])
const testDialogVisible = ref(false)
const policyId = ref(null)

const formulaForm = reactive({
  course_id: null,
  usual_formula: '',
  final_formula: '',
  usual_weight: 0.3,
  final_weight: 0.7
})

const testData = reactive({
  点名: 90,
  电子笔记: 85,
  作业成绩: 88,
  作品: 85,
  报告: 90
})

const testResult = reactive({
  usual_score: 0,
  final_score: 0,
  total_score: 0
})

const availableVariables = computed(() => {
  return ['点名', '考勤', '电子笔记', '作业成绩', '作业', '实验', '复习笔记', '作品', '报告', '期末']
})

onMounted(async () => {
  await loadCourses()
})

const loadCourses = async () => {
  try {
    const response = await getCourses()
    courses.value = response.results || response
  } catch (error) {
    ElMessage.error('加载课程列表失败')
  }
}

const handleCourseChange = async (courseId) => {
  if (!courseId) return
  
  try {
    const response = await getGradingPolicies({ course_id: courseId })
    if (response.results && response.results.length > 0) {
      const policy = response.results[0]
      policyId.value = policy.id
      formulaForm.usual_weight = policy.usual_weight
      formulaForm.final_weight = policy.final_weight
      
      if (policy.grading_scale) {
        formulaForm.usual_formula = policy.grading_scale.usual_formula || ''
        formulaForm.final_formula = policy.grading_scale.final_formula || ''
      }
    } else {
      policyId.value = null
      ElMessage.warning('该课程尚未配置评分政策，请先创建评分政策')
    }
  } catch (error) {
    ElMessage.error('加载评分政策失败')
  }
}

const handleSave = async () => {
  if (!formulaForm.course_id) {
    ElMessage.warning('请选择课程')
    return
  }
  
  if (!policyId.value) {
    ElMessage.warning('请先创建评分政策')
    return
  }

  // 验证权重
  const totalWeight = formulaForm.usual_weight + formulaForm.final_weight
  if (Math.abs(totalWeight - 1.0) > 0.01) {
    ElMessage.warning('权重总和应为 1.0')
    return
  }

  saving.value = true
  try {
    await setGradingFormula(policyId.value, {
      usual_formula: formulaForm.usual_formula,
      final_formula: formulaForm.final_formula
    })
    ElMessage.success('保存成功，已重新计算所有成绩')
  } catch (error) {
    ElMessage.error('保存失败')
  } finally {
    saving.value = false
  }
}

const handleTestFormula = () => {
  testDialogVisible.value = true
  calculateTestResult()
}

const calculateTestResult = () => {
  // 计算平时成绩
  if (formulaForm.usual_formula) {
    testResult.usual_score = calculateWithFormula(testData, formulaForm.usual_formula)
  } else {
    testResult.usual_score = 0
  }

  // 计算期末成绩
  if (formulaForm.final_formula) {
    testResult.final_score = calculateWithFormula(testData, formulaForm.final_formula)
  } else {
    testResult.final_score = 0
  }

  // 计算总成绩
  testResult.total_score = testResult.usual_score * formulaForm.usual_weight + 
                          testResult.final_score * formulaForm.final_weight
}

const calculateWithFormula = (data, formula) => {
  try {
    let formulaCopy = formula.replace(/\s/g, '')
    const sortedVars = Object.keys(data).sort((a, b) => b.length - a.length)
    
    for (const varName of sortedVars) {
      const value = data[varName] || 0
      formulaCopy = formulaCopy.replace(new RegExp(varName, 'g'), String(value))
    }
    
    // 检查是否还有未替换的变量
    const remainingVars = formulaCopy.match(/[\u4e00-\u9fa5a-zA-Z_]+/g)
    if (remainingVars) {
      for (const variable of remainingVars) {
        formulaCopy = formulaCopy.replace(new RegExp(variable, 'g'), '0')
      }
    }

    return eval(formulaCopy) || 0
  } catch (error) {
    console.error('公式计算错误:', error)
    return 0
  }
}

const handleReset = () => {
  formulaForm.usual_formula = ''
  formulaForm.final_formula = ''
  formulaForm.usual_weight = 0.3
  formulaForm.final_weight = 0.7
}

// 监听测试数据变化
watch(() => testData, () => {
  calculateTestResult()
}, { deep: true })
</script>

<style scoped>
.grading-formula {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.formula-help {
  margin-top: 10px;
  font-size: 12px;
  color: #909399;
}

.formula-preview {
  margin-top: 5px;
  padding: 5px;
  background-color: #f5f7fa;
  border-radius: 4px;
}

.weight-label {
  margin-top: 5px;
  font-size: 12px;
  color: #909399;
  text-align: center;
}

.weight-tip {
  margin-top: 10px;
  font-size: 12px;
  color: #909399;
}

.test-result {
  padding: 15px;
  background-color: #f5f7fa;
  border-radius: 4px;
}

.test-result p {
  margin: 10px 0;
  font-size: 14px;
}
</style>