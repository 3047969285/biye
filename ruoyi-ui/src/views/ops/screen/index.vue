<template>
  <div class="ops-screen" :class="{ 'is-ready': ready }">
    <div class="ops-atmosphere" aria-hidden="true">
      <div class="ops-grain" />
      <div class="ops-wash ops-wash--a" />
      <div class="ops-wash ops-wash--b" />
      <div class="ops-photo-depth" />
    </div>

    <DeviceFleetScene :devices="devices" :active-id="activeDeviceId" />

    <header class="ops-top">
      <div class="ops-brand">
        <span class="ops-brand-mark" aria-hidden="true"><i /><i /><i /></span>
        <div class="ops-brand-copy">
          <strong>智能电网运维</strong>
          <span>GRID COMMAND · DELTA OPS</span>
        </div>
      </div>
      <div class="ops-clock">
        <span>{{ clockDate }}</span>
        <b>{{ clockTime }}</b>
      </div>
      <div class="ops-top-actions">
        <button type="button" class="ops-ghost" @click="loadDevices" :disabled="loading">
          {{ loading ? '同步中…' : '刷新态势' }}
        </button>
        <button type="button" class="ops-ghost" @click="goHome">返回平台</button>
        <button type="button" class="ops-solid" @click="toggleFullscreen">
          {{ isFullscreen ? '退出全屏' : '全屏指挥' }}
        </button>
      </div>
    </header>

    <section class="ops-hero">
      <p class="ops-eyebrow">{{ fromDemo ? 'DEMO SEED · 演示数据' : 'LIVE FLEET · 设备域' }}</p>
      <h1 class="ops-title">
        让每一度电，<br>
        <span>都在指挥视野里。</span>
      </h1>
      <p class="ops-lead">
        全网设备以三维编队呈现运行状态——感知、预判、处置，在同一构图中完成。
      </p>
      <div class="ops-cta">
        <button type="button" class="ops-solid" @click="focusNext">巡视下一台</button>
        <router-link class="ops-ghost linkish" to="/index">设备台账</router-link>
      </div>
    </section>

    <aside class="ops-rail ops-rail--left">
      <div
        v-for="item in kpiItems"
        :key="item.key"
        class="ops-kpi"
        :class="'is-' + item.key"
      >
        <span class="ops-kpi-label">{{ item.label }}</span>
        <strong class="ops-kpi-value">{{ item.value }}</strong>
        <i class="ops-kpi-bar" :style="{ width: item.bar + '%' }" />
      </div>
    </aside>

    <aside class="ops-rail ops-rail--right">
      <div class="ops-panel-head">
        <span>设备阵列</span>
        <small>{{ devices.length }} 台</small>
      </div>
      <button
        v-for="device in devices"
        :key="device.deviceId"
        type="button"
        class="ops-device-row"
        :class="{ active: String(device.deviceId) === String(activeDeviceId) }"
        @click="selectDevice(device)"
      >
        <div class="ops-device-thumb">
          <DeviceScene3D
            :device="device"
            variant="rail"
            :show-caption="false"
            :interactive="false"
          />
        </div>
        <div class="ops-device-meta">
          <strong>{{ device.deviceName || '未命名' }}</strong>
          <span>{{ device.deviceType || '—' }} · {{ device.location || '—' }}</span>
          <em :style="{ color: toneOf(device.status) }">{{ device.statusName || '—' }}</em>
        </div>
      </button>
    </aside>

    <footer class="ops-bottom">
      <div class="ops-focus" v-if="activeDevice">
        <div class="ops-focus-stage">
          <DeviceScene3D
            :device="activeDevice"
            variant="hero"
            :show-caption="true"
            :device-name="activeDevice.deviceName"
          />
        </div>
        <div class="ops-focus-copy">
          <p class="ops-focus-kicker">FOCUS DEVICE</p>
          <h2>{{ activeDevice.deviceName }}</h2>
          <p>{{ activeDevice.deviceNo }} · {{ activeDevice.deviceType }}</p>
          <p class="ops-focus-loc">{{ activeDevice.location || '位置未登记' }}</p>
          <div class="ops-focus-tags">
            <span>{{ activeDevice.statusName }}</span>
            <span v-if="activeDevice.totalCount != null">数据 {{ activeDevice.totalCount }} 条</span>
            <span v-if="fromDemo || activeDevice._demo">演示种子</span>
          </div>
        </div>
      </div>
      <div class="ops-ticker" aria-live="polite">
        <span v-for="(line, idx) in tickerLines" :key="idx">{{ line }}</span>
      </div>
    </footer>
  </div>
