import { Message } from 'element-ui'

class WebSocketClient {
  constructor() {
    this.ws = null
    this.url = null
    this.reconnectTimer = null
    this.reconnectCount = 0
    this.maxReconnectCount = 5
    this.reconnectInterval = 3000
  }

  connect(url) {
    if (!url) {
      throw new Error('WebSocket url is required')
    }
    this.url = url
    this.ws = new WebSocket(url)
    this.ws.onopen = () => {
      this.reconnectCount = 0
      Message.success('WebSocket 已连接')
    }
    this.ws.onmessage = event => {
      console.log('WebSocket message:', event.data)
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
