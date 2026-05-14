<template>
  <div class="dashboard-container">
    <div class="dashboard-header">
      <h2 class="dashboard-title">设备概览</h2>
      <el-button
        type="primary"
        icon="el-icon-refresh"
        size="small"
        plain
        @click="loadData"
        :loading="loading"
      >刷新</el-button>
    </div>

    <el-row :gutter="16" class="stats-row">
      <el-col :xs="12" :sm="6" :md="6">
        <div class="stat-card stat-card--normal">
          <div class="stat-value">{{ statistics.normal || 0 }}</div>
          <div class="stat-label">正常</div>
        </div>
      </el-col>
      <el-col :xs="12" :sm="6" :md="6">
        <div class="stat-card stat-card--stopped">
          <div class="stat-value">{{ statistics.stopped || 0 }}</div>
          <div class="stat-label">停用</div>
        </div>
      </el-col>
      <el-col :xs="12" :sm="6" :md="6">
        <div class="stat-card stat-card--maintenance">
          <div class="stat-value">{{ statistics.maintenance || 0 }}</div>
          <div class="stat-label">维护</div>
        </div>
      </el-col>
      <el-col :xs="12" :sm="6" :md="6">
        <div class="stat-card stat-card--scrapped">
          <div class="stat-value">{{ statistics.scrapped || 0 }}</div>
          <div class="stat-label">报废</div>
        </div>
      </el-col>
    </el-row>

    <el-card class="device-list-card" shadow="never">
      <div slot="header" class="card-header">
        <span class="card-title">设备列表</span>
        <el-input
          v-model="searchKeyword"
          placeholder="搜索名称、编号、类型"
          prefix-icon="el-icon-search"
          size="small"
          class="device-search-input"
          clearable
          @input="handleSearch"
        />
      </div>
      <div class="device-list-container">
        <div v-if="loading" class="loading-data">
          <i class="el-icon-loading"></i>
          <span>加载中</span>
        </div>
        <div v-else-if="totalDevices === 0" class="empty-data">
          <span>{{ searchKeyword ? '无匹配设备' : '暂无设备' }}</span>
        </div>
        <el-collapse v-else v-model="collapseActiveNames" class="device-type-collapse">
          <el-collapse-item
            v-for="grp in groupedPagedDevices"
            :key="grp.key"
            :name="grp.key"
          >
            <template slot="title">
              <span class="collapse-title-text">{{ grp.label }}</span>
              <span class="collapse-title-count">{{ grp.devices.length }} 台</span>
            </template>
            <div class="device-grid">
              <div
                v-for="device in grp.devices"
                :key="device.deviceId"
                class="device-card"
                :class="{
                  'status-normal': device.status === 1,
                  'status-stopped': device.status === 2,
                  'status-maintenance': device.status === 3,
                  'status-scrapped': device.status === 4
                }"
                @click="showDeviceDetail(device.deviceId)"
              >
                <div class="device-card-header">
                  <div class="device-name">{{ device.deviceName || '未命名设备' }}</div>
                  <el-tag :type="getStatusTagType(device.status)" size="mini">
                    {{ device.statusName }}
                  </el-tag>
                </div>
                <div class="device-card-body">
                  <div class="device-info-row">
                    <span class="info-label">编号</span>
                    <span class="info-value">{{ device.deviceNo || '—' }}</span>
                  </div>
                  <div class="device-info-row">
                    <span class="info-label">类型</span>
                    <span class="info-value">{{ device.deviceType || '—' }}</span>
                  </div>
                  <div class="device-info-row">
                    <span class="info-label">位置</span>
                    <span class="info-value">{{ device.location || '—' }}</span>
                  </div>
                  <div class="device-info-row device-info-row--foot">
                    <span class="info-label">数据</span>
                    <div class="device-data-summary">
                      <span class="summary-total">
                        <strong class="highlight-count">{{ device.totalCount || 0 }}</strong>
                        <span class="summary-unit">条</span>
                      </span>
                      <span class="summary-sep" aria-hidden="true">·</span>
                      <el-tooltip
                        effect="dark"
                        placement="top"
                        :open-delay="280"
                        popper-class="device-dim-tooltip"
                      >
                        <div slot="content" class="dim-tooltip-body">
                          「类」表示系统为该设备统计的<strong>业务数据表种类</strong>（如设备状态、参数、告警等）。<br>
                          形如「3/{{ dataDimensionTotal }}」表示：共有 {{ dataDimensionTotal }} 类表参与统计，其中 3 类里已有数据。<br>
                          这与<strong>设备总台数</strong>无关；您当前列表里的设备台数见分组标题上的「N 台」。
                        </div>
                        <span class="summary-dim">
                          {{ deviceActiveDataTypeCount(device) }}/{{ dataDimensionTotal }} 类有数据
                        </span>
                      </el-tooltip>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </el-collapse-item>
        </el-collapse>
      </div>
      <!-- 分页 -->
      <div v-if="totalDevices > 0" class="pagination-container">
        <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="currentPage"
          :page-sizes="[12, 24, 48, 96]"
          :page-size="pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          :total="totalDevices"
        />
      </div>
    </el-card>

    <!-- 设备详情对话框 -->
    <el-dialog
      title="设备详情"
      :visible.sync="dialogVisible"
      width="88%"
      :before-close="handleClose"
      class="device-detail-dialog"
    >
      <div v-if="selectedDevice" v-loading="dialogLoading" class="device-detail-content">
        <!-- 设备基本信息卡片 -->
        <el-card class="device-info-card" shadow="never">
          <div slot="header" class="card-header-title">基本信息</div>
          <el-row :gutter="20">
            <el-col :xs="24" :sm="12" :md="8">
              <div class="info-item">
                <div class="info-label">设备编号</div>
                <div class="info-value">{{ selectedDevice.deviceNo || '-' }}</div>
              </div>
            </el-col>
            <el-col :xs="24" :sm="12" :md="8">
              <div class="info-item">
                <div class="info-label">设备名称</div>
                <div class="info-value primary">{{ selectedDevice.deviceName || '-' }}</div>
              </div>
            </el-col>
            <el-col :xs="24" :sm="12" :md="8">
              <div class="info-item">
                <div class="info-label">设备类型</div>
                <div class="info-value">{{ selectedDevice.deviceType || '-' }}</div>
              </div>
            </el-col>
            <el-col :xs="24" :sm="12" :md="8">
              <div class="info-item">
                <div class="info-label">安装位置</div>
                <div class="info-value">{{ selectedDevice.location || '-' }}</div>
              </div>
            </el-col>
            <el-col :xs="24" :sm="12" :md="8">
              <div class="info-item">
                <div class="info-label">运行状态</div>
                <div class="info-value">
                  <el-tag :type="getStatusTagType(selectedDevice.status)" size="small">
                    {{ selectedDevice.statusName }}
                  </el-tag>
                </div>
              </div>
            </el-col>
          </el-row>
        </el-card>

        <!-- 设备详细数据 - 使用标签页展示所有维度 -->
        <el-card class="device-data-card" shadow="never">
          <div slot="header" class="card-header-title">分项数据</div>
          <el-tabs v-model="activeTab" type="border-card" @tab-click="handleTabClick">
            <el-tab-pane 
              v-for="tab in dataTabs" 
              :key="tab.name" 
              :label="tab.label" 
              :name="tab.name"
            >
              <div class="tab-pane-inner">
                <div v-if="!tab.data || tab.data.length === 0" class="empty-data-tip">
                  <template v-if="tab.name === 'prediction'">
                    暂无预测记录。本页展示库表 eq_prediction：由「发电预测」对该设备的 device_id 预测成功且后端开启落库后写入；若在其它设备（如变压器）下查看而从未对该设备跑过预测，此处为空属正常。请在「发电预测」中选择<strong>当前设备</strong>执行「立即预测」后，再切换回本标签或重新打开本窗口。
                  </template>
                  <template v-else>暂无数据</template>
                </div>
                <el-table 
                  v-else
                  :data="tab.data" 
                  border
                  stripe
                  :max-height="500"
                  style="width: 100%;"
                  class="device-detail-table"
                >
                  <el-table-column
                    v-for="col in tab.columns"
                    :key="col.prop"
                    :prop="col.prop"
                    :label="col.label"
                    :width="col.width"
                    :min-width="col.minWidth || 120"
                    :formatter="col.formatter"
                    align="center"
                    show-overflow-tooltip
                  />
                </el-table>
              </div>
            </el-tab-pane>
          </el-tabs>
        </el-card>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getDeviceDashboardData } from '@/api/equipment/device'
