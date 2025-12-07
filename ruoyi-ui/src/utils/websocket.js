import { getToken } from '@/utils/auth'

/**
 * WebSocket工具类 - 聊天室
 */
class WebSocketClient {
  constructor() {
    this.ws = null
    this.reconnectTimer = null
    this.reconnectCount = 0
    this.maxReconnectCount = 5
    this.reconnectInterval = 3000
    this.url = null
    this.messageHandlers = []
    this.isConnected = false
    this.isManualClose = false // 标记是否为手动关闭
  }

  /**
   * 连接WebSocket
   */
  connect() {
    if (this.ws && this.ws.readyState === WebSocket.OPEN) {
      console.log('WebSocket已连接')
      return
    }

    const token = getToken()
    if (!token) {
      console.error('无法连接WebSocket: 未获取到token')
      return
    }

    // 构建WebSocket URL
    const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:'
    
    // 开发环境使用代理，生产环境使用当前域名
    let host = window.location.hostname
    let port = window.location.port
    
    if (process.env.NODE_ENV === 'development') {
      // 开发环境：使用代理（通过前端服务器转发到后端）
      // 前端服务运行在80端口，通过代理转发到后端的8080端口
      host = window.location.hostname
      port = window.location.port || '80'
    } else {
      // 生产环境：直接使用当前域名和端口
      host = window.location.hostname
      port = window.location.port
    }
    
    const wsPath = '/websocket/chat'
    const portStr = port && port !== '80' && port !== '443' ? `:${port}` : ''
    this.url = `${protocol}//${host}${portStr}${wsPath}?token=${token}`
    
    console.log('WebSocket连接URL:', this.url)

    try {
      this.ws = new WebSocket(this.url)
      this.bindEvents()
    } catch (error) {
      console.error('WebSocket连接失败:', error)
      this.reconnect()
    }
  }

  /**
   * 绑定WebSocket事件
   */
  bindEvents() {
    this.ws.onopen = (event) => {
      console.log('WebSocket连接成功', event)
      this.isConnected = true
      this.reconnectCount = 0
      this.onOpen(event)
    }

    this.ws.onmessage = (event) => {
      try {
        const message = JSON.parse(event.data)
        console.log('WebSocket收到消息:', message)
        console.log('注册的处理器数量:', this.messageHandlers.length)
        this.onMessage(message)
        // 通知所有注册的处理器
        this.messageHandlers.forEach((handler, index) => {
          console.log(`调用处理器 ${index}:`, typeof handler === 'function')
          if (typeof handler === 'function') {
            try {
              console.log('执行处理器:', handler)
              handler(message)
              console.log('处理器执行完成')
            } catch (error) {
              console.error('消息处理器执行失败:', error, error.stack)
            }
          } else {
            console.warn('处理器不是函数:', handler)
          }
        })
      } catch (error) {
        console.error('解析WebSocket消息失败:', error, event.data)
      }
    }

    this.ws.onerror = (error) => {
      console.error('WebSocket错误:', error)
      this.onError(error)
    }

    this.ws.onclose = (event) => {
      console.log('WebSocket连接关闭', event)
      console.log('关闭码:', event.code, '关闭原因:', event.reason)
      this.isConnected = false
      this.onClose(event)
      
      // 如果是手动关闭，不进行重连
      if (this.isManualClose) {
        console.log('手动关闭连接，不进行自动重连')
        this.isManualClose = false // 重置标志
        return
      }
      
      // 如果关闭码是 4000，表示被新连接替代，不进行重连
      if (event.code === 4000 || (event.reason && event.reason.includes('新连接已建立'))) {
        console.log('检测到被新连接替代，停止重连')
        this.reconnectCount = this.maxReconnectCount // 标记为已达到上限，不再重连
        return
      }
      
      // 其他情况，如果未达到重连上限，则自动重连
      if (this.reconnectCount < this.maxReconnectCount) {
        this.reconnect()
      }
    }
  }

  /**
   * 发送消息
   */
  send(message) {
    if (this.ws && this.ws.readyState === WebSocket.OPEN) {
      const messageData = {
        type: 'chat',
        content: message
      }
      const messageStr = JSON.stringify(messageData)
      console.log('发送WebSocket消息:', messageStr)
      this.ws.send(messageStr)
    } else {
      console.error('WebSocket未连接，无法发送消息。状态:', this.ws ? this.ws.readyState : 'null')
    }
  }

  /**
   * 关闭连接
   */
  close() {
    this.isManualClose = true // 标记为手动关闭
    if (this.reconnectTimer) {
      clearTimeout(this.reconnectTimer)
      this.reconnectTimer = null
    }
    if (this.ws) {
      this.ws.close()
      this.ws = null
    }
    this.isConnected = false
    this.reconnectCount = 0 // 重置重连计数
  }

  /**
   * 重连
   */
  reconnect() {
    if (this.reconnectCount >= this.maxReconnectCount) {
      console.error('WebSocket重连次数已达上限')
      return
    }

    this.reconnectCount++
    console.log(`WebSocket重连中... (${this.reconnectCount}/${this.maxReconnectCount})`)

    this.reconnectTimer = setTimeout(() => {
      this.connect()
    }, this.reconnectInterval)
  }

  /**
   * 注册消息处理器
   */
  addMessageHandler(handler) {
    if (typeof handler === 'function') {
      this.messageHandlers.push(handler)
      console.log('消息处理器已注册，当前处理器数量:', this.messageHandlers.length)
    }
  }

  /**
   * 移除消息处理器
   */
  removeMessageHandler(handler) {
    const index = this.messageHandlers.indexOf(handler)
    if (index > -1) {
      this.messageHandlers.splice(index, 1)
      console.log('消息处理器已移除，当前处理器数量:', this.messageHandlers.length)
    }
  }

  /**
   * 连接打开事件（内部使用，可重写）
   */
  onOpen(event) {
    // 子类可重写此方法
  }

  /**
   * 消息接收事件（内部使用，可重写）
   */
  onMessage(message) {
    // 子类可重写此方法，用于内部处理
  }

  /**
   * 错误事件（内部使用，可重写）
   */
  onError(error) {
    // 子类可重写此方法
  }

  /**
   * 连接关闭事件（内部使用，可重写）
   */
  onClose(event) {
    // 子类可重写此方法
  }
}

// 创建单例
const wsClient = new WebSocketClient()

export default wsClient

