<template>
  <div class="app-container">
    <!-- 查询区 -->
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" label-width="120px">
      <el-form-item label="时间窗">
        <el-date-picker
          v-model="dateRange"
          type="datetimerange"
          range-separator="至"
          start-placeholder="开始时间"
          end-placeholder="结束时间"
          value-format="yyyy-MM-dd HH:mm:ss"
          style="width: 360px"
        />
      </el-form-item>
      <el-form-item label="点编码（可选）">
        <el-select
          v-model="queryParams.pointCode"
          filterable
          clearable
          placeholder="选择点编码（或不选全部）"
          style="width: 260px"
        >
          <el-option v-for="p in openPoints" :key="p.pointCode" :label="p.pointCode" :value="p.pointCode" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">查询汇总</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="handleReset">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 快速统计 -->
    <el-row :gutter="10" style="margin-top: 10px;">
      <el-col :span="6">
        <el-card shadow="hover">
          <div style="font-size: 14px; color: #606266;">采样点数量</div>
          <div style="font-size: 26px; margin-top: 6px; font-weight: 600;">{{ summaryStats.samplePoints || 0 }}</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <div style="font-size: 14px; color: #606266;">总样本数</div>
          <div style="font-size: 26px; margin-top: 6px; font-weight: 600;">{{ summaryStats.sampleCount || 0 }}</div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 汇总表 -->
    <el-table v-loading="loading" :data="rows" border style="margin-top: 15px;">
      <el-table-column label="点编码" prop="pointCode" align="center" min-width="120" />
      <el-table-column label="点名称" prop="pointName" align="center" min-width="160" />
      <el-table-column label="单位" prop="unit" align="center" min-width="80" />
      <el-table-column label="样本数" prop="sampleCount" align="center" min-width="90" />
      <el-table-column label="最小值" prop="minValue" align="center" min-width="120" :show-overflow-tooltip="true" />
      <el-table-column label="最大值" prop="maxValue" align="center" min-width="120" :show-overflow-tooltip="true" />
      <el-table-column label="平均值" prop="avgValue" align="center" min-width="120" :show-overflow-tooltip="true" />
      <el-table-column label="最后采样时间" prop="lastReadTime" align="center" min-width="170" :show-overflow-tooltip="true" />
    </el-table>
  </div>
</template>

<script>
import { getOpenMeterPoints, getOpenMeterSummary } from '@/api/meter/openApi'

export default {
  name: 'MeterSummary',
  data() {
    return {
      loading: false,
      openPoints: [],
      rows: [],
      dateRange: [],
      queryParams: {
        pointCode: undefined
      },
      summaryStats: {
        samplePoints: 0,
        sampleCount: 0
      }
    }
  },
  created() {
    this.loadOpenPoints()
    this.initDefaultRange()
  },
  methods: {
    initDefaultRange() {
      // 默认：最近 1 小时
      const now = new Date()
      const start = new Date(now.getTime() - 3600 * 1000)
      this.dateRange = [this.formatDateTime(start), this.formatDateTime(now)]
      this.handleQuery()
    },
    formatDateTime(d) {
      const pad = (n) => String(n).padStart(2, '0')
      return (
        d.getFullYear() +
        '-' +
        pad(d.getMonth() + 1) +
        '-' +
        pad(d.getDate()) +
        ' ' +
        pad(d.getHours()) +
        ':' +
        pad(d.getMinutes()) +
        ':' +
        pad(d.getSeconds())
      )
    },
    handleReset() {
      this.queryParams.pointCode = undefined
      this.initDefaultRange()
    },
    loadOpenPoints() {
      getOpenMeterPoints().then(res => {
        if (res && res.code === 200) {
          this.openPoints = res.data || []
        } else if (res && res.data) {
          this.openPoints = res.data || []
        }
      }).catch(() => {})
    },
    handleQuery() {
      const beginTime = this.dateRange && this.dateRange.length >= 2 ? this.dateRange[0] : undefined
      const endTime = this.dateRange && this.dateRange.length >= 2 ? this.dateRange[1] : undefined
      if (!beginTime || !endTime) {
        this.$modal && this.$modal.msgWarning && this.$modal.msgWarning('请先选择时间窗')
        return
      }

      this.loading = true
      const params = {
        beginTime,
        endTime,
        pointCode: this.queryParams.pointCode || undefined
      }
      getOpenMeterSummary(params).then(res => {
        if (res && res.code === 200) {
          const body = res.data || {}
          this.rows = body.rows || []
          const points = this.rows.length
          const total = (this.rows || []).reduce((acc, r) => acc + (Number(r.sampleCount) || 0), 0)
          this.summaryStats.samplePoints = points
          this.summaryStats.sampleCount = total
        } else {
          this.rows = []
        }
      }).catch(() => {
        this.rows = []
      }).finally(() => {
        this.loading = false
      })
    }
  }
}
</script>

<style scoped>
.app-container {
  padding: 20px;
}
</style>

