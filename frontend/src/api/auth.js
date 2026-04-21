import request from '@/utils/request'

export function login(username, password) {
  return request({
    url: '/auth/login/',
    method: 'post',
    data: {
      username,
      password
    }
  })
}

export function logout() {
  return request({
    url: '/auth/logout/',
    method: 'post'
  })
}

export function register(username, password, email = '', first_name = '') {
  return request({
    url: '/auth/register/',
    method: 'post',
    data: {
      username,
      password,
      email,
      first_name
    }
  })
}

export function getCurrentUser() {
  return request({
    url: '/users/me/',
    method: 'get'
  })
}
