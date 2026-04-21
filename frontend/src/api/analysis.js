import request from '@/utils/request'

export function getCourseStatistics(params) {
  return request({
    url: '/analysis/course-statistics/',
    method: 'get',
    params
  })
}

export function getStudentProgress(studentId) {
  return request({
    url: '/analysis/student-progress/',
    method: 'get',
    params: { student_id: studentId }
  })
}

export function getClassComparison(courseId) {
  return request({
    url: '/analysis/class-comparison/',
    method: 'get',
    params: { course_id: courseId }
  })
}

export function getScoreDistribution(courseClassId) {
  return request({
    url: '/analysis/score-distribution/',
    method: 'get',
    params: { course_class_id: courseClassId }
  })
}

export function getComponentAnalysis(courseClassId) {
  return request({
    url: '/analysis/component-analysis/',
    method: 'get',
    params: { course_class_id: courseClassId }
  })
}

export function getDashboard() {
  return request({
    url: '/analysis/dashboard/',
    method: 'get'
  })
}

export function getObjectiveAchievement(courseClassId) {
  return request({
    url: '/analysis/objective-achievement/',
    method: 'get',
    params: { course_class_id: courseClassId }
  })
}

export function recalculateObjectives(courseClassId) {
  return request({
    url: '/analysis/recalculate-objectives/',
    method: 'post',
    data: { course_class_id: courseClassId }
  })
}

export function getQualityAnalysis(courseClassId) {
  return request({
    url: '/analysis/quality-analysis/',
    method: 'get',
    params: { course_class_id: courseClassId }
  })
}

export function getAchievementAnalysis(courseClassId) {
  return request({
    url: '/analysis/achievement-analysis/',
    method: 'get',
    params: { course_class_id: courseClassId }
  })
}

export function exportQualityAnalysis(data) {
  return request({
    url: '/analysis/export-quality-analysis/',
    method: 'post',
    data: data,
    responseType: 'blob' // 重要：指定响应类型为blob
  })
}