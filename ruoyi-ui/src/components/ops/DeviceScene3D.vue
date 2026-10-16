<template>
  <div
    ref="host"
    class="device-scene-3d"
    :class="[`is-${variant}`, `kind-${meshKind}`, { 'is-interactive': interactive, 'has-webgl': webglOk }]"
    @pointerenter="onEnter"
    @pointerleave="onLeave"
  >
    <!-- CSS 立体构图：无 WebGL 时仍有完整设备造型；有 WebGL 时作为衬底 -->
    <div class="css-stage" aria-hidden="true">
      <div class="css-orbit" />
      <div class="css-model" :style="{ '--tone': tone }">
        <template v-if="meshKind === 'turbine'">
          <div class="turbine-tower" />
          <div class="turbine-nacelle" />
          <div class="turbine-rotor" :class="{ spin: autoRotate || hoverBoost }">
            <i /><i /><i />
          </div>
        </template>
        <template v-else-if="meshKind === 'transformer'">
          <div class="xfmr-body" />
          <div class="xfmr-fin f1" /><div class="xfmr-fin f2" /><div class="xfmr-fin f3" />
          <div class="xfmr-bushing" />
        </template>
        <template v-else-if="meshKind === 'generator'">
          <div class="gen-drum" />
          <div class="gen-end" />
          <div class="gen-base" />
        </template>
        <template v-else-if="meshKind === 'sensor'">
          <div class="sensor-base" />
          <div class="sensor-stem" />
          <div class="sensor-head pulse" />
        </template>
        <template v-else-if="meshKind === 'breaker'">
          <div class="brk-frame" />
          <div class="brk-window" />
        </template>
        <template v-else>
          <div class="node-core" />
          <div class="node-ring" />
        </template>
      </div>
      <div class="css-shadow" />
    </div>

    <canvas ref="canvas" class="device-scene-canvas" :class="{ visible: webglOk }" />
    <div v-if="showCaption" class="device-scene-caption">
      <span class="device-scene-name">{{ resolvedName }}</span>
      <span class="device-scene-status" :style="{ color: tone }">{{ statusText }}</span>
    </div>
  </div>
</template>

<script>
import * as THREE from 'three'
import { resolveMeshKind, statusTone, statusLabel } from '@/utils/ops/deviceCatalog'

/**
 * 单设备三维存在：优先 WebGL（Three.js），失败则 CSS 透视立体造型。
 * 造型随设备类型变化，色调绑定运行状态。
 */
