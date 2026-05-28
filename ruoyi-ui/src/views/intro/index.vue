<template>
  <div
    class="intro-page"
    @wheel.prevent="onWheel"
    @touchstart.passive="onTouchStart"
    @touchend.passive="onTouchEnd"
  >
    <div class="pages-track" :style="{ transform: `translate3d(0, -${currentPage * 100}vh, 0)` }">
      <section class="page page-1">
        <div class="orb orb-a" />
        <div class="orb orb-b" />
        <div class="line-grid" />
      </section>

      <section class="page page-2">
        <div class="ring ring-1" />
        <div class="ring ring-2" />
        <div class="pulse pulse-1" />
      </section>

      <section class="page page-3">
        <div class="diagonal-band band-1" />
        <div class="diagonal-band band-2" />
        <div class="spark spark-1" />
        <div class="spark spark-2" />
      </section>

      <section class="page page-4">
        <div class="core core-1" />
        <div class="core core-2" />
        <div class="scan" />
      </section>
    </div>

    <div class="page-indicator">
      <span
        v-for="n in pageCount"
        :key="n"
        class="dot"
        :class="{ active: currentPage === n - 1 }"
      />
    </div>
  </div>
</template>

<script>
export default {
  name: 'IntroPage',
  data() {
    return {
      currentPage: 0,
      pageCount: 4,
      locked: false,
      touchStartY: 0
    }
  },
  methods: {
    onWheel(e) {
      if (this.locked) return
      const delta = e.deltaY
      if (Math.abs(delta) < 10) return
      if (delta > 0) this.next()
      else this.prev()
    },
    onTouchStart(e) {
      if (!e.changedTouches || !e.changedTouches.length) return
      this.touchStartY = e.changedTouches[0].clientY
    },
    onTouchEnd(e) {
      if (!e.changedTouches || !e.changedTouches.length) return
      const endY = e.changedTouches[0].clientY
      const diff = this.touchStartY - endY
      if (Math.abs(diff) < 28 || this.locked) return
      if (diff > 0) this.next()
      else this.prev()
    },
    next() {
      if (this.currentPage < this.pageCount - 1) {
        this.currentPage += 1
        this.freeze()
        return
      }
      this.$router.replace('/index')
    },
    prev() {
      if (this.currentPage > 0) {
        this.currentPage -= 1
        this.freeze()
      }
    },
    freeze() {
      this.locked = true
      setTimeout(() => {
        this.locked = false
      }, 520)
    }
  }
}
</script>

<style lang="scss" scoped>
.intro-page {
  position: fixed;
  inset: 0;
  overflow: hidden;
  background: #0f1f3a;
}

.pages-track {
  height: 100%;
  width: 100%;
  transition: transform 560ms cubic-bezier(0.22, 1, 0.36, 1);
}

