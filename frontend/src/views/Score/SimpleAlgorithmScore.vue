<template>
  <div class="simple-algorithm-score">
    <div class="page-header">
      <h1>算法成绩管理</h1>
      <div class="actions">
        <el-button type="primary" @click="handleImport" :disabled="!searchForm.course_class_id"><el-icon><Upload /></el-icon>导入</el-button>
        <el-button type="success" @click="handleExport" :disabled="!searchForm.course_class_id"><el-icon><Download /></el-icon>导出</el-button>
      </div>
    </div>
    <el-card>
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="课程班级">
          <el-select v-model="searchForm.course_class_id" placeholder="请选择" filterable style="width:300px" @change="handleSearch">
            <el-option v-for="cls in classes" :key="cls.id" :label="`${cls.course_name} - ${cls.class_name}`" :value="cls.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="学号"><el-input v-model="searchForm.student_id" placeholder="请输入" @keyup.enter="handleSearch" /></el-form-item>
        <el-form-item><el-button type="primary" @click="handleSearch">查询</el-button><el-button @click="handleReset">重置</el-button></el-form-item>
      </el-form>
      <el-steps :active="currentStep" style="margin:20px 0">
        <el-step title="记分册管理" />
        <el-step title="卷面成绩" />
        <el-step title="最终成绩" />
      </el-steps>
      <el-tabs v-model="activeTab" @tab-change="handleTabChange">
        <el-tab-pane label="记分册管理" name="gradebook">
          <el-table :data="gradebookList" border v-loading="loading" :max-height="500">
            <el-table-column prop="student_id" label="学号" width="120" />
            <el-table-column prop="student_name" label="姓名" width="100" />
            <el-table-column prop="homework1" label="作业1" width="80" />
            <el-table-column prop="homework2" label="作业2" width="80" />
            <el-table-column prop="homework3" label="作业3" width="80" />
            <el-table-column prop="experiment1" label="实验1" width="80" />
            <el-table-column prop="experiment2" label="实验2" width="80" />
            <el-table-column prop="final_score" label="期末" width="80" />
            <el-table-column prop="total_score" label="总评" width="80" />
            <el-table-column label="操作" width="120">
              <template #default="{row}"><el-button size="small" @click="handleEdit(row)">编辑</el-button><el-button size="small" type="danger" @click="handleDelete(row)">删除</el-button></template>
            </el-table-column>
          </el-table>
          <el-pagination v-if="gradebookList.length" v-model:current-page="pagination.page" v-model:page-size="pagination.pageSize" :total="pagination.total" layout="total,prev,pager,next" style="margin-top:20px;text-align:right" />
        </el-tab-pane>
        <el-tab-pane label="卷面成绩" name="finalPaper">
          <el-button type="warning" @click="handleImportFinalPaper" :disabled="!searchForm.course_class_id"><el-icon><Upload /></el-icon>导入卷面成绩</el-button>
          <el-table :data="finalPaperList" border v-loading="loading" :max-height="500">
            <el-table-column prop="student_id" label="学号" width="120" />
            <el-table-column prop="student_name" label="姓名" width="100" />
            <el-table-column prop="raw_scores" label="卷面得分" width="150" />
          </el-table>
        </el-tab-pane>
        <el-tab-pane label="最终成绩" name="finalScore">
          <el-button type="info" @click="handleRecalculate" :disabled="!searchForm.course_class_id"><el-icon><Refresh /></el-icon>重新计算</el-button>
          <el-table :data="algorithmScoreList" border v-loading="loading" :max-height="500">
            <el-table-column type="selection" width="55" />
            <el-table-column prop="student_id" label="学号" width="120" />
            <el-table-column prop="student_name" label="姓名" width="100" />
            <el-table-column prop="usual_score" label="平时" width="80" />
            <el-table-column prop="final_score" label="期末" width="80" />
            <el-table-column prop="total_score" label="总评" width="80" />
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>
<script setup>
import {ref,reactive,onMounted} from 'vue';
import {Upload,Download,Refresh} from '@element-plus/icons-vue';
import {ElMessage} from 'element-plus';
import {getClasses,getGradebooks,importGradebook,exportGradebook,deleteGradebook,getAlgorithmScores,importFinalPaper,recalculateScores,exportAlgorithmScores} from '@/api/scores';
const searchForm=reactive({course_class_id:null,student_id:''});
const classes=ref([]);
const gradebookList=ref([]);
const finalPaperList=ref([]);
const algorithmScoreList=ref([]);
const loading=ref(false);
const activeTab=ref('gradebook');
const currentStep=ref(0);
const pagination=reactive({page:1,pageSize:20,total:0});
onMounted(async()=>{await loadClasses();});
const loadClasses=async()=>{try{const res=await getClasses();classes.value=res.results||res;}catch(e){ElMessage.error('加载班级失败');}};
const handleSearch=async()=>{if(!searchForm.course_class_id)return;loading.value=true;try{const params={course_class_id:searchForm.course_class_id,page:pagination.page,page_size:pagination.pageSize};if(searchForm.student_id)params.student_id=searchForm.student_id;const res=await getGradebooks(params);gradebookList.value=res.results||res;pagination.total=res.count||res.length;}catch(e){ElMessage.error('查询失败');}finally{loading.value=false;}};
const handleReset=()=>{searchForm.course_class_id=null;searchForm.student_id='';gradebookList.value=[];finalPaperList.value=[];algorithmScoreList.value=[];};
const handleTabChange=(tab)=>{activeTab.value=tab;if(tab==='gradebook')currentStep.value=0;else if(tab==='finalPaper'){currentStep.value=1;loadFinalPaper();}else if(tab==='finalScore'){currentStep.value=2;loadAlgorithmScores();}};
const loadFinalPaper=async()=>{if(!searchForm.course_class_id)return;try{const res=await getAlgorithmScores({course_class_id:searchForm.course_class_id});finalPaperList.value=res.results||res.map(s=>({student_id:s.student_id,student_name:s.student_name,raw_scores:s.raw_paper_scores}));}catch(e){}};
const loadAlgorithmScores=async()=>{if(!searchForm.course_class_id)return;try{const res=await getAlgorithmScores({course_class_id:searchForm.course_class_id});algorithmScoreList.value=res.results||res;}catch(e){}};
const handleImport=async()=>{ElMessage.info('请选择Excel文件导入');};
const handleExport=async()=>{if(!searchForm.course_class_id)return;try{await exportAlgorithmScores({course_class_id:searchForm.course_class_id});ElMessage.success('导出成功');}catch(e){ElMessage.error('导出失败');}};
const handleEdit=(row)=>{ElMessage.info(`编辑:${row.student_name}`);};
const handleDelete=async(row)=>{try{await deleteGradebook(row.id);ElMessage.success('删除成功');handleSearch();}catch(e){ElMessage.error('删除失败');}};
const handleImportFinalPaper=async()=>{ElMessage.info('请选择卷面成绩Excel文件');};
const handleRecalculate=async()=>{if(!searchForm.course_class_id)return;try{await recalculateScores({course_class_id:searchForm.course_class_id});ElMessage.success('计算成功');loadAlgorithmScores();}catch(e){ElMessage.error('计算失败');}};
</script>
<style scoped>.simple-algorithm-score{padding:20px;}.page-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;}.actions{display:flex;gap:10px;}.search-form{margin-bottom:20px;}</style>