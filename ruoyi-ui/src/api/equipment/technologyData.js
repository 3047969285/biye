import request from '@/utils/request'
export function listTechnologyData(query) {
  return request({ url: '/equipment/technologyData/list', method: 'get', params: query })
}
export function listTechnologyDataByDeviceId(deviceId) {
  return request({ url: '/equipment/technologyData/listByDeviceId/' + deviceId, method: 'get' })
}
export function getTechnologyData(techId) {
  return request({ url: '/equipment/technologyData/' + techId, method: 'get' })
}
export function addTechnologyData(data) {
  return request({ url: '/equipment/technologyData', method: 'post', data: data })
}
export function updateTechnologyData(data) {
  return request({ url: '/equipment/technologyData', method: 'put', data: data })
}
export function delTechnologyData(techIds) {
  return request({ url: '/equipment/technologyData/' + techIds, method: 'delete' })
}
