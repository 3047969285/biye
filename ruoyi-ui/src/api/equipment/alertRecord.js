import request from '@/utils/request'

// 查询告警记录列表
export function listAlertRecord(query) {
  return request({
    url: '/equipment/alertRecord/list',
    method: 'get',
    params: query
  })
}

// 根据设备ID查询告警记录列表
export function listAlertRecordByDeviceId(deviceId) {
  return request({
    url: '/equipment/alertRecord/listByDeviceId/' + deviceId,
    method: 'get'
  })
}

// 查询告警记录详细
export function getAlertRecord(alertId) {
  return request({
    url: '/equipment/alertRecord/' + alertId,
    method: 'get'
  })
}

// 新增告警记录
export function addAlertRecord(data) {
  return request({
    url: '/equipment/alertRecord',
    method: 'post',
    data: data
  })
}

// 修改告警记录
export function updateAlertRecord(data) {
  return request({
    url: '/equipment/alertRecord',
    method: 'put',
    data: data
  })
}

// 删除告警记录
export function delAlertRecord(alertIds) {
  return request({
    url: '/equipment/alertRecord/' + alertIds,
    method: 'delete'
  })
}
