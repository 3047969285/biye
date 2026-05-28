<template>
  <div class="sidebar-logo-container" :class="{'collapse':collapse}">
    <transition name="sidebarLogoFade">
      <router-link v-if="collapse" key="collapse" class="sidebar-logo-link" to="/">
        <img v-if="logo" :src="logo" class="sidebar-logo" :alt="title" />
        <h1 v-else class="sidebar-title" :style="{ color: sideTheme === 'theme-dark' ? variables.logoTitleColor : variables.logoLightTitleColor }">{{ title }} </h1>
      </router-link>
      <router-link v-else key="expand" class="sidebar-logo-link" to="/">
        <img v-if="logo" :src="logo" class="sidebar-logo" :alt="title" />
        <h1 class="sidebar-title" :style="{ color: sideTheme === 'theme-dark' ? variables.logoTitleColor : variables.logoLightTitleColor }">{{ title }} </h1>
      </router-link>
    </transition>
  </div>
</template>

<script>
import logoImg from '@/assets/logo/logo.svg'
import variables from '@/assets/styles/variables.scss'

export default {
  name: 'SidebarLogo',
  props: {
    collapse: {
      type: Boolean,
      required: true
    }
  },
  computed: {
    variables() {
      return variables
    },
    sideTheme() {
      return this.$store.state.settings.sideTheme
    }
  },
  data() {
    return {
      title: '智能电网运维系统',
      logo: logoImg
    }
  }
}
</script>

<style lang="scss" scoped>
@import "~@/assets/styles/variables.scss";

.sidebarLogoFade-enter-active {
  transition: opacity 0.6s cubic-bezier(0.22, 1, 0.36, 1);
}

.sidebarLogoFade-enter,
.sidebarLogoFade-leave-to {
  opacity: 0;
}

.sidebar-logo-container {
  position: relative;
  width: 100%;
  height: 66px;
  line-height: 66px;
  background: linear-gradient(128deg, rgba(12, 20, 35, 0.96) 0%, rgba(18, 29, 48, 0.92) 100%);
  text-align: center;
  overflow: hidden;
  border-bottom: 1px solid rgba(146, 163, 201, 0.2);
  backdrop-filter: blur(10px);

  & .sidebar-logo-link {
    height: 100%;
    width: 100%;
    position: relative;
    z-index: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0 16px;

    & .sidebar-logo {
      width: 32px;
      height: 32px;
      vertical-align: middle;
      margin-right: 12px;
      transition: transform 0.28s cubic-bezier(0.2, 0.8, 0.2, 1);
      filter: drop-shadow(0 4px 10px rgba(48, 85, 182, 0.35));
    }

    & .sidebar-title {
      display: inline-block;
      margin: 0;
      color: #FFFFFF;
      font-weight: 700;
      line-height: 66px;
      font-size: 14px;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
      vertical-align: middle;
      letter-spacing: 0.08em;
      text-transform: uppercase;
    }
  }

  &.collapse {
    .sidebar-logo {
      margin-right: 0px;
    }
  }
}
</style>