import { listDeviceParamByDeviceId } from '@/api/equipment/deviceParam'
import { listDeviceStatByDeviceId } from '@/api/equipment/deviceStat'
import { listMaintenanceRecordByDeviceId } from '@/api/equipment/maintenanceRecord'
import { listAlertRecordByDeviceId } from '@/api/equipment/alertRecord'
import { listEnvironmentDataByDeviceId } from '@/api/equipment/environmentData'
import { listEconomicDataByDeviceId } from '@/api/equipment/economicData'
import { listElectricalDataByDeviceId } from '@/api/equipment/electricalData'
import { listTechnologyDataByDeviceId } from '@/api/equipment/technologyData'
import { listMechanicalDataByDeviceId } from '@/api/equipment/mechanicalData'
import { listOperationalDataByDeviceId } from '@/api/equipment/operationalData'
import { listSensorByDeviceId } from '@/api/equipment/sensor'
import { listClimateDataByDeviceId } from '@/api/equipment/climateData'
import { listFaultRecordByDeviceId } from '@/api/equipment/faultRecord'
import { listDeviceRuleByDeviceId } from '@/api/equipment/deviceRule'
import { listPredictionByDeviceId } from '@/api/equipment/prediction'
import { listDeviceStatus } from '@/api/equipment/deviceStatus'

/** 详情表空值显示（与 el-table formatter 签名一致） */
function fmtDash(row, column, cellValue) {
  if (cellValue === null || cellValue === undefined || cellValue === '') return '—'
  return cellValue
}

function mkEnumFormatter(map) {
  return (row, column, cellValue) => {
    if (cellValue === null || cellValue === undefined || cellValue === '') return '—'
    return map[cellValue] != null ? map[cellValue] : String(cellValue)
  }
}

const MAP_MAINT_TYPE = { 1: '预防性', 2: '纠正性', 3: '预测性', 4: '紧急' }
const MAP_MAINT_STATUS = { 1: '已完成', 2: '安排中', 3: '进行中', 4: '已取消' }
const MAP_ALERT_STATUS = { 1: '已触发', 2: '已解决', 3: '已确认' }
const MAP_DEVICE_STATUS = { 1: '正常', 2: '警告', 3: '错误', 4: '离线' }
const MAP_OPERATION_TYPE = { 1: '开机', 2: '关机', 3: '调试', 4: '维护', 5: '故障处理' }
const MAP_OPERATION_RESULT = { 1: '成功', 2: '失败', 3: '警告' }
const MAP_RULE_COND = { 1: '大于', 2: '小于', 3: '等于', 4: '区间' }
const MAP_RULE_ALERT = { 1: '一般', 2: '严重', 3: '紧急' }
const MAP_ENABLED = { 0: '禁用', 1: '启用' }
const MAP_FAULT_STATUS = { 1: '待处理', 2: '已解决', 3: '处理中' }
const MAP_SENSOR_STATUS = { 1: '启用', 2: '停用', 3: '校准中' }
const MAP_TECH_LEVEL = { 1: '落后', 2: '一般', 3: '先进', 4: '领先' }
const MAP_GRADE_4 = { 1: '优良', 2: '良好', 3: '一般', 4: '较差' }
const MAP_CERT = { 1: '有效', 2: '过期', 3: '待审核' }
const MAP_POLLUTION = { 1: '优', 2: '良', 3: '轻度污染', 4: '中度污染', 5: '重度污染' }
const MAP_SEASON = { 1: '春', 2: '夏', 3: '秋', 4: '冬' }
const MAP_PREDICTED_STATUS = { 1: '正常', 2: '警告', 3: '错误', 4: '离线' }
const MAP_RISK_LEVEL = { 1: '低', 2: '中', 3: '高' }
const MAP_ACTION_TAKEN = { 1: '待处理', 2: '已处理', 3: '忽略' }

