<template>
  <div class="app-container power-forecast-page">
    <el-tabs v-model="activeTab" type="border-card">
      <el-tab-pane label="实时预测" name="wind">
        <input
          ref="excelUploadFeature"
          type="file"
          accept=".xlsx,.xls"
          class="hidden-file-input"
          @change="onServerExcelUpload($event, 'feature')"
        />
        <input
          ref="excelUploadReal"
          type="file"
          accept=".xlsx,.xls"
          class="hidden-file-input"
          @change="onServerExcelUpload($event, 'real')"
        />
        <input
          ref="modelUpload"
          type="file"
          accept=".h5"
          class="hidden-file-input"
          @change="onModelUpload"
        />
        <div class="wind-toolbar-compact">
          <el-button type="primary" size="small" icon="el-icon-video-play" :loading="runLoading" @click="handleRunNow">
            立即预测
          </el-button>
          <el-button size="small" icon="el-icon-refresh" :loading="latestLoading" @click="refreshForecastLatest">刷新</el-button>
          <el-button size="small" icon="el-icon-document" :loading="summaryLoading" @click="handleAiSummary">AI</el-button>
          <el-switch v-model="autoRefresh" class="wind-auto-switch" />
          <span class="wind-poll-interval">
            <span class="wind-poll-label">刷新间隔</span>
            <el-input-number
              v-model="pollSec"
              :min="30"
              :max="3600"
              :step="60"
              size="small"
              controls-position="right"
              class="wind-poll-input"
              @change="handleClientPollSecChange"
            />
            <span class="wind-poll-unit">秒</span>
          </span>
          <el-tooltip content="先选设备：特征/功率按设备目录保存；未上传该设备 gru_FD.h5 时使用 application.yml 中的默认模型。立即预测对当前所选设备执行。" placement="bottom">
            <span class="wind-dev-tooltip-wrap">
          <el-select
            v-model="selectedWindDeviceId"
            clearable
            filterable
            placeholder="设备"
            size="small"
            class="wind-dev-select"
            @change="onWindDeviceChange"
          >
            <el-option
              v-for="item in deviceOptions"
              :key="item.deviceId"
              :label="formatWindDeviceLabel(item)"
              :value="item.deviceId"
            />
          </el-select>
            </span>
          </el-tooltip>
          <el-button
            size="small"
            plain
            :disabled="!selectedWindDeviceId"
            :loading="excelDownloadLoading.feature"
            icon="el-icon-download"
            @click="handleDownloadExcel('feature')"
          >导出特征</el-button>
          <el-button
            size="small"
            plain
            :disabled="!selectedWindDeviceId"
            :loading="excelUploadLoading.feature"
            icon="el-icon-upload2"
            @click="$refs.excelUploadFeature.click()"
          >上传特征</el-button>
          <el-button
            size="small"
            plain
            :disabled="!selectedWindDeviceId"
            :loading="excelDownloadLoading.real"
            icon="el-icon-download"
            @click="handleDownloadExcel('real')"
          >导出功率</el-button>
          <el-button
            size="small"
            plain
            :disabled="!selectedWindDeviceId"
            :loading="excelUploadLoading.real"
            icon="el-icon-upload2"
            @click="$refs.excelUploadReal.click()"
          >上传功率</el-button>
          <el-button
            size="small"
            plain
            type="warning"
            :disabled="!selectedWindDeviceId"
            :loading="modelUploadLoading"
            icon="el-icon-folder-add"
            @click="$refs.modelUpload.click()"
          >上传模型</el-button>
        </div>

        <el-card v-if="aiSummaryText" shadow="never" class="summary-card">
          <div slot="header">AI 总结</div>
          <div class="summary-body">{{ aiSummaryText }}</div>
        </el-card>

        <el-card shadow="never" class="chart-card chart-card-plain">
          <div ref="chartRef" class="chart-box" />
          <el-empty v-if="!hasSeries" description="暂无数据" />
        </el-card>
      </el-tab-pane>

      <el-tab-pane label="预测记录" name="data">
        <el-form size="small" :inline="true" class="data-toolbar">
          <el-form-item label="设备">
            <el-select
              v-model="dataTableDeviceId"
              clearable
              filterable
              placeholder="全部"
              style="width: 220px"
              @change="loadForecastRecordPanels"
            >
              <el-option
                v-for="item in deviceOptions"
                :key="item.deviceId"
                :label="formatWindDeviceLabel(item)"
                :value="item.deviceId"
              />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="el-icon-refresh" @click="loadForecastRecordPanels">刷新</el-button>
          </el-form-item>
        </el-form>

        <el-card shadow="never" class="record-block-card">
          <div slot="header" class="record-card-header">
            <span>预测落库（eq_prediction）</span>
            <span class="record-card-sub">每次「立即预测」成功且后端开启落库后自动写入，供设备详情与报表使用</span>
          </div>
          <el-table
            v-loading="predictionHistoryLoading"
            :data="predictionHistoryRows"
            border
            size="small"
            class="data-stat-table"
            max-height="360"
            empty-text="暂无落库记录（请确认已选设备并点击「立即预测」，且 wind.forecast.persist-eq-prediction=true）"
          >
            <el-table-column label="预测时间" prop="predictionTime" min-width="160" show-overflow-tooltip />
            <el-table-column label="状态" width="88" align="center">
              <template slot-scope="scope">
                {{ formatPredStatus(scope.row.predictedStatus) }}
              </template>
            </el-table-column>
            <el-table-column label="置信度" prop="predictionConfidence" width="96" align="center" />
            <el-table-column label="风险" width="72" align="center">
              <template slot-scope="scope">
                {{ formatRiskLevel(scope.row.riskLevel) }}
              </template>
            </el-table-column>
            <el-table-column label="建议措施" prop="recommendedAction" min-width="200" show-overflow-tooltip />
          </el-table>
        </el-card>

        <el-card shadow="never" class="record-block-card">
          <div slot="header" class="record-card-header">
            <span>日统计（eq_device_stat · 风力预测写入）</span>
          </div>
          <el-table v-loading="dataLoading" :data="dataStatRows" border size="small" class="data-stat-table">
            <el-table-column label="设备" min-width="200" show-overflow-tooltip>
              <template slot-scope="scope">
                {{ windStatDeviceLabel(scope.row) }}
              </template>
            </el-table-column>
            <el-table-column label="统计日期" prop="statDate" min-width="120" />
            <el-table-column label="平均功率(kW)" prop="averagePower" min-width="120" />
            <el-table-column label="运行率(%)" prop="uptimePercentage" min-width="100" />
            <el-table-column label="区间时长(h)" prop="totalRuntimeHours" min-width="110" />
            <el-table-column label="操作" width="100" align="center" fixed="right">
              <template slot-scope="scope">
                <el-button
                  v-hasPermi="['equipment:deviceStat:remove']"
                  type="text"
                  size="small"
                  @click="handleDeleteStat(scope.row)"
                >删除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import * as echarts from 'echarts'
