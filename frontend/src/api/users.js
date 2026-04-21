import request from '@/utils/request'

export function getUsers(params) {
  return request({
    url: '/users/',
    method: 'get',
    params
  })
}

export function getUser(id) {
  return request({
    url: `/users/${id}/`,
    method: 'get'
  })
}

export function createUser(data) {
  return request({
    url: '/users/',
    method: 'post',
    data
  })
}

export function updateUser(id, data) {
  return request({
    url: `/users/${id}/`,
    method: 'patch',
    data
  })
}

export function deleteUser(id) {
  return request({
    url: `/users/${id}/`,
    method: 'delete'
  })
}

export function getStudents(params) {
  return request({
    url: '/users/students/',
    method: 'get',
    params
  })
}

export function getStudentProfiles(params) {
  return request({
    url: '/users/student-profiles/',
    method: 'get',
    params
  })
}

export function createStudentProfile(data) {
  return request({
    url: '/users/student-profiles/',
    method: 'post',
    data
  })
}

export function updateStudentProfile(id, data) {
  return request({
    url: `/users/student-profiles/${id}/`,
    method: 'patch',
    data
  })
}

// 教师管理 API
export function getTeachers(params) {
  return request({
    url: '/users/teachers/',
    method: 'get',
    params
  })
}

export function getTeacher(id) {
  return request({
    url: `/users/teachers/${id}/`,
    method: 'get'
  })
}

export function createTeacher(data) {
  return request({
    url: '/users/teachers/',
    method: 'post',
    data
  })
}

export function updateTeacher(id, data) {
  return request({
    url: `/users/teachers/${id}/`,
    method: 'patch',
    data
  })
}

export function deleteTeacher(id) {
  return request({
    url: `/users/teachers/${id}/`,
    method: 'delete'
  })
}