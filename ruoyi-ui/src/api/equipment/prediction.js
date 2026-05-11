import request from '@/utils/request'

export function listPrediction(query) {
  return request({ url: '/equipment/prediction/list', method: 'get', params: query })
}

export function listPredictionByDeviceId(deviceId) {
  return request({ url: '/equipment/prediction/listByDeviceId/' + deviceId, method: 'get' })
}

export function getPrediction(predictionId) {
  return request({ url: '/equipment/prediction/' + predictionId, method: 'get' })
}

export function addPrediction(data) {
  return request({ url: '/equipment/prediction', method: 'post', data: data })
}

export function updatePrediction(data) {
  return request({ url: '/equipment/prediction', method: 'put', data: data })
}

export function delPrediction(predictionIds) {
  return request({ url: '/equipment/prediction/' + predictionIds, method: 'delete' })
}