export default {
  name: 'Dashboard',
  data() {
    return {
      loading: false,
      deviceData: [],
      originalDeviceData: [],
      filteredDeviceData: [],
      searchKeyword: '',
      statistics: {
        normal: 0,
        stopped: 0,
        maintenance: 0,
        scrapped: 0
      },
      dialogVisible: false,
      dialogLoading: false,
      selectedDevice: null,
      activeTab: 'deviceStatus',
      dataTabs: [],
      currentPage: 1,
      pageSize: 24,
      totalDevices: 0,
      /** 按类型折叠面板：当前页切换或筛选后默认全部展开 */
      collapseActiveNames: [],
      /** 后台参与统计的数据表种类数（与设备台数无关） */
      dataDimensionTotal: 16
    }
  },
  computed: {
    /** 当前页设备按 deviceType 分组 */
    groupedPagedDevices() {
      const list = this.filteredDeviceData || []
      const map = new Map()
      for (const d of list) {
        const t = (d.deviceType && String(d.deviceType).trim()) || ''
        const key = t || '__uncat__'
        if (!map.has(key)) {
          map.set(key, { key, label: t || '未分类', devices: [] })
        }
        map.get(key).devices.push(d)
      }
      return Array.from(map.values()).sort((a, b) => {
        if (a.key === '__uncat__') return 1
        if (b.key === '__uncat__') return -1
        return a.label.localeCompare(b.label, 'zh-CN')
      })
    }
  },
  watch: {
    groupedPagedDevices: {
      handler(groups) {
        this.collapseActiveNames = (groups || []).map(g => g.key)
      },
      immediate: true
    }
  },
  mounted() {
    this.loadData()
  },
  methods: {
    async loadData() {
      this.loading = true
      try {
        const response = await getDeviceDashboardData()
        if (response.code === 200) {
          const payload = response.data || {}
          this.originalDeviceData = payload.devices || []
          const tables = payload.tables
          if (Array.isArray(tables) && tables.length > 0) {
            this.dataDimensionTotal = tables.length
          } else if (this.originalDeviceData[0] && this.originalDeviceData[0].tableCounts) {
            this.dataDimensionTotal = Object.keys(this.originalDeviceData[0].tableCounts).length
          } else {
            this.dataDimensionTotal = 16
          }
          this.deviceData = [...this.originalDeviceData]
          this.calculateStatistics()
          this.applyPagination()
        } else {
          this.$modal.msgError('加载数据失败: ' + (response.msg || '未知错误'))
        }
      } catch (error) {
        console.error('加载数据失败:', error)
        this.$modal.msgError('加载数据失败: ' + error.message)
      } finally {
        this.loading = false
      }
    },
    calculateStatistics() {
      this.statistics = {
        normal: 0,
        stopped: 0,
        maintenance: 0,
        scrapped: 0
      }
      this.deviceData.forEach(device => {
        if (device.status === 1) this.statistics.normal++
        else if (device.status === 2) this.statistics.stopped++
        else if (device.status === 3) this.statistics.maintenance++
        else if (device.status === 4) this.statistics.scrapped++
      })
    },
    handleSearch() {
      this.currentPage = 1
      this.applyPagination()
    },
    getFilteredData() {
      const keyword = this.searchKeyword.toLowerCase().trim()
      if (!keyword) {
        return [...this.deviceData]
      } else {
        return this.deviceData.filter(device => {
          return (
            (device.deviceName && device.deviceName.toLowerCase().includes(keyword)) ||
            (device.deviceNo && device.deviceNo.toLowerCase().includes(keyword)) ||
            (device.deviceType && device.deviceType.toLowerCase().includes(keyword)) ||
            (device.location && device.location.toLowerCase().includes(keyword))
          )
        })
      }
    },
    applyPagination() {
      const allFiltered = this.getFilteredData()
      this.totalDevices = allFiltered.length
      const start = (this.currentPage - 1) * this.pageSize
      const end = start + this.pageSize
      this.filteredDeviceData = allFiltered.slice(start, end)
    },
    handleSizeChange(val) {
      this.pageSize = val
      this.currentPage = 1
      this.applyPagination()
    },
    handleCurrentChange(val) {
      this.currentPage = val
      this.applyPagination()
    },
    getTableDisplayName(tableName) {
      const nameMap = {
        'eq_device_status': '设备状态',
        'eq_device_param': '设备参数',
        'eq_device_stat': '统计数据',
        'eq_maintenance_record': '维护记录',
        'eq_alert_record': '告警记录',
        'eq_environment_data': '环境数据',
        'eq_economic_data': '经济数据',
        'eq_electrical_data': '电气数据',
        'eq_technology_data': '技术数据',
        'eq_mechanical_data': '机械数据',
        'eq_operational_data': '操作数据',
        'eq_sensor': '传感器',
        'eq_climate_data': '气候数据',
        'eq_fault_record': '故障记录',
        'eq_device_rule': '设备规则',
        'eq_prediction': '预测结果'
      }
      return nameMap[tableName] || tableName
    },
    async showDeviceDetail(deviceId) {
      // 从原始数据中查找完整设备信息
      const allDevices = this.originalDeviceData.length > 0 ? this.originalDeviceData : this.deviceData
      const device = allDevices.find(d => d.deviceId === deviceId)
      if (!device) {
        this.$modal.msgWarning('未找到该设备信息')
        return
      }
      
      this.selectedDevice = device
      this.activeTab = 'deviceStatus'
      
      // 初始化标签页配置
      this.initializeDataTabs()
      
      this.dialogVisible = true
      this.dialogLoading = true
      
      // 一次性加载所有标签页的数据
      try {
        await this.loadAllTabData()
      } finally {
        this.dialogLoading = false
      }
    },
    initializeDataTabs() {
      // 列 prop 须与 ruoyi-system/domain 下实体字段一致，否则表格会一直空白
      this.dataTabs = [
        {
          name: 'deviceStatus',
          label: '设备状态',
          api: (id) => listDeviceStatus({ deviceId: id }),
          columns: [
            { prop: 'timestamp', label: '采集时间', minWidth: 168 },
            { prop: 'temperature', label: '温度(℃)', width: 100, formatter: fmtDash },
            { prop: 'humidity', label: '湿度(%)', width: 100, formatter: fmtDash },
            { prop: 'pressure', label: '压力(Pa)', width: 110, formatter: fmtDash },
            { prop: 'current', label: '电流(A)', width: 100, formatter: fmtDash },
            { prop: 'voltage', label: '电压(V)', width: 100, formatter: fmtDash },
            { prop: 'power', label: '功率(kW)', width: 100, formatter: fmtDash },
            { prop: 'status', label: '状态', width: 100, formatter: mkEnumFormatter(MAP_DEVICE_STATUS) }
          ],
          data: [],
          loading: false
        },
        {
          name: 'deviceParam',
          label: '设备参数',
          api: listDeviceParamByDeviceId,
          columns: [
            { prop: 'paramId', label: '参数ID', width: 90 },
            { prop: 'parameterName', label: '参数名称', minWidth: 130 },
            { prop: 'parameterValue', label: '参数值', width: 100, formatter: fmtDash },
            { prop: 'unit', label: '单位', width: 72, formatter: fmtDash },
            { prop: 'defaultValue', label: '默认值', width: 100, formatter: fmtDash },
            { prop: 'minValue', label: '最小值', width: 100, formatter: fmtDash },
            { prop: 'maxValue', label: '最大值', width: 100, formatter: fmtDash },
            { prop: 'criticalThreshold', label: '临界阈值', width: 110, formatter: fmtDash },
            { prop: 'warningThreshold', label: '警告阈值', width: 110, formatter: fmtDash },
            { prop: 'lastUpdated', label: '最后更新', minWidth: 160, formatter: fmtDash }
          ],
          data: [],
          loading: false
        },
        {
          name: 'deviceStat',
          label: '统计数据',
          api: listDeviceStatByDeviceId,
          columns: [
            { prop: 'statId', label: '统计ID', width: 90 },
            { prop: 'statDate', label: '统计日期', minWidth: 160 },
            { prop: 'totalRuntimeHours', label: '总运行时间(小时)', width: 140, formatter: fmtDash },
            { prop: 'totalFaultCount', label: '总故障次数', width: 100, formatter: fmtDash },
            { prop: 'totalMaintenanceCount', label: '总维护次数', width: 110, formatter: fmtDash },
            { prop: 'averageTemperature', label: '平均温度(℃)', width: 120, formatter: fmtDash },
            { prop: 'maximumTemperature', label: '最高温度(℃)', width: 120, formatter: fmtDash },
            { prop: 'minimumTemperature', label: '最低温度(℃)', width: 120, formatter: fmtDash },
            { prop: 'uptimePercentage', label: '运行率(%)', width: 110, formatter: fmtDash },
            { prop: 'faultRatePerHour', label: '故障率(/小时)', width: 120, formatter: fmtDash }
          ],
          data: [],
          loading: false
        },
        {
          name: 'maintenanceRecord',
          label: '维护记录',
          api: listMaintenanceRecordByDeviceId,
          columns: [
            { prop: 'recordId', label: '记录ID', width: 90 },
            { prop: 'maintenanceDate', label: '维护日期', minWidth: 160 },
            { prop: 'maintenanceType', label: '维护类型', width: 100, formatter: mkEnumFormatter(MAP_MAINT_TYPE) },
            { prop: 'performedBy', label: '执行人员', minWidth: 100, formatter: fmtDash },
            { prop: 'maintenanceCost', label: '维护费用', width: 110, formatter: fmtDash },
            { prop: 'description', label: '维护描述', minWidth: 160, formatter: fmtDash },
            { prop: 'nextMaintenanceDate', label: '下次维护', minWidth: 160, formatter: fmtDash },
            { prop: 'status', label: '记录状态', width: 100, formatter: mkEnumFormatter(MAP_MAINT_STATUS) }
          ],
          data: [],
          loading: false
        },
        {
          name: 'alertRecord',
          label: '告警记录',
          api: listAlertRecordByDeviceId,
          columns: [
            { prop: 'alertId', label: '告警ID', width: 90 },
            { prop: 'triggeredTime', label: '告警时间', minWidth: 168 },
            { prop: 'alertLevel', label: '告警级别', width: 100, formatter: fmtDash },
            { prop: 'alertType', label: '告警类型', minWidth: 130, formatter: fmtDash },
            { prop: 'alertMessage', label: '告警信息', minWidth: 200, formatter: fmtDash },
            { prop: 'status', label: '告警状态', width: 100, formatter: mkEnumFormatter(MAP_ALERT_STATUS) },
            { prop: 'resolvedTime', label: '解决时间', minWidth: 168, formatter: fmtDash }
          ],
          data: [],
          loading: false
        },
        {
          name: 'environmentData',
          label: '环境数据',
          api: listEnvironmentDataByDeviceId,
          columns: [
            { prop: 'envId', label: '环境ID', width: 90 },
            { prop: 'timestamp', label: '采集时间', minWidth: 168 },
            { prop: 'ambientTemperature', label: '环境温度(℃)', width: 120, formatter: fmtDash },
            { prop: 'deviceTemperature', label: '设备温度(℃)', width: 120, formatter: fmtDash },
            { prop: 'humidity', label: '湿度(%)', width: 100, formatter: fmtDash },
            { prop: 'dewPoint', label: '露点(℃)', width: 100, formatter: fmtDash },
            { prop: 'vibrationX', label: '振动X(mm/s)', width: 120, formatter: fmtDash },
            { prop: 'vibrationY', label: '振动Y(mm/s)', width: 120, formatter: fmtDash },
            { prop: 'environmentGrade', label: '环境等级', width: 100, formatter: mkEnumFormatter(MAP_GRADE_4) }
          ],
          data: [],
          loading: false
        },
        {
          name: 'economicData',
          label: '经济数据',
          api: listEconomicDataByDeviceId,
          columns: [
            { prop: 'economicId', label: '经济ID', width: 90 },
            { prop: 'timestamp', label: '记录时间', minWidth: 168 },
            { prop: 'maintenanceCost', label: '维护成本', width: 110, formatter: fmtDash },
            { prop: 'energyConsumption', label: '能耗', width: 110, formatter: fmtDash },
            { prop: 'laborCost', label: '人工成本', width: 110, formatter: fmtDash },
            { prop: 'partsCost', label: '配件成本', width: 110, formatter: fmtDash },
            { prop: 'downtimeCost', label: '停机损失', width: 110, formatter: fmtDash },
            { prop: 'actualSpending', label: '实际支出', width: 110, formatter: fmtDash },
            { prop: 'roi', label: 'ROI', width: 90, formatter: fmtDash }
          ],
          data: [],
          loading: false
        },
        {
          name: 'electricalData',
          label: '电气数据',
          api: listElectricalDataByDeviceId,
          columns: [
            { prop: 'electricalId', label: '电气ID', width: 90 },
            { prop: 'timestamp', label: '采集时间', minWidth: 168 },
            { prop: 'voltageL1', label: 'L1电压', width: 100, formatter: fmtDash },
            { prop: 'voltageL2', label: 'L2电压', width: 100, formatter: fmtDash },
            { prop: 'voltageL3', label: 'L3电压', width: 100, formatter: fmtDash },
            { prop: 'currentL1', label: 'L1电流', width: 100, formatter: fmtDash },
            { prop: 'currentL2', label: 'L2电流', width: 100, formatter: fmtDash },
            { prop: 'currentL3', label: 'L3电流', width: 100, formatter: fmtDash },
            { prop: 'activePower', label: '有功功率(kW)', width: 120, formatter: fmtDash },
            { prop: 'frequency', label: '频率(Hz)', width: 100, formatter: fmtDash },
            { prop: 'powerFactor', label: '功率因数', width: 100, formatter: fmtDash },
            { prop: 'electricalGrade', label: '电气等级', width: 100, formatter: mkEnumFormatter(MAP_GRADE_4) }
          ],
          data: [],
          loading: false
        },
        {
          name: 'technologyData',
          label: '技术数据',
          api: listTechnologyDataByDeviceId,
          columns: [
            { prop: 'techId', label: '技术ID', width: 90 },
            { prop: 'timestamp', label: '更新时间', minWidth: 168 },
            { prop: 'technologyLevel', label: '技术等级', width: 100, formatter: mkEnumFormatter(MAP_TECH_LEVEL) },
            { prop: 'softwareVersion', label: '软件版本', minWidth: 110, formatter: fmtDash },
            { prop: 'firmwareVersion', label: '固件版本', minWidth: 110, formatter: fmtDash },
            { prop: 'digitalizationLevel', label: '数字化等级', width: 110, formatter: fmtDash },
            { prop: 'technologyMaturity', label: '技术成熟度', width: 110, formatter: fmtDash },
            { prop: 'certificationStatus', label: '认证状态', width: 100, formatter: mkEnumFormatter(MAP_CERT) },
            { prop: 'obsolescenceRisk', label: '淘汰风险', width: 100, formatter: fmtDash }
          ],
          data: [],
          loading: false
        },
        {
          name: 'mechanicalData',
          label: '机械数据',
          api: listMechanicalDataByDeviceId,
          columns: [
            { prop: 'mechanicalId', label: '机械ID', width: 90 },
            { prop: 'timestamp', label: '采集时间', minWidth: 168 },
            { prop: 'vibrationVelocity', label: '振动速度(mm/s)', width: 130, formatter: fmtDash },
            { prop: 'vibrationAmplitude', label: '振动振幅(mm)', width: 120, formatter: fmtDash },
            { prop: 'materialTemperature', label: '材料温度(℃)', width: 120, formatter: fmtDash },
            { prop: 'loadWeight', label: '载荷(kg)', width: 100, formatter: fmtDash },
            { prop: 'fatigueCycles', label: '疲劳循环', width: 100, formatter: fmtDash },
            { prop: 'mechanicalGrade', label: '机械等级', width: 100, formatter: mkEnumFormatter(MAP_GRADE_4) }
          ],
          data: [],
          loading: false
        },
        {
          name: 'operationalData',
          label: '操作数据',
          api: listOperationalDataByDeviceId,
          columns: [
            { prop: 'operationalId', label: '操作ID', width: 90 },
            { prop: 'timestamp', label: '操作时间', minWidth: 168 },
            { prop: 'operationType', label: '操作类型', width: 100, formatter: mkEnumFormatter(MAP_OPERATION_TYPE) },
            { prop: 'operationDuration', label: '时长(秒)', width: 100, formatter: fmtDash },
            { prop: 'operationResult', label: '操作结果', width: 100, formatter: mkEnumFormatter(MAP_OPERATION_RESULT) },
            { prop: 'operatorName', label: '操作员', minWidth: 100, formatter: fmtDash },
            { prop: 'operationNotes', label: '操作备注', minWidth: 160, formatter: fmtDash }
          ],
          data: [],
          loading: false
        },
        {
          name: 'sensor',
          label: '传感器',
          api: listSensorByDeviceId,
          columns: [
            { prop: 'sensorId', label: '传感器ID', width: 100 },
            { prop: 'sensorType', label: '传感器类型', minWidth: 120, formatter: fmtDash },
            { prop: 'sensorName', label: '传感器名称', minWidth: 120, formatter: fmtDash },
            { prop: 'location', label: '安装位置', minWidth: 120, formatter: fmtDash },
            { prop: 'unit', label: '单位', width: 72, formatter: fmtDash },
            { prop: 'status', label: '状态', width: 90, formatter: mkEnumFormatter(MAP_SENSOR_STATUS) },
            { prop: 'calibrationTime', label: '校准时间', minWidth: 160, formatter: fmtDash },
            { prop: 'nextCalibrationTime', label: '下次校准', minWidth: 160, formatter: fmtDash }
          ],
          data: [],
          loading: false
        },
        {
          name: 'climateData',
          label: '气候数据',
          api: listClimateDataByDeviceId,
          columns: [
            { prop: 'climateId', label: '气候ID', width: 90 },
            { prop: 'timestamp', label: '采集时间', minWidth: 168 },
            { prop: 'season', label: '季节(库)', width: 80, formatter: mkEnumFormatter(MAP_SEASON) },
            { prop: 'weatherCondition', label: '天气状况', minWidth: 100, formatter: fmtDash },
            { prop: 'precipitation', label: '降水量(mm)', width: 110, formatter: fmtDash },
            { prop: 'windSpeed', label: '风速(m/s)', width: 100, formatter: fmtDash },
            { prop: 'windDirection', label: '风向', minWidth: 90, formatter: fmtDash },
            { prop: 'extremeWeather', label: '极端天气', width: 100, formatter: fmtDash },
            { prop: 'weatherDuration', label: '天气持续(h)', width: 110, formatter: fmtDash },
            { prop: 'temperatureExtreme', label: '极端温度', width: 100, formatter: fmtDash },
            { prop: 'naturalDisasters', label: '自然灾害', width: 100, formatter: fmtDash },
            { prop: 'disasterIntensity', label: '灾害强度', width: 100, formatter: fmtDash },
            { prop: 'disasterDuration', label: '灾害持续(h)', width: 110, formatter: fmtDash },
            { prop: 'airQualityIndex', label: '空气质量指数', width: 120, formatter: fmtDash },
            { prop: 'pollutionLevel', label: '污染等级', width: 110, formatter: mkEnumFormatter(MAP_POLLUTION) },
            { prop: 'uvIndex', label: '紫外线指数', width: 110, formatter: fmtDash }
          ],
          data: [],
          loading: false
        },
        {
          name: 'faultRecord',
          label: '故障记录',
          api: listFaultRecordByDeviceId,
          columns: [
            { prop: 'faultId', label: '故障ID', width: 90 },
            { prop: 'detectedTime', label: '发现时间', minWidth: 168, formatter: fmtDash },
            { prop: 'faultCode', label: '故障代码', minWidth: 100, formatter: fmtDash },
            { prop: 'faultLevel', label: '故障等级', width: 100, formatter: fmtDash },
            { prop: 'faultDescription', label: '故障描述', minWidth: 180, formatter: fmtDash },
            { prop: 'status', label: '处理状态', width: 100, formatter: mkEnumFormatter(MAP_FAULT_STATUS) },
            { prop: 'resolvedTime', label: '解决时间', minWidth: 168, formatter: fmtDash },
            { prop: 'repairCost', label: '修复成本', width: 100, formatter: fmtDash }
          ],
          data: [],
          loading: false
        },
        {
          name: 'prediction',
          label: '预测结果',
          api: listPredictionByDeviceId,
          columns: [
            { prop: 'predictionId', label: '预测ID', width: 90 },
            { prop: 'predictionTime', label: '预测时间', minWidth: 168, formatter: fmtDash },
            { prop: 'predictedStatus', label: '预测状态', width: 100, formatter: mkEnumFormatter(MAP_PREDICTED_STATUS) },
            { prop: 'predictionConfidence', label: '置信度', width: 100, formatter: fmtDash },
            { prop: 'riskLevel', label: '风险', width: 80, formatter: mkEnumFormatter(MAP_RISK_LEVEL) },
            { prop: 'expectedFailureTime', label: '预计故障时间', minWidth: 168, formatter: fmtDash },
            { prop: 'preventiveCost', label: '预防成本', width: 100, formatter: fmtDash },
            { prop: 'actionTaken', label: '行动', width: 90, formatter: mkEnumFormatter(MAP_ACTION_TAKEN) },
            { prop: 'recommendedAction', label: '建议措施', minWidth: 160, formatter: fmtDash },
            { prop: 'notes', label: '备注(notes)', minWidth: 120, formatter: fmtDash }
          ],
          data: [],
          loading: false
        },
        {
          name: 'deviceRule',
          label: '设备规则',
          api: listDeviceRuleByDeviceId,
          columns: [
            { prop: 'ruleId', label: '规则ID', width: 90 },
            { prop: 'ruleName', label: '规则名称', minWidth: 140, formatter: fmtDash },
            { prop: 'parameterName', label: '参数名称', minWidth: 120, formatter: fmtDash },
            { prop: 'conditionType', label: '条件类型', width: 100, formatter: mkEnumFormatter(MAP_RULE_COND) },
            { prop: 'thresholdValue', label: '阈值', width: 100, formatter: fmtDash },
            { prop: 'thresholdUnit', label: '阈值单位', width: 100, formatter: fmtDash },
            { prop: 'alertLevel', label: '告警等级', width: 100, formatter: mkEnumFormatter(MAP_RULE_ALERT) },
            { prop: 'enabled', label: '启用', width: 80, formatter: mkEnumFormatter(MAP_ENABLED) },
            { prop: 'notificationChannels', label: '通知渠道', minWidth: 140, formatter: fmtDash }
          ],
          data: [],
          loading: false
        }
      ]
    },
    /** 切换分项 Tab 时重新拉取该 Tab 数据（避免先打开详情再跑预测时「预测结果」一直显示暂无数据） */
    async handleTabClick(tab) {
      if (!this.selectedDevice || !tab || !tab.name) return
      const tabConfig = this.dataTabs.find((t) => t.name === tab.name)
      if (!tabConfig || typeof tabConfig.api !== 'function') return
      try {
        const response = await tabConfig.api(this.selectedDevice.deviceId)
        if (response && response.code === 200) {
          let data = response.data
          if (data == null && response.rows != null) {
            data = response.rows
          }
          tabConfig.data = Array.isArray(data) ? data : []
        } else {
          tabConfig.data = []
        }
      } catch (error) {
        console.error(`刷新「${tabConfig.label}」失败:`, error)
        tabConfig.data = []
      }
    },
    async loadAllTabData() {
      if (!this.selectedDevice) return
      
      // 并发加载所有标签页的数据，不设置单独的loading状态
      const promises = this.dataTabs.map(async (tab) => {
        try {
          const response = await tab.api(this.selectedDevice.deviceId)
          if (response && response.code === 200) {
            // 兼容不同的响应格式
            tab.data = response.data || response.rows || []
            if (Array.isArray(response)) {
              tab.data = response
            }
          } else {
            console.warn(`加载${tab.label}失败: ${response?.msg || '未知错误'}`)
            tab.data = []
          }
        } catch (error) {
          console.error(`加载${tab.label}失败:`, error)
          tab.data = []
        }
      })
      
      await Promise.all(promises)
    },
    getTableName(category) {
      const map = {
        '设备状态': 'eq_device_status',
        '设备参数': 'eq_device_param',
        '统计数据': 'eq_device_stat',
        '维护记录': 'eq_maintenance_record',
        '告警记录': 'eq_alert_record',
        '环境数据': 'eq_environment_data',
        '经济数据': 'eq_economic_data',
        '电气数据': 'eq_electrical_data',
        '技术数据': 'eq_technology_data',
        '机械数据': 'eq_mechanical_data',
        '操作数据': 'eq_operational_data',
        '传感器': 'eq_sensor',
        '气候数据': 'eq_climate_data',
        '故障记录': 'eq_fault_record',
        '设备规则': 'eq_device_rule',
        '预测结果': 'eq_prediction'
      }
      return map[category] || ''
    },
    handleClose() {
      this.dialogVisible = false
      this.selectedDevice = null
      // 清空所有标签页的数据
      this.dataTabs.forEach(tab => {
        tab.data = []
        tab.loading = false
      })
      this.activeTab = 'deviceStatus'
    },
    getStatusTagType(status) {
      if (status === 1) return 'success'
      if (status === 2) return 'info'
      if (status === 3) return 'warning'
      if (status === 4) return 'danger'
      return ''
    },
    /** 该设备在多少类业务表中已有至少一条记录 */
    deviceActiveDataTypeCount(device) {
      const tc = device.tableCounts || {}
      return Object.keys(tc).filter(k => (tc[k] || 0) > 0).length
    }
  }
}
</script>