export default {
  name: 'DeviceScene3D',
  props: {
    device: { type: Object, default: null },
    deviceName: { type: String, default: '' },
    deviceType: { type: String, default: '' },
    status: { type: [Number, String], default: 1 },
    variant: { type: String, default: 'card' },
    interactive: { type: Boolean, default: true },
    showCaption: { type: Boolean, default: false },
    autoRotate: { type: Boolean, default: true }
  },
  data() {
    return {
      hoverBoost: false,
      raf: 0,
      disposed: false,
      webglOk: false
    }
  },
  computed: {
    resolvedName() {
      return this.deviceName || (this.device && this.device.deviceName) || '设备'
    },
    resolvedType() {
      return this.deviceType || (this.device && this.device.deviceType) || ''
    },
    resolvedStatus() {
      return this.status != null ? this.status : (this.device && this.device.status) || 1
    },
    tone() {
      return statusTone(this.resolvedStatus)
    },
    statusText() {
      return (this.device && this.device.statusName) || statusLabel(this.resolvedStatus)
    },
    meshKind() {
      return resolveMeshKind(this.resolvedType, this.resolvedName)
    }
  },
  watch: {
    meshKind() {
      if (this.webglOk) this.rebuildMesh()
    },
    tone() {
      if (this.webglOk) this.applyTone()
    }
  },
  mounted() {
    this.initThree()
    window.addEventListener('resize', this.onResize)
  },
  beforeDestroy() {
    this.disposed = true
    window.removeEventListener('resize', this.onResize)
    if (this.raf) cancelAnimationFrame(this.raf)
    this.teardown()
  },
  methods: {
    onEnter() {
      if (this.interactive) this.hoverBoost = true
    },
    onLeave() {
      this.hoverBoost = false
    },
    initThree() {
      try {
        // 列表缩略图只用 CSS 立体，避免 WebGL 上下文耗尽；大图/焦点再用 Three.js
        if (this.variant === 'rail') return

        const canvas = this.$refs.canvas
        const host = this.$refs.host
        if (!canvas || !host) return

        const test = document.createElement('canvas')
        const probe = test.getContext('webgl', { failIfMajorPerformanceCaveat: false })
          || test.getContext('experimental-webgl', { failIfMajorPerformanceCaveat: false })
        if (!probe) return

        const w = Math.max(host.clientWidth, 40)
        const h = Math.max(host.clientHeight, 40)

        this.renderer = new THREE.WebGLRenderer({
          canvas,
          antialias: true,
          alpha: true,
          failIfMajorPerformanceCaveat: false,
          powerPreference: 'default'
        })
        this.renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2))
        this.renderer.setSize(w, h, false)
        if (THREE.SRGBColorSpace) this.renderer.outputColorSpace = THREE.SRGBColorSpace

        this.scene = new THREE.Scene()
        this.camera = new THREE.PerspectiveCamera(38, w / h, 0.1, 80)
        this.camera.position.set(2.4, 1.55, 3.4)
        this.camera.lookAt(0, 0.35, 0)

        this.scene.add(new THREE.HemisphereLight(0xffe8d6, 0x1a120e, 0.85))
        const key = new THREE.DirectionalLight(0xfff2e4, 1.15)
        key.position.set(4, 6, 2)
        this.scene.add(key)
        const rim = new THREE.DirectionalLight(0xff3b2f, 0.55)
        rim.position.set(-3, 2, -4)
        this.scene.add(rim)

        const floorMat = new THREE.MeshStandardMaterial({
          color: 0x2a1812,
          roughness: 0.92,
          metalness: 0.08,
          transparent: true,
          opacity: 0.55
        })
        this.floor = new THREE.Mesh(new THREE.CircleGeometry(2.4, 48), floorMat)
        this.floor.rotation.x = -Math.PI / 2
        this.scene.add(this.floor)

        this.ring = new THREE.Mesh(
          new THREE.TorusGeometry(1.35, 0.018, 12, 64),
          new THREE.MeshBasicMaterial({ color: 0xe30613, transparent: true, opacity: 0.35 })
        )
        this.ring.rotation.x = Math.PI / 2
        this.ring.position.y = 0.01
        this.scene.add(this.ring)

        this.root = new THREE.Group()
        this.scene.add(this.root)
        this.clock = new THREE.Clock()
        this.webglOk = true
        this.rebuildMesh()
        this.loop()
      } catch (e) {
        this.webglOk = false
        // CSS stage remains visible
      }
    },
    teardown() {
      if (this.root) {
        this.root.traverse((obj) => {
          if (obj.geometry) obj.geometry.dispose()
          if (obj.material) {
            if (Array.isArray(obj.material)) obj.material.forEach((m) => m.dispose())
            else obj.material.dispose()
          }
        })
      }
      if (this.renderer) this.renderer.dispose()
      this.renderer = null
      this.scene = null
    },
    clearRoot() {
      while (this.root && this.root.children.length) {
        const child = this.root.children[0]
        this.root.remove(child)
        child.traverse((obj) => {
          if (obj.geometry) obj.geometry.dispose()
          if (obj.material) {
            if (Array.isArray(obj.material)) obj.material.forEach((m) => m.dispose())
            else obj.material.dispose()
          }
        })
      }
    },
    mat(color, opts = {}) {
      return new THREE.MeshStandardMaterial({
        color,
        roughness: opts.roughness != null ? opts.roughness : 0.42,
        metalness: opts.metalness != null ? opts.metalness : 0.35,
        emissive: opts.emissive || 0x000000,
        emissiveIntensity: opts.emissiveIntensity || 0
      })
    },
    rebuildMesh() {
      if (!this.root) return
      this.clearRoot()
      const body = this.mat(0x3b241c, { metalness: 0.45, roughness: 0.38 })
      const accent = this.mat(0xe30613, {
        metalness: 0.2,
        roughness: 0.35,
        emissive: 0x5a0408,
        emissiveIntensity: 0.25
      })
      const pale = this.mat(0xd9c4a8, { metalness: 0.15, roughness: 0.55 })
      const group = new THREE.Group()
      this.rotor = null
      this.pulse = null

      switch (this.meshKind) {
        case 'turbine': {
          const tower = new THREE.Mesh(new THREE.CylinderGeometry(0.08, 0.14, 1.6, 16), body)
          tower.position.y = 0.8
          group.add(tower)
          const nacelle = new THREE.Mesh(new THREE.BoxGeometry(0.45, 0.18, 0.22), pale)
          nacelle.position.set(0.05, 1.62, 0)
          group.add(nacelle)
          this.rotor = new THREE.Group()
          this.rotor.position.set(0.28, 1.62, 0)
          for (let i = 0; i < 3; i++) {
            const blade = new THREE.Mesh(new THREE.BoxGeometry(0.08, 1.05, 0.04), accent)
            blade.position.y = 0.52
            const pivot = new THREE.Group()
            pivot.rotation.z = (i * Math.PI * 2) / 3
            pivot.add(blade)
            this.rotor.add(pivot)
          }
          group.add(this.rotor)
          break
        }
        case 'transformer': {
          const tank = new THREE.Mesh(new THREE.BoxGeometry(1.1, 0.85, 0.7), body)
          tank.position.y = 0.45
          group.add(tank)
          for (let i = -1; i <= 1; i++) {
            const fin = new THREE.Mesh(new THREE.BoxGeometry(0.06, 0.7, 0.55), pale)
            fin.position.set(i * 0.42, 0.45, 0)
            group.add(fin)
          }
          const bushing = new THREE.Mesh(new THREE.CylinderGeometry(0.06, 0.08, 0.35, 12), accent)
          bushing.position.set(0, 1.05, 0)
          group.add(bushing)
          break
        }
        case 'generator': {
          const drum = new THREE.Mesh(new THREE.CylinderGeometry(0.55, 0.55, 0.9, 28), body)
          drum.rotation.z = Math.PI / 2
          drum.position.set(0, 0.55, 0)
          group.add(drum)
          const end = new THREE.Mesh(new THREE.CylinderGeometry(0.35, 0.35, 0.18, 20), accent)
          end.rotation.z = Math.PI / 2
          end.position.set(0.55, 0.55, 0)
          group.add(end)
          break
        }
        case 'sensor': {
          const base = new THREE.Mesh(new THREE.CylinderGeometry(0.35, 0.42, 0.2, 20), body)
          base.position.y = 0.1
          group.add(base)
          const stem = new THREE.Mesh(new THREE.CylinderGeometry(0.06, 0.08, 0.9, 12), pale)
          stem.position.y = 0.65
          group.add(stem)
          const head = new THREE.Mesh(new THREE.SphereGeometry(0.22, 20, 16), accent)
          head.position.y = 1.15
          group.add(head)
          this.pulse = head
          break
        }
        case 'breaker': {
          const frame = new THREE.Mesh(new THREE.BoxGeometry(0.9, 1.1, 0.35), body)
          frame.position.y = 0.55
          group.add(frame)
          const windowPane = new THREE.Mesh(new THREE.BoxGeometry(0.45, 0.35, 0.06), accent)
          windowPane.position.set(0, 0.7, 0.2)
          group.add(windowPane)
          break
        }
        default: {
          const core = new THREE.Mesh(new THREE.IcosahedronGeometry(0.55, 0), body)
          core.position.y = 0.65
          group.add(core)
          const halo = new THREE.Mesh(new THREE.TorusGeometry(0.72, 0.04, 10, 40), accent)
          halo.rotation.x = Math.PI / 2.4
          halo.position.y = 0.65
          group.add(halo)
          this.rotor = halo
        }
      }

      this.root.add(group)
      this.applyTone()
    },
    applyTone() {
      if (!this.ring) return
      const c = new THREE.Color(this.tone)
      this.ring.material.color.copy(c)
      this.root.traverse((obj) => {
        if (obj.isMesh && obj.material && obj.material.emissive && obj.material.color) {
          const hex = obj.material.color.getHex()
          if (hex === 0xe30613 || obj.material.emissiveIntensity > 0) {
            obj.material.color.copy(c)
            obj.material.emissive = c.clone().multiplyScalar(0.25)
          }
        }
      })
    },
    onResize() {
      if (!this.webglOk || !this.renderer || !this.$refs.host) return
      const w = Math.max(this.$refs.host.clientWidth, 40)
      const h = Math.max(this.$refs.host.clientHeight, 40)
      this.camera.aspect = w / h
      this.camera.updateProjectionMatrix()
      this.renderer.setSize(w, h, false)
    },
    loop() {
      if (this.disposed || !this.webglOk) return
      const t = this.clock ? this.clock.getElapsedTime() : 0
      const boost = this.hoverBoost ? 1 : 0
      const spin = this.autoRotate ? 0.35 + boost * 0.55 : boost * 0.2
      if (this.root) {
        this.root.rotation.y = t * spin
        this.root.position.y = Math.sin(t * 1.2) * 0.04
      }
      if (this.rotor) {
        if (this.meshKind === 'turbine') this.rotor.rotation.x = t * (1.8 + boost)
        else this.rotor.rotation.z = t * 0.8
      }
      if (this.pulse && this.pulse.material) {
        this.pulse.material.emissiveIntensity = 0.35 + Math.sin(t * 3) * 0.25
      }
      if (this.ring) this.ring.scale.setScalar(1 + Math.sin(t * 1.5) * 0.03)
      if (this.renderer && this.scene && this.camera) {
        this.renderer.render(this.scene, this.camera)
      }
      this.raf = requestAnimationFrame(this.loop)
    }
  }
}
</script>

