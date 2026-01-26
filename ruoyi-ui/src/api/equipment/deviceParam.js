import request from '@/utils/request'

// 查询设备参数列表
export function listDeviceParam(query) {
  return request({
    url: '/equipment/deviceParam/list',
    method: 'get',
    params: query
  })
}

// 根据设备ID查询设备参数列表
export function listDeviceParamByDeviceId(deviceId) {
  return request({
    url: '/equipment/deviceParam/listByDeviceId/' + deviceId,
    method: 'get'
  })
}

// 查询设备参数详细
export function getDeviceParam(paramId) {
  return request({
    url: '/equipment/deviceParam/' + paramId,
    method: 'get'
  })
}

// 新增设备参数
export function addDeviceParam(data) {
  return request({
    url: '/equipment/deviceParam',
    method: 'post',
    data: data
  })
}

// 修改设备参数
export function updateDeviceParam(data) {
  return request({
    url: '/equipment/deviceParam',
    method: 'put',
    data: data
  })
}

// 删除设备参数
export function delDeviceParam(paramIds) {
  return request({
    url: '/equipment/deviceParam/' + paramIds,
    method: 'delete'
  })
}
