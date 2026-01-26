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
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['equipment:alertRecord:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['equipment:alertRecord:remove']">删除</el-button>
      </el-col>
    </el-row>

    <el-table v-loading="loading" :data="alertList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="告警ID" align="center" prop="alertId" width="80" />
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
      <el-table-column label="告警类型" align="center" prop="alertType" width="120" show-overflow-tooltip />
      <el-table-column label="告警级别" align="center" prop="alertLevel" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.alertLevel === 1" type="danger" size="small">紧急</el-tag>
          <el-tag v-else-if="scope.row.alertLevel === 2" type="warning" size="small">严重</el-tag>
          <el-tag v-else-if="scope.row.alertLevel === 3" type="info" size="small">一般</el-tag>
          <el-tag v-else type="" size="small">轻微</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="告警时间" align="center" prop="triggeredTime" width="180" show-overflow-tooltip />
      <el-table-column label="告警内容" align="center" prop="alertMessage" min-width="200" show-overflow-tooltip>
        <template slot-scope="scope">
          <span>{{ scope.row.alertMessage || scope.row.alertContent || '-' }}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" align="center" prop="status" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status === 2" type="success" size="small">已解决</el-tag>
          <el-tag v-else-if="scope.row.status === 3" type="info" size="small">已确认</el-tag>
          <el-tag v-else type="warning" size="small">已触发</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="160" fixed="right">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['equipment:alertRecord:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['equipment:alertRecord:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="设备ID" prop="deviceId">
          <el-input v-model="form.deviceId" placeholder="请输入设备ID" />
        </el-form-item>
        <el-form-item label="告警类型" prop="alertType">
          <el-input v-model="form.alertType" placeholder="请输入告警类型" />
        </el-form-item>
        <el-form-item label="告警级别" prop="alertLevel">
          <el-select v-model="form.alertLevel" placeholder="请选择告警级别">
            <el-option label="紧急" :value="1" />
            <el-option label="严重" :value="2" />
            <el-option label="一般" :value="3" />
            <el-option label="轻微" :value="4" />
          </el-select>
        </el-form-item>
        <el-form-item label="告警内容" prop="alertMessage">
          <el-input v-model="form.alertMessage" type="textarea" :rows="4" placeholder="请输入告警内容" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="form.status" placeholder="请选择状态">
            <el-option label="已触发" :value="1" />
            <el-option label="已解决" :value="2" />
            <el-option label="已确认" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="告警时间" prop="triggeredTime" v-if="form.triggeredTime">
          <el-input v-model="form.triggeredTime" disabled />
        </el-form-item>
        <el-form-item label="解决时间" prop="resolvedTime" v-if="form.resolvedTime">
          <el-input v-model="form.resolvedTime" disabled />
        </el-form-item>
        <el-form-item label="解决备注" prop="resolutionNotes">
          <el-input v-model="form.resolutionNotes" type="textarea" :rows="3" placeholder="请输入解决备注" />
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
import { listAlertRecord, getAlertRecord, delAlertRecord, addAlertRecord, updateAlertRecord } from "@/api/equipment/alertRecord";

export default {
  name: "AlertRecord",
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      total: 0,
      alertList: [],
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
      listAlertRecord(this.queryParams).then(response => {
        let list = response.rows || [];
        // 前端排序：确保未处理（status=1）和告警级别高的排在前面
        list.sort((a, b) => {
          // 首先按状态排序：status=1（已触发/未处理）排在前面
          const statusA = a.status === 1 ? 0 : 1;
          const statusB = b.status === 1 ? 0 : 1;
          if (statusA !== statusB) {
            return statusA - statusB;
          }
          // 然后按告警级别排序：级别越小（1=紧急）越靠前
          const levelA = a.alertLevel || 999;
          const levelB = b.alertLevel || 999;
          if (levelA !== levelB) {
            return levelA - levelB;
          }
          // 最后按触发时间倒序：最新的排在前面
          const timeA = a.triggeredTime ? new Date(a.triggeredTime).getTime() : 0;
          const timeB = b.triggeredTime ? new Date(b.triggeredTime).getTime() : 0;
          return timeB - timeA;
        });
        this.alertList = list;
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
      this.ids = selection.map(item => item.alertId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加告警记录";
    },
    handleUpdate(row) {
      this.reset();
      const alertId = row.alertId || this.ids[0];
      getAlertRecord(alertId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改告警记录";
      });
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.alertId != null) {
            updateAlertRecord(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addAlertRecord(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    handleDelete(row) {
      const alertIds = row.alertId || this.ids;
      this.$modal.confirm('是否确认删除告警记录编号为"' + alertIds + '"的数据项？').then(function() {
        return delAlertRecord(alertIds);
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
        alertId: null,
        deviceId: null,
        deviceNo: null,
        deviceName: null,
        ruleId: null,
        alertLevel: null,
        alertMessage: null,
        triggeredTime: null,
        resolvedTime: null,
        status: null,
        resolvedBy: null,
        resolutionNotes: null,
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
