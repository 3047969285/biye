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
            <div v-if="messages.length === 0" class="empty-message">
              <p>👋 欢迎使用智能电网运维系统</p>
              <p>请选择对话模式开始提问</p>
            </div>
            <div
              v-for="(msg, index) in messages"
              :key="index"
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
            <pre>{{ dbStats }}</pre>
          </div>
          <div v-else class="empty-info">
            <p>点击刷新查看数据库统计信息</p>
          </div>
        </el-card>

        <!-- 快捷问题 -->
        <el-card class="side-card">
          <div slot="header">
            <span>快捷问题</span>
          </div>
          <div class="quick-questions">
            <el-button
              v-for="(q, index) in quickQuestionsComputed"
              :key="index"
              size="mini"
              plain
              @click="useQuickQuestion(q)"
              class="quick-btn"
            >
              {{ q }}
            </el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { chat, askWithRag, addDocument, clearKnowledgeBase, askDatabase, getDatabaseStats } from "@/api/ai/chat";

export default {
  name: "AiChat",
  data() {
    return {
      chatMode: "basic", // basic, rag, db
      messages: [],
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
      quickQuestions: {
        basic: [
          "变压器温度过高如何处理？",
          "如何提高设备运行效率？",
          "写一段简短的巡检提示"
        ],
        rag: [
          "根据知识库说明变压器检修步骤",
          "列出常见故障的安全注意事项",
          "根据知识库生成维护表单"
        ],
        db: [
          "查询所有正常状态的设备",
          "统计各部门的设备数量",
          "最近一个月新增的用户有哪些？"
        ]
      }
    };
  },
  mounted() {
    this.scrollToBottom();
    if (this.chatMode === "db") {
      this.loadDatabaseInfo();
    }
  },
  watch: {
    chatMode() {
      if (this.chatMode === "db") {
        this.loadDatabaseInfo();
      }
    }
  },
  computed: {
    quickQuestionsComputed() {
      return this.quickQuestions[this.chatMode] || [];
    }
  },
  methods: {
    // 发送消息
    async sendMessage() {
      if (!this.inputMessage.trim() || this.loading) return;

      const userMessage = this.inputMessage.trim();
      this.inputMessage = "";
      
      // 添加用户消息
      this.messages.push({
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
          this.startStream("/springai/chat/stream", { input: userMessage });
          return;
        } else if (this.chatMode === "rag") {
          // RAG问答（流式）
          this.startStream("/springai/rag/ask/stream", { question: userMessage, topK: 3 });
          return;
        } else if (this.chatMode === "db") {
          // 数据库查询
          response = await askDatabase(userMessage);
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

          this.messages.push(aiMessage);
        } else {
          this.messages.push({
            role: "ai",
            content: "抱歉，处理您的请求时出现错误：" + response.msg,
            timestamp: new Date()
          });
        }
      } catch (error) {
        console.error("发送消息失败:", error);
        this.messages.push({
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

      const aiMessage = {
        role: "ai",
        content: "",
        timestamp: new Date()
      };
      this.messages.push(aiMessage);
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

        es.onerror = () => {
          if (this.loading) {
            aiMessage.content = aiMessage.content || "流已结束";
          }
          es.close();
          this.eventSource = null;
          this.loading = false;
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
      try {
        const response = await getDatabaseStats();
        if (response.code === 200) {
          const data = response.data;
          this.dbStats = typeof data === "string" ? data : JSON.stringify(data, null, 2);
        } else {
          this.dbStats = "获取数据库信息失败：" + (response.msg || "");
        }
      } catch (error) {
        console.error("加载数据库信息失败:", error);
        this.dbStats = "获取数据库信息失败：" + error.message;
      } finally {
        this.dbLoading = false;
      }
    },

    // 使用快捷问题
    useQuickQuestion(question) {
      this.inputMessage = question;
      this.sendMessage();
    },

    // 清空对话
    clearMessages() {
      this.messages = [];
      if (this.eventSource) {
        this.eventSource.close();
        this.eventSource = null;
      }
    },

    // 格式化消息
    formatMessage(content) {
      if (!content) return "";
      // 简单的换行处理
      return content.replace(/\n/g, "<br>");
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
