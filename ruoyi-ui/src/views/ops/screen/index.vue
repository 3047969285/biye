<template>
  <div class="ops-screen" :class="{ 'is-ready': ready }">
    <div class="ops-atmosphere" aria-hidden="true">
      <div class="ops-photo" />
      <div class="ops-vignette" />
      <div class="ops-grain" />
    </div>

    <!-- 中央三维构图：占满第一视口 -->
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

    <!-- 品牌叙事叠在构图左下，不抢中央三维 -->
    <section class="ops-hero">
      <p class="ops-eyebrow">{{ fromDemo ? 'DEMO SEED · 演示数据' : 'LIVE FLEET · 设备域' }}</p>
      <h1 class="ops-title">让每一度电，<em>都在指挥视野里。</em></h1>
      <p class="ops-lead">感知 · 预判 · 处置——同一构图完成。</p>
      <div class="ops-cta">
        <button type="button" class="ops-solid" @click="focusNext">巡视下一台</button>
        <button type="button" class="ops-ghost" @click="goHome">设备台账</button>
      </div>
    </section>

    <!-- 用 div 而非 aside：全局 index.scss 的 aside 规则会刷成象牙白底板 -->
    <div class="ops-rail ops-rail--left" role="complementary" aria-label="运行指标">
      <div
        v-for="item in kpiItems"
        :key="item.key"
        class="ops-kpi"
        :class="'is-' + item.key"
      >
        <span class="ops-kpi-label">{{ item.label }}</span>
        <strong class="ops-kpi-value">{{ item.value }}</strong>
        <i class="ops-kpi-bar" :style="{ width: Math.max(item.bar, 8) + '%' }" />
      </div>
    </div>

    <div class="ops-rail ops-rail--right" role="complementary" aria-label="设备阵列">
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
    </div>

    <footer class="ops-bottom" v-if="activeDevice">
      <div class="ops-focus">
        <div class="ops-focus-copy">
          <p class="ops-focus-kicker">FOCUS · {{ activeDevice.deviceNo }}</p>
          <h2>{{ activeDevice.deviceName }}</h2>
          <p>{{ activeDevice.deviceType }} · {{ activeDevice.location || '位置未登记' }}</p>
          <div class="ops-focus-tags">
            <span>{{ activeDevice.statusName }}</span>
            <span v-if="activeDevice.totalCount != null">数据 {{ activeDevice.totalCount }} 条</span>
            <span v-if="fromDemo || activeDevice._demo">演示种子</span>
          </div>
        </div>
        <div class="ops-ticker" aria-live="polite">
          <span v-for="(line, idx) in tickerLines" :key="idx">{{ line }}</span>
        </div>
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
    if (screenfull.isEnabled) screenfull.on('change', this.syncFullscreen)
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
      if (getToken()) this.$router.push('/index')
      else this.$router.push('/login')
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
          if (dash && dash.data && Array.isArray(dash.data.devices) && dash.data.devices.length) {
            this.devices = dash.data.devices.map((d) => ({
              ...d,
              statusName: d.statusName || d.status,
              _demo: false
            }))
            this.fromDemo = false
          }
        } catch (e) { /* keep list */ }

        this.statistics = this.countStats(this.devices)
        try {
          const statsRes = await getDeviceStatistics()
          const raw = (statsRes && statsRes.data) || statsRes || {}
          const next = {
            normal: Number(raw.正常 || raw.normal || 0),
            stopped: Number(raw.停用 || raw.stopped || 0),
            maintenance: Number(raw.维护中 || raw.maintenance || 0),
            scrapped: Number(raw.已报废 || raw.scrapped || 0)
          }
          const sum = next.normal + next.stopped + next.maintenance + next.scrapped
          if (sum > 0 && !this.fromDemo) this.statistics = next
        } catch (e) { /* keep device-derived counts */ }

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
    countStats(devices) {
      return (devices || []).reduce(
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
  --ops-espresso: #140e0b;
  --ops-roast: #2a1812;
  --ops-gold: #c4a35a;
  --ops-glass: rgba(36, 22, 16, 0.55);
  --ops-glass-border: rgba(255, 220, 190, 0.14);
  position: relative;
  min-height: 100vh;
  width: 100%;
  overflow: hidden;
  color: var(--ops-ivory);
  background: #1a100c;
  font-family: 'DM Sans', 'Noto Sans SC', sans-serif;
  opacity: 0;
  transition: opacity 0.85s cubic-bezier(0.22, 1, 0.36, 1);

  &.is-ready { opacity: 1; }
}

.ops-atmosphere {
  position: absolute;
  inset: 0;
  z-index: 0;
  pointer-events: none;
}

.ops-photo {
  position: absolute;
  inset: 0;
  background:
    radial-gradient(70% 55% at 50% 38%, rgba(255, 186, 140, 0.2), transparent 62%),
    radial-gradient(45% 40% at 12% 18%, rgba(227, 6, 19, 0.36), transparent 58%),
    radial-gradient(40% 35% at 88% 22%, rgba(196, 163, 90, 0.22), transparent 55%),
    radial-gradient(30% 25% at 70% 80%, rgba(255, 160, 120, 0.1), transparent 60%),
    linear-gradient(165deg, #3a241c 0%, #1a100c 42%, #0e0a08 100%);
  animation: photoDrift 16s ease-in-out infinite alternate;
}

.ops-photo::after {
  content: '';
  position: absolute;
  inset: 0;
  background:
    linear-gradient(115deg, transparent 40%, rgba(255, 220, 190, 0.06) 48%, transparent 56%);
  animation: photoShaft 9s ease-in-out infinite alternate;
}

.ops-vignette {
  position: absolute;
  inset: 0;
  background:
    linear-gradient(90deg, rgba(14, 10, 8, 0.55) 0%, transparent 22%, transparent 78%, rgba(14, 10, 8, 0.58) 100%),
    linear-gradient(180deg, rgba(14, 10, 8, 0.35) 0%, transparent 28%, rgba(14, 10, 8, 0.72) 100%);
}

.ops-grain {
  position: absolute;
  inset: 0;
  opacity: 0.1;
  mix-blend-mode: soft-light;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");
}

@keyframes photoDrift {
  from { transform: scale(1); }
  to { transform: scale(1.05) translateY(-1.4%); }
}

@keyframes photoShaft {
  from { opacity: 0.35; transform: translateX(-4%); }
  to { opacity: 0.85; transform: translateX(5%); }
}

.ops-top,
.ops-hero,
.ops-rail,
.ops-bottom {
  position: relative;
  z-index: 4;
}

.ops-top {
  display: grid;
  grid-template-columns: 1fr auto 1fr;
  align-items: center;
  gap: 16px;
  padding: 20px clamp(18px, 3vw, 40px) 0;
}

.ops-brand {
  display: flex;
  align-items: center;
  gap: 14px;
}

.ops-brand-mark {
  width: 34px;
  height: 34px;
  position: relative;
  display: grid;
  place-items: center;

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
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.08); }
}