.page {
  position: relative;
  height: 100vh;
  width: 100vw;
  overflow: hidden;
  background: linear-gradient(160deg, #0f1f3a 0%, #13284a 52%, #0c1a31 100%);
}

.line-grid {
  position: absolute;
  inset: 0;
  background-image:
    linear-gradient(rgba(63, 120, 200, 0.08) 1px, transparent 1px),
    linear-gradient(90deg, rgba(63, 120, 200, 0.08) 1px, transparent 1px);
  background-size: 52px 52px;
  opacity: 0.2;
  animation: gridMove 20s linear infinite;
}

.orb {
  position: absolute;
  filter: blur(4px);
  border-radius: 0;
}

.orb-a {
  width: 52vw;
  height: 52vw;
  left: -12vw;
  top: -18vw;
  background: radial-gradient(circle at center, rgba(63, 120, 200, 0.22) 0%, rgba(63, 120, 200, 0.06) 48%, transparent 72%);
  animation: driftA 14s ease-in-out infinite;
}

.orb-b {
  width: 48vw;
  height: 48vw;
  right: -14vw;
  bottom: -18vw;
  background: radial-gradient(circle at center, rgba(51, 102, 179, 0.22) 0%, rgba(51, 102, 179, 0.06) 50%, transparent 74%);
  animation: driftB 15s ease-in-out infinite;
}

.ring {
  position: absolute;
  border: 1px solid rgba(63, 120, 200, 0.24);
}

.ring-1 {
  width: 44vw;
  height: 44vw;
  left: 28vw;
  top: 20vh;
  animation: rotateSlow 12s linear infinite;
}

.ring-2 {
  width: 26vw;
  height: 26vw;
  left: 37vw;
  top: 31vh;
  border-color: rgba(63, 120, 200, 0.3);
  animation: rotateSlowReverse 14s linear infinite;
}

.pulse {
  position: absolute;
  width: 14vw;
  height: 14vw;
  left: 43vw;
  top: 38vh;
  background: radial-gradient(circle at center, rgba(63, 120, 200, 0.24), rgba(63, 120, 200, 0.03) 68%, transparent 76%);
  animation: pulse 5s ease-in-out infinite;
}

.diagonal-band {
  position: absolute;
  width: 140vw;
  height: 24vh;
  left: -18vw;
  background: linear-gradient(90deg, rgba(63, 120, 200, 0), rgba(63, 120, 200, 0.12), rgba(63, 120, 200, 0));
  transform: rotate(-18deg);
}

.band-1 {
  top: 24vh;
  animation: slideBand 14s ease-in-out infinite;
}

.band-2 {
  top: 54vh;
  opacity: 0.7;
  animation: slideBand 14s ease-in-out 0.9s infinite;
}

.spark {
  position: absolute;
  width: 2px;
  height: 120px;
  background: linear-gradient(to bottom, rgba(63, 120, 200, 0), rgba(132, 171, 224, 0.45), rgba(63, 120, 200, 0));
}

.spark-1 {
  left: 34vw;
  top: 22vh;
  animation: sparkle 6s ease-in-out infinite;
}

.spark-2 {
  right: 30vw;
  bottom: 18vh;
  animation: sparkle 6s ease-in-out 1.2s infinite;
}

.core {
  position: absolute;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
}

.core-1 {
  width: 32vw;
  height: 32vw;
  border: 1px solid rgba(63, 120, 200, 0.24);
  animation: rotateSlow 18s linear infinite;
}

.core-2 {
  width: 10vw;
  height: 10vw;
  background: radial-gradient(circle at center, rgba(91, 141, 210, 0.35), rgba(63, 120, 200, 0.05) 60%, transparent 72%);
  animation: pulse 6s ease-in-out infinite;
}

.scan {
  position: absolute;
  left: 0;
  right: 0;
  top: 50%;
  height: 1px;
  background: linear-gradient(90deg, rgba(63, 120, 200, 0), rgba(123, 162, 217, 0.55), rgba(63, 120, 200, 0));
  animation: scanY 8s ease-in-out infinite;
}

.page-indicator {
  position: absolute;
  right: 24px;
  top: 50%;
  transform: translateY(-50%);
  display: grid;
  gap: 10px;
  z-index: 9;
}

.dot {
  width: 5px;
  height: 22px;
  background: rgba(63, 120, 200, 0.24);
  transition: background-color 220ms ease, transform 220ms ease;
}

.dot.active {
  background: rgba(123, 162, 217, 0.85);
  transform: scaleY(1.08);
}

@keyframes gridMove {
  from { transform: translateY(0); }
  to { transform: translateY(24px); }
}

@keyframes driftA {
  0%, 100% { transform: translate3d(0, 0, 0); }
  50% { transform: translate3d(26px, 20px, 0); }
}

@keyframes driftB {
  0%, 100% { transform: translate3d(0, 0, 0); }
  50% { transform: translate3d(-24px, -16px, 0); }
}

@keyframes rotateSlow {
  from { transform: translate(-50%, -50%) rotate(0deg); }
  to { transform: translate(-50%, -50%) rotate(360deg); }
}

@keyframes rotateSlowReverse {
  from { transform: rotate(360deg); }
  to { transform: rotate(0deg); }
}

@keyframes pulse {
  0%, 100% { opacity: 0.55; transform: translate(-50%, -50%) scale(0.96); }
  50% { opacity: 1; transform: translate(-50%, -50%) scale(1.08); }
}

@keyframes slideBand {
  0%, 100% { transform: rotate(-18deg) translateX(-4vw); }
  50% { transform: rotate(-18deg) translateX(5vw); }
}

@keyframes sparkle {
  0%, 100% { opacity: 0.16; }
  50% { opacity: 1; }
}

@keyframes scanY {
  0%, 100% { transform: translateY(-26vh); opacity: 0.24; }
  50% { transform: translateY(26vh); opacity: 0.9; }
}

@media (prefers-reduced-motion: reduce) {
  .pages-track,
  .line-grid,
  .orb-a,
  .orb-b,
  .ring-1,
  .ring-2,
  .pulse,
  .band-1,
  .band-2,
  .spark-1,
  .spark-2,
  .core-1,
  .core-2,
  .scan {
    animation: none !important;
    transition: none !important;
  }
}
</style>
