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
                    <span class="info-label">记录</span>
                    <span class="info-value highlight-count">{{ device.totalCount || 0 }}</span>
                    <span class="info-meta">{{ Object.keys(device.tableCounts || {}).filter(k => device.tableCounts[k] > 0).length }}/15 表</span>
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
                <div class="info-label">设备ID</div>
                <div class="info-value highlight">{{ selectedDevice.deviceId }}</div>
              </div>
            </el-col>
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
                  暂无数据
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
import { listDeviceStatus } from '@/api/equipment/deviceStatus'

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
      collapseActiveNames: []
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
          this.originalDeviceData = response.data.devices || []
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
        'eq_device_rule': '设备规则'
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
      this.dataTabs = [
        {
          name: 'deviceStatus',
          label: '设备状态',
          api: (id) => listDeviceStatus({ deviceId: id }),
          columns: [
            { prop: 'deviceId', label: '设备ID', width: 100 },
            { prop: 'timestamp', label: '采集时间', width: 180 },
            { prop: 'temperature', label: '温度(℃)', width: 100 },
            { prop: 'humidity', label: '湿度(%)', width: 100 },
            { prop: 'pressure', label: '压力(Pa)', width: 120 },
            { prop: 'current', label: '电流(A)', width: 100 },
            { prop: 'voltage', label: '电压(V)', width: 100 },
            { prop: 'power', label: '功率(kW)', width: 100 },
            { prop: 'status', label: '状态', width: 100 }
          ],
          data: [],
          loading: false
        },
        {
          name: 'deviceParam',
          label: '设备参数',
          api: listDeviceParamByDeviceId,
          columns: [
            { prop: 'paramId', label: '参数ID', width: 100 },
            { prop: 'deviceId', label: '设备ID', width: 100 },
            { prop: 'parameterName', label: '参数名称', width: 150 },
            { prop: 'parameterValue', label: '参数值', width: 120 },
            { prop: 'unit', label: '单位', width: 80 },
            { prop: 'defaultValue', label: '默认值', width: 120 },
            { prop: 'minValue', label: '最小值', width: 120 },
            { prop: 'maxValue', label: '最大值', width: 120 },
            { prop: 'criticalThreshold', label: '临界阈值', width: 120 },
            { prop: 'warningThreshold', label: '警告阈值', width: 120 }
          ],
          data: [],
          loading: false
        },
        {
          name: 'deviceStat',
          label: '统计数据',
          api: listDeviceStatByDeviceId,
          columns: [
            { prop: 'statId', label: '统计ID', width: 100 },
            { prop: 'deviceId', label: '设备ID', width: 100 },
            { prop: 'statDate', label: '统计日期', width: 150 },
            { prop: 'totalRuntimeHours', label: '总运行时间(小时)', width: 150 },
            { prop: 'totalFaultCount', label: '总故障次数', width: 120 },
            { prop: 'totalMaintenanceCount', label: '总维护次数', width: 130 },
            { prop: 'averageTemperature', label: '平均温度(℃)', width: 130 },
            { prop: 'uptimePercentage', label: '运行率(%)', width: 120 },
            { prop: 'faultRatePerHour', label: '故障率(/小时)', width: 140 }
          ],
          data: [],
          loading: false
        },
        {
          name: 'maintenanceRecord',
          label: '维护记录',
          api: listMaintenanceRecordByDeviceId,
          columns: [
            { prop: 'recordId', label: '记录ID', width: 100 },
            { prop: 'deviceId', label: '设备ID', width: 100 },
            { prop: 'maintenanceDate', label: '维护日期', width: 150 },
            { prop: 'maintenanceType', label: '维护类型', width: 120 },
            { prop: 'maintenancePerson', label: '维护人员', width: 120 },
            { prop: 'maintenanceCost', label: '维护费用', width: 120 },
            { prop: 'maintenanceDescription', label: '维护描述', minWidth: 200 }
          ],
          data: [],
          loading: false
        },
        {
          name: 'alertRecord',
          label: '告警记录',
          api: listAlertRecordByDeviceId,
          columns: [
            { prop: 'alertId', label: '告警ID', width: 100 },
            { prop: 'deviceId', label: '设备ID', width: 100 },
            { prop: 'alertTime', label: '告警时间', width: 180 },
            { prop: 'alertLevel', label: '告警级别', width: 120 },
            { prop: 'alertType', label: '告警类型', width: 120 },
            { prop: 'alertMessage', label: '告警信息', minWidth: 200 },
            { prop: 'alertStatus', label: '告警状态', width: 120 }
          ],
          data: [],
          loading: false
        },
        {
          name: 'environmentData',
          label: '环境数据',
          api: listEnvironmentDataByDeviceId,
          columns: [
            { prop: 'envId', label: '环境ID', width: 100 },
            { prop: 'deviceId', label: '设备ID', width: 100 },
            { prop: 'timestamp', label: '时间戳', width: 180 },
            { prop: 'temperature', label: '温度(℃)', width: 120 },
            { prop: 'humidity', label: '湿度(%)', width: 120 },
            { prop: 'pressure', label: '压力(Pa)', width: 120 },
            { prop: 'airQuality', label: '空气质量', width: 120 },
            { prop: 'noiseLevel', label: '噪音水平(dB)', width: 140 }
          ],
          data: [],
          loading: false
        },
        {
          name: 'economicData',
          label: '经济数据',
          api: listEconomicDataByDeviceId,
          columns: [
            { prop: 'economicId', label: '经济ID', width: 100 },
            { prop: 'deviceId', label: '设备ID', width: 100 },
            { prop: 'timestamp', label: '时间戳', width: 180 },
            { prop: 'energyCost', label: '能耗成本', width: 120 },
            { prop: 'maintenanceCost', label: '维护成本', width: 120 },
            { prop: 'operatingCost', label: '运营成本', width: 120 },
            { prop: 'totalCost', label: '总成本', width: 120 }
          ],
          data: [],
          loading: false
        },
        {
          name: 'electricalData',
          label: '电气数据',
          api: listElectricalDataByDeviceId,
          columns: [
            { prop: 'electricalId', label: '电气ID', width: 100 },
            { prop: 'deviceId', label: '设备ID', width: 100 },
            { prop: 'timestamp', label: '时间戳', width: 180 },
            { prop: 'voltage', label: '电压(V)', width: 120 },
            { prop: 'current', label: '电流(A)', width: 120 },
            { prop: 'power', label: '功率(kW)', width: 120 },
            { prop: 'frequency', label: '频率(Hz)', width: 120 },
            { prop: 'powerFactor', label: '功率因数', width: 120 }
          ],
          data: [],
          loading: false
        },
        {
          name: 'technologyData',
          label: '技术数据',
          api: listTechnologyDataByDeviceId,
          columns: [
            { prop: 'techId', label: '技术ID', width: 100 },
            { prop: 'deviceId', label: '设备ID', width: 100 },
            { prop: 'timestamp', label: '时间戳', width: 180 },
            { prop: 'technologyType', label: '技术类型', width: 150 },
            { prop: 'technologyValue', label: '技术值', width: 150 },
            { prop: 'technologyUnit', label: '技术单位', width: 130 }
          ],
          data: [],
          loading: false
        },
        {
          name: 'mechanicalData',
          label: '机械数据',
          api: listMechanicalDataByDeviceId,
          columns: [
            { prop: 'mechanicalId', label: '机械ID', width: 100 },
            { prop: 'deviceId', label: '设备ID', width: 100 },
            { prop: 'timestamp', label: '时间戳', width: 180 },
            { prop: 'vibration', label: '振动(mm/s)', width: 140 },
            { prop: 'rpm', label: '转速(rpm)', width: 120 },
            { prop: 'torque', label: '扭矩(N·m)', width: 120 },
            { prop: 'temperature', label: '温度(℃)', width: 120 }
          ],
          data: [],
          loading: false
        },
        {
          name: 'operationalData',
          label: '操作数据',
          api: listOperationalDataByDeviceId,
          columns: [
            { prop: 'operationalId', label: '操作ID', width: 100 },
            { prop: 'deviceId', label: '设备ID', width: 100 },
            { prop: 'timestamp', label: '时间戳', width: 180 },
            { prop: 'operationType', label: '操作类型', width: 150 },
            { prop: 'operationValue', label: '操作值', width: 150 },
            { prop: 'operator', label: '操作员', width: 120 }
          ],
          data: [],
          loading: false
        },
        {
          name: 'sensor',
          label: '传感器',
          api: listSensorByDeviceId,
          columns: [
            { prop: 'sensorId', label: '传感器ID', width: 120 },
            { prop: 'deviceId', label: '设备ID', width: 100 },
            { prop: 'sensorType', label: '传感器类型', width: 150 },
            { prop: 'sensorValue', label: '传感器值', width: 150 },
            { prop: 'sensorUnit', label: '传感器单位', width: 140 },
            { prop: 'sensorStatus', label: '传感器状态', width: 130 }
          ],
          data: [],
          loading: false
        },
        {
          name: 'climateData',
          label: '气候数据',
          api: listClimateDataByDeviceId,
          columns: [
            { prop: 'climateId', label: '气候ID', width: 100 },
            { prop: 'deviceId', label: '设备ID', width: 100 },
            { prop: 'timestamp', label: '时间戳', width: 180 },
            { prop: 'season', label: '季节', width: 100 },
            { prop: 'weatherCondition', label: '天气状况', width: 150 },
            { prop: 'precipitation', label: '降水量(mm)', width: 130 },
            { prop: 'windSpeed', label: '风速(m/s)', width: 130 },
            { prop: 'temperature', label: '温度(℃)', width: 120 }
          ],
          data: [],
          loading: false
        },
        {
          name: 'faultRecord',
          label: '故障记录',
          api: listFaultRecordByDeviceId,
          columns: [
            { prop: 'faultId', label: '故障ID', width: 100 },
            { prop: 'deviceId', label: '设备ID', width: 100 },
            { prop: 'faultTime', label: '故障时间', width: 180 },
            { prop: 'faultType', label: '故障类型', width: 150 },
            { prop: 'faultDescription', label: '故障描述', minWidth: 200 },
            { prop: 'faultStatus', label: '故障状态', width: 120 },
            { prop: 'repairTime', label: '修复时间', width: 180 }
          ],
          data: [],
          loading: false
        },
        {
          name: 'deviceRule',
          label: '设备规则',
          api: listDeviceRuleByDeviceId,
          columns: [
            { prop: 'ruleId', label: '规则ID', width: 100 },
            { prop: 'deviceId', label: '设备ID', width: 100 },
            { prop: 'ruleName', label: '规则名称', width: 200 },
            { prop: 'ruleType', label: '规则类型', width: 150 },
            { prop: 'ruleCondition', label: '规则条件', minWidth: 200 },
            { prop: 'ruleAction', label: '规则动作', minWidth: 200 },
            { prop: 'ruleStatus', label: '规则状态', width: 120 }
          ],
          data: [],
          loading: false
        }
      ]
    },
    handleTabClick(tab) {
      // 标签页切换，不做任何操作，数据已全部加载
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
        '设备规则': 'eq_device_rule'
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
  margin-bottom: 16px;

  .dashboard-title {
    color: $text-primary;
    font-size: 18px;
    font-weight: 600;
    margin: 0;
  }
}

.stats-row {
  margin-bottom: 16px;
}

.stat-card {
  background: $primary-bg;
  border: 1px solid $border-color;
  border-left: 3px solid $text-disabled;
  padding: 12px 14px;
  margin-bottom: 0;

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

      &:hover {
        background: $primary-bg;
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
          color: $text-primary;
          flex: 1;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
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
            padding-top: 6px;
            border-top: 1px solid $border-color;
            align-items: baseline;
            gap: 6px;

            .info-label {
              width: 36px;
            }

            .info-meta {
              font-size: 11px;
              color: $text-disabled;
              flex-shrink: 0;
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
