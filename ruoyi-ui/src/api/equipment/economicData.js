import request from '@/utils/request'
export function listEconomicData(query) {
  return request({ url: '/equipment/economicData/list', method: 'get', params: query })
}
export function listEconomicDataByDeviceId(deviceId) {
  return request({ url: '/equipment/economicData/listByDeviceId/' + deviceId, method: 'get' })
}
export function getEconomicData(economicId) {
  return request({ url: '/equipment/economicData/' + economicId, method: 'get' })
}
export function addEconomicData(data) {
  return request({ url: '/equipment/economicData', method: 'post', data: data })
}
export function updateEconomicData(data) {
  return request({ url: '/equipment/economicData', method: 'put', data: data })
}
export function delEconomicData(economicIds) {
  return request({ url: '/equipment/economicData/' + economicIds, method: 'delete' })
}
