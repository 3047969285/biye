<template>
  <div
    class="device-sil"
    :class="[
      `is-${size}`,
      `kind-${kind}`,
      {
        spin: spinning,
        'is-lit': lit,
        'is-focus': focused
      }
    ]"
    :style="{ '--tone': tone, '--lift': lit ? '1' : '0.68' }"
  >
    <div class="device-sil__beam" aria-hidden="true" />
    <div class="device-sil__haze" aria-hidden="true" />
    <div class="device-sil__plate" />
    <div class="device-sil__glow" />
    <div class="device-sil__model">
      <template v-if="kind === 'turbine'">
        <span class="t-base" />
        <span class="t-tower" />
        <span class="t-nacelle" />
        <span class="t-hub">
          <i /><i /><i />
        </span>
      </template>
      <template v-else-if="kind === 'transformer'">
        <span class="x-shadow" />
        <span class="x-tank" />
        <span class="x-fin a" /><span class="x-fin b" /><span class="x-fin c" /><span class="x-fin d" />
        <span class="x-bush" /><span class="x-bush r" /><span class="x-bush c" />
        <span class="x-badge">TF</span>
      </template>
      <template v-else-if="kind === 'generator'">
        <span class="g-skid" />
        <span class="g-body" />
        <span class="g-band" />
        <span class="g-cap" />
        <span class="g-vent" />
        <span class="g-pipe" />
      </template>
      <template v-else-if="kind === 'sensor'">
        <span class="s-base" />
        <span class="s-mast" />
        <span class="s-head" />
        <span class="s-dish" />
        <span class="s-beam" />
      </template>
      <template v-else-if="kind === 'breaker'">
        <span class="b-cabinet" />
        <span class="b-door" />
        <span class="b-glass" />
        <span class="b-handle" />
        <span class="b-lamp" />
      </template>
      <template v-else>
        <span class="n-core" />
        <span class="n-ring" />
        <span class="n-ring outer" />
        <span class="n-dot" />
      </template>
    </div>
    <span class="device-sil__kind">{{ kindLabel }}</span>
  </div>
</template>

<script>
import { resolveMeshKind, statusTone } from '@/utils/ops/deviceCatalog'

const KIND_LABEL = {
  turbine: 'TURBINE',
  transformer: 'XFRM',
  generator: 'GEN',
  sensor: 'SENSOR',
  breaker: 'BREAKER',
  node: 'NODE'
}

/** 高对比 CSS 立体设备：六种造型刻意拉开差异，带摄影光与怠速动效 */
export default {
  name: 'DeviceSilhouette',
  props: {
    device: { type: Object, default: null },
    size: { type: String, default: 'md' },
    spinning: { type: Boolean, default: true },
    focused: { type: Boolean, default: false }
  },
  computed: {
    kind() {
      const d = this.device || {}
      return resolveMeshKind(d.deviceType, d.deviceName)
    },
    kindLabel() {
      return KIND_LABEL[this.kind] || 'NODE'
    },
    tone() {
      return statusTone((this.device && this.device.status) || 1)
    },
    lit() {
      return Number((this.device && this.device.status) || 1) === 1
    }
  }
}
</script>

