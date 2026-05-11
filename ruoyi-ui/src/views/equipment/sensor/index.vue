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
      <el-form-item label="传感器名称" prop="sensorName">
        <el-input
          v-model="queryParams.sensorName"
          placeholder="请输入传感器名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
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
          v-hasPermi="['equipment:sensor:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="small"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['equipment:sensor:remove']"
        >删除</el-button>
      </el-col>
    </el-row>

    <el-table v-loading="loading" :data="dataList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="传感器ID" align="center" prop="sensorId" min-width="100" />
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
      <el-table-column label="传感器类型" align="center" prop="sensorType" min-width="150" />
      <el-table-column label="传感器名称" align="center" prop="sensorName" min-width="150" />
      <el-table-column label="安装位置" align="center" prop="location" min-width="150" />
      <el-table-column label="单位" align="center" prop="unit" min-width="80" />
      <el-table-column label="校准时间" align="center" prop="calibrationTime" min-width="160">
        <template slot-scope="scope">
          {{ scope.row.calibrationTime ? parseTime(scope.row.calibrationTime, '{y}-{m}-{d} {h}:{i}:{s}') : '-' }}
        </template>
      </el-table-column>
      <el-table-column label="下次校准" align="center" prop="nextCalibrationTime" min-width="160">
        <template slot-scope="scope">
          {{ scope.row.nextCalibrationTime ? parseTime(scope.row.nextCalibrationTime, '{y}-{m}-{d} {h}:{i}:{s}') : '-' }}
        </template>
      </el-table-column>
      <el-table-column label="传感器状态" align="center" prop="status" min-width="120">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status === 1" type="success">启用</el-tag>
          <el-tag v-else-if="scope.row.status === 2" type="info">停用</el-tag>
          <el-tag v-else-if="scope.row.status === 3" type="warning">校准中</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="160" fixed="right">
        <template slot-scope="scope">
          <el-button
            size="small"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['equipment:sensor:edit']"
          >修改</el-button>
          <el-button
            size="small"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['equipment:sensor:remove']"
          >删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 添加或修改传感器对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="140px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="设备" prop="deviceId">
              <device-select v-model="form.deviceId" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="传感器类型" prop="sensorType">
              <el-input v-model="form.sensorType" placeholder="请输入传感器类型" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="传感器名称" prop="sensorName">
              <el-input v-model="form.sensorName" placeholder="请输入传感器名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="安装位置" prop="location">
              <el-input v-model="form.location" placeholder="请输入安装位置" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="单位" prop="unit">
              <el-input v-model="form.unit" placeholder="请输入单位" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="传感器状态" prop="status">
              <el-select v-model="form.status" placeholder="请选择传感器状态" style="width: 100%">
                <el-option label="启用" :value="1" />
                <el-option label="停用" :value="2" />
                <el-option label="校准中" :value="3" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="校准时间" prop="calibrationTime">
              <el-date-picker
                v-model="form.calibrationTime"
                type="datetime"
                placeholder="选择校准时间"
                style="width: 100%"
                value-format="yyyy-MM-dd HH:mm:ss"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="下次校准时间" prop="nextCalibrationTime">
              <el-date-picker
                v-model="form.nextCalibrationTime"
                type="datetime"
                placeholder="选择下次校准时间"
                style="width: 100%"
                value-format="yyyy-MM-dd HH:mm:ss"
              />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listSensor, getSensor, delSensor, addSensor, updateSensor } from "@/api/equipment/sensor";
import dataAcquisitionDevice from '@/mixins/dataAcquisitionDevice'

export default {
  name: "Sensor",
  mixins: [dataAcquisitionDevice],
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      total: 0,
      dataList: [],
      title: "",
      open: false,
      form: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        deviceId: null,
        sensorName: null
      },
      rules: {
        deviceId: [
          { required: true, message: "请选择设备", trigger: "blur" }
        ],
        sensorName: [
          { required: true, message: "传感器名称不能为空", trigger: "blur" }
        ],
        sensorType: [
          { required: true, message: "传感器类型不能为空", trigger: "blur" }
        ]
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    getList() {
      this.loading = true;
      listSensor(this.queryParams).then(response => {
        this.dataList = response.rows;
        this.total = response.total;
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
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.sensorId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加传感器";
    },
    handleUpdate(row) {
      this.reset();
      const sensorId = row.sensorId || this.ids[0];
      getSensor(sensorId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改传感器";
      });
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.sensorId != null) {
            updateSensor(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addSensor(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    handleDelete(row) {
      const sensorIds = row.sensorId || this.ids;
      this.$modal.confirm('是否确认删除传感器编号为"' + sensorIds + '"的数据项？').then(function() {
        return delSensor(sensorIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    cancel() {
      this.open = false;
      this.reset();
    },
    reset() {
      this.form = {
        sensorId: null,
        deviceId: null,
        sensorType: null,
        sensorName: null,
        location: null,
        unit: null,
        calibrationTime: null,
        nextCalibrationTime: null,
        status: 1
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
</style>
