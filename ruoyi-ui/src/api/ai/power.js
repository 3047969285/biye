import request from '@/utils/request'

/** 异步启动模型训练（后台执行，通过 getPowerStatus 轮询进度） */
export function trainPowerModel(data) {
  return request({
    url: '/springai/power/train',
    method: 'post',
    data
  })
}

/** 快速预测（模型已训练，毫秒级推理） */
export function quickPredictPower(data) {
  return request({
    url: '/springai/power/predict',
    method: 'post',
    data
  })
}

/** 查询模型状态 / 训练进度 */
export function getPowerStatus() {
  return request({
    url: '/springai/power/status',
    method: 'get'
  })
}

/** @deprecated 使用 quickPredictPower 替代 */
export function predictPower(data) {
  return quickPredictPower(data)
}
