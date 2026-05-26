<template>
  <div class="app-container chat-container">
    <el-row :gutter="20">
      <!-- 左侧：对话区域 -->
      <el-col :span="16" :xs="24">
        <el-card class="chat-card">
          <div slot="header" class="card-header">
            <span>智能问答</span>
            <el-button-group>
              <el-button size="mini" :type="chatMode === 'basic' ? 'primary' : ''" @click="chatMode = 'basic'">基础对话</el-button>
              <el-button size="mini" :type="chatMode === 'rag' ? 'primary' : ''" @click="chatMode = 'rag'">知识库问答</el-button>
              <el-button size="mini" :type="chatMode === 'db' ? 'primary' : ''" @click="chatMode = 'db'">数据库查询</el-button>
            </el-button-group>
          </div>

          <!-- 消息列表 -->
          <div class="chat-messages" ref="messagesContainer">
            <div v-if="messages.length === 0 && !loading" class="empty-message">
              <p>👋 欢迎使用智能电网运维系统</p>
              <p v-if="currentConversationId">已加载会话，暂无消息</p>
              <p v-else>请选择对话模式开始提问，或点击"新建对话"开始新会话</p>
            </div>
            <div
              v-for="(msg, index) in messages"
              :key="`msg-${index}-${msg.timestamp}`"
              :class="['message-item', msg.role === 'user' ? 'user-message' : 'ai-message']"
            >
              <div class="message-avatar">
                <i v-if="msg.role === 'user'" class="el-icon-user"></i>
                <i v-else class="el-icon-cpu"></i>
              </div>
              <div class="message-content">
                <div class="message-text" v-html="formatMessage(msg.content)"></div>
                <div class="message-time">{{ formatTime(msg.timestamp) }}</div>
                <div v-if="msg.sql" class="message-sql">
                  <el-tag size="mini" type="info">SQL</el-tag>
                  <pre>{{ msg.sql }}</pre>
                </div>
              </div>
            </div>
            <div v-if="loading" class="message-item ai-message">
              <div class="message-avatar">
                <i class="el-icon-loading"></i>
              </div>
              <div class="message-content">
                <div class="message-text">正在思考中...</div>
              </div>
            </div>
          </div>

          <!-- 输入区域 -->
          <div class="chat-input">
            <el-input
              v-model="inputMessage"
              type="textarea"
              :rows="3"
              placeholder="请输入您的问题..."
              @keydown.ctrl.enter.native="sendMessage"
              :disabled="loading"
            />
            <div class="input-actions">
              <el-button
                type="primary"
                :loading="loading"
                @click="sendMessage"
                :disabled="!inputMessage.trim()"
              >
                发送 (Ctrl+Enter)
              </el-button>
              <el-button @click="clearMessages" :disabled="messages.length === 0">清空对话</el-button>
            </div>
          </div>
        </el-card>
      </el-col>

      <!-- 右侧：功能面板 -->
      <el-col :span="8" :xs="24">
        <!-- 会话列表 -->
        <el-card class="side-card conversation-card">
          <div slot="header" class="conversation-header">
            <el-button 
              type="primary" 
              size="mini" 
              icon="el-icon-plus" 
              @click="createNewConversation"
              :disabled="loading"
            >
              新建对话
            </el-button>
          </div>
          <div class="conversation-list" v-loading="historyLoading">
            <div v-if="conversationList.length === 0 && !historyLoading" class="empty-info">
              <p>暂无对话记录</p>
              <p style="font-size: 12px; color: #999; margin-top: 10px;">点击"新建对话"开始聊天</p>
            </div>
            <div v-else class="conversation-items">
              <div
                v-for="conversation in conversationList"
                :key="conversation.id"
                :class="['conversation-item', { 'active': currentConversationId === conversation.id }]"
                @click="loadConversation(conversation)"
                @contextmenu.prevent="showContextMenu($event, conversation)"
              >
                <div class="conversation-item-content">
                  <div class="conversation-title">
                    <i class="el-icon-chat-line-round"></i>
                    <span>{{ conversation.title }}</span>
                  </div>
                  <div class="conversation-preview">
                    {{ conversation.preview }}
                  </div>
                  <div class="conversation-meta">
                    <span class="conversation-time">{{ formatHistoryTime(conversation.lastTime) }}</span>
                    <span class="conversation-count">{{ conversation.messageCount }} 条消息</span>
                  </div>
                </div>
                <div 
                  class="conversation-delete" 
                  @click.stop="deleteConversation(conversation)"
                  v-if="currentConversationId === conversation.id"
                >
                  <i class="el-icon-delete"></i>
                </div>
              </div>
            </div>
          </div>
        </el-card>

        <!-- 知识库管理 -->
        <el-card class="side-card" v-if="chatMode === 'rag'">
          <div slot="header">
            <span>知识库管理</span>
          </div>
          <el-form :model="documentForm" label-width="80px" size="small">
            <el-form-item label="文档标题">
              <el-input v-model="documentForm.title" placeholder="请输入标题" />
            </el-form-item>
            <el-form-item label="文档分类">
              <el-input v-model="documentForm.category" placeholder="如：设备维护" />
            </el-form-item>
            <el-form-item label="文档内容">
              <el-input
                v-model="documentForm.content"
                type="textarea"
                :rows="6"
                placeholder="请输入文档内容..."
              />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" size="mini" @click="addDocument" :loading="docLoading">添加文档</el-button>
              <el-button size="mini" @click="clearKnowledgeBase">清空知识库</el-button>
            </el-form-item>
          </el-form>
        </el-card>

        <!-- 数据库信息 -->
        <el-card class="side-card" v-if="chatMode === 'db'">
          <div slot="header">
            <span>数据库信息</span>
            <el-button size="mini" style="float: right" @click="loadDatabaseInfo" :loading="dbLoading">刷新</el-button>
          </div>
          <div v-if="dbStats" class="db-info">
            <pre style="white-space: pre-wrap; word-wrap: break-word;">{{ dbStats }}</pre>
          </div>
          <div v-else-if="!dbLoading" class="empty-info">
            <p>点击刷新查看数据库统计信息</p>
          </div>
          <div v-else class="empty-info">
            <p>正在加载...</p>
          </div>
        </el-card>

      </el-col>
    </el-row>
  </div>
