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
      <el-form-item label="参数名称" prop="parameterName">
        <el-input
          v-model="queryParams.parameterName"
          placeholder="请输入参数名称"
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
          v-hasPermi="['equipment:param:add']"
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
          v-hasPermi="['equipment:param:remove']"
        >删除</el-button>
      </el-col>
    </el-row>

    <el-table v-loading="loading" :data="paramList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="参数ID" align="center" prop="paramId" min-width="80" />
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
      <el-table-column label="参数名称" align="center" prop="parameterName" min-width="150" />
      <el-table-column label="参数值" align="center" prop="parameterValue" min-width="120" />
      <el-table-column label="单位" align="center" prop="unit" min-width="80" />
      <el-table-column label="默认值" align="center" prop="defaultValue" min-width="120" />
      <el-table-column label="最小值" align="center" prop="minValue" min-width="120" />
      <el-table-column label="最大值" align="center" prop="maxValue" min-width="120" />
      <el-table-column label="临界阈值" align="center" prop="criticalThreshold" min-width="120" />
      <el-table-column label="警告阈值" align="center" prop="warningThreshold" min-width="120" />
      <el-table-column label="操作" align="center" width="160" fixed="right">
        <template slot-scope="scope">
          <el-button
            size="small"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['equipment:param:edit']"
          >修改</el-button>
          <el-button
            size="small"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['equipment:param:remove']"
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

    <!-- 添加或修改设备参数对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="设备" prop="deviceId">
          <device-select v-model="form.deviceId" :disabled="form.paramId != null" />
        </el-form-item>
        <el-form-item label="参数名称" prop="parameterName">
          <el-input v-model="form.parameterName" placeholder="请输入参数名称" />
        </el-form-item>
        <el-form-item label="参数值" prop="parameterValue">
          <el-input-number v-model="form.parameterValue" :precision="2" style="width: 100%" />
        </el-form-item>
        <el-form-item label="单位" prop="unit">
          <el-input v-model="form.unit" placeholder="请输入单位" />
        </el-form-item>
        <el-form-item label="默认值" prop="defaultValue">
          <el-input-number v-model="form.defaultValue" :precision="2" style="width: 100%" />
        </el-form-item>
        <el-form-item label="最小值" prop="minValue">
          <el-input-number v-model="form.minValue" :precision="2" style="width: 100%" />
        </el-form-item>
        <el-form-item label="最大值" prop="maxValue">
          <el-input-number v-model="form.maxValue" :precision="2" style="width: 100%" />
        </el-form-item>
        <el-form-item label="临界阈值" prop="criticalThreshold">
          <el-input-number v-model="form.criticalThreshold" :precision="2" style="width: 100%" />
        </el-form-item>
        <el-form-item label="警告阈值" prop="warningThreshold">
          <el-input-number v-model="form.warningThreshold" :precision="2" style="width: 100%" />
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入内容" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listDeviceParam, getDeviceParam, delDeviceParam, addDeviceParam, updateDeviceParam } from "@/api/equipment/deviceParam";
import dataAcquisitionDevice from '@/mixins/dataAcquisitionDevice'

export default {
  name: "DeviceParam",
  mixins: [dataAcquisitionDevice],
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      total: 0,
      paramList: [],
      title: "",
      open: false,
      form: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        deviceId: null,
        parameterName: null
      },
      rules: {
        deviceId: [
          { required: true, message: "请选择设备", trigger: "blur" }
        ],
        parameterName: [
          { required: true, message: "参数名称不能为空", trigger: "blur" }
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
      listDeviceParam(this.queryParams).then(response => {
        this.paramList = response.rows;
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
      this.ids = selection.map(item => item.paramId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加设备参数";
    },
    handleUpdate(row) {
      this.reset();
      const paramId = row.paramId || this.ids[0];
      getDeviceParam(paramId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改设备参数";
      });
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.paramId != null) {
            updateDeviceParam(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addDeviceParam(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    handleDelete(row) {
      const paramIds = row.paramId || this.ids;
      this.$modal.confirm('是否确认删除设备参数编号为"' + paramIds + '"的数据项？').then(function() {
        return delDeviceParam(paramIds);
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
        paramId: null,
        deviceId: null,
        parameterName: null,
        parameterValue: null,
        unit: null,
        defaultValue: null,
        minValue: null,
        maxValue: null,
        criticalThreshold: null,
        warningThreshold: null,
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
</style>
