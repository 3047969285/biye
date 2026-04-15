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
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['equipment:economicData:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['equipment:economicData:remove']">删除</el-button>
      </el-col>
    </el-row>

    <el-table v-loading="loading" :data="dataList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" align="center" prop="economicId" width="80" />
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
      <el-table-column label="记录时间" align="center" prop="timestamp" width="180" :formatter="formatTableTime" />
      <el-table-column label="维护成本" align="center" prop="maintainanceCost" width="120" />
      <el-table-column label="能耗" align="center" prop="energyConsumption" width="120" />
      <el-table-column label="人工成本" align="center" prop="laborCost" width="120" />
      <el-table-column label="配件成本" align="center" prop="partCost" width="120" />
      <el-table-column label="投资回报率" align="center" prop="roi" width="120" />
      <el-table-column label="环境影响" align="center" prop="environmentalImpact" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.environmentalImpact === 1" type="success">优秀</el-tag>
          <el-tag v-else-if="scope.row.environmentalImpact === 2" type="info">良好</el-tag>
          <el-tag v-else-if="scope.row.environmentalImpact === 3" type="warning">一般</el-tag>
          <el-tag v-else-if="scope.row.environmentalImpact === 4" type="danger">较差</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="160" fixed="right">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['equipment:economicData:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['equipment:economicData:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="900px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="140px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="设备ID" prop="deviceId">
              <el-input-number v-model="form.deviceId" placeholder="请输入设备ID" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="记录时间" prop="timestamp">
              <el-date-picker
                v-model="form.timestamp"
                type="datetime"
                placeholder="选择记录时间"
                style="width: 100%"
                value-format="yyyy-MM-dd HH:mm:ss"
              />
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
            <el-form-item label="能耗" prop="energyConsumption">
              <el-input-number v-model="form.energyConsumption" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="人工成本" prop="laborCost">
              <el-input-number v-model="form.laborCost" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="配件成本" prop="partCost">
              <el-input-number v-model="form.partCost" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="停机损失" prop="downtimeCost">
              <el-input-number v-model="form.downtimeCost" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="投资回报率" prop="roi">
              <el-input-number v-model="form.roi" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="净现值" prop="npv">
              <el-input-number v-model="form.npv" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="投资回收期" prop="paybackPeriod">
              <el-input-number v-model="form.paybackPeriod" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="年度预算" prop="annualBudget">
              <el-input-number v-model="form.annualBudget" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="实际支出" prop="actualSpending">
              <el-input-number v-model="form.actualSpending" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="预算利用率" prop="budgetUtilization">
              <el-input-number v-model="form.budgetUtilization" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="法规符合率" prop="regulatoryImpact">
              <el-input-number v-model="form.regulatoryImpact" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="环境影响评级" prop="environmentalImpact">
              <el-select v-model="form.environmentalImpact" placeholder="请选择环境影响评级" style="width: 100%">
                <el-option label="优秀" :value="1" />
                <el-option label="良好" :value="2" />
                <el-option label="一般" :value="3" />
                <el-option label="较差" :value="4" />
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
import { listEconomicData, getEconomicData, delEconomicData, addEconomicData, updateEconomicData } from "@/api/equipment/economicData";

export default {
  name: "EconomicData",
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
        deviceId: [{ required: true, message: "设备ID不能为空", trigger: "blur" }]
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
      listEconomicData(this.queryParams).then(response => {
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
      this.ids = selection.map(item => item.economicId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加经济数据";
    },
    handleUpdate(row) {
      this.reset();
      const economicId = row.economicId || this.ids[0];
      getEconomicData(economicId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改经济数据";
      });
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.economicId != null) {
            updateEconomicData(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addEconomicData(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    handleDelete(row) {
      const economicIds = row.economicId || this.ids;
      this.$modal.confirm('是否确认删除经济数据编号为"' + economicIds + '"的数据项？').then(function() {
        return delEconomicData(economicIds);
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
        economicId: null,
        deviceId: null,
        timestamp: null,
        maintainanceCost: null,
        energyConsumption: null,
        laborCost: null,
        partCost: null,
        downtimeCost: null,
        roi: null,
        npv: null,
        paybackPeriod: null,
        annualBudget: null,
        actualSpending: null,
        budgetUtilization: null,
        regulatoryImpact: null,
        environmentalImpact: null
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
