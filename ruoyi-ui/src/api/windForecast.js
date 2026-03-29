import axios from 'axios'
import request from '@/utils/request'
import { getToken } from '@/utils/auth'

/**
 * 合并状态 + GRU 预测曲线；deviceId 可选。
 * @param {number|undefined} deviceId
 * @param {{ live?: boolean }} options live=true 时后端会先调 Python 再返回，避免只展示内存旧数据（耗时长，需加大 timeout）
 */
export function getWindForecastLatest(deviceId, options) {
  const opts = options || {}
  const params = {}
  if (deviceId != null && deviceId !== '') {
    params.deviceId = deviceId
  }
  if (opts.live) {
    params.live = true
  }
  return request({
    url: '/wind/forecast/latest',
    method: 'get',
    params,
    timeout: opts.live ? 360000 : 10000
  })
}

/** 手动触发一次 Python 预测（全局 yml 配置，写入 bind-device-id） */
export function runWindForecastNow() {
  return request({
    url: '/wind/forecast/run',
    method: 'post',
    data: {},
    timeout: 360000
  })
}

/** 按设备绑定数据预测（deviceId 必填，路径取库中绑定 + yml 兜底） */
export function runWindForecastForDevice(data) {
  return request({
    url: '/wind/forecast/run/device',
    method: 'post',
    data: data || {},
    timeout: 360000
  })
}

/**
 * 从服务器下载当前设备解析到的特征/真值 Excel（不走通用 request 拦截器，以便处理 HTTP 错误体中的 JSON）
 * @param {number} deviceId
 * @param {'feature'|'real'} kind
 * @returns {Promise<Blob>}
 */
export function downloadWindForecastExcel(deviceId, kind) {
  const baseURL = process.env.VUE_APP_BASE_API || '/dev-api'
  return axios({
    baseURL,
    url: '/wind/forecast/excel/' + deviceId,
    method: 'get',
    params: { kind },
    responseType: 'blob',
    timeout: 120000,
    headers: { Authorization: 'Bearer ' + getToken() },
    validateStatus: () => true
  }).then(async (res) => {
    const blob = res.data
    if (!(blob instanceof Blob)) {
      throw new Error('响应异常')
    }
    if (res.status !== 200) {
      const t = await blob.text()
      try {
        const j = JSON.parse(t)
        throw new Error(j.msg || '下载失败 (' + res.status + ')')
      } catch (e) {
        if (e instanceof SyntaxError) {
          throw new Error('下载失败 (' + res.status + ')')
        }
        throw e
      }
    }
    return blob
  })
}

/** 上传覆盖服务器上该设备的特征/真值 Excel */
export function uploadWindForecastExcel(deviceId, kind, file) {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: '/wind/forecast/excel/' + deviceId,
    method: 'post',
    params: { kind },
    data: formData,
    headers: { repeatSubmit: false },
    timeout: 120000
  })
}

/** AI 总结：可选 deviceId 使用对应设备上次预测 */
export function windForecastSummary(data) {
  return request({
    url: '/wind/forecast/summary',
    method: 'post',
    data: data || {}
  })
}
