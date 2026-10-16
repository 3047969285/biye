<template>
  <div ref="host" class="device-fleet-scene">
    <canvas ref="canvas" class="fleet-canvas" :class="{ visible: webglOk }" />
    <div v-if="!webglOk" class="fleet-css-stage" aria-hidden="true">
      <div class="fleet-arc" />
      <div
        v-for="(device, i) in stageDevices"
        :key="'fleet-' + device.deviceId"
        class="fleet-slot"
        :class="{ active: String(device.deviceId) === String(activeId) }"
        :style="slotStyle(i, stageDevices.length)"
      >
        <DeviceScene3D :device="device" variant="rail" :interactive="false" />
      </div>
    </div>
  </div>
</template>

<script>
import * as THREE from 'three'
import DeviceScene3D from '@/components/ops/DeviceScene3D.vue'
import { resolveMeshKind, statusTone } from '@/utils/ops/deviceCatalog'

/**
 * 运维大屏中央舰队三维构图：WebGL 编队优先，失败时 CSS 弧形阵列。
 */
export default {
  name: 'DeviceFleetScene',
  components: { DeviceScene3D },
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
    stageDevices() {
      return (this.devices || []).slice(0, 8)
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
    slotStyle(i, n) {
      const t = n <= 1 ? 0.5 : i / (n - 1)
      const angle = -48 + t * 96
      const x = Math.sin((angle * Math.PI) / 180) * 38
      const y = Math.cos((angle * Math.PI) / 180) * 10 + 8
      const scale = 0.85 + (1 - Math.abs(t - 0.5) * 2) * 0.25
      return {
        transform: `translate(-50%, -50%) translate(${x}vw, ${y}vh) scale(${scale})`,
        zIndex: String(10 + Math.round(scale * 10))
      }
    },
    init() {
      try {
        const host = this.$refs.host
        const canvas = this.$refs.canvas
        const probe = document.createElement('canvas').getContext('webgl', { failIfMajorPerformanceCaveat: false })
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
        this.camera = new THREE.PerspectiveCamera(42, w / h, 0.1, 120)
        this.camera.position.set(0, 4.2, 9.5)
        this.camera.lookAt(0, 0.6, 0)

        this.scene.add(new THREE.HemisphereLight(0xffe6d2, 0x100c0a, 0.9))
        const key = new THREE.DirectionalLight(0xfff4ea, 1.2)
        key.position.set(5, 10, 4)
        this.scene.add(key)
        const fill = new THREE.DirectionalLight(0xe30613, 0.4)
        fill.position.set(-6, 3, -2)
        this.scene.add(fill)

        const plate = new THREE.Mesh(
          new THREE.CircleGeometry(7.5, 72),
          new THREE.MeshStandardMaterial({
            color: 0x1c110e,
            roughness: 0.95,
            metalness: 0.05,
            transparent: true,
            opacity: 0.72
          })
        )
        plate.rotation.x = -Math.PI / 2
        this.scene.add(plate)

        const arc = new THREE.Mesh(
          new THREE.TorusGeometry(5.2, 0.025, 10, 100, Math.PI * 1.2),
          new THREE.MeshBasicMaterial({ color: 0xe30613, transparent: true, opacity: 0.45 })
        )
        arc.rotation.x = Math.PI / 2
        arc.rotation.z = -Math.PI * 0.1
        arc.position.y = 0.02
        this.scene.add(arc)

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
    makeMini(kind, toneHex) {
      const g = new THREE.Group()
      const body = new THREE.MeshStandardMaterial({
        color: 0x3a241c,
        roughness: 0.4,
        metalness: 0.4
      })
      const accent = new THREE.MeshStandardMaterial({
        color: new THREE.Color(toneHex),
        roughness: 0.35,
        metalness: 0.25,
        emissive: new THREE.Color(toneHex),
        emissiveIntensity: 0.22
      })

      if (kind === 'turbine') {
        const tower = new THREE.Mesh(new THREE.CylinderGeometry(0.05, 0.09, 1.1, 10), body)
        tower.position.y = 0.55
        g.add(tower)
        const rotor = new THREE.Group()
        rotor.position.y = 1.1
        for (let i = 0; i < 3; i++) {
          const blade = new THREE.Mesh(new THREE.BoxGeometry(0.05, 0.7, 0.03), accent)
          blade.position.y = 0.35
          const p = new THREE.Group()
          p.rotation.z = (i * Math.PI * 2) / 3
          p.add(blade)
          rotor.add(p)
        }
        g.add(rotor)
        g.userData.rotor = rotor
      } else if (kind === 'transformer') {
        g.add(new THREE.Mesh(new THREE.BoxGeometry(0.7, 0.55, 0.45), body))
        const top = new THREE.Mesh(new THREE.CylinderGeometry(0.05, 0.06, 0.25, 8), accent)
        top.position.y = 0.4
        g.add(top)
      } else if (kind === 'sensor') {
        const stem = new THREE.Mesh(new THREE.CylinderGeometry(0.04, 0.05, 0.7, 8), body)
        stem.position.y = 0.35
        g.add(stem)
        const head = new THREE.Mesh(new THREE.SphereGeometry(0.16, 14, 12), accent)
        head.position.y = 0.75
        g.add(head)
      } else {
        const core = new THREE.Mesh(new THREE.IcosahedronGeometry(0.32, 0), body)
        core.position.y = 0.4
        g.add(core)
        const ring = new THREE.Mesh(new THREE.TorusGeometry(0.42, 0.03, 8, 28), accent)
        ring.rotation.x = Math.PI / 2.5
        ring.position.y = 0.4
        g.add(ring)
        g.userData.rotor = ring
      }

      const pedestal = new THREE.Mesh(
        new THREE.CylinderGeometry(0.35, 0.4, 0.06, 20),
        new THREE.MeshStandardMaterial({ color: 0x241510, roughness: 0.9 })
      )
      pedestal.position.y = 0.03
      g.add(pedestal)
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
      const list = (this.devices || []).slice(0, 12)
      const n = Math.max(list.length, 1)
      list.forEach((device, i) => {
        const kind = resolveMeshKind(device.deviceType, device.deviceName)
        const tone = statusTone(device.status)
        const node = this.makeMini(kind, tone)
        const t = n === 1 ? 0.5 : i / (n - 1)
        const angle = -Math.PI * 0.55 + t * Math.PI * 1.1
        const radius = 4.2
        node.position.set(Math.sin(angle) * radius, 0, Math.cos(angle) * radius * 0.72 - 0.8)
        node.rotation.y = -angle
        node.userData.deviceId = device.deviceId
        node.userData.baseScale = 1
        this.fleet.add(node)
        this.nodes.push(node)
      })
      this.highlightActive()
    },
    highlightActive() {
      this.nodes.forEach((node) => {
        const active = this.activeId != null && String(node.userData.deviceId) === String(this.activeId)
        node.userData.baseScale = active ? 1.28 : 1
      })
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
        const target = node.userData.baseScale || 1
        node.scale.setScalar(THREE.MathUtils.lerp(node.scale.x, target, 0.08))
        node.position.y = Math.sin(t * 1.3 + i) * 0.06
        if (node.userData.rotor) {
          node.userData.rotor.rotation.x = t * (1.4 + i * 0.05)
        }
      })
      if (this.fleet) this.fleet.rotation.y = Math.sin(t * 0.15) * 0.08
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
  display: block;
  width: 100%;
  height: 100%;
  opacity: 0;

  &.visible {
    opacity: 1;
  }
}

.fleet-css-stage {
  position: absolute;
  inset: 0;
}

.fleet-arc {
  position: absolute;
  left: 50%;
  top: 52%;
  width: 72vw;
  height: 28vh;
  transform: translate(-50%, -50%);
  border: 1px solid rgba(227, 6, 19, 0.28);
  border-radius: 50%;
  box-shadow: 0 0 80px rgba(227, 6, 19, 0.12);
  animation: arcBreath 6s ease-in-out infinite;
}

@keyframes arcBreath {
  0%, 100% { opacity: 0.45; }
  50% { opacity: 0.85; }
}

.fleet-slot {
  position: absolute;
  left: 50%;
  top: 48%;
  width: min(160px, 14vw);
  height: min(140px, 16vh);
  transition: transform 0.45s cubic-bezier(0.22, 1, 0.36, 1), filter 0.35s ease;
  filter: saturate(0.9) brightness(0.92);

  &.active {
    filter: saturate(1.15) brightness(1.08);
  }
}
</style>
