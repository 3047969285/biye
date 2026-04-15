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
      <el-form-item label="操作员名称" prop="operatorName">
        <el-input
          v-model="queryParams.operatorName"
          placeholder="请输入操作员名称"
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
          v-hasPermi="['equipment:operationalData:add']"
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
          v-hasPermi="['equipment:operationalData:remove']"
        >删除</el-button>
      </el-col>
    </el-row>

    <el-table v-loading="loading" :data="dataList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" align="center" prop="operationalId" width="80" />
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
      <el-table-column label="操作时间" align="center" prop="timestamp" width="180" :formatter="formatTableTime" />
      <el-table-column label="操作员名称" align="center" prop="operatorName" width="120" />
      <el-table-column label="操作类型" align="center" prop="operationType" width="100">
        <template slot-scope="scope">
          <span v-if="scope.row.operationType === 1">开机</span>
          <span v-else-if="scope.row.operationType === 2">关机</span>
          <span v-else-if="scope.row.operationType === 3">调试</span>
          <span v-else-if="scope.row.operationType === 4">维护</span>
          <span v-else-if="scope.row.operationType === 5">故障处理</span>
        </template>
      </el-table-column>
      <el-table-column label="操作结果" align="center" prop="operationResult" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.operationResult === '1'" type="success">成功</el-tag>
          <el-tag v-else-if="scope.row.operationResult === '2'" type="danger">失败</el-tag>
          <el-tag v-else-if="scope.row.operationResult === '3'" type="warning">警告</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作时长(秒)" align="center" prop="operationDuration" width="120" />
      <el-table-column label="操作" align="center" width="160" fixed="right">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['equipment:operationalData:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['equipment:operationalData:remove']"
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

    <!-- 添加或修改操作数据对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="900px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="160px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="设备ID" prop="deviceId">
              <el-input-number v-model="form.deviceId" placeholder="请输入设备ID" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="操作时间" prop="timestamp">
              <el-date-picker
                v-model="form.timestamp"
                type="datetime"
                placeholder="选择操作时间"
                style="width: 100%"
                value-format="yyyy-MM-dd HH:mm:ss"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="操作员ID" prop="operatorId">
              <el-input-number v-model="form.operatorId" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="操作员名称" prop="operatorName">
              <el-input v-model="form.operatorName" placeholder="请输入操作员名称" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="操作员技能等级" prop="operatorSkillLevel">
              <el-select v-model="form.operatorSkillLevel" placeholder="请选择技能等级" style="width: 100%">
                <el-option label="初级" :value="1" />
                <el-option label="中级" :value="2" />
                <el-option label="高级" :value="3" />
                <el-option label="专家" :value="4" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="培训完成度(%)" prop="trainingCompletion">
              <el-input-number v-model="form.trainingCompletion" :min="0" :max="100" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="操作类型" prop="operationType">
              <el-select v-model="form.operationType" placeholder="请选择操作类型" style="width: 100%">
                <el-option label="开机" :value="1" />
                <el-option label="关机" :value="2" />
                <el-option label="调试" :value="3" />
                <el-option label="维护" :value="4" />
                <el-option label="故障处理" :value="5" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="操作时长(秒)" prop="operationDuration">
              <el-input-number v-model="form.operationDuration" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="操作结果" prop="operationResult">
              <el-select v-model="form.operationResult" placeholder="请选择操作结果" style="width: 100%">
                <el-option label="成功" value="1" />
                <el-option label="失败" value="2" />
                <el-option label="警告" value="3" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="操作备注" prop="operationNotes">
              <el-input v-model="form.operationNotes" placeholder="请输入操作备注" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="维护类型" prop="maintainanceType">
              <el-select v-model="form.maintainanceType" placeholder="请选择维护类型" style="width: 100%">
                <el-option label="预防性" :value="1" />
                <el-option label="纠正性" :value="2" />
                <el-option label="预测性" :value="3" />
                <el-option label="紧急" :value="4" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="维护时长(秒)" prop="maintainanceDuration">
              <el-input-number v-model="form.maintainanceDuration" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="维护成本" prop="maintainanceCost">
              <el-input-number v-model="form.maintainanceCost" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="使用的部件" prop="partsUsed">
              <el-input v-model="form.partsUsed" placeholder="请输入使用的部件" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="操作员绩效评分" prop="operatorPerformanceScore">
              <el-input-number v-model="form.operatorPerformanceScore" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="安全合规度" prop="safetyCompliance">
              <el-input-number v-model="form.safetyCompliance" :min="0" :max="100" style="width: 100%" />
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
import { listOperationalData, getOperationalData, delOperationalData, addOperationalData, updateOperationalData } from "@/api/equipment/operationalData";

export default {
  name: "OperationalData",
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
        operatorName: null
      },
      rules: {
        deviceId: [
          { required: true, message: "设备ID不能为空", trigger: "blur" }
        ]
      }
    };
  },
  created() {
    this.getList();
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
    getList() {
      this.loading = true;
      listOperationalData(this.queryParams).then(response => {
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
      this.ids = selection.map(item => item.operationalId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加操作数据";
    },
    handleUpdate(row) {
      this.reset();
      const operationalId = row.operationalId || this.ids[0];
      getOperationalData(operationalId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改操作数据";
      });
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.operationalId != null) {
            updateOperationalData(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addOperationalData(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    handleDelete(row) {
      const operationalIds = row.operationalId || this.ids;
      this.$modal.confirm('是否确认删除操作数据编号为"' + operationalIds + '"的数据项？').then(function() {
        return delOperationalData(operationalIds);
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
        operationalId: null,
        deviceId: null,
        timestamp: null,
        operatorId: null,
        operatorName: null,
        operatorSkillLevel: null,
        trainingCompletion: null,
        operationType: null,
        operationDuration: null,
        operationResult: null,
        operationNotes: null,
        maintainanceType: null,
        maintainanceDuration: null,
        maintainanceCost: null,
        partsUsed: null,
        operatorPerformanceScore: null,
        safetyCompliance: null
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