import { listDevice } from '@/api/equipment/device'
import { listDeviceStat, delDeviceStat } from '@/api/equipment/deviceStat'
import { saveAs } from 'file-saver'
import {
  downloadWindForecastExcel,
  getWindForecastLatest,
  runWindForecastNow,
  runWindForecastForDevice,
  uploadWindForecastExcel,
  uploadWindForecastModel,
  windForecastSummary
} from '@/api/windForecast'
import { getClientPollIntervalSec, setClientPollIntervalSec } from '@/utils/clientPoll'
import { listPrediction, listPredictionByDeviceId } from '@/api/equipment/prediction'

export default {
  name: 'PowerForecast',
  data() {
    return {
      activeTab: 'wind',
      latestLoading: false,
      runLoading: false,
      runDeviceLoading: false,
      summaryLoading: false,
      selectedWindDeviceId: undefined,
      _defaultDeviceApplied: false,
      excelDownloadLoading: { feature: false, real: false },
      excelUploadLoading: { feature: false, real: false },
      modelUploadLoading: false,
      aiSummaryText: '',
      autoRefresh: true,
      pollSec: 180,
      pollTimer: null,
      chart: null,
      windMeta: {
        reachable: false,
        lastPredictionAt: 0
      },
      prediction: {},
      deviceOptions: [],
      windBindDeviceId: null,
      windForecastConfig: {},
      dataStatRows: [],
      dataLoading: false,
      predictionHistoryRows: [],
      predictionHistoryLoading: false,
      dataTableDeviceId: undefined,
      _lastPredictionAtSeen: 0,
      _firstLatestLoaded: false,
      _suppressAutoPredictNotify: false
    }
  },
  computed: {
    pointIntervalMinutes() {
      const c = this.windForecastConfig || {}
      const v = c.forecastPointIntervalMinutes
      const n = v != null ? Number(v) : 15
      return Number.isFinite(n) && n > 0 ? n : 15
    },
    hasSeries() {
      const p = this.prediction || {}
      return Array.isArray(p.predicted_power) && p.predicted_power.length > 0
    },
    pointTimesList() {
      const p = this.prediction || {}
      return Array.isArray(p.point_times)
        ? p.point_times
        : Array.isArray(p.pointTimes)
          ? p.pointTimes
          : null
    },
  },
  created() {
    this.pollSec = getClientPollIntervalSec(180)
    this.loadDevices()
    this.loadLatest(false, false)
    this.startPoll()
  },
  mounted() {
    window.addEventListener('resize', this.resizeChart)
  },
  beforeDestroy() {
    this.stopPoll()
    window.removeEventListener('resize', this.resizeChart)
    if (this.chart) {
      this.chart.dispose()
      this.chart = null
    }
  },
  watch: {
    autoRefresh(val) {
      if (val) this.startPoll()
      else this.stopPoll()
    },
    prediction: {
      deep: true,
      handler() {
        this.$nextTick(() => this.renderChart())
      }
    },
    activeTab(tab) {
      if (tab === 'wind') {
        this.$nextTick(() => this.renderChart())
      }
      if (tab === 'data') {
        if (this.dataTableDeviceId == null && this.windBindDeviceId) {
          this.dataTableDeviceId = this.windBindDeviceId
        }
        this.loadForecastRecordPanels()
      }
    }
  },
  methods: {
    formatPredStatus(v) {
      const m = { 1: '正常', 2: '警告', 3: '错误', 4: '离线' }
      return m[v] != null ? m[v] : v == null || v === '' ? '—' : String(v)
    },
    formatRiskLevel(v) {
      const m = { 1: '低', 2: '中', 3: '高' }
      return m[v] != null ? m[v] : v == null || v === '' ? '—' : String(v)
    },
    formatWindDeviceLabel(item) {
      if (!item) return '设备'
      const name = item.deviceName || '设备'
      const no = item.deviceNo
      return no ? `${name}（${no}）` : name
    },
    windStatDeviceLabel(row) {
      if (!row) return '—'
      return this.formatWindDeviceLabel(row)
    },
    formatDateTime(d) {
      if (this.$parseTime) return this.$parseTime(d, '{y}-{m}-{d} {h}:{i}:{s}')
      const pad = (n) => (n < 10 ? '0' + n : '' + n)
      const x = d instanceof Date ? d : new Date(d)
      return `${x.getFullYear()}-${pad(x.getMonth() + 1)}-${pad(x.getDate())} ${pad(x.getHours())}:${pad(x.getMinutes())}:${pad(x.getSeconds())}`
    },
    formatDurationMinutes(totalMin) {
      const m = Math.round(Number(totalMin))
      if (!Number.isFinite(m) || m <= 0) return '—'
      if (m < 60) return `${m}分`
      const h = Math.floor(m / 60)
      const r = m % 60
      if (r === 0) return `${h}h`
      return `${h}h${r}m`
    },
    forecastStepLabel(indexZeroBased) {
      const step = this.pointIntervalMinutes
      const cum = (indexZeroBased + 1) * step
      const h = Math.floor(cum / 60)
      const mm = cum % 60
      if (h === 0) return `${mm}分`
      if (mm === 0) return `${h}h`
      return `${h}:${String(mm).padStart(2, '0')}`
    },
    formatAxisShortFromIso(isoStr) {
      if (!isoStr) return ''
      const d = new Date(isoStr)
      if (isNaN(d.getTime())) return String(isoStr)
      if (this.$parseTime) return this.$parseTime(d, '{y}-{m}-{d} {h}:{i}')
      const pad = (n) => (n < 10 ? '0' + n : '' + n)
      return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`
    },
    chartAxisLabel(indexZeroBased) {
      const pts = this.pointTimesList
      if (pts && pts[indexZeroBased]) {
        return this.formatAxisShortFromIso(pts[indexZeroBased])
      }
      return this.forecastStepLabel(indexZeroBased)
    },
    formatTooltipClock(isoStr) {
      if (!isoStr) return ''
      const d = new Date(isoStr)
      if (isNaN(d.getTime())) return String(isoStr)
      if (this.$parseTime) return this.$parseTime(d, '{y}-{m}-{d} {h}:{i}:{s}')
      return this.formatDateTime(d)
    },
    handleClientPollSecChange(val) {
      if (val == null) return
      setClientPollIntervalSec(val)
      this.pollSec = getClientPollIntervalSec(this.windForecastConfig.clientPollIntervalSec || 180)
      if (this.autoRefresh) {
        this.startPoll()
      }
    },
    startPoll() {
      this.stopPoll()
      if (!this.autoRefresh) return
      const sec = Math.max(30, Math.min(3600, Number(this.pollSec) || 180))
      this.pollTimer = setInterval(() => {
        this.loadLatest(true, false)
      }, sec * 1000)
    },
    stopPoll() {
      if (this.pollTimer) {
        clearInterval(this.pollTimer)
        this.pollTimer = null
      }
    },
    refreshForecastLatest() {
      this.loadLatest(false, true)
    },
    async loadLatest(silent, live) {
      if (live === undefined) live = false
      if (!silent) this.latestLoading = true
      try {
        const did =
          this.selectedWindDeviceId != null && this.selectedWindDeviceId !== ''
            ? this.selectedWindDeviceId
            : undefined
        const res = await getWindForecastLatest(did, { live: !!live })
        if (res.code === 200 && res.data) {
          const d = res.data
          this.windMeta.reachable = !!d.reachable
          this.windMeta.lastPredictionAt = d.lastPredictionAt || 0
          this.prediction = d.prediction || {}
          const cfg = d.config || {}
          this.windForecastConfig = { ...cfg }
          const srvPoll = cfg.clientPollIntervalSec != null ? cfg.clientPollIntervalSec : 180
          const nextPoll = getClientPollIntervalSec(srvPoll)
          if (nextPoll !== this.pollSec) {
            this.pollSec = nextPoll
            if (this.autoRefresh) {
              this.startPoll()
            }
          }
          const bid = cfg.bindDeviceId
          const bidStr = bid != null && String(bid).trim() !== '' ? String(bid).trim() : null
          this.windBindDeviceId = bidStr
          if (!this._defaultDeviceApplied && this.selectedWindDeviceId == null && this.windBindDeviceId) {
            this._defaultDeviceApplied = true
            this.selectedWindDeviceId = this.windBindDeviceId
          }
          this.syncWindDeviceSelectionWithOptions()
          const curAt = this.windMeta.lastPredictionAt || 0
          const prevAt = this._lastPredictionAtSeen || 0
          if (
            silent &&
            this._firstLatestLoaded &&
            curAt > prevAt &&
            prevAt > 0 &&
            !this._suppressAutoPredictNotify
          ) {
            this.$notify({
              title: '预测已更新',
              message: this.formatDateTime(new Date(curAt)),
              type: 'success',
              duration: 3800,
              position: 'bottom-right'
            })
          }
          this._firstLatestLoaded = true
          this._lastPredictionAtSeen = curAt
          this._suppressAutoPredictNotify = false
        }
      } catch (e) {
        if (!silent) this.$modal.msgError('获取预测数据失败')
      } finally {
        if (!silent) this.latestLoading = false
      }
    },
    async handleRunNow() {
      const id = this.selectedWindDeviceId
      const useDevice = id != null && id !== ''
      this.runLoading = true
      try {
        const res = useDevice
          ? await runWindForecastForDevice({ deviceId: id })
          : await runWindForecastNow()
        if (res.code === 200) {
          const body = res.data || {}
          if (body.success) {
            this.$modal.msgSuccess(useDevice ? '当前设备预测完成' : '预测完成（系统默认配置）')
            this._suppressAutoPredictNotify = true
            await this.loadLatest(false, false)
            this.syncDataTableDeviceFromSelection()
            await this.loadForecastRecordPanels()
            if (body.eq_prediction_persisted === false && body.eq_prediction_error) {
              this.$modal.msgWarning('曲线已更新，但写入预测库失败：' + body.eq_prediction_error)
            }
          } else {
            this.$modal.msgError(body.message || '预测失败')
          }
        } else {
          this.$modal.msgError(res.msg || '请求失败')
        }
      } catch (e) {
        this.$modal.msgError('预测请求失败')
      } finally {
        this.runLoading = false
      }
    },
    async handleRunForDevice() {
      const id = this.selectedWindDeviceId
      if (id == null || id === '') {
        this.$modal.msgWarning('请先选择预测设备')
        return
      }
      this.runDeviceLoading = true
      try {
        const res = await runWindForecastForDevice({ deviceId: id })
        if (res.code === 200) {
          const body = res.data || {}
          if (body.success) {
            this.$modal.msgSuccess('设备预测完成')
            this._suppressAutoPredictNotify = true
            await this.loadLatest(false, false)
            this.syncDataTableDeviceFromSelection()
            await this.loadForecastRecordPanels()
            if (body.eq_prediction_persisted === false && body.eq_prediction_error) {
              this.$modal.msgWarning('曲线已更新，但写入预测库失败：' + body.eq_prediction_error)
            }
          } else {
            this.$modal.msgError(body.message || '预测失败')
          }
        } else {
          this.$modal.msgError(res.msg || '请求失败')
        }
      } catch (e) {
        this.$modal.msgError('预测请求失败')
      } finally {
        this.runDeviceLoading = false
      }
    },
    async handleAiSummary() {
      this.summaryLoading = true
      try {
        const id =
          this.selectedWindDeviceId != null && this.selectedWindDeviceId !== ''
            ? this.selectedWindDeviceId
            : undefined
        const res = await windForecastSummary({ deviceId: id })
        if (res.code === 200) {
          const d = res.data
          let text = ''
          if (typeof d === 'string') {
            text = d.trim()
          } else if (d != null && typeof d === 'object' && typeof d.summary === 'string') {
            text = d.summary.trim()
          } else if (d != null && typeof d !== 'object') {
            text = String(d).trim()
          }
          this.aiSummaryText =
            text || (res.msg && res.msg !== '操作成功' ? res.msg : '请先完成预测后再试。')
        } else {
          this.$modal.msgError(res.msg || '总结失败')
        }
      } catch (e) {
        this.$modal.msgError('总结请求失败')
      } finally {
        this.summaryLoading = false
      }
    },
    onWindDeviceChange() {
      this.aiSummaryText = ''
      this.loadLatest(false, false)
    },
    async handleDownloadExcel(kind) {
      const id = this.selectedWindDeviceId
      if (id == null || id === '') {
        this.$modal.msgWarning('请先选择设备')
        return
      }
      this.excelDownloadLoading[kind] = true
      try {
        const blob = await downloadWindForecastExcel(id, kind)
        const name =
          kind === 'feature' ? `特征表_device${id}.xlsx` : `实际功率表_device${id}.xlsx`
        saveAs(blob, name)
        this.$modal.msgSuccess('已导出到本地')
      } catch (e) {
        this.$modal.msgError(e.message || '导出失败')
      } finally {
        this.excelDownloadLoading[kind] = false
      }
    },
    uploadExcelErrorMessage(err) {
      const d = err && err.response && err.response.data
      if (!d) {
        return (err && err.message) || '上传失败'
      }
      if (typeof d === 'string') {
        return d
      }
      if (typeof d.msg === 'string' && d.msg) {
        return d.msg
      }
      return '上传失败'
    },
    async onServerExcelUpload(ev, kind) {
      const input = ev && ev.target
      const file = input && input.files && input.files[0]
      if (input) input.value = ''
      if (!file) return
      const lower = (file.name || '').toLowerCase()
      if (!lower.endsWith('.xlsx') && !lower.endsWith('.xls')) {
        this.$modal.msgWarning('请上传 .xlsx 或 .xls 文件')
        return
      }
      const id = this.selectedWindDeviceId
      if (id == null || id === '') {
        this.$modal.msgWarning('请先选择设备')
        return
      }
      this.excelUploadLoading[kind] = true
      try {
        const res = await uploadWindForecastExcel(id, kind, file)
        if (res.code === 200) {
          const saved = res.data && res.data.savedPath
          this.$modal.msgSuccess(
            saved
              ? `${kind === 'feature' ? '特征表' : '实际功率表'}已写入设备目录，正在按该设备重新预测…`
              : kind === 'feature'
                ? '特征表已保存，正在重新预测…'
                : '实际功率表已保存，正在重新预测…'
          )
          if (saved) {
            this.$notify({
              title: '保存路径',
              message: saved,
              type: 'success',
              duration: 6000,
              position: 'bottom-right'
            })
          }
          this._suppressAutoPredictNotify = true
          await this.handleRunForDevice()
        } else {
          this.$modal.msgError(res.msg || '上传失败')
        }
      } catch (e) {
        this.$modal.msgError(this.uploadExcelErrorMessage(e))
      } finally {
        this.excelUploadLoading[kind] = false
      }
    },
    async onModelUpload(ev) {
      const input = ev && ev.target
      const file = input && input.files && input.files[0]
      if (input) input.value = ''
      if (!file) return
      const id = this.selectedWindDeviceId
      if (id == null || id === '') {
        this.$modal.msgWarning('请先选择设备')
        return
      }
      this.modelUploadLoading = true
      try {
        const res = await uploadWindForecastModel(id, file)
        if (res.code === 200) {
          const saved = res.data && res.data.savedPath
          this.$modal.msgSuccess('模型已保存到该设备目录')
          if (saved) {
            this.$notify({
              title: '模型路径',
              message: saved,
              type: 'success',
              duration: 6000,
              position: 'bottom-right'
            })
          }
          this._suppressAutoPredictNotify = true
          await this.handleRunForDevice()
        } else {
          this.$modal.msgError(res.msg || '上传失败')
        }
      } catch (e) {
        this.$modal.msgError('上传失败')
      } finally {
        this.modelUploadLoading = false
      }
    },
    renderChart() {
      if (!this.$refs.chartRef || !this.hasSeries) {
        if (this.chart) {
          this.chart.clear()
        }
        return
      }
      const pred = this.prediction.predicted_power || []
      const real = this.realSeriesAligned(pred.length)
      const x = pred.map((_, i) => this.chartAxisLabel(i))
      const tickStep = Math.max(1, Math.floor(pred.length / 6))
      const axisMuted = '#B4BAC7'
      const axisStrong = '#F5F7FB'
      const cmpLen =
        this.prediction.compare_length != null ? Number(this.prediction.compare_length) : pred.length
      const fut = this.prediction.future_points != null ? Number(this.prediction.future_points) : 0
      const markLineData =
        fut > 0 && cmpLen > 0 && cmpLen < pred.length && x[cmpLen]
          ? [{ xAxis: x[cmpLen], label: { formatter: '无实测', color: axisMuted, fontSize: 10 } }]
          : []
      if (!this.chart) {
        this.chart = echarts.init(this.$refs.chartRef, null, { renderer: 'canvas' })
      }
      this.chart.setOption({
        textStyle: { color: axisStrong },
        tooltip: {
          trigger: 'axis',
          backgroundColor: 'rgba(36, 41, 56, 0.96)',
          borderColor: '#2D3548',
          textStyle: { color: axisStrong },
          formatter: (params) => {
            if (!params || !params.length) return ''
            const idx = params[0].dataIndex
            const pts = this.pointTimesList
            const iso = pts ? pts[idx] : null
            const cumMin = (idx + 1) * this.pointIntervalMinutes
            const head = iso
              ? `${this.formatTooltipClock(iso)} · #${idx + 1}`
              : `${this.formatDurationMinutes(cumMin)} · #${idx + 1}`
            const lines = params.map((p) => `${p.marker}${p.seriesName} ${p.data}`)
            return `${head}<br/>` + lines.join('<br/>')
          }
        },
        legend: {
          data: ['预测', '实际'],
          top: 8,
          textStyle: { color: axisStrong, fontSize: 12, fontWeight: 600 },
          itemWidth: 18,
          itemGap: 20
        },
        grid: { left: '52px', right: '4%', top: 48, bottom: 52, containLabel: true },
        xAxis: {
          type: 'category',
          boundaryGap: false,
          data: x,
          axisLabel: {
            interval: tickStep - 1,
            rotate: 0,
            color: axisMuted,
            fontSize: 10,
            hideOverlap: true
          },
          axisLine: { lineStyle: { color: '#3D4A63' } },
          axisTick: { lineStyle: { color: '#3D4A63' } }
        },
        yAxis: {
          type: 'value',
          name: 'kW',
          nameTextStyle: { color: axisStrong, fontSize: 12, padding: [0, 0, 0, 8] },
          axisLabel: { color: axisMuted, fontSize: 11 },
          axisLine: { show: true, lineStyle: { color: '#3D4A63' } },
          splitLine: { lineStyle: { color: 'rgba(255,255,255,0.08)' } }
        },
        series: [
          {
            name: '预测',
            type: 'line',
            smooth: true,
            data: pred,
            itemStyle: { color: '#5B8DEF' },
            lineStyle: { width: 2 },
            markLine:
              markLineData.length > 0
                ? {
                    symbol: 'none',
                    lineStyle: { type: 'dashed', color: 'rgba(255,255,255,0.35)' },
                    data: markLineData
                  }
                : undefined
          },
          {
            name: '实际',
            type: 'line',
            smooth: true,
            connectNulls: false,
            data: real,
            itemStyle: { color: '#5FD68A' },
            lineStyle: { width: 2 }
          }
        ]
      }, true)
    },
    realSeriesAligned(len) {
      const r = (this.prediction && this.prediction.real_power) || []
      if (r.length === len) {
        return r.map((v) => (v === null || v === undefined ? null : v))
      }
      if (r.length > len) return r.slice(0, len).map((v) => (v === null || v === undefined ? null : v))
      const out = r.map((v) => (v === null || v === undefined ? null : v))
      while (out.length < len) out.push(null)
      return out
    },
    syncDataTableDeviceFromSelection() {
      const id = this.selectedWindDeviceId || this.windBindDeviceId
      if (id != null && id !== '') {
        this.dataTableDeviceId = id
      }
    },
    async loadForecastRecordPanels() {
      await Promise.all([this.loadDataRecords(), this.loadPredictionHistory()])
    },
    async loadPredictionHistory() {
      this.predictionHistoryLoading = true
      try {
        if (this.dataTableDeviceId != null && this.dataTableDeviceId !== '') {
          const res = await listPredictionByDeviceId(this.dataTableDeviceId)
          this.predictionHistoryRows = res && res.code === 200 && Array.isArray(res.data) ? res.data : []
        } else {
          const res = await listPrediction({ pageNum: 1, pageSize: 200 })
          this.predictionHistoryRows = res && res.rows ? res.rows : []
        }
      } catch (e) {
        this.predictionHistoryRows = []
      } finally {
        this.predictionHistoryLoading = false
      }
    },
    async loadDataRecords() {
      this.dataLoading = true
      try {
        const q = { pageNum: 1, pageSize: 10000, windForecastOnly: true }
        if (this.dataTableDeviceId != null && this.dataTableDeviceId !== '') {
          q.deviceId = this.dataTableDeviceId
        }
        const res = await listDeviceStat(q)
        this.dataStatRows = (res && res.rows) || []
      } finally {
        this.dataLoading = false
      }
    },
    handleDeleteStat(row) {
      const id = row && row.statId
      if (id == null) return
      this.$modal
        .confirm('确认删除该条设备统计记录？删除后不可恢复。')
        .then(() => delDeviceStat(id))
        .then(() => {
          this.$modal.msgSuccess('已删除')
          this.loadForecastRecordPanels()
        })
        .catch(() => {})
    },
    resizeChart() {
      if (this.chart) this.chart.resize()
    },
    async loadDevices() {
      const res = await listDevice({ pageNum: 1, pageSize: 1000 })
      this.deviceOptions = (res && res.rows) || []
      this.syncWindDeviceSelectionWithOptions()
    },
    /** 当前选中设备若已在库中删除，下拉会只显示数字；纠正为 bind 设备或列表首项 */
    syncWindDeviceSelectionWithOptions() {
      const rows = this.deviceOptions || []
      if (!rows.length) {
        return
      }
      const ids = new Set(rows.map((d) => String(d.deviceId)))
      const cur =
        this.selectedWindDeviceId != null && this.selectedWindDeviceId !== ''
          ? String(this.selectedWindDeviceId)
          : ''
      if (!cur) {
        return
      }
      if (ids.has(cur)) {
        return
      }
      const bid =
        this.windBindDeviceId != null && this.windBindDeviceId !== ''
          ? String(this.windBindDeviceId)
          : ''
      if (bid && ids.has(bid)) {
        this.selectedWindDeviceId = bid
        return
      }
      this.selectedWindDeviceId = rows[0].deviceId
    },
  }
}
</script>

