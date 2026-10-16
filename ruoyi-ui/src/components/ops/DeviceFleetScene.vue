<template>
  <div ref="host" class="device-fleet-scene">
    <canvas ref="canvas" class="fleet-canvas" :class="{ visible: webglOk }" />

    <!-- 主导构图：中央巨型焦点 + 环绕卫星（CSS，保证无 WebGL 也饱满） -->
    <div class="fleet-stage" aria-hidden="true">
      <div class="fleet-stage__wash" />
      <div class="fleet-stage__floor" />
      <div class="fleet-stage__rim" />

      <div class="fleet-hero" :key="'hero-' + (activeDevice && activeDevice.deviceId)">
        <DeviceScene3D
          v-if="activeDevice"
          :device="activeDevice"
          variant="stage"
          :show-caption="false"
          :interactive="false"
        />
      </div>

      <div
        v-for="(device, i) in satellites"
        :key="'sat-' + device.deviceId"
        class="fleet-sat"
        :class="{ active: String(device.deviceId) === String(activeId) }"
        :style="satStyle(i, satellites.length)"
      >
        <DeviceSilhouette :device="device" size="md" />
      </div>
    </div>
  </div>
</template>

<script>
import * as THREE from 'three'
import DeviceScene3D from '@/components/ops/DeviceScene3D.vue'
import DeviceSilhouette from '@/components/ops/DeviceSilhouette.vue'
import { resolveMeshKind, statusTone } from '@/utils/ops/deviceCatalog'

/**
 * 大屏中央舰队：焦点设备占满构图中心，其余沿椭圆环绕。
 */
