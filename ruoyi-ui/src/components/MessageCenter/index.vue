<template>
  <div class="message-center-wrap">
    <el-popover
      placement="bottom-end"
      width="380"
      trigger="click"
      popper-class="message-center-popper"
      @show="onPopoverShow"
    >
      <div class="message-center-panel">
        <div class="message-center-header">
          <span class="message-center-title">消息中心</span>
          <el-button
            type="text"
            size="mini"
            class="msg-readall-btn"
            :disabled="unreadCount === 0"
            @click.stop="handleReadAll"
          >全部已读</el-button>
        </div>
        <div v-loading="listLoading" class="message-list-scroll">
          <div v-if="!messageList.length && !listLoading" class="message-empty">暂无消息</div>
          <div
            v-for="item in messageList"
            :key="item.msgId"
            class="message-item"
            :class="{ 'is-unread': item.readFlag === '0' }"
          >
            <div class="message-item-inner">
              <div class="message-item-body" @click="handleItemClick(item)">
                <div class="message-item-title">
                  <span>{{ item.title }}</span>
                  <el-tag v-if="item.readFlag === '0'" type="primary" size="mini" effect="plain">未读</el-tag>
                </div>
                <div class="message-item-content">{{ item.content }}</div>
                <div class="message-item-time">{{ parseTime(item.createTime, '{y}-{m}-{d} {h}:{i}') }}</div>
              </div>
              <div class="message-item-actions" @click.stop>
                <el-button
                  v-if="item.readFlag === '0'"
                  type="text"
                  size="mini"
                  class="msg-action-read"
                  @click="handleMarkReadOnly(item)"
                >标为已读</el-button>
                <el-button
                  type="text"
                  size="mini"
                  class="msg-action-delete"
                  @click="handleDelete(item)"
                >删除</el-button>
              </div>
            </div>
          </div>
        </div>
        <div v-if="messageList.length" class="message-center-footer">
          <el-button type="text" size="small" class="msg-footer-link" @click="goMaintenancePage">打开运维表单页</el-button>
        </div>
      </div>
      <div slot="reference" class="message-trigger" @click.stop>
        <el-badge :value="unreadCount" :hidden="unreadCount < 1" :max="99">
          <svg-icon icon-class="message" class-name="message-bell-icon" />
        </el-badge>
      </div>
    </el-popover>
  </div>
</template>

<script>
import { listUserMessage, getUnreadMessageCount, markMessageRead, markAllMessagesRead, deleteUserMessage } from '@/api/system/userMessage'
import { getConfigKey } from '@/api/system/config'
import { getClientPollIntervalSec, CLIENT_POLL_INTERVAL_EVENT } from '@/utils/clientPoll'

export default {
  name: 'MessageCenter',
  data() {
    return {
      unreadCount: 0,
      messageList: [],
      listLoading: false,
      pollTimer: null,
      serverPollDefaultSec: 180
    }
  },
  mounted() {
    this.fetchUnread()
    this._onClientPollIntervalChanged = () => this.restartUnreadPoll()
    window.addEventListener(CLIENT_POLL_INTERVAL_EVENT, this._onClientPollIntervalChanged)
    getConfigKey('client.poll.interval.seconds')
      .then(res => {
        if (res && res.code === 200 && res.data != null && res.data !== '') {
          const n = parseInt(res.data, 10)
          if (Number.isFinite(n)) {
            this.serverPollDefaultSec = n
          }
        }
      })
      .catch(() => {})
      .finally(() => this.restartUnreadPoll())
  },
  beforeDestroy() {
    if (this.pollTimer) {
      clearInterval(this.pollTimer)
    }
    if (this._onClientPollIntervalChanged) {
      window.removeEventListener(CLIENT_POLL_INTERVAL_EVENT, this._onClientPollIntervalChanged)
    }
  },
  methods: {
    resolveMaintenanceFormPath() {
      const candidates = ['/maintenance-form', '/ai/maintenance-form']
      for (const path of candidates) {
        const resolved = this.$router.resolve({ path })
        const matched = (resolved && resolved.route && resolved.route.matched) || []
        const hasNon404Match = matched.some(record => {
          const routePath = record && record.path
          return routePath && routePath !== '*' && routePath !== '/404'
        })
        if (hasNon404Match) {
          return path
        }
      }
      return '/maintenance-form'
    },
    navigateToMaintenanceForm(query) {
      const path = this.resolveMaintenanceFormPath()
      const target = query ? { path, query } : { path }
      this.$router.push(target).catch(() => {})
    },
    restartUnreadPoll() {
      if (this.pollTimer) {
        clearInterval(this.pollTimer)
        this.pollTimer = null
      }
      const sec = getClientPollIntervalSec(this.serverPollDefaultSec)
      this.pollTimer = setInterval(() => this.fetchUnread(), sec * 1000)
    },
    fetchUnread() {
      getUnreadMessageCount()
        .then(res => {
          if (res && res.code === 200 && res.data != null) {
            this.unreadCount = Number(res.data) || 0
          }
        })
        .catch(() => {})
    },
    onPopoverShow() {
      this.loadList()
      this.fetchUnread()
    },
    loadList() {
      this.listLoading = true
      listUserMessage({ pageNum: 1, pageSize: 20 })
        .then(res => {
          this.messageList = (res && res.rows) ? res.rows : []
        })
        .catch(() => {
          this.messageList = []
        })
        .finally(() => {
          this.listLoading = false
        })
    },
    handleReadAll() {
      markAllMessagesRead().then(res => {
        if (res && res.code === 200) {
          this.$modal.msgSuccess('已全部标为已读')
          this.unreadCount = 0
          this.loadList()
        }
      }).catch(() => {})
    },
    handleMarkReadOnly(item) {
      if (!item || item.readFlag !== '0') {
        return
      }
      markMessageRead(item.msgId).then(res => {
        if (res && res.code === 200) {
          item.readFlag = '1'
          this.fetchUnread()
          this.$modal.msgSuccess('已标为已读')
        }
      }).catch(() => {})
    },
    handleDelete(item) {
      if (!item || item.msgId == null) {
        return
      }
      this.$modal.confirm('是否确认删除该条消息？删除后不可恢复。').then(() => {
        deleteUserMessage(item.msgId).then(res => {
          if (res && res.code === 200) {
            this.$modal.msgSuccess('删除成功')
            this.messageList = this.messageList.filter(m => m.msgId !== item.msgId)
            this.fetchUnread()
          }
        }).catch(() => {})
      }).catch(() => {})
    },
    handleItemClick(item) {
      const isMaintenanceForm = item.msgType === 'maintenance_form' && item.bizId
      const isDevicePending = item.msgType === 'maintenance_device_pending' && item.bizId
      const doNavigate = () => {
        if (isMaintenanceForm) {
          this.navigateToMaintenanceForm({ formId: String(item.bizId) })
        } else if (isDevicePending) {
          this.navigateToMaintenanceForm({ deviceId: String(item.bizId) })
        }
      }
      if (item.readFlag === '0') {
        markMessageRead(item.msgId).then(res => {
          if (res && res.code === 200) {
            item.readFlag = '1'
            this.fetchUnread()
          }
          doNavigate()
        }).catch(() => doNavigate())
      } else {
        doNavigate()
      }
    },
    goMaintenancePage() {
      this.navigateToMaintenanceForm()
    }
  }
}
</script>

