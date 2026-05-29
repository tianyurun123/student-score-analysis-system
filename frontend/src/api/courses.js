import request from '@/utils/request'

export function getCourses(params) {
  return request({
    url: '/courses/courses/',
    method: 'get',
    params
  })
}

export function getCourse(id) {
  return request({
    url: `/courses/courses/${id}/`,
    method: 'get'
  })
}

export function createCourse(data) {
  return request({
    url: '/courses/courses/',
    method: 'post',
    data
  })
}

export function updateCourse(id, data) {
  return request({
    url: `/courses/courses/${id}/`,
    method: 'patch',
    data
  })
}

export function deleteCourse(id) {
  return request({
    url: `/courses/courses/${id}/`,
    method: 'delete'
  })
}

export function uploadSyllabus(id, formDataOrFile) {
  // 如果传入的是 FormData，直接使用；否则创建新的 FormData
  const formData = formDataOrFile instanceof FormData 
    ? formDataOrFile 
    : (() => {
        const fd = new FormData()
        fd.append('file', formDataOrFile)
        return fd
      })()
  
  return request({
    url: `/courses/courses/${id}/upload-syllabus/`,
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

export function getSuggestedFields(id) {
  return request({
    url: `/courses/courses/${id}/suggested-fields/`,
    method: 'get'
  })
}

export function getClasses(params) {
  return request({
    url: '/courses/classes/',
    method: 'get',
    params
  })
}

export function getClass(id) {
  return request({
    url: `/courses/classes/${id}/`,
    method: 'get'
  })
}

export function createClass(data) {
  return request({
    url: '/courses/classes/',
    method: 'post',
    data
  })
}

export function updateClass(id, data) {
  return request({
    url: `/courses/classes/${id}/`,
    method: 'patch',
    data
  })
}

export function deleteClass(id) {
  return request({
    url: `/courses/classes/${id}/`,
    method: 'delete'
  })
}

export function getClassStatistics(id) {
  return request({
    url: `/courses/classes/${id}/statistics/`,
    method: 'get'
  })
}

export function addStudentsToClass(id, studentIds) {
  return request({
    url: `/courses/classes/${id}/add-students/`,
    method: 'post',
    data: { student_ids: studentIds }
  })
}

export function importStudentsToClass(id, file) {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: `/courses/classes/${id}/import-students/`,
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

export function importClass(file) {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: '/courses/classes/import-class/',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

export function getClassStudents(classId, params) {
  return request({
    url: '/courses/enrollments/',
    method: 'get',
    params: {
      course_class_id: classId,
      ...params
    }
  })
}

export function deleteEnrollment(enrollmentId) {
  return request({
    url: `/courses/enrollments/${enrollmentId}/`,
    method: 'delete'
  })
}

export function updateEnrollment(enrollmentId, data) {
  return request({
    url: `/courses/enrollments/${enrollmentId}/`,
    method: 'patch',
    data
  })
}

export function createEnrollment(data) {
  return request({
    url: '/courses/enrollments/',
    method: 'post',
    data
  })
}

export function getGradingPolicies(params) {
  return request({
    url: '/courses/grading-policies/',
    method: 'get',
    params
  })
}

export function setGradingFormula(id, data) {
  return request({
    url: `/courses/grading-policies/${id}/set-formula/`,
    method: 'post',
    data
  })
}

export function getObjectiveConfig(courseId) {
  return request({
    url: `/courses/courses/${courseId}/objective-config/`,
    method: 'get'
  })
}

export function setObjectiveConfig(courseId, config) {
  return request({
    url: `/courses/courses/${courseId}/set-objective-config/`,
    method: 'post',
    data: { config }
  })
}

export function getGraphicsGradebooks() {
  return request({
    url: '/scores/gradebooks/graphics-classes/',
    method: 'get'
  })
}
