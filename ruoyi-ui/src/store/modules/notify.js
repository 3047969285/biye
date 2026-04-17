const state = {
  messages: [],
  hasNew: false
}

const mutations = {
  ADD_MESSAGE(state, msg) {
    state.messages.unshift(msg)
    state.hasNew = true
  },
  MARK_READ(state) {
    state.hasNew = false
  }
}

const actions = {
  addNotifyMessage({ commit }, msg) {
    commit('ADD_MESSAGE', msg)
  },
  markNotifyRead({ commit }) {
    commit('MARK_READ')
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}