</template>

<script>
import screenfull from 'screenfull'
import { listDevice, getDeviceDashboardData, getDeviceStatistics } from '@/api/equipment/device'
import DeviceScene3D from '@/components/ops/DeviceScene3D.vue'
import DeviceFleetScene from '@/components/ops/DeviceFleetScene.vue'
import { normalizeDeviceList, statusTone } from '@/utils/ops/deviceCatalog'
import { getToken } from '@/utils/auth'

export default {
  name: 'OpsCommandScreen',
  components: { DeviceScene3D, DeviceFleetScene },
  data() {
    return {
      ready: false,
      loading: false,
      fromDemo: false,
      devices: [],
      activeDeviceId: null,
      statistics: { normal: 0, stopped: 0, maintenance: 0, scrapped: 0 },
      clockDate: '',
      clockTime: '',
      clockTimer: null,
      isFullscreen: false,
      tickerLines: []
    }
  },
  computed: {
    activeDevice() {
      return this.devices.find((d) => String(d.deviceId) === String(this.activeDeviceId)) || this.devices[0] || null
    },
    kpiItems() {
      const total = this.devices.length || 1
      const s = this.statistics
      return [
        { key: 'normal', label: '正常运行', value: s.normal || 0, bar: Math.round(((s.normal || 0) / total) * 100) },
        { key: 'maintenance', label: '维护中', value: s.maintenance || 0, bar: Math.round(((s.maintenance || 0) / total) * 100) },
        { key: 'stopped', label: '停用', value: s.stopped || 0, bar: Math.round(((s.stopped || 0) / total) * 100) },
        { key: 'scrapped', label: '报废', value: s.scrapped || 0, bar: Math.round(((s.scrapped || 0) / total) * 100) }
      ]
    }
  },
  mounted() {
    this.ready = true
    this.tickClock()
    this.clockTimer = setInterval(this.tickClock, 1000)
    this.loadDevices()
    if (screenfull.isEnabled) {
      screenfull.on('change', this.syncFullscreen)
    }
    document.body.classList.add('ops-screen-lock')
  },
  beforeDestroy() {
    clearInterval(this.clockTimer)
    document.body.classList.remove('ops-screen-lock')
    if (screenfull.isEnabled) {
      screenfull.off('change', this.syncFullscreen)
      if (screenfull.isFullscreen) screenfull.exit()
    }
  },
  methods: {
    toneOf(status) {
      return statusTone(status)
    },
    tickClock() {
      const now = new Date()
      const pad = (n) => String(n).padStart(2, '0')
      this.clockDate = `${now.getFullYear()}.${pad(now.getMonth() + 1)}.${pad(now.getDate())}`
      this.clockTime = `${pad(now.getHours())}:${pad(now.getMinutes())}:${pad(now.getSeconds())}`
    },
    syncFullscreen() {
      this.isFullscreen = !!(screenfull.isEnabled && screenfull.isFullscreen)
    },
    async toggleFullscreen() {
      if (!screenfull.isEnabled) {
        this.$message.warning('当前浏览器不支持全屏')
        return
      }
      await screenfull.toggle(this.$el)
      this.syncFullscreen()
    },
    goHome() {
      if (getToken()) {
        this.$router.push('/index')
      } else {
        this.$router.push('/login')
      }
    },
    selectDevice(device) {
      this.activeDeviceId = device.deviceId
    },
    focusNext() {
      if (!this.devices.length) return
      const idx = this.devices.findIndex((d) => String(d.deviceId) === String(this.activeDeviceId))
      const next = this.devices[(idx + 1) % this.devices.length]
      this.activeDeviceId = next.deviceId
    },
    async loadDevices() {
      this.loading = true
      try {
        const listRes = await listDevice({ pageNum: 1, pageSize: 100 })
        const normalized = normalizeDeviceList(listRes)
        this.devices = normalized.devices
        this.fromDemo = normalized.fromDemo

        try {
          const dash = await getDeviceDashboardData()
          const dashRows = (dash && (dash.rows || (dash.data && dash.data.devices))) || null
          if (dash && dash.data && Array.isArray(dash.data.devices) && dash.data.devices.length) {
            this.devices = dash.data.devices.map((d) => ({
              ...d,
              statusName: d.statusName || d.status,
              _demo: false
            }))
            this.fromDemo = false
          } else if (Array.isArray(dashRows) && dashRows.length) {
            this.devices = dashRows
            this.fromDemo = false
          }
        } catch (e) {
          /* list already loaded or demo */
        }

        try {
          const statsRes = await getDeviceStatistics()
          const raw = (statsRes && statsRes.data) || statsRes || {}
          this.statistics = {
            normal: raw.正常 || raw.normal || 0,
            stopped: raw.停用 || raw.stopped || 0,
            maintenance: raw.维护中 || raw.maintenance || 0,
            scrapped: raw.已报废 || raw.scrapped || 0
          }
        } catch (e) {
          this.statistics = this.devices.reduce(
            (acc, d) => {
              const s = Number(d.status)
              if (s === 1) acc.normal += 1
              else if (s === 2) acc.stopped += 1
              else if (s === 3) acc.maintenance += 1
              else if (s === 4) acc.scrapped += 1
              return acc
            },
            { normal: 0, stopped: 0, maintenance: 0, scrapped: 0 }
          )
        }

        if (!this.activeDeviceId && this.devices.length) {
          this.activeDeviceId = this.devices[0].deviceId
        }
        this.tickerLines = this.buildTicker()
      } catch (err) {
        const normalized = normalizeDeviceList(null)
        this.devices = normalized.devices
        this.fromDemo = true
        this.activeDeviceId = this.devices[0].deviceId
        this.statistics = { normal: 3, stopped: 1, maintenance: 1, scrapped: 0 }
        this.tickerLines = this.buildTicker()
        this.$message.warning('设备接口不可用，已切换演示种子数据')
      } finally {
        this.loading = false
      }
    },
    buildTicker() {
      const prefix = this.fromDemo ? '[演示]' : '[实时]'
      return this.devices.slice(0, 8).map((d) => {
        return `${prefix} ${d.deviceName} · ${d.statusName || '—'} · ${d.location || '未定位'}`
      })
    }
  }
}
</script>

