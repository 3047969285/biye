<template>
  <div class="app-container power-forecast-page">
    <!-- 顶部状态条 -->
    <el-alert
      v-if="statusInfo"
      :type="statusAlertType"
      :closable="false"
      show-icon
      class="status-alert"
    >
      <template slot="title">
        <span v-if="statusInfo.isTraining">
          <i class="el-icon-loading" /> 模型训练中… {{ statusInfo.progress }}% — {{ statusInfo.message }}
        </span>
        <span v-else-if="statusInfo.modelExists">
          模型已就绪 &nbsp;|&nbsp; 训练时间：{{ statusInfo.trainedAt | fmtDate }}
          &nbsp;|&nbsp; RMSE：{{ (statusInfo.rmse || 0).toFixed(4) }}
          &nbsp;|&nbsp; MAE：{{ (statusInfo.mae || 0).toFixed(4) }}
          &nbsp;|&nbsp; R²：{{ (statusInfo.r2 || 0).toFixed(4) }}
        </span>
        <span v-else>
          尚未训练模型，请在左侧配置 Excel 路径和参数后点击"开始训练"
        </span>
      </template>
    </el-alert>

    <el-row :gutter="16" class="content-row">
      <!-- ─── 左侧：训练配置 ──────────────────────── -->
      <el-col :xs="24" :md="8">
        <el-card class="train-card">
          <div slot="header" class="card-title">
            <i class="el-icon-setting" /> 模型训练配置
          </div>

          <el-form :model="trainForm" label-width="90px" size="small">
            <el-form-item label="数据路径">
              <el-input
                v-model="trainForm.excelPath"
                placeholder="Excel 文件绝对路径"
                clearable
              />
            </el-form-item>
            <el-form-item label="目标列名">
              <el-input
                v-model="trainForm.targetCol"
                placeholder="留空=最后一列数值"
                clearable
              />
            </el-form-item>
            <el-form-item label="时间步长">
              <el-input-number v-model="trainForm.timeStep" :min="5" :max="200" style="width:100%" />
            </el-form-item>
            <el-form-item label="测试集比例">
              <el-input-number
                v-model="trainForm.testSize"
                :step="0.05" :min="0.05" :max="0.5" :precision="2"
                style="width:100%"
              />
            </el-form-item>
            <el-form-item label="训练轮数">
              <el-input-number v-model="trainForm.epochs" :min="10" :max="500" style="width:100%" />
            </el-form-item>
            <el-form-item label="批大小">
              <el-input-number v-model="trainForm.batchSize" :min="8" :max="512" style="width:100%" />
            </el-form-item>
          </el-form>

          <!-- 训练进度条 -->
          <el-progress
            v-if="statusInfo && statusInfo.isTraining"
            :percentage="statusInfo.progress"
            :stroke-width="10"
            :show-text="true"
            status="active"
            class="train-progress"
          />

          <div class="train-btn-row">
            <el-button
              type="primary"
              icon="el-icon-cpu"
              :loading="isTraining"
              @click="handleTrain"
              style="width:100%"
            >
              {{ isTraining ? '训练中…' : '开始训练' }}
            </el-button>
          </div>

          <!-- 预测参数 -->
          <el-divider content-position="left" class="divider">预测参数</el-divider>
          <el-form :model="predictForm" label-width="90px" size="small">
            <el-form-item label="预测长度">
              <el-input-number
                v-model="predictForm.predictLength"
                :min="24" :max="500"
                style="width:100%"
              />
            </el-form-item>
            <el-form-item label="起始偏移">
              <el-input-number
                v-model="predictForm.predictStartIndex"
                :min="0" :max="9999"
                style="width:100%"
              />
            </el-form-item>
          </el-form>

          <!-- 使用已有模型（可选）-->
          <el-divider content-position="left" class="divider">
            使用已有模型（可选）
            <el-tooltip content="填写已训练好的模型路径，无需重新训练" placement="top">
              <i class="el-icon-question" style="margin-left:4px;color:#909399" />
            </el-tooltip>
          </el-divider>
          <el-form :model="existingModelForm" label-width="90px" size="small">
            <el-form-item label="模型路径">
              <el-input
                v-model="existingModelForm.modelPath"
                placeholder="如 D:\project\model\gru_FD.h5"
                clearable
              />
            </el-form-item>
            <el-form-item label="特征数据">
              <el-input
                v-model="existingModelForm.featureExcel"
                placeholder="如 D:\project\FD001.xlsx"
                clearable
              />
            </el-form-item>
            <el-form-item label="真实功率">
              <el-input
                v-model="existingModelForm.realExcel"
                placeholder="如 D:\project\FD001_real.xlsx"
                clearable
              />
            </el-form-item>
            <el-row :gutter="8">
              <el-col :span="12">
                <el-form-item label="时间步长">
                  <el-input-number v-model="existingModelForm.timeStep" :min="5" :max="200" style="width:100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="测试比例">
                  <el-input-number v-model="existingModelForm.testSize" :step="0.05" :min="0.05" :max="0.5" :precision="2" style="width:100%" />
                </el-form-item>
              </el-col>
            </el-row>
          </el-form>

          <el-button
            type="success"
            icon="el-icon-data-line"
            :loading="predictLoading"
            :disabled="!canPredict"
            @click="handlePredict"
            style="width:100%;margin-top:4px"
          >
            {{ predictLoading ? '预测中…' : '开始预测' }}
          </el-button>
        </el-card>
      </el-col>

      <!-- ─── 右侧：预测结果图表 ─────────────────── -->
      <el-col :xs="24" :md="16">
        <el-card class="chart-card">
          <div slot="header" class="card-title">
            <i class="el-icon-data-analysis" /> 发电功率预测结果（GRU 实时推理）
          </div>

          <!-- 精度指标 -->
          <el-row v-if="metrics" :gutter="12" class="metric-row">
            <el-col :span="8">
              <div class="metric-box">
                <div class="metric-label">RMSE</div>
                <div class="metric-value">{{ metrics.rmse.toFixed(4) }}</div>
              </div>
            </el-col>
            <el-col :span="8">
              <div class="metric-box">
                <div class="metric-label">MAE</div>
                <div class="metric-value">{{ metrics.mae.toFixed(4) }}</div>
              </div>
            </el-col>
            <el-col :span="8">
              <div class="metric-box">
                <div class="metric-label">R²</div>
                <div class="metric-value">{{ metrics.r2.toFixed(4) }}</div>
              </div>
            </el-col>
          </el-row>

          <!-- 图表区域 -->
          <div class="chart-container" v-loading="predictLoading">
            <div v-if="!seriesReady" class="empty-tip">
              <i class="el-icon-data-analysis empty-icon" />
              <p>
                {{ statusInfo && statusInfo.modelExists
                    ? '点击"开始预测"查看预测曲线'
                    : '请先训练模型' }}
              </p>
            </div>
            <div v-show="seriesReady" ref="chartDom" class="chart" />
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import * as echarts from 'echarts'
import { trainPowerModel, quickPredictPower, getPowerStatus } from '@/api/ai/power'

