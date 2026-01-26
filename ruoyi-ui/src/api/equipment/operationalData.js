import request from '@/utils/request'
export function listOperationalData(query) {
  return request({ url: '/equipment/operationalData/list', method: 'get', params: query })
}
export function listOperationalDataByDeviceId(deviceId) {
  return request({ url: '/equipment/operationalData/listByDeviceId/' + deviceId, method: 'get' })
}
export function getOperationalData(operationalId) {
  return request({ url: '/equipment/operationalData/' + operationalId, method: 'get' })
}
export function addOperationalData(data) {
  return request({ url: '/equipment/operationalData', method: 'post', data: data })
}
export function updateOperationalData(data) {
  return request({ url: '/equipment/operationalData', method: 'put', data: data })
}
export function delOperationalData(operationalIds) {
  return request({ url: '/equipment/operationalData/' + operationalIds, method: 'delete' })
}
