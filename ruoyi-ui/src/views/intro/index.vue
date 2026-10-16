<template>
  <div class="intro-page">
    <div class="intro-atmosphere" aria-hidden="true">
      <div class="ambient-grid" />
      <div class="halo halo-outer" />
      <div class="halo halo-inner" />
      <div class="light-orbit" />
    </div>

    <header class="intro-header">
      <div class="intro-brand">
        <span class="brand-mark"><i /><i /><i /></span>
        <span>智能电网 <b>/</b> 序章</span>
      </div>
      <button class="skip-button" type="button" @click="skipIntro">
        跳过动画 <span aria-hidden="true">↗</span>
      </button>
    </header>

    <main class="intro-main">
      <section class="word-stage" :key="activeIndex" aria-live="polite">
        <p class="word-kicker">{{ currentWord.kicker }}</p>
        <h1 class="art-word" :aria-label="currentWord.title">
          <span
            v-for="(character, index) in currentWord.title.split('')"
            :key="`${activeIndex}-${index}`"
            class="art-character"
            :data-character="character"
            :style="characterStyle(index)"
            aria-hidden="true"
          >{{ character }}</span>
        </h1>
        <div class="word-rule" aria-hidden="true"><i /></div>
        <p class="word-subtitle">{{ currentWord.subtitle }}</p>
      </section>
    </main>

    <footer class="intro-footer">
      <div class="sequence-count">
        <span class="count-current">{{ displayIndex }}</span>
        <span class="count-divider" />
        <span>03</span>
      </div>
      <div class="sequence-progress" aria-hidden="true">
        <i
          v-for="(word, index) in words"
          :key="word.title"
          :class="{ active: index === activeIndex, complete: index < activeIndex }"
        />
      </div>
      <span class="footer-label">让每一度电，都有迹可循</span>
    </footer>
  </div>
</template>

<script>
const characterOrigins = [
  { x: '-5.5rem', y: '-3.8rem', rotation: '-16deg' },
  { x: '4.8rem', y: '-4.6rem', rotation: '13deg' },
  { x: '-4.4rem', y: '4rem', rotation: '11deg' },
  { x: '5.2rem', y: '3.4rem', rotation: '-14deg' }
]

export default {
  name: 'IntroPage',
  data() {
    return {
      activeIndex: 0,
      sequenceTimer: null,
      words: [
        { kicker: '01  /  感知', title: '智联电网', subtitle: '让每一条线路，都清晰可见' },
        { kicker: '02  /  预判', title: '预见风险', subtitle: '在故障发生之前，找到答案' },
        { kicker: '03  /  守护', title: '守护光明', subtitle: '以稳定运维，点亮每一度电' }
      ]
    }
  },
  computed: {
    currentWord() {
      return this.words[this.activeIndex]
    },
    displayIndex() {
      return String(this.activeIndex + 1).padStart(2, '0')
    }
  },
  mounted() {
    this.sequenceTimer = window.setInterval(this.advanceSequence, 3200)
  },
  beforeDestroy() {
    window.clearInterval(this.sequenceTimer)
  },
  methods: {
    characterStyle(index) {
      const origin = characterOrigins[index % characterOrigins.length]
      return {
        '--character-delay': `${index * 135}ms`,
        '--outline-delay': `${index * 135 + 90}ms`,
        '--origin-x': origin.x,
        '--origin-y': origin.y,
        '--origin-rotation': origin.rotation
      }
    },
    advanceSequence() {
      if (this.activeIndex < this.words.length - 1) {
        this.activeIndex += 1
        return
      }
      window.clearInterval(this.sequenceTimer)
      this.sequenceTimer = null
      this.$router.replace('/index')
    },
    skipIntro() {
      window.clearInterval(this.sequenceTimer)
      this.sequenceTimer = null
      this.$router.replace('/index')
    }
  }
}
</script>

