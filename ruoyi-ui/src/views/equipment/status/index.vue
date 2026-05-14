<template>
  <div class="app-container">
    <!-- 搜索区域 -->
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
        <el-button type="primary" icon="el-icon-search" size="small" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="small" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="small"
          @click="handleAdd"
          v-hasPermi="['equipment:deviceStatus:add']"
        >新增</el-button>
      </el-col>
    </el-row>

    <!-- 数据表格 -->
    <el-table v-loading="loading" :data="statusList" border>
      <el-table-column label="设备编号" align="center" prop="deviceNo" min-width="140" show-overflow-tooltip>
        <template slot-scope="scope">
          {{ scope.row.deviceNo || '-' }}
        </template>
      </el-table-column>
      <el-table-column label="设备名称" align="center" prop="deviceName" min-width="128" show-overflow-tooltip>
        <template slot-scope="scope">
          {{ scope.row.deviceName || '-' }}
        </template>
      </el-table-column>
      <el-table-column label="采集时间" align="center" prop="timestamp" min-width="180" :formatter="formatTableTime" />
      <el-table-column label="温度(℃)" align="center" prop="temperature" min-width="100" />
      <el-table-column label="湿度(%)" align="center" prop="humidity" min-width="100" />
      <el-table-column label="压力(Pa)" align="center" prop="pressure" min-width="100" />
      <el-table-column label="振动(mm/s)" align="center" prop="vibration" min-width="110" />
      <el-table-column label="电流(A)" align="center" prop="current" min-width="100" />
      <el-table-column label="电压(V)" align="center" prop="voltage" min-width="100" />
      <el-table-column label="功率(kW)" align="center" prop="power" min-width="100" />
      <el-table-column label="转速(rpm)" align="center" prop="rpm" min-width="110" />
      <el-table-column label="运行状态" align="center" prop="status" min-width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status === 1" type="success">正常</el-tag>
          <el-tag v-else-if="scope.row.status === 2" type="warning">警告</el-tag>
          <el-tag v-else-if="scope.row.status === 3" type="danger">错误</el-tag>
          <el-tag v-else-if="scope.row.status === 4" type="info">离线</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="200" fixed="right">
        <template slot-scope="scope">
          <el-button size="small" type="text" icon="el-icon-view" @click="handleDetail(scope.row)">详情</el-button>
          <el-button
            size="small"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['equipment:deviceStatus:edit']"
          >修改</el-button>
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

    <!-- 添加或修改设备状态对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="900px" append-to-body class="dark-dialog">
      <el-form ref="form" :model="form" :rules="rules" label-width="140px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="设备" prop="deviceId">
              <device-select v-model="form.deviceId" :disabled="form.statusId != null" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="设备编号">
              <el-input v-model="form.deviceNo" placeholder="设备编号（自动显示）" disabled />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="设备名称">
              <el-input v-model="form.deviceName" placeholder="设备名称（自动显示）" disabled />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="采集时间" prop="timestamp">
              <el-date-picker
                v-model="form.timestamp"
                type="datetime"
                placeholder="选择采集时间"
                style="width: 100%"
                value-format="yyyy-MM-dd HH:mm:ss"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-divider content-position="left">基础参数</el-divider>
        <el-row>
          <el-col :span="8">
            <el-form-item label="温度(℃)" prop="temperature">
              <el-input-number v-model="form.temperature" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="湿度(%)" prop="humidity">
              <el-input-number v-model="form.humidity" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="压力(Pa)" prop="pressure">
              <el-input-number v-model="form.pressure" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="振动(mm/s)" prop="vibration">
              <el-input-number v-model="form.vibration" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="电流(A)" prop="current">
              <el-input-number v-model="form.current" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="电压(V)" prop="voltage">
              <el-input-number v-model="form.voltage" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="功率(kW)" prop="power">
              <el-input-number v-model="form.power" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="转速(rpm)" prop="rpm">
              <el-input-number v-model="form.rpm" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="运行状态" prop="status">
              <el-select v-model="form.status" placeholder="请选择运行状态" style="width: 100%">
                <el-option label="正常" :value="1" />
                <el-option label="警告" :value="2" />
                <el-option label="错误" :value="3" />
                <el-option label="离线" :value="4" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-divider content-position="left">扩展参数</el-divider>
        <el-row>
          <el-col :span="8">
            <el-form-item label="流量(m³/h)" prop="flowRate">
              <el-input-number v-model="form.flowRate" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="液位(m)" prop="liquidLevel">
              <el-input-number v-model="form.liquidLevel" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="运行时长(h)" prop="runtimeHours">
              <el-input-number v-model="form.runtimeHours" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="启动次数" prop="startCount">
              <el-input-number v-model="form.startCount" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="故障次数" prop="faultCount">
              <el-input-number v-model="form.faultCount" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="报警次数" prop="alarmCount">
              <el-input-number v-model="form.alarmCount" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="效率(%)" prop="efficiency">
              <el-input-number v-model="form.efficiency" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="负载系数" prop="loadFactor">
              <el-input-number v-model="form.loadFactor" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="是否需要维护" prop="maintenanceRequired">
              <el-select v-model="form.maintenanceRequired" placeholder="请选择" style="width: 100%">
                <el-option label="不需要" :value="0" />
                <el-option label="需要" :value="1" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-divider content-position="left">环境参数</el-divider>
        <el-row>
          <el-col :span="8">
            <el-form-item label="环境温度(℃)" prop="ambientTemp">
              <el-input-number v-model="form.ambientTemp" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="环境湿度(%)" prop="ambientHumidity">
              <el-input-number v-model="form.ambientHumidity" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="噪音水平(dB)" prop="noiseLevel">
              <el-input-number v-model="form.noiseLevel" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="空气质量指数" prop="airQuality">
              <el-input-number v-model="form.airQuality" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="故障代码" prop="faultCode">
              <el-input v-model="form.faultCode" placeholder="请输入故障代码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="故障描述" prop="faultDescription">
              <el-input v-model="form.faultDescription" type="textarea" :rows="3" placeholder="请输入故障描述" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="备注" prop="remark">
              <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="请输入备注" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 详情对话框 -->
    <el-dialog title="设备状态详情" :visible.sync="detailVisible" width="800px" append-to-body class="dark-dialog">
      <el-descriptions :column="2" border v-if="currentStatus">
        <el-descriptions-item label="设备编号">{{ currentStatus.deviceNo || '-' }}</el-descriptions-item>
        <el-descriptions-item label="设备名称" :span="2">{{ currentStatus.deviceName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="采集时间" :span="2">{{ currentStatus.timestamp }}</el-descriptions-item>
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
import { listDeviceStatus, getDeviceStatus, addDeviceStatus, updateDeviceStatus } from "@/api/equipment/deviceStatus";
import { getDevice } from "@/api/equipment/device";
import dataAcquisitionDevice from '@/mixins/dataAcquisitionDevice'

export default {
  name: "EquipmentStatus",
  mixins: [dataAcquisitionDevice],
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
      // 修改对话框
      open: false,
      title: "",
      form: {},
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        deviceId: null,
        deviceNo: null,
        deviceName: null,
        status: null
      },
      rules: {
        deviceId: [
          { required: true, message: "请选择设备", trigger: "blur" }
        ],
        timestamp: [
          { required: true, message: "采集时间不能为空", trigger: "change" }
        ]
      }
    };
  },
  created() {
    this.getList();
  },
  watch: {
    'form.deviceId'(newVal) {
      if (newVal && this.form.statusId == null) {
        // 新增时，设备ID改变时自动获取设备信息
        this.loadDeviceInfo(newVal);
      }
    }
  },
  methods: {
    // 表格时间字段格式化，兼容 2025-12-27T00:40:52.000+08:00
    formatTableTime(row, column, cellValue) {
      if (!cellValue) {
        return '-';
      }
      try {
        const dateObj = new Date(cellValue);
        if (this.parseTime) {
          return this.parseTime(dateObj, '{y}-{m}-{d} {h}:{i}:{s}');
        }
        return dateObj.toLocaleString();
      } catch (e) {
        return String(cellValue);
      }
    },
    /** 加载设备信息 */
    loadDeviceInfo(deviceId) {
      if (!deviceId) return;
      getDevice(deviceId).then(response => {
        if (response && response.code === 200 && response.data) {
          if (response.data.deviceNo) {
            this.form.deviceNo = response.data.deviceNo;
          }
          if (response.data.deviceName) {
            this.form.deviceName = response.data.deviceName;
          }
        }
      }).catch(error => {
        console.error("加载设备信息失败:", error);
        // 忽略错误，设备可能不存在
      });
    },
    /** 查询设备状态列表 */
    getList() {
      this.loading = true;
      listDeviceStatus(this.queryParams).then(response => {
        if (response.code === 200) {
          this.statusList = response.rows || [];
          this.total = response.total || 0;
          // 调试日志：检查设备编号和设备名称
          if (this.statusList.length > 0) {
            console.log("设备状态列表数据示例:", this.statusList[0]);
            console.log("设备编号:", this.statusList[0].deviceNo);
            console.log("设备名称:", this.statusList[0].deviceName);
          }
        } else {
          this.$modal.msgError(response.msg || "获取数据失败");
          this.statusList = [];
          this.total = 0;
        }
        this.loading = false;
      }).catch(error => {
        console.error("获取设备状态列表失败:", error);
        this.$modal.msgError("获取数据失败: " + (error.message || "未知错误"));
        this.statusList = [];
        this.total = 0;
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
      this.clearDataAcquisitionDeviceFilter();
      this.handleQuery();
    },
    /** 查看详情 */
    handleDetail(row) {
      this.currentStatus = row;
      this.detailVisible = true;
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "新增设备状态";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const statusId = row.statusId;
      console.log("修改按钮 - 行数据:", row);
      console.log("设备编号:", row.deviceNo);
      console.log("设备名称:", row.deviceName);

      // 先从row中获取设备编号和设备名称（列表数据已包含）
      const formData = {
        ...row,
        deviceNo: row.deviceNo || '',
        deviceName: row.deviceName || ''
      };

      // 获取完整详情数据（确保所有字段都有值）
      getDeviceStatus(statusId).then(response => {
        console.log("获取详情响应:", response);
        if (response.code === 200 && response.data) {
          console.log("详情数据:", response.data);
          console.log("详情中的设备编号:", response.data.deviceNo);
          console.log("详情中的设备名称:", response.data.deviceName);
          // 合并详情数据，优先使用详情数据，但保留列表中的设备编号和设备名称
          this.form = {
            ...response.data,
            deviceNo: response.data.deviceNo || formData.deviceNo || '',
            deviceName: response.data.deviceName || formData.deviceName || ''
          };
          console.log("最终表单数据 - 设备编号:", this.form.deviceNo);
          console.log("最终表单数据 - 设备名称:", this.form.deviceName);
          // 如果详情中没有设备编号和设备名称，尝试从设备表获取
          if ((!this.form.deviceNo || !this.form.deviceName) && this.form.deviceId) {
            this.loadDeviceInfo(this.form.deviceId);
          }
        } else {
          // 如果详情查询失败，使用列表数据
          this.form = formData;
          this.$modal.msgWarning(response.msg || "获取详情失败，使用列表数据");
        }
        this.open = true;
        this.title = "修改设备状态";
      }).catch(error => {
        console.error("获取设备状态详情失败:", error);
        // 如果查询失败，使用列表数据
        this.form = formData;
        if (this.form.deviceId) {
          this.loadDeviceInfo(this.form.deviceId);
        }
        this.open = true;
        this.title = "修改设备状态";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.statusId != null) {
            updateDeviceStatus(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addDeviceStatus(this.form).then(() => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 取消按钮 */
    cancel() {
      this.open = false;
      this.reset();
    },
    /** 表单重置 */
    reset() {
      this.form = {
        statusId: null,
        deviceId: null,
        deviceNo: null,
        deviceName: null,
        timestamp: null,
        temperature: null,
        humidity: null,
        pressure: null,
        vibration: null,
        current: null,
        voltage: null,
        power: null,
        rpm: null,
        flowRate: null,
        liquidLevel: null,
        status: null,
        runtimeHours: null,
        startCount: null,
        faultCount: null,
        alarmCount: null,
        efficiency: null,
        loadFactor: null,
        ambientTemp: null,
        ambientHumidity: null,
        noiseLevel: null,
        airQuality: null,
        faultCode: null,
        faultDescription: null,
        maintenanceRequired: null,
        remark: null
      };
      this.resetForm("form");
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
