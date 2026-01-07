import request from '@/utils/request'

// 查询设备信息列表
export function listDevice(query) {
  return request({
    url: '/equipment/device/list',
    method: 'get',
    params: query
  })
}

// 查询设备信息详细
export function getDevice(deviceId) {
  return request({
    url: '/equipment/device/' + deviceId,
    method: 'get'
  })
}

// 新增设备信息
export function addDevice(data) {
  return request({
    url: '/equipment/device',
    method: 'post',
    data: data
  })
}

// 修改设备信息
export function updateDevice(data) {
  return request({
    url: '/equipment/device',
    method: 'put',
    data: data
  })
}

// 删除设备信息
export function delDevice(deviceIds) {
  return request({
    url: '/equipment/device/' + deviceIds,
    method: 'delete'
  })
}

// 更新设备状态（单个）
export function updateDeviceStatus(deviceId, status) {
  return request({
    url: `/equipment/device/status/${deviceId}/${status}`,
    method: 'put'
  })
}

// 批量更新设备状态
export function updateDeviceStatusBatch(deviceIds, status) {
  return request({
    url: '/equipment/device/status/batch',
    method: 'put',
    params: {
      deviceIds: deviceIds,
      status: status
    }
  })
}

// 获取设备统计信息
export function getDeviceStatistics() {
  return request({
    url: '/equipment/device/statistics',
    method: 'get'
  })
}

// 校验设备编号是否唯一
export function checkDeviceNoUnique(deviceNo) {
  return request({
    url: '/equipment/device/checkDeviceNoUnique/' + deviceNo,
    method: 'get'
  })
}
