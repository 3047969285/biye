<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" label-width="80px">
      <el-form-item label="设备" prop="deviceId">
        <device-select
          :value="queryParams.deviceId"
          placeholder="请选择设备（数据获取共用）"
          clearable
          style="width: 260px"
          @input="handleDataAcquisitionDeviceChange"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="small" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="small" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="dataList">
      <el-table-column label="统计ID" align="center" prop="statId" min-width="90">
        <template slot-scope="scope">
          {{ scope.row.statId != null ? scope.row.statId : '—' }}
        </template>
      </el-table-column>
      <el-table-column label="设备编号" align="center" prop="deviceNo" min-width="140" show-overflow-tooltip>
        <template slot-scope="scope">
          {{ scope.row.deviceNo || '-' }}
        </template>
      </el-table-column>
      <el-table-column label="设备名称" align="center" prop="deviceName" min-width="132" show-overflow-tooltip>
        <template slot-scope="scope">
          {{ scope.row.deviceName || '-' }}
        </template>
      </el-table-column>
      <el-table-column label="汇总时间" align="center" prop="statDate" min-width="170" show-overflow-tooltip>
        <template slot-scope="scope">
          {{ formatDateTimeDisplay(scope.row.statDate) }}
        </template>
      </el-table-column>
      <el-table-column label="总运行时间(小时)" align="center" prop="totalRuntimeHours" min-width="140">
        <template slot-scope="scope">{{ formatStatNum(scope.row.totalRuntimeHours) }}</template>
      </el-table-column>
      <el-table-column label="总故障次数" align="center" prop="totalFaultCount" min-width="120">
        <template slot-scope="scope">{{ formatStatInt(scope.row.totalFaultCount) }}</template>
      </el-table-column>
      <el-table-column label="总维护次数" align="center" prop="totalMaintenanceCount" min-width="120">
        <template slot-scope="scope">{{ formatStatInt(scope.row.totalMaintenanceCount) }}</template>
      </el-table-column>
      <el-table-column label="平均温度(°C)" align="center" prop="averageTemperature" min-width="120">
        <template slot-scope="scope">{{ formatStatNum(scope.row.averageTemperature) }}</template>
      </el-table-column>
      <el-table-column label="运行率(%)" align="center" prop="uptimePercentage" min-width="100">
        <template slot-scope="scope">{{ formatStatNum(scope.row.uptimePercentage) }}</template>
      </el-table-column>
      <el-table-column label="故障率(/小时)" align="center" prop="faultRatePerHour" min-width="120">
        <template slot-scope="scope">{{ formatStatNum(scope.row.faultRatePerHour) }}</template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />
  </div>
</template>

<script>
import { listDeviceStat } from "@/api/equipment/deviceStat";
import dataAcquisitionDevice from '@/mixins/dataAcquisitionDevice'

export default {
  name: "DeviceStat",
  mixins: [dataAcquisitionDevice],
  data() {
    return {
      loading: true,
      total: 0,
      dataList: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        deviceId: null,
        computedSummary: true
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    formatDateTimeDisplay(val) {
      if (val === null || val === undefined || val === "") {
        return "—";
      }
      try {
        const d = val instanceof Date ? val : new Date(val);
        if (Number.isNaN(d.getTime())) {
          return String(val);
        }
        if (typeof this.parseTime === "function") {
          return this.parseTime(d, "{y}-{m}-{d} {h}:{i}:{s}");
        }
        const pad = n => (n < 10 ? "0" + n : "" + n);
        return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}`;
      } catch (e) {
        return String(val);
      }
    },
    formatStatInt(v) {
      if (v === null || v === undefined || v === "") {
        return "—";
      }
      return v;
    },
    formatStatNum(v) {
      if (v === null || v === undefined || v === "") {
        return "—";
      }
      return v;
    },
    getList() {
      this.loading = true;
      listDeviceStat(this.queryParams).then(response => {
        this.dataList = response.rows || [];
        this.total = response.total || 0;
        this.loading = false;
      });
    },
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    resetQuery() {
      this.resetForm("queryForm");
      this.clearDataAcquisitionDeviceFilter();
      this.handleQuery();
    }
  }
};
</script>

<style scoped>
.app-container {
  padding: 20px;
}
.mb8 {
  margin-bottom: 8px;
}
</style>