<style lang="scss" scoped>
.intro-page {
  position: fixed;
  inset: 0;
  overflow: hidden;
  color: #272b2d;
  background:
    radial-gradient(ellipse at 50% 43%, rgba(233, 130, 53, 0.1), transparent 43%),
    linear-gradient(145deg, #faf9f6 0%, #f5f2ec 58%, #f7f5f0 100%);
}

.intro-atmosphere {
  position: absolute;
  inset: 0;
  overflow: hidden;
  pointer-events: none;
}

.ambient-grid {
  position: absolute;
  inset: -20%;
  opacity: 0.17;
  background-image:
    linear-gradient(rgba(150, 125, 99, 0.09) 1px, transparent 1px),
    linear-gradient(90deg, rgba(150, 125, 99, 0.09) 1px, transparent 1px);
  background-size: 58px 58px;
  mask-image: radial-gradient(ellipse at center, #000 8%, transparent 72%);
  animation: grid-drift 28s linear infinite;
}

.halo {
  position: absolute;
  left: 50%;
  top: 46%;
  border: 1px solid rgba(196, 146, 105, 0.19);
  border-radius: 50%;
  transform: translate(-50%, -50%);
}

.halo-outer {
  width: min(76vw, 900px);
  aspect-ratio: 1;
}

.halo-inner {
  width: min(54vw, 640px);
  aspect-ratio: 1;
  border-color: rgba(196, 146, 105, 0.13);
}

.light-orbit {
  position: absolute;
  left: 50%;
  top: 46%;
  width: min(84vw, 1040px);
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(233, 130, 53, 0.38), transparent);
  transform: translate(-50%, -50%) rotate(-18deg);
  animation: orbit-breathe 6s ease-in-out infinite;
}

.intro-header,
.intro-footer {
  position: absolute;
  z-index: 2;
  left: clamp(24px, 5vw, 76px);
  right: clamp(24px, 5vw, 76px);
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.intro-header {
  top: clamp(24px, 5vh, 48px);
}

.intro-brand {
  display: inline-flex;
  align-items: center;
  gap: 13px;
  color: rgba(39, 43, 45, 0.72);
  font-size: 12px;
  letter-spacing: 0.12em;
}

.intro-brand b {
  padding: 0 5px;
  color: rgba(233, 130, 53, 0.68);
  font-weight: 400;
}

.brand-mark {
  display: flex;
  align-items: center;
  gap: 3px;
  height: 18px;
}

.brand-mark i {
  display: block;
  width: 2px;
  height: 9px;
  background: #e30613;
  transform: skew(-24deg);
}

.brand-mark i:nth-child(2) {
  height: 15px;
  opacity: 0.72;
}

.brand-mark i:nth-child(3) {
  height: 11px;
  opacity: 0.48;
}

.skip-button {
  display: inline-flex;
  align-items: center;
  gap: 12px;
  padding: 9px 0 9px 12px;
  border: 0;
  color: rgba(39, 43, 45, 0.58);
  background: transparent;
  font: inherit;
  font-size: 12px;
  letter-spacing: 0.08em;
  cursor: pointer;
  transition: color 180ms ease;
}

.skip-button:hover,
.skip-button:focus-visible {
  color: #bd641e;
}

.skip-button:focus-visible {
  outline: 1px solid rgba(233, 130, 53, 0.6);
  outline-offset: 5px;
}

.skip-button span {
  color: #e30613;
  font-size: 16px;
}

.intro-main {
  position: absolute;
  z-index: 1;
  inset: 0;
  display: grid;
  place-items: center;
  padding: 90px 24px;
  text-align: center;
}

.word-stage {
  width: 100%;
  animation: stage-arrive 500ms ease both;
}

.word-kicker {
  margin: 0 0 clamp(20px, 4vh, 38px);
  color: rgba(160, 112, 72, 0.82);
  font-size: 11px;
  letter-spacing: 0.3em;
}

.art-word {
  display: flex;
  justify-content: center;
  gap: clamp(8px, 2.1vw, 28px);
  margin: 0;
  padding: 0 0 0 0.12em;
  color: #262a2d;
  font-family: 'STSong', 'Songti SC', 'Noto Serif SC', 'Microsoft YaHei', serif;
  font-size: clamp(58px, 13vw, 156px);
  font-weight: 700;
  line-height: 1.12;
  letter-spacing: 0.12em;
  white-space: nowrap;
}

.art-character {
  position: relative;
  display: inline-block;
  min-width: 1em;
  opacity: 0;
  color: transparent;
  background: linear-gradient(150deg, #282d30 4%, #5d6466 52%, #df7f35 100%);
  background-clip: text;
  -webkit-background-clip: text;
  filter: blur(12px);
  text-shadow: 0 8px 28px rgba(164, 116, 72, 0.12);
  transform: translate3d(var(--origin-x), var(--origin-y), 0) rotate(var(--origin-rotation)) scale(0.58);
  animation: character-assemble 850ms cubic-bezier(0.2, 0.9, 0.25, 1.12) var(--character-delay) both;
}

.art-character::after {
  position: absolute;
  inset: 0;
  color: transparent;
  content: attr(data-character);
  -webkit-text-stroke: 1px rgba(191, 113, 52, 0.5);
  clip-path: inset(0 100% 0 0);
  animation: outline-assemble 720ms ease-out var(--outline-delay) both;
}

.word-rule {
  position: relative;
  width: clamp(94px, 12vw, 156px);
  height: 1px;
  margin: clamp(24px, 4vh, 40px) auto 19px;
  background: rgba(145, 123, 102, 0.2);
}

.word-rule i {
  position: absolute;
  top: 0;
  left: 50%;
  width: 34%;
  height: 1px;
  background: #e30613;
  box-shadow: 0 0 12px rgba(233, 130, 53, 0.35);
  transform: translateX(-50%);
}

.word-subtitle {
  margin: 0;
  color: rgba(69, 75, 77, 0.67);
  font-size: clamp(12px, 1.2vw, 15px);
  letter-spacing: 0.2em;
}

.intro-footer {
  bottom: clamp(25px, 5vh, 48px);
  min-height: 22px;
}

.sequence-count {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  color: rgba(67, 73, 75, 0.48);
  font-size: 11px;
  letter-spacing: 0.12em;
}

.count-current {
  color: #c66d28;
}

.count-divider {
  width: 22px;
  height: 1px;
  background: rgba(161, 119, 82, 0.35);
}

.sequence-progress {
  position: absolute;
  left: 50%;
  display: flex;
  gap: 7px;
  transform: translateX(-50%);
}

.sequence-progress i {
  display: block;
  width: 24px;
  height: 2px;
  background: rgba(161, 119, 82, 0.17);
  transition: background-color 240ms ease, width 240ms ease;
}

.sequence-progress i.active {
  width: 38px;
  background: #e30613;
  box-shadow: 0 0 10px rgba(233, 130, 53, 0.28);
}

.sequence-progress i.complete {
  background: rgba(233, 130, 53, 0.52);
}

.footer-label {
  color: rgba(67, 73, 75, 0.42);
  font-size: 10px;
  letter-spacing: 0.14em;
}

@keyframes grid-drift {
  from { transform: translate3d(0, 0, 0); }
  to { transform: translate3d(58px, 58px, 0); }
}

@keyframes orbit-breathe {
  0%, 100% { opacity: 0.35; }
  50% { opacity: 0.9; }
}

@keyframes stage-arrive {
  from { opacity: 0.75; }
  to { opacity: 1; }
}

@keyframes character-assemble {
  0% {
    opacity: 0;
    filter: blur(12px);
    transform: translate3d(var(--origin-x), var(--origin-y), 0) rotate(var(--origin-rotation)) scale(0.58);
  }
  72% {
    opacity: 1;
    filter: blur(0);
    transform: translate3d(0, 0, 0) rotate(0) scale(1.06);
  }
  100% {
    opacity: 1;
    filter: blur(0);
    transform: translate3d(0, 0, 0) rotate(0) scale(1);
  }
}

@keyframes outline-assemble {
  0% { opacity: 0; clip-path: inset(0 100% 0 0); }
  50% { opacity: 0.9; }
  100% { opacity: 0; clip-path: inset(0 0 0 0); }
}

@media (max-width: 640px) {
  .intro-header,
  .intro-footer {
    left: 22px;
    right: 22px;
  }

  .intro-brand {
    gap: 9px;
    font-size: 10px;
  }

  .art-word {
    gap: 4px;
    font-size: clamp(48px, 13vw, 82px);
  }

  .footer-label {
    max-width: 42%;
    text-align: right;
    line-height: 1.5;
  }
}

@media (prefers-reduced-motion: reduce) {
  .ambient-grid,
  .light-orbit,
  .word-stage,
  .art-character,
  .art-character::after,
  .sequence-progress i {
    animation: none !important;
    transition: none !important;
  }

  .art-character {
    opacity: 1;
    filter: none;
    transform: none;
  }
}
</style>
