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
