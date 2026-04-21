<template>
  <div class="gradebook-list">
    <div class="page-header">
      <h1 class="page-title">算法成绩管理{{ isAlgorithmCourse ? ' - 算法分析与设计成绩' : '' }}</h1>
      <div class="page-actions">
        <!-- 普通课程的按钮 -->
        <template v-if="!isAlgorithmCourse || !searchForm.course_class_id">
          <el-button type="primary" @click="handleImport" :disabled="!searchForm.course_class_id">
            <el-icon><Upload /></el-icon>
            导入记分册
          </el-button>
          <el-button 
            type="success" 
            @click="handleExport" 
            :disabled="!searchForm.course_class_id"
          >
            <el-icon><Download /></el-icon>
            导出记分册
          </el-button>
          <el-button type="info" @click="handleAdd" :disabled="!searchForm.course_class_id">
            <el-icon><Plus /></el-icon>
            新增记录
          </el-button>
        </template>
        <!-- 算法课程的操作按钮在标签页内，这里不显示 -->
      </div>
    </div>

    <!-- 班级列表卡片 -->
    <el-card style="margin-bottom: 20px">
      <template #header>
        <div style="display: flex; justify-content: space-between; align-items: center">
          <span>有成绩的班级</span>
          <el-button type="text" @click="loadClassesWithAlgorithmScores">
            <el-icon><Refresh /></el-icon>
            刷新
          </el-button>
        </div>
      </template>
      <el-table :data="classesWithAlgorithmScores" border v-loading="loadingClasses" style="width: 100%">
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
            <el-button type="primary" size="small" @click="handleViewAlgorithmScores(row)">查看成绩</el-button>
            <el-button type="success" size="small" @click="handleExportAlgorithmClass(row)">
              导出成绩
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-card>
      <!-- 搜索表单 -->
      <div class="table-toolbar">
        <el-form :inline="true" :model="searchForm" class="search-form">
          <el-form-item label="课程班级">
            <el-select
              v-model="searchForm.course_class_id"
              placeholder="请选择"
              clearable
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
          </el-form-item>
        </el-form>
      </div>

      <!-- 算法分析与设计课程：步骤指示器和标签页 -->
      <div v-if="searchForm.course_class_id">
        <!-- 步骤指示器 -->
        <el-steps :active="currentStep" finish-status="success" style="margin-bottom: 20px; margin-top: 10px">
          <el-step 
            title="步骤1: 记分册管理" 
            :description="gradebookStatus"
            :status="gradebookStepStatus"
          />
          <el-step 
            title="步骤2: 卷面成绩" 
            :description="finalPaperStatus"
            :status="finalPaperStepStatus"
          />
          <el-step 
            title="步骤3: 最终成绩" 
            :description="finalScoreStatus"
            :status="finalScoreStepStatus"
          />
        </el-steps>

        <!-- 标签页 -->
        <el-tabs v-model="activeTab" type="border-card" @tab-change="handleTabChange">
          <!-- 标签1: 记分册 -->
          <el-tab-pane label="步骤1: 记分册管理" name="gradebook">
            <div class="tab-header">
              <el-alert
                :title="gradebookAlertTitle"
                :type="gradebookAlertType"
                :closable="false"
                style="margin-bottom: 15px"
              />
              <div class="tab-actions">
                <el-button type="primary" @click="handleImport" :disabled="!searchForm.course_class_id">
                  <el-icon><Upload /></el-icon>
                  导入记分册
                </el-button>
                <el-button type="info" @click="handleAdd" :disabled="!searchForm.course_class_id">
                  <el-icon><Plus /></el-icon>
                  新增记录
                </el-button>
                <el-button 
                  type="success" 
                  @click="handleExportGradebook" 
                  :disabled="!searchForm.course_class_id || gradebookList.length === 0"
                >
                  <el-icon><Download /></el-icon>
                  导出记分册
                </el-button>
              </div>
            </div>
            
            <!-- 记分册表格 -->
            <el-table
              :data="gradebookList"
              border
              v-loading="loading"
              style="width: 100%; margin-top: 15px"
              :max-height="500"
            >
              <el-table-column prop="student_id" label="学号" width="120" fixed="left" />
              <el-table-column prop="student_name" label="姓名" width="100" fixed="left" />
              <el-table-column label="作业" width="400">
                <el-table-column prop="homework1" label="作业1" width="80" align="center" />
                <el-table-column prop="homework2" label="作业2" width="80" align="center" />
                <el-table-column prop="homework3" label="作业3" width="80" align="center" />
                <el-table-column prop="homework4" label="作业4" width="80" align="center" />
                <el-table-column prop="homework5" label="作业5" width="80" align="center" />
              </el-table-column>
              <el-table-column label="实验" width="160">
                <el-table-column prop="experiment1" label="实验1" width="80" align="center" />
                <el-table-column prop="experiment2" label="实验2" width="80" align="center" />
              </el-table-column>
              <el-table-column label="考勤" width="400">
                <el-table-column prop="attendance1" label="考勤1" width="80" align="center" />
                <el-table-column prop="attendance2" label="考勤2" width="80" align="center" />
                <el-table-column prop="attendance3" label="考勤3" width="80" align="center" />
                <el-table-column prop="attendance4" label="考勤4" width="80" align="center" />
                <el-table-column prop="attendance5" label="考勤5" width="80" align="center" />
              </el-table-column>
              <el-table-column prop="review_note" label="复习笔记" width="100" align="center" />
              <el-table-column prop="final_score" label="期末成绩" width="100" align="center" />
              <el-table-column prop="usual_score" label="平时" width="80" align="center">
                <template #default="{ row }">
                  {{ row.usual_score !== null && row.usual_score !== undefined ? Math.round(row.usual_score) : '' }}
                </template>
              </el-table-column>
              <el-table-column prop="total_score" label="总评" width="80" align="center">
                <template #default="{ row }">
                  {{ row.total_score !== null && row.total_score !== undefined ? Math.round(row.total_score) : '' }}
                </template>
              </el-table-column>
              <el-table-column label="操作" width="150" fixed="right">
                <template #default="{ row }">
                  <el-button type="primary" size="small" @click="handleEdit(row)">编辑</el-button>
                  <el-button type="danger" size="small" @click="handleDelete(row)">删除</el-button>
                </template>
              </el-table-column>
            </el-table>

            <!-- 记分册分页 -->
            <el-pagination
              v-if="gradebookList.length > 0"
              v-model:current-page="pagination.page"
              v-model:page-size="pagination.pageSize"
              :total="pagination.total"
              :page-sizes="[10, 20, 50, 100]"
              layout="total, sizes, prev, pager, next, jumper"
              @size-change="handleSizeChange"
              @current-change="handlePageChange"
              style="margin-top: 20px; justify-content: flex-end"
            />
          </el-tab-pane>

          <!-- 标签2: 卷面成绩 -->
          <el-tab-pane label="步骤2: 卷面成绩" name="finalPaper">
            <div class="tab-header">
              <el-alert
                :title="finalPaperAlertTitle"
                :type="finalPaperAlertType"
                :closable="false"
                style="margin-bottom: 15px"
              />
              <div class="tab-actions">
                <el-button 
                  type="primary" 
                  @click="handleAddFinalPaperScore" 
                  :disabled="!searchForm.course_class_id || gradebookList.length === 0"
                >
                  <el-icon><Plus /></el-icon>
                  新增记录
                </el-button>
                <el-button 
                  type="warning" 
                  @click="handleImportFinalPaper" 
                  :disabled="!searchForm.course_class_id || gradebookList.length === 0"
                >
                  <el-icon><Upload /></el-icon>
                  导入卷面成绩
                </el-button>
                <el-button 
                  type="warning" 
                  @click="showMConfigDialog = true"
                  :disabled="!searchForm.course_class_id"
                >
                  <el-icon><Setting /></el-icon>
                  M列配置
                </el-button>
                <el-button 
                  type="info" 
                  @click="handleRecalculate" 
                  :disabled="!searchForm.course_class_id || algorithmScoreList.length === 0" 
                  :loading="recalculating"
                >
                  <el-icon><Refresh /></el-icon>
                  重新计算
                </el-button>
              </div>
            </div>
            
            <!-- 卷面成绩表格（显示原始小题得分） -->
            <!-- 使用多级表头：第一行显示大题（一、二、三、四、卷面），第二行显示题号 -->
            <el-table
              v-if="finalPaperTableData.length > 0 || previewData.length > 0"
              :data="finalPaperTableData.length > 0 ? finalPaperTableData : previewData"
              border
              v-loading="loading"
              style="width: 100%; margin-top: 15px"
              :max-height="500"
              key="final-paper-table"
              :header-cell-style="{ textAlign: 'center', fontWeight: 'bold', background: '#f5f7fa', padding: '8px 0' }"
              :cell-style="{ textAlign: 'center', padding: '6px 0' }"
            >
              <!-- 基本信息列 -->
              <el-table-column prop="student_id" label="学号" width="120" fixed="left" align="center" />
              <el-table-column prop="student_name" label="姓名" width="100" fixed="left" align="center" />
              
              <!-- 动态生成大题列（多级表头结构） -->
              <template v-if="finalPaperTableColumnsForDisplay && Object.keys(finalPaperTableColumnsForDisplay).length > 0">
                <template v-for="(section, sectionKey) in finalPaperTableColumnsForDisplay" :key="sectionKey">
                  <el-table-column 
                    :label="sectionKey" 
                    :min-width="section.minWidth"
                    align="center"
                  >
                    <!-- 子题列（第二级表头） -->
                    <el-table-column 
                      v-for="(subCol, subKey) in section.subColumns" 
                      :key="`${sectionKey}-${subKey}`"
                      :label="subKey === 'total' ? '总分' : subKey"
                      width="80"
                      align="center"
                      :show-overflow-tooltip="false"
                    >
                      <template #default="{ row }">
                        <span>{{ getRawScore(row, sectionKey, subKey) }}</span>
                      </template>
                    </el-table-column>
                  </el-table-column>
                </template>
              </template>
              
              <!-- 如果没有列配置但有数据，显示提示 -->
              <el-table-column 
                v-if="(!finalPaperTableColumnsForDisplay || Object.keys(finalPaperTableColumnsForDisplay).length === 0) && (finalPaperTableData.length > 0 || previewData.length > 0)"
                label="提示"
                width="200"
                align="center"
              >
                <template #default>
                  <span style="color: #909399">请导入卷面成绩数据</span>
                </template>
              </el-table-column>
            </el-table>
            
            <!-- 空状态提示 -->
            <el-empty 
              v-if="finalPaperTableData.length === 0 && previewData.length === 0 && !loading && gradebookList.length === 0" 
              description="请先完成步骤1：导入记分册，系统会自动创建成绩记录" 
              style="margin-top: 40px"
            />
          </el-tab-pane>

          <!-- 标签3: 最终成绩 -->
          <el-tab-pane label="步骤3: 最终成绩" name="finalScore">
            <div class="tab-header">
              <el-alert
                :title="finalScoreAlertTitle"
                :type="finalScoreAlertType"
                :closable="false"
                style="margin-bottom: 15px"
              />
              <div class="tab-actions">
                <el-button 
                  type="primary" 
                  @click="handleAddAlgorithmScore" 
                  :disabled="!searchForm.course_class_id"
                >
                  <el-icon><Plus /></el-icon>
                  新增记录
                </el-button>
                <el-button 
                  type="danger" 
                  @click="handleBatchDeleteAlgorithmScores" 
                  :disabled="!searchForm.course_class_id || selectedAlgorithmScores.length === 0"
                >
                  <el-icon><Delete /></el-icon>
                  批量删除
                </el-button>
                <el-button 
                  type="info" 
                  @click="handleRecalculate" 
                  :disabled="!searchForm.course_class_id" 
                  :loading="recalculating"
                >
                  <el-icon><Refresh /></el-icon>
                  重新计算
                </el-button>
                <el-button 
                  type="success" 
                  @click="handleExport" 
                  :disabled="!searchForm.course_class_id || algorithmScoreList.length === 0"
                >
                  <el-icon><Download /></el-icon>
                  导出最终成绩
                </el-button>
              </div>
            </div>
            
            <!-- 最终成绩完整表格 -->
            <el-table
              v-if="algorithmScoreList.length > 0"
              :data="algorithmScoreList"
              border
              v-loading="loading"
              style="width: 100%; margin-top: 15px"
              :max-height="500"
              @selection-change="handleAlgorithmScoreSelectionChange"
            >
              <!-- 选择列 -->
              <el-table-column type="selection" width="55" fixed="left" />
              <!-- 基本信息列 -->
              <el-table-column prop="student_id" label="学号" width="120" fixed="left" />
              <el-table-column prop="student_name" label="姓名" width="100" fixed="left" />
              
              <!-- 平时成绩组成部分 -->
              <el-table-column label="平时" align="center">
                <el-table-column prop="class_performance" label="课堂表现" width="90">
                  <template #default="{ row }">
                    {{ row.class_performance !== null && row.class_performance !== undefined ? row.class_performance.toFixed(2) : '-' }}
                  </template>
                </el-table-column>
                <el-table-column prop="note_score" label="笔记" width="80">
                  <template #default="{ row }">
                    {{ row.note_score !== null && row.note_score !== undefined ? row.note_score.toFixed(2) : '-' }}
                  </template>
                </el-table-column>
                <el-table-column prop="homework_avg" label="作业" width="80">
                  <template #default="{ row }">
                    {{ row.homework_avg !== null && row.homework_avg !== undefined ? row.homework_avg.toFixed(2) : '-' }}
                  </template>
                </el-table-column>
                <el-table-column prop="experiment_avg" label="实验" width="80">
                  <template #default="{ row }">
                    {{ row.experiment_avg !== null && row.experiment_avg !== undefined ? row.experiment_avg.toFixed(2) : '-' }}
                  </template>
                </el-table-column>
              </el-table-column>
              
              <el-table-column prop="usual_score" label="平时成绩" width="100">
                <template #default="{ row }">
                  {{ row.usual_score !== null && row.usual_score !== undefined ? Math.round(row.usual_score) : '-' }}
                </template>
              </el-table-column>
              
              <!-- 卷面成绩和M1-M4 -->
              <el-table-column label="卷面成绩" align="center">
                <el-table-column label="M1/35" width="90">
                  <template #default="{ row }">
                    {{ row.M1 !== null && row.M1 !== undefined ? Math.min(row.M1, 35.0).toFixed(2) : (calculateM1(row)) }}
                  </template>
                </el-table-column>
                <el-table-column label="M2/20" width="90">
                  <template #default="{ row }">
                    {{ row.M2 !== null && row.M2 !== undefined ? Math.min(row.M2, 20.0).toFixed(2) : (calculateM2(row)) }}
                  </template>
                </el-table-column>
                <el-table-column label="M3/35" width="90">
                  <template #default="{ row }">
                    {{ row.M3 !== null && row.M3 !== undefined ? Math.min(row.M3, 35.0).toFixed(2) : (calculateM3(row)) }}
                  </template>
                </el-table-column>
                <el-table-column label="M4/10" width="90">
                  <template #default="{ row }">
                    {{ row.M4 !== null && row.M4 !== undefined ? Math.min(row.M4, 10.0).toFixed(2) : (calculateM4(row)) }}
                  </template>
                </el-table-column>
                <el-table-column label="卷面" width="90">
                  <template #default="{ row }">
                    {{ calculateFinalPaperScore(row) }}
                  </template>
                </el-table-column>
              </el-table-column>

              <!-- 课程目标1 -->
              <el-table-column label="课程目标1" align="center">
                <el-table-column label="课堂" width="70">
                  <template #default="{ row }">
                    {{ calculateObj1Classroom(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="笔记" width="70">
                  <template #default="{ row }">
                    {{ calculateObj1Note(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="作业" width="70">
                  <template #default="{ row }">
                    {{ calculateObj1Homework(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="实验" width="70">
                  <template #default="{ row }">
                    {{ calculateObj1Experiment(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="期末" width="70">
                  <template #default="{ row }">
                    {{ calculateObj1Final(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="达成情况" width="100">
                  <template #default="{ row }">
                    {{ calculateObj1Achievement(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="达成度" width="100">
                  <template #default="{ row }">
                    {{ calculateObj1Degree(row) }}
                  </template>
                </el-table-column>
              </el-table-column>
              
              <!-- 课程目标2 -->
              <el-table-column label="课程目标2" align="center">
                <el-table-column label="课堂" width="70">
                  <template #default="{ row }">
                    {{ calculateObj2Classroom(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="笔记" width="70">
                  <template #default="{ row }">
                    {{ calculateObj2Note(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="作业" width="70">
                  <template #default="{ row }">
                    {{ calculateObj2Homework(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="实验" width="70">
                  <template #default="{ row }">
                    {{ calculateObj2Experiment(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="期末" width="70">
                  <template #default="{ row }">
                    {{ calculateObj2Final(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="达成情况" width="100">
                  <template #default="{ row }">
                    {{ calculateObj2Achievement(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="达成度" width="100">
                  <template #default="{ row }">
                    {{ calculateObj2Degree(row) }}
                  </template>
                </el-table-column>
              </el-table-column>
              
              <!-- 课程目标3 -->
              <el-table-column label="课程目标3" align="center">
                <el-table-column label="课堂" width="70">
                  <template #default="{ row }">
                    {{ calculateObj3Classroom(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="笔记" width="70">
                  <template #default="{ row }">
                    {{ calculateObj3Note(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="作业" width="70">
                  <template #default="{ row }">
                    {{ calculateObj3Homework(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="实验" width="70">
                  <template #default="{ row }">
                    {{ calculateObj3Experiment(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="期末" width="70">
                  <template #default="{ row }">
                    {{ calculateObj3Final(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="达成情况" width="100">
                  <template #default="{ row }">
                    {{ calculateObj3Achievement(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="达成度" width="100">
                  <template #default="{ row }">
                    {{ calculateObj3Degree(row) }}
                  </template>
                </el-table-column>
              </el-table-column>
              
              <!-- 课程目标4 -->
              <el-table-column label="课程目标4" align="center">
                <el-table-column label="课堂" width="70">
                  <template #default="{ row }">
                    {{ calculateObj4Classroom(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="笔记" width="70">
                  <template #default="{ row }">
                    {{ calculateObj4Note(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="作业" width="70">
                  <template #default="{ row }">
                    {{ calculateObj4Homework(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="实验" width="70">
                  <template #default="{ row }">
                    {{ calculateObj4Experiment(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="期末" width="70">
                  <template #default="{ row }">
                    {{ calculateObj4Final(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="达成情况" width="100">
                  <template #default="{ row }">
                    {{ calculateObj4Achievement(row) }}
                  </template>
                </el-table-column>
                <el-table-column label="达成度" width="100">
                  <template #default="{ row }">
                    {{ calculateObj4Degree(row) }}
                  </template>
                </el-table-column>
              </el-table-column>

              <!-- 总成绩 -->
              <el-table-column prop="total_score" label="总成绩" width="100">
                <template #default="{ row }">
                  {{ row.total_score !== null && row.total_score !== undefined ? Math.round(row.total_score) : '-' }}
                </template>
              </el-table-column>
              
              <!-- 步骤2的卷面成绩详细内容（原始小题得分） -->
              <template v-if="finalPaperTableColumnsForDisplay && Object.keys(finalPaperTableColumnsForDisplay).length > 0">
                <template v-for="(section, sectionKey) in finalPaperTableColumnsForDisplay" :key="sectionKey">
                  <el-table-column 
                    :label="sectionKey" 
                    :min-width="section.minWidth"
                    align="center"
                  >
                    <!-- 子题列（第二级表头） -->
                    <el-table-column 
                      v-for="(subCol, subKey) in section.subColumns" 
                      :key="`${sectionKey}-${subKey}`"
                      :label="subKey === 'total' ? '总分' : subKey"
                      width="80"
                      align="center"
                      :show-overflow-tooltip="false"
                    >
                      <template #default="{ row }">
                        <span>{{ getRawScore(row, sectionKey, subKey) }}</span>
                      </template>
                    </el-table-column>
                  </el-table-column>
                </template>
              </template>
              
              <el-table-column label="成绩录入" align="center" fixed="right">
                <el-table-column prop="usual_entry" label="平时录入" width="100">
                  <template #default="{ row }">
                    {{ row.usual_entry !== null && row.usual_entry !== undefined ? Math.round(row.usual_entry) : '-' }}
                  </template>
                </el-table-column>
                <el-table-column prop="final_entry" label="期末录入" width="100">
                  <template #default="{ row }">
                    {{ getFinalEntryValue(row) }}
                  </template>
                </el-table-column>
                <el-table-column prop="final_grade" label="最终成绩" width="100">
                  <template #default="{ row }">
                    {{ row.final_grade !== null && row.final_grade !== undefined ? Math.round(row.final_grade) : '-' }}
                  </template>
                </el-table-column>
              </el-table-column>
              
              <!-- 操作列 -->
              <el-table-column label="操作" width="150" fixed="right">
                <template #default="{ row }">
                  <el-button type="primary" size="small" @click="handleEditAlgorithmScore(row)">编辑</el-button>
                  <el-button type="danger" size="small" @click="handleDeleteAlgorithmScore(row)">删除</el-button>
                </template>
              </el-table-column>
            </el-table>
            
            <!-- 步骤3空状态提示 -->
            <el-empty 
              v-else-if="!loading" 
              description="请先完成步骤1和步骤2：导入记分册和卷面成绩，然后点击重新计算生成最终成绩" 
              style="margin-top: 40px"
            />
            
            <!-- 达成度计算表 -->
            <el-card v-if="algorithmScoreList.length > 0 && statisticsTable.length > 0" style="margin-top: 20px">
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
                <el-table-column prop="achievement_degree" label="达成度%" width="150" align="right">
                  <template #default="{ row }">
                    {{ (row.achievement_degree * 100).toFixed(2) }}%
                  </template>
                </el-table-column>
              </el-table>
            </el-card>
          </el-tab-pane>
        </el-tabs>
      </div>

      <!-- 旧代码开始标记，以下需要删除 -->
      <div v-if="false">
        <el-table
          :data="algorithmScoreList"
          border
          v-loading="loading"
          style="width: 100%"
          :max-height="600"
        >
          <!-- 基本信息列 -->
          <el-table-column prop="student_id" label="学号" width="120" fixed="left" />
          <el-table-column prop="student_name" label="姓名" width="100" fixed="left" />
          
          <!-- 平时成绩组成部分 -->
          <el-table-column label="平时" align="center">
            <el-table-column prop="class_performance" label="课堂表现" width="90">
              <template #default="{ row }">
                {{ row.class_performance !== null && row.class_performance !== undefined ? row.class_performance.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="note_score" label="笔记" width="80">
              <template #default="{ row }">
                {{ row.note_score !== null && row.note_score !== undefined ? row.note_score.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="homework_avg" label="作业" width="80">
              <template #default="{ row }">
                {{ row.homework_avg !== null && row.homework_avg !== undefined ? row.homework_avg.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="experiment_avg" label="实验" width="80">
              <template #default="{ row }">
                {{ row.experiment_avg !== null && row.experiment_avg !== undefined ? row.experiment_avg.toFixed(2) : '-' }}
              </template>
            </el-table-column>
          </el-table-column>
          
          <el-table-column prop="usual_score" label="平时成绩" width="100">
            <template #default="{ row }">
              {{ row.usual_score !== null && row.usual_score !== undefined ? Math.round(row.usual_score) : '-' }}
            </template>
          </el-table-column>
          
          <!-- 期末成绩组成部分 -->
          <el-table-column label="期末" align="center">
            <el-table-column prop="M1" label="M1/35" width="90">
              <template #default="{ row }">
                {{ row.M1 !== null && row.M1 !== undefined ? row.M1.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="M2" label="M2/20" width="90">
              <template #default="{ row }">
                {{ row.M2 !== null && row.M2 !== undefined ? row.M2.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="M3" label="M3/35" width="90">
              <template #default="{ row }">
                {{ row.M3 !== null && row.M3 !== undefined ? row.M3.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="M4" label="M4/10" width="90">
              <template #default="{ row }">
                {{ row.M4 !== null && row.M4 !== undefined ? row.M4.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="final_paper_score" label="卷面" width="90">
              <template #default="{ row }">
                {{ row.final_paper_score !== null && row.final_paper_score !== undefined ? row.final_paper_score.toFixed(2) : '-' }}
              </template>
            </el-table-column>
          </el-table-column>

          <!-- 课程目标1 -->
          <el-table-column label="课程目标1" align="center">
            <el-table-column prop="obj1_classroom" label="课堂" width="70">
              <template #default="{ row }">
                {{ row.obj1_classroom !== null && row.obj1_classroom !== undefined ? row.obj1_classroom.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj1_note" label="笔记" width="70">
              <template #default="{ row }">
                {{ row.obj1_note !== null && row.obj1_note !== undefined ? row.obj1_note.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj1_homework" label="作业" width="70">
              <template #default="{ row }">
                {{ row.obj1_homework !== null && row.obj1_homework !== undefined ? row.obj1_homework.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj1_experiment" label="实验" width="70">
              <template #default="{ row }">
                {{ row.obj1_experiment !== null && row.obj1_experiment !== undefined ? row.obj1_experiment.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj1_final" label="期末" width="70">
              <template #default="{ row }">
                {{ row.obj1_final !== null && row.obj1_final !== undefined ? row.obj1_final.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj1_achievement" label="达成情况" width="100">
              <template #default="{ row }">
                {{ row.obj1_achievement !== null && row.obj1_achievement !== undefined ? row.obj1_achievement.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj1_degree" label="达成度" width="100">
              <template #default="{ row }">
                {{ row.obj1_degree !== null && row.obj1_degree !== undefined ? row.obj1_degree.toFixed(2) : '-' }}
              </template>
            </el-table-column>
          </el-table-column>

          <!-- 课程目标2 -->
          <el-table-column label="课程目标2" align="center">
            <el-table-column prop="obj2_classroom" label="课堂" width="70">
              <template #default="{ row }">
                {{ row.obj2_classroom !== null && row.obj2_classroom !== undefined ? row.obj2_classroom.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj2_note" label="笔记" width="70">
              <template #default="{ row }">
                {{ row.obj2_note !== null && row.obj2_note !== undefined ? row.obj2_note.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj2_homework" label="作业" width="70">
              <template #default="{ row }">
                {{ row.obj2_homework !== null && row.obj2_homework !== undefined ? row.obj2_homework.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj2_experiment" label="实验" width="70">
              <template #default="{ row }">
                {{ row.obj2_experiment !== null && row.obj2_experiment !== undefined ? row.obj2_experiment.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj2_final" label="期末" width="70">
              <template #default="{ row }">
                {{ row.obj2_final !== null && row.obj2_final !== undefined ? row.obj2_final.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj2_achievement" label="达成情况" width="100">
              <template #default="{ row }">
                {{ row.obj2_achievement !== null && row.obj2_achievement !== undefined ? row.obj2_achievement.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj2_degree" label="达成度" width="100">
              <template #default="{ row }">
                {{ row.obj2_degree !== null && row.obj2_degree !== undefined ? row.obj2_degree.toFixed(2) : '-' }}
              </template>
            </el-table-column>
          </el-table-column>

          <!-- 课程目标3 -->
          <el-table-column label="课程目标3" align="center">
            <el-table-column prop="obj3_classroom" label="课堂" width="70">
              <template #default="{ row }">
                {{ row.obj3_classroom !== null && row.obj3_classroom !== undefined ? row.obj3_classroom.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj3_note" label="笔记" width="70">
              <template #default="{ row }">
                {{ row.obj3_note !== null && row.obj3_note !== undefined ? row.obj3_note.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj3_homework" label="作业" width="70">
              <template #default="{ row }">
                {{ row.obj3_homework !== null && row.obj3_homework !== undefined ? row.obj3_homework.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj3_experiment" label="实验" width="70">
              <template #default="{ row }">
                {{ row.obj3_experiment !== null && row.obj3_experiment !== undefined ? row.obj3_experiment.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj3_final" label="期末" width="70">
              <template #default="{ row }">
                {{ row.obj3_final !== null && row.obj3_final !== undefined ? row.obj3_final.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj3_achievement" label="达成情况" width="100">
              <template #default="{ row }">
                {{ row.obj3_achievement !== null && row.obj3_achievement !== undefined ? row.obj3_achievement.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj3_degree" label="达成度" width="100">
              <template #default="{ row }">
                {{ row.obj3_degree !== null && row.obj3_degree !== undefined ? row.obj3_degree.toFixed(2) : '-' }}
              </template>
            </el-table-column>
          </el-table-column>

          <!-- 课程目标4 -->
          <el-table-column label="课程目标4" align="center">
            <el-table-column prop="obj4_classroom" label="课堂" width="70">
              <template #default="{ row }">
                {{ row.obj4_classroom !== null && row.obj4_classroom !== undefined ? row.obj4_classroom.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj4_note" label="笔记" width="70">
              <template #default="{ row }">
                {{ row.obj4_note !== null && row.obj4_note !== undefined ? row.obj4_note.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj4_homework" label="作业" width="70">
              <template #default="{ row }">
                {{ row.obj4_homework !== null && row.obj4_homework !== undefined ? row.obj4_homework.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj4_experiment" label="实验" width="70">
              <template #default="{ row }">
                {{ row.obj4_experiment !== null && row.obj4_experiment !== undefined ? row.obj4_experiment.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj4_final" label="期末" width="70">
              <template #default="{ row }">
                {{ row.obj4_final !== null && row.obj4_final !== undefined ? row.obj4_final.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj4_achievement" label="达成情况" width="100">
              <template #default="{ row }">
                {{ row.obj4_achievement !== null && row.obj4_achievement !== undefined ? row.obj4_achievement.toFixed(2) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="obj4_degree" label="达成度" width="100">
              <template #default="{ row }">
                {{ row.obj4_degree !== null && row.obj4_degree !== undefined ? row.obj4_degree.toFixed(2) : '-' }}
              </template>
            </el-table-column>
          </el-table-column>

          <!-- 总成绩和成绩录入 -->
          <el-table-column prop="total_score" label="总成绩" width="100" fixed="right">
            <template #default="{ row }">
              {{ row.total_score !== null && row.total_score !== undefined ? Math.round(row.total_score) : '-' }}
            </template>
          </el-table-column>
          
          <el-table-column label="成绩录入" align="center" fixed="right">
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
            <el-table-column prop="final_grade" label="最终成绩" width="100">
              <template #default="{ row }">
                {{ row.final_grade !== null && row.final_grade !== undefined ? Math.round(row.final_grade) : '-' }}
              </template>
            </el-table-column>
          </el-table-column>
        </el-table>
        
        <!-- 达成度计算表 -->
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
            <el-table-column prop="achievement_degree" label="达成度%" width="150">
              <template #default="{ row }">
                {{ row.achievement_degree.toFixed(2) }}
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </div>

      <!-- 普通记分册表格 -->
      <el-table
        v-else-if="!isAlgorithmCourse"
        :data="gradebookList"
        border
        v-loading="loading"
        style="width: 100%"
        :max-height="600"
      >
        <el-table-column prop="student_id" label="学号" width="120" fixed="left" />
        <el-table-column prop="student_name" label="姓名" width="100" fixed="left" />
        <el-table-column label="作业" width="400">
          <el-table-column prop="homework1" label="作业1" width="80" align="center" />
          <el-table-column prop="homework2" label="作业2" width="80" align="center" />
          <el-table-column prop="homework3" label="作业3" width="80" align="center" />
          <el-table-column prop="homework4" label="作业4" width="80" align="center" />
          <el-table-column prop="homework5" label="作业5" width="80" align="center" />
        </el-table-column>
        <el-table-column label="实验" width="160">
          <el-table-column prop="experiment1" label="实验1" width="80" align="center" />
          <el-table-column prop="experiment2" label="实验2" width="80" align="center" />
        </el-table-column>
        <el-table-column label="考勤" width="400">
          <el-table-column prop="attendance1" label="考勤1" width="80" align="center" />
          <el-table-column prop="attendance2" label="考勤2" width="80" align="center" />
          <el-table-column prop="attendance3" label="考勤3" width="80" align="center" />
          <el-table-column prop="attendance4" label="考勤4" width="80" align="center" />
          <el-table-column prop="attendance5" label="考勤5" width="80" align="center" />
        </el-table-column>
        <el-table-column prop="review_note" label="复习笔记" width="100" align="center" />
        <el-table-column prop="final_score" label="期末成绩" width="100" align="center" />
        <el-table-column prop="usual_score" label="平时" width="80" align="center">
          <template #default="{ row }">
            {{ row.usual_score !== null && row.usual_score !== undefined ? Math.round(row.usual_score) : '' }}
          </template>
        </el-table-column>
        <el-table-column prop="total_score" label="总评" width="80" align="center">
          <template #default="{ row }">
            {{ row.total_score !== null && row.total_score !== undefined ? Math.round(row.total_score) : '' }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" size="small" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 空状态提示 -->
      <div v-if="!searchForm.course_class_id" style="margin-top: 40px">
        <el-empty description="请选择课程班级查看成绩" />
      </div>
      <div v-else-if="!isAlgorithmCourse && gradebookList.length === 0 && !loading" style="margin-top: 40px">
        <el-empty description="该班级暂无记分册数据" />
      </div>
      <div v-else-if="isAlgorithmCourse && algorithmScoreList.length === 0 && !loading" style="margin-top: 40px">
        <el-empty description="该班级暂无成绩数据，请先导入记分册，然后导入卷面成绩" />
      </div>

      <!-- 普通记分册分页 -->
      <el-pagination
        v-if="!isAlgorithmCourse && gradebookList.length > 0"
        v-model:current-page="pagination.page"
        v-model:page-size="pagination.pageSize"
        :total="pagination.total"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="handleSizeChange"
        @current-change="handlePageChange"
        style="margin-top: 20px; justify-content: flex-end"
      />
    </el-card>

    <!-- 编辑对话框 -->
    <el-dialog
      v-model="editDialogVisible"
      :title="editForm.id ? '编辑记分册' : '新增记分册'"
      width="800px"
      @close="handleDialogClose"
    >
      <el-form
        ref="editFormRef"
        :model="editForm"
        :rules="editRules"
        label-width="120px"
      >
        <el-form-item label="学号" prop="student_id" v-if="!editForm.id">
          <el-input v-model="editForm.student_id" placeholder="请输入学号" />
        </el-form-item>
        <el-form-item label="姓名" prop="student_name" v-if="!editForm.id">
          <el-input v-model="editForm.student_name" placeholder="请输入姓名" />
        </el-form-item>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="作业1" prop="homework1">
              <el-input-number v-model="editForm.homework1" :min="0" :max="100" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="作业2" prop="homework2">
              <el-input-number v-model="editForm.homework2" :min="0" :max="100" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="作业3" prop="homework3">
              <el-input-number v-model="editForm.homework3" :min="0" :max="100" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="作业4" prop="homework4">
              <el-input-number v-model="editForm.homework4" :min="0" :max="100" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="作业5" prop="homework5">
          <el-input-number v-model="editForm.homework5" :min="0" :max="100" :precision="2" style="width: 200px" />
        </el-form-item>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="实验1" prop="experiment1">
              <el-input-number v-model="editForm.experiment1" :min="0" :max="100" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="实验2" prop="experiment2">
              <el-input-number v-model="editForm.experiment2" :min="0" :max="100" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="考勤1" prop="attendance1">
              <el-input-number v-model="editForm.attendance1" :min="0" :max="100" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="考勤2" prop="attendance2">
              <el-input-number v-model="editForm.attendance2" :min="0" :max="100" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="考勤3" prop="attendance3">
              <el-input-number v-model="editForm.attendance3" :min="0" :max="100" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="考勤4" prop="attendance4">
              <el-input-number v-model="editForm.attendance4" :min="0" :max="100" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="考勤5" prop="attendance5">
          <el-input-number v-model="editForm.attendance5" :min="0" :max="100" :precision="2" style="width: 200px" />
        </el-form-item>
        <el-form-item label="复习笔记" prop="review_note">
          <el-input-number v-model="editForm.review_note" :min="0" :max="100" :precision="2" style="width: 200px" />
        </el-form-item>
        <el-form-item label="期末成绩" prop="final_score">
          <el-input-number v-model="editForm.final_score" :min="0" :max="100" :precision="2" style="width: 200px" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="editDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSave" :loading="saving">保存</el-button>
      </template>
    </el-dialog>

    <!-- 导入对话框 -->
    <el-dialog v-model="importDialogVisible" title="导入记分册" width="600px">
      <el-upload
        ref="uploadRef"
        :auto-upload="false"
        :on-change="handleFileChange"
        :file-list="fileList"
        accept=".xlsx,.xls"
        drag
      >
        <el-icon class="el-icon--upload"><upload-filled /></el-icon>
        <div class="el-upload__text">
          将文件拖到此处，或<em>点击上传</em>
        </div>
        <template #tip>
          <div class="el-upload__tip">
            支持 .xlsx, .xls 格式，请确保Excel包含：学号、姓名、作业1-5、实验1-2、考勤1-5、复习笔记、期末成绩
          </div>
        </template>
      </el-upload>
      <template #footer>
        <el-button @click="importDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleConfirmImport" :loading="importing">确认导入</el-button>
      </template>
    </el-dialog>

    <!-- 导入卷面成绩对话框 -->
    <el-dialog
      v-model="importFinalPaperDialogVisible"
      title="导入卷面成绩"
      width="900px"
    >
      <el-alert
        title="文件格式说明"
        type="info"
        :closable="false"
        style="margin-bottom: 20px"
      >
        <p>1. 第1行：大题题号（M1, M2, M3, M4）</p>
        <p>2. 第2行：小题题号（1, 2, 3...）</p>
        <p>3. 第3行：分值</p>
        <p>4. 第4行开始：学生成绩（学号、姓名、各题成绩）</p>
      </el-alert>
      <el-upload
        ref="finalPaperUploadRef"
        :auto-upload="false"
        :on-change="handleFinalPaperFileChange"
        :file-list="finalPaperFileList"
        accept=".xlsx,.xls"
        drag
      >
        <el-icon class="el-icon--upload"><upload-filled /></el-icon>
        <div class="el-upload__text">
          将文件拖到此处，或<em>点击上传</em>
        </div>
        <template #tip>
          <div class="el-upload__tip">
            只能上传xlsx/xls文件
          </div>
        </template>
      </el-upload>
      
      <!-- 预览数据表格 -->
      <el-divider v-if="previewData.length > 0" />
      <div v-if="previewData.length > 0" style="margin-top: 20px">
        <h4>预览数据（共{{ previewData.length }}条）</h4>
        <div style="overflow-x: auto">
          <el-table
            :data="previewData"
            border
            :max-height="500"
            style="margin-top: 10px"
            :header-cell-style="{ textAlign: 'center', fontWeight: 'bold', background: '#f5f7fa' }"
            :cell-style="{ textAlign: 'center' }"
          >
            <!-- 学号列 -->
            <el-table-column prop="student_id" label="学号" width="120" fixed="left" />
            <!-- 姓名列 -->
            <el-table-column prop="student_name" label="姓名" width="100" fixed="left" />
            
            <!-- 动态生成大题列（多级表头） -->
            <template v-for="(section, sectionKey) in previewTableColumns" :key="sectionKey">
              <el-table-column 
                :label="sectionKey" 
                :min-width="section.minWidth"
                align="center"
              >
                <!-- 子题列 -->
                <el-table-column 
                  v-for="(subCol, subKey) in section.subColumns" 
                  :key="subKey"
                  :label="subKey === 'total' ? '总分' : subKey"
                  width="80"
                  align="center"
                >
                  <template #default="{ row }">
                    {{ getScoreValue(row.scores, sectionKey, subKey) }}
                  </template>
                </el-table-column>
              </el-table-column>
            </template>
          </el-table>
        </div>
      </div>
      
      <template #footer>
        <el-button @click="handleCancelImportFinalPaper">取消</el-button>
        <el-button type="info" @click="handlePreviewFinalPaper" :loading="previewing" :disabled="finalPaperFileList.length === 0">
          预览数据
        </el-button>
        <el-button type="primary" @click="handleConfirmImportFinalPaper" :loading="importing" :disabled="previewData.length === 0">
          确定导入
        </el-button>
      </template>
    </el-dialog>
    
    <!-- 编辑/新增卷面成绩对话框 -->
    <el-dialog
      v-model="editFinalPaperDialogVisible"
      :title="editingFinalPaperScore ? '编辑卷面成绩' : '新增卷面成绩'"
      width="800px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="editFinalPaperFormRef"
        :model="editFinalPaperForm"
        label-width="120px"
      >
        <el-form-item label="学号" prop="student_id" :rules="[{ required: true, message: '请输入学号', trigger: 'blur' }]">
          <el-input 
            v-model="editFinalPaperForm.student_id" 
            placeholder="请输入学号"
            :disabled="!!editingFinalPaperScore"
          />
        </el-form-item>
        <el-form-item label="姓名" prop="student_name" :rules="[{ required: true, message: '请输入姓名', trigger: 'blur' }]">
          <el-input 
            v-model="editFinalPaperForm.student_name" 
            placeholder="请输入姓名"
            :disabled="!!editingFinalPaperScore"
          />
        </el-form-item>
        
        <!-- 动态生成成绩输入表单 -->
        <template v-if="finalPaperTableColumnsForDisplay && Object.keys(finalPaperTableColumnsForDisplay).length > 0">
          <template v-for="(section, sectionKey) in finalPaperTableColumnsForDisplay" :key="sectionKey">
            <el-divider>{{ sectionKey }}</el-divider>
            <template v-for="(subCol, subKey) in section.subColumns" :key="subKey">
              <el-form-item 
                :label="subKey === 'total' ? `${sectionKey}总分` : `${sectionKey}-${subKey}`"
              >
                <el-input-number
                  :model-value="getEditFormScore(sectionKey, subKey)"
                  :min="0"
                  :max="100"
                  :precision="2"
                  placeholder="请输入分数"
                  style="width: 100%"
                  @update:model-value="(val) => setEditFormScore(sectionKey, subKey, val)"
                />
              </el-form-item>
            </template>
          </template>
        </template>
        <el-alert v-else type="info" :closable="false" style="margin-top: 20px">
          请先导入卷面成绩或预览数据，以显示成绩输入表单
        </el-alert>
      </el-form>
      
      <template #footer>
        <el-button @click="editFinalPaperDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSaveFinalPaperScore">确定</el-button>
      </template>
    </el-dialog>
    
    <!-- M列配置对话框 -->
    <el-dialog
      v-model="showMConfigDialog"
      title="M列配置"
      width="800px"
      :close-on-click-modal="false"
    >
      <el-form :model="mConfigForm" label-width="200px">
        <el-form-item label="M1/35对应列">
          <el-select
            v-model="mConfigForm.M1"
            multiple
            placeholder="请选择M1对应的列"
            style="width: 100%"
          >
            <el-option-group
              v-for="(section, sectionKey) in finalPaperTableColumnsForDisplay"
              :key="sectionKey"
              :label="sectionKey"
            >
              <el-option
                v-for="(subCol, subKey) in section.subColumns"
                :key="`${sectionKey}-${subKey}`"
                :label="`${sectionKey}-${subKey === 'total' ? '总分' : subKey}`"
                :value="`${sectionKey}-${subKey}`"
              />
            </el-option-group>
          </el-select>
          <div style="color: #909399; font-size: 12px; margin-top: 5px">
            默认：一-总分 + 三-1
          </div>
        </el-form-item>
        
        <el-form-item label="M2/20对应列">
          <el-select
            v-model="mConfigForm.M2"
            multiple
            placeholder="请选择M2对应的列"
            style="width: 100%"
          >
            <el-option-group
              v-for="(section, sectionKey) in finalPaperTableColumnsForDisplay"
              :key="sectionKey"
              :label="sectionKey"
            >
              <el-option
                v-for="(subCol, subKey) in section.subColumns"
                :key="`${sectionKey}-${subKey}`"
                :label="`${sectionKey}-${subKey === 'total' ? '总分' : subKey}`"
                :value="`${sectionKey}-${subKey}`"
              />
            </el-option-group>
          </el-select>
          <div style="color: #909399; font-size: 12px; margin-top: 5px">
            默认：二-2 + 二-3
          </div>
        </el-form-item>
        
        <el-form-item label="M3/35对应列">
          <el-select
            v-model="mConfigForm.M3"
            multiple
            placeholder="请选择M3对应的列"
            style="width: 100%"
          >
            <el-option-group
              v-for="(section, sectionKey) in finalPaperTableColumnsForDisplay"
              :key="sectionKey"
              :label="sectionKey"
            >
              <el-option
                v-for="(subCol, subKey) in section.subColumns"
                :key="`${sectionKey}-${subKey}`"
                :label="`${sectionKey}-${subKey === 'total' ? '总分' : subKey}`"
                :value="`${sectionKey}-${subKey}`"
              />
            </el-option-group>
          </el-select>
          <div style="color: #909399; font-size: 12px; margin-top: 5px">
            默认：二-1 + 三-2 + 三-3
          </div>
        </el-form-item>
        
        <el-form-item label="M4/10对应列">
          <el-select
            v-model="mConfigForm.M4"
            multiple
            placeholder="请选择M4对应的列"
            style="width: 100%"
          >
            <el-option-group
              v-for="(section, sectionKey) in finalPaperTableColumnsForDisplay"
              :key="sectionKey"
              :label="sectionKey"
            >
              <el-option
                v-for="(subCol, subKey) in section.subColumns"
                :key="`${sectionKey}-${subKey}`"
                :label="`${sectionKey}-${subKey === 'total' ? '总分' : subKey}`"
                :value="`${sectionKey}-${subKey}`"
              />
            </el-option-group>
          </el-select>
          <div style="color: #909399; font-size: 12px; margin-top: 5px">
            默认：四-总分
          </div>
        </el-form-item>
      </el-form>
      
      <template #footer>
        <el-button @click="handleResetMConfig">恢复默认</el-button>
        <el-button @click="showMConfigDialog = false">取消</el-button>
        <el-button type="primary" @click="handleSaveMConfig">保存配置</el-button>
      </template>
    </el-dialog>
    
    <!-- 编辑/新增算法成绩对话框 -->
    <el-dialog
      v-model="editAlgorithmScoreDialogVisible"
      :title="editingAlgorithmScore ? '编辑算法成绩' : '新增算法成绩'"
      width="900px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="editAlgorithmScoreFormRef"
        :model="editAlgorithmScoreForm"
        label-width="150px"
      >
        <el-form-item label="学号" prop="student_id" :rules="[{ required: true, message: '请选择学生', trigger: 'change' }]">
          <el-select
            v-model="editAlgorithmScoreForm.student_id"
            placeholder="请选择学生"
            filterable
            style="width: 100%"
            :disabled="!!editingAlgorithmScore"
            @change="handleStudentChange"
          >
            <el-option
              v-for="gb in gradebookList"
              :key="gb.student_id"
              :label="`${gb.student_id} - ${gb.student_name}`"
              :value="gb.student_id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="姓名" prop="student_name">
          <el-input 
            v-model="editAlgorithmScoreForm.student_name" 
            placeholder="自动填充"
            disabled
          />
        </el-form-item>
        
        <el-divider>平时成绩</el-divider>
        <el-form-item label="课堂表现">
          <el-input-number
            v-model="editAlgorithmScoreForm.class_performance"
            :min="0"
            :max="100"
            :precision="2"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="笔记">
          <el-input-number
            v-model="editAlgorithmScoreForm.note_score"
            :min="0"
            :max="100"
            :precision="2"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="作业平均">
          <el-input-number
            v-model="editAlgorithmScoreForm.homework_avg"
            :min="0"
            :max="100"
            :precision="2"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="实验平均">
          <el-input-number
            v-model="editAlgorithmScoreForm.experiment_avg"
            :min="0"
            :max="100"
            :precision="2"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="平时成绩">
          <el-input-number
            v-model="editAlgorithmScoreForm.usual_score"
            :min="0"
            :max="100"
            :precision="0"
            style="width: 100%"
          />
        </el-form-item>
        
        <el-divider>卷面成绩</el-divider>
        <el-form-item label="M1/35">
          <el-input-number
            v-model="editAlgorithmScoreForm.M1"
            :min="0"
            :max="35"
            :precision="2"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="M2/20">
          <el-input-number
            v-model="editAlgorithmScoreForm.M2"
            :min="0"
            :max="20"
            :precision="2"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="M3/35">
          <el-input-number
            v-model="editAlgorithmScoreForm.M3"
            :min="0"
            :max="35"
            :precision="2"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="M4/10">
          <el-input-number
            v-model="editAlgorithmScoreForm.M4"
            :min="0"
            :max="10"
            :precision="2"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="卷面成绩">
          <el-input-number
            v-model="editAlgorithmScoreForm.final_paper_score"
            :min="0"
            :max="100"
            :precision="2"
            style="width: 100%"
          />
        </el-form-item>
        
        <el-divider>成绩录入</el-divider>
        <el-form-item label="平时录入">
          <el-input-number
            v-model="editAlgorithmScoreForm.usual_entry"
            :min="0"
            :max="100"
            :precision="0"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="期末录入">
          <el-input-number
            v-model="editAlgorithmScoreForm.final_entry"
            :min="0"
            :max="100"
            :precision="2"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="最终成绩">
          <el-input-number
            v-model="editAlgorithmScoreForm.final_grade"
            :min="0"
            :max="100"
            :precision="0"
            style="width: 100%"
          />
        </el-form-item>
      </el-form>
      
      <template #footer>
        <el-button @click="editAlgorithmScoreDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSaveAlgorithmScore" :loading="saving">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Upload, Download, Plus, UploadFilled, Refresh, Setting, Delete } from '@element-plus/icons-vue'
import {
  getGradebooks,
  createGradebook,
  updateGradebook,
  deleteGradebook,
  importGradebookExcel,
  exportGradebookExcel,
  getAlgorithmScores,
  getAlgorithmScore,
  createAlgorithmScore,
  updateAlgorithmScore,
  deleteAlgorithmScore,
  previewFinalPaperExcel,
  importFinalPaperExcel,
  recalculateAlgorithmScores,
  exportAlgorithmScoreExcel,
  getClassesWithAlgorithmScores
} from '@/api/scores'
import { getClasses } from '@/api/courses'

const loading = ref(false)
const saving = ref(false)
const importing = ref(false)
const recalculating = ref(false)
const gradebookList = ref([])
const algorithmScoreList = ref([])
const classes = ref([])
const classesWithAlgorithmScores = ref([])
const loadingClasses = ref(false)
const editDialogVisible = ref(false)
const importDialogVisible = ref(false)
const importFinalPaperDialogVisible = ref(false)
const editAlgorithmScoreDialogVisible = ref(false)
const editFormRef = ref(null)
const editAlgorithmScoreFormRef = ref(null)
const selectedAlgorithmScores = ref([]) // 选中的算法成绩记录
const uploadRef = ref(null)
const finalPaperUploadRef = ref(null)
const fileList = ref([])
const finalPaperFileList = ref([])
const activeTab = ref('gradebook') // 当前激活的标签页
const previewData = ref([]) // 预览数据
const previewVisible = ref(false) // 是否显示预览
const previewing = ref(false) // 预览中
const previewQuestionStructure = ref({}) // 预览数据的题目结构
const editFinalPaperDialogVisible = ref(false) // 编辑卷面成绩对话框
const editFinalPaperFormRef = ref(null) // 编辑表单引用
const editFinalPaperForm = ref({}) // 编辑表单数据
const editingFinalPaperScore = ref(null) // 正在编辑的记录
const editingAlgorithmScore = ref(null) // 正在编辑的算法成绩记录
const editAlgorithmScoreForm = reactive({
  id: null,
  student_id: '',
  student_name: '',
  course_class_id: null,
  class_performance: null,
  note_score: null,
  homework_avg: null,
  experiment_avg: null,
  usual_score: null,
  M1: null,
  M2: null,
  M3: null,
  M4: null,
  final_paper_score: null,
  usual_entry: null,
  final_entry: null,
  final_grade: null
})
const showMConfigDialog = ref(false) // M列配置对话框
const mConfigForm = ref({
  M1: ['一-total', '三-1'], // 默认：第一大题总分 + 第三大题第一小题
  M2: ['二-2', '二-3'], // 默认：第二大题第二小题 + 第二大题第三小题
  M3: ['二-1', '三-2', '三-3'], // 默认：第二大题第一小题 + 第三大题第二小题 + 第三大题第三小题
  M4: ['四-total'] // 默认：第四大题总分
})

// 解析预览数据，生成表格列配置
const previewTableColumns = computed(() => {
  const columns = {}
  // 定义大题的标准顺序
  const sectionOrder = ['一', '二', '三', '四', '卷面']
  
  // 优先使用后端返回的题目结构
  if (previewQuestionStructure.value && Object.keys(previewQuestionStructure.value).length > 0) {
    Object.keys(previewQuestionStructure.value).forEach(sectionKey => {
      const section = previewQuestionStructure.value[sectionKey]
      if (section && typeof section === 'object') {
        columns[sectionKey] = {
          subColumns: {},
          minWidth: 100,
          order: sectionOrder.indexOf(sectionKey) >= 0 ? sectionOrder.indexOf(sectionKey) : 999
        }
        
        // 从题目结构中提取所有子题
        Object.keys(section).forEach(subKey => {
          columns[sectionKey].subColumns[subKey] = true
        })
      }
    })
  } else if (previewData.value && previewData.value.length > 0) {
    // 如果没有题目结构，从数据中推断
    previewData.value.forEach(row => {
      if (row.scores && typeof row.scores === 'object') {
        Object.keys(row.scores).forEach(sectionKey => {
          if (!columns[sectionKey]) {
            columns[sectionKey] = {
              subColumns: {},
              minWidth: 100,
              order: sectionOrder.indexOf(sectionKey) >= 0 ? sectionOrder.indexOf(sectionKey) : 999
            }
          }
          
          const section = row.scores[sectionKey]
          if (section && typeof section === 'object') {
            Object.keys(section).forEach(subKey => {
              if (!columns[sectionKey].subColumns[subKey]) {
                columns[sectionKey].subColumns[subKey] = true
              }
            })
          }
        })
      }
    })
  }
  
  // 计算每个大题的最小宽度（根据子题数量）
  Object.keys(columns).forEach(sectionKey => {
    const subCount = Object.keys(columns[sectionKey].subColumns).length
    columns[sectionKey].minWidth = Math.max(100, subCount * 90)
    
    // 对子题进行排序：total排在最后，数字题号按数字大小排序
    const subKeys = Object.keys(columns[sectionKey].subColumns)
    subKeys.sort((a, b) => {
      if (a === 'total') return 1
      if (b === 'total') return -1
      const numA = parseInt(a)
      const numB = parseInt(b)
      if (!isNaN(numA) && !isNaN(numB)) {
        return numA - numB
      }
      return a.localeCompare(b)
    })
    
    // 重新构建有序的subColumns对象
    const orderedSubColumns = {}
    subKeys.forEach(key => {
      orderedSubColumns[key] = true
    })
    columns[sectionKey].subColumns = orderedSubColumns
  })
  
  // 按照标准顺序排序
  const orderedColumns = {}
  const sortedKeys = Object.keys(columns).sort((a, b) => {
    return columns[a].order - columns[b].order
  })
  sortedKeys.forEach(key => {
    orderedColumns[key] = columns[key]
  })
  
  return orderedColumns
})

// 获取分数值的辅助函数
const getScoreValue = (scores, sectionKey, subKey) => {
  if (!scores || !scores[sectionKey]) {
    return '-'
  }
  const value = scores[sectionKey][subKey]
  return value !== null && value !== undefined ? value : '-'
}

// 判断是否是算法分析与设计课程
const isAlgorithmCourse = computed(() => {
  if (!searchForm.course_class_id) return false
  const selectedClass = classes.value.find(cls => cls.id === searchForm.course_class_id)
  const courseName = selectedClass?.course_name || ''
  return courseName.includes('算法分析与设计') || courseName.includes('算法设计与分析') || false
})

// 步骤状态计算
const gradebookStepStatus = computed(() => {
  if (gradebookList.value.length > 0) return 'success'
  return 'wait'
})

const finalPaperStepStatus = computed(() => {
  // 检查是否有原始卷面成绩数据
  if (algorithmScoreList.value.length > 0 && algorithmScoreList.value.some(s => s.raw_paper_scores && Object.keys(s.raw_paper_scores).length > 0)) {
    return 'success'
  }
  if (gradebookList.value.length > 0) return 'wait'
  return 'wait'
})

const finalScoreStepStatus = computed(() => {
  if (algorithmScoreList.value.length > 0 && algorithmScoreList.value.some(s => s.total_score !== null)) {
    return 'success'
  }
  if (algorithmScoreList.value.length > 0 && algorithmScoreList.value.some(s => s.final_paper_score !== null)) {
    return 'wait'
  }
  return 'wait'
})

const currentStep = computed(() => {
  if (finalScoreStepStatus.value === 'success') return 2
  if (finalPaperStepStatus.value === 'success') return 1
  if (gradebookStepStatus.value === 'success') return 0
  return 0
})

// 步骤描述
const gradebookStatus = computed(() => {
  const count = gradebookList.value.length
  if (count > 0) return `已完成 (${count}条记录)`
  return '请先导入或新增记分册数据'
})

const finalPaperStatus = computed(() => {
  if (gradebookList.value.length === 0) return '需先完成步骤1'
  const hasPaperScore = algorithmScoreList.value.some(s => s.final_paper_score !== null)
  if (hasPaperScore) {
    const count = algorithmScoreList.value.filter(s => s.final_paper_score !== null).length
    return `已完成 (${count}条记录)`
  }
  return '请导入卷面成绩'
})

const finalScoreStatus = computed(() => {
  if (algorithmScoreList.value.length === 0 || !algorithmScoreList.value.some(s => s.final_paper_score !== null)) {
    return '需先完成步骤1和步骤2'
  }
  const hasTotalScore = algorithmScoreList.value.some(s => s.total_score !== null)
  if (hasTotalScore) {
    const count = algorithmScoreList.value.filter(s => s.total_score !== null).length
    return `已完成 (${count}条记录)`
  }
  return '请点击重新计算生成最终成绩'
})

// 提示信息
const gradebookAlertTitle = computed(() => {
  if (gradebookList.value.length > 0) {
    return `记分册数据已加载 (${gradebookList.value.length}条)，请确保数据完整后进入下一步`
  }
  return '请先导入或新增记分册数据，这是后续步骤的基础'
})

const gradebookAlertType = computed(() => {
  return gradebookList.value.length > 0 ? 'success' : 'warning'
})

const finalPaperAlertTitle = computed(() => {
  if (gradebookList.value.length === 0) {
    return '请先完成步骤1：导入记分册数据'
  }
  const hasPaperScore = algorithmScoreList.value.some(s => s.final_paper_score !== null)
  if (hasPaperScore) {
    const count = algorithmScoreList.value.filter(s => s.final_paper_score !== null).length
    return `卷面成绩已导入 (${count}条)，可以进入下一步计算最终成绩`
  }
  return '请导入卷面成绩Excel文件（包含M1、M2、M3、M4等题目得分）'
})

const finalPaperAlertType = computed(() => {
  if (gradebookList.value.length === 0) return 'error'
  const hasPaperScore = algorithmScoreList.value.some(s => s.final_paper_score !== null)
  return hasPaperScore ? 'success' : 'warning'
})

const finalScoreAlertTitle = computed(() => {
  if (gradebookList.value.length === 0) {
    return '请先完成步骤1：导入记分册数据'
  }
  if (!algorithmScoreList.value.some(s => s.final_paper_score !== null)) {
    return '请先完成步骤2：导入卷面成绩'
  }
  const hasTotalScore = algorithmScoreList.value.some(s => s.total_score !== null)
  if (hasTotalScore) {
    const count = algorithmScoreList.value.filter(s => s.total_score !== null).length
    return `最终成绩已计算 (${count}条)，可以导出成绩表`
  }
  return '请点击"重新计算"按钮生成最终成绩和课程目标达成度'
})

const finalScoreAlertType = computed(() => {
  if (gradebookList.value.length === 0 || !algorithmScoreList.value.some(s => s.final_paper_score !== null)) {
    return 'error'
  }
  const hasTotalScore = algorithmScoreList.value.some(s => s.total_score !== null)
  return hasTotalScore ? 'success' : 'warning'
})

// 步骤2表格数据（合并记分册和算法成绩数据）
const finalPaperTableData = computed(() => {
  if (algorithmScoreList.value.length > 0) {
    // 如果有算法成绩数据，直接使用
    return algorithmScoreList.value
  } else if (gradebookList.value.length > 0) {
    // 如果算法成绩数据为空，但记分册有数据，根据记分册生成表格数据
    return gradebookList.value.map(gb => ({
      student_id: gb.student_id,
      student_name: gb.student_name,
      raw_paper_scores: null
    }))
  }
  return []
})

// 检查是否有原始卷面成绩数据
const hasRawScores = computed(() => {
  return finalPaperTableData.value.some(row => row.raw_paper_scores && Object.keys(row.raw_paper_scores).length > 0)
})

// 生成步骤2表格的列配置（基于已导入的数据）
const finalPaperTableColumns = computed(() => {
  const columns = {}
  // 定义大题的标准顺序
  const sectionOrder = ['一', '二', '三', '四', '卷面']
  
  // 从已导入的数据中提取所有大题和子题
  finalPaperTableData.value.forEach(row => {
    if (row.raw_paper_scores && typeof row.raw_paper_scores === 'object') {
      Object.keys(row.raw_paper_scores).forEach(sectionKey => {
        if (!columns[sectionKey]) {
          columns[sectionKey] = {
            subColumns: {},
            minWidth: 100,
            order: sectionOrder.indexOf(sectionKey) >= 0 ? sectionOrder.indexOf(sectionKey) : 999
          }
        }
        
        const section = row.raw_paper_scores[sectionKey]
        if (section && typeof section === 'object') {
          Object.keys(section).forEach(subKey => {
            if (!columns[sectionKey].subColumns[subKey]) {
              columns[sectionKey].subColumns[subKey] = true
            }
          })
        }
      })
    }
  })
  
  // 计算每个大题的最小宽度（根据子题数量）
  Object.keys(columns).forEach(sectionKey => {
    const subCount = Object.keys(columns[sectionKey].subColumns).length
    columns[sectionKey].minWidth = Math.max(100, subCount * 90)
    
    // 对子题进行排序：total排在最后，数字题号按数字大小排序
    const subKeys = Object.keys(columns[sectionKey].subColumns)
    subKeys.sort((a, b) => {
      if (a === 'total') return 1
      if (b === 'total') return -1
      const numA = parseInt(a)
      const numB = parseInt(b)
      if (!isNaN(numA) && !isNaN(numB)) {
        return numA - numB
      }
      return a.localeCompare(b)
    })
    
    // 重新构建有序的subColumns对象
    const orderedSubColumns = {}
    subKeys.forEach(key => {
      orderedSubColumns[key] = true
    })
    columns[sectionKey].subColumns = orderedSubColumns
  })
  
  // 按照标准顺序排序
  const orderedColumns = {}
  const sortedKeys = Object.keys(columns).sort((a, b) => {
    return columns[a].order - columns[b].order
  })
  sortedKeys.forEach(key => {
    orderedColumns[key] = columns[key]
  })
  
  return orderedColumns
})

// 用于显示的表格列配置（优先使用预览数据的结构，如果没有则使用已导入数据的结构）
const finalPaperTableColumnsForDisplay = computed(() => {
  // 如果有预览数据的题目结构，优先使用
  if (previewQuestionStructure.value && Object.keys(previewQuestionStructure.value).length > 0) {
    const columns = {}
    const sectionOrder = ['一', '二', '三', '四', '卷面']
    
    Object.keys(previewQuestionStructure.value).forEach(sectionKey => {
      const section = previewQuestionStructure.value[sectionKey]
      if (section && typeof section === 'object') {
        columns[sectionKey] = {
          subColumns: {},
          minWidth: 100,
          order: sectionOrder.indexOf(sectionKey) >= 0 ? sectionOrder.indexOf(sectionKey) : 999
        }
        
        // 从题目结构中提取所有子题
        Object.keys(section).forEach(subKey => {
          columns[sectionKey].subColumns[subKey] = true
        })
      }
    })
    
    // 计算每个大题的最小宽度
    Object.keys(columns).forEach(sectionKey => {
      const subCount = Object.keys(columns[sectionKey].subColumns).length
      columns[sectionKey].minWidth = Math.max(100, subCount * 90)
      
      // 对子题进行排序：数字题号在前，total在后
      const subKeys = Object.keys(columns[sectionKey].subColumns)
      subKeys.sort((a, b) => {
        if (a === 'total') return 1
        if (b === 'total') return -1
        const numA = parseInt(a)
        const numB = parseInt(b)
        if (!isNaN(numA) && !isNaN(numB)) {
          return numA - numB
        }
        return a.localeCompare(b)
      })
      
      const orderedSubColumns = {}
      subKeys.forEach(key => {
        orderedSubColumns[key] = true
      })
      columns[sectionKey].subColumns = orderedSubColumns
    })
    
    // 按照标准顺序排序
    const orderedColumns = {}
    const sortedKeys = Object.keys(columns).sort((a, b) => {
      return columns[a].order - columns[b].order
    })
    sortedKeys.forEach(key => {
      orderedColumns[key] = columns[key]
    })
    
    return orderedColumns
  }
  
  // 如果没有预览数据，尝试从预览数据本身推断结构
  if (previewData.value && previewData.value.length > 0) {
    const columns = {}
    const sectionOrder = ['一', '二', '三', '四', '卷面']
    
    previewData.value.forEach(row => {
      if (row.scores && typeof row.scores === 'object') {
        Object.keys(row.scores).forEach(sectionKey => {
          if (!columns[sectionKey]) {
            columns[sectionKey] = {
              subColumns: {},
              minWidth: 100,
              order: sectionOrder.indexOf(sectionKey) >= 0 ? sectionOrder.indexOf(sectionKey) : 999
            }
          }
          
          const section = row.scores[sectionKey]
          if (section && typeof section === 'object') {
            Object.keys(section).forEach(subKey => {
              if (!columns[sectionKey].subColumns[subKey]) {
                columns[sectionKey].subColumns[subKey] = true
              }
            })
          }
        })
      }
    })
    
    // 计算每个大题的最小宽度并排序
    Object.keys(columns).forEach(sectionKey => {
      const subCount = Object.keys(columns[sectionKey].subColumns).length
      columns[sectionKey].minWidth = Math.max(100, subCount * 90)
      
      const subKeys = Object.keys(columns[sectionKey].subColumns)
      subKeys.sort((a, b) => {
        if (a === 'total') return 1
        if (b === 'total') return -1
        const numA = parseInt(a)
        const numB = parseInt(b)
        if (!isNaN(numA) && !isNaN(numB)) {
          return numA - numB
        }
        return a.localeCompare(b)
      })
      
      const orderedSubColumns = {}
      subKeys.forEach(key => {
        orderedSubColumns[key] = true
      })
      columns[sectionKey].subColumns = orderedSubColumns
    })
    
    // 按照标准顺序排序
    const orderedColumns = {}
    const sortedKeys = Object.keys(columns).sort((a, b) => {
      return columns[a].order - columns[b].order
    })
    sortedKeys.forEach(key => {
      orderedColumns[key] = columns[key]
    })
    
    return orderedColumns
  }
  
  // 如果没有预览数据，使用已导入数据的结构
  return finalPaperTableColumns.value
})

// 获取原始小题得分（支持预览数据和已导入数据）
const getRawScore = (row, majorQ, minorQ) => {
  // 如果是预览数据，使用scores字段
  if (row.scores && row.scores[majorQ]) {
    const scores = row.scores[majorQ]
    if (minorQ === 'total' && (scores[minorQ] !== undefined || typeof scores === 'number')) {
      const value = typeof scores === 'number' ? scores : scores[minorQ]
      return value !== null && value !== undefined ? parseFloat(value).toFixed(2) : '-'
    }
    if (scores[minorQ] !== undefined && scores[minorQ] !== null) {
      return parseFloat(scores[minorQ]).toFixed(2)
    }
    return '-'
  }
  
  // 如果是已导入数据，使用raw_paper_scores字段
  if (!row.raw_paper_scores || !row.raw_paper_scores[majorQ]) {
    return '-'
  }
  const scores = row.raw_paper_scores[majorQ]
  if (minorQ === 'total' && (scores[minorQ] !== undefined || typeof scores === 'number')) {
    const value = typeof scores === 'number' ? scores : scores[minorQ]
    // 修复：0值也应该显示，不应该返回'-'
    return value !== null && value !== undefined ? parseFloat(value).toFixed(2) : '-'
  }
  
  // 处理键名匹配：支持"2"、"2.0"等格式
  let value = scores[minorQ]
  if (value === undefined || value === null) {
    // 尝试匹配"2.0"格式的键
    for (const key in scores) {
      if (key !== 'total') {
        try {
          const keyNum = parseFloat(key)
          const minorQNum = parseFloat(minorQ)
          if (!isNaN(keyNum) && !isNaN(minorQNum) && Math.abs(keyNum - minorQNum) < 0.01) {
            value = scores[key]
            break
          }
        } catch (e) {
          // 忽略转换错误
        }
      }
    }
  }
  
  if (value !== undefined && value !== null) {
    // 修复：0值也应该显示，不应该返回'-'
    return parseFloat(value).toFixed(2)
  }
  return '-'
}

// 根据配置计算M值的辅助函数
const calculateMByConfig = (row, configList) => {
  if (!row.raw_paper_scores) return 0.0
  const scores = row.raw_paper_scores
  let total = 0.0
  
  configList.forEach(configItem => {
    const parts = configItem.split('-')
    if (parts.length !== 2) return
    const sectionKey = parts[0]
    const subKey = parts[1]
    
    if (!scores[sectionKey]) return
    
    const section = scores[sectionKey]
    if (typeof section === 'object' && section !== null) {
      if (subKey === 'total') {
        if (section.total !== undefined) {
          total += parseFloat(section.total) || 0
        } else {
          Object.values(section).forEach(val => {
            if (typeof val === 'number') {
              total += val
            }
          })
        }
      } else {
        for (const key in section) {
          const keyStr = String(key).trim()
          try {
            if (parseFloat(keyStr) === parseFloat(subKey)) {
              total += parseFloat(section[key]) || 0
              break
            }
          } catch (e) {
            // 忽略转换错误
          }
        }
      }
    } else if (typeof section === 'number') {
      total += section
    }
  })
  
  return total
}

// 计算M1/35（支持配置）
const calculateM1 = (row) => {
  // 优先使用后端计算的值
  if (row.M1 !== null && row.M1 !== undefined) {
    return Math.min(row.M1, 35.0).toFixed(2)
  }
  
  if (!row.raw_paper_scores) return '-'
  
  // 获取配置
  const savedConfig = localStorage.getItem('algorithm_m_config')
  let config = mConfigForm.value
  if (savedConfig) {
    try {
      config = JSON.parse(savedConfig)
    } catch (e) {
      // 使用默认配置
    }
  }
  
  const m1Config = config.M1 || ['一-total', '三-1']
  const M1 = calculateMByConfig(row, m1Config)
  return M1 > 0 ? Math.min(M1, 35.0).toFixed(2) : (M1 === 0 ? '0.00' : '-')
}

// 计算M2/20（支持配置）
const calculateM2 = (row) => {
  // 优先使用后端计算的值
  if (row.M2 !== null && row.M2 !== undefined) {
    return Math.min(row.M2, 20.0).toFixed(2)
  }
  
  if (!row.raw_paper_scores) return '-'
  
  // 获取配置
  const savedConfig = localStorage.getItem('algorithm_m_config')
  let config = mConfigForm.value
  if (savedConfig) {
    try {
      config = JSON.parse(savedConfig)
    } catch (e) {
      // 使用默认配置
    }
  }
  
  const m2Config = config.M2 || ['二-2', '二-3']
  const M2 = calculateMByConfig(row, m2Config)
  return M2 > 0 ? Math.min(M2, 20.0).toFixed(2) : (M2 === 0 ? '0.00' : '-')
}

// 计算M3/35（支持配置）
const calculateM3 = (row) => {
  // 优先使用后端计算的值
  if (row.M3 !== null && row.M3 !== undefined) {
    return Math.min(row.M3, 35.0).toFixed(2)
  }
  
  if (!row.raw_paper_scores) return '-'
  
  // 获取配置
  const savedConfig = localStorage.getItem('algorithm_m_config')
  let config = mConfigForm.value
  if (savedConfig) {
    try {
      config = JSON.parse(savedConfig)
    } catch (e) {
      // 使用默认配置
    }
  }
  
  const m3Config = config.M3 || ['二-1', '三-2', '三-3']
  const M3 = calculateMByConfig(row, m3Config)
  return M3 > 0 ? Math.min(M3, 35.0).toFixed(2) : (M3 === 0 ? '0.00' : '-')
}

// 计算M4/10（支持配置）
// 计算M4/10（支持配置）
const calculateM4 = (row) => {
  // 优先使用后端计算的值
  if (row.M4 !== null && row.M4 !== undefined) {
    return Math.min(row.M4, 10.0).toFixed(2)
  }
  
  if (!row.raw_paper_scores) return '-'
  
  // 获取配置
  const savedConfig = localStorage.getItem('algorithm_m_config')
  let config = mConfigForm.value
  if (savedConfig) {
    try {
      config = JSON.parse(savedConfig)
    } catch (e) {
      // 使用默认配置
    }
  }
  
  const m4Config = config.M4 || ['四-total']
  const M4 = calculateMByConfig(row, m4Config)
  return M4 > 0 ? Math.min(M4, 10.0).toFixed(2) : (M4 === 0 ? '0.00' : '-')
}

// 计算卷面 = 优先使用本地导入的表格的"卷面"字段，如果不存在则使用计算值（M1 + M2 + M3 + M4）
const calculateFinalPaperScore = (row) => {
  if (!row.raw_paper_scores) return '-'
  const scores = row.raw_paper_scores
  
  // 优先使用"卷面"字段
  if (scores['卷面']) {
    const sectionPaper = scores['卷面']
    if (typeof sectionPaper === 'object' && sectionPaper !== null) {
      if (sectionPaper.total !== undefined && sectionPaper.total !== null) {
        return parseFloat(sectionPaper.total).toFixed(2)
      }
    } else if (typeof sectionPaper === 'number') {
      return sectionPaper.toFixed(2)
    }
  }
  
  // 如果不存在，使用计算值（M1 + M2 + M3 + M4）
  const M1 = parseFloat(calculateM1(row)) || 0
  const M2 = parseFloat(calculateM2(row)) || 0
  const M3 = parseFloat(calculateM3(row)) || 0
  const M4 = parseFloat(calculateM4(row)) || 0
  const total = M1 + M2 + M3 + M4
  
  return total > 0 ? total.toFixed(2) : (total === 0 ? '0.00' : '-')
}

// 获取编辑表单中的分数值
const getEditFormScore = (sectionKey, subKey) => {
  if (!editFinalPaperForm.value.scores || !editFinalPaperForm.value.scores[sectionKey]) {
    return null
  }
  return editFinalPaperForm.value.scores[sectionKey][subKey] ?? null
}

// 设置编辑表单中的分数值
const setEditFormScore = (sectionKey, subKey, value) => {
  if (!editFinalPaperForm.value.scores) {
    editFinalPaperForm.value.scores = {}
  }
  if (!editFinalPaperForm.value.scores[sectionKey]) {
    editFinalPaperForm.value.scores[sectionKey] = {}
  }
  editFinalPaperForm.value.scores[sectionKey][subKey] = value
}

// 获取期末录入值（与卷面成绩一致）
const getFinalEntryValue = (row) => {
  const paperScore = calculateFinalPaperScore(row)
  if (paperScore === '-') {
    return '-'
  }
  const score = parseFloat(paperScore)
  return isNaN(score) ? '-' : Math.round(score)
}

// 课程目标1计算函数
const calculateObj1Classroom = (row) => {
  const classPerformance = row.class_performance || 0
  const value = classPerformance * 0.05 * 0.4
  return value.toFixed(2)
}

const calculateObj1Note = (row) => {
  const noteScore = row.note_score || 0
  const value = noteScore * 0.05 * 0.4
  return value.toFixed(2)
}

const calculateObj1Homework = (row) => {
  const homeworkAvg = row.homework_avg || 0
  const value = homeworkAvg * 0.1 * 0.4
  return value.toFixed(2)
}

const calculateObj1Experiment = (row) => {
  return '0.00'
}

const calculateObj1Final = (row) => {
  const M1Str = calculateM1(row)
  if (M1Str === '-') return '0.00'
  const M1 = parseFloat(M1Str) || 0
  const value = M1 * 0.6
  return value.toFixed(2)
}

const calculateObj1Achievement = (row) => {
  // 优先使用后端计算的值
  if (row.obj1_achievement !== null && row.obj1_achievement !== undefined) {
    return parseFloat(row.obj1_achievement).toFixed(2)
  }
  const classroom = parseFloat(calculateObj1Classroom(row)) || 0
  const note = parseFloat(calculateObj1Note(row)) || 0
  const homework = parseFloat(calculateObj1Homework(row)) || 0
  const experiment = parseFloat(calculateObj1Experiment(row)) || 0
  const final = parseFloat(calculateObj1Final(row)) || 0
  const value = classroom + note + homework + experiment + final
  return value.toFixed(2)
}

const calculateObj1Degree = (row) => {
  // 优先使用后端计算的值
  if (row.obj1_degree !== null && row.obj1_degree !== undefined) {
    return parseFloat(row.obj1_degree).toFixed(2)
  }
  const achievement = parseFloat(calculateObj1Achievement(row)) || 0
  const value = achievement / 29.0
  return value.toFixed(2)
}

// 课程目标2计算函数
const calculateObj2Classroom = (row) => {
  const classPerformance = row.class_performance || 0
  const value = classPerformance * 0.05 * 0.3
  return value.toFixed(2)
}

const calculateObj2Note = (row) => {
  const noteScore = row.note_score || 0
  const value = noteScore * 0.05 * 0.3
  return value.toFixed(2)
}

const calculateObj2Homework = (row) => {
  const homeworkAvg = row.homework_avg || 0
  const value = homeworkAvg * 0.1 * 0.3
  return value.toFixed(2)
}

const calculateObj2Experiment = (row) => {
  const experimentAvg = row.experiment_avg || 0
  const value = experimentAvg * 0.2 * 0.4
  return value.toFixed(2)
}

const calculateObj2Final = (row) => {
  const M2Str = calculateM2(row)
  if (M2Str === '-') return '0.00'
  const M2 = parseFloat(M2Str) || 0
  const value = M2 * 0.6
  return value.toFixed(2)
}

const calculateObj2Achievement = (row) => {
  // 优先使用后端计算的值
  if (row.obj2_achievement !== null && row.obj2_achievement !== undefined) {
    return parseFloat(row.obj2_achievement).toFixed(2)
  }
  const classroom = parseFloat(calculateObj2Classroom(row)) || 0
  const note = parseFloat(calculateObj2Note(row)) || 0
  const homework = parseFloat(calculateObj2Homework(row)) || 0
  const experiment = parseFloat(calculateObj2Experiment(row)) || 0
  const final = parseFloat(calculateObj2Final(row)) || 0
  const value = classroom + note + homework + experiment + final
  return value.toFixed(2)
}

const calculateObj2Degree = (row) => {
  // 优先使用后端计算的值
  if (row.obj2_degree !== null && row.obj2_degree !== undefined) {
    return parseFloat(row.obj2_degree).toFixed(2)
  }
  const achievement = parseFloat(calculateObj2Achievement(row)) || 0
  const value = achievement / 26.0
  return value.toFixed(2)
}

// 课程目标3计算函数
const calculateObj3Classroom = (row) => {
  const classPerformance = row.class_performance || 0
  const value = classPerformance * 0.05 * 0.3
  return value.toFixed(2)
}

const calculateObj3Note = (row) => {
  const noteScore = row.note_score || 0
  const value = noteScore * 0.05 * 0.3
  return value.toFixed(2)
}

const calculateObj3Homework = (row) => {
  const homeworkAvg = row.homework_avg || 0
  const value = homeworkAvg * 0.1 * 0.3
  return value.toFixed(2)
}

const calculateObj3Experiment = (row) => {
  const experimentAvg = row.experiment_avg || 0
  const value = experimentAvg * 0.2 * 0.2
  return value.toFixed(2)
}

const calculateObj3Final = (row) => {
  const M3Str = calculateM3(row)
  if (M3Str === '-') return '0.00'
  const M3 = parseFloat(M3Str) || 0
  // 注意：M3/31，需要将M3转换为31分制
  // M3原始值是35分制，需要转换为31分制：M3 * (31/35)
  const M3_31 = M3 * (31 / 35)
  const value = M3_31 * 0.6
  return value.toFixed(2)
}

const calculateObj3Achievement = (row) => {
  // 优先使用后端计算的值
  if (row.obj3_achievement !== null && row.obj3_achievement !== undefined) {
    return parseFloat(row.obj3_achievement).toFixed(2)
  }
  const classroom = parseFloat(calculateObj3Classroom(row)) || 0
  const note = parseFloat(calculateObj3Note(row)) || 0
  const homework = parseFloat(calculateObj3Homework(row)) || 0
  const experiment = parseFloat(calculateObj3Experiment(row)) || 0
  const final = parseFloat(calculateObj3Final(row)) || 0
  const value = classroom + note + homework + experiment + final
  return value.toFixed(2)
}

const calculateObj3Degree = (row) => {
  // 优先使用后端计算的值
  if (row.obj3_degree !== null && row.obj3_degree !== undefined) {
    return parseFloat(row.obj3_degree).toFixed(2)
  }
  const achievement = parseFloat(calculateObj3Achievement(row)) || 0
  // 课程目标3满分是31分
  const value = achievement / 31.0
  return value.toFixed(2)
}

// 课程目标4计算函数
const calculateObj4Classroom = (row) => {
  return '0.00'
}

const calculateObj4Note = (row) => {
  return '0.00'
}

const calculateObj4Homework = (row) => {
  return '0.00'
}

const calculateObj4Experiment = (row) => {
  const experimentAvg = row.experiment_avg || 0
  const value = experimentAvg * 0.2 * 0.4
  return value.toFixed(2)
}

const calculateObj4Final = (row) => {
  const M4Str = calculateM4(row)
  if (M4Str === '-') return '0.00'
  const M4 = parseFloat(M4Str) || 0
  const value = M4 * 0.6
  return value.toFixed(2)
}

const calculateObj4Achievement = (row) => {
  // 优先使用后端计算的值
  if (row.obj4_achievement !== null && row.obj4_achievement !== undefined) {
    return parseFloat(row.obj4_achievement).toFixed(2)
  }
  const classroom = parseFloat(calculateObj4Classroom(row)) || 0
  const note = parseFloat(calculateObj4Note(row)) || 0
  const homework = parseFloat(calculateObj4Homework(row)) || 0
  const experiment = parseFloat(calculateObj4Experiment(row)) || 0
  const final = parseFloat(calculateObj4Final(row)) || 0
  const value = classroom + note + homework + experiment + final
  return value.toFixed(2)
}

const calculateObj4Degree = (row) => {
  // 优先使用后端计算的值
  if (row.obj4_degree !== null && row.obj4_degree !== undefined) {
    return parseFloat(row.obj4_degree).toFixed(2)
  }
  const achievement = parseFloat(calculateObj4Achievement(row)) || 0
  const value = achievement / 14.0
  return value.toFixed(2)
}

// 标签页切换
const handleTabChange = async (tabName) => {
  activeTab.value = tabName
  // 切换到步骤2或步骤3时，确保加载了算法成绩数据
  if ((tabName === 'finalPaper' || tabName === 'finalScore') && algorithmScoreList.value.length === 0 && gradebookList.value.length > 0) {
    // 等待一下，确保后端已经创建了AlgorithmScore记录
    await loadAlgorithmScores()
    // 如果还是没有数据，可能是后端还没有创建，再等一会
    if (algorithmScoreList.value.length === 0) {
      setTimeout(async () => {
        await loadAlgorithmScores()
      }, 1000)
    }
  }
}

// 导出记分册
const handleExportGradebook = async () => {
  if (!searchForm.course_class_id) {
    ElMessage.warning('请先选择课程班级')
    return
  }

  try {
    const response = await exportGradebookExcel({
      course_class_id: searchForm.course_class_id
    })
    
    const blob = new Blob([response.data], {
      type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    })
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `记分册_${new Date().getTime()}.xlsx`
    link.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success('导出成功')
  } catch (error) {
    ElMessage.error('导出失败: ' + (error.response?.data?.message || error.message))
  }
}

// 达成度计算表
const statisticsTable = computed(() => {
  if (!algorithmScoreList.value || algorithmScoreList.value.length === 0) return []
  
  let obj1ScoreSum = 0, obj2ScoreSum = 0, obj3ScoreSum = 0, obj4ScoreSum = 0
  let obj1DegreeSum = 0, obj2DegreeSum = 0, obj3DegreeSum = 0, obj4DegreeSum = 0
  let obj1Count = 0, obj2Count = 0, obj3Count = 0, obj4Count = 0
  let obj1DegreeCount = 0, obj2DegreeCount = 0, obj3DegreeCount = 0, obj4DegreeCount = 0
  
  algorithmScoreList.value.forEach(score => {
    // 课程目标1
    if (score.obj1_achievement !== null && score.obj1_achievement !== undefined && !isNaN(score.obj1_achievement)) {
      obj1ScoreSum += parseFloat(score.obj1_achievement)
      obj1Count++
    }
    if (score.obj1_degree !== null && score.obj1_degree !== undefined && !isNaN(score.obj1_degree)) {
      obj1DegreeSum += parseFloat(score.obj1_degree)
      obj1DegreeCount++
    }
    
    // 课程目标2
    if (score.obj2_achievement !== null && score.obj2_achievement !== undefined && !isNaN(score.obj2_achievement)) {
      obj2ScoreSum += parseFloat(score.obj2_achievement)
      obj2Count++
    }
    if (score.obj2_degree !== null && score.obj2_degree !== undefined && !isNaN(score.obj2_degree)) {
      obj2DegreeSum += parseFloat(score.obj2_degree)
      obj2DegreeCount++
    }
    
    // 课程目标3
    if (score.obj3_achievement !== null && score.obj3_achievement !== undefined && !isNaN(score.obj3_achievement)) {
      obj3ScoreSum += parseFloat(score.obj3_achievement)
      obj3Count++
    }
    if (score.obj3_degree !== null && score.obj3_degree !== undefined && !isNaN(score.obj3_degree)) {
      obj3DegreeSum += parseFloat(score.obj3_degree)
      obj3DegreeCount++
    }
    
    // 课程目标4
    if (score.obj4_achievement !== null && score.obj4_achievement !== undefined && !isNaN(score.obj4_achievement)) {
      obj4ScoreSum += parseFloat(score.obj4_achievement)
      obj4Count++
    }
    if (score.obj4_degree !== null && score.obj4_degree !== undefined && !isNaN(score.obj4_degree)) {
      obj4DegreeSum += parseFloat(score.obj4_degree)
      obj4DegreeCount++
    }
  })
  
  // 计算平均值，保留两位小数
  return [
    {
      objective: '课程目标1',
      achievement_score: obj1Count > 0 ? parseFloat((obj1ScoreSum / obj1Count).toFixed(2)) : 0.00,
      achievement_degree: obj1DegreeCount > 0 ? parseFloat((obj1DegreeSum / obj1DegreeCount).toFixed(2)) : 0.00
    },
    {
      objective: '课程目标2',
      achievement_score: obj2Count > 0 ? parseFloat((obj2ScoreSum / obj2Count).toFixed(2)) : 0.00,
      achievement_degree: obj2DegreeCount > 0 ? parseFloat((obj2DegreeSum / obj2DegreeCount).toFixed(2)) : 0.00
    },
    {
      objective: '课程目标3',
      achievement_score: obj3Count > 0 ? parseFloat((obj3ScoreSum / obj3Count).toFixed(2)) : 0.00,
      achievement_degree: obj3DegreeCount > 0 ? parseFloat((obj3DegreeSum / obj3DegreeCount).toFixed(2)) : 0.00
    },
    {
      objective: '课程目标4',
      achievement_score: obj4Count > 0 ? parseFloat((obj4ScoreSum / obj4Count).toFixed(2)) : 0.00,
      achievement_degree: obj4DegreeCount > 0 ? parseFloat((obj4DegreeSum / obj4DegreeCount).toFixed(2)) : 0.00
    }
  ]
})

const searchForm = reactive({
  course_class_id: null,
  student_id: ''
})

const pagination = reactive({
  page: 1,
  pageSize: 20,
  total: 0
})

const editForm = reactive({
  id: null,
  student_id: '',
  student_name: '',
  course_class_id: null,
  homework1: null,
  homework2: null,
  homework3: null,
  homework4: null,
  homework5: null,
  experiment1: null,
  experiment2: null,
  attendance1: null,
  attendance2: null,
  attendance3: null,
  attendance4: null,
  attendance5: null,
  review_note: null,
  final_score: null
})

const editRules = {
  student_id: [{ required: true, message: '请输入学号', trigger: 'blur' }],
  student_name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  homework1: [{ type: 'number', min: 0, max: 100, message: '成绩必须在0-100之间', trigger: 'blur' }],
  homework2: [{ type: 'number', min: 0, max: 100, message: '成绩必须在0-100之间', trigger: 'blur' }],
  homework3: [{ type: 'number', min: 0, max: 100, message: '成绩必须在0-100之间', trigger: 'blur' }],
  homework4: [{ type: 'number', min: 0, max: 100, message: '成绩必须在0-100之间', trigger: 'blur' }],
  homework5: [{ type: 'number', min: 0, max: 100, message: '成绩必须在0-100之间', trigger: 'blur' }],
  experiment1: [{ type: 'number', min: 0, max: 100, message: '成绩必须在0-100之间', trigger: 'blur' }],
  experiment2: [{ type: 'number', min: 0, max: 100, message: '成绩必须在0-100之间', trigger: 'blur' }],
  attendance1: [{ type: 'number', min: 0, max: 100, message: '成绩必须在0-100之间', trigger: 'blur' }],
  attendance2: [{ type: 'number', min: 0, max: 100, message: '成绩必须在0-100之间', trigger: 'blur' }],
  attendance3: [{ type: 'number', min: 0, max: 100, message: '成绩必须在0-100之间', trigger: 'blur' }],
  attendance4: [{ type: 'number', min: 0, max: 100, message: '成绩必须在0-100之间', trigger: 'blur' }],
  attendance5: [{ type: 'number', min: 0, max: 100, message: '成绩必须在0-100之间', trigger: 'blur' }],
  review_note: [{ type: 'number', min: 0, max: 100, message: '成绩必须在0-100之间', trigger: 'blur' }],
  final_score: [{ type: 'number', min: 0, max: 100, message: '成绩必须在0-100之间', trigger: 'blur' }]
}

// 加载班级列表
const loadClasses = async () => {
  try {
    const response = await getClasses({ page_size: 1000 })
    const classList = response.results || response || []
    // 只显示算法相关的班级（算法分析与设计或算法设计与分析）
    classes.value = classList
      .map(cls => ({
        id: cls.id,
        course_name: cls.course?.course_name || cls.course_name || '',
        class_name: cls.class_name || ''
      }))
      .filter(cls => {
        const courseName = cls.course_name || ''
        return courseName.includes('算法分析与设计') || courseName.includes('算法设计与分析')
      })
  } catch (error) {
    console.error('加载班级列表失败:', error)
    ElMessage.error('加载班级列表失败')
  }
}

// 加载记分册列表
const loadGradebooks = async () => {
  if (!searchForm.course_class_id) {
    gradebookList.value = []
    return
  }

  loading.value = true
  try {
    // 传递大的page_size以获取所有记录
    const params = {
      course_class_id: searchForm.course_class_id,
      page_size: 1000,
      page: 1
    }
    if (searchForm.student_id) {
      // 这里需要后端支持按学号搜索，暂时前端过滤
    }
    const response = await getGradebooks(params)
    let allResults = response.results || response.data || []
    const totalCount = response.count || allResults.length
    
    // 如果有更多页面，继续获取所有数据
    let currentPage = 1
    let nextUrl = response.next
    while (nextUrl && allResults.length < totalCount) {
      currentPage++
      const nextResponse = await getGradebooks({
        course_class_id: searchForm.course_class_id,
        page_size: 1000,
        page: currentPage
      })
      if (nextResponse.results && Array.isArray(nextResponse.results)) {
        allResults = [...allResults, ...nextResponse.results]
      }
      nextUrl = nextResponse.next
    }
    
    gradebookList.value = allResults
    pagination.total = totalCount
  } catch (error) {
    console.error('加载记分册失败:', error)
    ElMessage.error('加载记分册失败: ' + (error.response?.data?.detail || error.message))
    gradebookList.value = []
  } finally {
    loading.value = false
  }
}

// 加载算法分析与设计成绩
const loadAlgorithmScores = async () => {
  if (!searchForm.course_class_id) {
    algorithmScoreList.value = []
    return
  }

  loading.value = true
  try {
    // 传递大的page_size以获取所有记录
    const params = {
      course_class_id: searchForm.course_class_id,
      page_size: 1000,
      page: 1
    }
    const response = await getAlgorithmScores(params)
    
    // 处理响应数据
    if (response.error) {
      console.error('API返回错误:', response.error)
      ElMessage.warning('加载算法成绩时出现问题: ' + response.error)
      algorithmScoreList.value = []
    } else if (response.results) {
      let allResults = Array.isArray(response.results) ? response.results : []
      const totalCount = response.count || allResults.length
      
      // 如果有更多页面，继续获取所有数据
      let currentPage = 1
      let nextUrl = response.next
      while (nextUrl && allResults.length < totalCount) {
        currentPage++
        const nextResponse = await getAlgorithmScores({
          course_class_id: searchForm.course_class_id,
          page_size: 1000,
          page: currentPage
        })
        if (nextResponse.results && Array.isArray(nextResponse.results)) {
          allResults = [...allResults, ...nextResponse.results]
        }
        nextUrl = nextResponse.next
      }
      
      algorithmScoreList.value = allResults
    } else if (Array.isArray(response)) {
      algorithmScoreList.value = response
    } else {
      algorithmScoreList.value = []
      console.warn('未识别的响应格式:', response)
    }
  } catch (error) {
    console.error('加载算法分析与设计成绩失败:', error)
    if (error.response?.data?.error) {
      ElMessage.error('加载失败: ' + error.response.data.error)
    }
    algorithmScoreList.value = []
  } finally {
    loading.value = false
  }
}

// 搜索
const handleSearch = async () => {
  pagination.page = 1
  await loadGradebooks()
  if (isAlgorithmCourse.value && gradebookList.value.length > 0) {
    // 先尝试加载算法成绩（会触发后端自动创建记录）
    await loadAlgorithmScores()
    // 如果还是没有数据，等待一下再加载（给后端时间创建记录）
    if (algorithmScoreList.value.length === 0) {
      setTimeout(async () => {
        await loadAlgorithmScores()
      }, 800)
    }
    // 如果记分册已加载，自动切换到记分册标签页
    activeTab.value = 'gradebook'
  }
}

// 重置
const handleReset = () => {
  searchForm.course_class_id = null
  searchForm.student_id = ''
  pagination.page = 1
  loadGradebooks()
}

// 分页
const handleSizeChange = (size) => {
  pagination.pageSize = size
  loadGradebooks()
}

const handlePageChange = (page) => {
  pagination.page = page
  loadGradebooks()
}

// 新增
const handleAdd = () => {
  Object.assign(editForm, {
    id: null,
    student_id: '',
    student_name: '',
    course_class_id: searchForm.course_class_id,
    homework1: null,
    homework2: null,
    homework3: null,
    homework4: null,
    homework5: null,
    experiment1: null,
    experiment2: null,
    attendance1: null,
    attendance2: null,
    attendance3: null,
    attendance4: null,
    attendance5: null,
    review_note: null,
    final_score: null
  })
  editDialogVisible.value = true
}

// 编辑
const handleEdit = (row) => {
  Object.assign(editForm, {
    id: row.id,
    student_id: row.student_id,
    student_name: row.student_name,
    course_class_id: row.course_class,
    homework1: row.homework1,
    homework2: row.homework2,
    homework3: row.homework3,
    homework4: row.homework4,
    homework5: row.homework5,
    experiment1: row.experiment1,
    experiment2: row.experiment2,
    attendance1: row.attendance1,
    attendance2: row.attendance2,
    attendance3: row.attendance3,
    attendance4: row.attendance4,
    attendance5: row.attendance5,
    review_note: row.review_note,
    final_score: row.final_score
  })
  editDialogVisible.value = true
}

// 删除
const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除学生 ${row.student_name} (${row.student_id}) 的记分册记录吗？`,
      '提示',
      { type: 'warning' }
    )
    await deleteGradebook(row.id)
    ElMessage.success('删除成功')
    await loadGradebooks()
    if (isAlgorithmCourse.value) {
      await loadAlgorithmScores()
    }
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error(error.response?.data?.error || error.response?.data?.message || '删除失败')
    }
  }
}

// 保存
const handleSave = async () => {
  if (!editFormRef.value) return

  await editFormRef.value.validate(async (valid) => {
    if (valid) {
      saving.value = true
      try {
        const data = {
          course_class_id: editForm.course_class_id,
          student_id: editForm.student_id,
          student_name: editForm.student_name,
          homework1: editForm.homework1,
          homework2: editForm.homework2,
          homework3: editForm.homework3,
          homework4: editForm.homework4,
          homework5: editForm.homework5,
          experiment1: editForm.experiment1,
          experiment2: editForm.experiment2,
          attendance1: editForm.attendance1,
          attendance2: editForm.attendance2,
          attendance3: editForm.attendance3,
          attendance4: editForm.attendance4,
          attendance5: editForm.attendance5,
          review_note: editForm.review_note,
          final_score: editForm.final_score
        }

        if (editForm.id) {
          await updateGradebook(editForm.id, data)
          ElMessage.success('更新成功')
        } else {
          await createGradebook(data)
          ElMessage.success('创建成功')
        }
        editDialogVisible.value = false
        await loadGradebooks()
        if (isAlgorithmCourse.value) {
          // 保存记分册后，如果是算法课程，应该已经自动创建了AlgorithmScore
          // 但需要重新计算以确保数据正确
          try {
            await recalculateAlgorithmScores({
              course_class_id: searchForm.course_class_id
            })
          } catch (error) {
            console.warn('自动重新计算失败:', error)
          }
          await loadAlgorithmScores()
        }
      } catch (error) {
        ElMessage.error(error.response?.data?.error || error.response?.data?.message || '保存失败')
      } finally {
        saving.value = false
      }
    }
  })
}

// 对话框关闭
const handleDialogClose = () => {
  editFormRef.value?.resetFields()
}

// 导入
const handleImport = () => {
  if (!searchForm.course_class_id) {
    ElMessage.warning('请先选择课程班级')
    return
  }
  fileList.value = []
  importDialogVisible.value = true
}

// 文件变化
const handleFileChange = (file) => {
  fileList.value = [file]
}

// 确认导入
const handleConfirmImport = async () => {
  if (fileList.value.length === 0) {
    ElMessage.warning('请选择要导入的文件')
    return
  }

  if (!searchForm.course_class_id) {
    ElMessage.warning('请先选择课程班级')
    return
  }

  importing.value = true
  try {
    const formData = new FormData()
    formData.append('file', fileList.value[0].raw)
    formData.append('course_class_id', String(searchForm.course_class_id))

    const response = await importGradebookExcel(formData)
    if (response.success) {
      ElMessage.success(response.message || '导入成功')
      importDialogVisible.value = false
      fileList.value = []
      // 确保course_class_id还在，然后刷新列表
      if (searchForm.course_class_id) {
        pagination.page = 1  // 重置到第一页
        await loadGradebooks()
        if (isAlgorithmCourse.value) {
          // 等待一下，让后端有时间自动创建AlgorithmScore记录
          setTimeout(async () => {
            await loadAlgorithmScores()
          }, 500)
        }
      }
    } else {
      let errorMsg = response.message || '导入失败'
      if (response.errors && response.errors.length > 0) {
        errorMsg += '\n' + response.errors.slice(0, 3).join('\n')
        console.error('导入错误详情:', response.errors)
      }
      if (response.data?.errors && response.data.errors.length > 0) {
        errorMsg += '\n' + response.data.errors.slice(0, 3).join('\n')
      }
      ElMessage.error(errorMsg)
    }
  } catch (error) {
    console.error('导入失败:', error)
    let errorMessage = error.response?.data?.message || 
                       error.response?.data?.detail || 
                       error.response?.data?.error || 
                       error.message || 
                       '导入失败'
    
    // 如果有详细错误信息，添加到消息中
    if (error.response?.data?.errors) {
      const errors = Array.isArray(error.response.data.errors) 
        ? error.response.data.errors 
        : [error.response.data.errors]
      if (errors.length > 0) {
        errorMessage += '\n' + errors.slice(0, 3).join('\n')
      }
      console.error('错误详情:', errors)
    }
    
    ElMessage.error(errorMessage)
  } finally {
    importing.value = false
  }
}

// 导入卷面成绩
const handleImportFinalPaper = () => {
  if (!searchForm.course_class_id) {
    ElMessage.warning('请先选择课程班级')
    return
  }
  finalPaperFileList.value = []
  importFinalPaperDialogVisible.value = true
}

const handleFinalPaperFileChange = (file) => {
  finalPaperFileList.value = [file]
  // 切换文件时清空预览数据
  previewData.value = []
  previewQuestionStructure.value = {}
}

const handleCancelImportFinalPaper = () => {
  importFinalPaperDialogVisible.value = false
  finalPaperFileList.value = []
  previewData.value = []
  previewQuestionStructure.value = {}
}

const handlePreviewFinalPaper = async () => {
  if (finalPaperFileList.value.length === 0) {
    ElMessage.warning('请先选择要上传的文件')
    return
  }

  previewing.value = true
  try {
    const formData = new FormData()
    formData.append('file', finalPaperFileList.value[0].raw)
    formData.append('course_class_id', searchForm.course_class_id)

    const response = await previewFinalPaperExcel(formData)
    if (response.success) {
      previewData.value = response.data || []
      previewQuestionStructure.value = response.question_structure || {}
      ElMessage.success(`预览成功，共 ${previewData.value.length} 条数据`)
    } else {
      ElMessage.error(response.message || '预览失败')
      previewData.value = []
      previewQuestionStructure.value = {}
    }
  } catch (error) {
    ElMessage.error(error.response?.data?.message || '预览失败')
    console.error(error)
      previewData.value = []
      previewQuestionStructure.value = {}
    } finally {
      previewing.value = false
    }
  }

const handleConfirmImportFinalPaper = async () => {
  if (finalPaperFileList.value.length === 0) {
    ElMessage.warning('请先选择要上传的文件')
    return
  }

  if (previewData.value.length === 0) {
    ElMessage.warning('请先预览数据，确认无误后再导入')
    return
  }

  importing.value = true
  try {
    const formData = new FormData()
    formData.append('file', finalPaperFileList.value[0].raw)
    formData.append('course_class_id', searchForm.course_class_id)

    const response = await importFinalPaperExcel(formData)
    if (response.success) {
      ElMessage.success(response.message || '导入成功，请到步骤3点击"重新计算"生成最终成绩')
      importFinalPaperDialogVisible.value = false
      finalPaperFileList.value = []
      previewData.value = []
      previewQuestionStructure.value = {}
      // 直接加载算法成绩数据（卷面成绩保存在AlgorithmScore中）
      // 等待一下确保后端数据已保存
      setTimeout(async () => {
        await loadAlgorithmScores()
        
        // 如果还是没有数据，再等一会重试
        if (algorithmScoreList.value.length === 0) {
          setTimeout(async () => {
            await loadAlgorithmScores()
          }, 1000)
        }
        // 导入成功后，切换到步骤2标签页查看结果
        activeTab.value = 'finalPaper'
      }, 800)
    } else {
      ElMessage.error(response.message || '导入失败')
    }
  } catch (error) {
    ElMessage.error(error.response?.data?.message || '导入失败')
    console.error(error)
  } finally {
    importing.value = false
  }
}

// 重新计算
const handleRecalculate = async () => {
  if (!searchForm.course_class_id) {
    ElMessage.warning('请先选择课程班级')
    return
  }

  try {
    await ElMessageBox.confirm('确定要重新计算所有学生的成绩吗？', '提示', {
      type: 'warning'
    })
    
    recalculating.value = true
    // 获取M列配置：优先使用当前对话框中的配置（用户可能刚修改但未保存），
    // 如果没有则从localStorage加载，最后使用默认配置
    let mConfig = null
    
    // 先检查 mConfigForm.value 是否有有效的配置（用户可能在对话框中修改了）
    // 注意：空数组也是有效配置，所以不能只用 || 判断
    if (mConfigForm.value && 
        (Array.isArray(mConfigForm.value.M1) || 
         Array.isArray(mConfigForm.value.M2) || 
         Array.isArray(mConfigForm.value.M3) || 
         Array.isArray(mConfigForm.value.M4))) {
      mConfig = { ...mConfigForm.value }  // 深拷贝，避免引用问题
    } else {
      // 从localStorage加载（保存的配置优先）
      const savedConfig = localStorage.getItem('algorithm_m_config')
      if (savedConfig) {
        try {
          const parsedConfig = JSON.parse(savedConfig)
          // 验证配置格式
          if (parsedConfig && typeof parsedConfig === 'object') {
            mConfig = {
              M1: Array.isArray(parsedConfig.M1) ? parsedConfig.M1 : [],
              M2: Array.isArray(parsedConfig.M2) ? parsedConfig.M2 : [],
              M3: Array.isArray(parsedConfig.M3) ? parsedConfig.M3 : [],
              M4: Array.isArray(parsedConfig.M4) ? parsedConfig.M4 : []
            }
          } else {
            console.warn('localStorage中的配置格式不正确')
          }
        } catch (e) {
          console.warn('加载配置失败，使用默认配置', e)
        }
      }
    }
    
    // 如果还是没有配置，使用默认配置
    if (!mConfig) {
      mConfig = {
        M1: ['一-total', '三-1'],
        M2: ['二-2', '二-3'],
        M3: ['二-1', '三-2', '三-3'],
        M4: ['四-total']
      }
    }
    
    // 确保所有M列都有配置（即使是空数组）
    if (!mConfig.M1) mConfig.M1 = []
    if (!mConfig.M2) mConfig.M2 = []
    if (!mConfig.M3) mConfig.M3 = []
    if (!mConfig.M4) mConfig.M4 = []
    const response = await recalculateAlgorithmScores({
      course_class_id: searchForm.course_class_id,
      m_config: mConfig
    })
    ElMessage.success(response.message || '重新计算完成')
    await loadGradebooks()
    // 等待一下确保数据已更新
    setTimeout(async () => {
      await loadAlgorithmScores()
      // 重新计算后，切换到步骤3标签页查看结果
      activeTab.value = 'finalScore'
    }, 300)
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('重新计算失败')
      console.error(error)
    }
  } finally {
    recalculating.value = false
  }
}

// 导出
const handleExport = async () => {
  if (!searchForm.course_class_id) {
    ElMessage.warning('请先选择课程班级')
    return
  }

  try {
    let response, filename
    if (isAlgorithmCourse.value) {
      // 导出算法分析与设计成绩
      response = await exportAlgorithmScoreExcel({
        course_class_id: searchForm.course_class_id
      })
      filename = `算法分析与设计成绩_${new Date().getTime()}.xlsx`
    } else {
      // 导出记分册
      response = await exportGradebookExcel({
        course_class_id: searchForm.course_class_id
      })
      filename = `记分册_${new Date().getTime()}.xlsx`
    }
    
    // response.data是blob数据
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
    ElMessage.error('导出失败: ' + (error.response?.data?.message || error.message))
  }
}

// 新增卷面成绩记录
const handleAddFinalPaperScore = () => {
  if (!searchForm.course_class_id) {
    ElMessage.warning('请先选择课程班级')
    return
  }
  if (gradebookList.value.length === 0) {
    ElMessage.warning('请先导入记分册数据')
    return
  }
  
  editingFinalPaperScore.value = null
  // 初始化scores结构
  const scores = {}
  if (finalPaperTableColumnsForDisplay.value && Object.keys(finalPaperTableColumnsForDisplay.value).length > 0) {
    Object.keys(finalPaperTableColumnsForDisplay.value).forEach(sectionKey => {
      scores[sectionKey] = {}
      Object.keys(finalPaperTableColumnsForDisplay.value[sectionKey].subColumns).forEach(subKey => {
        scores[sectionKey][subKey] = null
      })
    })
  }
  
  editFinalPaperForm.value = {
    student_id: '',
    student_name: '',
    scores: scores
  }
  editFinalPaperDialogVisible.value = true
}

// 编辑卷面成绩
const handleEditFinalPaperScore = async (row) => {
  if (!row.id) {
    ElMessage.warning('该记录无法编辑（可能是预览数据）')
    return
  }
  
  try {
    const response = await getAlgorithmScore(row.id)
    editingFinalPaperScore.value = response
    // 确保scores结构完整
    const scores = response.raw_paper_scores || {}
    if (finalPaperTableColumnsForDisplay.value && Object.keys(finalPaperTableColumnsForDisplay.value).length > 0) {
      Object.keys(finalPaperTableColumnsForDisplay.value).forEach(sectionKey => {
        if (!scores[sectionKey]) {
          scores[sectionKey] = {}
        }
        Object.keys(finalPaperTableColumnsForDisplay.value[sectionKey].subColumns).forEach(subKey => {
          if (scores[sectionKey][subKey] === undefined) {
            scores[sectionKey][subKey] = null
          }
        })
      })
    }
    
    editFinalPaperForm.value = {
      student_id: response.student_id,
      student_name: response.student_name,
      scores: scores
    }
    editFinalPaperDialogVisible.value = true
  } catch (error) {
    ElMessage.error('加载数据失败: ' + (error.response?.data?.message || error.message))
  }
}

// 删除卷面成绩
const handleDeleteFinalPaperScore = async (row) => {
  if (!row.id) {
    ElMessage.warning('该记录无法删除（可能是预览数据）')
    return
  }
  
  try {
    await ElMessageBox.confirm(
      `确定要删除学生 ${row.student_name} (${row.student_id}) 的卷面成绩吗？`,
      '确认删除',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    
    await deleteAlgorithmScore(row.id)
    ElMessage.success('删除成功')
    await loadAlgorithmScores()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败: ' + (error.response?.data?.message || error.message))
    }
  }
}

// 保存卷面成绩（新增或编辑）
const handleSaveFinalPaperScore = async () => {
  if (!editFinalPaperFormRef.value) return
  
  try {
    await editFinalPaperFormRef.value.validate()
    
    // 清理scores数据，移除null值
    const cleanedScores = {}
    Object.keys(editFinalPaperForm.value.scores).forEach(sectionKey => {
      const section = editFinalPaperForm.value.scores[sectionKey]
      if (section && typeof section === 'object') {
        const cleanedSection = {}
        Object.keys(section).forEach(subKey => {
          if (section[subKey] !== null && section[subKey] !== undefined) {
            cleanedSection[subKey] = section[subKey]
          }
        })
        if (Object.keys(cleanedSection).length > 0) {
          cleanedScores[sectionKey] = cleanedSection
        }
      }
    })
    
    const formData = {
      raw_paper_scores: cleanedScores
    }
    
    if (editingFinalPaperScore.value) {
      // 编辑
      await updateAlgorithmScore(editingFinalPaperScore.value.id, formData)
      ElMessage.success('更新成功')
    } else {
      // 新增 - 需要先找到对应的学生
      const student = gradebookList.value.find(gb => gb.student_id === editFinalPaperForm.value.student_id)
      if (!student) {
        ElMessage.error('找不到对应的学生，请先导入记分册')
        return
      }
      
      // 查找或创建AlgorithmScore记录
      const existingScore = algorithmScoreList.value.find(s => s.student_id === editFinalPaperForm.value.student_id)
      if (existingScore) {
        await updateAlgorithmScore(existingScore.id, formData)
        ElMessage.success('更新成功')
      } else {
        // 创建新记录需要更多信息，这里先更新现有记录
        ElMessage.warning('请先导入记分册，系统会自动创建成绩记录')
        return
      }
    }
    
    editFinalPaperDialogVisible.value = false
    await loadAlgorithmScores()
  } catch (error) {
    if (error !== false) { // 表单验证失败会返回false
      ElMessage.error('保存失败: ' + (error.response?.data?.message || error.message))
    }
  }
}

// 加载有算法成绩的班级列表
const loadClassesWithAlgorithmScores = async () => {
  loadingClasses.value = true
  try {
    const response = await getClassesWithAlgorithmScores()
    classesWithAlgorithmScores.value = response.results || []
  } catch (error) {
    console.error('加载有算法成绩的班级列表失败:', error)
    ElMessage.error('加载班级列表失败')
  } finally {
    loadingClasses.value = false
  }
}

// 查看算法成绩
const handleViewAlgorithmScores = async (row) => {
  searchForm.course_class_id = row.id
  // 先加载数据
  await handleSearch()
  // 等待数据加载完成后再切换标签页
  await new Promise(resolve => setTimeout(resolve, 300))
  // 切换到步骤3查看最终成绩
  activeTab.value = 'finalScore'
  // 滚动到成绩表格
  setTimeout(() => {
    const scoreTable = document.querySelector('.el-tabs')
    if (scoreTable) {
      scoreTable.scrollIntoView({ behavior: 'smooth', block: 'start' })
    }
  }, 200)
}

// 导出算法成绩
const handleExportAlgorithmClass = async (row) => {
  try {
    const params = { course_class_id: row.id }
    const response = await exportAlgorithmScoreExcel(params)
    const filename = `算法成绩表_${row.course_code}_${row.class_name}_${new Date().getTime()}.xlsx`
    
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

// 加载M列配置（从localStorage）
const loadMConfig = () => {
  const savedConfig = localStorage.getItem('algorithm_m_config')
  if (savedConfig) {
    try {
      const config = JSON.parse(savedConfig)
      if (config && typeof config === 'object') {
        // 使用 Array.isArray 判断，空数组也是有效配置
        mConfigForm.value = {
          M1: Array.isArray(config.M1) ? config.M1 : (config.M1 || ['一-total', '三-1']),
          M2: Array.isArray(config.M2) ? config.M2 : (config.M2 || ['二-2', '二-3']),
          M3: Array.isArray(config.M3) ? config.M3 : (config.M3 || ['二-1', '三-2', '三-3']),
          M4: Array.isArray(config.M4) ? config.M4 : (config.M4 || ['四-total'])
        }
      }
    } catch (e) {
      console.error('加载M列配置失败:', e)
    }
  }
}

// 保存M列配置
const handleSaveMConfig = () => {
  // 确保配置格式正确
  const configToSave = {
    M1: Array.isArray(mConfigForm.value.M1) ? mConfigForm.value.M1 : [],
    M2: Array.isArray(mConfigForm.value.M2) ? mConfigForm.value.M2 : [],
    M3: Array.isArray(mConfigForm.value.M3) ? mConfigForm.value.M3 : [],
    M4: Array.isArray(mConfigForm.value.M4) ? mConfigForm.value.M4 : []
  }
  localStorage.setItem('algorithm_m_config', JSON.stringify(configToSave))
  ElMessage.success('配置已保存')
  showMConfigDialog.value = false
  // 保存后需要重新计算
  ElMessage.info('请点击"重新计算"按钮应用新配置')
}

// 恢复默认配置
const handleResetMConfig = () => {
  mConfigForm.value = {
    M1: ['一-total', '三-1'],
    M2: ['二-2', '二-3'],
    M3: ['二-1', '三-2', '三-3'],
    M4: ['四-total']
  }
  ElMessage.success('已恢复默认配置')
}

// 算法成绩选择变化
const handleAlgorithmScoreSelectionChange = (selection) => {
  selectedAlgorithmScores.value = selection
}

// 新增算法成绩
const handleAddAlgorithmScore = () => {
  if (!searchForm.course_class_id) {
    ElMessage.warning('请先选择课程班级')
    return
  }
  if (gradebookList.value.length === 0) {
    ElMessage.warning('请先导入记分册数据')
    return
  }
  
  editingAlgorithmScore.value = null
  Object.assign(editAlgorithmScoreForm, {
    id: null,
    student_id: '',
    student_name: '',
    course_class_id: searchForm.course_class_id,
    class_performance: null,
    note_score: null,
    homework_avg: null,
    experiment_avg: null,
    usual_score: null,
    M1: null,
    M2: null,
    M3: null,
    M4: null,
    final_paper_score: null,
    usual_entry: null,
    final_entry: null,
    final_grade: null
  })
  editAlgorithmScoreDialogVisible.value = true
}

// 编辑算法成绩
const handleEditAlgorithmScore = async (row) => {
  if (!row.id) {
    ElMessage.warning('该记录无法编辑')
    return
  }
  
  try {
    const response = await getAlgorithmScore(row.id)
    editingAlgorithmScore.value = response
    Object.assign(editAlgorithmScoreForm, {
      id: response.id,
      student_id: response.student_id,
      student_name: response.student_name,
      course_class_id: response.course_class,
      class_performance: response.class_performance,
      note_score: response.note_score,
      homework_avg: response.homework_avg,
      experiment_avg: response.experiment_avg,
      usual_score: response.usual_score,
      M1: response.M1,
      M2: response.M2,
      M3: response.M3,
      M4: response.M4,
      final_paper_score: response.final_paper_score,
      usual_entry: response.usual_entry,
      final_entry: response.final_entry,
      final_grade: response.final_grade
    })
    editAlgorithmScoreDialogVisible.value = true
  } catch (error) {
    ElMessage.error('加载数据失败: ' + (error.response?.data?.message || error.message))
  }
}

// 学生选择变化
const handleStudentChange = (studentId) => {
  const gradebook = gradebookList.value.find(gb => gb.student_id === studentId)
  if (gradebook) {
    editAlgorithmScoreForm.student_name = gradebook.student_name
  }
}

// 保存算法成绩
const handleSaveAlgorithmScore = async () => {
  if (!editAlgorithmScoreFormRef.value) return
  
  try {
    await editAlgorithmScoreFormRef.value.validate()
    
    saving.value = true
    const formData = {
      course_class_id: editAlgorithmScoreForm.course_class_id,
      student_id: editAlgorithmScoreForm.student_id,
      class_performance: editAlgorithmScoreForm.class_performance,
      note_score: editAlgorithmScoreForm.note_score,
      homework_avg: editAlgorithmScoreForm.homework_avg,
      experiment_avg: editAlgorithmScoreForm.experiment_avg,
      usual_score: editAlgorithmScoreForm.usual_score,
      M1: editAlgorithmScoreForm.M1,
      M2: editAlgorithmScoreForm.M2,
      M3: editAlgorithmScoreForm.M3,
      M4: editAlgorithmScoreForm.M4,
      final_paper_score: editAlgorithmScoreForm.final_paper_score,
      usual_entry: editAlgorithmScoreForm.usual_entry,
      final_entry: editAlgorithmScoreForm.final_entry,
      final_grade: editAlgorithmScoreForm.final_grade
    }
    
    if (editingAlgorithmScore.value) {
      // 更新
      await updateAlgorithmScore(editingAlgorithmScore.value.id, formData)
      ElMessage.success('更新成功')
    } else {
      // 创建
      await createAlgorithmScore(formData)
      ElMessage.success('创建成功')
    }
    
    editAlgorithmScoreDialogVisible.value = false
    await loadAlgorithmScores()
  } catch (error) {
    if (error !== false) { // 表单验证失败会返回false
      ElMessage.error(error.response?.data?.message || error.response?.data?.detail || '保存失败')
    }
  } finally {
    saving.value = false
  }
}

// 删除算法成绩
const handleDeleteAlgorithmScore = async (row) => {
  if (!row.id) {
    ElMessage.warning('该记录无法删除')
    return
  }
  
  try {
    await ElMessageBox.confirm(
      `确定要删除学生 ${row.student_name} (${row.student_id}) 的算法成绩吗？`,
      '确认删除',
      { type: 'warning' }
    )
    
    await deleteAlgorithmScore(row.id)
    ElMessage.success('删除成功')
    await loadAlgorithmScores()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败: ' + (error.response?.data?.message || error.message))
    }
  }
}

// 批量删除算法成绩
const handleBatchDeleteAlgorithmScores = async () => {
  if (selectedAlgorithmScores.value.length === 0) {
    ElMessage.warning('请先选择要删除的记录')
    return
  }
  
  try {
    await ElMessageBox.confirm(
      `确定要删除选中的 ${selectedAlgorithmScores.value.length} 条记录吗？`,
      '确认批量删除',
      { type: 'warning' }
    )
    
    const deletePromises = selectedAlgorithmScores.value.map(score => 
      deleteAlgorithmScore(score.id)
    )
    await Promise.all(deletePromises)
    
    ElMessage.success(`成功删除 ${selectedAlgorithmScores.value.length} 条记录`)
    selectedAlgorithmScores.value = []
    await loadAlgorithmScores()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('批量删除失败: ' + (error.response?.data?.message || error.message))
    }
  }
}

onMounted(() => {
  loadClasses()
  loadMConfig()
  // 默认加载有成绩的班级列表
  loadClassesWithAlgorithmScores()
})
</script>

<style scoped>
.gradebook-list {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-title {
  font-size: 24px;
  font-weight: 500;
  margin: 0;
}

.page-actions {
  display: flex;
  gap: 10px;
}

.table-toolbar {
  margin-bottom: 20px;
}

.search-form {
  margin: 0;
}
</style>

