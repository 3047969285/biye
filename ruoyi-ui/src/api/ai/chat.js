import request from '@/utils/request'

export function chat(input) {
  return request({
    url: '/springai/chat',
    method: 'get',
    params: { input }
  })
}

export function askWithRag(question, topK = 3) {
  return request({
    url: '/springai/rag/ask',
    method: 'get',
    params: { question, topK }
  })
}

export function addDocument(content, title, category) {
  return request({
    url: '/springai/rag/document',
    method: 'post',
    params: { content, title, category }
  })
}

export function generateForm(question, topK = 3, saveToDb = false) {
  return request({
    url: '/springai/rag/generate-form',
    method: 'get',
    params: { question, topK, saveToDb }
  })
}

export function deleteDocument(documentId) {
  return request({
    url: '/springai/rag/document/' + documentId,
    method: 'delete'
  })
}

export function clearKnowledgeBase() {
  return request({
    url: '/springai/rag/clear',
    method: 'post'
  })
}

export function askDatabase(question) {
  return request({
    url: '/springai/db/ask',
    method: 'get',
    params: { question }
  })
}

export function getDatabaseStats() {
  return request({
    url: '/springai/db/stats',
    method: 'get'
  })
}

export function getDatabaseContext() {
  return request({
    url: '/springai/db/context',
    method: 'get'
  })
}

export function getChatHistory(chatType) {
  return request({
    url: '/springai/history/list',
    method: 'get',
    params: { chatType }
  })
}

export function getChatHistoryById(recordId) {
  return request({
    url: '/springai/history/' + recordId,
    method: 'get'
  })
}

export function deleteChatRecords(recordIds) {
  return request({
    url: '/springai/history/delete',
    method: 'delete',
    data: recordIds
  })
}

export function getDevicesRequiringMaintenance(options) {
  const params = {}
  if (options && options.aiSummary === false) {
    params.aiSummary = false
  }
  return request({
    url: '/springai/maintenance-form/devices',
    method: 'get',
    params
  })
}

export function generateFormForDevice(deviceId, saveToDb = false) {
  return request({
    url: '/springai/maintenance-form/generate',
    method: 'post',
    params: { deviceId, saveToDb }
  })
}

export function batchGenerateForms(deviceIds, saveToDb = false) {
  return request({
    url: '/springai/maintenance-form/batch-generate',
    method: 'post',
    params: { deviceIds: deviceIds.join(','), saveToDb }
  })
}

export function listAiMaintenanceForm(query) {
  return request({
    url: '/springai/maintenance-form/forms',
    method: 'get',
    params: query
  })
}

export function getAiMaintenanceFormById(formId) {
  return request({
    url: '/springai/maintenance-form/forms/' + formId,
    method: 'get'
  })
}

export function updateMaintenanceForm(data) {
  return request({
    url: '/springai/maintenance-form/forms',
    method: 'put',
    data: data
  })
}

export function deleteMaintenanceForm(formId) {
  return request({
    url: '/springai/maintenance-form/forms/' + formId,
    method: 'delete'
  })
}

export function batchDeleteMaintenanceForms(formIds) {
  return request({
    url: '/springai/maintenance-form/forms',
    method: 'delete',
    data: formIds
  })
}