<style lang="scss" scoped>
@import "~@/assets/styles/variables.scss";

.power-forecast-page {
  background: transparent;
  color: $text-primary;

  :deep(.el-tabs--border-card) {
    background: $secondary-bg !important;
    border-color: $border-color !important;
  }

  :deep(.el-card) {
    background: $secondary-bg !important;
    border-color: $border-color !important;
    color: $text-primary !important;

    .el-card__header {
      background: $primary-bg !important;
      border-bottom-color: $border-color !important;
      color: $text-primary !important;
    }

    .el-card__body {
      background: $secondary-bg !important;
      color: $text-primary !important;
    }
  }

  :deep(.el-empty__description p) {
    color: $text-secondary !important;
  }

  .wind-toolbar-compact {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 8px;
    margin-bottom: 8px;
  }
  .wind-auto-switch {
    margin: 0 2px;
  }
  .wind-poll-interval {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-size: 12px;
    color: $text-secondary;
    .wind-poll-label {
      white-space: nowrap;
    }
    .wind-poll-input {
      width: 112px;
    }
    .wind-poll-unit {
      white-space: nowrap;
    }
  }
  .wind-dev-tooltip-wrap {
    display: inline-flex;
    align-items: center;
  }
  .wind-dev-select {
    width: 220px;
    min-width: 160px;
  }
  .hidden-file-input {
    position: absolute;
    width: 0;
    height: 0;
    opacity: 0;
    pointer-events: none;
  }
  .summary-card {
    margin-bottom: 12px;
    .summary-body {
      font-size: 14px;
      line-height: 1.65;
      color: $text-primary;
      white-space: pre-wrap;
    }
  }
  .data-toolbar {
    margin-bottom: 10px;
  }
  .chart-card {
    .sub {
      margin-left: 12px;
      color: $text-secondary;
      font-size: 13px;
    }
  }
  .chart-card-plain {
    :deep(.el-card__header) {
      display: none;
    }
    :deep(.el-card__body) {
      padding: 12px;
    }
  }
  .chart-box {
    width: 100%;
    height: 420px;
  }
  .mb12 {
    margin-bottom: 12px;
  }
}
</style>
