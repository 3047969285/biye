import request from '@/utils/request'

export function listUserMessage(query) {
  return request({
    url: '/system/user-message/list',
    method: 'get',
    params: query
  })
}

export function getUnreadMessageCount() {
  return request({
    url: '/system/user-message/unreadCount',
    method: 'get'
  })
}

export function markMessageRead(msgId) {
  return request({
    url: '/system/user-message/read/' + msgId,
    method: 'put'
  })
}

export function markAllMessagesRead() {
  return request({
    url: '/system/user-message/readAll',
    method: 'put'
  })
}

export function deleteUserMessage(msgId) {
  return request({
    url: '/system/user-message/' + msgId,
    method: 'delete'
  })
}