</template>

<script>
import { chat, askWithRag, addDocument, clearKnowledgeBase, askDatabase, getDatabaseStats, getChatHistory, getChatHistoryById, deleteChatRecords } from "@/api/ai/chat";

export default {
  name: "AiChat",
  data() {
    return {
      chatMode: "basic", // basic, rag, db
      // 为每个模式维护独立的对话历史
      basicMessages: [],
      ragMessages: [],
      dbMessages: [],
      inputMessage: "",
      loading: false,
      docLoading: false,
      eventSource: null,
      documentForm: {
        title: "",
        category: "",
        content: ""
      },
      dbStats: "",
      dbLoading: false,
      historyList: [],
      historyLoading: false,
      selectedHistoryId: null,
      conversationList: [],
      currentConversationId: null,
      conversationMessages: {}, // 存储每个会话的消息 { conversationId: [messages] }
      newConversationStartTime: null // 新会话开始时间，用于区分会话
    };
  },
  computed: {
    // 根据当前模式返回对应的消息列表
    messages() {
      switch (this.chatMode) {
        case 'basic':
          return this.basicMessages;
        case 'rag':
          return this.ragMessages;
        case 'db':
          return this.dbMessages;
        default:
          return [];
      }
    }
  },
  mounted() {
    this.scrollToBottom();
    if (this.chatMode === "db") {
      this.loadDatabaseInfo();
    }
    this.loadConversations();
  },
  watch: {
    chatMode(newMode, oldMode) {
      // 切换模式时加载对应模式的会话列表
      this.loadConversations();
      
      // 如果是切换到数据库模式，加载数据库信息
      if (newMode === "db") {
        this.loadDatabaseInfo();
      }
      
      // 切换模式时创建新会话
      this.createNewConversation();
      
      // 滚动到底部
      this.$nextTick(() => {
        this.scrollToBottom();
      });
    }
  },
  methods: {
    // 发送消息
    async sendMessage() {
      if (!this.inputMessage.trim() || this.loading) return;

      const userMessage = this.inputMessage.trim();
      if (!this.currentConversationId) {
        this.currentConversationId = this.generateConversationId();
      }
      this.inputMessage = "";
      
      // 获取当前模式的消息数组
      const currentMessages = this.getCurrentMessages();
      
      // 添加用户消息到当前模式的消息数组
      currentMessages.push({
        role: "user",
        content: userMessage,
        timestamp: new Date()
      });

      this.loading = true;
      this.scrollToBottom();

      try {
        let response;
        if (this.chatMode === "basic") {
          // 基础对话（流式）
          this.startStream("/springai/chat/stream", { input: userMessage, conversationId: this.currentConversationId });
          return;
        } else if (this.chatMode === "rag") {
          // RAG问答（流式）
          this.startStream("/springai/rag/ask/stream", { question: userMessage, topK: 3, conversationId: this.currentConversationId });
          return;
        } else if (this.chatMode === "db") {
          // 数据库查询
          response = await askDatabase(userMessage, this.currentConversationId);
        }

        if (response.code === 200) {
          const aiMessage = {
            role: "ai",
            content: "",
            timestamp: new Date()
          };

          if (this.chatMode === "db") {
            // 数据库查询模式
            const res = response.data || {};
            const rows = res.rawData || res.data || [];
            const rowCount = res.rowCount != null ? res.rowCount : (Array.isArray(rows) ? rows.length : 0);
            const summary = res.aiSummary || res.readableSummary;

            if (res.error && res.error !== "null") {
              aiMessage.content = "查询失败：" + res.error;
            } else if (summary) {
              aiMessage.content = `查询结果（${rowCount} 条）\n` + summary;
            } else {
              aiMessage.content = `查询结果（${rowCount} 条）\n` +
                (Array.isArray(rows) ? JSON.stringify(rows, null, 2) : JSON.stringify(res, null, 2));
            }

            if (res.sql) {
              aiMessage.sql = res.sql;
            }
          } else {
            // 基础对话或RAG模式
            aiMessage.content = response.data || response.msg || "未收到回复";
          }

          // 获取当前模式的消息数组并添加AI回复
          const currentMessages = this.getCurrentMessages();
          currentMessages.push(aiMessage);
        } else {
          const currentMessages = this.getCurrentMessages();
          currentMessages.push({
            role: "ai",
            content: "抱歉，处理您的请求时出现错误：" + response.msg,
            timestamp: new Date()
          });
        }
        
        // 发送消息成功后刷新会话列表
        this.loadConversations();
      } catch (error) {
        console.error("发送消息失败:", error);
        const currentMessages = this.getCurrentMessages();
        currentMessages.push({
          role: "ai",
          content: "抱歉，服务暂时不可用，请稍后重试。",
          timestamp: new Date()
        });
      } finally {
        this.loading = false;
        this.$nextTick(() => {
          this.scrollToBottom();
        });
      }
    },

    // 开始 SSE 流
    startStream(url, params) {
      // 关闭已有连接
      if (this.eventSource) {
        this.eventSource.close();
        this.eventSource = null;
      }

      const query = Object.keys(params)
        .map(key => `${encodeURIComponent(key)}=${encodeURIComponent(params[key])}`)
        .join("&");
      const fullUrl = `${process.env.VUE_APP_BASE_API}${url}?${query}`;

      // 获取当前模式的消息数组
      const currentMessages = this.getCurrentMessages();
      
      const aiMessage = {
        role: "ai",
        content: "",
        timestamp: new Date()
      };
      currentMessages.push(aiMessage);
      this.scrollToBottom();

      try {
        const es = new EventSource(fullUrl);
        this.eventSource = es;

        es.onmessage = (event) => {
          if (event.data) {
            aiMessage.content += event.data;
            this.$forceUpdate();
            this.scrollToBottom();
          }
        };

        es.onerror = (error) => {
          console.log("SSE流结束或出错:", error);
          if (this.loading) {
            aiMessage.content = aiMessage.content || "流已结束";
          }
          es.close();
          this.eventSource = null;
          this.loading = false;
          // 流式响应结束后刷新会话列表
          setTimeout(() => {
            this.loadConversations();
          }, 500); // 延迟500ms确保后端已保存
        };

        es.onopen = () => {
          this.loading = true;
        };
      } catch (error) {
        aiMessage.content = "流式连接失败：" + error.message;
        this.loading = false;
      } finally {
        // 当 SSE 自然结束时会触发 onerror，loading 已在 onerror 中关闭
      }
    },

    // 添加文档
    async addDocument() {
      if (!this.documentForm.content.trim()) {
        this.$modal.msgWarning("请输入文档内容");
        return;
      }

      this.docLoading = true;
      try {
        const response = await addDocument(
          this.documentForm.content,
          this.documentForm.title || "未命名文档",
          this.documentForm.category || "默认分类"
        );

        if (response.code === 200) {
          this.$modal.msgSuccess("文档添加成功");
          this.documentForm = {
            title: "",
            category: "",
            content: ""
          };
        } else {
          this.$modal.msgError(response.msg || "添加失败");
        }
      } catch (error) {
        this.$modal.msgError("添加文档失败：" + error.message);
      } finally {
        this.docLoading = false;
      }
    },

    // 清空知识库
    async clearKnowledgeBase() {
      try {
        await this.$confirm("确定要清空知识库吗？此操作不可恢复。", "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        });

        const response = await clearKnowledgeBase();
        if (response.code === 200) {
          this.$modal.msgSuccess("知识库已清空");
        } else {
          this.$modal.msgError(response.msg || "清空失败");
        }
      } catch (error) {
        if (error !== "cancel") {
          this.$modal.msgError("清空失败：" + error.message);
        }
      }
    },

    // 加载数据库信息
    async loadDatabaseInfo() {
      this.dbLoading = true;
      this.dbStats = ""; // 清空之前的数据
      try {
        console.log("开始加载数据库统计信息...");
        const response = await getDatabaseStats();
        console.log("数据库统计信息完整响应:", JSON.stringify(response, null, 2));
        console.log("响应类型:", typeof response);
        console.log("响应 code:", response.code);
        console.log("响应 data 类型:", typeof response.data);
        console.log("响应 data 值:", response.data);
        console.log("响应 data 是否为 null:", response.data === null);
        console.log("响应 data 是否为 undefined:", response.data === undefined);
        
        if (response && response.code === 200) {
          const data = response.data;
          console.log("处理 data，类型:", typeof data, "值:", data);
          
          // 处理字符串类型
          if (typeof data === "string") {
            if (data.trim().length > 0) {
              this.dbStats = data;
              console.log("数据库统计信息加载成功，长度:", data.length);
            } else {
              console.warn("数据库统计信息为空字符串");
              this.dbStats = "暂无数据\n\n数据库统计信息为空，请检查数据库连接。";
            }
          } 
          // 处理对象类型
          else if (data && typeof data === "object") {
            console.log("数据是对象，转换为 JSON");
            this.dbStats = JSON.stringify(data, null, 2);
          } 
          // 处理 null 或 undefined
          else if (data === null || data === undefined) {
            console.warn("数据库统计信息为 null 或 undefined");
            this.dbStats = "暂无数据\n\n后端返回的数据为空，请检查：\n1. 数据库连接是否正常\n2. 数据库表是否存在\n3. 后端日志是否有错误";
          }
          // 其他类型（数字、布尔等）
          else {
            console.warn("数据库统计信息类型异常:", typeof data, data);
            this.dbStats = String(data) || "暂无数据\n\n数据类型异常，请检查后端返回格式。";
          }
        } else {
          const errorMsg = (response && response.msg) || "未知错误";
          console.error("获取数据库信息失败，code:", response ? response.code : "无响应", "msg:", errorMsg);
          this.dbStats = "获取数据库信息失败：\n" + errorMsg + "\n\n请检查：\n1. 数据库连接是否正常\n2. 数据库表是否存在\n3. 后端服务是否正常运行";
        }
      } catch (error) {
        console.error("加载数据库信息失败:", error);
        console.error("错误堆栈:", error.stack);
        const errorMsg = error.message || error.toString();
        this.dbStats = "获取数据库信息失败：\n" + errorMsg + "\n\n请检查：\n1. 网络连接是否正常\n2. 后端服务是否运行\n3. API 接口是否可访问";
      } finally {
        this.dbLoading = false;
      }
    },


    // 获取当前模式的消息数组
    getCurrentMessages() {
      switch (this.chatMode) {
        case 'basic':
          return this.basicMessages;
        case 'rag':
          return this.ragMessages;
        case 'db':
          return this.dbMessages;
        default:
          return [];
      }
    },

    // 清空当前模式的对话
    clearMessages() {
      const currentMessages = this.getCurrentMessages();
      currentMessages.length = 0; // 清空数组
      this.selectedHistoryId = null;
      if (this.eventSource) {
        this.eventSource.close();
        this.eventSource = null;
      }
    },

    // 加载会话列表
    async loadConversations() {
      this.historyLoading = true;
      try {
        const response = await getChatHistory(this.chatMode);
        if (response.code === 200) {
          const records = response.data || [];
          // 将记录组织成会话（按时间窗口，30分钟内的对话属于一个会话）
          this.conversationList = this.organizeConversations(records);
        } else {
          this.conversationList = [];
        }
      } catch (error) {
        console.error("加载会话列表失败:", error);
        this.conversationList = [];
      } finally {
        this.historyLoading = false;
      }
    },

    // 将记录组织成会话
    organizeConversations(records) {
      if (!records || records.length === 0) return [];
      
      const conversations = [];
      let currentConversation = null;
      const TIME_WINDOW = 30 * 60 * 1000; // 30分钟
      const conversationMap = {};
      
      // 按时间正序处理记录（从最早到最新）
      const sortedRecords = [...records].sort((a, b) => {
        const timeA = new Date(a.createTime).getTime();
        const timeB = new Date(b.createTime).getTime();
        return timeA - timeB; // 正序排列
      });
      
      for (const record of sortedRecords) {
        const recordTime = new Date(record.createTime).getTime();
        const backendConversationId = record.conversationId;
        
        if (backendConversationId) {
          let conv = conversationMap[backendConversationId];
          if (!conv) {
            conv = {
              id: backendConversationId,
              title: this.truncateText(record.userMessage || '新对话', 20),
              preview: this.truncateText(record.aiMessage || record.userMessage || '', 50),
              lastTime: recordTime,
              firstTime: recordTime,
              messageCount: 0,
              records: [],
              chatType: record.chatType
            };
            conversationMap[backendConversationId] = conv;
            conversations.push(conv);
          }
          conv.records.push(record);
          conv.messageCount++;
          conv.lastTime = Math.max(conv.lastTime, recordTime);
          conv.firstTime = Math.min(conv.firstTime, recordTime);
          if (record.aiMessage) {
            conv.preview = this.truncateText(record.aiMessage, 50);
          }
          continue;
        }
        
        // 如果新会话开始时间存在，且记录时间在新会话开始时间之后，创建新会话
        const isNewConversation = this.newConversationStartTime && 
                                   recordTime >= this.newConversationStartTime;
        
        if (!currentConversation || 
            isNewConversation ||
            (recordTime - currentConversation.lastTime > TIME_WINDOW)) {
          // 创建新会话
          currentConversation = {
            id: `conv_${record.recordId}_${recordTime}`,
            title: this.truncateText(record.userMessage || '新对话', 20),
            preview: this.truncateText(record.aiMessage || record.userMessage || '', 50),
            lastTime: recordTime,
            firstTime: recordTime,
            messageCount: 1,
            records: [record],
            chatType: record.chatType
          };
          conversations.push(currentConversation);
        } else {
          // 添加到当前会话
          currentConversation.records.push(record);
          currentConversation.messageCount++;
          currentConversation.lastTime = recordTime; // 更新最后时间
          // 更新预览为最新的消息
          if (record.aiMessage) {
            currentConversation.preview = this.truncateText(record.aiMessage, 50);
          }
        }
      }
      
      // 按最后时间倒序排列（最新的在前）
      conversations.sort((a, b) => b.lastTime - a.lastTime);
      
      return conversations;
    },

    // 创建新会话
    createNewConversation() {
      console.log("创建新会话，当前模式:", this.chatMode);
      
      // 关闭当前流式连接
      if (this.eventSource) {
        this.eventSource.close();
        this.eventSource = null;
      }
      
      // 停止加载状态
      this.loading = false;
      
      // 清空输入框
      this.inputMessage = "";
      
      // 重置会话ID和选中状态
      this.currentConversationId = this.generateConversationId();
      this.selectedHistoryId = null;
      
      // 设置新会话开始时间（用于区分新会话）
      this.newConversationStartTime = new Date().getTime();
      console.log("新会话开始时间:", this.newConversationStartTime);
      console.log("新会话ID:", this.currentConversationId);
      
      // 根据当前模式清空对应的消息数组（使用 Vue 的响应式方式）
      switch (this.chatMode) {
        case 'basic':
          this.basicMessages = [];
          console.log("清空基础对话消息");
          break;
        case 'rag':
          this.ragMessages = [];
          console.log("清空知识库问答消息");
          break;
        case 'db':
          this.dbMessages = [];
          console.log("清空数据库查询消息");
          break;
      }
      
      // 使用 $nextTick 确保响应式更新
      this.$nextTick(() => {
        console.log("新会话创建完成，当前消息数量:", this.messages.length);
        
        // 刷新会话列表
        this.loadConversations();
        
        // 滚动到底部
        this.scrollToBottom();
        
        // 强制更新视图
        this.$forceUpdate();
      });
    },

    // 加载会话
    async loadConversation(conversation) {
      if (!conversation || !conversation.records) return;
      
      console.log("加载会话:", conversation.id, "消息数:", conversation.messageCount);
      
      this.currentConversationId = conversation.id;
      // 清空新会话开始时间，因为已经加载了历史会话
      this.newConversationStartTime = null;
      
      // 根据当前模式清空对应的消息数组
      switch (this.chatMode) {
        case 'basic':
          this.basicMessages = [];
          break;
        case 'rag':
          this.ragMessages = [];
          break;
        case 'db':
          this.dbMessages = [];
          break;
      }
      
      const currentMessages = this.getCurrentMessages();
      
      // 按时间正序加载消息
      const sortedRecords = [...conversation.records].sort((a, b) => {
        return new Date(a.createTime).getTime() - new Date(b.createTime).getTime();
      });
      
      for (const record of sortedRecords) {
        // 添加用户消息
        if (record.userMessage) {
          currentMessages.push({
            role: "user",
            content: record.userMessage,
            timestamp: record.createTime ? new Date(record.createTime) : new Date()
          });
        }
        
        // 添加AI回复
        if (record.aiMessage) {
          currentMessages.push({
            role: "ai",
            content: record.aiMessage,
            timestamp: record.createTime ? new Date(record.createTime) : new Date()
          });
        }
      }
      
      console.log("加载会话完成，消息数量:", currentMessages.length);
      
      this.$nextTick(() => {
        this.scrollToBottom();
        this.$forceUpdate();
      });
    },

    // 删除会话
    async deleteConversation(conversation) {
      try {
        await this.$confirm(`确定要删除会话"${conversation.title}"吗？此操作将删除该会话的所有消息。`, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        });
        
        // 删除该会话的所有记录
        const recordIds = conversation.records.map(r => r.recordId).filter(id => id != null);
        if (recordIds.length > 0) {
          try {
            const response = await deleteChatRecords(recordIds);
            if (response.code === 200) {
              this.$modal.msgSuccess("删除成功");
            } else {
              this.$modal.msgError(response.msg || "删除失败");
            }
          } catch (error) {
            console.error("删除记录失败:", error);
            this.$modal.msgError("删除失败：" + (error.message || "未知错误"));
          }
        }
        
        // 如果删除的是当前会话，清空对话
        if (this.currentConversationId === conversation.id) {
          this.createNewConversation();
        }
        
        // 重新加载会话列表
        this.loadConversations();
      } catch (error) {
        if (error !== 'cancel') {
          console.error("删除会话失败:", error);
        }
      }
    },

    // 显示右键菜单
    showContextMenu(event, conversation) {
      // 可以在这里实现右键菜单功能
      console.log("右键菜单:", conversation);
    },


    // 获取对话类型名称
    getChatTypeName(chatType) {
      const typeMap = {
        'basic': '基础对话',
        'rag': '知识库问答',
        'db': '数据库查询'
      };
      return typeMap[chatType] || chatType;
    },

    // 格式化历史记录时间
    formatHistoryTime(time) {
      if (!time) return '';
      const date = new Date(time);
      const now = new Date();
      const diff = now - date;
      const minutes = Math.floor(diff / 60000);
      const hours = Math.floor(diff / 3600000);
      const days = Math.floor(diff / 86400000);
      
      if (minutes < 1) return '刚刚';
      if (minutes < 60) return `${minutes}分钟前`;
      if (hours < 24) return `${hours}小时前`;
      if (days < 7) return `${days}天前`;
      
      return date.toLocaleDateString('zh-CN', { month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit' });
    },

    // 截断文本
    truncateText(text, maxLength) {
      if (!text) return '';
      if (text.length <= maxLength) return text;
      return text.substring(0, maxLength) + '...';
    },

    generateConversationId() {
      return `conv_${Date.now()}_${Math.random().toString(36).slice(2, 10)}`;
    },

    // 格式化消息 - 去除Markdown符号并处理换行
    formatMessage(content) {
      if (!content) return "";
      // 去除Markdown符号
      let formatted = content
        .replace(/^#+\s*/gm, "") // 去除标题符号 #
        .replace(/\*\*(.*?)\*\*/g, "$1") // 去除粗体 **
        .replace(/\*(.*?)\*/g, "$1") // 去除斜体 *
        .replace(/`(.*?)`/g, "$1") // 去除代码块 `
        .replace(/```[\s\S]*?```/g, "") // 去除代码块
        .replace(/\[(.*?)\]\(.*?\)/g, "$1") // 去除链接
        .replace(/^\s*[-*+]\s+/gm, "") // 去除列表符号
        .replace(/^\s*\d+\.\s+/gm, "") // 去除有序列表
        .replace(/\n/g, "<br>"); // 换行处理
      return formatted;
    },

    // 格式化时间
    formatTime(timestamp) {
      const date = new Date(timestamp);
      return date.toLocaleTimeString("zh-CN", { hour: "2-digit", minute: "2-digit" });
    },

    // 滚动到底部
    scrollToBottom() {
      this.$nextTick(() => {
        const container = this.$refs.messagesContainer;
        if (container) {
          container.scrollTop = container.scrollHeight;
        }
      });
    }
  }
};
</script>

<style scoped lang="scss">
@import "~@/assets/styles/variables.scss";

.chat-container {
  padding: 20px;
  height: calc(100vh - 120px);
}

.chat-card,
.side-card {
  background: $secondary-bg !important;
  border: 1px solid $border-color !important;
  height: 100%;

  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    color: $text-primary !important;
    font-weight: 600 !important;
    font-size: 16px !important;
  }

  .el-card__body {
    display: flex;
    flex-direction: column;
    height: calc(100% - 57px);
    padding: 20px !important;
  }
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 20px 0;
  margin-bottom: 20px;

  .empty-message {
    text-align: center;
    color: $text-secondary !important;
    padding: 60px 20px;

    p {
      margin: 10px 0;
      font-size: 14px;
    }
  }

  .message-item {
    display: flex;
    margin-bottom: 20px;
    animation: fadeIn 0.3s ease;

    .message-avatar {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-right: 12px;
      flex-shrink: 0;
      font-size: 20px;
    }

    .message-content {
      flex: 1;
      min-width: 0;

      .message-text {
        background: $primary-bg;
        padding: 12px 16px;
        border-radius: 0;
        color: $text-primary !important;
        line-height: 1.6;
        word-wrap: break-word;
        white-space: pre-wrap;
        border: 1px solid $border-color;
      }

      .message-time {
        font-size: 12px;
        color: $text-disabled !important;
        margin-top: 4px;
      }

      .message-sql {
        margin-top: 8px;
        padding: 8px;
        background: $primary-bg;
        border: 1px solid $border-color;
        border-radius: 0;

        pre {
          margin: 8px 0 0 0;
          color: $accent-color !important;
          font-size: 12px;
          overflow-x: auto;
        }
      }
    }

    &.user-message {
      flex-direction: row-reverse;

      .message-avatar {
        margin-right: 0;
        margin-left: 12px;
        background: $accent-color;
        color: $text-primary !important;
      }

      .message-content .message-text {
        background: $accent-color;
        color: $text-primary !important;
      }
    }

    &.ai-message {
      .message-avatar {
        background: $secondary-bg;
        color: $accent-color !important;
        border: 1px solid $border-color;
      }
    }
  }
}

.chat-input {
  .input-actions {
    display: flex;
    justify-content: flex-end;
    margin-top: 10px;
    gap: 10px;
  }
}

.side-card {
  margin-bottom: 20px;

  .el-card__header {
    background: $primary-bg !important;
    border-bottom: 1px solid $border-color !important;
    color: $text-primary !important;
    font-weight: 600 !important;
  }

  .el-card__body {
    color: $text-primary !important;
  }
}

.db-info {
  pre {
    background: $primary-bg;
    padding: 12px;
    border: 1px solid $border-color;
    border-radius: 0;
    color: $text-primary !important;
    font-size: 12px;
    overflow-x: auto;
    margin: 0;
  }
}

.empty-info {
  text-align: center;
  color: $text-secondary !important;
  padding: 20px;

  p {
    margin: 0;
    font-size: 14px;
  }
}

/* 会话列表样式 */
.conversation-card {
  margin-bottom: 20px;
  
  .conversation-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  
  .conversation-list {
    max-height: 500px;
    overflow-y: auto;
    
    .conversation-items {
      display: flex;
      flex-direction: column;
      gap: 8px;
    }
    
    .conversation-item {
      position: relative;
      padding: 12px;
      background: $primary-bg;
      border: 1px solid $border-color;
      border-radius: 4px;
      cursor: pointer;
      transition: all 0.3s ease;
      
      &:hover {
        background: rgba(91, 141, 239, 0.1);
        border-color: $accent-color;
        
        .conversation-delete {
          opacity: 1;
        }
      }
      
      &.active {
        background: rgba(91, 141, 239, 0.2);
        border-color: $accent-color;
      }
      
      .conversation-item-content {
        flex: 1;
        min-width: 0;
      }
      
      .conversation-title {
        display: flex;
        align-items: center;
        gap: 6px;
        margin-bottom: 6px;
        font-size: 14px;
        font-weight: 500;
        color: $text-primary;
        
        i {
          color: $accent-color;
          font-size: 16px;
        }
        
        span {
          flex: 1;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
        }
      }
      
      .conversation-preview {
        font-size: 12px;
        color: $text-secondary;
        line-height: 1.4;
        margin-bottom: 6px;
        overflow: hidden;
        text-overflow: ellipsis;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
      }
      
      .conversation-meta {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 11px;
        color: $text-disabled;
        
        .conversation-time {
          flex: 1;
        }
        
        .conversation-count {
          margin-left: 8px;
        }
      }
      
      .conversation-delete {
        position: absolute;
        top: 8px;
        right: 8px;
        width: 20px;
        height: 20px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: $text-disabled;
        opacity: 0;
        transition: all 0.3s ease;
        border-radius: 2px;
        
        &:hover {
          color: #f56c6c;
          background: rgba(245, 108, 108, 0.1);
        }
        
        i {
          font-size: 14px;
        }
      }
    }
  }
}

/* 会话列表滚动条样式 */
.conversation-list::-webkit-scrollbar {
  width: 6px;
}

.conversation-list::-webkit-scrollbar-track {
  background: $primary-bg;
}

.conversation-list::-webkit-scrollbar-thumb {
  background: $border-color;
  border-radius: 0;
  
  &:hover {
    background: $accent-color;
  }
}

.quick-questions {
  display: flex;
  flex-direction: column;
  gap: 8px;

  .quick-btn {
    width: 100%;
    text-align: left;
    color: $text-primary !important;
    border-color: $border-color !important;
    background: $secondary-bg !important;

    &:hover {
      border-color: $accent-color !important;
      color: $accent-color !important;
    }
  }
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 滚动条样式 */
.chat-messages::-webkit-scrollbar {
  width: 6px;
}

.chat-messages::-webkit-scrollbar-track {
  background: $primary-bg;
}

.chat-messages::-webkit-scrollbar-thumb {
  background: $border-color;
  border-radius: 0;

  &:hover {
    background: $accent-color;
  }
}
</style>
