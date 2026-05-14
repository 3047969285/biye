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
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="全部状态" clearable style="width: 140px">
          <el-option label="已触发" :value="1" />
          <el-option label="已解决" :value="2" />
          <el-option label="已确认" :value="3" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="small" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="small" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="small" @click="handleAdd" v-hasPermi="['equipment:alertRecord:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="small" :disabled="multiple" @click="handleDelete" v-hasPermi="['equipment:alertRecord:remove']">删除</el-button>
      </el-col>
    </el-row>

    <el-table v-loading="loading" :data="alertList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="告警ID" align="center" prop="alertId" min-width="80" />
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
      <el-table-column label="告警类型" align="center" prop="alertType" min-width="140" show-overflow-tooltip>
        <template slot-scope="scope">
          {{ displayAlertType(scope.row) }}
        </template>
      </el-table-column>
      <el-table-column label="告警级别" align="center" prop="alertLevel" min-width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.alertLevel === 1" type="info" size="small">一般</el-tag>
          <el-tag v-else-if="scope.row.alertLevel === 2" type="warning" size="small">严重</el-tag>
          <el-tag v-else-if="scope.row.alertLevel === 3" type="danger" size="small">紧急</el-tag>
          <el-tag v-else type="success" size="small">轻微</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="告警时间" align="center" prop="triggeredTime" min-width="170" show-overflow-tooltip>
        <template slot-scope="scope">
          {{ formatDateTimeDisplay(scope.row.triggeredTime) }}
        </template>
      </el-table-column>
      <el-table-column label="告警内容" align="center" prop="alertMessage" min-width="188" show-overflow-tooltip>
        <template slot-scope="scope">
          <span>{{ scope.row.alertMessage || scope.row.alertContent || '-' }}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" align="center" prop="status" min-width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status === 2" type="success" size="small">已解决</el-tag>
          <el-tag v-else-if="scope.row.status === 3" type="info" size="small">已确认</el-tag>
          <el-tag v-else type="warning" size="small">已触发</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="160" fixed="right">
        <template slot-scope="scope">
          <el-button size="small" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['equipment:alertRecord:edit']">修改</el-button>
          <el-button size="small" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['equipment:alertRecord:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="设备" prop="deviceId">
          <device-select v-model="form.deviceId" />
        </el-form-item>
        <el-form-item label="告警类型" prop="alertType">
          <el-select
            v-model="form.alertType"
            filterable
            allow-create
            default-first-option
            clearable
            placeholder="请选择或输入告警类型"
            style="width: 100%"
          >
            <el-option
              v-for="item in alertTypeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="告警级别" prop="alertLevel">
          <el-select v-model="form.alertLevel" placeholder="请选择告警级别">
            <el-option label="一般" :value="1" />
            <el-option label="严重" :value="2" />
            <el-option label="紧急" :value="3" />
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
          <el-input :value="formatDateTimeDisplay(form.triggeredTime)" disabled />
        </el-form-item>
        <el-form-item label="解决时间" prop="resolvedTime" v-if="form.resolvedTime">
          <el-input :value="formatDateTimeDisplay(form.resolvedTime)" disabled />
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
import dataAcquisitionDevice from '@/mixins/dataAcquisitionDevice'

export default {
  name: "AlertRecord",
  mixins: [dataAcquisitionDevice],
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
        deviceId: null,
        status: null
      },
      alertTypeOptions: [
        { label: "规则告警", value: "规则告警" },
        { label: "手工录入", value: "手工录入" },
        { label: "负载过高", value: "负载过高" },
        { label: "振动异常", value: "振动异常" },
        { label: "温度异常", value: "温度异常" },
        { label: "电压异常", value: "电压异常" },
        { label: "绝缘劣化", value: "绝缘劣化" },
        { label: "通信中断", value: "通信中断" }
      ],
      rules: {
        deviceId: [{ required: true, message: "请选择设备", trigger: "blur" }]
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 统一显示为 yyyy-MM-dd HH:mm:ss */
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
    /** 表格展示：兼容 alert_type 乱码（????）、空值时按告警内容推断 */
    displayAlertType(row) {
      let t = row && row.alertType;
      if (t != null && String(t).trim() !== "") {
        const s = String(t).trim();
        if (/^[\uFFFD?]+$/.test(s)) {
          t = null;
        } else {
          return s;
        }
      }
      const msg = (row && row.alertMessage) || "";
      const m = msg.match(/规则\[([^\]]+)\]/);
      if (m) {
        return m[1].trim();
      }
      if (row && (row.ruleId || (row.remark && String(row.remark).indexOf("规则引擎") >= 0))) {
        return "规则告警";
      }
      return "手工录入";
    },
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
          // 然后按告警级别排序：紧急(3) > 严重(2) > 一般(1) > 其他
          const weight = level => {
            if (level === 3) return 3;
            if (level === 2) return 2;
            if (level === 1) return 1;
            return 0;
          };
          const weightA = weight(a.alertLevel);
          const weightB = weight(b.alertLevel);
          if (weightA !== weightB) {
            return weightB - weightA;
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
      this.clearDataAcquisitionDeviceFilter();
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
        this.form = response.data || {};
        const at = this.form.alertType;
        if (at != null && /^[\uFFFD?]+$/.test(String(at).trim())) {
          this.form.alertType = this.displayAlertType(this.form);
        }
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
        alertType: null,
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
