import request from '@/utils/request'
export function listMechanicalData(query) {
  return request({ url: '/equipment/mechanicalData/list', method: 'get', params: query })
}
export function listMechanicalDataByDeviceId(deviceId) {
  return request({ url: '/equipment/mechanicalData/listByDeviceId/' + deviceId, method: 'get' })
}
export function getMechanicalData(mechanicalId) {
  return request({ url: '/equipment/mechanicalData/' + mechanicalId, method: 'get' })
}
export function addMechanicalData(data) {
  return request({ url: '/equipment/mechanicalData', method: 'post', data: data })
}
export function updateMechanicalData(data) {
  return request({ url: '/equipment/mechanicalData', method: 'put', data: data })
}
export function delMechanicalData(mechanicalIds) {
  return request({ url: '/equipment/mechanicalData/' + mechanicalIds, method: 'delete' })
}