<style lang="scss" scoped>
@import url('https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@500;600;700&family=DM+Sans:wght@400;500;600;700&family=Noto+Sans+SC:wght@400;500;700&display=swap');

.ops-screen {
  --ops-red: #e30613;
  --ops-ivory: #f7f0e6;
  --ops-espresso: #120c0a;
  --ops-roast: #2a1812;
  --ops-gold: #c4a35a;
  position: relative;
  min-height: 100vh;
  width: 100%;
  overflow: hidden;
  color: var(--ops-ivory);
  background: var(--ops-espresso);
  font-family: 'DM Sans', 'Noto Sans SC', sans-serif;
  opacity: 0;
  transform: scale(1.02);
  transition: opacity 0.8s cubic-bezier(0.22, 1, 0.36, 1), transform 1s cubic-bezier(0.22, 1, 0.36, 1);

  &.is-ready {
    opacity: 1;
    transform: none;
  }
}

.ops-atmosphere {
  position: absolute;
  inset: 0;
  z-index: 0;
  pointer-events: none;
}

.ops-wash--a {
  position: absolute;
  inset: -10%;
  background:
    radial-gradient(55% 45% at 18% 20%, rgba(227, 6, 19, 0.28), transparent 60%),
    radial-gradient(50% 40% at 82% 18%, rgba(196, 163, 90, 0.16), transparent 55%),
    linear-gradient(160deg, #1a100c 0%, #0d0908 55%, #1c0f0c 100%);
}

.ops-wash--b {
  position: absolute;
  inset: 0;
  background:
    linear-gradient(90deg, rgba(12, 8, 6, 0.72) 0%, transparent 28%, transparent 72%, rgba(12, 8, 6, 0.75) 100%),
    linear-gradient(180deg, rgba(12, 8, 6, 0.35) 0%, transparent 35%, rgba(12, 8, 6, 0.82) 100%);
}

.ops-photo-depth {
  position: absolute;
  inset: 0;
  background-image:
    repeating-linear-gradient(
      0deg,
      transparent,
      transparent 3px,
      rgba(255, 255, 255, 0.012) 3px,
      rgba(255, 255, 255, 0.012) 4px
    );
  mix-blend-mode: soft-light;
  opacity: 0.55;
  animation: opsDrift 18s ease-in-out infinite alternate;
}

.ops-grain {
  position: absolute;
  inset: 0;
  opacity: 0.08;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.85' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");
}

@keyframes opsDrift {
  from { transform: translateY(0); }
  to { transform: translateY(-2.5%); }
}

.ops-top,
.ops-hero,
.ops-rail,
.ops-bottom {
  position: relative;
  z-index: 2;
}

.ops-top {
  display: grid;
  grid-template-columns: 1fr auto 1fr;
  align-items: center;
  gap: 16px;
  padding: 22px clamp(18px, 3vw, 40px) 0;
}

.ops-brand {
  display: flex;
  align-items: center;
  gap: 14px;
}

.ops-brand-mark {
  width: 34px;
  height: 34px;
  display: grid;
  place-items: center;
  position: relative;

  i {
    position: absolute;
    border: 1.5px solid var(--ops-red);
    border-radius: 50%;
    animation: markPulse 3.6s ease-in-out infinite;

    &:nth-child(1) { width: 10px; height: 10px; }
    &:nth-child(2) { width: 20px; height: 20px; animation-delay: 0.35s; opacity: 0.7; }
    &:nth-child(3) { width: 30px; height: 30px; animation-delay: 0.7s; opacity: 0.4; }
  }
}

@keyframes markPulse {
  0%, 100% { transform: scale(1); opacity: 0.85; }
  50% { transform: scale(1.08); opacity: 1; }
}

.ops-brand-copy {
  display: flex;
  flex-direction: column;
  gap: 2px;

  strong {
    font-family: 'Cormorant Garamond', 'Noto Serif SC', serif;
    font-size: 1.55rem;
    font-weight: 700;
    letter-spacing: 0.02em;
    line-height: 1;
  }

  span {
    font-size: 10px;
    letter-spacing: 0.18em;
    color: rgba(247, 240, 230, 0.55);
  }
}

.ops-clock {
  text-align: center;

  span {
    display: block;
    font-size: 11px;
    letter-spacing: 0.16em;
    color: rgba(247, 240, 230, 0.5);
  }

  b {
    font-family: 'Cormorant Garamond', serif;
    font-size: 1.75rem;
    font-weight: 600;
    letter-spacing: 0.08em;
  }
}

.ops-top-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  flex-wrap: wrap;
}

