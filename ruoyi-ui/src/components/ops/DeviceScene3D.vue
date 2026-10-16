<template>
  <div
    ref="host"
    class="device-scene-3d"
    :class="[`is-${variant}`, { 'is-interactive': interactive, 'has-webgl': webglOk }]"
    @pointerenter="hoverBoost = interactive"
    @pointerleave="hoverBoost = false"
  >
    <DeviceSilhouette
      class="device-scene-sil"
      :device="boundDevice"
      :size="silSize"
      :spinning="autoRotate || hoverBoost"
    />
    <canvas ref="canvas" class="device-scene-canvas" :class="{ visible: webglOk }" />
    <div v-if="showCaption" class="device-scene-caption">
      <span class="device-scene-name">{{ resolvedName }}</span>
      <span class="device-scene-status" :style="{ color: tone }">{{ statusText }}</span>
    </div>
  </div>
</template>

<script>
import * as THREE from 'three'
import DeviceSilhouette from '@/components/ops/DeviceSilhouette.vue'
import { resolveMeshKind, statusTone, statusLabel } from '@/utils/ops/deviceCatalog'

/**
 * 设备三维存在：始终渲染高对比 CSS 立体；hero/card 在可用时叠加 Three.js。
 */
export default {
  name: 'DeviceScene3D',
  components: { DeviceSilhouette },
  props: {
    device: { type: Object, default: null },
    deviceName: { type: String, default: '' },
    deviceType: { type: String, default: '' },
    status: { type: [Number, String], default: 1 },
    variant: { type: String, default: 'card' },
    interactive: { type: Boolean, default: true },
    showCaption: { type: Boolean, default: false },
    autoRotate: { type: Boolean, default: true },
    enableWebgl: { type: Boolean, default: false }
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
    boundDevice() {
      return {
        ...(this.device || {}),
        deviceName: this.resolvedName,
        deviceType: this.resolvedType,
        status: this.resolvedStatus
      }
    },
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
    },
    silSize() {
      if (this.variant === 'hero' || this.variant === 'stage') return 'xl'
      if (this.variant === 'rail') return 'sm'
      return 'md'
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
    initThree() {
      // 默认以 CSS 立体为主构图（VM/无 GPU 时 Three 易出黑块并把剪影压暗）。
      // 需要 WebGL 增强时：URL 加 ?webgl=1 或父级传入 enable-webgl。
      const wantWebgl =
        this.enableWebgl === true ||
        (typeof window !== 'undefined' && /[?&]webgl=1\b/.test(window.location.search || ''))
      if (!wantWebgl || this.variant === 'rail') return
      try {
        const canvas = this.$refs.canvas
        const host = this.$refs.host
        if (!canvas || !host) return
        const probe = document.createElement('canvas').getContext('webgl', { failIfMajorPerformanceCaveat: false })
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
        this.camera = new THREE.PerspectiveCamera(36, w / h, 0.1, 80)
        this.camera.position.set(2.6, 1.8, 3.8)
        this.camera.lookAt(0, 0.55, 0)

        this.scene.add(new THREE.HemisphereLight(0xfff0e0, 0x2a1812, 1.1))
        const key = new THREE.DirectionalLight(0xfff6ea, 1.45)
        key.position.set(4, 7, 3)
        this.scene.add(key)
        const rim = new THREE.DirectionalLight(0xff4a3a, 0.7)
        rim.position.set(-4, 2, -3)
        this.scene.add(rim)
        const fill = new THREE.PointLight(0xffc9a0, 0.55, 12)
        fill.position.set(0, 2.2, 2)
        this.scene.add(fill)

        this.floor = new THREE.Mesh(
          new THREE.CircleGeometry(2.8, 56),
          new THREE.MeshStandardMaterial({
            color: 0x3a241c,
            roughness: 0.85,
            metalness: 0.12,
            transparent: true,
            opacity: 0.65
          })
        )
        this.floor.rotation.x = -Math.PI / 2
        this.scene.add(this.floor)

        this.ring = new THREE.Mesh(
          new THREE.TorusGeometry(1.5, 0.025, 12, 72),
          new THREE.MeshBasicMaterial({ color: 0xe30613, transparent: true, opacity: 0.5 })
        )
        this.ring.rotation.x = Math.PI / 2
        this.ring.position.y = 0.02
        this.scene.add(this.ring)

        this.root = new THREE.Group()
        this.scene.add(this.root)
        this.clock = new THREE.Clock()
        this.webglOk = true
        this.rebuildMesh()
        this.loop()
      } catch (e) {
        this.webglOk = false
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
        roughness: opts.roughness != null ? opts.roughness : 0.38,
        metalness: opts.metalness != null ? opts.metalness : 0.32,
        emissive: opts.emissive || 0x000000,
        emissiveIntensity: opts.emissiveIntensity || 0
      })
    },
    rebuildMesh() {
      if (!this.root) return
      this.clearRoot()
      const body = this.mat(0x6b4332, { metalness: 0.4, roughness: 0.35 })
      const accent = this.mat(0xe30613, {
        metalness: 0.18,
        roughness: 0.32,
        emissive: 0x7a0810,
        emissiveIntensity: 0.35
      })
      const pale = this.mat(0xf0ddd0, { metalness: 0.12, roughness: 0.5 })
      const group = new THREE.Group()
      this.rotor = null
      this.pulse = null

      switch (this.meshKind) {
        case 'turbine': {
          const tower = new THREE.Mesh(new THREE.CylinderGeometry(0.1, 0.16, 1.85, 18), body)
          tower.position.y = 0.92
          group.add(tower)
          const nacelle = new THREE.Mesh(new THREE.BoxGeometry(0.55, 0.2, 0.26), pale)
          nacelle.position.set(0.06, 1.86, 0)
          group.add(nacelle)
          this.rotor = new THREE.Group()
          this.rotor.position.set(0.34, 1.86, 0)
          for (let i = 0; i < 3; i++) {
            const blade = new THREE.Mesh(new THREE.BoxGeometry(0.09, 1.2, 0.045), accent)
            blade.position.y = 0.58
            const pivot = new THREE.Group()
            pivot.rotation.z = (i * Math.PI * 2) / 3
            pivot.add(blade)
            this.rotor.add(pivot)
          }
          group.add(this.rotor)
          break
        }
        case 'transformer': {
          const tank = new THREE.Mesh(new THREE.BoxGeometry(1.25, 0.95, 0.78), body)
          tank.position.y = 0.5
          group.add(tank)
          for (let i = -1; i <= 1; i++) {
            const fin = new THREE.Mesh(new THREE.BoxGeometry(0.07, 0.8, 0.6), pale)
            fin.position.set(i * 0.48, 0.5, 0)
            group.add(fin)
          }
          const bushing = new THREE.Mesh(new THREE.CylinderGeometry(0.07, 0.09, 0.42, 12), accent)
          bushing.position.set(-0.18, 1.2, 0)
          group.add(bushing)
          const bushing2 = bushing.clone()
          bushing2.position.x = 0.18
          group.add(bushing2)
          break
        }
        case 'generator': {
          const drum = new THREE.Mesh(new THREE.CylinderGeometry(0.62, 0.62, 1.05, 32), body)
          drum.rotation.z = Math.PI / 2
          drum.position.set(0, 0.62, 0)
          group.add(drum)
          const end = new THREE.Mesh(new THREE.CylinderGeometry(0.4, 0.4, 0.22, 22), accent)
          end.rotation.z = Math.PI / 2
          end.position.set(0.62, 0.62, 0)
          group.add(end)
          break
        }
        case 'sensor': {
          const base = new THREE.Mesh(new THREE.CylinderGeometry(0.4, 0.48, 0.22, 22), body)
          base.position.y = 0.11
          group.add(base)
          const stem = new THREE.Mesh(new THREE.CylinderGeometry(0.07, 0.09, 1.05, 12), pale)
          stem.position.y = 0.72
          group.add(stem)
          const head = new THREE.Mesh(new THREE.SphereGeometry(0.26, 22, 18), accent)
          head.position.y = 1.3
          group.add(head)
          this.pulse = head
          break
        }
        case 'breaker': {
          const frame = new THREE.Mesh(new THREE.BoxGeometry(1, 1.25, 0.4), body)
          frame.position.y = 0.62
          group.add(frame)
          const windowPane = new THREE.Mesh(new THREE.BoxGeometry(0.5, 0.4, 0.07), accent)
          windowPane.position.set(0, 0.78, 0.22)
          group.add(windowPane)
          break
        }
        default: {
          const core = new THREE.Mesh(new THREE.IcosahedronGeometry(0.62, 0), body)
          core.position.y = 0.72
          group.add(core)
          const halo = new THREE.Mesh(new THREE.TorusGeometry(0.82, 0.045, 10, 44), accent)
          halo.rotation.x = Math.PI / 2.4
          halo.position.y = 0.72
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
          if (obj.material.emissiveIntensity > 0 || obj.material.color.getHex() === 0xe30613) {
            obj.material.color.copy(c)
            obj.material.emissive = c.clone().multiplyScalar(0.28)
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
      const t = this.clock.getElapsedTime()
      const boost = this.hoverBoost ? 1 : 0
      const spin = this.autoRotate ? 0.32 + boost * 0.5 : boost * 0.2
      if (this.root) {
        this.root.rotation.y = t * spin
        this.root.position.y = Math.sin(t * 1.15) * 0.05
      }
      if (this.rotor) {
        if (this.meshKind === 'turbine') this.rotor.rotation.x = t * (1.9 + boost)
        else this.rotor.rotation.z = t * 0.85
      }
      if (this.pulse && this.pulse.material) {
        this.pulse.material.emissiveIntensity = 0.4 + Math.sin(t * 3) * 0.28
      }
      if (this.ring) this.ring.scale.setScalar(1 + Math.sin(t * 1.4) * 0.04)
      this.renderer.render(this.scene, this.camera)
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
}

.device-scene-sil {
  position: absolute;
  inset: 0;
  z-index: 1;
}

.device-scene-canvas {
  position: absolute;
  inset: 0;
  z-index: 2;
  display: block;
  width: 100%;
  height: 100%;
  opacity: 0;
  pointer-events: none;

  &.visible {
    opacity: 1;
  }
}

.has-webgl .device-scene-sil {
  /* WebGL 仅作轻量叠层，剪影始终保持可读 */
  opacity: 0.55;
}

.device-scene-caption {
  position: absolute;
  left: 14px;
  right: 14px;
  bottom: 12px;
  z-index: 3;
  display: flex;
  justify-content: space-between;
  gap: 8px;
  pointer-events: none;
  font-family: 'DM Sans', 'Noto Sans SC', sans-serif;
  font-size: 11px;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: rgba(255, 246, 236, 0.88);
  text-shadow: 0 1px 8px rgba(0, 0, 0, 0.45);
}

.device-scene-name {
  font-weight: 600;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.is-hero,
.is-stage {
  min-height: 320px;
  border-radius: 0;
}

.is-rail {
  min-height: 88px;
}

.is-interactive:hover {
  box-shadow: inset 0 0 0 1px rgba(255, 214, 180, 0.28);
}
</style>
