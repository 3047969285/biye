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
          v-hasPermi="['equipment:mechanicalData:add']"
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
          v-hasPermi="['equipment:mechanicalData:remove']"
        >删除</el-button>
      </el-col>
    </el-row>

    <el-table v-loading="loading" :data="dataList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" align="center" prop="mechanicalId" min-width="80" />
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
      <el-table-column label="载荷重量(kg)" align="center" prop="loadWeight" min-width="120" />
      <el-table-column label="载荷比率(%)" align="center" prop="loadRatio" min-width="120" />
      <el-table-column label="应力水平(MPa)" align="center" prop="stressLevel" min-width="120" />
      <el-table-column label="振动振幅(mm)" align="center" prop="vibrationAmplitude" min-width="120" />
      <el-table-column label="机械等级" align="center" prop="mechanicalGrade" min-width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.mechanicalGrade === 1" type="success">优良</el-tag>
          <el-tag v-else-if="scope.row.mechanicalGrade === 2" type="info">良好</el-tag>
          <el-tag v-else-if="scope.row.mechanicalGrade === 3" type="warning">一般</el-tag>
          <el-tag v-else-if="scope.row.mechanicalGrade === 4" type="danger">较差</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="160" fixed="right">
        <template slot-scope="scope">
          <el-button
            size="small"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['equipment:mechanicalData:edit']"
          >修改</el-button>
          <el-button
            size="small"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['equipment:mechanicalData:remove']"
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

    <!-- 添加或修改机械数据对话框 -->
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
        <el-divider content-position="left">载荷相关</el-divider>
        <el-row>
          <el-col :span="8">
            <el-form-item label="载荷重量(kg)" prop="loadWeight">
              <el-input-number v-model="form.loadWeight" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="载荷比率(%)" prop="loadRatio">
              <el-input-number v-model="form.loadRatio" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="应力水平(MPa)" prop="stressLevel">
              <el-input-number v-model="form.stressLevel" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="疲劳循环次数" prop="fatigueCycles">
              <el-input-number v-model="form.fatigueCycles" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="过载次数" prop="overloadTimes">
              <el-input-number v-model="form.overloadTimes" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-divider content-position="left">振动相关</el-divider>
        <el-row>
          <el-col :span="8">
            <el-form-item label="振动振幅(mm)" prop="vibrationAmplitude">
              <el-input-number v-model="form.vibrationAmplitude" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="振动速度(mm/s)" prop="vibrationVelocity">
              <el-input-number v-model="form.vibrationVelocity" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="振动加速度(g)" prop="vibrationAcceleration">
              <el-input-number v-model="form.vibrationAcceleration" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="振动频谱数据" prop="vibrationSpectrum">
              <el-input v-model="form.vibrationSpectrum" placeholder="请输入振动频谱数据" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="振动方向" prop="vibrationDirection">
              <el-input v-model="form.vibrationDirection" placeholder="请输入振动方向" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-divider content-position="left">腐蚀相关</el-divider>
        <el-row>
          <el-col :span="8">
            <el-form-item label="腐蚀速率(mm/year)" prop="corrosionRate">
              <el-input-number v-model="form.corrosionRate" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="腐蚀深度(mm)" prop="corrosionDepth">
              <el-input-number v-model="form.corrosionDepth" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-divider content-position="left">材料相关</el-divider>
        <el-row>
          <el-col :span="8">
            <el-form-item label="表面状况" prop="surfaceCondition">
              <el-select v-model="form.surfaceCondition" placeholder="请选择表面状况" style="width: 100%">
                <el-option label="好" :value="1" />
                <el-option label="一般" :value="2" />
                <el-option label="较差" :value="3" />
                <el-option label="严重" :value="4" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="涂层厚度(mm)" prop="coatingThickness">
              <el-input-number v-model="form.coatingThickness" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="材料温度(°C)" prop="materialTemperature">
              <el-input-number v-model="form.materialTemperature" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="热膨胀系数" prop="thermalExpansion">
              <el-input-number v-model="form.thermalExpansion" :precision="4" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="材料硬度(HRC)" prop="materialHardness">
              <el-input-number v-model="form.materialHardness" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="机械等级" prop="mechanicalGrade">
              <el-select v-model="form.mechanicalGrade" placeholder="请选择机械等级" style="width: 100%">
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
import { listMechanicalData, getMechanicalData, delMechanicalData, addMechanicalData, updateMechanicalData } from "@/api/equipment/mechanicalData";
import dataAcquisitionDevice from '@/mixins/dataAcquisitionDevice'

export default {
  name: "MechanicalData",
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
      listMechanicalData(this.queryParams).then(response => {
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
      this.ids = selection.map(item => item.mechanicalId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加机械数据";
    },
    handleUpdate(row) {
      this.reset();
      const mechanicalId = row.mechanicalId || this.ids[0];
      getMechanicalData(mechanicalId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改机械数据";
      });
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.mechanicalId != null) {
            updateMechanicalData(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addMechanicalData(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    handleDelete(row) {
      const mechanicalIds = row.mechanicalId || this.ids;
      this.$modal.confirm('是否确认删除机械数据编号为"' + mechanicalIds + '"的数据项？').then(function() {
        return delMechanicalData(mechanicalIds);
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
        mechanicalId: null,
        deviceId: null,
        timestamp: null,
        loadWeight: null,
        loadRatio: null,
        stressLevel: null,
        fatigueCycles: null,
        overloadTimes: null,
        vibrationAmplitude: null,
        vibrationVelocity: null,
        vibrationAcceleration: null,
        vibrationSpectrum: null,
        vibrationDirection: null,
        corrosionRate: null,
        corrosionDepth: null,
        surfaceCondition: null,
        coatingThickness: null,
        materialTemperature: null,
        thermalExpansion: null,
        materialHardness: null,
        mechanicalGrade: null
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
