<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" label-width="80px">
      <el-form-item label="设备ID" prop="deviceId">
        <el-input
          v-model="queryParams.deviceId"
          placeholder="请输入设备ID"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="规则名称" prop="ruleName">
        <el-input
          v-model="queryParams.ruleName"
          placeholder="请输入规则名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['equipment:deviceRule:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['equipment:deviceRule:remove']"
        >删除</el-button>
      </el-col>
    </el-row>

    <el-table v-loading="loading" :data="dataList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="规则ID" align="center" prop="ruleId" width="80" />
      <el-table-column label="设备ID" align="center" prop="deviceId" width="100" />
      <el-table-column label="设备编号" align="center" prop="deviceNo" width="140" show-overflow-tooltip>
        <template slot-scope="scope">
          {{ scope.row.deviceNo || '-' }}
        </template>
      </el-table-column>
      <el-table-column label="设备名称" align="center" prop="deviceName" width="180" show-overflow-tooltip>
        <template slot-scope="scope">
          {{ scope.row.deviceName || '-' }}
        </template>
      </el-table-column>
      <el-table-column label="规则名称" align="center" prop="ruleName" width="150" />
      <el-table-column label="参数名称" align="center" prop="parameterName" width="150" />
      <el-table-column label="条件类型" align="center" prop="conditionType" width="100">
        <template slot-scope="scope">
          <span v-if="scope.row.conditionType === 1">大于</span>
          <span v-else-if="scope.row.conditionType === 2">小于</span>
          <span v-else-if="scope.row.conditionType === 3">等于</span>
          <span v-else-if="scope.row.conditionType === 4">区间</span>
        </template>
      </el-table-column>
      <el-table-column label="阈值" align="center" prop="thresholdValue" width="120" />
      <el-table-column label="阈值单位" align="center" prop="thresholdUnit" width="100" />
      <el-table-column label="报警等级" align="center" prop="alertLevel" width="100">
        <template slot-scope="scope">
          <span v-if="scope.row.alertLevel === 1">警报</span>
          <span v-else-if="scope.row.alertLevel === 2">严重</span>
          <span v-else-if="scope.row.alertLevel === 3">紧急</span>
        </template>
      </el-table-column>
      <el-table-column label="是否启用" align="center" prop="enabled" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.enabled === 1" type="success">启用</el-tag>
          <el-tag v-else type="info">禁用</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="160" fixed="right">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['equipment:deviceRule:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['equipment:deviceRule:remove']"
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

    <!-- 添加或修改设备规则对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <el-form-item label="设备ID" prop="deviceId">
          <el-input-number v-model="form.deviceId" placeholder="请输入设备ID" style="width: 100%" />
        </el-form-item>
        <el-form-item label="规则名称" prop="ruleName">
          <el-input v-model="form.ruleName" placeholder="请输入规则名称" />
        </el-form-item>
        <el-form-item label="参数名称" prop="parameterName">
          <el-input v-model="form.parameterName" placeholder="请输入参数名称" />
        </el-form-item>
        <el-form-item label="条件类型" prop="conditionType">
          <el-select v-model="form.conditionType" placeholder="请选择条件类型" style="width: 100%">
            <el-option label="大于" :value="1" />
            <el-option label="小于" :value="2" />
            <el-option label="等于" :value="3" />
            <el-option label="区间" :value="4" />
          </el-select>
        </el-form-item>
        <el-form-item label="阈值" prop="thresholdValue">
          <el-input-number v-model="form.thresholdValue" :precision="2" style="width: 100%" />
        </el-form-item>
        <el-form-item label="阈值单位" prop="thresholdUnit">
          <el-input v-model="form.thresholdUnit" placeholder="请输入阈值单位" />
        </el-form-item>
        <el-form-item label="报警等级" prop="alertLevel">
          <el-select v-model="form.alertLevel" placeholder="请选择报警等级" style="width: 100%">
            <el-option label="警报" :value="1" />
            <el-option label="严重" :value="2" />
            <el-option label="紧急" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="是否启用" prop="enabled">
          <el-radio-group v-model="form.enabled">
            <el-radio :label="1">启用</el-radio>
            <el-radio :label="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="通知渠道" prop="notificationChannels">
          <el-input v-model="form.notificationChannels" type="textarea" placeholder="请输入通知渠道" />
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
import { listDeviceRule, getDeviceRule, delDeviceRule, addDeviceRule, updateDeviceRule } from "@/api/equipment/deviceRule";

export default {
  name: "DeviceRule",
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
        ruleName: null
      },
      rules: {
        deviceId: [
          { required: true, message: "设备ID不能为空", trigger: "blur" }
        ],
        ruleName: [
          { required: true, message: "规则名称不能为空", trigger: "blur" }
        ],
        parameterName: [
          { required: true, message: "参数名称不能为空", trigger: "blur" }
        ],
        conditionType: [
          { required: true, message: "条件类型不能为空", trigger: "change" }
        ],
        thresholdValue: [
          { required: true, message: "阈值不能为空", trigger: "blur" }
        ],
        alertLevel: [
          { required: true, message: "报警等级不能为空", trigger: "change" }
        ],
        enabled: [
          { required: true, message: "是否启用不能为空", trigger: "change" }
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
      listDeviceRule(this.queryParams).then(response => {
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
      this.handleQuery();
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.ruleId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加设备规则";
    },
    handleUpdate(row) {
      this.reset();
      const ruleId = row.ruleId || this.ids[0];
      getDeviceRule(ruleId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改设备规则";
      });
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.ruleId != null) {
            updateDeviceRule(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addDeviceRule(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    handleDelete(row) {
      const ruleIds = row.ruleId || this.ids;
      this.$modal.confirm('是否确认删除设备规则编号为"' + ruleIds + '"的数据项？').then(function() {
        return delDeviceRule(ruleIds);
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
        ruleId: null,
        deviceId: null,
        ruleName: null,
        parameterName: null,
        conditionType: null,
        thresholdValue: null,
        thresholdUnit: null,
        alertLevel: null,
        enabled: 1,
        notificationChannels: null
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
