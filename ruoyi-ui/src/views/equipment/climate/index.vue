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
          v-hasPermi="['equipment:climateData:add']"
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
          v-hasPermi="['equipment:climateData:remove']"
        >删除</el-button>
      </el-col>
    </el-row>

    <el-table v-loading="loading" :data="dataList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" align="center" prop="climateId" width="80" />
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
      <el-table-column label="采集时间" align="center" prop="timestamp" width="160" />
      <el-table-column label="季节" align="center" prop="season" width="80">
        <template slot-scope="scope">
          <span v-if="scope.row.season === 1">春</span>
          <span v-else-if="scope.row.season === 2">夏</span>
          <span v-else-if="scope.row.season === 3">秋</span>
          <span v-else-if="scope.row.season === 4">冬</span>
        </template>
      </el-table-column>
      <el-table-column label="天气情况" align="center" prop="weatherCondition" width="120" />
      <el-table-column label="降水量" align="center" prop="precipitation" width="100" />
      <el-table-column label="风速" align="center" prop="windSpeed" width="100" />
      <el-table-column label="污染等级" align="center" prop="pollutionLevel" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.pollutionLevel === 1" type="success">优</el-tag>
          <el-tag v-else-if="scope.row.pollutionLevel === 2" type="info">良</el-tag>
          <el-tag v-else-if="scope.row.pollutionLevel === 3" type="warning">轻度污染</el-tag>
          <el-tag v-else-if="scope.row.pollutionLevel === 4" type="danger">中度污染</el-tag>
          <el-tag v-else-if="scope.row.pollutionLevel === 5" type="danger">重度污染</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="160" fixed="right">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['equipment:climateData:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['equipment:climateData:remove']"
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

    <!-- 添加或修改气候数据对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="900px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="160px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="设备ID" prop="deviceId">
              <el-input-number v-model="form.deviceId" placeholder="请输入设备ID" style="width: 100%" />
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
        <el-row>
          <el-col :span="12">
            <el-form-item label="季节" prop="season">
              <el-select v-model="form.season" placeholder="请选择季节" style="width: 100%">
                <el-option label="春" :value="1" />
                <el-option label="夏" :value="2" />
                <el-option label="秋" :value="3" />
                <el-option label="冬" :value="4" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="天气情况" prop="weatherCondition">
              <el-input v-model="form.weatherCondition" placeholder="请输入天气情况" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="降水量" prop="precipitation">
              <el-input-number v-model="form.precipitation" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="风速" prop="windSpeed">
              <el-input-number v-model="form.windSpeed" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="风向" prop="windDirection">
              <el-input v-model="form.windDirection" placeholder="请输入风向" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="极端天气" prop="extremeWeather">
              <el-input-number v-model="form.extremeWeather" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="天气持续时间" prop="weatherDuration">
              <el-input-number v-model="form.weatherDuration" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="极端温度" prop="temperatureExtreme">
              <el-input-number v-model="form.temperatureExtreme" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="自然灾害" prop="naturalDisasters">
              <el-input-number v-model="form.naturalDisasters" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="灾害强度" prop="disasterIntensity">
              <el-input-number v-model="form.disasterIntensity" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="灾害持续时间" prop="disasterDuration">
              <el-input-number v-model="form.disasterDuration" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="空气质量指数" prop="airQualityIndex">
              <el-input-number v-model="form.airQualityIndex" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="污染等级" prop="pollutionLevel">
              <el-select v-model="form.pollutionLevel" placeholder="请选择污染等级" style="width: 100%">
                <el-option label="优" :value="1" />
                <el-option label="良" :value="2" />
                <el-option label="轻度污染" :value="3" />
                <el-option label="中度污染" :value="4" />
                <el-option label="重度污染" :value="5" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="紫外线指数" prop="uvIndex">
              <el-input-number v-model="form.uvIndex" :precision="2" style="width: 100%" />
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
import { listClimateData, getClimateData, delClimateData, addClimateData, updateClimateData } from "@/api/equipment/climateData";

export default {
  name: "ClimateData",
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
    getList() {
      this.loading = true;
      listClimateData(this.queryParams).then(response => {
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
      this.ids = selection.map(item => item.climateId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加气候数据";
    },
    handleUpdate(row) {
      this.reset();
      const climateId = row.climateId || this.ids[0];
      getClimateData(climateId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改气候数据";
      });
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.climateId != null) {
            updateClimateData(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addClimateData(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    handleDelete(row) {
      const climateIds = row.climateId || this.ids;
      this.$modal.confirm('是否确认删除气候数据编号为"' + climateIds + '"的数据项？').then(function() {
        return delClimateData(climateIds);
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
        climateId: null,
        deviceId: null,
        timestamp: null,
        season: null,
        weatherCondition: null,
        precipitation: null,
        windSpeed: null,
        windDirection: null,
        extremeWeather: null,
        weatherDuration: null,
        temperatureExtreme: null,
        naturalDisasters: null,
        disasterIntensity: null,
        disasterDuration: null,
        airQualityIndex: null,
        pollutionLevel: null,
        uvIndex: null
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
