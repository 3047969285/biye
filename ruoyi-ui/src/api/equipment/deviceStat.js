import request from '@/utils/request'
export function listDeviceStat(query) {
  return request({ url: '/equipment/deviceStat/list', method: 'get', params: query })
}
export function listDeviceStatByDeviceId(deviceId) {
  return request({ url: '/equipment/deviceStat/listByDeviceId/' + deviceId, method: 'get' })
}
export function getDeviceStat(statId) {
  return request({ url: '/equipment/deviceStat/' + statId, method: 'get' })
}
export function addDeviceStat(data) {
  return request({ url: '/equipment/deviceStat', method: 'post', data: data })
}
export function updateDeviceStat(data) {
  return request({ url: '/equipment/deviceStat', method: 'put', data: data })
}
export function delDeviceStat(statIds) {
  return request({ url: '/equipment/deviceStat/' + statIds, method: 'delete' })
}
