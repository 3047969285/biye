import request from '@/utils/request'
export function listSensor(query) {
  return request({ url: '/equipment/sensor/list', method: 'get', params: query })
}
export function listSensorByDeviceId(deviceId) {
  return request({ url: '/equipment/sensor/listByDeviceId/' + deviceId, method: 'get' })
}
export function getSensor(sensorId) {
  return request({ url: '/equipment/sensor/' + sensorId, method: 'get' })
}
export function addSensor(data) {
  return request({ url: '/equipment/sensor', method: 'post', data: data })
}
export function updateSensor(data) {
  return request({ url: '/equipment/sensor', method: 'put', data: data })
}
export function delSensor(sensorIds) {
  return request({ url: '/equipment/sensor/' + sensorIds, method: 'delete' })
}
