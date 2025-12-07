import request from '@/utils/request'

// 查询聊天消息列表
export function listMessage(query) {
  return request({
    url: '/chat/message/list',
    method: 'get',
    params: query
  })
}

// 查询最近的聊天消息
export function getRecentMessages(limit) {
  return request({
    url: `/chat/message/recent/${limit}`,
    method: 'get'
  })
}

// 查询聊天消息详细
export function getMessage(id) {
  return request({
    url: '/chat/message/' + id,
    method: 'get'
  })
}

// 新增聊天消息
export function addMessage(data) {
  return request({
    url: '/chat/message',
    method: 'post',
    data: data
  })
}

// 修改聊天消息
export function updateMessage(data) {
  return request({
    url: '/chat/message',
    method: 'put',
    data: data
  })
}

// 删除聊天消息
export function delMessage(id) {
  return request({
    url: '/chat/message/' + id,
    method: 'delete'
  })
}

