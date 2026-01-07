<template>
  <div class="app-container">
    <!-- 搜索区域 -->
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" label-width="80px">
      <el-form-item label="设备编号" prop="deviceNo">
        <el-input
          v-model="queryParams.deviceNo"
          placeholder="请输入设备编号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="设备名称" prop="deviceName">
        <el-input
          v-model="queryParams.deviceName"
          placeholder="请输入设备名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="运行状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option label="正常" value="1" />
          <el-option label="警告" value="2" />
          <el-option label="错误" value="3" />
          <el-option label="离线" value="4" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 数据表格 -->
    <el-table v-loading="loading" :data="statusList" border>
      <el-table-column label="设备ID" align="center" prop="deviceId" width="80" />
      <el-table-column label="设备编号" align="center" prop="deviceNo" width="140" />
      <el-table-column label="设备名称" align="center" prop="deviceName" width="140" />
      <el-table-column label="采集时间" align="center" prop="timestamp" width="160" />
      <el-table-column label="温度(℃)" align="center" prop="temperature" width="100" />
      <el-table-column label="湿度(%)" align="center" prop="humidity" width="100" />
      <el-table-column label="压力(Pa)" align="center" prop="pressure" width="100" />
      <el-table-column label="振动(mm/s)" align="center" prop="vibration" width="110" />
      <el-table-column label="电流(A)" align="center" prop="current" width="100" />
      <el-table-column label="电压(V)" align="center" prop="voltage" width="100" />
      <el-table-column label="功率(kW)" align="center" prop="power" width="100" />
      <el-table-column label="转速(rpm)" align="center" prop="rpm" width="110" />
      <el-table-column label="运行状态" align="center" prop="status" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status === 1" type="success">正常</el-tag>
          <el-tag v-else-if="scope.row.status === 2" type="warning">警告</el-tag>
          <el-tag v-else-if="scope.row.status === 3" type="danger">错误</el-tag>
          <el-tag v-else-if="scope.row.status === 4" type="info">离线</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="160" fixed="right">
        <template slot-scope="scope">
          <el-button size="mini" type="text" @click="handleDetail(scope.row)">详情</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 详情对话框 -->
    <el-dialog title="设备状态详情" :visible.sync="detailVisible" width="800px" append-to-body class="dark-dialog">
      <el-descriptions :column="2" border v-if="currentStatus">
        <el-descriptions-item label="设备ID">{{ currentStatus.deviceId }}</el-descriptions-item>
        <el-descriptions-item label="采集时间">{{ currentStatus.timestamp }}</el-descriptions-item>
        <el-descriptions-item label="温度">{{ currentStatus.temperature }} ℃</el-descriptions-item>
        <el-descriptions-item label="湿度">{{ currentStatus.humidity }} %</el-descriptions-item>
        <el-descriptions-item label="压力">{{ currentStatus.pressure }} Pa</el-descriptions-item>
        <el-descriptions-item label="振动">{{ currentStatus.vibration }} mm/s</el-descriptions-item>
        <el-descriptions-item label="电流">{{ currentStatus.current }} A</el-descriptions-item>
        <el-descriptions-item label="电压">{{ currentStatus.voltage }} V</el-descriptions-item>
        <el-descriptions-item label="功率">{{ currentStatus.power }} kW</el-descriptions-item>
        <el-descriptions-item label="转速">{{ currentStatus.rpm }} rpm</el-descriptions-item>
        <el-descriptions-item label="流量">{{ currentStatus.flowRate }} m³/h</el-descriptions-item>
        <el-descriptions-item label="液位">{{ currentStatus.liquidLevel }} m</el-descriptions-item>
        <el-descriptions-item label="运行时长">{{ currentStatus.runtimeHours }} h</el-descriptions-item>
        <el-descriptions-item label="启动次数">{{ currentStatus.startCount }}</el-descriptions-item>
        <el-descriptions-item label="故障次数">{{ currentStatus.faultCount }}</el-descriptions-item>
        <el-descriptions-item label="报警次数">{{ currentStatus.alarmCount }}</el-descriptions-item>
        <el-descriptions-item label="效率">{{ currentStatus.efficiency }} %</el-descriptions-item>
        <el-descriptions-item label="负载系数">{{ currentStatus.loadFactor }}</el-descriptions-item>
        <el-descriptions-item label="环境温度">{{ currentStatus.ambientTemp }} ℃</el-descriptions-item>
        <el-descriptions-item label="环境湿度">{{ currentStatus.ambientHumidity }} %</el-descriptions-item>
        <el-descriptions-item label="噪音水平">{{ currentStatus.noiseLevel }} dB</el-descriptions-item>
        <el-descriptions-item label="空气质量">{{ currentStatus.airQuality }}</el-descriptions-item>
        <el-descriptions-item label="故障代码">{{ currentStatus.faultCode || '无' }}</el-descriptions-item>
        <el-descriptions-item label="故障描述">{{ currentStatus.faultDescription || '无' }}</el-descriptions-item>
        <el-descriptions-item label="是否需要维护" :span="2">
          <el-tag v-if="currentStatus.maintenanceRequired === 1" type="warning">需要</el-tag>
          <el-tag v-else type="success">不需要</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ currentStatus.remark || '无' }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button @click="detailVisible = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listDeviceStatus } from "@/api/equipment/deviceStatus";

export default {
  name: "EquipmentStatus",
  data() {
    return {
      // 遮罩层
      loading: true,
      // 总条数
      total: 0,
      // 设备状态表格数据
      statusList: [],
      // 详情对话框
      detailVisible: false,
      // 当前状态数据
      currentStatus: null,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        deviceNo: null,
        deviceName: null,
        status: null
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询设备状态列表 */
    getList() {
      this.loading = true;
      listDeviceStatus(this.queryParams).then(response => {
        this.statusList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    /** 查看详情 */
    handleDetail(row) {
      this.currentStatus = row;
      this.detailVisible = true;
    }
  }
};
</script>

<style scoped>
.app-container {
  padding: 20px;
}

.dark-card {
  background: var(--secondary-bg);
  border: 1px solid var(--border-color);
  border-radius: 0;
}

.dark-dialog ::v-deep .el-dialog {
  background: var(--primary-bg) !important;
  border: 1px solid var(--border-color) !important;
}
.dark-dialog ::v-deep .el-dialog__header,
.dark-dialog ::v-deep .el-dialog__body,
.dark-dialog ::v-deep .el-dialog__footer {
  background: var(--primary-bg) !important;
  color: var(--text-primary) !important;
}
.dark-dialog ::v-deep .el-descriptions__header,
.dark-dialog ::v-deep .el-descriptions-item__label,
.dark-dialog ::v-deep .el-descriptions-item__content {
  background: var(--secondary-bg) !important;
  color: var(--text-primary) !important;
  border-color: var(--border-color) !important;
}
</style>
