<template>
  <div class="welcome-container">
    <h2 class="welcome-title">智能电网运维系统</h2>
  </div>
</template>

<script>
export default {
  name: "Index"
}
</script>

<style scoped lang="scss">
@import "~@/assets/styles/variables.scss";

.welcome-container {
  display: flex;
  align-items: center;
  justify-content: center;
  height: calc(100vh - 200px);
  color: $text-primary !important;
}

.welcome-title {
  color: $text-primary !important;
  font-weight: 600 !important;
  font-size: 36px !important;
  letter-spacing: 2px !important;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3) !important;
}
</style>

