<template>
  <div class="app-container">
    <el-card class="chat-card">
      <div slot="header" class="chat-header">
        <span>聊天室</span>
        <div class="header-right">
          <span class="online-count">在线人数: {{ onlineCount }}</span>
          <el-tag :type="wsStatus === 'connected' ? 'success' : 'danger'" size="mini">
            {{ wsStatus === 'connected' ? '已连接' : '未连接' }}
          </el-tag>
        </div>
      </div>

      <div class="chat-container">
        <!-- 消息列表 -->
        <div class="chat-messages" ref="messagesContainer" v-loading="loading">
          <div v-if="messages.length === 0 && !loading" class="empty-message">
            <p>暂无消息，开始聊天吧！</p>
          </div>
          <div
            v-for="(message, index) in messages"
            :key="`msg-${index}-${message.timestamp || Date.now()}`"
            :class="['message-item', message.type]"
          >
            <div v-if="message.type === 'system'" class="system-message">
              {{ message.content }}
            </div>
            <div v-else-if="message.type === 'chat'" class="chat-message">
              <div class="message-header">
                <span class="user-name">{{ message.userName }}</span>
                <span class="message-time">{{ formatTime(message.timestamp) }}</span>
              </div>
              <div class="message-content">{{ message.content }}</div>
            </div>
          </div>
        </div>

        <!-- 输入区域 -->
        <div class="chat-input">
          <el-input
            v-model="inputMessage"
            type="textarea"
            :rows="3"
            placeholder="输入消息..."
            @keydown.ctrl.enter.native="sendMessage"
            @keydown.enter.native="handleEnterKey"
          />
          <div class="input-actions">
            <el-button type="primary" @click="sendMessage" :disabled="!canSend">发送</el-button>
            <el-button @click="clearMessages">清空</el-button>
          </div>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script>
import wsClient from '@/utils/websocket'
import { getToken } from '@/utils/auth'
import { getRecentMessages } from '@/api/chat/message'