export default {
  name: 'PowerForecast',

  filters: {
    fmtDate(val) {
      if (!val) return '-'
      return val.replace('T', ' ').slice(0, 19)
    }
  },

  data() {
    return {
      // 训练表单
      trainForm: {
        excelPath:  '',
        targetCol:  '',
        timeStep:   30,
        testSize:   0.2,
        epochs:     50,
        batchSize:  64
      },
      // 预测表单
      predictForm: {
        predictLength:      96,
        predictStartIndex:  0
      },
      // 使用已有模型（可选）
      existingModelForm: {
        modelPath:    '',
        featureExcel: '',
        realExcel:    '',
        timeStep:     30,
        testSize:     0.2
      },
      // 状态
      statusInfo:     null,
      isTraining:     false,
      predictLoading: false,
      // 结果
      metrics:    null,
      predicted:  [],
      real:       [],
      seriesReady: false,
      // ECharts
      chart:      null,
      // 轮询定时器
      _pollTimer: null
    }
  },

  computed: {
    statusAlertType() {
      if (!this.statusInfo) return 'info'
      if (this.statusInfo.isTraining) return 'warning'
      if (this.statusInfo.modelExists) return 'success'
      return 'info'
    },
    // 是否可以预测：缓存模型存在 OR 填写了已有模型路径
    canPredict() {
      if (this.predictLoading || this.isTraining) return false
      const f = this.existingModelForm
      if (f.modelPath && f.modelPath.trim()) return true
      return !!(this.statusInfo && this.statusInfo.modelExists)
    }
  },

  mounted() {
    this.loadStatus()
  },

  beforeDestroy() {
    this._stopPoll()
    if (this.chart) {
      this.chart.dispose()
      this.chart = null
    }
  },

  methods: {
    // ── 状态加载 ───────────────────────────────────────────────────────────
    loadStatus() {
      getPowerStatus()
        .then(res => {
          if (res.code === 200 && res.data) {
            this.statusInfo = res.data
            this.isTraining = res.data.isTraining === true || res.data.is_training === true

            if (this.isTraining) {
              this._startPoll()
            } else if (res.data.modelExists === true || res.data.model_exists === true) {
              this.$nextTick(() => this.handlePredict())
            }
          }
        })
        .catch(() => {
          this.statusInfo = null
        })
    },

    _startPoll() {
      if (this._pollTimer) return
      this._pollTimer = setInterval(() => {
        getPowerStatus().then(res => {
          if (res.code === 200 && res.data) {
            this.statusInfo = res.data
            const training = res.data.isTraining === true || res.data.is_training === true
            this.isTraining = training
            if (!training) {
              this._stopPoll()
              // 训练完成后自动预测
              if (res.data.modelExists === true || res.data.model_exists === true) {
                this.$message.success('模型训练完成，正在自动预测…')
                this.handlePredict()
              }
            }
          }
        }).catch(() => this._stopPoll())
      }, 2000)
    },

    _stopPoll() {
      if (this._pollTimer) {
        clearInterval(this._pollTimer)
        this._pollTimer = null
      }
    },

    // ── 训练 ───────────────────────────────────────────────────────────────
    handleTrain() {
      if (!this.trainForm.excelPath || !this.trainForm.excelPath.trim()) {
        this.$message.warning('请先填写 Excel 数据文件路径')
        return
      }
      const params = {
        excel_path:  this.trainForm.excelPath.trim(),
        target_col:  this.trainForm.targetCol || null,
        time_step:   this.trainForm.timeStep,
        test_size:   this.trainForm.testSize,
        epochs:      this.trainForm.epochs,
        batch_size:  this.trainForm.batchSize
      }
      this.isTraining = true
      trainPowerModel(params)
        .then(res => {
          if (res.code === 200) {
            this.$message.success('训练任务已启动，请等待完成…')
            this._startPoll()
          } else {
            this.$message.error(res.msg || '训练启动失败')
            this.isTraining = false
          }
        })
        .catch(e => {
          this.$message.error('训练请求异常：' + (e.message || ''))
          this.isTraining = false
        })
    },

    // ── 预测 ───────────────────────────────────────────────────────────────
    handlePredict() {
      this.predictLoading = true
      const f = this.existingModelForm
      const useExisting = f.modelPath && f.modelPath.trim()
      const params = {
        predict_length:       this.predictForm.predictLength,
        predict_start_index:  this.predictForm.predictStartIndex,
        // 已有模型路径（有值才传，空字符串不传）
        model_path:    useExisting ? f.modelPath.trim()    : undefined,
        feature_excel: useExisting ? f.featureExcel.trim() : undefined,
        real_excel:    useExisting ? f.realExcel.trim()    : undefined,
        time_step:     useExisting ? f.timeStep            : undefined,
        test_size:     useExisting ? f.testSize            : undefined
      }
      quickPredictPower(params)
        .then(res => {
          if (res.code === 200 && res.data) {
            const d = res.data
            if (d.success === false) {
              this.$message.warning(d.message || '预测失败')
              return
            }
            this.metrics = { rmse: d.rmse, mae: d.mae, r2: d.r2 }
            this.predicted  = d.predictedPower || []
            this.real       = d.realPower || []
            this.seriesReady = this.predicted.length > 0
            this.$nextTick(() => this.renderChart())
          } else {
            this.$message.error(res.msg || '预测失败')
          }
        })
        .catch(e => {
          this.$message.error('预测异常：' + (e.message || ''))
        })
        .finally(() => {
          this.predictLoading = false
        })
    },

    // ── ECharts ────────────────────────────────────────────────────────────
    renderChart() {
      if (!this.seriesReady) return
      const dom = this.$refs.chartDom
      if (!dom) return
      if (!this.chart) {
        this.chart = echarts.init(dom)
        // 响应容器尺寸变化
        window.addEventListener('resize', () => this.chart && this.chart.resize())
      }
      const labels = this.real.map((_, i) => i + 1)
      this.chart.setOption({
        backgroundColor: 'transparent',
        tooltip: { trigger: 'axis', axisPointer: { type: 'cross' } },
        legend: {
          data: ['真实功率', '预测功率'],
          textStyle: { color: '#ccc' },
          top: 0
        },
        grid: { left: '5%', right: '4%', bottom: '8%', containLabel: true },
        xAxis: {
          type: 'category',
          data: labels,
          axisLabel: { color: '#aaa', interval: Math.floor(labels.length / 8) },
          axisLine: { lineStyle: { color: '#444' } },
          name: '时间点',
          nameTextStyle: { color: '#aaa' }
        },
        yAxis: {
          type: 'value',
          name: '功率 (kW)',
          nameTextStyle: { color: '#aaa' },
          axisLabel: { color: '#aaa' },
          axisLine: { lineStyle: { color: '#444' } },
          splitLine: { lineStyle: { color: '#2a2a3a' } }
        },
        series: [
          {
            name: '真实功率',
            type: 'line',
            smooth: true,
            showSymbol: false,
            data: this.real,
            lineStyle: { width: 2, color: '#4A8EE8' },
            areaStyle: { color: 'rgba(64,158,255,0.08)' }
          },
          {
            name: '预测功率',
            type: 'line',
            smooth: true,
            showSymbol: false,
            data: this.predicted,
            lineStyle: { width: 2, color: '#8FC6FF', type: 'dashed' }
          }
        ]
      }, true)
    }
  }
}
</script>

<style scoped>
.power-forecast-page {
  padding-bottom: 20px;
}
.status-alert {
  margin-bottom: 14px;
}
.content-row {
  margin-top: 0;
}
.card-title {
  font-weight: 600;
  font-size: 14px;
}
.train-card {
  height: 100%;
}
.train-progress {
  margin: 10px 0 6px;
}
.train-btn-row {
  margin: 8px 0;
}
.divider {
  margin: 14px 0 8px;
}
.chart-card {
  height: 100%;
}
.metric-row {
  margin-bottom: 12px;
}
.metric-box {
  background: #1a2035;
  border-radius: 6px;
  padding: 10px 0;
  text-align: center;
}
.metric-label {
  font-size: 12px;
  color: #aaa;
  margin-bottom: 4px;
}
.metric-value {
  font-size: 20px;
  font-weight: 700;
  color: #8FC6FF;
}
.chart-container {
  height: 420px;
  background: #131929;
  border-radius: 6px;
  overflow: hidden;
  position: relative;
}
.chart {
  width: 100%;
  height: 100%;
}
.empty-tip {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: #606266;
}
.empty-icon {
  font-size: 48px;
  margin-bottom: 12px;
  color: #2a3a5a;
}
</style>
