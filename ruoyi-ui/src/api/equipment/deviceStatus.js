import request from '@/utils/request'

// 查询设备状态列表
export function listDeviceStatus(query) {
  return request({
    url: '/equipment/deviceStatus/list',
    method: 'get',
    params: query
  })
}

// 查询设备状态详细
export function getDeviceStatus(statusId) {
  return request({
    url: '/equipment/deviceStatus/' + statusId,
    method: 'get'
  })
}

// 新增设备状态
export function addDeviceStatus(data) {
  return request({
    url: '/equipment/deviceStatus',
    method: 'post',
    data: data
  })
}

// 修改设备状态
export function updateDeviceStatus(data) {
  return request({
    url: '/equipment/deviceStatus',
    method: 'put',
    data: data
  })
}

// 删除设备状态
export function delDeviceStatus(statusId) {
  return request({
    url: '/equipment/deviceStatus/' + statusId,
    method: 'delete'
  })
}
