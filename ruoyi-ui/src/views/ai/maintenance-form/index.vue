<template>
  <div class="app-container form-gen">
    <el-row :gutter="20">
      <!-- 左侧：设备列表和生成表单 -->
      <el-col :span="14" :xs="24">
        <el-card>
          <div slot="header" class="card-header">
            <span>智能运维表单生成</span>
            <div class="header-actions">
              <el-button 
                type="primary" 
                size="small" 
                icon="el-icon-refresh" 
                @click="loadDevices"
                :loading="deviceLoading"
              >
                刷新
              </el-button>
              <el-button 
                type="success" 
                size="small" 
                icon="el-icon-check" 
                @click="batchGenerate"
                :loading="batchLoading"
                :disabled="selectedDevices.length === 0"
              >
                批量生成 ({{ selectedDevices.length }})
              </el-button>
              <el-button 
                type="info" 
                size="small" 
                icon="el-icon-document" 
                @click="showFormHistory = true"
              >
                历史记录
              </el-button>
            </div>
          </div>

          <!-- 搜索和筛选 -->
          <div class="filter-section">
            <el-input
              v-model="searchKeyword"
              placeholder="搜索设备编号或名称"
              prefix-icon="el-icon-search"
              clearable
              @input="handleSearch"
              style="width: 300px; margin-right: 10px;"
            />
            <el-select
              v-model="filterStatus"
              placeholder="筛选状态"
              clearable
              @change="handleFilter"
              style="width: 120px; margin-right: 10px;"
            >
              <el-option label="全部" value="" />
              <el-option label="警告" :value="2" />
              <el-option label="错误" :value="3" />
              <el-option label="离线" :value="4" />
            </el-select>
            <el-select
              v-model="filterPriority"
              placeholder="筛选优先级"
              clearable
              @change="handleFilter"
              style="width: 120px;"
            >
              <el-option label="全部" value="" />
              <el-option label="高" value="高" />
              <el-option label="中" value="中" />
              <el-option label="低" value="低" />
            </el-select>
          </div>

          <!-- 设备列表 -->
          <div class="device-list-section">
            <div class="section-title">
              <span>需要维护的设备列表 ({{ filteredDeviceList.length }}/{{ deviceList.length }})</span>
            </div>
            <el-table
              :data="filteredDeviceList"
              v-loading="deviceLoading"
              @selection-change="handleSelectionChange"
              @row-click="handleRowClick"
              border
              style="width: 100%"
              max-height="400"
              :row-class-name="tableRowClassName"
            >
              <el-table-column type="selection" width="55" align="center" />
              <el-table-column prop="deviceNo" label="设备编号" width="120" />
              <el-table-column prop="deviceName" label="设备名称" min-width="150" show-overflow-tooltip />
              <el-table-column prop="statusText" label="状态" width="80" align="center">
                <template slot-scope="scope">
                  <el-tag 
                    :type="getStatusTagType(scope.row.status)"
                    size="small"
                  >
                    {{ scope.row.statusText }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column prop="priority" label="优先级" width="80" align="center">
                <template slot-scope="scope">
                  <el-tag 
                    :type="getPriorityTagType(scope.row.priority)"
                    size="small"
                  >
                    {{ scope.row.priority }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="问题描述" min-width="200" show-overflow-tooltip>
                <template slot-scope="scope">
                  <div v-if="scope.row.issues && scope.row.issues.length > 0">
                    <el-tooltip effect="dark" placement="top">
                      <div slot="content">
                        <div v-for="(issue, index) in scope.row.issues" :key="index" style="margin-bottom: 4px;">
                          {{ issue }}
                        </div>
                      </div>
                      <div>
                        <div v-for="(issue, index) in scope.row.issues.slice(0, 1)" :key="index" class="issue-item">
                          {{ issue }}
                        </div>
                        <span v-if="scope.row.issues.length > 1" class="more-issues">
                          +{{ scope.row.issues.length - 1 }} 个问题
                        </span>
                      </div>
                    </el-tooltip>
                  </div>
                  <span v-else class="text-muted">无</span>
                </template>
              </el-table-column>
              <el-table-column label="操作" width="150" align="center" fixed="right">
                <template slot-scope="scope">
                  <el-button 
                    type="text" 
                    size="small" 
                    icon="el-icon-view"
                    @click.stop="viewDeviceDetail(scope.row)"
                  >
                    详情
                  </el-button>
                  <el-button 
                    type="text" 
                    size="small" 
                    icon="el-icon-edit"
                    @click.stop="generateForDevice(scope.row)"
                    :loading="generatingDeviceId === scope.row.deviceId"
                  >
                    生成
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
            
            <!-- 空状态提示 -->
            <div v-if="!deviceLoading && filteredDeviceList.length === 0 && deviceList.length > 0" class="empty-filter-tip">
              <el-alert
                title="没有匹配的设备"
                type="info"
                :closable="false"
                show-icon
              >
                <template slot="default">
                  <p>当前筛选条件下没有找到匹配的设备，请尝试：</p>
                  <ul style="margin: 10px 0 0 20px; text-align: left;">
                    <li>清除搜索关键词</li>
                    <li>调整状态或优先级筛选条件</li>
                    <li>点击"刷新"按钮重新加载设备列表</li>
                  </ul>
                </template>
              </el-alert>
            </div>
          </div>

          <!-- 生成表单区域 -->
          <div class="form-section" v-if="currentForm">
            <div class="section-title">
              <span>生成的运维表单</span>
              <div class="form-actions-header">
                <el-button 
                  size="mini" 
                  type="text" 
                  icon="el-icon-printer"
                  @click="printForm"
                >
                  打印
                </el-button>
                <el-button 
                  size="mini" 
                  type="text" 
                  icon="el-icon-download"
                  @click="exportForm"
                >
                  导出
                </el-button>
                <el-button 
                  size="mini" 
                  type="text" 
                  icon="el-icon-document-copy"
                  @click="copyForm"
                >
                  复制
                </el-button>
                <el-button 
                  size="mini" 
                  type="text" 
                  icon="el-icon-edit"
                  @click="editForm"
                >
                  编辑
                </el-button>
              </div>
            </div>
            <div class="form-content" id="form-content">
              <el-descriptions :column="2" border class="form-descriptions">
                <el-descriptions-item label="设备名称" :span="2">
                  <strong class="device-name">{{ currentForm.deviceName }}</strong>
                </el-descriptions-item>
                <el-descriptions-item label="设备ID">
                  <span class="form-value">{{ currentForm.deviceId }}</span>
                </el-descriptions-item>
                <el-descriptions-item label="表单ID" v-if="currentForm.formId">
                  <span class="form-value">{{ currentForm.formId }}</span>
                </el-descriptions-item>
                <el-descriptions-item label="维护类型">
                  <el-tag 
                    :type="getMaintenanceTypeTagType(currentForm.maintenanceType)" 
                    size="small"
                    class="form-tag"
                  >
                    {{ currentForm.maintenanceType }}
                  </el-tag>
                </el-descriptions-item>
                <el-descriptions-item label="优先级">
                  <el-tag 
                    :type="getPriorityTagType(currentForm.priorityLevel)" 
                    size="small"
                    class="form-tag"
                  >
                    {{ currentForm.priorityLevel }}
                  </el-tag>
                </el-descriptions-item>
                <el-descriptions-item label="预计耗时">
                  <span class="time-badge">{{ currentForm.estimatedTime }} 分钟</span>
                </el-descriptions-item>
                <el-descriptions-item label="表单状态" v-if="currentForm.formStatus">
                  <div style="display: flex; align-items: center; gap: 8px;">
                    <el-tag 
                      :type="getFormStatusTagType(currentForm.formStatus)" 
                      size="small"
                      class="form-tag"
                    >
                      {{ getFormStatusText(currentForm.formStatus) }}
                    </el-tag>
                    <el-button 
                      type="text" 
                      size="mini" 
                      icon="el-icon-edit"
                      @click="showStatusEditDialog"
                      v-if="currentForm.formId"
                    >
                      修改
                    </el-button>
                  </div>
                </el-descriptions-item>
                <el-descriptions-item label="故障描述" :span="2">
                  <div class="fault-description">{{ currentForm.faultDescription }}</div>
                </el-descriptions-item>
                <el-descriptions-item label="所需工具" :span="2">
                  <div class="tools-container">
                    <el-tag 
                      v-for="(tool, index) in currentFormTools" 
                      :key="index"
                      size="small"
                      class="tool-tag"
                    >
                      {{ tool }}
                    </el-tag>
                  </div>
                </el-descriptions-item>
                <el-descriptions-item label="安全注意事项" :span="2">
                  <div class="safety-precautions">{{ currentForm.safetyPrecautions }}</div>
                </el-descriptions-item>
                <el-descriptions-item label="操作步骤" :span="2">
                  <div class="steps-container">
                    <div v-for="(step, index) in currentFormSteps" :key="index" class="step-item">
                      <div class="step-header">
                        <span class="step-number">{{ step.step }}</span>
                        <span class="step-title">{{ step.title }}</span>
                      </div>
                      <div class="step-description">{{ step.description }}</div>
                    </div>
                  </div>
                </el-descriptions-item>
                <el-descriptions-item label="预期结果" :span="2">
                  <div class="expected-outcome">{{ currentForm.expectedOutcome }}</div>
                </el-descriptions-item>
                <el-descriptions-item label="创建时间" v-if="currentForm.createdTime" :span="2">
                  <span class="form-value">{{ currentForm.createdTime }}</span>
                </el-descriptions-item>
                <el-descriptions-item label="创建人" v-if="currentForm.createdBy" :span="2">
                  <span class="form-value">{{ currentForm.createdBy }}</span>
                </el-descriptions-item>
              </el-descriptions>
              
              <div class="form-actions" style="margin-top: 16px;">
                <el-button 
                  type="primary" 
                  icon="el-icon-check"
                  @click="saveForm"
                  :loading="saving"
                  v-if="!currentForm.formId"
                >
                  保存到数据库
                </el-button>
                <el-button 
                  type="primary" 
                  icon="el-icon-check"
                  @click="updateForm"
                  :loading="saving"
                  v-if="currentForm.formId"
                >
                  更新表单
                </el-button>
                <el-button @click="clearForm">清空</el-button>
                <el-button 
                  type="danger" 
                  icon="el-icon-delete"
                  @click="deleteCurrentForm"
                  v-if="currentForm && currentForm.formId"
                >
                  删除表单
                </el-button>
              </div>
            </div>
          </div>

          <!-- 空状态 -->
          <el-empty 
            v-if="!deviceLoading && deviceList.length === 0" 
            description="暂无需要维护的设备"
            :image-size="100"
          />
        </el-card>
      </el-col>

      <!-- 右侧：统计信息和提示 -->
      <el-col :span="10" :xs="24">
        <!-- 统计卡片 -->
        <el-card>
          <div slot="header" class="card-header">
            <span>统计信息</span>
            <el-button 
              type="text" 
              size="mini" 
              icon="el-icon-arrow-up"
              :icon="statisticsCollapsed ? 'el-icon-arrow-down' : 'el-icon-arrow-up'"
              @click="statisticsCollapsed = !statisticsCollapsed"
              class="collapse-btn"
            >
              {{ statisticsCollapsed ? '展开' : '收起' }}
            </el-button>
          </div>
          <div class="statistics" v-show="!statisticsCollapsed">
            <div class="stat-item">
              <div class="stat-value">{{ deviceList.length }}</div>
              <div class="stat-label">需要维护设备</div>
            </div>
            <div class="stat-item">
              <div class="stat-value warning">{{ statusCount.warning }}</div>
              <div class="stat-label">警告状态</div>
            </div>
            <div class="stat-item">
              <div class="stat-value danger">{{ statusCount.error }}</div>
              <div class="stat-label">错误状态</div>
            </div>
            <div class="stat-item">
              <div class="stat-value info">{{ statusCount.offline }}</div>
              <div class="stat-label">离线状态</div>
            </div>
          </div>
        </el-card>

        <el-card style="margin-top: 20px;">
          <div slot="header" class="card-header">
            <span>使用说明</span>
          </div>
          <ul class="tips">
            <li>系统会自动检测状态不好的设备（警告、错误、离线或需要维护）</li>
            <li>支持单个设备生成表单，也支持批量生成</li>
            <li>生成的表单包含完整的维护信息：故障描述、操作步骤、安全注意事项等</li>
            <li>可以保存表单到数据库，状态为"草稿"，后续可编辑和审批</li>
            <li>表单格式参考了标准运维操作规范</li>
            <li>支持打印、导出、复制等操作</li>
          </ul>
        </el-card>

        <el-card style="margin-top: 20px;">
          <div slot="header" class="card-header">
            <span>设备状态说明</span>
          </div>
          <ul class="tips">
            <li><el-tag type="success" size="small">正常</el-tag> - 设备运行正常</li>
            <li><el-tag type="warning" size="small">警告</el-tag> - 设备有异常但可继续运行</li>
            <li><el-tag type="danger" size="small">错误</el-tag> - 设备出现故障</li>
            <li><el-tag type="info" size="small">离线</el-tag> - 设备离线或无法通信</li>
          </ul>
        </el-card>

        <el-card style="margin-top: 20px;">
          <div slot="header" class="card-header">
            <span>状态和优先级判断依据</span>
          </div>
          <div class="judgment-rules">
            <div class="rule-section">
              <strong>设备状态判断：</strong>
              <ul>
                <li>来自设备状态表（eq_device_status）的 status 字段</li>
                <li>1 = 正常，2 = 警告，3 = 错误，4 = 离线</li>
              </ul>
            </div>
            <div class="rule-section" style="margin-top: 12px;">
              <strong>优先级判断（按优先级从高到低）：</strong>
              <ul>
                <li><strong>高优先级：</strong>
                  <ul>
                    <li>故障等级为"紧急"（1）或"严重"（2）</li>
                    <li>设备状态为"错误"（3）或"离线"（4）</li>
                    <li>告警级别 ≤ 2</li>
                  </ul>
                </li>
                <li><strong>中优先级：</strong>
                  <ul>
                    <li>设备状态为"警告"（2）</li>
                    <li>故障等级为"一般"（3）</li>
                    <li>默认优先级</li>
                  </ul>
                </li>
                <li><strong>低优先级：</strong>
                  <ul>
                    <li>故障等级为"轻微"（4）</li>
                  </ul>
                </li>
              </ul>
            </div>
            <div class="rule-section" style="margin-top: 12px;">
              <strong>表单状态：</strong>
              <ul>
                <li><el-tag type="info" size="small">草稿</el-tag> - 初始状态，可编辑</li>
                <li><el-tag type="success" size="small">已审批</el-tag> - 已通过审批</li>
                <li><el-tag type="danger" size="small">已拒绝</el-tag> - 审批被拒绝</li>
              </ul>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 设备详情对话框 -->
    <el-dialog
      title="设备详情"
      :visible.sync="deviceDetailVisible"
      width="600px"
    >
      <el-descriptions :column="2" border v-if="selectedDevice">
        <el-descriptions-item label="设备编号">{{ selectedDevice.deviceNo }}</el-descriptions-item>
        <el-descriptions-item label="设备名称">{{ selectedDevice.deviceName }}</el-descriptions-item>
        <el-descriptions-item label="设备状态">
          <el-tag :type="getStatusTagType(selectedDevice.status)" size="small">
            {{ selectedDevice.statusText }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="优先级">
          <el-tag :type="getPriorityTagType(selectedDevice.priority)" size="small">
            {{ selectedDevice.priority }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="问题列表" :span="2">
          <ul class="issue-list">
            <li v-for="(issue, index) in selectedDevice.issues" :key="index">{{ issue }}</li>
          </ul>
        </el-descriptions-item>
        <el-descriptions-item label="时间" :span="2" v-if="selectedDevice.timestamp">
          {{ selectedDevice.timestamp }}
        </el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button @click="deviceDetailVisible = false">关闭</el-button>
        <el-button type="primary" @click="generateForDevice(selectedDevice)">生成表单</el-button>
      </div>
    </el-dialog>

    <!-- 表单编辑对话框 -->
    <el-dialog
      title="编辑运维表单"
      :visible.sync="formEditVisible"
      width="800px"
      @close="cancelEdit"
    >
      <el-form :model="editForm" label-width="120px" v-if="editForm">
        <el-form-item label="设备名称">
          <el-input v-model="editForm.deviceName" disabled />
        </el-form-item>
        <el-form-item label="维护类型">
          <el-select v-model="editForm.maintenanceType" style="width: 100%">
            <el-option label="预防性" value="预防性" />
            <el-option label="纠正性" value="纠正性" />
            <el-option label="预测性" value="预测性" />
            <el-option label="紧急" value="紧急" />
          </el-select>
        </el-form-item>
        <el-form-item label="优先级">
          <el-select v-model="editForm.priorityLevel" style="width: 100%">
            <el-option label="高" value="高" />
            <el-option label="中" value="中" />
            <el-option label="低" value="低" />
          </el-select>
          <div style="font-size: 12px; color: #909399; margin-top: 4px;">
            优先级判断依据：故障等级（紧急/严重→高）、设备状态（错误/离线→高，警告→中）、告警级别（≤2→高）
          </div>
        </el-form-item>
        <el-form-item label="表单状态" v-if="editForm.formId">
          <el-select v-model="editForm.formStatus" style="width: 100%">
            <el-option label="草稿" value="draft" />
            <el-option label="已审批" value="approved" />
            <el-option label="已拒绝" value="rejected" />
          </el-select>
        </el-form-item>
        <el-form-item label="预计耗时(分钟)">
          <el-input-number v-model="editForm.estimatedTime" :min="1" style="width: 100%" />
        </el-form-item>
        <el-form-item label="故障描述">
          <el-input
            type="textarea"
            :rows="4"
            v-model="editForm.faultDescription"
            placeholder="请输入故障描述"
          />
        </el-form-item>
        <el-form-item label="安全注意事项">
          <el-input
            type="textarea"
            :rows="6"
            v-model="editForm.safetyPrecautions"
            placeholder="请输入安全注意事项"
          />
        </el-form-item>
        <el-form-item label="预期结果">
          <el-input
            type="textarea"
            :rows="4"
            v-model="editForm.expectedOutcome"
            placeholder="请输入预期结果"
          />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancelEdit">取消</el-button>
        <el-button type="primary" @click="saveEdit" :loading="saving">保存</el-button>
      </div>
    </el-dialog>

    <!-- 快速修改状态对话框 -->
    <el-dialog
      title="修改表单状态"
      :visible.sync="showStatusEdit"
      width="500px"
      @close="cancelStatusEdit"
    >
      <el-form :model="statusEditForm" label-width="120px" v-if="statusEditForm">
        <el-form-item label="当前状态">
          <el-tag 
            :type="getFormStatusTagType(statusEditForm.formStatus)" 
            size="small"
          >
            {{ getFormStatusText(statusEditForm.formStatus) }}
          </el-tag>
        </el-form-item>
        <el-form-item label="新状态">
          <el-select v-model="statusEditForm.formStatus" style="width: 100%">
            <el-option label="草稿" value="draft" />
            <el-option label="已审批" value="approved" />
            <el-option label="已拒绝" value="rejected" />
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancelStatusEdit">取消</el-button>
        <el-button type="primary" @click="saveStatusEdit" :loading="saving">保存</el-button>
      </div>
    </el-dialog>

    <!-- 表单历史记录对话框 -->
    <el-dialog
      title="表单历史记录"
      :visible.sync="showFormHistory"
      width="900px"
    >
      <el-table
        :data="formHistoryList"
        v-loading="historyLoading"
        border
        style="width: 100%"
        max-height="500"
      >
        <el-table-column prop="formId" label="表单ID" width="80" />
        <el-table-column prop="deviceName" label="设备名称" min-width="150" />
        <el-table-column prop="maintenanceType" label="维护类型" width="100" />
        <el-table-column prop="priorityLevel" label="优先级" width="80">
          <template slot-scope="scope">
            <el-tag :type="getPriorityTagType(scope.row.priorityLevel)" size="small">
              {{ scope.row.priorityLevel }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="formStatus" label="状态" width="100">
          <template slot-scope="scope">
            <el-tag :type="getFormStatusTagType(scope.row.formStatus)" size="small">
              {{ getFormStatusText(scope.row.formStatus) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdTime" label="创建时间" width="160" />
        <el-table-column label="操作" width="200" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="loadFormFromHistory(scope.row)">加载</el-button>
            <el-button type="text" size="small" @click="viewFormDetail(scope.row)">查看</el-button>
            <el-button 
              type="text" 
              size="small" 
              style="color: #f56c6c;"
              @click="deleteFormFromHistory(scope.row)"
            >
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-dialog>
  </div>
</template>

<script>
import { 
  getDevicesRequiringMaintenance, 
  generateFormForDevice, 
  batchGenerateForms,
  listAiMaintenanceForm,
  getAiMaintenanceFormById,
  updateMaintenanceForm,
  deleteMaintenanceForm,
  batchDeleteMaintenanceForms
} from "@/api/ai/chat";
import clipboard from "@/utils/clipboard";

export default {
  name: "AiMaintenanceForm",
  data() {
    return {
      deviceLoading: false,
      batchLoading: false,
      saving: false,
      historyLoading: false,
      generatingDeviceId: null,
      deviceList: [],
      filteredDeviceList: [],
      selectedDevices: [],
      currentForm: null,
      searchKeyword: "",
      filterStatus: "",
      filterPriority: "",
      deviceDetailVisible: false,
      selectedDevice: null,
      formEditVisible: false,
      editForm: null,
      showFormHistory: false,
      formHistoryList: [],
      statisticsCollapsed: false,
      showStatusEdit: false,
      statusEditForm: null
    };
  },
  computed: {
    currentFormTools() {
      if (!this.currentForm || !this.currentForm.requiredTools) return [];
      try {
        return JSON.parse(this.currentForm.requiredTools);
      } catch (e) {
        return [];
      }
    },
    currentFormSteps() {
      if (!this.currentForm || !this.currentForm.stepByStepGuide) return [];
      try {
        return JSON.parse(this.currentForm.stepByStepGuide);
      } catch (e) {
        return [];
      }
    },
    statusCount() {
      return {
        warning: this.deviceList.filter(d => d.status === 2).length,
        error: this.deviceList.filter(d => d.status === 3).length,
        offline: this.deviceList.filter(d => d.status === 4).length
      };
    }
  },
  mounted() {
    console.log("运维表单生成页面已加载");
    console.log("当前路由:", this.$route);
    this.loadDevices();
    this.loadFormHistory();
  },
  created() {
    console.log("运维表单生成组件已创建");
  },
  methods: {
    // 加载设备列表
    async loadDevices() {
      this.deviceLoading = true;
      try {
        console.log("开始加载设备列表...");
        const res = await getDevicesRequiringMaintenance();
        console.log("设备列表响应:", res);
        
        if (res && res.code === 200) {
          const devices = res.data && res.data.devices ? res.data.devices : [];
          console.log("获取到设备列表:", devices);
          
          // 确保每个设备都有status和priority字段
          devices.forEach(device => {
            if (device.status === null || device.status === undefined) {
              device.status = 2; // 默认警告状态
            }
            if (!device.statusText) {
              device.statusText = this.getStatusText(device.status);
            }
            if (!device.priority) {
              device.priority = "中";
            }
          });
          
          this.deviceList = devices;
          this.filteredDeviceList = [...devices];
          
          if (devices.length > 0) {
            this.$modal.msgSuccess(`找到 ${devices.length} 个需要维护的设备`);
          } else {
            this.$modal.msgInfo("当前没有需要维护的设备");
          }
        } else {
          const errorMsg = res ? (res.msg || "加载设备列表失败") : "接口返回数据异常";
          console.error("加载设备列表失败:", errorMsg, res);
          this.$modal.msgError(errorMsg);
          this.deviceList = [];
          this.filteredDeviceList = [];
        }
      } catch (e) {
        console.error("加载设备列表异常:", e);
        this.$modal.msgError("加载设备列表失败：" + (e.message || "未知错误"));
        this.deviceList = [];
        this.filteredDeviceList = [];
      } finally {
        this.deviceLoading = false;
      }
    },
    
    // 搜索
    handleSearch() {
      this.applyFilters();
    },
    
    // 筛选
    handleFilter() {
      this.applyFilters();
    },
    
    // 应用筛选
    applyFilters() {
      let filtered = [...this.deviceList];
      
      // 搜索关键词
      if (this.searchKeyword) {
        const keyword = this.searchKeyword.toLowerCase();
        filtered = filtered.filter(d => 
          (d.deviceNo && d.deviceNo.toLowerCase().includes(keyword)) ||
          (d.deviceName && d.deviceName.toLowerCase().includes(keyword))
        );
      }
      
      // 状态筛选
      if (this.filterStatus) {
        filtered = filtered.filter(d => d.status === this.filterStatus);
      }
      
      // 优先级筛选
      if (this.filterPriority) {
        filtered = filtered.filter(d => d.priority === this.filterPriority);
      }
      
      this.filteredDeviceList = filtered;
    },
    
    // 为单个设备生成表单
    async generateForDevice(device) {
      this.generatingDeviceId = device.deviceId;
      this.deviceDetailVisible = false;
      try {
        console.log("开始生成表单，设备ID:", device.deviceId, "设备信息:", device);
        const res = await generateFormForDevice(device.deviceId, false);
        console.log("生成表单响应:", res);
        
        if (res && res.code === 200) {
          // 处理返回的数据
          let formData = res.data;
          if (formData && typeof formData === 'object') {
            this.currentForm = formData;
            console.log("表单数据已设置:", this.currentForm);
            this.$modal.msgSuccess("表单生成成功");
            
            // 滚动到表单区域
            this.$nextTick(() => {
              const formSection = document.querySelector('.form-section');
              if (formSection) {
                formSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
              }
            });
          } else {
            console.error("表单数据格式错误:", formData);
            this.$modal.msgError("表单数据格式错误");
          }
        } else {
          this.$modal.msgError(res?.msg || "生成表单失败");
        }
      } catch (e) {
        console.error("生成表单异常:", e);
        this.$modal.msgError("生成表单失败：" + e.message);
      } finally {
        this.generatingDeviceId = null;
      }
    },
    
    // 批量生成表单
    async batchGenerate() {
      if (this.selectedDevices.length === 0) {
        this.$modal.msgWarning("请先选择要生成表单的设备");
        return;
      }
      
      this.$confirm(
        `确定要为 ${this.selectedDevices.length} 个设备批量生成运维表单吗？`,
        "批量生成确认",
        {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        }
      ).then(async () => {
        this.batchLoading = true;
        try {
          const deviceIds = this.selectedDevices.map(d => d.deviceId);
          const res = await batchGenerateForms(deviceIds, false);
          if (res.code === 200) {
            const summary = res.data;
            this.$modal.msgSuccess(
              `批量生成完成：成功 ${summary.success} 个，失败 ${summary.fail} 个`
            );
            if (summary.success === 1 && summary.results && summary.results.length > 0) {
              const result = summary.results.find(r => r.success);
              if (result && result.form) {
                this.currentForm = result.form;
              }
            }
            this.loadFormHistory();
          } else {
            this.$modal.msgError(res.msg || "批量生成失败");
          }
        } catch (e) {
          this.$modal.msgError("批量生成失败：" + e.message);
        } finally {
          this.batchLoading = false;
        }
      }).catch(() => {});
    },
    
    // 保存表单到数据库
    async saveForm() {
      if (!this.currentForm) {
        this.$modal.msgWarning("没有可保存的表单");
        return;
      }
      
      this.saving = true;
      try {
        const res = await generateFormForDevice(this.currentForm.deviceId, true);
        if (res.code === 200) {
          this.$modal.msgSuccess("表单已保存到数据库");
          this.currentForm = res.data;
          this.loadFormHistory();
        } else {
          this.$modal.msgError(res.msg || "保存失败");
        }
      } catch (e) {
        this.$modal.msgError("保存失败：" + e.message);
      } finally {
        this.saving = false;
      }
    },
    
    // 更新表单
    async updateForm() {
      if (!this.currentForm || !this.currentForm.formId) {
        this.$modal.msgWarning("表单ID不存在，无法更新");
        return;
      }
      
      this.saving = true;
      try {
        // 确保数据类型正确
        const updateData = {
          formId: Number(this.currentForm.formId),
          deviceId: this.currentForm.deviceId ? Number(this.currentForm.deviceId) : null,
          deviceName: this.currentForm.deviceName,
          faultDescription: this.currentForm.faultDescription,
          maintenanceType: this.currentForm.maintenanceType,
          priorityLevel: this.currentForm.priorityLevel,
          estimatedTime: this.currentForm.estimatedTime ? Number(this.currentForm.estimatedTime) : null,
          requiredTools: this.currentForm.requiredTools,
          safetyPrecautions: this.currentForm.safetyPrecautions,
          stepByStepGuide: this.currentForm.stepByStepGuide,
          expectedOutcome: this.currentForm.expectedOutcome,
          formStatus: this.currentForm.formStatus
        };
        
        // 移除 null 和 undefined 的字段
        Object.keys(updateData).forEach(key => {
          if (updateData[key] === null || updateData[key] === undefined) {
            delete updateData[key];
          }
        });
        
        console.log("开始更新表单，表单ID:", updateData.formId);
        console.log("发送更新数据:", updateData);
        const res = await updateMaintenanceForm(updateData);
        console.log("更新表单响应:", res);
        
        if (res && res.code === 200) {
          this.$modal.msgSuccess("表单已更新");
          this.formEditVisible = false;
          // 重新加载表单详情
          const detailRes = await getAiMaintenanceFormById(this.currentForm.formId);
          if (detailRes && detailRes.code === 200) {
            this.currentForm = detailRes.data;
          }
          this.loadFormHistory();
        } else {
          this.$modal.msgError(res?.msg || "更新失败");
        }
      } catch (e) {
        console.error("更新表单异常:", e);
        this.$modal.msgError("更新失败：" + e.message);
      } finally {
        this.saving = false;
      }
    },
    
    // 编辑表单
    editForm() {
      if (!this.currentForm) return;
      this.editForm = JSON.parse(JSON.stringify(this.currentForm));
      // 确保数字字段的类型正确
      if (this.editForm.formId) {
        this.editForm.formId = Number(this.editForm.formId);
      }
      if (this.editForm.deviceId) {
        this.editForm.deviceId = Number(this.editForm.deviceId);
      }
      if (this.editForm.estimatedTime !== null && this.editForm.estimatedTime !== undefined) {
        this.editForm.estimatedTime = Number(this.editForm.estimatedTime);
      }
      this.formEditVisible = true;
    },
    
    // 保存编辑
    async saveEdit() {
      if (!this.editForm) return;
      
      // 如果有表单ID，调用后端API保存
      if (this.editForm.formId) {
        this.saving = true;
        try {
          // 确保数据类型正确
          const updateData = {
            formId: this.editForm.formId,
            deviceId: this.editForm.deviceId ? Number(this.editForm.deviceId) : null,
            deviceName: this.editForm.deviceName,
            faultDescription: this.editForm.faultDescription,
            maintenanceType: this.editForm.maintenanceType,
            priorityLevel: this.editForm.priorityLevel,
            estimatedTime: this.editForm.estimatedTime ? Number(this.editForm.estimatedTime) : null,
            requiredTools: this.editForm.requiredTools,
            safetyPrecautions: this.editForm.safetyPrecautions,
            stepByStepGuide: this.editForm.stepByStepGuide,
            expectedOutcome: this.editForm.expectedOutcome,
            formStatus: this.editForm.formStatus
          };
          
          // 移除 null 和 undefined 的字段
          Object.keys(updateData).forEach(key => {
            if (updateData[key] === null || updateData[key] === undefined) {
              delete updateData[key];
            }
          });
          
          console.log("发送更新数据:", updateData);
          const res = await updateMaintenanceForm(updateData);
          if (res && res.code === 200) {
            this.$modal.msgSuccess("表单已更新");
            this.formEditVisible = false;
            // 重新加载表单详情
            const detailRes = await getAiMaintenanceFormById(this.editForm.formId);
            if (detailRes && detailRes.code === 200) {
              this.currentForm = detailRes.data;
            }
            this.loadFormHistory();
          } else {
            this.$modal.msgError(res?.msg || "更新失败");
          }
        } catch (e) {
          console.error("更新表单异常:", e);
          this.$modal.msgError("更新失败：" + e.message);
        } finally {
          this.saving = false;
        }
      } else {
        // 如果没有表单ID，只在前端更新
        this.currentForm = { ...this.currentForm, ...this.editForm };
        this.formEditVisible = false;
        this.$modal.msgSuccess("表单已更新");
      }
    },
    
    // 取消编辑
    cancelEdit() {
      this.editForm = null;
    },
    
    // 显示状态编辑对话框
    showStatusEditDialog() {
      if (!this.currentForm || !this.currentForm.formId) {
        this.$modal.msgWarning("表单ID不存在，无法修改状态");
        return;
      }
      console.log("打开状态编辑对话框，当前表单:", this.currentForm);
      this.statusEditForm = {
        formId: Number(this.currentForm.formId),
        formStatus: this.currentForm.formStatus || "draft"
      };
      console.log("状态编辑表单数据:", this.statusEditForm);
      this.showStatusEdit = true;
    },
    
    // 保存状态修改
    async saveStatusEdit() {
      if (!this.statusEditForm || !this.statusEditForm.formId) {
        this.$modal.msgWarning("表单ID不存在");
        return;
      }
      
      if (!this.statusEditForm.formStatus) {
        this.$modal.msgWarning("请选择新状态");
        return;
      }
      
      this.saving = true;
      try {
        // 只更新状态字段，确保 formId 是数字类型
        const updateData = {
          formId: Number(this.statusEditForm.formId),
          formStatus: String(this.statusEditForm.formStatus)
        };
        console.log("发送状态更新数据:", updateData);
        console.log("数据类型检查 - formId:", typeof updateData.formId, updateData.formId);
        console.log("数据类型检查 - formStatus:", typeof updateData.formStatus, updateData.formStatus);
        
        const res = await updateMaintenanceForm(updateData);
        console.log("状态更新响应:", res);
        
        if (res && res.code === 200) {
          this.$modal.msgSuccess("状态已更新");
          this.showStatusEdit = false;
          // 重新加载表单详情
          const detailRes = await getAiMaintenanceFormById(this.statusEditForm.formId);
          if (detailRes && detailRes.code === 200) {
            this.currentForm = detailRes.data;
            console.log("重新加载的表单数据:", this.currentForm);
          }
          this.loadFormHistory();
        } else {
          console.error("状态更新失败，响应:", res);
          this.$modal.msgError(res?.msg || "更新失败");
        }
      } catch (e) {
        console.error("更新状态异常:", e);
        console.error("异常详情:", e.response || e.message);
        this.$modal.msgError("更新失败：" + (e.response?.data?.msg || e.message));
      } finally {
        this.saving = false;
      }
    },
    
    // 取消状态编辑
    cancelStatusEdit() {
      this.statusEditForm = null;
    },
    
    // 查看设备详情
    viewDeviceDetail(device) {
      this.selectedDevice = device;
      this.deviceDetailVisible = true;
    },
    
    // 表格行点击
    handleRowClick(row) {
      // 可以在这里添加行点击逻辑
    },
    
    // 表格行类名
    tableRowClassName({ row, rowIndex }) {
      if (row.priority === "高") {
        return "warning-row";
      }
      return "";
    },
    
    // 复制表单
    copyForm() {
      if (!this.currentForm) {
        this.$modal.msgWarning("没有可复制的表单");
        return;
      }
      
      const formText = this.formatFormText(this.currentForm);
      clipboard(formText, null);
      this.$modal.msgSuccess("表单已复制到剪贴板");
    },
    
    // 打印表单
    printForm() {
      if (!this.currentForm) {
        this.$modal.msgWarning("没有可打印的表单");
        return;
      }
      
      const printContent = document.getElementById('form-content').innerHTML;
      const printWindow = window.open('', '_blank');
      printWindow.document.write(`
        <html>
          <head>
            <title>运维表单 - ${this.currentForm.deviceName}</title>
            <style>
              body { font-family: Arial, sans-serif; padding: 20px; }
              .el-descriptions { width: 100%; }
              .step-item { margin-bottom: 15px; }
              .step-number { display: inline-block; width: 24px; height: 24px; 
                line-height: 24px; text-align: center; background: #5EA1FF; 
                color: #F5F7FB; border-radius: 50%; margin-right: 8px; }
            </style>
          </head>
          <body>
            <h2>智能运维操作表单</h2>
            ${printContent}
          </body>
        </html>
      `);
      printWindow.document.close();
      printWindow.print();
    },
    
    // 导出表单
    exportForm() {
      if (!this.currentForm) {
        this.$modal.msgWarning("没有可导出的表单");
        return;
      }
      
      const formText = this.formatFormText(this.currentForm);
      const blob = new Blob([formText], { type: 'text/plain;charset=utf-8' });
      const url = URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.download = `运维表单_${this.currentForm.deviceName}_${new Date().getTime()}.txt`;
      link.click();
      URL.revokeObjectURL(url);
      this.$modal.msgSuccess("表单已导出");
    },
    
    // 格式化表单文本
    formatFormText(form) {
      let text = "=== 智能运维操作表单 ===\n\n";
      text += `设备名称：${form.deviceName}\n`;
      text += `设备ID：${form.deviceId}\n`;
      if (form.formId) text += `表单ID：${form.formId}\n`;
      text += `维护类型：${form.maintenanceType}\n`;
      text += `优先级：${form.priorityLevel}\n`;
      text += `预计耗时：${form.estimatedTime} 分钟\n\n`;
      text += `故障描述：\n${form.faultDescription}\n\n`;
      text += `所需工具：\n${this.currentFormTools.join("、")}\n\n`;
      text += `安全注意事项：\n${form.safetyPrecautions}\n\n`;
      text += `操作步骤：\n`;
      this.currentFormSteps.forEach(step => {
        text += `${step.step}. ${step.title}\n   ${step.description}\n`;
      });
      text += `\n预期结果：\n${form.expectedOutcome}\n`;
      if (form.createdTime) text += `\n创建时间：${form.createdTime}\n`;
      if (form.createdBy) text += `创建人：${form.createdBy}\n`;
      return text;
    },
    
    // 清空表单
    clearForm() {
      if (this.currentForm && this.currentForm.formId) {
        // 如果表单已保存，提示用户
        this.$confirm(
          "确定要清空当前表单吗？表单内容将丢失，但已保存的表单不会删除。",
          "清空确认",
          {
            confirmButtonText: "确定",
            cancelButtonText: "取消",
            type: "warning"
          }
        ).then(() => {
          this.currentForm = null;
          this.$modal.msgSuccess("表单已清空");
        }).catch(() => {});
      } else {
        this.currentForm = null;
        this.$modal.msgSuccess("表单已清空");
      }
    },
    
    // 删除历史记录中的表单
    async deleteFormFromHistory(form) {
      this.$confirm(
        `确定要删除表单 "${form.deviceName}" 吗？此操作不可恢复。`,
        "删除确认",
        {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        }
      ).then(async () => {
        try {
          console.log("开始删除表单，表单ID:", form.formId);
          const res = await deleteMaintenanceForm(form.formId);
          console.log("删除表单响应:", res);
          
          if (res && res.code === 200) {
            this.$modal.msgSuccess("删除成功");
            // 如果删除的是当前显示的表单，清空当前表单
            if (this.currentForm && this.currentForm.formId === form.formId) {
              this.currentForm = null;
            }
            // 重新加载历史记录
            this.loadFormHistory();
          } else {
            this.$modal.msgError(res?.msg || "删除失败");
          }
        } catch (e) {
          console.error("删除表单异常:", e);
          this.$modal.msgError("删除失败：" + e.message);
        }
      }).catch(() => {});
    },
    
    // 删除当前表单
    async deleteCurrentForm() {
      if (!this.currentForm || !this.currentForm.formId) {
        this.$modal.msgWarning("没有可删除的表单");
        return;
      }
      
      this.$confirm(
        `确定要删除表单 "${this.currentForm.deviceName}" 吗？此操作不可恢复。`,
        "删除确认",
        {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        }
      ).then(async () => {
        try {
          console.log("开始删除当前表单，表单ID:", this.currentForm.formId);
          const res = await deleteMaintenanceForm(this.currentForm.formId);
          console.log("删除表单响应:", res);
          
          if (res && res.code === 200) {
            this.$modal.msgSuccess("删除成功");
            this.currentForm = null;
            // 重新加载历史记录
            this.loadFormHistory();
          } else {
            this.$modal.msgError(res?.msg || "删除失败");
          }
        } catch (e) {
          console.error("删除表单异常:", e);
          this.$modal.msgError("删除失败：" + e.message);
        }
      }).catch(() => {});
    },
    
    // 表格选择变化
    handleSelectionChange(selection) {
      this.selectedDevices = selection;
    },
    
    // 加载表单历史记录
    async loadFormHistory() {
      this.historyLoading = true;
      try {
        console.log("开始加载表单历史记录...");
        const res = await listAiMaintenanceForm({});
        console.log("历史记录响应:", res);
        
        if (res && res.code === 200) {
          // 处理分页数据
          if (res.rows) {
            this.formHistoryList = res.rows;
          } else if (Array.isArray(res.data)) {
            this.formHistoryList = res.data;
          } else if (res.data && res.data.rows) {
            this.formHistoryList = res.data.rows;
          } else {
            this.formHistoryList = [];
          }
          console.log("加载历史记录成功，数量:", this.formHistoryList.length);
        } else {
          console.error("加载历史记录失败:", res?.msg);
          this.formHistoryList = [];
        }
      } catch (e) {
        console.error("加载历史记录异常:", e);
        this.formHistoryList = [];
      } finally {
        this.historyLoading = false;
      }
    },
    
    // 从历史记录加载表单
    loadFormFromHistory(form) {
      this.currentForm = form;
      this.showFormHistory = false;
      this.$modal.msgSuccess("表单已加载");
    },
    
    // 查看表单详情
    viewFormDetail(form) {
      this.currentForm = form;
      this.showFormHistory = false;
      this.$nextTick(() => {
        const formSection = document.querySelector('.form-section');
        if (formSection) {
          formSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
      });
    },
    
    // 获取状态文本
    getStatusText(status) {
      if (status === 1) return "正常";
      if (status === 2) return "警告";
      if (status === 3) return "错误";
      if (status === 4) return "离线";
      return "未知";
    },
    
    // 获取状态标签类型
    getStatusTagType(status) {
      if (status === 1) return "success";
      if (status === 2) return "warning";
      if (status === 3) return "danger";
      if (status === 4) return "info";
      return "";
    },
    
    // 获取优先级标签类型
    getPriorityTagType(priority) {
      if (priority === "高") return "danger";
      if (priority === "中") return "warning";
      if (priority === "低") return "info";
      return "";
    },
    
    // 获取表单状态标签类型
    getFormStatusTagType(status) {
      if (status === "draft") return "info";
      if (status === "approved") return "success";
      if (status === "rejected") return "danger";
      return "";
    },
    
    // 获取表单状态文本
    getFormStatusText(status) {
      const statusMap = {
        "draft": "草稿",
        "approved": "已审批",
        "rejected": "已拒绝"
      };
      return statusMap[status] || status;
    },
    
    // 获取维护类型标签类型
    getMaintenanceTypeTagType(type) {
      if (type === "紧急") return "danger";
      if (type === "纠正性") return "warning";
      if (type === "预测性") return "info";
      if (type === "预防性") return "success";
      return "info";
    }
  }
};
</script>

<style scoped lang="scss">
@import "~@/assets/styles/variables.scss";

.form-gen {
  .card-header {
    font-weight: 600;
    color: $text-primary;
    display: flex;
    justify-content: space-between;
    align-items: center;
    
    .header-actions {
      display: flex;
      gap: 8px;
    }
    
    .collapse-btn {
      color: $text-secondary !important;
      
      &:hover {
        color: $accent-color !important;
      }
    }
  }
  
  .filter-section {
    margin-bottom: 16px;
    display: flex;
    align-items: center;
  }
  
  .device-list-section {
    margin-bottom: 20px;
    
    .section-title {
      font-weight: 600;
      color: $text-primary;
      margin-bottom: 12px;
      font-size: 14px;
    }
    
    .issue-item {
      font-size: 12px;
      color: $text-secondary;
      margin-bottom: 4px;
    }
    
    .more-issues {
      font-size: 11px;
      color: $accent-color;
      margin-left: 4px;
    }
    
    .text-muted {
      color: $text-disabled;
      font-style: italic;
    }
  }
  
  .form-section {
    margin-top: 20px;
    padding-top: 20px;
    border-top: 1px solid $border-color;
    
    .section-title {
      font-weight: 600;
      color: $text-primary;
      margin-bottom: 12px;
      font-size: 14px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      
      .form-actions-header {
        display: flex;
        gap: 8px;
      }
    }
    
    .form-content {
      // 表单描述列表样式覆盖
      ::v-deep .form-descriptions {
        .el-descriptions__label {
          color: $text-secondary !important;
          font-weight: 600;
          background: $secondary-bg !important;
          border-color: $border-color !important;
        }
        
        .el-descriptions__content {
          color: $text-primary !important;
          background: $secondary-bg !important;
          border-color: $border-color !important;
          
          // 确保内容区域内的所有元素都是深色
          * {
            color: $text-primary !important;
          }
          
          // 确保内容区域内的输入框也是深色
          .el-input__inner,
          .el-textarea__inner,
          .el-select .el-input__inner,
          .el-input-number .el-input__inner {
            background-color: $secondary-bg !important;
            border-color: $border-color !important;
            color: $text-primary !important;
          }
          
          // 确保所有文字都是可见的
          strong, span, div, p {
            color: $text-primary !important;
          }
        }
        
        .el-descriptions__table {
          border-color: $border-color !important;
          background: transparent !important;
        }
        
        .el-descriptions__table td,
        .el-descriptions__table th {
          border-color: $border-color !important;
          background: $secondary-bg !important;
          color: $text-primary !important;
          
          // 确保单元格内的所有文字都是可见的
          * {
            color: $text-primary !important;
          }
        }
        
        .el-descriptions__table th {
          background: $secondary-bg !important;
          color: $text-secondary !important;
        }
        
        .el-descriptions__table td {
          background: $secondary-bg !important;
          color: $text-primary !important;
        }
      }
      
      // 确保表单内所有输入框都是深色
      ::v-deep .el-input__inner,
      ::v-deep .el-textarea__inner,
      ::v-deep .el-select .el-input__inner,
      ::v-deep .el-input-number .el-input__inner {
        background-color: $secondary-bg !important;
        border-color: $border-color !important;
        color: $text-primary !important;
        
        &::placeholder {
          color: $text-disabled !important;
        }
        
        &:focus {
          border-color: $accent-color !important;
          background-color: $secondary-bg !important;
        }
      }
      
      .device-name {
        color: $accent-color;
        font-size: 16px;
        font-weight: 700;
      }
      
      .form-value {
        color: $text-primary;
        font-size: 14px;
      }
      
      .form-tag {
        border-color: $border-color !important;
      }
      
      .fault-description {
        color: $text-primary;
        line-height: 1.8;
        padding: 12px;
        background: rgba(94, 161, 255, 0.1);
        border-left: 3px solid $accent-color;
        border-radius: 4px;
        font-size: 14px;
      }
      
      .tools-container {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
        
        .tool-tag {
          background: rgba(94, 161, 255, 0.15) !important;
          border-color: $accent-color !important;
          color: $accent-color !important;
          padding: 4px 12px;
        }
      }
      
      .safety-precautions {
        white-space: pre-wrap;
        word-break: break-word;
        color: $text-primary;
        font-size: 14px;
        line-height: 1.8;
        padding: 12px;
        background: rgba(94, 161, 255, 0.08);
        border-left: 3px solid $accent-color;
        border-radius: 4px;
      }
      
      .expected-outcome {
        white-space: pre-wrap;
        word-break: break-word;
        color: $text-primary;
        font-size: 14px;
        line-height: 1.8;
        padding: 12px;
        background: rgba(94, 161, 255, 0.1);
        border-left: 3px solid $accent-color;
        border-radius: 4px;
      }
      
      .time-badge {
        display: inline-block;
        padding: 4px 12px;
        background: rgba(94, 161, 255, 0.2);
        color: $accent-color;
        border: 1px solid $accent-color;
        border-radius: 4px;
        font-weight: 600;
        font-size: 13px;
      }
      
      .steps-container {
        display: flex;
        flex-direction: column;
        gap: 12px;
      }
      
      .step-item {
        padding: 16px;
        background: $secondary-bg;
        border-radius: 6px;
        border: 1px solid $border-color;
        border-left: 4px solid $accent-color;
        transition: all 0.3s;
        
        &:hover {
          background: rgba(94, 161, 255, 0.1);
          border-color: $accent-color;
          border-left-color: lighten($accent-color, 10%);
        }
        
        .step-header {
          display: flex;
          align-items: center;
          margin-bottom: 10px;
          
          .step-number {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            line-height: 1;
            text-align: center;
            background: $accent-color;
            color: $text-primary;
            border-radius: 50%;
            font-weight: 700;
            font-size: 14px;
            margin-right: 12px;
            flex-shrink: 0;
            box-shadow: 0 2px 4px rgba(94, 161, 255, 0.3);
            border: 2px solid rgba(94, 161, 255, 0.5);
          }
          
          .step-title {
            font-weight: 600;
            color: $text-primary;
            font-size: 15px;
          }
        }
        
        .step-description {
          color: $text-secondary;
          font-size: 14px;
          margin-left: 44px;
          line-height: 1.8;
        }
      }
    }
  }
  
  .statistics {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 12px;
    
    .stat-item {
      text-align: center;
      padding: 16px;
      background: $secondary-bg;
      border-radius: 8px;
      border: 1px solid $border-color;
      transition: all 0.3s;
      
      &:hover {
        background: rgba(94, 161, 255, 0.1);
        border-color: $accent-color;
        transform: translateY(-2px);
      }
      
      .stat-value {
        font-size: 32px;
        font-weight: 700;
        color: $accent-color;
        margin-bottom: 8px;
        line-height: 1;
        
        &.warning {
          color: #ffc107;
        }
        
        &.danger {
          color: #f56c6c;
        }
        
        &.info {
          color: #909399;
        }
      }
      
      .stat-label {
        font-size: 13px;
        color: $text-secondary;
        font-weight: 500;
      }
    }
  }
  
  .tips {
    margin: 0;
    padding-left: 20px;
    line-height: 1.8;
    color: $text-secondary;
    
    li {
      margin-bottom: 8px;
    }
  }
  
  .judgment-rules {
    color: $text-secondary;
    line-height: 1.8;
    
    .rule-section {
      strong {
        color: $text-primary;
        display: block;
        margin-bottom: 8px;
        font-size: 14px;
      }
      
      ul {
        margin: 0;
        padding-left: 20px;
        
        li {
          margin-bottom: 6px;
          font-size: 13px;
          
          ul {
            margin-top: 4px;
            padding-left: 20px;
            
            li {
              margin-bottom: 4px;
              font-size: 12px;
            }
          }
        }
      }
    }
  }
  
  .issue-list {
    margin: 0;
    padding-left: 20px;
    color: $text-secondary;
    
    li {
      margin-bottom: 4px;
    }
  }
  
  .empty-state {
    padding: 40px 0;
    text-align: center;
    
    .empty-tips {
      margin-top: 20px;
      color: $text-secondary;
      font-size: 13px;
      line-height: 1.8;
      
      ul {
        text-align: left;
        display: inline-block;
        margin-top: 10px;
      }
    }
  }
  
  .empty-filter-tip {
    margin-top: 20px;
    padding: 20px;
  }
  
  .loading-tip {
    padding: 40px 0;
    text-align: center;
    color: $text-secondary;
    
    i {
      font-size: 24px;
      margin-right: 8px;
      animation: rotating 2s linear infinite;
    }
  }
}

// 全局覆盖 el-descriptions 的白色背景
::v-deep .form-descriptions {
  .el-descriptions__label {
    color: $text-secondary !important;
    font-weight: 600;
    background: $secondary-bg !important;
    border-color: $border-color !important;
  }
  
  .el-descriptions__content {
    color: $text-primary !important;
    background: $secondary-bg !important;
    border-color: $border-color !important;
    
    // 强制所有子元素文字颜色为高对比度
    * {
      color: $text-primary !important;
    }
    
    strong, span, div, p, pre, label, a {
      color: $text-primary !important;
    }
  }
  
  .el-descriptions__table {
    border-color: $border-color !important;
    background: transparent !important;
    
    td, th {
      border-color: $border-color !important;
      background: $secondary-bg !important;
      color: $text-primary !important;
    }
    
    th {
      background: $secondary-bg !important;
      color: $text-secondary !important;
    }
    
    td {
      background: $secondary-bg !important;
      color: $text-primary !important;
    }
  }
}

@keyframes rotating {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

// 表格行样式
::v-deep .warning-row {
  background-color: rgba(255, 193, 7, 0.05);
}

// 编辑表单对话框样式 - 确保所有输入框都是深色
.form-edit-dialog {
  ::v-deep .el-dialog__body {
    background-color: $secondary-bg !important;
  }
  
  .form-edit-form {
    ::v-deep .el-input__inner,
    ::v-deep .el-textarea__inner,
    ::v-deep .el-select .el-input__inner,
    ::v-deep .el-input-number .el-input__inner {
      background-color: $secondary-bg !important;
      border-color: $border-color !important;
      color: $text-primary !important;
      
      &::placeholder {
        color: $text-disabled !important;
      }
      
      &:focus {
        border-color: $accent-color !important;
        background-color: $secondary-bg !important;
      }
    }
    
    ::v-deep .el-form-item__label {
      color: $text-primary !important;
    }
  }
}
</style>