.ops-ghost,
.ops-solid {
  border: 1px solid rgba(247, 240, 230, 0.28);
  background: transparent;
  color: var(--ops-ivory);
  padding: 10px 16px;
  font-size: 12px;
  letter-spacing: 0.08em;
  cursor: pointer;
  transition: transform 0.25s cubic-bezier(0.22, 1, 0.36, 1), background 0.25s ease, border-color 0.25s ease;
  text-decoration: none;
  display: inline-flex;
  align-items: center;

  &:hover {
    transform: translateY(-2px);
    border-color: var(--ops-red);
  }

  &.linkish {
    line-height: 1;
  }
}

.ops-solid {
  background: var(--ops-red);
  border-color: var(--ops-red);
  font-weight: 600;

  &:hover {
    background: #ff1d2b;
  }
}

.ops-hero {
  max-width: 520px;
  padding: clamp(28px, 5vh, 64px) 0 0 clamp(18px, 3vw, 40px);
  animation: heroIn 1s cubic-bezier(0.22, 1, 0.36, 1) 0.15s both;
}

@keyframes heroIn {
  from { opacity: 0; transform: translateY(28px); }
  to { opacity: 1; transform: none; }
}

.ops-eyebrow {
  margin: 0 0 14px;
  font-size: 11px;
  letter-spacing: 0.22em;
  color: var(--ops-gold);
}

