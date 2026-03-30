import request from '@/utils/request'

// 查询电表点表列表（分页）
export function listMeterPoint(query) {
  return request({
    url: '/meter/point/list',
    method: 'get',
    params: query
  })
}

// 查询电表点表详情
export function getMeterPoint(pointId) {
  return request({
    url: '/meter/point/' + pointId,
    method: 'get'
  })
}

// 新增电表点表
export function addMeterPoint(data) {
  return request({
    url: '/meter/point',
    method: 'post',
    data: data
  })
}

// 修改电表点表
export function updateMeterPoint(data) {
  return request({
    url: '/meter/point',
    method: 'put',
    data: data
  })
}

// 删除电表点表（pointIds 允许传数组或逗号串）
export function delMeterPoint(pointIds) {
  return request({
    url: '/meter/point/' + pointIds,
    method: 'delete'
  })
}

// 批量导入点表
export function importMeterPoints(list, updateSupport = false) {
  return request({
    url: '/meter/point/importData',
    method: 'post',
    params: { updateSupport },
    data: list
  })
}

