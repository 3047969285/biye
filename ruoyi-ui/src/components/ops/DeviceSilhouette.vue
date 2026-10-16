<template>
  <div
    class="device-sil"
    :class="[`is-${size}`, `kind-${kind}`, { spin: spinning }]"
    :style="{ '--tone': tone, '--lift': lit ? '1' : '0.72' }"
  >
    <div class="device-sil__plate" />
    <div class="device-sil__glow" />
    <div class="device-sil__model">
      <!-- turbine -->
      <template v-if="kind === 'turbine'">
        <span class="t-tower" />
        <span class="t-nacelle" />
        <span class="t-hub">
          <i /><i /><i />
        </span>
      </template>
      <!-- transformer -->
      <template v-else-if="kind === 'transformer'">
        <span class="x-tank" />
        <span class="x-fin a" /><span class="x-fin b" /><span class="x-fin c" />
        <span class="x-bush" />
        <span class="x-bush r" />
      </template>
      <!-- generator -->
      <template v-else-if="kind === 'generator'">
        <span class="g-skid" />
        <span class="g-body" />
        <span class="g-cap" />
        <span class="g-vent" />
      </template>
      <!-- sensor -->
      <template v-else-if="kind === 'sensor'">
        <span class="s-base" />
        <span class="s-mast" />
        <span class="s-head" />
        <span class="s-dish" />
      </template>
      <!-- breaker -->
      <template v-else-if="kind === 'breaker'">
        <span class="b-cabinet" />
        <span class="b-glass" />
        <span class="b-handle" />
      </template>
      <!-- node -->
      <template v-else>
        <span class="n-core" />
        <span class="n-ring" />
        <span class="n-dot" />
      </template>
    </div>
  </div>
</template>

<script>
import { resolveMeshKind, statusTone } from '@/utils/ops/deviceCatalog'

