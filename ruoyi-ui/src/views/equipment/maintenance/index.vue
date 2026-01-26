<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" label-width="80px">
      <el-form-item label="设备ID" prop="deviceId">
        <el-input v-model="queryParams.deviceId" placeholder="请输入设备ID" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['equipment:maintenanceRecord:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['equipment:maintenanceRecord:remove']">删除</el-button>
      </el-col>
    </el-row>

    <el-table v-loading="loading" :data="recordList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="记录ID" align="center" prop="recordId" width="80" />
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
      <el-table-column label="维护类型" align="center" prop="maintenanceType" width="100">
        <template slot-scope="scope">
          <span v-if="scope.row.maintenanceType === 1">预防性</span>
          <span v-else-if="scope.row.maintenanceType === 2">纠正性</span>
          <span v-else-if="scope.row.maintenanceType === 3">预测性</span>
        </template>
      </el-table-column>
      <el-table-column label="维护日期" align="center" prop="maintenanceDate" width="120" />
      <el-table-column label="执行人员" align="center" prop="performedBy" width="120" />
      <el-table-column label="维护成本" align="center" prop="maintenanceCost" width="120" />
      <el-table-column label="状态" align="center" prop="status" width="100">
        <template slot-scope="scope">
          <span v-if="scope.row.status === 1">已完成</span>
          <span v-else-if="scope.row.status === 2">安排中</span>
          <span v-else-if="scope.row.status === 3">进行中</span>
          <span v-else-if="scope.row.status === 4">已取消</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="160" fixed="right">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['equipment:maintenanceRecord:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['equipment:maintenanceRecord:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="设备ID" prop="deviceId">
          <el-input v-model="form.deviceId" placeholder="请输入设备ID" />
        </el-form-item>
        <el-form-item label="维护类型" prop="maintenanceType">
          <el-select v-model="form.maintenanceType" placeholder="请选择维护类型">
            <el-option label="预防性" :value="1" />
            <el-option label="纠正性" :value="2" />
            <el-option label="预测性" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="维护日期" prop="maintenanceDate">
          <el-date-picker v-model="form.maintenanceDate" type="date" placeholder="选择日期" style="width: 100%" />
        </el-form-item>
        <el-form-item label="执行人员" prop="performedBy">
          <el-input v-model="form.performedBy" placeholder="请输入执行人员" />
        </el-form-item>
        <el-form-item label="维护成本" prop="maintenanceCost">
          <el-input-number v-model="form.maintenanceCost" :precision="2" style="width: 100%" />
        </el-form-item>
        <el-form-item label="维护描述" prop="description">
          <el-input v-model="form.description" type="textarea" placeholder="请输入维护描述" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="form.status" placeholder="请选择状态">
            <el-option label="已完成" :value="1" />
            <el-option label="安排中" :value="2" />
            <el-option label="进行中" :value="3" />
            <el-option label="已取消" :value="4" />
          </el-select>
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
import { listMaintenanceRecord, getMaintenanceRecord, delMaintenanceRecord, addMaintenanceRecord, updateMaintenanceRecord } from "@/api/equipment/maintenanceRecord";

export default {
  name: "MaintenanceRecord",
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      total: 0,
      recordList: [],
      title: "",
      open: false,
      form: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        deviceId: null
      },
      rules: {
        deviceId: [{ required: true, message: "设备ID不能为空", trigger: "blur" }]
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    getList() {
      this.loading = true;
      listMaintenanceRecord(this.queryParams).then(response => {
        this.recordList = response.rows;
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
      this.ids = selection.map(item => item.recordId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加维护记录";
    },
    handleUpdate(row) {
      this.reset();
      const recordId = row.recordId || this.ids[0];
      getMaintenanceRecord(recordId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改维护记录";
      });
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.recordId != null) {
            updateMaintenanceRecord(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addMaintenanceRecord(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    handleDelete(row) {
      const recordIds = row.recordId || this.ids;
      this.$modal.confirm('是否确认删除维护记录编号为"' + recordIds + '"的数据项？').then(function() {
        return delMaintenanceRecord(recordIds);
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
        recordId: null,
        deviceId: null,
        maintenanceType: null,
        maintenanceDate: null,
        nextMaintenanceDate: null,
        maintenanceCost: null,
        performedBy: null,
        description: null,
        partsReplaced: null,
        technicianNotes: null,
        status: null,
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