<style lang="scss" scoped>
@import "~@/assets/styles/variables.scss";

.dashboard-container {
  padding: 20px;
  background: #222D42;
  min-height: calc(100vh - 84px);
}

.dashboard-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;

  .dashboard-title {
    margin: 0;
    color: $text-primary;
    font-size: 16px;
    font-weight: 600;
  }
}

.stats-row {
  margin-bottom: 16px;
}

.stat-card {
  border-radius: 0;
  background: $primary-bg;
  border: 1px solid $border-color;
  border-left: 3px solid $text-disabled;
  padding: 12px 14px;
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.04);
  transition: border-color 0.15s ease, box-shadow 0.15s ease;

  &:hover {
    border-color: rgba(94, 161, 255, 0.22);
    box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.06);
  }

  .stat-value {
    font-size: 22px;
    font-weight: 600;
    color: $text-primary;
    line-height: 1.2;
    margin-bottom: 4px;
  }

  .stat-label {
    font-size: 13px;
    color: $text-secondary;
  }

  &--normal {
    border-left-color: #67c23a;
  }

  &--stopped {
    border-left-color: #909399;
  }

  &--maintenance {
    border-left-color: #e6a23c;
  }

  &--scrapped {
    border-left-color: #f56c6c;
  }
}

.device-list-card {
  background: #222D42;
  border: 1px solid #2E3B55;
  
  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 10px;

    .card-title {
      font-size: 15px;
      font-weight: 600;
      color: $text-primary;
    }

    .device-search-input {
      width: 220px;
      max-width: 100%;
    }
    
    ::v-deep .device-search-input {
      .el-input__inner {
        background: #1B2435;
        border-color: #2E3B55;
        color: #F5F7FB;
        
        &::placeholder {
          color: #9AA6BF;
        }
      }
      
      .el-input__prefix {
        .el-input__icon {
          color: #5EA1FF;
        }
      }
    }
  }
  
      .device-list-container {
        min-height: 280px;
        
        .loading-data,
        .empty-data {
          text-align: center;
          padding: 48px 16px;
          color: $text-secondary;
          font-size: 14px;

          i {
            font-size: 28px;
            display: block;
            margin-bottom: 8px;
            color: $text-disabled;
          }
        }
        
        .device-type-collapse {
          border: none;

          ::v-deep .el-collapse-item {
            margin-bottom: 10px;
            border: 1px solid $border-color;
            border-radius: 4px;
            overflow: hidden;
            background: $primary-bg;
          }

          ::v-deep .el-collapse-item__header {
            height: 44px;
            line-height: 44px;
            padding: 0 14px;
            background: $primary-bg;
            color: $text-primary;
            font-weight: 500;
            font-size: 14px;
            border-bottom: 1px solid transparent;
          }

          ::v-deep .el-collapse-item__header.is-active {
            border-bottom-color: $border-color;
          }

          ::v-deep .el-collapse-item__wrap {
            background: $secondary-bg;
            border-bottom: none;
          }

          ::v-deep .el-collapse-item__content {
            padding: 10px 12px 12px;
          }

          ::v-deep .el-collapse-item__arrow {
            color: $text-secondary;
          }
        }

        .collapse-title-text {
          margin-right: 10px;
        }

        .collapse-title-count {
          font-size: 12px;
          color: $text-disabled;
          font-weight: 400;
        }

        .device-grid {
          display: grid;
          grid-template-columns: repeat(4, minmax(0, 1fr));
          gap: 10px;
          padding: 0;
        }
    
    .device-card {
      background: $secondary-bg;
      padding: 10px 12px;
      cursor: pointer;
      border: 1px solid $border-color;
      border-left: 3px solid $accent-color;
      transition: background-color 0.18s ease, border-color 0.18s ease, box-shadow 0.18s ease;
      box-shadow: 0 1px 0 rgba(0, 0, 0, 0.12);

      &:hover {
        background: $primary-bg;
        border-color: rgba(94, 161, 255, 0.28);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.18);
      }

      &.status-normal {
        border-left-color: $accent-color;
      }
      
      &.status-stopped {
        border-left-color: #909399;
      }
      
      &.status-maintenance {
        border-left-color: #E6A23C;
      }
      
      &.status-scrapped {
        border-left-color: #F56C6C;
      }
      
        .device-card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 8px;
        padding-bottom: 8px;
        border-bottom: 1px solid #2E3B55;
        
        .device-name {
          font-size: 14px;
          font-weight: 600;
          color: #eef2f8;
          flex: 1;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
          letter-spacing: 0.01em;
        }
      }
      
      .device-card-body {
        margin-bottom: 8px;
        
        .device-info-row {
          display: flex;
          margin-bottom: 6px;
          font-size: 12px;
          
          .info-label {
            color: $text-secondary;
            width: 36px;
            flex-shrink: 0;
            font-size: 12px;
          }

          .info-value {
            color: $text-primary;
            flex: 1;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            font-size: 12px;

            &.highlight-count {
              color: $accent-color;
              font-weight: 600;
            }
          }

          &.device-info-row--foot {
            margin-top: 6px;
            padding-top: 8px;
            border-top: 1px solid $border-color;
            align-items: center;
            gap: 8px;

            .info-label {
              width: 36px;
            }

            .device-data-summary {
              flex: 1;
              min-width: 0;
              display: flex;
              align-items: center;
              flex-wrap: wrap;
              gap: 2px 6px;
              font-size: 12px;
              color: $text-primary;
            }

            .summary-total {
              display: inline-flex;
              align-items: baseline;
            }

            .summary-unit {
              margin-left: 2px;
              font-size: 11px;
              color: $text-secondary;
              font-weight: 400;
            }

            .summary-sep {
              color: $text-disabled;
              margin: 0 2px;
              user-select: none;
            }

            .summary-dim {
              font-size: 11px;
              color: #9aa6bf;
              cursor: help;
              border-bottom: 1px dashed rgba(154, 166, 191, 0.45);
              line-height: 1.3;
            }
          }
        }
      }
      
      .device-card-footer {
        padding-top: 15px;
        border-top: 1px solid #2E3B55;
        
        .data-count {
          display: flex;
          align-items: center;
          margin-bottom: 10px;
          color: #D1D7E6;
          font-size: 14px;
          
          i {
            margin-right: 5px;
            color: #5EA1FF;
          }
          
          strong {
            color: #5EA1FF;
            font-size: 16px;
            margin-left: 5px;
          }
        }
        
        .data-categories {
          display: flex;
          flex-wrap: wrap;
          gap: 5px;
          
          .no-data-tip {
            font-size: 12px;
            color: #C0C4CC;
            font-style: italic;
          }
        }
      }
    }
  }
  
  @media (max-width: 1200px) {
    .device-list-container {
      .device-grid {
        grid-template-columns: repeat(3, minmax(0, 1fr));
      }
    }
  }
  
  @media (max-width: 992px) {
    .device-list-container {
      .device-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }
    }
  }
  
  @media (max-width: 768px) {
    .device-list-container {
      .device-grid {
        grid-template-columns: 1fr;
      }
    }
  }
  
  .pagination-container {
    margin-top: 20px;
    text-align: right;
    padding-top: 20px;
    border-top: 1px solid #2E3B55;
    
    ::v-deep .el-pagination {
      .el-pagination__total,
      .el-pagination__jump,
      .btn-prev,
      .btn-next,
      .el-pager li {
        color: #D1D7E6;
      }
      
      .el-pager li.active {
        color: #5EA1FF;
      }
      
      .el-select .el-input__inner {
        background: #1B2435;
        border-color: #2E3B55;
        color: #F5F7FB;
      }
    }
  }
}