.ops-brand-copy {
  display: flex;
  flex-direction: column;
  gap: 2px;

  strong {
    font-family: 'Cormorant Garamond', 'Noto Serif SC', serif;
    font-size: clamp(1.5rem, 2.4vw, 1.9rem);
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
    font-size: 1.7rem;
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

  &:hover {
    transform: translateY(-2px);
    border-color: var(--ops-red);
  }
}

.ops-solid {
  background: var(--ops-red);
  border-color: var(--ops-red);
  font-weight: 600;
  &:hover { background: #ff1d2b; }
}

.ops-hero {
  position: absolute;
  left: clamp(18px, 3vw, 40px);
  bottom: 108px;
  z-index: 4;
  max-width: min(340px, 26vw);
  padding: 16px 18px 18px;
  background: linear-gradient(145deg, rgba(42, 24, 18, 0.35), rgba(20, 14, 11, 0.18));
  border: 1px solid rgba(255, 220, 190, 0.12);
  border-left: 2px solid var(--ops-red);
  backdrop-filter: blur(10px) saturate(1.05);
  animation: heroIn 0.9s cubic-bezier(0.22, 1, 0.36, 1) 0.1s both;
}

@keyframes heroIn {
  from { opacity: 0; transform: translateY(18px); }
  to { opacity: 1; transform: none; }
}

.ops-eyebrow {
  margin: 0 0 10px;
  font-size: 10px;
  letter-spacing: 0.2em;
  color: var(--ops-gold);
}

.ops-title {
  margin: 0;
  font-family: 'Cormorant Garamond', 'Noto Serif SC', serif;
  font-size: clamp(1.55rem, 2.4vw, 2.15rem);
  font-weight: 600;
  line-height: 1.15;

  em {
    font-style: normal;
    color: #ffd2c6;
  }
}

.ops-lead {
  margin: 10px 0 14px;
  font-size: 13px;
  line-height: 1.55;
  color: rgba(247, 240, 230, 0.7);
}

.ops-cta {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.ops-rail {
  position: absolute;
  top: 96px;
  bottom: 96px;
  width: min(268px, 20vw);
  display: flex;
  flex-direction: column;
  gap: 10px;
  z-index: 5;
}

.ops-rail--left {
  left: clamp(14px, 2.4vw, 32px);
  justify-content: center;
  padding: 12px;
  background: #1c120e !important;
  background-color: #1c120e !important;
  background-image: linear-gradient(165deg, #2a1812, #140e0b) !important;
  border: 1px solid rgba(255, 210, 170, 0.16) !important;
  box-shadow: 0 18px 48px rgba(0, 0, 0, 0.35);
}

.ops-rail--right {
  right: clamp(14px, 2.4vw, 32px);
  overflow: auto;
  padding: 12px;
  background: #1c120e !important;
  background-image: linear-gradient(160deg, #2a1812 0%, #140e0b 100%) !important;
  border: 1px solid rgba(255, 210, 170, 0.16);
  box-shadow: 0 18px 48px rgba(0, 0, 0, 0.35);
}

.ops-kpi {
  position: relative;
  padding: 12px 14px 16px;
  background: #241610 !important;
  background-image: linear-gradient(145deg, #3a241c 0%, #1a100c 100%) !important;
  border: 1px solid rgba(255, 210, 170, 0.18) !important;
  color: #f7f0e6 !important;
  box-shadow: inset 0 1px 0 rgba(255, 220, 190, 0.06);
  overflow: hidden;
  animation: kpiIn 0.7s cubic-bezier(0.22, 1, 0.36, 1) both;

  &:nth-child(1) { animation-delay: 0.15s; }
  &:nth-child(2) { animation-delay: 0.25s; }
  &:nth-child(3) { animation-delay: 0.35s; }
  &:nth-child(4) { animation-delay: 0.45s; }
}

@keyframes kpiIn {
  from { opacity: 0; transform: translateX(-14px); }
  to { opacity: 1; transform: none; }
}

.ops-kpi-label {
  display: block;
  font-size: 10px;
  letter-spacing: 0.16em;
  color: rgba(247, 240, 230, 0.58);
}

.ops-kpi-value {
  display: block;
  margin-top: 4px;
  font-family: 'Cormorant Garamond', serif;
  font-size: 2.2rem;
  font-weight: 600;
  line-height: 1;
  color: #fff6ee;
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
.ops-kpi.is-stopped .ops-kpi-bar { background: #9a8578; }
.ops-kpi.is-scrapped .ops-kpi-bar { background: #c0392b; }

.ops-panel-head {
  display: flex;
  justify-content: space-between;
  padding: 0 2px 8px;
  font-size: 11px;
  letter-spacing: 0.16em;
  text-transform: uppercase;
  color: rgba(247, 240, 230, 0.62);

  small { color: var(--ops-gold); }
}

.ops-device-row {
  display: grid;
  grid-template-columns: 92px 1fr;
  gap: 10px;
  padding: 8px;
  margin-bottom: 8px;
  border: 1px solid rgba(255, 220, 190, 0.1);
  background: rgba(20, 14, 11, 0.45) !important;
  color: var(--ops-ivory) !important;
  text-align: left;
  cursor: pointer;
  transition: border-color 0.25s ease, transform 0.25s ease, background 0.25s ease;

  &:hover,
  &.active {
    border-color: rgba(227, 6, 19, 0.55);
    background: rgba(58, 36, 28, 0.72) !important;
    transform: translateX(-3px);
  }
}

.ops-device-thumb {
  height: 96px;
  overflow: hidden;
  border: 1px solid rgba(255, 220, 190, 0.18);
  background: #2a1812;
}

.ops-device-meta {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
  justify-content: center;

  strong {
    font-family: 'Cormorant Garamond', serif;
    font-size: 1.15rem;
    font-weight: 600;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  span {
    font-size: 11px;
    color: rgba(247, 240, 230, 0.58);
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
  z-index: 5;
  padding: 0 clamp(18px, 3vw, 40px) 16px;
}

.ops-focus {
  display: grid;
  grid-template-columns: minmax(260px, 420px) 1fr;
  gap: 20px;
  align-items: end;
  padding: 14px 18px;
  background: linear-gradient(90deg, rgba(42, 24, 18, 0.72), rgba(20, 14, 11, 0.35));
  border-top: 1px solid var(--ops-glass-border);
  backdrop-filter: blur(14px);
}

.ops-focus-kicker {
  margin: 0;
  font-size: 10px;
  letter-spacing: 0.2em;
  color: var(--ops-gold);
}

.ops-focus-copy {
  h2 {
    margin: 4px 0;
    font-family: 'Cormorant Garamond', serif;
    font-size: 1.65rem;
    font-weight: 600;
    line-height: 1.1;
  }
  p {
    margin: 0;
    font-size: 12px;
    color: rgba(247, 240, 230, 0.65);
  }
}

.ops-focus-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-top: 8px;

  span {
    padding: 3px 8px;
    border: 1px solid rgba(255, 220, 190, 0.2);
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
  padding: 10px 0;

  span {
    display: inline-block;
    animation: ticker 28s linear infinite;
    font-size: 12px;
    letter-spacing: 0.06em;
    color: rgba(247, 240, 230, 0.62);
  }
}

@keyframes ticker {
  from { transform: translateX(18%); }
  to { transform: translateX(-100%); }
}

@media (max-width: 1100px) {
  .ops-rail--left { display: none; }
  .ops-rail--right {
    width: min(240px, 34vw);
    bottom: 110px;
  }
  .ops-hero {
    max-width: min(420px, 48vw);
    bottom: 110px;
  }
}

@media (max-width: 720px) {
  .ops-top { grid-template-columns: 1fr; }
  .ops-clock { display: none; }
  .ops-rail--right { display: none; }
  .ops-hero {
    position: relative;
    left: auto;
    bottom: auto;
    max-width: none;
    margin: 12px 16px;
  }
  .ops-focus { grid-template-columns: 1fr; }
}
</style>

<style lang="scss">
body.ops-screen-lock {
  overflow: hidden;
  background: #140e0b !important;
}

/* 防止全局 Element / modern-theme / aside 默认把大屏刷成白卡片 */
.ops-screen aside,
.ops-screen .ops-rail,
.ops-screen .ops-rail--left,
.ops-screen .ops-rail--right {
  background: #1c120e !important;
  background-color: #1c120e !important;
}

.ops-screen .ops-kpi {
  background: #241610 !important;
  background-image: linear-gradient(145deg, #3a241c 0%, #1a100c 100%) !important;
}

.ops-screen .ops-device-row {
  background: rgba(20, 14, 11, 0.65) !important;
}
</style>