/** 高对比度 CSS 立体设备剪影：专为无 WebGL / 缩略图场景设计 */
export default {
  name: 'DeviceSilhouette',
  props: {
    device: { type: Object, default: null },
    size: { type: String, default: 'md' }, // sm | md | lg | xl
    spinning: { type: Boolean, default: true }
  },
  computed: {
    kind() {
      const d = this.device || {}
      return resolveMeshKind(d.deviceType, d.deviceName)
    },
    tone() {
      const d = this.device || {}
      return statusTone(d.status)
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
    radial-gradient(120% 90% at 50% 0%, rgba(255, 214, 170, 0.28), transparent 55%),
    radial-gradient(90% 70% at 70% 100%, rgba(227, 6, 19, 0.22), transparent 50%),
    linear-gradient(165deg, #5a3426 0%, #2a1812 48%, #140e0b 100%);
}

.device-sil__plate {
  position: absolute;
  left: 18%;
  right: 18%;
  bottom: 10%;
  height: 14%;
  border-radius: 50%;
  background: radial-gradient(ellipse at center, rgba(0, 0, 0, 0.55), transparent 70%);
  filter: blur(2px);
}

.device-sil__glow {
  position: absolute;
  left: 22%;
  right: 22%;
  bottom: 12%;
  height: 18%;
  border-radius: 50%;
  border: 1px solid rgba(227, 6, 19, 0.55);
  box-shadow: 0 0 28px rgba(227, 6, 19, 0.35);
  transform: rotateX(68deg) scale(1.05);
  opacity: calc(0.45 + var(--lift) * 0.35);
}

.device-sil__model {
  position: relative;
  width: 58%;
  height: 68%;
  transform-style: preserve-3d;
  transform: rotateX(14deg) rotateY(-32deg);
  filter: brightness(calc(0.95 + var(--lift) * 0.25)) contrast(1.08);
}

.spin .device-sil__model {
  animation: silYaw 7s ease-in-out infinite;
}

@keyframes silYaw {
  0%, 100% { transform: rotateX(14deg) rotateY(-36deg) translateY(0); }
  50% { transform: rotateX(16deg) rotateY(28deg) translateY(-3%); }
}

.is-sm .device-sil__model { width: 64%; height: 72%; }
.is-md .device-sil__model { width: 58%; height: 68%; }
.is-lg .device-sil__model { width: 52%; height: 64%; }
.is-xl .device-sil__model {
  width: 46%;
  height: 62%;
  transform: rotateX(12deg) rotateY(-28deg) scale(1.15);
}

/* —— turbine —— */
.t-tower {
  position: absolute;
  left: 46%;
  bottom: 0;
  width: 10%;
  height: 78%;
  border-radius: 4px;
  background: linear-gradient(180deg, #f0ddd0, #7a4d38 40%, #3b241c);
  box-shadow: 3px 0 0 rgba(255, 230, 210, 0.15);
}
.t-nacelle {
  position: absolute;
  left: 38%;
  top: 10%;
  width: 34%;
  height: 12%;
  border-radius: 4px;
  background: linear-gradient(90deg, #fff1e4, #c9a88a);
}
.t-hub {
  position: absolute;
  left: 48%;
  top: 4%;
  width: 12%;
  aspect-ratio: 1;
  border-radius: 50%;
  background: var(--tone);
  box-shadow: 0 0 12px rgba(227, 6, 19, 0.55);
  animation: hubSpin 2.2s linear infinite;

  i {
    position: absolute;
    left: 42%;
    bottom: 50%;
    width: 16%;
    height: 220%;
    border-radius: 40% 40% 20% 20%;
    background: linear-gradient(180deg, #ffe7d6, var(--tone));
    transform-origin: 50% 100%;
  }
  i:nth-child(2) { transform: rotate(120deg); }
  i:nth-child(3) { transform: rotate(240deg); }
}
@keyframes hubSpin { to { transform: rotate(360deg); } }

/* —— transformer —— */
.x-tank {
  position: absolute;
  left: 18%;
  bottom: 8%;
  width: 64%;
  height: 52%;
  background: linear-gradient(145deg, #c9a88a, #5a3426 55%, #2a1812);
  box-shadow: inset 0 0 0 1px rgba(255, 235, 210, 0.2);
}
.x-fin {
  position: absolute;
  bottom: 12%;
  width: 6%;
  height: 44%;
  background: linear-gradient(180deg, #ffe8d4, #8a5a40);
}
.x-fin.a { left: 24%; }
.x-fin.b { left: 47%; }
.x-fin.c { left: 70%; }
.x-bush {
  position: absolute;
  left: 36%;
  bottom: 58%;
  width: 10%;
  height: 28%;
  border-radius: 4px 4px 0 0;
  background: linear-gradient(180deg, #fff0e0, var(--tone));
}
.x-bush.r { left: 54%; }

/* —— generator —— */
.g-skid {
  position: absolute;
  left: 10%;
  bottom: 6%;
  width: 80%;
  height: 10%;
  border-radius: 3px;
  background: #1a100c;
}
.g-body {
  position: absolute;
  left: 14%;
  bottom: 14%;
  width: 72%;
  height: 48%;
  border-radius: 40px;
  background: linear-gradient(180deg, #f2dfd0 0%, #8a5a40 45%, #3b241c 100%);
  box-shadow: inset 0 -8px 16px rgba(0, 0, 0, 0.25);
}
.g-cap {
  position: absolute;
  right: 10%;
  bottom: 22%;
  width: 16%;
  height: 34%;
  border-radius: 8px;
  background: linear-gradient(180deg, #ffb4aa, var(--tone));
}
.g-vent {
  position: absolute;
  left: 28%;
  top: 28%;
  width: 40%;
  height: 8%;
  background: repeating-linear-gradient(90deg, rgba(26, 16, 12, 0.35) 0 3px, transparent 3px 7px);
}

/* —— sensor —— */
.s-base {
  position: absolute;
  left: 22%;
  bottom: 4%;
  width: 56%;
  height: 14%;
  border-radius: 50%;
  background: linear-gradient(180deg, #8a5a40, #2a1812);
}
.s-mast {
  position: absolute;
  left: 46%;
  bottom: 14%;
  width: 8%;
  height: 58%;
  border-radius: 4px;
  background: linear-gradient(180deg, #ffe8d4, #7a4d38);
}
.s-head {
  position: absolute;
  left: 34%;
  top: 8%;
  width: 32%;
  aspect-ratio: 1;
  border-radius: 50%;
  background: radial-gradient(circle at 35% 30%, #ffe0d6, var(--tone));
  box-shadow: 0 0 22px rgba(227, 6, 19, 0.55);
  animation: headPulse 1.8s ease-in-out infinite;
}
.s-dish {
  position: absolute;
  left: 58%;
  top: 30%;
  width: 28%;
  height: 18%;
  border: 2px solid #ffe8d4;
  border-radius: 50%;
  transform: rotate(-28deg);
}
@keyframes headPulse {
  0%, 100% { filter: brightness(1); }
  50% { filter: brightness(1.35); }
}

/* —— breaker —— */
.b-cabinet {
  position: absolute;
  left: 24%;
  bottom: 6%;
  width: 52%;
  height: 78%;
  background: linear-gradient(180deg, #d7b59a, #4a2e24 60%, #1a100c);
  border: 1px solid rgba(255, 236, 214, 0.25);
}
.b-glass {
  position: absolute;
  left: 34%;
  top: 28%;
  width: 32%;
  height: 22%;
  background: linear-gradient(160deg, rgba(255, 220, 200, 0.55), var(--tone));
  box-shadow: 0 0 16px rgba(227, 6, 19, 0.4);
}
.b-handle {
  position: absolute;
  right: 30%;
  top: 58%;
  width: 8%;
  height: 16%;
  border-radius: 3px;
  background: #ffe8d4;
}

/* —— node —— */
.n-core {
  position: absolute;
  left: 28%;
  top: 22%;
  width: 44%;
  height: 44%;
  background: linear-gradient(145deg, #ffe8d4, #5a3426);
  clip-path: polygon(50% 0%, 100% 38%, 82% 100%, 18% 100%, 0% 38%);
}
.n-ring {
  position: absolute;
  left: 18%;
  top: 34%;
  width: 64%;
  height: 34%;
  border: 3px solid var(--tone);
  border-radius: 50%;
  transform: rotateX(62deg);
  animation: ringSpin 5s linear infinite;
}
.n-dot {
  position: absolute;
  left: 46%;
  top: 38%;
  width: 8%;
  aspect-ratio: 1;
  border-radius: 50%;
  background: #fff6ee;
  box-shadow: 0 0 12px var(--tone);
}
@keyframes ringSpin {
  to { transform: rotateX(62deg) rotateZ(360deg); }
}
</style>
