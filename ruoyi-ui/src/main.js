import Vue from 'vue'

import Cookies from 'js-cookie'

import Element from 'element-ui'
import './assets/styles/element-variables.scss'

import '@/assets/styles/index.scss' // global css
import '@/assets/styles/ruoyi.scss' // ruoyi css
import App from './App'
import store from './store'
import router from './router'
import directive from './directive' // directive
import plugins from './plugins' // plugins
import { download } from '@/utils/request'
import defaultSettings from '@/settings'

import './assets/icons' // icon
import './permission' // permission control
import { getDicts } from "@/api/system/dict/data"
import { getConfigKey } from "@/api/system/config"
import { parseTime, resetForm, addDateRange, selectDictLabel, selectDictLabels, handleTree } from "@/utils/ruoyi"
import wsClient from '@/utils/websocket'
// 分页组件
import Pagination from "@/components/Pagination"
// 自定义表格工具组件
import RightToolbar from "@/components/RightToolbar"
// 富文本组件
import Editor from "@/components/Editor"
// 文件上传组件
import FileUpload from "@/components/FileUpload"
// 图片上传组件
import ImageUpload from "@/components/ImageUpload"
// 图片预览组件
import ImagePreview from "@/components/ImagePreview"
import DeviceSelect from '@/components/DeviceSelect'
// 字典标签组件
import DictTag from '@/components/DictTag'
// 字典数据组件
import DictData from '@/components/DictData'

// 全局方法挂载
Vue.prototype.getDicts = getDicts
Vue.prototype.getConfigKey = getConfigKey
Vue.prototype.parseTime = parseTime
Vue.prototype.resetForm = resetForm
Vue.prototype.addDateRange = addDateRange
Vue.prototype.selectDictLabel = selectDictLabel
Vue.prototype.selectDictLabels = selectDictLabels
Vue.prototype.download = download
Vue.prototype.handleTree = handleTree

// 全局组件挂载
Vue.component('DictTag', DictTag)
Vue.component('Pagination', Pagination)
Vue.component('RightToolbar', RightToolbar)
Vue.component('Editor', Editor)
Vue.component('FileUpload', FileUpload)
Vue.component('ImageUpload', ImageUpload)
Vue.component('ImagePreview', ImagePreview)
Vue.component('DeviceSelect', DeviceSelect)

Vue.use(directive)
Vue.use(plugins)
DictData.install()

/**
 * If you don't want to use mock-server
 * you want to use MockJs for mock api
 * you can execute: mockXHR()
 *
 * Currently MockJs will be used in the production environment,
 * please remove it before going online! ! !
 */

Vue.use(Element, {
  size: Cookies.get('size') || 'medium' // set element-ui default size
})

Vue.config.productionTip = false

// 初始化页面标题
document.title = defaultSettings.title || '智能电网运维系统'

// 全局初始化 WebSocket，用于系统消息
try {
  const protocol = window.location.protocol === 'https:' ? 'wss://' : 'ws://'
  const host = window.location.host
  const url = `${protocol}${host}/websocket/ws`
  wsClient.connect(url)
  wsClient.addHandler((data) => {
    if (!data || !data.type) return
    if (data.type === 'maintenance_notice') {
      const record = {
        id: Date.now(),
        title: data.title || '智能运维提醒',
        message: data.message || '有设备需要生成智能运维表单或存在告警，请及时处理。',
        count: data.count || 0,
        time: parseTime ? parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}') : new Date().toLocaleString()
      }
      store.dispatch('notify/addNotifyMessage', record)
    }
  })
} catch (e) {
  // 忽略初始化失败
}

new Vue({
  el: '#app',
  router,
  store,
  render: h => h(App)
})
