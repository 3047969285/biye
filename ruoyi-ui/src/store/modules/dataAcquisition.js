const STORAGE_KEY = 'eq-data-acquisition-device-id'

function readStoredId() {
  if (typeof sessionStorage === 'undefined') {
    return null
  }
  return sessionStorage.getItem(STORAGE_KEY)
}

export default {
  namespaced: true,
  state: {
    deviceId: readStoredId()
  },
  mutations: {
    SET_DEVICE_ID(state, deviceId) {
      const id = deviceId || null
      state.deviceId = id
      if (typeof sessionStorage === 'undefined') {
        return
      }
      if (id) {
        sessionStorage.setItem(STORAGE_KEY, id)
      } else {
        sessionStorage.removeItem(STORAGE_KEY)
      }
    }
  }
}