export default {
  name: 'DeviceFleetScene',
  components: { DeviceScene3D, DeviceSilhouette },
  props: {
    devices: { type: Array, default: () => [] },
    activeId: { type: [String, Number], default: null }
  },
  data() {
    return {
      raf: 0,
      disposed: false,
      nodes: [],
      webglOk: false
    }
  },
  computed: {
    activeDevice() {
      return (
        this.devices.find((d) => String(d.deviceId) === String(this.activeId)) ||
        this.devices[0] ||
        null
      )
    },
    satellites() {
      return (this.devices || [])
        .filter((d) => String(d.deviceId) !== String(this.activeId))
        .slice(0, 7)
    }
  },
  watch: {
    devices: {
      deep: true,
      handler() {
        if (this.webglOk) this.rebuildFleet()
      }
    },
    activeId() {
      if (this.webglOk) this.highlightActive()
    }
  },
  mounted() {
    this.init()
    window.addEventListener('resize', this.onResize)
  },
  beforeDestroy() {
    this.disposed = true
    window.removeEventListener('resize', this.onResize)
    if (this.raf) cancelAnimationFrame(this.raf)
    this.disposeScene()
  },
  methods: {
    satStyle(i, n) {
      const t = n <= 1 ? 0.5 : i / Math.max(n - 1, 1)
      const angle = -70 + t * 140
      const rad = (angle * Math.PI) / 180
      const x = Math.sin(rad) * 34
      const y = Math.cos(rad) * 10 + 18
      const depth = 0.72 + (1 - Math.abs(t - 0.5) * 2) * 0.35
      return {
        transform: `translate(-50%, -50%) translate(${x}vw, ${y}vh) scale(${depth})`,
        zIndex: String(8 + Math.round(depth * 10)),
        opacity: 0.55 + depth * 0.35
      }
    },
    init() {
      // CSS 舞台始终主导；WebGL 仅在显式开启时增强（避免半残上下文压暗构图）
      const wantWebgl =
        typeof window !== 'undefined' && /[?&]webgl=1\b/.test(window.location.search || '')
      if (!wantWebgl) return
      try {
        const host = this.$refs.host
        const canvas = this.$refs.canvas
        const probe = document.createElement('canvas').getContext('webgl', {
          failIfMajorPerformanceCaveat: false
        })
        if (!probe || !host || !canvas) return

        const w = Math.max(host.clientWidth, 60)
        const h = Math.max(host.clientHeight, 60)
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
        this.camera = new THREE.PerspectiveCamera(40, w / h, 0.1, 120)
        this.camera.position.set(0, 3.2, 8.2)
        this.camera.lookAt(0, 0.9, 0)

        this.scene.add(new THREE.HemisphereLight(0xfff0e0, 0x1a100c, 1))
        const key = new THREE.DirectionalLight(0xfff6ea, 1.35)
        key.position.set(4, 9, 4)
        this.scene.add(key)
        const fill = new THREE.DirectionalLight(0xe30613, 0.45)
        fill.position.set(-5, 3, -2)
        this.scene.add(fill)

        const plate = new THREE.Mesh(
          new THREE.CircleGeometry(6.5, 72),
          new THREE.MeshStandardMaterial({
            color: 0x241510,
            roughness: 0.92,
            metalness: 0.08,
            transparent: true,
            opacity: 0.55
          })
        )
        plate.rotation.x = -Math.PI / 2
        this.scene.add(plate)

        this.fleet = new THREE.Group()
        this.scene.add(this.fleet)
        this.clock = new THREE.Clock()
        this.webglOk = true
        this.rebuildFleet()
        this.loop()
      } catch (e) {
        this.webglOk = false
      }
    },
    disposeScene() {
      if (this.fleet) {
        this.fleet.traverse((o) => {
          if (o.geometry) o.geometry.dispose()
          if (o.material) {
            if (Array.isArray(o.material)) o.material.forEach((m) => m.dispose())
            else o.material.dispose()
          }
        })
      }
      if (this.renderer) this.renderer.dispose()
    },
    makeMini(kind, toneHex, scale) {
      const g = new THREE.Group()
      g.scale.setScalar(scale || 1)
      const body = new THREE.MeshStandardMaterial({ color: 0x6b4332, roughness: 0.38, metalness: 0.35 })
      const accent = new THREE.MeshStandardMaterial({
        color: new THREE.Color(toneHex),
        roughness: 0.32,
        metalness: 0.22,
        emissive: new THREE.Color(toneHex),
        emissiveIntensity: 0.28
      })
      if (kind === 'turbine') {
        const tower = new THREE.Mesh(new THREE.CylinderGeometry(0.06, 0.11, 1.35, 12), body)
        tower.position.y = 0.68
        g.add(tower)
        const rotor = new THREE.Group()
        rotor.position.y = 1.35
        for (let i = 0; i < 3; i++) {
          const blade = new THREE.Mesh(new THREE.BoxGeometry(0.06, 0.85, 0.035), accent)
          blade.position.y = 0.42
          const p = new THREE.Group()
          p.rotation.z = (i * Math.PI * 2) / 3
          p.add(blade)
          rotor.add(p)
        }
        g.add(rotor)
        g.userData.rotor = rotor
      } else if (kind === 'transformer') {
        g.add(new THREE.Mesh(new THREE.BoxGeometry(0.85, 0.65, 0.55), body))
        const top = new THREE.Mesh(new THREE.CylinderGeometry(0.06, 0.07, 0.3, 8), accent)
        top.position.y = 0.48
        g.add(top)
      } else if (kind === 'sensor') {
        const stem = new THREE.Mesh(new THREE.CylinderGeometry(0.05, 0.06, 0.85, 8), body)
        stem.position.y = 0.42
        g.add(stem)
        const head = new THREE.Mesh(new THREE.SphereGeometry(0.2, 14, 12), accent)
        head.position.y = 0.9
        g.add(head)
      } else {
        const core = new THREE.Mesh(new THREE.IcosahedronGeometry(0.4, 0), body)
        core.position.y = 0.48
        g.add(core)
        const ring = new THREE.Mesh(new THREE.TorusGeometry(0.52, 0.035, 8, 28), accent)
        ring.rotation.x = Math.PI / 2.5
        ring.position.y = 0.48
        g.add(ring)
        g.userData.rotor = ring
      }
      return g
    },
    rebuildFleet() {
      if (!this.fleet) return
      while (this.fleet.children.length) {
        const c = this.fleet.children[0]
        this.fleet.remove(c)
        c.traverse((o) => {
          if (o.geometry) o.geometry.dispose()
          if (o.material) {
            if (Array.isArray(o.material)) o.material.forEach((m) => m.dispose())
            else o.material.dispose()
          }
        })
      }
      this.nodes = []
      const list = (this.devices || []).slice(0, 10)
      list.forEach((device, i) => {
        const kind = resolveMeshKind(device.deviceType, device.deviceName)
        const tone = statusTone(device.status)
        const isActive = String(device.deviceId) === String(this.activeId)
        const node = this.makeMini(kind, tone, isActive ? 1.8 : 0.85)
        if (isActive) {
          node.position.set(0, 0.2, 0.6)
        } else {
          const others = list.filter((d) => String(d.deviceId) !== String(this.activeId))
          const idx = others.findIndex((d) => String(d.deviceId) === String(device.deviceId))
          const n = Math.max(others.length, 1)
          const t = n === 1 ? 0.5 : idx / (n - 1)
          const angle = -Math.PI * 0.55 + t * Math.PI * 1.1
          node.position.set(Math.sin(angle) * 4.4, 0, Math.cos(angle) * 3.1 - 0.4)
          node.rotation.y = -angle
        }
        node.userData.deviceId = device.deviceId
        node.userData.baseScale = isActive ? 1.8 : 0.85
        this.fleet.add(node)
        this.nodes.push(node)
      })
    },
    highlightActive() {
      this.rebuildFleet()
    },
    onResize() {
      if (!this.webglOk || !this.renderer || !this.$refs.host) return
      const w = Math.max(this.$refs.host.clientWidth, 60)
      const h = Math.max(this.$refs.host.clientHeight, 60)
      this.camera.aspect = w / h
      this.camera.updateProjectionMatrix()
      this.renderer.setSize(w, h, false)
    },
    loop() {
      if (this.disposed || !this.webglOk) return
      const t = this.clock.getElapsedTime()
      this.nodes.forEach((node, i) => {
        node.position.y = (node.userData.baseScale > 1 ? 0.25 : 0) + Math.sin(t * 1.2 + i) * 0.05
        if (node.userData.rotor) node.userData.rotor.rotation.x = t * (1.5 + i * 0.04)
      })
      this.renderer.render(this.scene, this.camera)
      this.raf = requestAnimationFrame(this.loop)
    }
  }
}
</script>

