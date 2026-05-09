import { mapMutations } from 'vuex'

export default {
  created() {
    this.applyStoredDeviceToQuery()
  },
  methods: {
    ...mapMutations('dataAcquisition', ['SET_DEVICE_ID']),
    applyStoredDeviceToQuery() {
      if (!this.queryParams || !Object.prototype.hasOwnProperty.call(this.queryParams, 'deviceId')) {
        return
      }
      const id = this.$store.state.dataAcquisition.deviceId
      if (id) {
        this.queryParams.deviceId = id
      }
    },
    handleDataAcquisitionDeviceChange(val) {
      if (!this.queryParams || !Object.prototype.hasOwnProperty.call(this.queryParams, 'deviceId')) {
        return
      }
      this.queryParams.deviceId = val || null
      this.SET_DEVICE_ID(val || null)
      if (typeof this.handleQuery === 'function') {
        this.handleQuery()
      }
    },
    clearDataAcquisitionDeviceFilter() {
      if (this.queryParams && Object.prototype.hasOwnProperty.call(this.queryParams, 'deviceId')) {
        this.queryParams.deviceId = null
      }
      this.SET_DEVICE_ID(null)
    }
  }
}
