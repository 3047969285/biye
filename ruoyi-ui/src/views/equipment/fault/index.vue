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
      <el-form-item label="故障代码" prop="faultCode">
        <el-input
          v-model="queryParams.faultCode"
          placeholder="请输入故障代码"
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
          v-hasPermi="['equipment:faultRecord:add']"
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
          v-hasPermi="['equipment:faultRecord:remove']"
        >删除</el-button>
      </el-col>
    </el-row>

    <el-table v-loading="loading" :data="dataList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="故障ID" align="center" prop="faultId" width="80" />
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
      <el-table-column label="故障代码" align="center" prop="faultCode" width="120" />
      <el-table-column label="故障描述" align="center" prop="faultDescription" width="200" show-overflow-tooltip />
      <el-table-column label="故障等级" align="center" prop="faultLevel" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.faultLevel === '1'" type="danger">紧急</el-tag>
          <el-tag v-else-if="scope.row.faultLevel === '2'" type="warning">严重</el-tag>
          <el-tag v-else-if="scope.row.faultLevel === '3'" type="info">一般</el-tag>
          <el-tag v-else-if="scope.row.faultLevel === '4'" type="success">轻微</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="发现时间" align="center" prop="detectedTime" width="160" />
      <el-table-column label="解决时间" align="center" prop="resolvedTime" width="160" />
      <el-table-column label="状态" align="center" prop="status" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status === 1" type="warning">待处理</el-tag>
          <el-tag v-else-if="scope.row.status === 2" type="success">已解决</el-tag>
          <el-tag v-else-if="scope.row.status === 3" type="info">处理中</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="160" fixed="right">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['equipment:faultRecord:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['equipment:faultRecord:remove']"
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

    <!-- 添加或修改故障记录对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="900px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="140px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="设备ID" prop="deviceId">
              <el-input-number v-model="form.deviceId" placeholder="请输入设备ID" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="故障代码" prop="faultCode">
              <el-input v-model="form.faultCode" placeholder="请输入故障代码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="故障描述" prop="faultDescription">
              <el-input v-model="form.faultDescription" type="textarea" :rows="2" placeholder="请输入故障描述" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="故障等级" prop="faultLevel">
              <el-select v-model="form.faultLevel" placeholder="请选择故障等级" style="width: 100%">
                <el-option label="紧急" value="1" />
                <el-option label="严重" value="2" />
                <el-option label="一般" value="3" />
                <el-option label="轻微" value="4" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态" prop="status">
              <el-select v-model="form.status" placeholder="请选择状态" style="width: 100%">
                <el-option label="待处理" :value="1" />
                <el-option label="已解决" :value="2" />
                <el-option label="处理中" :value="3" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="故障发现时间" prop="detectedTime">
              <el-date-picker
                v-model="form.detectedTime"
                type="datetime"
                placeholder="选择故障发现时间"
                style="width: 100%"
                value-format="yyyy-MM-dd HH:mm:ss"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="故障解决时间" prop="resolvedTime">
              <el-date-picker
                v-model="form.resolvedTime"
                type="datetime"
                placeholder="选择故障解决时间"
                style="width: 100%"
                value-format="yyyy-MM-dd HH:mm:ss"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="修复时长(分钟)" prop="repairDuration">
              <el-input-number v-model="form.repairDuration" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="修复成本" prop="repairCost">
              <el-input-number v-model="form.repairCost" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="替换部件" prop="partsReplaced">
              <el-input v-model="form.partsReplaced" placeholder="请输入替换部件" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="解决措施" prop="resolutionNotes">
              <el-input v-model="form.resolutionNotes" type="textarea" :rows="3" placeholder="请输入解决措施" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="根本原因" prop="rootCause">
              <el-input v-model="form.rootCause" type="textarea" :rows="3" placeholder="请输入根本原因" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="备注" prop="remark">
              <el-input v-model="form.remark" type="textarea" :rows="2" placeholder="请输入备注" />
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
import { listFaultRecord, getFaultRecord, delFaultRecord, addFaultRecord, updateFaultRecord } from "@/api/equipment/faultRecord";

export default {
  name: "FaultRecord",
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
        faultCode: null
      },
      rules: {
        deviceId: [
          { required: true, message: "设备ID不能为空", trigger: "blur" }
        ],
        faultCode: [
          { required: true, message: "故障代码不能为空", trigger: "blur" }
        ],
        faultDescription: [
          { required: true, message: "故障描述不能为空", trigger: "blur" }
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
      listFaultRecord(this.queryParams).then(response => {
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
      this.ids = selection.map(item => item.faultId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加故障记录";
    },
    handleUpdate(row) {
      this.reset();
      const faultId = row.faultId || this.ids[0];
      getFaultRecord(faultId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改故障记录";
      });
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.faultId != null) {
            updateFaultRecord(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addFaultRecord(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    handleDelete(row) {
      const faultIds = row.faultId || this.ids;
      this.$modal.confirm('是否确认删除故障记录编号为"' + faultIds + '"的数据项？').then(function() {
        return delFaultRecord(faultIds);
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
        faultId: null,
        deviceId: null,
        faultCode: null,
        faultDescription: null,
        faultLevel: null,
        detectedTime: null,
        resolvedTime: null,
        resolutionNotes: null,
        rootCause: null,
        repairDuration: null,
        repairCost: null,
        partsReplaced: null,
        status: 1,
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
