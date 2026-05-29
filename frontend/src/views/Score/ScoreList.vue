<template>
  <div class="score-list">
    <div class="page-header">
      <h1 class="page-title">图形学成绩管理</h1>
      <div class="page-actions">
        <el-button type="warning" @click="handleOpenConfig">
          <el-icon><Setting /></el-icon>
          配置公式
        </el-button>
        <el-button type="primary" @click="$router.push('/scores/gradebook-import')">
          <el-icon><Upload /></el-icon>
          导入记分册
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

          <!-- 平时表现 -->
          <el-table-column label="平时表现" align="center">
            <el-table-column prop="attendance_score" label="点名" width="80" />
            <el-table-column label="电子笔记" width="100">
              <template #default="{ row }">
                {{ row.extra_scores && row.extra_scores['电子笔记'] ? row.extra_scores['电子笔记'].toFixed(1) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="homework_score" label="作业成绩" width="100" />
          </el-table-column>

          <!-- 期末 -->
          <el-table-column label="期末" align="center">
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
            <el-table-column prop="final_total" label="期末成绩" width="100">
              <template #default="{ row }">
                {{ row.final_total !== null && row.final_total !== undefined ? Math.floor(row.final_total) : '-' }}
              </template>
            </el-table-column>
          </el-table-column>

          <!-- 原始成绩列（保留平时成绩和实验） -->
          <el-table-column prop="usual_total" label="平时成绩" width="100">
            <template #default="{ row }">
              {{ row.usual_total ? Math.round(row.usual_total) : '-' }}
            </template>
          </el-table-column>
          <el-table-column prop="experiment_score" label="实验" width="80" />

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

    <!-- 配置公式对话框 -->
    <el-dialog
      v-model="configDialogVisible"
      title="课程目标计算公式配置"
      width="900px"
      :close-on-click-modal="false"
    >
      <div style="margin-bottom: 20px">
        <el-select
          v-model="configCourseClassId"
          placeholder="请选择班级"
          filterable
          @change="handleConfigClassChange"
          style="width: 300px"
        >
          <el-option
            v-for="cls in allClasses"
            :key="cls.id"
            :label="`${cls.course_name} - ${cls.class_name}`"
            :value="cls.id"
          />
        </el-select>
        <span v-if="configCourseClassId" style="margin-left: 10px; color: #67c23a">
          已选择班级，可编辑公式配置
        </span>
      </div>

      <el-tabs v-model="configActiveTab" :disabled="!configCourseClassId">
        <el-tab-pane label="平时成绩公式" name="usual">
          <el-card shadow="never">
            <el-form label-width="150px">
              <el-form-item label="点名权重">
                <el-input-number v-model="configData.usual_score_formula.attendance_weight" :min="0" :max="1" :step="0.01" :precision="2" />
                <span class="formula-hint">（当前: {{ configData.usual_score_formula.attendance_weight }}）</span>
              </el-form-item>
              <el-form-item label="电子笔记权重">
                <el-input-number v-model="configData.usual_score_formula.e_notes_weight" :min="0" :max="1" :step="0.01" :precision="2" />
                <span class="formula-hint">（当前: {{ configData.usual_score_formula.e_notes_weight }}）</span>
              </el-form-item>
              <el-form-item label="作业成绩权重">
                <el-input-number v-model="configData.usual_score_formula.homework_weight" :min="0" :max="1" :step="0.01" :precision="2" />
                <span class="formula-hint">（当前: {{ configData.usual_score_formula.homework_weight }}）</span>
              </el-form-item>
              <el-form-item label="总权重">
                <el-input-number v-model="configData.usual_score_formula.total_weight" :min="0.01" :max="1" :step="0.01" :precision="2" />
                <span class="formula-hint">（用于归一化，当前: {{ configData.usual_score_formula.total_weight }}）</span>
              </el-form-item>
              <el-alert type="info" :closable="false" style="margin-top: 10px">
                <template #title>
                  计算公式: 平时成绩 = (点名 × {{ configData.usual_score_formula.attendance_weight }} + 电子笔记 × {{ configData.usual_score_formula.e_notes_weight }} + 作业成绩 × {{ configData.usual_score_formula.homework_weight }}) / {{ configData.usual_score_formula.total_weight }}
                </template>
              </el-alert>
            </el-form>
          </el-card>
        </el-tab-pane>
        
        <el-tab-pane label="期末成绩公式" name="final">
          <el-card shadow="never">
            <template v-if="isGraphicsCourse">
              <el-alert type="success" :closable="false">
                <template #title>
                  图形学课程期末成绩公式：<strong>期末成绩 = (作品 + 报告) / 2</strong>
                </template>
                此公式由记分册导入数据直接计算，无需配置。
              </el-alert>
            </template>
            <el-form v-else label-width="150px">
              <el-form-item label="实验权重">
                <el-input-number v-model="configData.final_score_formula.experiment_weight" :min="0" :max="1" :step="0.01" :precision="2" />
                <span class="formula-hint">（当前: {{ configData.final_score_formula.experiment_weight }}）</span>
              </el-form-item>
              <el-form-item label="作品权重">
                <el-input-number v-model="configData.final_score_formula.work_weight" :min="0" :max="1" :step="0.01" :precision="2" />
                <span class="formula-hint">（当前: {{ configData.final_score_formula.work_weight }}）</span>
              </el-form-item>
              <el-form-item label="报告权重">
                <el-input-number v-model="configData.final_score_formula.report_weight" :min="0" :max="1" :step="0.01" :precision="2" />
                <span class="formula-hint">（当前: {{ configData.final_score_formula.report_weight }}）</span>
              </el-form-item>
              <el-form-item label="总权重">
                <el-input-number v-model="configData.final_score_formula.total_weight" :min="0.01" :max="1" :step="0.01" :precision="2" />
                <span class="formula-hint">（用于归一化，当前: {{ configData.final_score_formula.total_weight }}）</span>
              </el-form-item>
              <el-alert type="info" :closable="false" style="margin-top: 10px">
                <template #title>
                  计算公式: 期末成绩 = (实验 × {{ configData.final_score_formula.experiment_weight }} + 作品 × {{ configData.final_score_formula.work_weight }} + 报告 × {{ configData.final_score_formula.report_weight }}) / {{ configData.final_score_formula.total_weight }}
                </template>
              </el-alert>
            </el-form>
          </el-card>
        </el-tab-pane>
        
        <el-tab-pane label="最终成绩公式" name="grade">
          <el-card shadow="never">
            <el-form label-width="150px">
              <el-form-item label="平时成绩权重">
                <el-input-number v-model="configData.final_grade_formula.usual_weight" :min="0" :max="1" :step="0.01" :precision="2" />
                <span class="formula-hint">（当前: {{ configData.final_grade_formula.usual_weight }}）</span>
              </el-form-item>
              <el-form-item label="期末成绩权重">
                <el-input-number v-model="configData.final_grade_formula.final_weight" :min="0" :max="1" :step="0.01" :precision="2" />
                <span class="formula-hint">（当前: {{ configData.final_grade_formula.final_weight }}）</span>
              </el-form-item>
              <el-alert type="info" :closable="false" style="margin-top: 10px">
                <template #title>
                  计算公式: 最终成绩 = 平时成绩 × {{ configData.final_grade_formula.usual_weight }} + 期末成绩 × {{ configData.final_grade_formula.final_weight }}
                </template>
              </el-alert>
            </el-form>
          </el-card>
        </el-tab-pane>
        
        <el-tab-pane label="课程目标配置" name="objectives">
          <el-card shadow="never" v-for="(obj, index) in configData.objectives" :key="index" style="margin-bottom: 15px">
            <template #header>
              <span style="font-weight: bold">{{ obj.name }}（满分: {{ obj.max_score }}）</span>
            </template>
            <el-form label-width="150px">
              <el-row :gutter="20">
                <el-col :span="8">
                  <el-form-item label="平时权重">
                    <el-input-number v-model="obj.usual_weight" :min="0" :max="1" :step="0.01" :precision="2" size="small" />
                  </el-form-item>
                </el-col>
                <el-col :span="8">
                  <el-form-item label="平时子权重">
                    <el-input-number v-model="obj.usual_sub_weight" :min="0" :max="1" :step="0.01" :precision="2" size="small" />
                  </el-form-item>
                </el-col>
                <el-col :span="8">
                  <el-form-item label="满分">
                    <el-input-number v-model="obj.max_score" :min="1" :max="100" :step="1" :precision="1" size="small" />
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row :gutter="20">
                <el-col :span="8">
                  <el-form-item label="实验权重">
                    <el-input-number v-model="obj.experiment_weight" :min="0" :max="1" :step="0.01" :precision="2" size="small" />
                  </el-form-item>
                </el-col>
                <el-col :span="8">
                  <el-form-item label="实验子权重">
                    <el-input-number v-model="obj.experiment_sub_weight" :min="0" :max="1" :step="0.01" :precision="2" size="small" />
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row :gutter="20">
                <el-col :span="8">
                  <el-form-item label="期末权重">
                    <el-input-number v-model="obj.final_weight" :min="0" :max="1" :step="0.01" :precision="2" size="small" />
                  </el-form-item>
                </el-col>
                <el-col :span="8">
                  <el-form-item label="期末子权重">
                    <el-input-number v-model="obj.final_sub_weight" :min="0" :max="1" :step="0.01" :precision="2" size="small" />
                  </el-form-item>
                </el-col>
              </el-row>
              <el-alert type="info" :closable="false">
                <template #title>
                  计算公式: {{ obj.name }}达成情况 = 平时成绩 × {{ obj.usual_weight }} × {{ obj.usual_sub_weight }} + 实验 × {{ obj.experiment_weight }} × {{ obj.experiment_sub_weight }} + 期末成绩 × {{ obj.final_weight }} × {{ obj.final_sub_weight }}
                </template>
              </el-alert>
            </el-form>
          </el-card>
        </el-tab-pane>
      </el-tabs>
      
      <template #footer>
        <el-button @click="configDialogVisible = false">取消</el-button>
        <el-button type="warning" @click="handleResetConfig">恢复默认</el-button>
        <el-button type="primary" @click="handleSaveConfig" :loading="savingConfig">保存配置</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Upload, Download, Refresh, ArrowDown, Plus, Delete, Setting } from '@element-plus/icons-vue'
import { getScores, createScore, updateScore, deleteScore, exportScores, exportAchievement, getClassesWithScores } from '@/api/scores'
import { getClasses, getObjectiveConfig, setObjectiveConfig } from '@/api/courses'
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
const configDialogVisible = ref(false)
const configActiveTab = ref('usual')
const savingConfig = ref(false)
const currentCourseId = ref(null)
const configCourseClassId = ref(null)
const allClasses = ref([])
const isGraphicsCourse = ref(false)

const DEFAULT_CONFIG = {
  usual_score_formula: {
    attendance_weight: 0.05,
    e_notes_weight: 0.05,
    homework_weight: 0.1,
    total_weight: 0.2
  },
  final_score_formula: {
    experiment_weight: 0,
    work_weight: 0.5,
    report_weight: 0.5,
    total_weight: 1.0
  },
  final_grade_formula: {
    usual_weight: 0.4,
    final_weight: 0.6
  },
  objectives: [
    {
      number: 1,
      name: '课程目标1',
      usual_weight: 0.2,
      usual_sub_weight: 0.5,
      experiment_weight: 0,
      experiment_sub_weight: 0,
      final_weight: 0.6,
      final_sub_weight: 0.35,
      max_score: 31.0
    },
    {
      number: 2,
      name: '课程目标2',
      usual_weight: 0.2,
      usual_sub_weight: 0.3,
      experiment_weight: 0.5,
      experiment_sub_weight: 0.2,
      final_weight: 0.6,
      final_sub_weight: 0.35,
      max_score: 37.0
    },
    {
      number: 3,
      name: '课程目标3',
      usual_weight: 0.2,
      usual_sub_weight: 0.2,
      experiment_weight: 0.5,
      experiment_sub_weight: 0.2,
      final_weight: 0.6,
      final_sub_weight: 0.3,
      max_score: 32.0
    }
  ]
}

const configData = reactive(JSON.parse(JSON.stringify(DEFAULT_CONFIG)))

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

const handleOpenConfig = async () => {
  configCourseClassId.value = null
  configActiveTab.value = 'usual'

  try {
    if (allClasses.value.length === 0) {
      const response = await getClasses()
      allClasses.value = response.results || response
    }
    configDialogVisible.value = true
  } catch (error) {
    ElMessage.error('获取班级列表失败: ' + (error.response?.data?.error || error.message))
  }
}

const handleConfigClassChange = async (classId) => {
  if (!classId) {
    return
  }

  try {
    const selectedClass = allClasses.value.find(cls => cls.id === classId)

    if (!selectedClass || !selectedClass.course) {
      ElMessage.warning('无法获取课程信息')
      return
    }

    currentCourseId.value = selectedClass.course
    isGraphicsCourse.value = selectedClass.course_name?.includes('图形学') || false

    const response = await getObjectiveConfig(currentCourseId.value)

    if (response.config) {
      Object.assign(configData, JSON.parse(JSON.stringify(response.config)))
    } else {
      Object.assign(configData, JSON.parse(JSON.stringify(DEFAULT_CONFIG)))
    }
  } catch (error) {
    ElMessage.error('获取配置失败: ' + (error.response?.data?.error || error.message))
  }
}

const handleResetConfig = () => {
  Object.assign(configData, JSON.parse(JSON.stringify(DEFAULT_CONFIG)))
  ElMessage.success('已恢复默认配置')
}

const handleSaveConfig = async () => {
  if (!currentCourseId.value) {
    ElMessage.warning('请先选择一个班级')
    return
  }

  savingConfig.value = true
  try {
    await setObjectiveConfig(currentCourseId.value, JSON.parse(JSON.stringify(configData)))
    ElMessage.success('配置保存成功')

    if (configCourseClassId.value) {
      const shouldRecalculate = await ElMessageBox.confirm('配置已更新，是否重新计算该班级所有成绩？', '提示', {
        type: 'info',
        confirmButtonText: '重新计算',
        cancelButtonText: '稍后计算'
      })

      if (shouldRecalculate === 'confirm' && configCourseClassId.value) {
        searchForm.course_class_id = configCourseClassId.value
        await handleRecalculate()
      }
    }

    configDialogVisible.value = false
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('保存配置失败: ' + (error.response?.data?.error || error.message))
    }
  } finally {
    savingConfig.value = false
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

.formula-hint {
  color: #909399;
  font-size: 12px;
  margin-left: 10px;
}
</style>
