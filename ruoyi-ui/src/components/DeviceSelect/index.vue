<template>
  <el-select
    :value="value"
    size="small"
    filterable
    clearable
    :disabled="disabled"
    :placeholder="placeholder"
    style="width: 100%"
    @input="$emit('input', $event)"
    @change="$emit('change', $event)"
  >
    <el-option
      v-for="d in devices"
      :key="d.deviceId"
      :label="formatLabel(d)"
      :value="d.deviceId"
    />
  </el-select>
</template>

<script>
import { listDevice } from '@/api/equipment/device'

export default {
  name: 'DeviceSelect',
  props: {
    value: {
      type: String,
      default: null
    },
    disabled: {
      type: Boolean,
      default: false
    },
    placeholder: {
      type: String,
      default: '请选择设备'
    }
  },
  data() {
    return {
      devices: []
    }
  },
  created() {
    this.loadDevices()
  },
  methods: {
    formatLabel(d) {
      const name = d.deviceName || '未命名设备'
      const no = d.deviceNo || '—'
      return `${name}（${no}）`
    },
    loadDevices() {
      listDevice({ pageNum: 1, pageSize: 999 }).then(res => {
        const rows = res.rows || []
        this.devices = rows.slice().sort((a, b) => {
          const ta = a.createTime ? new Date(a.createTime).getTime() : 0
          const tb = b.createTime ? new Date(b.createTime).getTime() : 0
          return tb - ta
        })
      }).catch(() => {
        this.devices = []
      })
    }
  }
}
</script>