export default {
  name: 'ChatRoom',
  data() {
    return {
      messages: [],
      inputMessage: '',
      onlineCount: 0,
      wsStatus: 'disconnected',
      canSend: false,
      messageHandler: null,
      loading: false
    }
  },
  mounted() {
    this.loadHistoryMessages()
  },
  beforeDestroy() {
    this.closeWebSocket()
  },
  methods: {
    /**
     * 加载历史消息
     */
    loadHistoryMessages() {
      this.loading = true
      getRecentMessages(50).then(response => {
        console.log('加载历史消息:', response)
        if (response.code === 200 && response.data) {
          // 转换历史消息格式
          this.messages = response.data.map(msg => {
            return {
              type: msg.messageType || 'chat',
              userId: msg.userId,
              userName: msg.userName,
              content: msg.content,
              timestamp: new Date(msg.createTime).getTime()
            }
          })
          console.log('历史消息加载完成，消息数量:', this.messages.length)
          
          // 滚动到底部
          this.$nextTick(() => {
            this.scrollToBottom()
          })
        }
      }).catch(error => {
        console.error('加载历史消息失败:', error)
        this.$message.error('加载历史消息失败')
      }).finally(() => {
        this.loading = false
        // 加载完历史消息后初始化WebSocket
        this.initWebSocket()
      })
    },

    /**
     * 初始化WebSocket连接
     */
    initWebSocket() {
      const token = getToken()
      if (!token) {
        this.$message.error('请先登录')
        this.$router.push('/login')
        return
      }

      // 绑定消息处理方法 - 确保this指向Vue实例
      const self = this
      this.messageHandler = function(message) {
        console.log('=== 消息处理器被调用 ===')
        console.log('消息处理器中的self:', self)
        console.log('self是Vue实例?', self.$options && self.$options.name)
        console.log('收到的消息:', message)
        try {
          self.handleMessage(message)
          console.log('handleMessage执行完成')
        } catch (error) {
          console.error('handleMessage执行失败:', error, error.stack)
        }
      }

      // 注册消息处理器
      wsClient.addMessageHandler(this.messageHandler)
      console.log('消息处理器已注册，处理器数量:', wsClient.messageHandlers.length)
      console.log('注册的处理器:', this.messageHandler)

      // 连接WebSocket
      wsClient.connect()

      // 监听连接状态
      this.checkConnectionStatus()
    },

    /**
     * 检查连接状态
     */
    checkConnectionStatus() {
      const interval = setInterval(() => {
        if (wsClient.ws) {
          if (wsClient.ws.readyState === WebSocket.OPEN) {
            this.wsStatus = 'connected'
            this.canSend = true
          } else if (wsClient.ws.readyState === WebSocket.CONNECTING) {
            this.wsStatus = 'connecting'
            this.canSend = false
          } else {
            this.wsStatus = 'disconnected'
            this.canSend = false
          }
        } else {
          this.wsStatus = 'disconnected'
          this.canSend = false
        }
      }, 1000)

      this.$once('hook:beforeDestroy', () => {
        clearInterval(interval)
      })
    },

    /**
     * 处理接收到的消息
     */
    handleMessage(message) {
      console.log('=== handleMessage被调用 ===')
      console.log('收到消息:', JSON.stringify(message, null, 2))
      console.log('消息类型:', message.type)
      console.log('this是Vue实例?', this.$options && this.$options.name)
      console.log('this.$data:', this.$data)
      console.log('当前messages长度:', this.messages.length)
      console.log('当前onlineCount:', this.onlineCount)
      
      // 确保this是Vue实例
      if (!this.$options || !this.$options.name) {
        console.error('this不是Vue实例！')
        return
      }
      
      // 更新在线人数
      if (message.onlineCount !== undefined && message.onlineCount !== null) {
        this.onlineCount = message.onlineCount
        console.log('更新在线人数为:', this.onlineCount)
        console.log('更新后this.$data.onlineCount:', this.$data.onlineCount)
      }
      
      // 处理不同类型的消息
      if (message.type === 'chat') {
        const chatMessage = {
          type: 'chat',
          userId: message.userId,
          userName: message.userName || '未知用户',
          content: message.content || '',
          timestamp: message.timestamp || Date.now()
        }
        console.log('准备添加聊天消息:', chatMessage)
        // 使用Vue.set确保响应式
        const newMessages = [...this.messages, chatMessage]
        this.messages = newMessages
        console.log('添加后messages长度:', this.messages.length)
        console.log('添加后this.$data.messages长度:', this.$data.messages.length)
        console.log('messages内容:', JSON.stringify(this.messages, null, 2))
      } else if (message.type === 'system') {
        const systemMessage = {
          type: 'system',
          content: message.content || '',
          timestamp: message.timestamp || Date.now()
        }
        console.log('准备添加系统消息:', systemMessage)
        // 使用Vue.set确保响应式
        const newMessages = [...this.messages, systemMessage]
        this.messages = newMessages
        console.log('添加后messages长度:', this.messages.length)
        console.log('添加后this.$data.messages长度:', this.$data.messages.length)
      } else if (message.type === 'welcome') {
        // 欢迎消息，更新在线人数
        console.log('欢迎加入聊天室，当前在线人数:', message.onlineCount)
        if (message.onlineCount !== undefined && message.onlineCount !== null) {
          this.onlineCount = message.onlineCount
          console.log('欢迎消息后，在线人数更新为:', this.onlineCount)
        }
      } else if (message.type === 'onlineCountUpdate') {
        // 仅更新在线人数（多标签页连接/断开时不显示系统消息）
        console.log('在线人数更新:', message.onlineCount)
        if (message.onlineCount !== undefined && message.onlineCount !== null) {
          this.onlineCount = message.onlineCount
          console.log('在线人数已更新为:', this.onlineCount)
        }
      }
      
      // 强制更新视图
      this.$forceUpdate()
      console.log('视图已强制更新，当前messages长度:', this.messages.length, '在线人数:', this.onlineCount)
      console.log('$forceUpdate后，this.$data.messages长度:', this.$data.messages.length)
      
      // 滚动到底部
      this.$nextTick(() => {
        this.scrollToBottom()
        console.log('滚动到底部')
      })
    },

    /**
     * 发送消息
     */
    sendMessage() {
      if (!this.inputMessage.trim()) {
        this.$message.warning('请输入消息内容')
        return
      }

      if (!this.canSend) {
        this.$message.warning('WebSocket未连接，无法发送消息')
        return
      }

      const message = this.inputMessage.trim()
      console.log('准备发送消息:', message)
      console.log('WebSocket状态:', wsClient.ws ? wsClient.ws.readyState : 'null')
      console.log('canSend状态:', this.canSend)
      
      if (wsClient.ws && wsClient.ws.readyState === WebSocket.OPEN) {
        try {
          wsClient.send(message)
          this.inputMessage = ''
        } catch (error) {
          console.error('发送消息失败:', error)
          this.$message.error('发送消息失败: ' + error.message)
        }
      } else {
        this.$message.error('WebSocket未连接，无法发送消息')
      }
    },

    /**
     * 处理Enter键
     */
    handleEnterKey(event) {
      if (event.ctrlKey) {
        // Ctrl+Enter 发送消息
        this.sendMessage()
      }
      // 普通Enter键不做处理，允许换行
    },

    /**
     * 清空消息
     */
    clearMessages() {
      this.$confirm('确定要清空所有消息吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.messages = []
      })
    },

    /**
     * 滚动到底部
     */
    scrollToBottom() {
      const container = this.$refs.messagesContainer
      if (container) {
        container.scrollTop = container.scrollHeight
      }
    },

    /**
     * 格式化时间
     */
    formatTime(timestamp) {
      if (!timestamp) return ''
      const date = new Date(timestamp)
      const hours = String(date.getHours()).padStart(2, '0')
      const minutes = String(date.getMinutes()).padStart(2, '0')
      const seconds = String(date.getSeconds()).padStart(2, '0')
      return `${hours}:${minutes}:${seconds}`
    },

    /**
     * 关闭WebSocket连接
     */
    closeWebSocket() {
      if (this.messageHandler) {
        wsClient.removeMessageHandler(this.messageHandler)
      }
      wsClient.close()
    }
  }
}
</script>