.device-detail-content {
  padding: 10px 0;
}

.device-info-card {
  margin-bottom: 20px;
  background: #222D42;
  border: 1px solid #2E3B55;
  
  ::v-deep .el-card__body {
    background: #222D42;
  }

  .card-header-title {
    font-size: 15px;
    font-weight: 600;
    color: $text-primary;
  }

  .info-item {
    padding: 10px 12px;
    margin-bottom: 10px;
    background: $primary-bg;
    border: 1px solid $border-color;
    border-radius: 2px;

    .info-label {
      font-size: 12px;
      color: $text-secondary;
      margin-bottom: 4px;
    }

    .info-value {
      font-size: 14px;
      color: $text-primary;
      font-weight: 500;

      &.highlight {
        color: $accent-color;
        font-size: 15px;
        font-weight: 600;
      }

      &.primary {
        color: $text-primary;
        font-size: 15px;
        font-weight: 600;
      }
    }
  }
}

.device-data-card {
  margin-top: 20px;
  background: #222D42;
  border: 1px solid #2E3B55;
  
  ::v-deep .el-card__body {
    background: #222D42;
    padding: 0;
  }
  
  .card-header-title {
    font-size: 15px;
    font-weight: 600;
    color: $text-primary;
  }

  .tab-pane-inner {
    min-height: 260px;
    background: $secondary-bg;
    padding: 12px;
  }

  .empty-data-tip {
    text-align: center;
    padding: 40px 16px;
    color: $text-disabled;
    font-size: 13px;
    background: $primary-bg;
    border: 1px dashed $border-color;
  }
  
  ::v-deep .el-tabs--border-card {
    background: #222D42;
    border: 1px solid #2E3B55;
    
    .el-tabs__header {
      background: #1B2435;
      border-bottom: 2px solid #2E3B55;
      margin: 0;
      padding: 0 20px;
      
      .el-tabs__item {
        color: #D1D7E6;
        font-weight: 400;

        &.is-active {
          color: $accent-color;
          font-weight: 500;
        }
      }
    }
    
    .el-tabs__content {
      padding: 20px;
      background: #222D42;
    }
  }
  
  ::v-deep .device-detail-table {
    background: #222D42 !important;
    
    th {
      background-color: #1B2435 !important;
      color: #F5F7FB !important;
      font-weight: 600 !important;
      border-color: #2E3B55 !important;
    }
    
    td {
      background-color: #222D42 !important;
      color: #D1D7E6 !important;
      border-color: #2E3B55 !important;
    }
    
    .el-table__row {
      background-color: #222D42 !important;

      &:hover td {
        background-color: #2a3548 !important;
      }
    }

    .el-table__row--striped {
      background-color: #1B2435 !important;

      td {
        background-color: #1B2435 !important;
      }

      &:hover td {
        background-color: #2a3548 !important;
      }
    }
  }
}