<style lang="scss" scoped>
.device-scene-3d {
  position: relative;
  width: 100%;
  height: 100%;
  min-height: 140px;
  overflow: hidden;
  border-radius: 2px;
  background:
    radial-gradient(120% 90% at 70% 10%, rgba(227, 6, 19, 0.22), transparent 55%),
    radial-gradient(80% 70% at 20% 90%, rgba(196, 163, 90, 0.14), transparent 50%),
    linear-gradient(165deg, #3a2018 0%, #120c0a 100%);
  perspective: 700px;
}

.device-scene-canvas {
  position: absolute;
  inset: 0;
  display: block;
  width: 100%;
  height: 100%;
  opacity: 0;
  pointer-events: none;
  z-index: 2;

  &.visible {
    opacity: 1;
  }
}

.has-webgl .css-stage {
  opacity: 0.18;
}

.css-stage {
  position: absolute;
  inset: 0;
  z-index: 1;
  display: grid;
  place-items: center;
  transform-style: preserve-3d;
}

.css-orbit {
  position: absolute;
  width: 68%;
  aspect-ratio: 1;
  border: 1px solid rgba(227, 6, 19, 0.35);
  border-radius: 50%;
  transform: rotateX(68deg) scale(1.05);
  animation: orbitPulse 3.8s ease-in-out infinite;
}

.css-shadow {
  position: absolute;
  bottom: 14%;
  width: 42%;
  height: 10px;
  border-radius: 50%;
  background: rgba(0, 0, 0, 0.45);
  filter: blur(6px);
}

.css-model {
  position: relative;
  width: 88px;
  height: 110px;
  transform-style: preserve-3d;
  transform: rotateX(12deg) rotateY(-28deg);
  animation: modelIdle 5.5s ease-in-out infinite;
}

.is-interactive:hover .css-model {
  animation-duration: 2.8s;
}

@keyframes modelIdle {
  0%, 100% { transform: rotateX(12deg) rotateY(-28deg) translateY(0); }
  50% { transform: rotateX(14deg) rotateY(18deg) translateY(-4px); }
}

@keyframes orbitPulse {
  0%, 100% { opacity: 0.35; transform: rotateX(68deg) scale(1); }
  50% { opacity: 0.7; transform: rotateX(68deg) scale(1.06); }
}

/* turbine */
.turbine-tower {
  position: absolute;
  left: 40px;
  bottom: 8px;
  width: 10px;
  height: 72px;
  background: linear-gradient(180deg, #d9c4a8, #3b241c);
  border-radius: 4px;
  transform: translateZ(0);
}
.turbine-nacelle {
  position: absolute;
  left: 34px;
  top: 18px;
  width: 28px;
  height: 12px;
  background: #e8d5bc;
  border-radius: 3px;
  transform: translateZ(8px);
}
.turbine-rotor {
  position: absolute;
  left: 44px;
  top: 8px;
  width: 8px;
  height: 8px;
  transform-style: preserve-3d;

  i {
    position: absolute;
    left: 3px;
    top: -34px;
    width: 3px;
    height: 38px;
    background: var(--tone, #e30613);
    border-radius: 2px;
    transform-origin: 50% 100%;
  }
  i:nth-child(2) { transform: rotate(120deg); }
  i:nth-child(3) { transform: rotate(240deg); }

  &.spin {
    animation: rotorSpin 1.6s linear infinite;
  }
}
@keyframes rotorSpin {
  to { transform: rotate(360deg); }
}

/* transformer */
.xfmr-body {
  position: absolute;
  left: 18px;
  bottom: 18px;
  width: 54px;
  height: 42px;
  background: linear-gradient(145deg, #4a2e24, #2a1812);
  box-shadow: 8px 0 0 #3b241c, -8px 0 0 #3b241c;
}
.xfmr-fin {
  position: absolute;
  bottom: 22px;
  width: 4px;
  height: 34px;
  background: #d9c4a8;
}
.xfmr-fin.f1 { left: 22px; }
.xfmr-fin.f2 { left: 42px; }
.xfmr-fin.f3 { left: 62px; }
.xfmr-bushing {
  position: absolute;
  left: 40px;
  bottom: 58px;
  width: 8px;
  height: 18px;
  background: var(--tone, #e30613);
  border-radius: 4px 4px 0 0;
}

/* generator */
.gen-base {
  position: absolute;
  left: 16px;
  bottom: 14px;
  width: 58px;
  height: 10px;
  background: #241510;
  border-radius: 3px;
}
.gen-drum {
  position: absolute;
  left: 20px;
  bottom: 22px;
  width: 50px;
  height: 34px;
  border-radius: 17px;
  background: linear-gradient(180deg, #5a3a2c, #2a1812 55%, #1a100c);
  box-shadow: inset 0 0 0 2px rgba(217, 196, 168, 0.2);
}
.gen-end {
  position: absolute;
  right: 14px;
  bottom: 28px;
  width: 12px;
  height: 22px;
  border-radius: 6px;
  background: var(--tone, #e30613);
}

/* sensor */
.sensor-base {
  position: absolute;
  left: 26px;
  bottom: 16px;
  width: 36px;
  height: 12px;
  border-radius: 50%;
  background: #3b241c;
}
.sensor-stem {
  position: absolute;
  left: 41px;
  bottom: 24px;
  width: 6px;
  height: 48px;
  background: #d9c4a8;
  border-radius: 3px;
}
.sensor-head {
  position: absolute;
  left: 32px;
  top: 18px;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background: radial-gradient(circle at 35% 30%, #ff6b5e, var(--tone, #e30613));
  box-shadow: 0 0 16px rgba(227, 6, 19, 0.45);

  &.pulse {
    animation: headPulse 1.8s ease-in-out infinite;
  }
}
@keyframes headPulse {
  0%, 100% { transform: scale(1); filter: brightness(1); }
  50% { transform: scale(1.08); filter: brightness(1.25); }
}

/* breaker */
.brk-frame {
  position: absolute;
  left: 24px;
  bottom: 16px;
  width: 42px;
  height: 70px;
  background: linear-gradient(180deg, #4a2e24, #1a100c);
  border: 1px solid rgba(217, 196, 168, 0.25);
}
.brk-window {
  position: absolute;
  left: 32px;
  top: 34px;
  width: 26px;
  height: 18px;
  background: var(--tone, #e30613);
  opacity: 0.9;
}

/* node */
.node-core {
  position: absolute;
  left: 26px;
  top: 28px;
  width: 36px;
  height: 36px;
  background: linear-gradient(145deg, #5a3a2c, #1a100c);
  clip-path: polygon(50% 0%, 100% 38%, 82% 100%, 18% 100%, 0% 38%);
}
.node-ring {
  position: absolute;
  left: 18px;
  top: 34px;
  width: 52px;
  height: 28px;
  border: 2px solid var(--tone, #e30613);
  border-radius: 50%;
  transform: rotateX(60deg);
  animation: ringSpin 4s linear infinite;
}
@keyframes ringSpin {
  to { transform: rotateX(60deg) rotateZ(360deg); }
}

.device-scene-caption {
  position: absolute;
  left: 12px;
  right: 12px;
  bottom: 10px;
  z-index: 3;
  display: flex;
  justify-content: space-between;
  gap: 8px;
  pointer-events: none;
  font-family: 'DM Sans', 'Noto Sans SC', sans-serif;
  font-size: 11px;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: rgba(247, 240, 230, 0.78);
}

.device-scene-name {
  font-weight: 600;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.is-hero {
  min-height: 320px;
  border-radius: 0;
}

.is-hero .css-model {
  width: 140px;
  height: 170px;
  transform: scale(1.35) rotateX(12deg) rotateY(-28deg);
}

.is-rail {
  min-height: 110px;
}

.is-rail .css-model {
  transform: scale(0.72) rotateX(12deg) rotateY(-28deg);
}

.is-interactive:hover {
  box-shadow: inset 0 0 0 1px rgba(227, 6, 19, 0.35);
}
</style>