.ops-title {
  margin: 0;
  font-family: 'Cormorant Garamond', 'Noto Serif SC', serif;
  font-size: clamp(2.6rem, 5.5vw, 4.4rem);
  font-weight: 600;
  line-height: 1.05;
  letter-spacing: 0.01em;

  span {
    color: #ffd8cf;
  }
}

.ops-lead {
  margin: 18px 0 26px;
  max-width: 36ch;
  font-size: 15px;
  line-height: 1.65;
  color: rgba(247, 240, 230, 0.72);
}

.ops-cta {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}

.ops-rail {
  position: absolute;
  top: 110px;
  bottom: 210px;
  width: min(280px, 22vw);
  display: flex;
  flex-direction: column;
  gap: 12px;
  z-index: 3;
}

.ops-rail--left {
  left: clamp(18px, 3vw, 40px);
  justify-content: center;
}

.ops-rail--right {
  right: clamp(18px, 3vw, 40px);
  overflow: auto;
  padding-right: 4px;
}

.ops-kpi {
  position: relative;
  padding: 14px 16px 18px;
  background: linear-gradient(135deg, rgba(42, 24, 18, 0.72), rgba(18, 12, 10, 0.55));
  border: 1px solid rgba(247, 240, 230, 0.1);
  backdrop-filter: blur(10px);
  overflow: hidden;
  animation: kpiIn 0.7s cubic-bezier(0.22, 1, 0.36, 1) both;

  &:nth-child(1) { animation-delay: 0.2s; }
  &:nth-child(2) { animation-delay: 0.3s; }
  &:nth-child(3) { animation-delay: 0.4s; }
  &:nth-child(4) { animation-delay: 0.5s; }
}

@keyframes kpiIn {
  from { opacity: 0; transform: translateX(-16px); }
  to { opacity: 1; transform: none; }
}

.ops-kpi-label {
  display: block;
  font-size: 11px;
  letter-spacing: 0.14em;
  color: rgba(247, 240, 230, 0.55);
}

.ops-kpi-value {
  display: block;
  margin-top: 6px;
  font-family: 'Cormorant Garamond', serif;
  font-size: 2.4rem;
  font-weight: 600;
  line-height: 1;
}

.ops-kpi-bar {
  position: absolute;
  left: 0;
  bottom: 0;
  height: 2px;
  background: var(--ops-red);
  max-width: 100%;
}