::v-deep .el-card__header {
  background: #1B2435;
  border-bottom: 1px solid #2E3B55;
  
  .card-header {
    color: #F5F7FB;
  }
}

::v-deep .device-detail-dialog {
  .el-dialog {
    overflow: hidden;
    background: transparent;
  }
  
  .el-dialog__header {
    background: #1B2435;
    padding: 14px 20px;
    border-bottom: 1px solid #2E3B55;

    .el-dialog__title {
      color: #F5F7FB;
      font-weight: 600;
      font-size: 16px;
    }
    
    .el-dialog__headerbtn {
      top: 20px;
      right: 20px;
      
      .el-dialog__close {
        color: #F5F7FB;
        font-size: 24px;
        font-weight: bold;
        
        &:hover {
          color: #5EA1FF;
        }
      }
    }
  }
  
  .el-dialog__body {
    padding: 16px 20px;
    background: #1B2435;
    max-height: 72vh;
    overflow-y: auto;
  }
  
  .el-card {
    border: 1px solid #2E3B55;
    background: #222D42;
    
    .el-card__header {
      background: #222D42;
      border-bottom: 2px solid #2E3B55;
      padding: 20px;
      color: #F5F7FB;
    }
    
    .el-card__body {
      padding: 20px;
      background: #222D42;
      color: #F5F7FB;
    }
  }
}
</style>

<style lang="scss">
/* el-tooltip 挂载在 body，与 scoped 分离 */
.device-dim-tooltip {
  max-width: 340px;
  line-height: 1.6;
  font-size: 12px;
}

.device-dim-tooltip .dim-tooltip-body {
  text-align: left;
}
</style>
