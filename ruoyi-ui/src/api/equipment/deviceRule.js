import request from '@/utils/request'
export function listDeviceRule(query) {
  return request({ url: '/equipment/deviceRule/list', method: 'get', params: query })
}
export function listDeviceRuleByDeviceId(deviceId) {
  return request({ url: '/equipment/deviceRule/listByDeviceId/' + deviceId, method: 'get' })
}
export function getDeviceRule(ruleId) {
  return request({ url: '/equipment/deviceRule/' + ruleId, method: 'get' })
}
export function addDeviceRule(data) {
  return request({ url: '/equipment/deviceRule', method: 'post', data: data })
}
export function updateDeviceRule(data) {
  return request({ url: '/equipment/deviceRule', method: 'put', data: data })
}
export function delDeviceRule(ruleIds) {
  return request({ url: '/equipment/deviceRule/' + ruleIds, method: 'delete' })
}
