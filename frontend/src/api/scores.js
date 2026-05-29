import request from '@/utils/request'

export function getScores(params) {
  return request({
    url: '/scores/scores/',
    method: 'get',
    params
  })
}

export function getScore(id) {
  return request({
    url: `/scores/scores/${id}/`,
    method: 'get'
  })
}

export function createScore(data) {
  return request({
    url: '/scores/scores/',
    method: 'post',
    data
  })
}

export function updateScore(id, data) {
  return request({
    url: `/scores/scores/${id}/`,
    method: 'patch',
    data
  })
}

export function deleteScore(id) {
  return request({
    url: `/scores/scores/${id}/`,
    method: 'delete'
  })
}

export function importExcel(data) {
  return request({
    url: '/scores/scores/import-excel/',
    method: 'post',
    data,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

export function previewExcel(file) {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: '/scores/scores/preview-excel/',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

export function getScoreStatistics(params) {
  return request({
    url: '/scores/scores/statistics/',
    method: 'get',
    params
  })
}

export function exportScores(params) {
  return request({
    url: '/scores/scores/export/',
    method: 'get',
    params,
    responseType: 'blob'
  })
}

export function exportAchievement(params) {
  return request({
    url: '/scores/scores/export-achievement/',
    method: 'get',
    params,
    responseType: 'blob'
  })
}

export function publishScore(id) {
  return request({
    url: `/scores/scores/${id}/publish/`,
    method: 'post'
  })
}

export function unpublishScore(id) {
  return request({
    url: `/scores/scores/${id}/unpublish/`,
    method: 'post'
  })
}

export function getClassesWithScores(params) {
  return request({
    url: '/scores/scores/classes-with-scores/',
    method: 'get',
    params
  })
}

// 记分册相关API
export function getGradebooks(params) {
  return request({
    url: '/scores/gradebooks/',
    method: 'get',
    params
  })
}

export function getGradebook(id) {
  return request({
    url: `/scores/gradebooks/${id}/`,
    method: 'get'
  })
}

export function createGradebook(data) {
  return request({
    url: '/scores/gradebooks/',
    method: 'post',
    data
  })
}

export function updateGradebook(id, data) {
  return request({
    url: `/scores/gradebooks/${id}/`,
    method: 'patch',
    data
  })
}

export function deleteGradebook(id) {
  return request({
    url: `/scores/gradebooks/${id}/`,
    method: 'delete'
  })
}

export function importGradebookExcel(data) {
  return request({
    url: '/scores/gradebooks/import-excel/',
    method: 'post',
    data,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

export function exportGradebookExcel(params) {
  return request({
    url: '/scores/gradebooks/export-excel/',
    method: 'get',
    params,
    responseType: 'blob'
  })
}

// 算法分析与设计成绩相关API
export function getAlgorithmScores(params) {
  return request({
    url: '/scores/algorithm-scores/',
    method: 'get',
    params
  })
}

export function getAlgorithmScore(id) {
  return request({
    url: `/scores/algorithm-scores/${id}/`,
    method: 'get'
  })
}

export function updateAlgorithmScore(id, data) {
  return request({
    url: `/scores/algorithm-scores/${id}/`,
    method: 'patch',
    data
  })
}

export function deleteAlgorithmScore(id) {
  return request({
    url: `/scores/algorithm-scores/${id}/`,
    method: 'delete'
  })
}

export function createAlgorithmScore(data) {
  return request({
    url: '/scores/algorithm-scores/',
    method: 'post',
    data
  })
}

export function previewFinalPaperExcel(data) {
  return request({
    url: '/scores/algorithm-scores/preview-final-paper/',
    method: 'post',
    data,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

export function importFinalPaperExcel(data) {
  return request({
    url: '/scores/algorithm-scores/import-final-paper/',
    method: 'post',
    data,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

export function recalculateAlgorithmScores(data) {
  return request({
    url: '/scores/algorithm-scores/recalculate/',
    method: 'post',
    data
  })
}

export function exportAlgorithmScoreExcel(params) {
  return request({
    url: '/scores/algorithm-scores/export-excel/',
    method: 'get',
    params,
    responseType: 'blob'
  })
}

export function getClassesWithAlgorithmScores(params) {
  return request({
    url: '/scores/algorithm-scores/classes-with-scores/',
    method: 'get',
    params
  })
}

// 图形学记分册相关API
export function previewGraphicsGradebook(data) {
  return request({
    url: '/scores/gradebooks/preview-graphics-gradebook/',
    method: 'post',
    data,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

export function importGraphicsGradebook(data) {
  return request({
    url: '/scores/gradebooks/import-graphics-gradebook/',
    method: 'post',
    data,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

export function getGraphicsClasses() {
  return request({
    url: '/scores/gradebooks/graphics-classes/',
    method: 'get'
  })
}
