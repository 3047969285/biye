import request from '@/utils/request'
export function listClimateData(query) {
  return request({ url: '/equipment/climateData/list', method: 'get', params: query })
}
export function listClimateDataByDeviceId(deviceId) {
  return request({ url: '/equipment/climateData/listByDeviceId/' + deviceId, method: 'get' })
}
export function getClimateData(climateId) {
  return request({ url: '/equipment/climateData/' + climateId, method: 'get' })
}
export function addClimateData(data) {
  return request({ url: '/equipment/climateData', method: 'post', data: data })
}
export function updateClimateData(data) {
  return request({ url: '/equipment/climateData', method: 'put', data: data })
}
export function delClimateData(climateIds) {
  return request({ url: '/equipment/climateData/' + climateIds, method: 'delete' })
}
