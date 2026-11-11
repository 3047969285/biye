import Vue from 'vue'

import Cookies from 'js-cookie'

import Alert from 'element-ui/lib/alert'
import Badge from 'element-ui/lib/badge'
import Breadcrumb from 'element-ui/lib/breadcrumb'
import BreadcrumbItem from 'element-ui/lib/breadcrumb-item'
import Button from 'element-ui/lib/button'
import ButtonGroup from 'element-ui/lib/button-group'
import Card from 'element-ui/lib/card'
import Checkbox from 'element-ui/lib/checkbox'
import Col from 'element-ui/lib/col'
import Collapse from 'element-ui/lib/collapse'
import CollapseItem from 'element-ui/lib/collapse-item'
import ColorPicker from 'element-ui/lib/color-picker'
import DatePicker from 'element-ui/lib/date-picker'
import Descriptions from 'element-ui/lib/descriptions'
import DescriptionsItem from 'element-ui/lib/descriptions-item'
import Dialog from 'element-ui/lib/dialog'
import Divider from 'element-ui/lib/divider'
import Drawer from 'element-ui/lib/drawer'
import Dropdown from 'element-ui/lib/dropdown'
import DropdownItem from 'element-ui/lib/dropdown-item'
import DropdownMenu from 'element-ui/lib/dropdown-menu'
import Empty from 'element-ui/lib/empty'
import Form from 'element-ui/lib/form'
import FormItem from 'element-ui/lib/form-item'
import Image from 'element-ui/lib/image'
import Input from 'element-ui/lib/input'
import InputNumber from 'element-ui/lib/input-number'
import Link from 'element-ui/lib/link'
import Menu from 'element-ui/lib/menu'
import MenuItem from 'element-ui/lib/menu-item'
import Option from 'element-ui/lib/option'
import ElPagination from 'element-ui/lib/pagination'
import Popover from 'element-ui/lib/popover'
import Progress from 'element-ui/lib/progress'
import Radio from 'element-ui/lib/radio'
import RadioButton from 'element-ui/lib/radio-button'
import RadioGroup from 'element-ui/lib/radio-group'
import Row from 'element-ui/lib/row'
import Scrollbar from 'element-ui/lib/scrollbar'
import Select from 'element-ui/lib/select'
import Submenu from 'element-ui/lib/submenu'
import Switch from 'element-ui/lib/switch'
import TabPane from 'element-ui/lib/tab-pane'
import Table from 'element-ui/lib/table'
import TableColumn from 'element-ui/lib/table-column'
import Tabs from 'element-ui/lib/tabs'
import Tag from 'element-ui/lib/tag'
import Tooltip from 'element-ui/lib/tooltip'
import Transfer from 'element-ui/lib/transfer'
import Tree from 'element-ui/lib/tree'
import Upload from 'element-ui/lib/upload'
import './assets/styles/element-variables.scss'

import '@/assets/styles/index.scss' // global css
import '@/assets/styles/ruoyi.scss' // ruoyi css
import '@/assets/styles/energy-theme.scss' // shared energy theme base
import '@/assets/styles/delta-ops-theme.scss' // Delta Cafés–caliber ops visual language
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

Vue.prototype.$ELEMENT = { size: Cookies.get('size') || 'medium' };
[
  Alert, Badge, Breadcrumb, BreadcrumbItem, Button, ButtonGroup, Card, Checkbox, Col,
  Collapse, CollapseItem, ColorPicker, DatePicker, Descriptions, DescriptionsItem,
  Dialog, Divider, Drawer, Dropdown, DropdownItem, DropdownMenu, Empty, Form, FormItem,
  Image, Input, InputNumber, Link, Menu, MenuItem, Option, ElPagination, Popover, Progress,
  Radio, RadioButton, RadioGroup, Row, Scrollbar, Select, Submenu, Switch, TabPane, Table,
  TableColumn, Tabs, Tag, Tooltip, Transfer, Tree, Upload
].forEach(component => Vue.use(component))

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
