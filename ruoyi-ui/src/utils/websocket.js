import { Message } from 'element-ui'

class WebSocketClient {
  constructor() {
    this.ws = null
    this.url = null
    this.reconnectTimer = null
    this.reconnectCount = 0
    this.maxReconnectCount = 5
    this.reconnectInterval = 3000
    this.handlers = []
  }

  connect(url) {
    if (!url) {
      throw new Error('WebSocket url is required')
    }
    this.url = url
    if (this.ws && this.ws.readyState === WebSocket.OPEN) {
      return
    }
    this.ws = new WebSocket(url)
    this.ws.onopen = () => {
      this.reconnectCount = 0
      Message.success('WebSocket 已连接')
    }
    this.ws.onmessage = event => {
      console.log('WebSocket message:', event.data)
      try {
        const data = JSON.parse(event.data)
        // 简单的智能运维提醒
        if (data && data.type === 'maintenance_notice') {
          Message.warning(data.message || '有设备需要生成智能运维表单，请及时处理。')
        }
        // 分发给额外的业务处理函数
        this.handlers.forEach(fn => {
          try {
            fn(data)
          } catch (e) {
            console.error('WebSocket handler error', e)
          }
        })
      } catch (e) {
        // 不是 JSON 就忽略
      }
    }
    this.ws.onclose = () => {
      this.ws = null
      this.scheduleReconnect()
      Message.info('WebSocket 已断开，尝试重连')
    }
    this.ws.onerror = error => {
      console.error('WebSocket error', error)
    }
  }

  addHandler(fn) {
    if (typeof fn === 'function' && !this.handlers.includes(fn)) {
      this.handlers.push(fn)
    }
  }

  scheduleReconnect() {
    if (this.reconnectCount >= this.maxReconnectCount) {
      return
    }
    clearTimeout(this.reconnectTimer)
    this.reconnectTimer = setTimeout(() => {
      this.reconnectCount += 1
      this.connect(this.url)
    }, this.reconnectInterval)
  }

  send(payload) {
    if (this.ws && this.ws.readyState === WebSocket.OPEN) {
      this.ws.send(JSON.stringify(payload))
    }
  }

  close() {
    if (this.ws) {
      this.ws.close()
    }
  }
}

export default new WebSocketClient()
