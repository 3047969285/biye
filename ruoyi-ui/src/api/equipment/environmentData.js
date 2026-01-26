import request from '@/utils/request'

// 查询环境数据列表
export function listEnvironmentData(query) {
  return request({
    url: '/equipment/environmentData/list',
    method: 'get',
    params: query
  })
}

// 根据设备ID查询环境数据列表
export function listEnvironmentDataByDeviceId(deviceId) {
  return request({
    url: '/equipment/environmentData/listByDeviceId/' + deviceId,
    method: 'get'
  })
}

// 查询环境数据详细
export function getEnvironmentData(envId) {
  return request({
    url: '/equipment/environmentData/' + envId,
    method: 'get'
  })
}

// 新增环境数据
export function addEnvironmentData(data) {
  return request({
    url: '/equipment/environmentData',
    method: 'post',
    data: data
  })
}

// 修改环境数据
export function updateEnvironmentData(data) {
  return request({
    url: '/equipment/environmentData',
    method: 'put',
    data: data
  })
}

// 删除环境数据
export function delEnvironmentData(envIds) {
  return request({
    url: '/equipment/environmentData/' + envIds,
    method: 'delete'
  })
}
