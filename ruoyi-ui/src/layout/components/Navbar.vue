<template>
  <div class="navbar">
    <hamburger id="hamburger-container" :is-active="sidebar.opened" class="hamburger-container" @toggleClick="toggleSideBar" />

    <breadcrumb v-if="!topNav" id="breadcrumb-container" class="breadcrumb-container" />
    <top-nav v-if="topNav" id="topmenu-container" class="topmenu-container" />

    <div class="right-menu">
      <template v-if="device!=='mobile'">
        <div class="right-menu-tools">
          <router-link
            to="/ops/screen"
            class="navbar-tool-slot is-clickable navbar-ops-link"
            title="运维指挥大屏"
          >
            <i class="el-icon-data-board" />
            <span class="navbar-ops-label">指挥大屏</span>
          </router-link>
          <div class="navbar-tool-slot is-clickable">
            <message-center id="header-message" />
          </div>
          <div class="navbar-tool-slot is-clickable">
            <search id="header-search" />
          </div>
          <div class="navbar-tool-slot is-clickable">
            <screenfull id="screenfull" />
          </div>
        </div>
      </template>
      <template v-else>
        <div class="navbar-tool-slot is-clickable navbar-tool-slot--mobile">
          <message-center id="header-message-mobile" />
        </div>
      </template>

      <el-dropdown class="avatar-container" trigger="hover">
        <div class="avatar-wrapper">
          <img :src="avatar" class="user-avatar">
          <span class="user-nickname"> {{ nickName }} </span>
        </div>
        <el-dropdown-menu slot="dropdown">
          <router-link to="/user/profile">
            <el-dropdown-item>个人中心</el-dropdown-item>
          </router-link>
          <el-dropdown-item @click.native="setLayout" v-if="setting">
            <span>布局设置</span>
          </el-dropdown-item>
          <el-dropdown-item class="navbar-logout-item" @click.native="logout">
            <span>退出登录</span>
          </el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import Breadcrumb from '@/components/Breadcrumb'
import TopNav from '@/components/TopNav'
import Hamburger from '@/components/Hamburger'
import Screenfull from '@/components/Screenfull'
import SizeSelect from '@/components/SizeSelect'
import Search from '@/components/HeaderSearch'
import MessageCenter from '@/components/MessageCenter'

export default {
  emits: ['setLayout'],
  components: {
    Breadcrumb,
    TopNav,
    Hamburger,
    Screenfull,
    SizeSelect,
    Search,
    MessageCenter
  },
  computed: {
    ...mapGetters([
      'sidebar',
      'avatar',
      'device',
      'nickName'
    ]),
    setting: {
      get() {
        return this.$store.state.settings.showSettings
      },
      set(val) {
        this.$store.dispatch('settings/changeSetting', {
          key: 'showSettings',
          value: val
        })
      }
    },
    topNav: {
      get() {
        return this.$store.state.settings.topNav
      }
    }
  },
  methods: {
    toggleSideBar() {
      this.$store.dispatch('app/toggleSideBar')
    },
    async logout() {
      this.$confirm('确定注销并退出系统吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$store.dispatch('LogOut').then(() => {
          location.href = '/index';
        })
      }).catch(() => {});
    },
    setLayout() {
      this.$emit('setLayout');
    }
  }
}
</script>

<style lang="scss" scoped>
@import "~@/assets/styles/variables.scss";

.navbar {
  height: 56px;
  overflow: hidden;
  position: relative;
  background: rgba(255, 255, 255, 0.94);
  box-shadow: 0 1px 0 rgba(32, 37, 43, 0.06);
  border-bottom: 1px solid rgba(232, 227, 219, 0.85);
  backdrop-filter: blur(12px);

  .hamburger-container {
    line-height: 52px;
    height: 100%;
    float: left;
    cursor: pointer;
    transition: background .32s cubic-bezier(0.22, 1, 0.36, 1), transform .28s cubic-bezier(0.2, 0.8, 0.2, 1);
    -webkit-tap-highlight-color:transparent;

    &:hover {
      background: rgba(233, 130, 53, 0.1);
    }
  }

  .breadcrumb-container {
    float: left;
  }

  .topmenu-container {
    position: absolute;
    left: 50px;
  }

  .errLog-container {
    display: inline-block;
    vertical-align: top;
  }

  .right-menu {
    float: right;
    height: 100%;
    display: flex;
    align-items: center;
    padding-right: 12px;

    &:focus {
      outline: none;
    }

    .right-menu-tools {
      display: flex;
      align-items: center;
      height: 100%;
      gap: 2px;
      margin-right: 4px;
    }

    .navbar-ops-link {
      gap: 6px;
      padding: 0 12px;
      min-width: auto;
      text-decoration: none;
      color: $text-secondary !important;
      font-size: 12px;
      letter-spacing: 0.08em;

      .el-icon-data-board {
        font-size: 16px;
        color: $accent-color;
      }

      &:hover {
        color: $accent-color !important;
      }
    }

    .navbar-ops-label {
      font-weight: 600;
    }

    .navbar-tool-slot {
      display: flex;
      align-items: center;
      justify-content: center;
      min-width: 42px;
      height: 56px;
      border-radius: 999px;
      transition: background 0.28s cubic-bezier(0.22, 1, 0.36, 1), color 0.22s ease, transform 0.28s cubic-bezier(0.2, 0.8, 0.2, 1);

      &.is-clickable {
        cursor: pointer;
        color: $text-secondary;

        &:hover {
          background: rgba(233, 130, 53, 0.1);
          ::v-deep .svg-icon {
            color: $accent-color;
          }
          ::v-deep .search-icon {
            color: $accent-color;
          }
          ::v-deep .message-bell-icon {
            color: $accent-color;
          }
        }
      }

      &--mobile {
        margin-right: 4px;
      }

      ::v-deep .header-search {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 100%;
        line-height: 1;
      }

      ::v-deep .search-icon {
        color: $text-secondary;
        font-size: 18px;
        transition: color 0.2s ease;
      }

      ::v-deep > div {
        display: flex;
        align-items: center;
        justify-content: center;
      }

      ::v-deep .svg-icon {
        color: $text-secondary;
        font-size: 18px;
        transition: color 0.2s ease;
      }
    }

    .avatar-container {
      display: flex;
      align-items: center;
      height: 100%;
      padding-left: 8px;
      cursor: pointer;
      border-radius: 999px;
      transition: background 0.28s cubic-bezier(0.22, 1, 0.36, 1), transform 0.28s cubic-bezier(0.2, 0.8, 0.2, 1);

      &:hover {
        background: rgba(233, 130, 53, 0.1);
      }

      .avatar-wrapper {
        display: flex;
        align-items: center;
        gap: 8px;
        height: 100%;
        padding: 0 4px;

        .user-avatar {
          cursor: pointer;
          width: 32px;
          height: 32px;
          border-radius: 50%;
          border: 1px solid rgba(232, 227, 219, 0.9);
          box-shadow: 0 0 0 3px rgba(233, 130, 53, 0.08);
          flex-shrink: 0;
        }

        .user-nickname {
          font-size: 14px;
          font-weight: 600;
          color: $text-primary;
          line-height: 1;
          max-width: 96px;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
          letter-spacing: 0.02em;
        }

        .el-icon-caret-bottom {
          display: none;
        }
      }
    }
  }
}
</style>
