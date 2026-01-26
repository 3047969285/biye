import request from '@/utils/request'

// 查询维护记录列表
export function listMaintenanceRecord(query) {
  return request({
    url: '/equipment/maintenanceRecord/list',
    method: 'get',
    params: query
  })
}

// 根据设备ID查询维护记录列表
export function listMaintenanceRecordByDeviceId(deviceId) {
  return request({
    url: '/equipment/maintenanceRecord/listByDeviceId/' + deviceId,
    method: 'get'
  })
}

// 查询维护记录详细
export function getMaintenanceRecord(recordId) {
  return request({
    url: '/equipment/maintenanceRecord/' + recordId,
    method: 'get'
  })
}

// 新增维护记录
export function addMaintenanceRecord(data) {
  return request({
    url: '/equipment/maintenanceRecord',
    method: 'post',
    data: data
  })
}

// 修改维护记录
export function updateMaintenanceRecord(data) {
  return request({
    url: '/equipment/maintenanceRecord',
    method: 'put',
    data: data
  })
}

// 删除维护记录
export function delMaintenanceRecord(recordIds) {
  return request({
    url: '/equipment/maintenanceRecord/' + recordIds,
    method: 'delete'
  })
}