<style lang="scss" scoped>
.device-fleet-scene {
  position: absolute;
  inset: 0;
  z-index: 1;
  pointer-events: none;
  overflow: hidden;
}

.fleet-canvas {
  position: absolute;
  inset: 0;
  display: block;
  width: 100%;
  height: 100%;
  opacity: 0;
  z-index: 2;

  &.visible {
    opacity: 0.42;
  }
}

.fleet-stage {
  position: absolute;
  inset: 0;
  z-index: 1;
}

.fleet-stage__wash {
  position: absolute;
  inset: 8% 12% 18%;
  background:
    radial-gradient(55% 50% at 50% 42%, rgba(255, 196, 150, 0.18), transparent 70%),
    radial-gradient(40% 35% at 50% 70%, rgba(227, 6, 19, 0.2), transparent 70%);
  filter: blur(2px);
  animation: stageBreath 8s ease-in-out infinite;
}

.fleet-stage__floor {
  position: absolute;
  left: 18%;
  right: 18%;
  top: 58%;
  height: 28%;
  border-radius: 50%;
  background:
    radial-gradient(ellipse at center, rgba(90, 52, 38, 0.55), transparent 68%);
  transform: rotateX(66deg) scale(1.15);
}

.fleet-stage__rim {
  position: absolute;
  left: 22%;
  right: 22%;
  top: 56%;
  height: 26%;
  border-radius: 50%;
  border: 1px solid rgba(227, 6, 19, 0.38);
  box-shadow: 0 0 60px rgba(227, 6, 19, 0.16);
  transform: rotateX(66deg) scale(1.05);
}

.fleet-hero {
  position: absolute;
  left: 50%;
  top: 42%;
  width: min(68vw, 860px);
  height: min(68vh, 640px);
  transform: translate(-50%, -50%);
  z-index: 20;
  border-radius: 2px;
  overflow: hidden;
  box-shadow:
    0 40px 100px rgba(0, 0, 0, 0.55),
    0 0 0 1px rgba(255, 220, 190, 0.18),
    0 0 100px rgba(227, 6, 19, 0.16);
  animation: heroRise 1s cubic-bezier(0.22, 1, 0.36, 1) both;
}

.fleet-sat {
  position: absolute;
  left: 50%;
  top: 50%;
  width: min(190px, 14.5vw);
  height: min(168px, 16.5vh);
  border-radius: 3px;
  overflow: hidden;
  box-shadow: 0 14px 36px rgba(0, 0, 0, 0.35);
  transition: transform 0.5s cubic-bezier(0.22, 1, 0.36, 1), opacity 0.35s ease, filter 0.35s ease;
  filter: saturate(0.95);

  &.active {
    filter: saturate(1.2) brightness(1.08);
  }
}

@keyframes stageBreath {
  0%, 100% { opacity: 0.75; }
  50% { opacity: 1; }
}

@keyframes heroRise {
  from { opacity: 0; transform: translate(-50%, -46%) scale(0.94); }
  to { opacity: 1; transform: translate(-50%, -50%) scale(1); }
}

@media (max-width: 900px) {
  .fleet-hero {
    width: min(78vw, 520px);
    height: min(42vh, 360px);
    top: 42%;
  }
  .fleet-sat {
    display: none;
  }
}
</style>
