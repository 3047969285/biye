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
          v-hasPermi="['equipment:electricalData:add']"
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
          v-hasPermi="['equipment:electricalData:remove']"
        >删除</el-button>
      </el-col>
    </el-row>

    <el-table v-loading="loading" :data="dataList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" align="center" prop="electricalId" min-width="80" />
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
      <el-table-column label="采集时间" align="center" prop="timestamp" min-width="180" :formatter="formatTableTime" />
      <el-table-column label="L1相电压(V)" align="center" prop="voltageL1" min-width="120" />
      <el-table-column label="L2相电压(V)" align="center" prop="voltageL2" min-width="120" />
      <el-table-column label="L3相电压(V)" align="center" prop="voltageL3" min-width="120" />
      <el-table-column label="有功功率(kW)" align="center" prop="activePower" min-width="120" />
      <el-table-column label="功率因数" align="center" prop="powerFactor" min-width="100" />
      <el-table-column label="效率(%)" align="center" prop="efficiency" min-width="100" />
      <el-table-column label="电器等级" align="center" prop="electricalGrade" min-width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.electricalGrade === 1" type="success">优良</el-tag>
          <el-tag v-else-if="scope.row.electricalGrade === 2" type="info">良好</el-tag>
          <el-tag v-else-if="scope.row.electricalGrade === 3" type="warning">一般</el-tag>
          <el-tag v-else-if="scope.row.electricalGrade === 4" type="danger">较差</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="160" fixed="right">
        <template slot-scope="scope">
          <el-button
            size="small"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['equipment:electricalData:edit']"
          >修改</el-button>
          <el-button
            size="small"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['equipment:electricalData:remove']"
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

    <!-- 添加或修改电气数据对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="1000px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="160px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="设备" prop="deviceId">
              <device-select v-model="form.deviceId" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="采集时间" prop="timestamp">
              <el-date-picker
                v-model="form.timestamp"
                type="datetime"
                placeholder="选择采集时间"
                style="width: 100%"
                value-format="yyyy-MM-dd HH:mm:ss"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-divider content-position="left">电压相关</el-divider>
        <el-row>
          <el-col :span="8">
            <el-form-item label="L1相电压(V)" prop="voltageL1">
              <el-input-number v-model="form.voltageL1" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="L2相电压(V)" prop="voltageL2">
              <el-input-number v-model="form.voltageL2" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="L3相电压(V)" prop="voltageL3">
              <el-input-number v-model="form.voltageL3" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="电压不平衡率(%)" prop="voltageUnbalance">
              <el-input-number v-model="form.voltageUnbalance" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="电压波动率(%)" prop="voltageFluctuation">
              <el-input-number v-model="form.voltageFluctuation" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="电网频率(Hz)" prop="frequency">
              <el-input-number v-model="form.frequency" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-divider content-position="left">电流相关</el-divider>
        <el-row>
          <el-col :span="8">
            <el-form-item label="L1相电流(A)" prop="currentL1">
              <el-input-number v-model="form.currentL1" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="L2相电流(A)" prop="currentL2">
              <el-input-number v-model="form.currentL2" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="L3相电流(A)" prop="currentL3">
              <el-input-number v-model="form.currentL3" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="电流不平衡率(%)" prop="currentUnbalance">
              <el-input-number v-model="form.currentUnbalance" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="总电流(A)" prop="totalCurrent">
              <el-input-number v-model="form.totalCurrent" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-divider content-position="left">功率相关</el-divider>
        <el-row>
          <el-col :span="8">
            <el-form-item label="有功功率(kW)" prop="activePower">
              <el-input-number v-model="form.activePower" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="无功功率(kVar)" prop="reactivePower">
              <el-input-number v-model="form.reactivePower" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="视在功率(kVA)" prop="apparentPower">
              <el-input-number v-model="form.apparentPower" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="功率因数" prop="powerFactor">
              <el-input-number v-model="form.powerFactor" :precision="2" :min="0" :max="1" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="效率(%)" prop="efficiency">
              <el-input-number v-model="form.efficiency" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-divider content-position="left">谐波相关</el-divider>
        <el-row>
          <el-col :span="12">
            <el-form-item label="电压谐波含量" prop="harmonicsVoltage">
              <el-input v-model="form.harmonicsVoltage" placeholder="请输入电压谐波含量" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="电流谐波含量" prop="harmonicsCurrent">
              <el-input v-model="form.harmonicsCurrent" placeholder="请输入电流谐波含量" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="总谐波失真率(%)" prop="totalHarmonicDistortion">
              <el-input-number v-model="form.totalHarmonicDistortion" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="电压总谐波失真率(%)" prop="voltageThd">
              <el-input-number v-model="form.voltageThd" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="电流总谐波失真率(%)" prop="currentThd">
              <el-input-number v-model="form.currentThd" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-divider content-position="left">其他参数</el-divider>
        <el-row>
          <el-col :span="8">
            <el-form-item label="电磁干扰强度(dB)" prop="electromagneticInterference">
              <el-input-number v-model="form.electromagneticInterference" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="接地电阻(Ω)" prop="groundingResistance">
              <el-input-number v-model="form.groundingResistance" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="屏蔽效果(dB)" prop="shieldingEffectiveness">
              <el-input-number v-model="form.shieldingEffectiveness" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="电器等级" prop="electricalGrade">
              <el-select v-model="form.electricalGrade" placeholder="请选择电器等级" style="width: 100%">
                <el-option label="优良" :value="1" />
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
import { listElectricalData, getElectricalData, delElectricalData, addElectricalData, updateElectricalData } from "@/api/equipment/electricalData";
import dataAcquisitionDevice from '@/mixins/dataAcquisitionDevice'

export default {
  name: "ElectricalData",
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
        deviceId: null
      },
      rules: {
        deviceId: [
          { required: true, message: "请选择设备", trigger: "blur" }
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
      listElectricalData(this.queryParams).then(response => {
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
      this.ids = selection.map(item => item.electricalId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加电气数据";
    },
    handleUpdate(row) {
      this.reset();
      const electricalId = row.electricalId || this.ids[0];
      getElectricalData(electricalId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改电气数据";
      });
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.electricalId != null) {
            updateElectricalData(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addElectricalData(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    handleDelete(row) {
      const electricalIds = row.electricalId || this.ids;
      this.$modal.confirm('是否确认删除电气数据编号为"' + electricalIds + '"的数据项？').then(function() {
        return delElectricalData(electricalIds);
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
        electricalId: null,
        deviceId: null,
        timestamp: null,
        voltageL1: null,
        voltageL2: null,
        voltageL3: null,
        voltageUnbalance: null,
        frequency: null,
        voltageFluctuation: null,
        currentL1: null,
        currentL2: null,
        currentL3: null,
        currentUnbalance: null,
        totalCurrent: null,
        activePower: null,
        reactivePower: null,
        apparentPower: null,
        powerFactor: null,
        efficiency: null,
        harmonicsVoltage: null,
        harmonicsCurrent: null,
        totalHarmonicDistortion: null,
        voltageThd: null,
        currentThd: null,
        electromagneticInterference: null,
        groundingResistance: null,
        shieldingEffectiveness: null,
        electricalGrade: null
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
