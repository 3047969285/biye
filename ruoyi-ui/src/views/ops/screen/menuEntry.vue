<template>
  <div class="ops-menu-entry">
    <p>正在进入运维指挥大屏…</p>
  </div>
</template>

<script>
/** 侧栏菜单入口：跳转到无 Layout 包裹的全屏路由 /ops/screen */
export default {
  name: 'OpsScreenMenuEntry',
  mounted() {
    this.$router.replace('/ops/screen')
  }
}
</script>

<style scoped>
.ops-menu-entry {
  padding: 48px;
  color: #5c463c;
  font-family: 'DM Sans', 'Noto Sans SC', sans-serif;
}
</style>