<style scoped lang="scss">
.app-container {
  padding: 20px;
}

.chat-card {
  height: calc(100vh - 120px);
  
  ::v-deep .el-card__body {
    height: 100%;
    display: flex;
    flex-direction: column;
    overflow: hidden;
    padding: 15px;
  }
}

.chat-header {
  display: flex;
  justify-content: space-between;
  align-items: center;

  .header-right {
    display: flex;
    align-items: center;
    gap: 10px;

    .online-count {
      font-size: 14px;
      color: #666;
    }
  }
}

.chat-container {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 15px;
  background-color: #f5f5f5;
  border-radius: 4px;
  margin-bottom: 15px;
  min-height: 300px;
  max-height: calc(100vh - 350px);

  .empty-message {
    text-align: center;
    padding: 40px 20px;
    color: #999;
    font-size: 14px;
  }

  .message-item {
    margin-bottom: 15px;
    display: block;
    clear: both;

    &.system {
      text-align: center;
      
      .system-message {
        display: inline-block;
        color: #999;
        font-size: 12px;
        padding: 8px 15px;
        background-color: #e9e9eb;
        border-radius: 4px;
      }
    }

    &.chat {
      .chat-message {
        display: block;
        background-color: #fff;
        padding: 12px 15px;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        max-width: 80%;

        .message-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 8px;
          font-size: 12px;

          .user-name {
            font-weight: bold;
            color: #409eff;
            font-size: 14px;
          }

          .message-time {
            color: #999;
            font-size: 11px;
            margin-left: 10px;
          }
        }

        .message-content {
          color: #333;
          font-size: 14px;
          line-height: 1.6;
          word-wrap: break-word;
          white-space: pre-wrap;
        }
      }
    }
  }
}

.chat-input {
  .input-actions {
    margin-top: 10px;
    text-align: right;
  }
}

/* 滚动条样式 */
.chat-messages::-webkit-scrollbar {
  width: 6px;
}

.chat-messages::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 3px;
}

.chat-messages::-webkit-scrollbar-thumb {
  background: #888;
  border-radius: 3px;
}

.chat-messages::-webkit-scrollbar-thumb:hover {
  background: #555;
}

.empty-message {
  text-align: center;
  padding: 40px 20px;
  color: #999;
  font-size: 14px;
}
</style>

