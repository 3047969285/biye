import request from '@/utils/request'

// 查询管理商品列表
export function listGood(query) {
  return request({
    url: '/good/good/list',
    method: 'get',
    params: query
  })
}

// 查询管理商品详细
export function getGood(goodId) {
  return request({
    url: '/good/good/' + goodId,
    method: 'get'
  })
}

// 新增管理商品
export function addGood(data) {
  return request({
    url: '/good/good',
    method: 'post',
    data: data
  })
}

// 修改管理商品
export function updateGood(data) {
  return request({
    url: '/good/good',
    method: 'put',
    data: data
  })
}

// 删除管理商品
export function delGood(goodId) {
  return request({
    url: '/good/good/' + goodId,
    method: 'delete'
  })
}