<style lang="scss" scoped>
@import "~@/assets/styles/variables.scss";

.message-center-wrap {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  padding: 0 6px;
}

.message-trigger {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 36px;
  width: 36px;
  cursor: pointer;
  border-radius: 8px;
  transition: background 0.2s ease;

  &:hover {
    background: rgba(94, 161, 255, 0.12);
  }
}

.message-bell-icon {
  font-size: 18px;
  color: $text-secondary;
}

.message-center-panel {
  display: flex;
  flex-direction: column;
  max-height: min(560px, 78vh);
  min-height: 0;
}

.message-center-header {
  flex-shrink: 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
  padding-bottom: 10px;
  border-bottom: 1px solid $border-color;
}

.message-center-title {
  font-weight: 600;
  font-size: 15px;
  color: $text-primary;
  letter-spacing: 0.02em;
}

::v-deep .msg-readall-btn {
  color: $accent-color !important;
  font-weight: 500;
  padding: 6px 10px !important;
  border-radius: 6px;
  transition: background 0.2s ease, color 0.2s ease;

  &:not(.is-disabled):hover {
    color: lighten($accent-color, 6%) !important;
    background: rgba(94, 161, 255, 0.12) !important;
  }

  &.is-disabled {
    color: #c0c4cc !important;
  }
}

.message-list-scroll {
  flex: 1 1 auto;
  min-height: 0;
  max-height: min(440px, 62vh);
  overflow-y: auto;
  overflow-x: hidden;
  -webkit-overflow-scrolling: touch;
  padding-right: 2px;
}

.message-empty {
  text-align: center;
  color: $text-disabled;
  padding: 24px 0;
  font-size: 13px;
}

.message-item {
  border-bottom: 1px solid $border-color;
  border-radius: 4px;

  &.is-unread {
    background: rgba(94, 161, 255, 0.12);
    border-left: 3px solid $accent-color;
  }
}

.message-item-inner {
  display: flex;
  align-items: stretch;
  gap: 4px;
  padding: 10px 4px;
}

.message-item-body {
  flex: 1;
  min-width: 0;
  cursor: pointer;
  border-radius: 4px;
  padding: 2px 4px;
  margin: -2px -4px;

  &:hover {
    background: $hover-bg;
  }
}

.message-item-actions {
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 2px;
  padding-left: 2px;
}

::v-deep .msg-action-read {
  color: $accent-color !important;
  padding: 4px 6px !important;
  margin: 0 !important;
}

::v-deep .msg-action-delete {
  color: $text-secondary !important;
  padding: 4px 6px !important;
  margin: 0 !important;

  &:hover {
    color: #f56c6c !important;
  }
}

.message-item-title {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 13px;
  font-weight: 500;
  margin-bottom: 4px;
}

.message-item-content {
  font-size: 12px;
  color: $text-secondary;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.message-item-time {
  font-size: 11px;
  color: $text-disabled;
  margin-top: 6px;
}

.message-center-footer {
  flex-shrink: 0;
  text-align: center;
  padding-top: 8px;
  border-top: 1px solid $border-color;
  margin-top: 4px;
}

::v-deep .msg-footer-link {
  color: $accent-color !important;
  font-weight: 500;
}
</style>

<style lang="scss">
@import "~@/assets/styles/variables.scss";

.message-center-popper {
  padding: 14px 14px 12px !important;
  border-radius: 10px !important;
  background: $secondary-bg !important;
  border: 1px solid $border-color !important;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.35) !important;

  .el-badge__content {
    background-color: $accent-color;
    border: none;
  }
}
</style>
