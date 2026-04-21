import request from '@/utils/request'

export function ingestDl645(data) {
  return request({
    url: '/meter/dl645/ingest',
    method: 'post',
    data
  })
}

export function listDl645Latest(params) {
  return request({
    url: '/api/open/meter/dl645/latest',
    method: 'get',
    params: params || {}
  })
}