<style lang="scss" scoped>
.device-sil {
  --tone: #e30613;
  --lift: 1;
  position: relative;
  width: 100%;
  height: 100%;
  display: grid;
  place-items: center;
  overflow: hidden;
  isolation: isolate;
  background:
    radial-gradient(120% 90% at 50% 0%, rgba(255, 214, 170, 0.32), transparent 55%),
    radial-gradient(90% 70% at 78% 100%, rgba(227, 6, 19, 0.26), transparent 52%),
    linear-gradient(165deg, #6a4030 0%, #2a1812 48%, #120c0a 100%);
  transition: filter 0.45s cubic-bezier(0.22, 1, 0.36, 1), transform 0.45s cubic-bezier(0.22, 1, 0.36, 1);
}

.device-sil.is-focus {
  filter: brightness(1.08) saturate(1.12);
  transform: scale(1.02);
}

.device-sil__beam {
  position: absolute;
  inset: -20% -10% auto;
  height: 55%;
  background: linear-gradient(180deg, rgba(255, 236, 214, 0.28), transparent 70%);
  transform: skewX(-12deg);
  animation: beamDrift 7s ease-in-out infinite alternate;
  pointer-events: none;
}

.device-sil__haze {
  position: absolute;
  inset: 0;
  background:
    radial-gradient(40% 30% at 30% 20%, rgba(255, 220, 190, 0.16), transparent 70%);
  mix-blend-mode: screen;
  opacity: 0.7;
  animation: hazePulse 5.5s ease-in-out infinite;
  pointer-events: none;
}

.device-sil__plate {
  position: absolute;
  left: 16%;
  right: 16%;
  bottom: 9%;
  height: 14%;
  border-radius: 50%;
  background: radial-gradient(ellipse at center, rgba(0, 0, 0, 0.6), transparent 70%);
  filter: blur(2px);
}

.device-sil__glow {
  position: absolute;
  left: 20%;
  right: 20%;
  bottom: 11%;
  height: 18%;
  border-radius: 50%;
  border: 1px solid rgba(227, 6, 19, 0.55);
  box-shadow: 0 0 28px rgba(227, 6, 19, 0.38);
  transform: rotateX(68deg) scale(1.05);
  opacity: calc(0.45 + var(--lift) * 0.35);
  animation: glowBreath 3.8s ease-in-out infinite;
}

.device-sil__model {
  position: relative;
  width: 58%;
  height: 68%;
  transform-style: preserve-3d;
  transform: rotateX(14deg) rotateY(-32deg);
  filter: brightness(calc(0.96 + var(--lift) * 0.28)) contrast(1.1);
  z-index: 2;
}

.spin .device-sil__model {
  animation: silYaw 7.2s ease-in-out infinite;
}

.device-sil__kind {
  position: absolute;
  left: 8px;
  top: 7px;
  z-index: 3;
  font-family: 'DM Sans', 'Noto Sans SC', sans-serif;
  font-size: 9px;
  letter-spacing: 0.16em;
  color: rgba(255, 240, 224, 0.55);
  pointer-events: none;
}

.is-sm .device-sil__model { width: 64%; height: 72%; }
.is-md .device-sil__model { width: 58%; height: 68%; }
.is-lg .device-sil__model { width: 52%; height: 64%; }
.is-xl .device-sil__model {
  width: 52%;
  height: 68%;
  transform: rotateX(12deg) rotateY(-28deg) scale(1.35);
}
.is-sm .device-sil__kind { display: none; }

@keyframes silYaw {
  0%, 100% { transform: rotateX(14deg) rotateY(-36deg) translateY(0); }
  50% { transform: rotateX(16deg) rotateY(28deg) translateY(-3%); }
}
@keyframes beamDrift {
  from { transform: skewX(-12deg) translateX(-4%); opacity: 0.55; }
  to { transform: skewX(-8deg) translateX(6%); opacity: 0.9; }
}
@keyframes hazePulse {
  0%, 100% { opacity: 0.45; }
  50% { opacity: 0.85; }
}
@keyframes glowBreath {
  0%, 100% { opacity: 0.4; transform: rotateX(68deg) scale(1); }
  50% { opacity: 0.75; transform: rotateX(68deg) scale(1.06); }
}

/* —— turbine：修长塔筒 + 三叶旋翼 —— */
.kind-turbine { background:
  radial-gradient(120% 90% at 50% 0%, rgba(180, 220, 255, 0.12), transparent 50%),
  radial-gradient(90% 70% at 70% 100%, rgba(47, 143, 107, 0.22), transparent 50%),
  linear-gradient(165deg, #4a3428 0%, #1e1410 100%);
}
.t-base {
  position: absolute; left: 34%; bottom: 0; width: 32%; height: 10%;
  border-radius: 50%; background: #1a100c;
}
.t-tower {
  position: absolute; left: 46%; bottom: 6%; width: 9%; height: 72%;
  border-radius: 5px;
  background: linear-gradient(180deg, #f4e4d4, #8a5a40 42%, #3b241c);
  box-shadow: 4px 0 0 rgba(255, 230, 210, 0.18);
}
.t-nacelle {
  position: absolute; left: 36%; top: 12%; width: 36%; height: 11%;
  border-radius: 4px;
  background: linear-gradient(90deg, #fff4e8, #c9a88a);
}
.t-hub {
  position: absolute; left: 47%; top: 5%; width: 12%; aspect-ratio: 1;
  border-radius: 50%; background: var(--tone);
  box-shadow: 0 0 14px rgba(227, 6, 19, 0.55);
  animation: hubSpin 2s linear infinite;
  i {
    position: absolute; left: 42%; bottom: 50%; width: 16%; height: 230%;
    border-radius: 40% 40% 20% 20%;
    background: linear-gradient(180deg, #ffe7d6, var(--tone));
    transform-origin: 50% 100%;
  }
  i:nth-child(2) { transform: rotate(120deg); }
  i:nth-child(3) { transform: rotate(240deg); }
}
@keyframes hubSpin { to { transform: rotate(360deg); } }

/* —— transformer：厚箱体 + 散热片 + 套管 —— */
.kind-transformer { background:
  radial-gradient(100% 80% at 40% 10%, rgba(255, 210, 140, 0.22), transparent 55%),
  linear-gradient(165deg, #5a3a28 0%, #1a100c 100%);
}
.x-shadow {
  position: absolute; left: 12%; right: 12%; bottom: 4%; height: 12%;
  border-radius: 50%; background: rgba(0,0,0,0.35); filter: blur(3px);
}
.x-tank {
  position: absolute; left: 16%; bottom: 10%; width: 68%; height: 50%;
  background: linear-gradient(145deg, #e0c4a8, #6a4030 55%, #2a1812);
  box-shadow: inset 0 0 0 1px rgba(255, 235, 210, 0.25), 8px 0 0 #4a2e24, -8px 0 0 #4a2e24;
}
.x-fin {
  position: absolute; bottom: 14%; width: 5%; height: 42%;
  background: linear-gradient(180deg, #ffe8d4, #8a5a40);
}
.x-fin.a { left: 22%; } .x-fin.b { left: 38%; }
.x-fin.c { left: 54%; } .x-fin.d { left: 70%; }
.x-bush {
  position: absolute; left: 30%; bottom: 58%; width: 9%; height: 26%;
  border-radius: 4px 4px 0 0;
  background: linear-gradient(180deg, #fff0e0, var(--tone));
}
.x-bush.r { left: 46%; }
.x-bush.c { left: 62%; height: 22%; }
.x-badge {
  position: absolute; right: 14%; top: 18%;
  font-size: 9px; letter-spacing: 0.12em; color: rgba(255,236,214,0.5);
}

/* —— generator：卧式鼓形机组 —— */
.kind-generator { background:
  radial-gradient(90% 70% at 60% 20%, rgba(255, 180, 120, 0.2), transparent 55%),
  linear-gradient(165deg, #523628 0%, #18100c 100%);
}
.g-skid {
  position: absolute; left: 8%; bottom: 6%; width: 84%; height: 10%;
  border-radius: 3px; background: #140e0b;
}
.g-body {
  position: absolute; left: 12%; bottom: 14%; width: 76%; height: 48%;
  border-radius: 44px;
  background: linear-gradient(180deg, #f4e0cc 0%, #8a5a40 45%, #3b241c 100%);
  box-shadow: inset 0 -10px 18px rgba(0, 0, 0, 0.28);
}
.g-band {
  position: absolute; left: 28%; top: 38%; width: 12%; height: 28%;
  background: repeating-linear-gradient(90deg, rgba(26,16,12,0.4) 0 2px, transparent 2px 5px);
}
.g-cap {
  position: absolute; right: 8%; bottom: 20%; width: 16%; height: 36%;
  border-radius: 8px;
  background: linear-gradient(180deg, #ffb4aa, var(--tone));
  animation: genPulse 2.4s ease-in-out infinite;
}
.g-vent {
  position: absolute; left: 30%; top: 26%; width: 38%; height: 8%;
  background: repeating-linear-gradient(90deg, rgba(26,16,12,0.4) 0 3px, transparent 3px 7px);
}
.g-pipe {
  position: absolute; left: 18%; top: 14%; width: 8%; height: 18%;
  border-radius: 3px; background: #d9c4a8;
}
@keyframes genPulse {
  0%, 100% { filter: brightness(1); }
  50% { filter: brightness(1.25); }
}

/* —— sensor：桅杆 + 球头 + 碟 —— */
.kind-sensor { background:
  radial-gradient(80% 60% at 50% 15%, rgba(255, 120, 100, 0.22), transparent 55%),
  linear-gradient(165deg, #3a2820 0%, #120c0a 100%);
}
.s-base {
  position: absolute; left: 22%; bottom: 4%; width: 56%; height: 14%;
  border-radius: 50%;
  background: linear-gradient(180deg, #8a5a40, #2a1812);
}
.s-mast {
  position: absolute; left: 46%; bottom: 14%; width: 8%; height: 58%;
  border-radius: 4px;
  background: linear-gradient(180deg, #ffe8d4, #7a4d38);
}
.s-head {
  position: absolute; left: 34%; top: 8%; width: 32%; aspect-ratio: 1;
  border-radius: 50%;
  background: radial-gradient(circle at 35% 30%, #ffe0d6, var(--tone));
  box-shadow: 0 0 24px rgba(227, 6, 19, 0.6);
  animation: headPulse 1.8s ease-in-out infinite;
}
.s-dish {
  position: absolute; left: 58%; top: 30%; width: 28%; height: 18%;
  border: 2px solid #ffe8d4; border-radius: 50%;
  transform: rotate(-28deg);
}
.s-beam {
  position: absolute; left: 48%; top: 22%; width: 2px; height: 28%;
  background: linear-gradient(180deg, var(--tone), transparent);
  opacity: 0.7; animation: headPulse 1.8s ease-in-out infinite;
}
@keyframes headPulse {
  0%, 100% { filter: brightness(1); transform: scale(1); }
  50% { filter: brightness(1.35); transform: scale(1.06); }
}

/* —— breaker：立柜 + 视窗灯 —— */
.kind-breaker { background:
  radial-gradient(90% 70% at 50% 10%, rgba(200, 220, 255, 0.1), transparent 50%),
  linear-gradient(165deg, #3e2a22 0%, #120c0a 100%);
}
.b-cabinet {
  position: absolute; left: 24%; bottom: 6%; width: 52%; height: 78%;
  background: linear-gradient(180deg, #d7b59a, #4a2e24 60%, #1a100c);
  border: 1px solid rgba(255, 236, 214, 0.25);
}
.b-door {
  position: absolute; left: 28%; top: 18%; width: 44%; height: 62%;
  border: 1px solid rgba(255, 220, 190, 0.15);
}
.b-glass {
  position: absolute; left: 34%; top: 28%; width: 32%; height: 22%;
  background: linear-gradient(160deg, rgba(255, 220, 200, 0.55), var(--tone));
  box-shadow: 0 0 16px rgba(227, 6, 19, 0.4);
  animation: genPulse 2.8s ease-in-out infinite;
}
.b-handle {
  position: absolute; right: 30%; top: 58%; width: 8%; height: 16%;
  border-radius: 3px; background: #ffe8d4;
}
.b-lamp {
  position: absolute; left: 46%; top: 12%; width: 8%; aspect-ratio: 1;
  border-radius: 50%; background: var(--tone);
  box-shadow: 0 0 10px var(--tone);
}

/* —— node：多面体节点 —— */
.kind-node { background:
  radial-gradient(90% 70% at 50% 20%, rgba(255, 200, 160, 0.18), transparent 55%),
  linear-gradient(165deg, #4a3024 0%, #140e0b 100%);
}
.n-core {
  position: absolute; left: 28%; top: 22%; width: 44%; height: 44%;
  background: linear-gradient(145deg, #ffe8d4, #5a3426);
  clip-path: polygon(50% 0%, 100% 38%, 82% 100%, 18% 100%, 0% 38%);
}
.n-ring {
  position: absolute; left: 18%; top: 34%; width: 64%; height: 34%;
  border: 3px solid var(--tone); border-radius: 50%;
  transform: rotateX(62deg);
  animation: ringSpin 5s linear infinite;
}
.n-ring.outer {
  left: 10%; top: 30%; width: 80%; height: 42%;
  border-width: 1px; opacity: 0.45;
  animation-duration: 8s; animation-direction: reverse;
}
.n-dot {
  position: absolute; left: 46%; top: 38%; width: 8%; aspect-ratio: 1;
  border-radius: 50%; background: #fff6ee;
  box-shadow: 0 0 12px var(--tone);
}
@keyframes ringSpin {
  to { transform: rotateX(62deg) rotateZ(360deg); }
}
</style>
