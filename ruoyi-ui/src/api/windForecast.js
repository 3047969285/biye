import axios from 'axios'
import request from '@/utils/request'
import { getToken } from '@/utils/auth'

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

export function runWindForecastNow() {
  return request({
    url: '/wind/forecast/run',
    method: 'post',
    data: {},
    timeout: 360000
  })
}

export function runWindForecastForDevice(data) {
  return request({
    url: '/wind/forecast/run/device',
    method: 'post',
    data: data || {},
    timeout: 360000
  })
}

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

export function windForecastSummary(data) {
  return request({
    url: '/wind/forecast/summary',
    method: 'post',
    data: data || {}
  })
}