.ops-kpi.is-maintenance .ops-kpi-bar { background: var(--ops-gold); }
.ops-kpi.is-stopped .ops-kpi-bar { background: #8a7a6a; }
.ops-kpi.is-scrapped .ops-kpi-bar { background: #c0392b; }

.ops-panel-head {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  padding: 0 2px 6px;
  font-size: 12px;
  letter-spacing: 0.16em;
  text-transform: uppercase;
  color: rgba(247, 240, 230, 0.6);

  small {
    letter-spacing: 0.08em;
    color: var(--ops-gold);
  }
}

.ops-device-row {
  display: grid;
  grid-template-columns: 72px 1fr;
  gap: 10px;
  padding: 8px;
  border: 1px solid rgba(247, 240, 230, 0.08);
  background: rgba(18, 12, 10, 0.55);
  color: inherit;
  text-align: left;
  cursor: pointer;
  transition: border-color 0.25s ease, transform 0.25s ease, background 0.25s ease;

  &:hover,
  &.active {
    border-color: rgba(227, 6, 19, 0.55);
    background: rgba(42, 24, 18, 0.75);
    transform: translateX(-3px);
  }
}

.ops-device-thumb {
  height: 72px;
  overflow: hidden;
}

.ops-device-meta {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;

  strong {
    font-size: 13px;
    font-weight: 600;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  span {
    font-size: 11px;
    color: rgba(247, 240, 230, 0.55);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  em {
    font-style: normal;
    font-size: 11px;
    letter-spacing: 0.08em;
  }
}

.ops-bottom {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 3;
  display: grid;
  grid-template-columns: minmax(280px, 420px) 1fr;
  gap: 18px;
  padding: 0 clamp(18px, 3vw, 40px) 18px;
  align-items: end;
}

.ops-focus {
  display: grid;
  grid-template-columns: 160px 1fr;
  gap: 14px;
  padding: 12px;
  background: linear-gradient(135deg, rgba(42, 24, 18, 0.85), rgba(12, 8, 6, 0.7));
  border: 1px solid rgba(247, 240, 230, 0.12);
  backdrop-filter: blur(12px);
}

.ops-focus-stage {
  height: 140px;
}

.ops-focus-kicker {
  margin: 0;
  font-size: 10px;
  letter-spacing: 0.2em;
  color: var(--ops-gold);
}

.ops-focus-copy {
  h2 {
    margin: 6px 0 4px;
    font-family: 'Cormorant Garamond', serif;
    font-size: 1.7rem;
    font-weight: 600;
    line-height: 1.1;
  }

  p {
    margin: 0;
    font-size: 12px;
    color: rgba(247, 240, 230, 0.65);
  }
}

.ops-focus-loc {
  margin-top: 6px !important;
}

.ops-focus-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-top: 10px;

  span {
    padding: 4px 8px;
    border: 1px solid rgba(247, 240, 230, 0.18);
    font-size: 10px;
    letter-spacing: 0.08em;
  }
}

.ops-ticker {
  display: flex;
  gap: 28px;
  overflow: hidden;
  white-space: nowrap;
  mask-image: linear-gradient(90deg, transparent, #000 8%, #000 92%, transparent);
  padding: 14px 0;

  span {
    display: inline-block;
    animation: ticker 28s linear infinite;
    font-size: 12px;
    letter-spacing: 0.06em;
    color: rgba(247, 240, 230, 0.62);
  }
}

@keyframes ticker {
  from { transform: translateX(20%); }
  to { transform: translateX(-100%); }
}

@media (max-width: 1100px) {
  .ops-rail--left,
  .ops-rail--right {
    display: none;
  }

  .ops-bottom {
    grid-template-columns: 1fr;
  }

  .ops-hero {
    max-width: 90%;
  }
}

@media (max-width: 720px) {
  .ops-top {
    grid-template-columns: 1fr;
    justify-items: start;
  }

  .ops-clock {
    display: none;
  }

  .ops-title {
    font-size: 2.3rem;
  }

  .ops-focus {
    grid-template-columns: 1fr;
  }
}
</style>

<style lang="scss">
body.ops-screen-lock {
  overflow: hidden;
  background: #120c0a;
}
</style>
