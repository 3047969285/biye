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
        <el-button type="primary" plain icon="el-icon-plus" size="small" @click="handleAdd" v-hasPermi="['equipment:prediction:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="small" :disabled="multiple" @click="handleDelete" v-hasPermi="['equipment:prediction:remove']">删除</el-button>
      </el-col>
    </el-row>

    <el-table v-loading="loading" :data="dataList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="预测ID" align="center" prop="predictionId" min-width="90" />
      <el-table-column label="设备编号" align="center" prop="deviceNo" min-width="130" show-overflow-tooltip>
        <template slot-scope="scope">{{ scope.row.deviceNo || '-' }}</template>
      </el-table-column>
      <el-table-column label="设备名称" align="center" prop="deviceName" min-width="120" show-overflow-tooltip>
        <template slot-scope="scope">{{ scope.row.deviceName || '-' }}</template>
      </el-table-column>
      <el-table-column label="预测时间" align="center" prop="predictionTime" min-width="168" :formatter="formatTableTime" />
      <el-table-column label="预测状态" align="center" prop="predictedStatus" min-width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.predictedStatus === 1" type="success">正常</el-tag>
          <el-tag v-else-if="scope.row.predictedStatus === 2" type="warning">警告</el-tag>
          <el-tag v-else-if="scope.row.predictedStatus === 3" type="danger">错误</el-tag>
          <el-tag v-else-if="scope.row.predictedStatus === 4" type="info">离线</el-tag>
          <span v-else>{{ scope.row.predictedStatus != null ? scope.row.predictedStatus : '—' }}</span>
        </template>
      </el-table-column>
      <el-table-column label="置信度" align="center" prop="predictionConfidence" min-width="90" />
      <el-table-column label="风险" align="center" prop="riskLevel" min-width="80">
        <template slot-scope="scope">
          <span v-if="scope.row.riskLevel === 1">低</span>
          <span v-else-if="scope.row.riskLevel === 2">中</span>
          <span v-else-if="scope.row.riskLevel === 3">高</span>
          <span v-else>{{ scope.row.riskLevel != null ? scope.row.riskLevel : '—' }}</span>
        </template>
      </el-table-column>
      <el-table-column label="预计故障时间" align="center" prop="expectedFailureTime" min-width="168" :formatter="formatTableTime" />
      <el-table-column label="建议措施" align="center" prop="recommendedAction" min-width="160" show-overflow-tooltip>
        <template slot-scope="scope">{{ scope.row.recommendedAction || '—' }}</template>
      </el-table-column>
      <el-table-column label="预防成本" align="center" prop="preventiveCost" min-width="100">
        <template slot-scope="scope">{{ scope.row.preventiveCost != null ? scope.row.preventiveCost : '—' }}</template>
      </el-table-column>
      <el-table-column label="行动" align="center" prop="actionTaken" min-width="90">
        <template slot-scope="scope">
          <span v-if="scope.row.actionTaken === 1">待处理</span>
          <span v-else-if="scope.row.actionTaken === 2">已处理</span>
          <span v-else-if="scope.row.actionTaken === 3">忽略</span>
          <span v-else>{{ scope.row.actionTaken != null ? scope.row.actionTaken : '—' }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="160" fixed="right">
        <template slot-scope="scope">
          <el-button size="small" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['equipment:prediction:edit']">修改</el-button>
          <el-button size="small" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['equipment:prediction:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="720px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="140px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="设备" prop="deviceId">
              <device-select v-model="form.deviceId" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="预测时间" prop="predictionTime">
              <el-date-picker v-model="form.predictionTime" type="datetime" placeholder="预测时间" style="width: 100%" value-format="yyyy-MM-dd HH:mm:ss" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="预测状态" prop="predictedStatus">
              <el-select v-model="form.predictedStatus" placeholder="请选择" style="width: 100%" clearable>
                <el-option label="正常" :value="1" />
                <el-option label="警告" :value="2" />
                <el-option label="错误" :value="3" />
                <el-option label="离线" :value="4" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="预测置信度" prop="predictionConfidence">
              <el-input-number v-model="form.predictionConfidence" :precision="4" :min="0" :max="1" :step="0.0001" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="风险等级" prop="riskLevel">
              <el-select v-model="form.riskLevel" placeholder="请选择" style="width: 100%" clearable>
                <el-option label="低" :value="1" />
                <el-option label="中" :value="2" />
                <el-option label="高" :value="3" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="预计故障时间" prop="expectedFailureTime">
              <el-date-picker v-model="form.expectedFailureTime" type="datetime" placeholder="可选" style="width: 100%" value-format="yyyy-MM-dd HH:mm:ss" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="预防成本" prop="preventiveCost">
              <el-input-number v-model="form.preventiveCost" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="采取行动" prop="actionTaken">
              <el-select v-model="form.actionTaken" placeholder="请选择" style="width: 100%">
                <el-option label="待处理" :value="1" />
                <el-option label="已处理" :value="2" />
                <el-option label="忽略" :value="3" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="行动时间" prop="actionTakenDate">
              <el-date-picker v-model="form.actionTakenDate" type="datetime" placeholder="可选" style="width: 100%" value-format="yyyy-MM-dd HH:mm:ss" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="建议措施" prop="recommendedAction">
          <el-input v-model="form.recommendedAction" type="textarea" :rows="2" placeholder="建议措施" />
        </el-form-item>
        <el-form-item label="备注(notes)" prop="notes">
          <el-input v-model="form.notes" type="textarea" :rows="2" placeholder="对应库字段 notes" />
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
import { listPrediction, getPrediction, delPrediction, addPrediction, updatePrediction } from '@/api/equipment/prediction'
import dataAcquisitionDevice from '@/mixins/dataAcquisitionDevice'

export default {
  name: 'PredictionData',
  mixins: [dataAcquisitionDevice],
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      total: 0,
      dataList: [],
      title: '',
      open: false,
      form: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        deviceId: null
      },
      rules: {
        deviceId: [{ required: true, message: '请选择设备', trigger: 'blur' }],
        predictionTime: [{ required: true, message: '请选择预测时间', trigger: 'change' }]
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    formatTableTime(row, column, cellValue) {
      if (!cellValue) return '—'
      try {
        const dateObj = new Date(cellValue)
        if (this.parseTime) {
          return this.parseTime(dateObj, '{y}-{m}-{d} {h}:{i}:{s}')
        }
        return dateObj.toLocaleString()
      } catch (e) {
        return String(cellValue)
      }
    },
    getList() {
      this.loading = true
      listPrediction(this.queryParams).then(response => {
        this.dataList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.resetForm('queryForm')
      this.clearDataAcquisitionDeviceFilter()
      this.handleQuery()
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.predictionId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    handleAdd() {
      this.reset()
      this.open = true
      this.title = '添加预测数据'
    },
    handleUpdate(row) {
      this.reset()
      const predictionId = row.predictionId || this.ids[0]
      getPrediction(predictionId).then(response => {
        this.form = response.data
        this.open = true
        this.title = '修改预测数据'
      })
    },
    submitForm() {
      this.$refs['form'].validate(valid => {
        if (!valid) return
        if (this.form.predictionId != null) {
          updatePrediction(this.form).then(() => {
            this.$modal.msgSuccess('修改成功')
            this.open = false
            this.getList()
          })
        } else {
          addPrediction(this.form).then(() => {
            this.$modal.msgSuccess('新增成功')
            this.open = false
            this.getList()
          })
        }
      })
    },
    handleDelete(row) {
      const predictionIds = row.predictionId || this.ids
      this.$modal.confirm('是否确认删除预测编号为"' + predictionIds + '"的数据项？').then(() => {
        return delPrediction(predictionIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess('删除成功')
      }).catch(() => {})
    },
    cancel() {
      this.open = false
      this.reset()
    },
    reset() {
      this.form = {
        predictionId: null,
        deviceId: null,
        predictionTime: null,
        predictedStatus: null,
        predictionConfidence: null,
        riskLevel: null,
        expectedFailureTime: null,
        recommendedAction: null,
        preventiveCost: null,
        actionTaken: 1,
        actionTakenDate: null,
        notes: null
      }
      this.resetForm('form')
    }
  }
}
</script>

<style scoped>
.app-container {
  padding: 20px;
}
</style>
