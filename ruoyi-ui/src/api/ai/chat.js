import request from '@/utils/request'

// 基础AI对话
export function chat(input) {
  return request({
    url: '/springai/chat',
    method: 'get',
    params: { input }
  })
}

// RAG问答（基于知识库）
export function askWithRag(question, topK = 3) {
  return request({
    url: '/springai/rag/ask',
    method: 'get',
    params: { question, topK }
  })
}

// 添加文档到知识库
export function addDocument(content, title, category) {
  return request({
    url: '/springai/rag/document',
    method: 'post',
    params: { content, title, category }
  })
}

// 生成运维表单
export function generateForm(question, topK = 3, saveToDb = false) {
  return request({
    url: '/springai/rag/generate-form',
    method: 'get',
    params: { question, topK, saveToDb }
  })
}

// 删除文档
export function deleteDocument(documentId) {
  return request({
    url: '/springai/rag/document/' + documentId,
    method: 'delete'
  })
}

// 清空知识库
export function clearKnowledgeBase() {
  return request({
    url: '/springai/rag/clear',
    method: 'post'
  })
}

// 数据库智能查询
export function askDatabase(question) {
  return request({
    url: '/springai/db/ask',
    method: 'get',
    params: { question }
  })
}

// 获取数据库统计信息
export function getDatabaseStats() {
  return request({
    url: '/springai/db/stats',
    method: 'get'
  })
}

// 获取数据库上下文
export function getDatabaseContext() {
  return request({
    url: '/springai/db/context',
    method: 'get'
  })
}

// 获取对话历史记录列表
export function getChatHistory(chatType) {
  return request({
    url: '/springai/history/list',
    method: 'get',
    params: { chatType }
  })
}

// 根据ID获取单条对话记录
export function getChatHistoryById(recordId) {
  return request({
    url: '/springai/history/' + recordId,
    method: 'get'
  })
}

// 批量删除对话记录
export function deleteChatRecords(recordIds) {
  return request({
    url: '/springai/history/delete',
    method: 'delete',
    data: recordIds
  })
}

// 查询需要维护的设备列表；aiSummary=false 跳过 LLM，仅规则摘要，首屏更快
export function getDevicesRequiringMaintenance(options) {
  const params = {}
  if (options && options.aiSummary === false) {
    params.aiSummary = false
  }
  return request({
    url: '/ai/maintenance-form/devices',
    method: 'get',
    params
  })
}

// 为指定设备生成运维表单
export function generateFormForDevice(deviceId, saveToDb = false) {
  return request({
    url: '/ai/maintenance-form/generate',
    method: 'post',
    params: { deviceId, saveToDb }
  })
}

// 批量生成运维表单
export function batchGenerateForms(deviceIds, saveToDb = false) {
  return request({
    url: '/ai/maintenance-form/batch-generate',
    method: 'post',
    params: { deviceIds: deviceIds.join(','), saveToDb }
  })
}

// 查询运维表单列表（历史记录）
export function listAiMaintenanceForm(query) {
  return request({
    url: '/ai/maintenance-form/forms',
    method: 'get',
    params: query
  })
}

// 根据ID获取运维表单详情
export function getAiMaintenanceFormById(formId) {
  return request({
    url: '/ai/maintenance-form/forms/' + formId,
    method: 'get'
  })
}

// 更新运维表单
export function updateMaintenanceForm(data) {
  return request({
    url: '/ai/maintenance-form/forms',
    method: 'put',
    data: data
  })
}

// 删除运维表单
export function deleteMaintenanceForm(formId) {
  return request({
    url: '/ai/maintenance-form/forms/' + formId,
    method: 'delete'
  })
}

// 批量删除运维表单
export function batchDeleteMaintenanceForms(formIds) {
  return request({
    url: '/ai/maintenance-form/forms',
    method: 'delete',
    data: formIds
  })
}
