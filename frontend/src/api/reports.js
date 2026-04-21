import request from '@/utils/request'

export function getCourseReport(courseClassId) {
  return request({
    url: '/reports/course-report/',
    method: 'get',
    params: { course_class_id: courseClassId }
  })
}

export function printCourseReport(courseClassId) {
  return request({
    url: '/reports/print-course-report/',
    method: 'get',
    params: { course_class_id: courseClassId },
    responseType: 'blob'
  })
}

export function getStudentTranscript(studentId) {
  return request({
    url: '/reports/student-transcript/',
    method: 'get',
    params: { student_id: studentId }
  })
}

