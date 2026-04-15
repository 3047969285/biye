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
          v-hasPermi="['equipment:technologyData:add']"
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
          v-hasPermi="['equipment:technologyData:remove']"
        >删除</el-button>
      </el-col>
    </el-row>

    <el-table v-loading="loading" :data="dataList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" align="center" prop="techId" width="80" />
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
      <el-table-column label="更新时间" align="center" prop="timestamp" width="180" :formatter="formatTableTime" />
      <el-table-column label="技术等级" align="center" prop="technologyLevel" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.technologyLevel === 1" type="danger">落后</el-tag>
          <el-tag v-else-if="scope.row.technologyLevel === 2" type="warning">一般</el-tag>
          <el-tag v-else-if="scope.row.technologyLevel === 3" type="info">先进</el-tag>
          <el-tag v-else-if="scope.row.technologyLevel === 4" type="success">领先</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="数字化等级" align="center" prop="digitalizationLevel" width="120">
        <template slot-scope="scope">
          <span v-if="scope.row.digitalizationLevel === 1">低</span>
          <span v-else-if="scope.row.digitalizationLevel === 2">中</span>
          <span v-else-if="scope.row.digitalizationLevel === 3">高</span>
          <span v-else-if="scope.row.digitalizationLevel === 4">超高</span>
        </template>
      </el-table-column>
      <el-table-column label="技术成熟度" align="center" prop="technologyMaturity" width="120">
        <template slot-scope="scope">
          <span v-if="scope.row.technologyMaturity === 1">试验</span>
          <span v-else-if="scope.row.technologyMaturity === 2">试用</span>
          <span v-else-if="scope.row.technologyMaturity === 3">推广</span>
          <span v-else-if="scope.row.technologyMaturity === 4">成熟</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="160" fixed="right">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['equipment:technologyData:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['equipment:technologyData:remove']"
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

    <!-- 添加或修改技术数据对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="140px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="设备ID" prop="deviceId">
              <el-input-number v-model="form.deviceId" placeholder="请输入设备ID" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="更新时间" prop="timestamp">
              <el-date-picker
                v-model="form.timestamp"
                type="datetime"
                placeholder="选择更新时间"
                style="width: 100%"
                value-format="yyyy-MM-dd HH:mm:ss"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="技术等级" prop="technologyLevel">
              <el-select v-model="form.technologyLevel" placeholder="请选择技术等级" style="width: 100%">
                <el-option label="落后" :value="1" />
                <el-option label="一般" :value="2" />
                <el-option label="先进" :value="3" />
                <el-option label="领先" :value="4" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="标准符合情况" prop="standardCompliance">
              <el-input v-model="form.standardCompliance" placeholder="请输入标准符合情况" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="认证状态" prop="certificationStatus">
              <el-select v-model="form.certificationStatus" placeholder="请选择认证状态" style="width: 100%">
                <el-option label="有效" :value="1" />
                <el-option label="过期" :value="2" />
                <el-option label="待审核" :value="3" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="软件版本" prop="softwareVersion">
              <el-input v-model="form.softwareVersion" placeholder="请输入软件版本" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="固件版本" prop="firmwareVersion">
              <el-input v-model="form.firmwareVersion" placeholder="请输入固件版本" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="系统更新次数" prop="systemUpdates">
              <el-input-number v-model="form.systemUpdates" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="数字化等级" prop="digitalizationLevel">
              <el-select v-model="form.digitalizationLevel" placeholder="请选择数字化等级" style="width: 100%">
                <el-option label="低" :value="1" />
                <el-option label="中" :value="2" />
                <el-option label="高" :value="3" />
                <el-option label="超高" :value="4" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="连接水平" prop="connectivityLevel">
              <el-select v-model="form.connectivityLevel" placeholder="请选择连接水平" style="width: 100%">
                <el-option label="无连接" :value="1" />
                <el-option label="基础连接" :value="2" />
                <el-option label="智能连接" :value="3" />
                <el-option label="全连接" :value="4" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="技术成熟度" prop="technologyMaturity">
              <el-select v-model="form.technologyMaturity" placeholder="请选择技术成熟度" style="width: 100%">
                <el-option label="试验" :value="1" />
                <el-option label="试用" :value="2" />
                <el-option label="推广" :value="3" />
                <el-option label="成熟" :value="4" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="淘汰风险" prop="obsolescenceRisk">
              <el-select v-model="form.obsolescenceRisk" placeholder="请选择淘汰风险" style="width: 100%">
                <el-option label="低" :value="1" />
                <el-option label="中" :value="2" />
                <el-option label="高" :value="3" />
                <el-option label="极高" :value="4" />
              </el-select>
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
import { listTechnologyData, getTechnologyData, delTechnologyData, addTechnologyData, updateTechnologyData } from "@/api/equipment/technologyData";

export default {
  name: "TechnologyData",
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
        deviceId: null
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
    // 表格时间字段格式化
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
      listTechnologyData(this.queryParams).then(response => {
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
      this.ids = selection.map(item => item.techId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加技术数据";
    },
    handleUpdate(row) {
      this.reset();
      const techId = row.techId || this.ids[0];
      getTechnologyData(techId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改技术数据";
      });
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.techId != null) {
            updateTechnologyData(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addTechnologyData(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    handleDelete(row) {
      const techIds = row.techId || this.ids;
      this.$modal.confirm('是否确认删除技术数据编号为"' + techIds + '"的数据项？').then(function() {
        return delTechnologyData(techIds);
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
        techId: null,
        deviceId: null,
        timestamp: null,
        technologyLevel: null,
        standardCompliance: null,
        certificationStatus: null,
        softwareVersion: null,
        firmwareVersion: null,
        systemUpdates: null,
        digitalizationLevel: null,
        connectivityLevel: null,
        technologyMaturity: null,
        obsolescenceRisk: null
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
