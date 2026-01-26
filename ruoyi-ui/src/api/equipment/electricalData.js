import request from '@/utils/request'
export function listElectricalData(query) {
  return request({ url: '/equipment/electricalData/list', method: 'get', params: query })
}
export function listElectricalDataByDeviceId(deviceId) {
  return request({ url: '/equipment/electricalData/listByDeviceId/' + deviceId, method: 'get' })
}
export function getElectricalData(electricalId) {
  return request({ url: '/equipment/electricalData/' + electricalId, method: 'get' })
}
export function addElectricalData(data) {
  return request({ url: '/equipment/electricalData', method: 'post', data: data })
}
export function updateElectricalData(data) {
  return request({ url: '/equipment/electricalData', method: 'put', data: data })
}
export function delElectricalData(electricalIds) {
  return request({ url: '/equipment/electricalData/' + electricalIds, method: 'delete' })
}
