import request from '@/utils/request'
export function listFaultRecord(query) {
  return request({ url: '/equipment/faultRecord/list', method: 'get', params: query })
}
export function listFaultRecordByDeviceId(deviceId) {
  return request({ url: '/equipment/faultRecord/listByDeviceId/' + deviceId, method: 'get' })
}
export function getFaultRecord(faultId) {
  return request({ url: '/equipment/faultRecord/' + faultId, method: 'get' })
}
export function addFaultRecord(data) {
  return request({ url: '/equipment/faultRecord', method: 'post', data: data })
}
export function updateFaultRecord(data) {
  return request({ url: '/equipment/faultRecord', method: 'put', data: data })
}
export function delFaultRecord(faultIds) {
  return request({ url: '/equipment/faultRecord/' + faultIds, method: 'delete' })
}
