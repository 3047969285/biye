<template>
  <div class="app-container form-gen form-gen-layout">
    <div class="form-gen-workspace">
    <div
      ref="splitWorkspace"
      class="split-workspace"
      :class="{ 'split-workspace--narrow': splitLayoutNarrow, 'split-workspace--dragging': splitDragging }"
    >
      <div class="split-pane split-pane--left" :style="leftPaneStyle">
        <el-card class="list-card">
          <div slot="header" class="card-header card-header--list">
            <span class="header-title-row">运维表单 <em class="header-count">待维护 {{ filteredDeviceList.length }}/{{ deviceList.length }}</em></span>
            <div class="header-actions">
              <el-button 
                type="primary" 
                size="small" 
                icon="el-icon-refresh" 
                @click="() => loadDevices(true)"
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
                批量 ({{ selectedDevices.length }})
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

          <div class="filter-section filter-section--comfortable">
            <el-input
              v-model="searchKeyword"
              placeholder="搜索编号或名称"
              prefix-icon="el-icon-search"
              clearable
              size="small"
              @input="handleSearch"
              class="filter-search"
            />
            <el-select
              v-model="filterStatus"
              placeholder="状态"
              clearable
              size="small"
              @change="handleFilter"
              class="filter-select"
            >
              <el-option label="全部" value="" />
              <el-option label="警告" :value="2" />
              <el-option label="错误" :value="3" />
              <el-option label="离线" :value="4" />
            </el-select>
            <el-select
              v-model="filterPriority"
              placeholder="优先级"
              clearable
              size="small"
              @change="handleFilter"
              class="filter-select"
            >
              <el-option label="全部" value="" />
              <el-option label="高" value="高" />
              <el-option label="中" value="中" />
              <el-option label="低" value="低" />
            </el-select>
          </div>

          <div class="device-list-section">
            <el-table
              :data="filteredDeviceList"
              v-loading="deviceLoading"
              size="small"
              :height="listTableHeight"
              @selection-change="handleSelectionChange"
              @row-click="handleRowClick"
              border
              stripe
              highlight-current-row
              class="device-table device-table--readable"
              style="width: 100%"
              :row-class-name="tableRowClassName"
            >
              <el-table-column type="selection" width="48" align="center" />
              <el-table-column prop="deviceNo" label="设备编号" width="108" show-overflow-tooltip />
              <el-table-column prop="deviceName" label="设备名称" min-width="110" show-overflow-tooltip />
              <el-table-column prop="statusText" label="状态" width="76" align="center">
                <template slot-scope="scope">
                  <el-tag 
                    :type="getStatusTagType(scope.row.status)"
                    size="small"
                  >
                    {{ scope.row.statusText }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column prop="priority" label="优先级" width="68" align="center">
                <template slot-scope="scope">
                  <el-tag 
                    :type="getPriorityTagType(scope.row.priority)"
                    size="small"
                  >
                    {{ scope.row.priority }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="问题描述" min-width="130">
                <template slot-scope="scope">
                  <div v-if="hasIssueDisplay(scope.row)">
                    <el-tooltip effect="dark" placement="top" :open-delay="300">
                      <div slot="content" class="issues-tooltip">
                        <template v-if="scope.row.pendingFaults && scope.row.pendingFaults.length">
                          <div class="issues-tooltip-cap">待处理故障</div>
                          <div v-for="(line, idx) in scope.row.pendingFaults" :key="'f' + idx">{{ issueDescriptionDisplayText(line) }}</div>
                        </template>
                        <template v-if="scope.row.issues && scope.row.issues.length">
                          <div v-if="scope.row.pendingFaults && scope.row.pendingFaults.length" class="issues-tooltip-sep" />
                          <div class="issues-tooltip-cap">未恢复告警</div>
                          <div v-for="(issue, index) in scope.row.issues" :key="'a' + index">{{ issueDescriptionDisplayText(issue) }}</div>
                        </template>
                      </div>
                      <span class="issue-inline">{{ formatIssueDescriptionCell(scope.row) }}</span>
                    </el-tooltip>
                  </div>
                  <span v-else class="text-muted">—</span>
                </template>
              </el-table-column>
              <el-table-column label="操作" width="132" align="center" fixed="right">
                <template slot-scope="scope">
                  <el-button 
                    type="text" 
                    size="small" 
                    class="table-action-btn"
                    @click.stop="viewDeviceDetail(scope.row)"
                  >
                    详情
                  </el-button>
                  <el-button 
                    type="text" 
                    size="small" 
                    class="table-action-btn"
                    @click.stop="generateForDevice(scope.row)"
                    :loading="generatingDeviceId === scope.row.deviceId"
                  >
                    生成
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
            
            <!-- 空状态提示 -->
            <p
              v-if="!deviceLoading && filteredDeviceList.length === 0 && deviceList.length > 0"
              class="empty-filter-hint"
            >
              无匹配结果，请清空筛选或调整条件。
            </p>
          </div>

          <!-- 空状态 -->
          <el-empty 
            v-if="!deviceLoading && deviceList.length === 0" 
            description="暂无待维护设备"
            :image-size="80"
          />
        </el-card>
      </div>

      <div
        v-show="!splitLayoutNarrow"
        class="split-gutter"
        title="拖动调整左右区域宽度"
        role="separator"
        aria-orientation="vertical"
        @mousedown.prevent="startSplitDrag"
      >
        <span class="split-gutter__line" />
      </div>

      <div class="split-pane split-pane--right">
        <el-card 
          v-if="currentForm" 
          class="form-result-card form-section form-panel-card"
        >
          <div slot="header" class="card-header">
            <span>当前表单</span>
            <div class="form-actions-header">
              <el-button 
                size="small" 
                type="text" 
                icon="el-icon-printer"
                @click="printForm"
              >
                打印
              </el-button>
              <el-button 
                size="small" 
                type="text" 
                icon="el-icon-download"
                @click="exportForm"
              >
                导出
              </el-button>
              <el-button 
                size="small" 
                type="text" 
                icon="el-icon-document-copy"
                @click="copyForm"
              >
                复制
              </el-button>
              <el-button 
                size="small" 
                type="text" 
                icon="el-icon-edit"
                @click="openEditForm"
              >
                编辑
              </el-button>
            </div>
          </div>
          <div v-if="batchGeneratedForms.length > 0" class="batch-form-picker">
            <div class="batch-form-picker__title">本次批量生成（{{ batchGeneratedForms.length }}）</div>
            <el-collapse
              accordion
              v-model="batchCollapseActive"
              @change="onBatchCollapseChange"
              class="batch-form-collapse"
            >
              <el-collapse-item
                v-for="(f, i) in batchGeneratedForms"
                :key="'batch-form-' + i + '-' + (f.deviceId || i)"
                :name="'batch-' + i"
              >
                <template slot="title">
                  <span class="batch-form-picker__item-title">{{ f.deviceName || "设备" }}{{ f.deviceNo ? "（" + f.deviceNo + "）" : "" }}</span>
                  <el-tag size="mini" :type="getMaintenanceTypeTagType(f.maintenanceType)">{{ f.maintenanceType }}</el-tag>
                  <el-tag size="mini" type="info">{{ f.priorityLevel }}</el-tag>
                </template>
                <div class="batch-form-picker__snippet">{{ truncateText(f.faultDescription, 220) }}</div>
              </el-collapse-item>
            </el-collapse>
          </div>

          <div 
            class="form-content form-content-scroll" 
            id="form-content"
            :style="{ maxHeight: formPanelScrollMax + 'px' }"
          >
              <el-descriptions :column="2" border class="form-descriptions">
                <el-descriptions-item label="设备名称" :span="2">
                  <strong class="device-name">{{ currentForm.deviceName }}</strong>
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
                  <span class="time-badge">{{ currentForm.estimatedTime }} min</span>
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
                  保存
                </el-button>
                <el-button 
                  type="primary" 
                  icon="el-icon-check"
                  @click="updateForm"
                  :loading="saving"
                  v-if="currentForm.formId"
                >
                  更新
                </el-button>
                <el-button @click="clearForm">清空</el-button>
                <el-button 
                  type="danger" 
                  icon="el-icon-delete"
                  @click="deleteCurrentForm"
                  v-if="currentForm && currentForm.formId"
                >
                  删除
                </el-button>
              </div>
            </div>
        </el-card>
        <el-card v-else class="form-placeholder-card form-panel-card">
          <div slot="header" class="card-header">
            <span>当前表单</span>
          </div>
          <div class="form-placeholder-body" :style="{ minHeight: formPanelScrollMax + 'px' }">
            <el-empty description="在左侧选择设备后，点击「生成」查看运维表单" :image-size="96" />
          </div>
        </el-card>
      </div>
    </div>
    </div>

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
        <el-descriptions-item v-if="trimStr(selectedDevice.issueAiSummary)" label="综合摘要" :span="2">
          {{ selectedDevice.issueAiSummary }}
        </el-descriptions-item>
        <el-descriptions-item v-if="selectedDevice.faultDescription" label="状态说明" :span="2">
          {{ selectedDevice.faultDescription }}
        </el-descriptions-item>
        <el-descriptions-item label="待处理故障" :span="2">
          <ul v-if="selectedDevice.pendingFaults && selectedDevice.pendingFaults.length" class="issue-list">
            <li v-for="(line, index) in selectedDevice.pendingFaults" :key="'pf' + index">{{ issueDescriptionDisplayText(line) }}</li>
          </ul>
          <span v-else class="text-muted">无</span>
        </el-descriptions-item>
        <el-descriptions-item label="未恢复告警" :span="2">
          <ul v-if="selectedDevice.issues && selectedDevice.issues.length" class="issue-list">
            <li v-for="(issue, index) in selectedDevice.issues" :key="index">{{ issueDescriptionDisplayText(issue) }}</li>
          </ul>
          <span v-else class="text-muted">无</span>
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
      title="编辑表单"
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
      title="历史记录"
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
      /** 本次批量生成成功的表单列表，用于展开切换查看 */
      batchGeneratedForms: [],
      batchCollapseActive: "",
      searchKeyword: "",
      filterStatus: "",
      filterPriority: "",
      deviceDetailVisible: false,
      selectedDevice: null,
      formEditVisible: false,
      editForm: null,
      showFormHistory: false,
      formHistoryList: [],
      showStatusEdit: false,
      statusEditForm: null,
      winInnerHeight: typeof window !== "undefined" ? window.innerHeight : 900,
      winInnerWidth: typeof window !== "undefined" ? window.innerWidth : 1200,
      leftPaneWidth: 440,
      splitDragging: false
    };
  },
  computed: {
    splitLayoutNarrow() {
      return this.winInnerWidth < 992;
    },
    leftPaneStyle() {
      if (this.splitLayoutNarrow) {
        return { width: "100%" };
      }
      return {
        width: `${this.leftPaneWidth}px`,
        flexShrink: 0
      };
    },
    listTableHeight() {
      const h = this.winInnerHeight;
      const reserved = 230;
      return Math.max(220, Math.min(720, h - reserved));
    },
    formPanelScrollMax() {
      const h = this.winInnerHeight;
      const reserved = 215;
      return Math.max(280, Math.min(760, h - reserved));
    },
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
  },
  watch: {
    "$route.query.formId"(val) {
      if (val) {
        this.$nextTick(() => this.tryOpenFormFromRoute());
      }
    },
    "$route.query.deviceId"(val) {
      if (val) {
        this.$nextTick(() => this.tryOpenDeviceFromRoute());
      }
    }
  },
  mounted() {
    Promise.all([this.loadDevices(), this.loadFormHistory()])
      .then(() => {
        this.$nextTick(() => {
          this.initSplitWidth();
          this.tryOpenFormFromRoute();
          this.tryOpenDeviceFromRoute();
        });
      })
      .catch(() => {});
    this.onWinResize();
    window.addEventListener("resize", this.onWinResize);
  },
  beforeDestroy() {
    window.removeEventListener("resize", this.onWinResize);
    this.stopSplitDrag();
  },
  methods: {
    async tryOpenFormFromRoute() {
      const fid = this.$route.query.formId;
      if (fid == null || fid === "") return;
      const id = parseInt(String(fid), 10);
      if (!Number.isFinite(id) || id <= 0) return;
      try {
        const res = await getAiMaintenanceFormById(id);
        if (res && res.code === 200 && res.data) {
          this.clearBatchList();
          this.currentForm = res.data;
          this.showFormHistory = false;
          this.$nextTick(() => {
            const formSection = document.querySelector(".form-section");
            if (formSection) {
              formSection.scrollIntoView({ behavior: "smooth", block: "start" });
            }
          });
        }
      } catch (e) {
        /* ignore */
      }
    },
    tryOpenDeviceFromRoute() {
      const did = this.$route.query.deviceId;
      if (did == null || did === "") return;
      const id = parseInt(String(did), 10);
      if (!Number.isFinite(id) || id <= 0) return;
      const row = (this.deviceList || []).find((d) => d.deviceId === id);
      if (row) {
        this.viewDeviceDetail(row);
      }
    },
    initSplitWidth() {
      const el = this.$refs.splitWorkspace;
      if (!el || this.splitLayoutNarrow) return;
      const w = el.clientWidth;
      const gutter = 10;
      const target = Math.round((w - gutter) * 0.44);
      this.leftPaneWidth = Math.max(280, Math.min(w - 300 - gutter, target));
    },
    startSplitDrag() {
      if (this.splitLayoutNarrow) return;
      this.splitDragging = true;
      document.body.style.cursor = "col-resize";
      document.body.style.userSelect = "none";
      document.addEventListener("mousemove", this.onSplitDrag);
      document.addEventListener("mouseup", this.stopSplitDrag);
    },
    onSplitDrag(e) {
      if (!this.splitDragging || !this.$refs.splitWorkspace) return;
      const rect = this.$refs.splitWorkspace.getBoundingClientRect();
      const gutter = 10;
      const minLeft = 260;
      const minRight = 280;
      let x = e.clientX - rect.left - gutter / 2;
      const maxLeft = rect.width - minRight - gutter;
      this.leftPaneWidth = Math.max(minLeft, Math.min(maxLeft, x));
    },
    stopSplitDrag() {
      if (this.splitDragging) {
        this.splitDragging = false;
        document.body.style.cursor = "";
        document.body.style.userSelect = "";
      }
      document.removeEventListener("mousemove", this.onSplitDrag);
      document.removeEventListener("mouseup", this.stopSplitDrag);
    },
    onWinResize() {
      this.winInnerHeight = window.innerHeight || 900;
      this.winInnerWidth = window.innerWidth || 1200;
      this.$nextTick(() => {
        const el = this.$refs.splitWorkspace;
        if (!el || this.splitLayoutNarrow) return;
        const w = el.clientWidth;
        const gutter = 10;
        const maxLeft = w - 280 - gutter;
        if (this.leftPaneWidth > maxLeft) {
          this.leftPaneWidth = Math.max(260, maxLeft);
        }
      });
    },
    trimStr(s) {
      return s != null && String(s).trim().length > 0;
    },
    hasIssueDisplay(row) {
      return (row.issues && row.issues.length > 0) || (row.pendingFaults && row.pendingFaults.length > 0);
    },
    /** 去掉英文字母，仅展示中文与数字等内容 */
    issueDescriptionDisplayText(raw) {
      if (raw == null || raw === "") return "";
      let t = String(raw).replace(/[A-Za-z]+/g, "");
      t = t.replace(/[ \t\u00A0]+/g, " ");
      t = t.replace(/\s*([,，.:：;；、])\s*/g, "$1");
      t = t.replace(/\s+/g, " ").trim();
      t = t.replace(/^[,，.:：;；、\s]+|[,，.:：;；、\s]+$/g, "").trim();
      return t;
    },
    /** 表格单元格：待处理故障 + 未恢复告警，与浮层一致，不显示英文单词 */
    formatIssueDescriptionCell(row) {
      const parts = [];
      if (row.pendingFaults && row.pendingFaults.length) {
        row.pendingFaults.forEach((s) => {
          const d = this.issueDescriptionDisplayText(s);
          if (d) parts.push(d);
        });
      }
      if (row.issues && row.issues.length) {
        row.issues.forEach((s) => {
          const d = this.issueDescriptionDisplayText(s);
          if (d) parts.push(d);
        });
      }
      if (!parts.length) return "—";
      const j = parts.join("；");
      return j.length > 56 ? j.slice(0, 53) + "…" : j;
    },
    // 加载设备列表；首屏 withAi=false 快；手动「刷新」传 true 再走大模型摘要
    async loadDevices(withAiSummary) {
      this.deviceLoading = true;
      try {
        const res = await getDevicesRequiringMaintenance({ aiSummary: withAiSummary === true });
        
        if (res && res.code === 200) {
          const devices = res.data && res.data.devices ? res.data.devices : [];
          
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
            if (!device.pendingFaults) {
              device.pendingFaults = [];
            }
          });
          
          this.deviceList = devices;
          this.filteredDeviceList = [...devices];
          
          if (devices.length === 0) {
            this.$modal.msgInfo("暂无待维护设备");
          }
        } else {
          const errorMsg = res ? (res.msg || "加载设备列表失败") : "接口返回数据异常";
          this.$modal.msgError(errorMsg);
          this.deviceList = [];
          this.filteredDeviceList = [];
        }
      } catch (e) {
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
          (d.deviceName && d.deviceName.toLowerCase().includes(keyword)) ||
          (d.issueAiSummary && String(d.issueAiSummary).toLowerCase().includes(keyword)) ||
          (d.issues && d.issues.some(x => x && String(x).toLowerCase().includes(keyword))) ||
          (d.pendingFaults && d.pendingFaults.some(x => x && String(x).toLowerCase().includes(keyword))) ||
          (d.faultDescription && String(d.faultDescription).toLowerCase().includes(keyword))
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
        const res = await generateFormForDevice(device.deviceId, false);
        
        if (res && res.code === 200) {
          // 处理返回的数据
          let formData = res.data;
          if (formData && typeof formData === 'object') {
            this.clearBatchList();
            this.currentForm = formData;
            this.$modal.msgSuccess("已生成");
            
            // 滚动到表单区域
            this.$nextTick(() => {
              const formSection = document.querySelector('.form-section');
              if (formSection) {
                formSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
              }
            });
          } else {
            this.$modal.msgError("表单数据格式错误");
          }
        } else {
          this.$modal.msgError(res?.msg || "生成表单失败");
        }
      } catch (e) {
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
        `为 ${this.selectedDevices.length} 台设备批量生成表单？`,
        "确认",
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
            const summary = res.data || {};
            const results = Array.isArray(summary.results) ? summary.results : [];
            const forms = results.filter((r) => r && r.success && r.form).map((r) => r.form);
            this.batchGeneratedForms = forms;
            this.currentForm = forms.length > 0 ? forms[0] : null;
            this.$nextTick(() => {
              this.batchCollapseActive = forms.length > 0 ? "batch-0" : "";
            });
            this.$modal.msgSuccess(
              `批量生成完成：成功 ${summary.success} 个，失败 ${summary.fail} 个`
            );
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
          this.$modal.msgSuccess("已保存");
          this.currentForm = res.data;
          this.syncCurrentFormIntoBatchList();
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
          deviceId: this.currentForm.deviceId ? String(this.currentForm.deviceId).trim() : null,
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
        
        const res = await updateMaintenanceForm(updateData);
        
        if (res && res.code === 200) {
          this.$modal.msgSuccess("已更新");
          this.formEditVisible = false;
          // 重新加载表单详情
          const detailRes = await getAiMaintenanceFormById(this.currentForm.formId);
          if (detailRes && detailRes.code === 200) {
            this.currentForm = detailRes.data;
            this.syncCurrentFormIntoBatchList();
          }
          this.loadFormHistory();
        } else {
          this.$modal.msgError(res?.msg || "更新失败");
        }
      } catch (e) {
        this.$modal.msgError("更新失败：" + e.message);
      } finally {
        this.saving = false;
      }
    },
    
    // 编辑表单
    openEditForm() {
      if (!this.currentForm) return;
      this.editForm = JSON.parse(JSON.stringify(this.currentForm));
      // 确保数字字段的类型正确
      if (this.editForm.formId) {
        this.editForm.formId = Number(this.editForm.formId);
      }
      if (this.editForm.deviceId != null && this.editForm.deviceId !== "") {
        this.editForm.deviceId = String(this.editForm.deviceId).trim();
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
            deviceId: this.editForm.deviceId ? String(this.editForm.deviceId).trim() : null,
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
          
          const res = await updateMaintenanceForm(updateData);
          if (res && res.code === 200) {
            this.$modal.msgSuccess("已更新");
            this.formEditVisible = false;
            // 重新加载表单详情
            const detailRes = await getAiMaintenanceFormById(this.editForm.formId);
            if (detailRes && detailRes.code === 200) {
              this.currentForm = detailRes.data;
              this.syncCurrentFormIntoBatchList();
            }
            this.loadFormHistory();
          } else {
            this.$modal.msgError(res?.msg || "更新失败");
          }
        } catch (e) {
          this.$modal.msgError("更新失败：" + e.message);
        } finally {
          this.saving = false;
        }
      } else {
        // 如果没有表单ID，只在前端更新
        this.currentForm = { ...this.currentForm, ...this.editForm };
        this.syncCurrentFormIntoBatchList();
        this.formEditVisible = false;
        this.$modal.msgSuccess("已更新");
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
      this.statusEditForm = {
        formId: Number(this.currentForm.formId),
        formStatus: this.currentForm.formStatus || "draft"
      };
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
        
        const res = await updateMaintenanceForm(updateData);
        
        if (res && res.code === 200) {
          this.$modal.msgSuccess("已更新");
          this.showStatusEdit = false;
          // 重新加载表单详情
          const detailRes = await getAiMaintenanceFormById(this.statusEditForm.formId);
          if (detailRes && detailRes.code === 200) {
            this.currentForm = detailRes.data;
            this.syncCurrentFormIntoBatchList();
          }
          this.loadFormHistory();
        } else {
          this.$modal.msgError(res?.msg || "更新失败");
        }
      } catch (e) {
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
      this.$modal.msgSuccess("已复制");
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
            <h2>运维表单</h2>
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
      this.$modal.msgSuccess("已导出");
    },
    
    // 格式化表单文本
    formatFormText(form) {
      let text = "=== 运维表单 ===\n\n";
      text += `设备名称：${form.deviceName}\n`;
      if (form.deviceNo) text += `设备编号：${form.deviceNo}\n`;
      if (form.formId) text += `表单ID：${form.formId}\n`;
      text += `维护类型：${form.maintenanceType}\n`;
      text += `优先级：${form.priorityLevel}\n`;
      text += `预计耗时：${form.estimatedTime} min\n\n`;
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
          "清空当前表单？（已入库记录不受影响）",
          "清空",
          {
            confirmButtonText: "确定",
            cancelButtonText: "取消",
            type: "warning"
          }
        ).then(() => {
          this.clearBatchList();
          this.currentForm = null;
          this.$modal.msgSuccess("已清空");
        }).catch(() => {});
      } else {
        this.clearBatchList();
        this.currentForm = null;
        this.$modal.msgSuccess("已清空");
      }
    },

    clearBatchList() {
      this.batchGeneratedForms = [];
      this.batchCollapseActive = "";
    },

    /** 保存/更新后当前表单对象已替换时，同步批量列表中同设备项 */
    syncCurrentFormIntoBatchList() {
      if (!this.currentForm || !this.batchGeneratedForms.length) {
        return;
      }
      const did = this.currentForm.deviceId;
      const i = this.batchGeneratedForms.findIndex(
        (f) => f && String(f.deviceId) === String(did)
      );
      if (i >= 0) {
        this.$set(this.batchGeneratedForms, i, this.currentForm);
      }
    },

    onBatchCollapseChange(activeName) {
      if (activeName == null || activeName === "") {
        return;
      }
      const m = /^batch-(\d+)$/.exec(String(activeName));
      if (!m) {
        return;
      }
      const i = parseInt(m[1], 10);
      const f = this.batchGeneratedForms[i];
      if (f) {
        this.currentForm = f;
      }
    },

    truncateText(text, maxLen) {
      if (text == null || text === "") {
        return "—";
      }
      const s = String(text).replace(/\s+/g, " ").trim();
      const n = maxLen != null ? maxLen : 200;
      if (s.length <= n) {
        return s;
      }
      return s.slice(0, n) + "…";
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
          const res = await deleteMaintenanceForm(form.formId);
          
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
          const res = await deleteMaintenanceForm(this.currentForm.formId);
          
          if (res && res.code === 200) {
            this.$modal.msgSuccess("删除成功");
            const fid = this.currentForm.formId;
            this.batchGeneratedForms = (this.batchGeneratedForms || []).filter(
              (f) => !f.formId || Number(f.formId) !== Number(fid)
            );
            if (this.batchGeneratedForms.length > 0) {
              this.currentForm = this.batchGeneratedForms[0];
              this.batchCollapseActive = "batch-0";
            } else {
              this.currentForm = null;
              this.batchCollapseActive = "";
            }
            // 重新加载历史记录
            this.loadFormHistory();
          } else {
            this.$modal.msgError(res?.msg || "删除失败");
          }
        } catch (e) {
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
        const res = await listAiMaintenanceForm({});
        
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
        } else {
          this.formHistoryList = [];
        }
      } catch (e) {
        this.formHistoryList = [];
      } finally {
        this.historyLoading = false;
      }
    },
    
    // 从历史记录加载表单
    loadFormFromHistory(form) {
      this.clearBatchList();
      this.currentForm = form;
      this.showFormHistory = false;
      this.$modal.msgSuccess("已加载");
    },
    
    // 查看表单详情
    viewFormDetail(form) {
      this.clearBatchList();
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
  &.form-gen-layout {
    width: calc(100% + 40px);
    max-width: none;
    margin-left: -20px;
    margin-right: -20px;
    box-sizing: border-box;
    padding-left: 12px;
    padding-right: 12px;
    display: flex;
    flex-direction: column;
    min-height: calc(100vh - 90px);
  }

  .form-gen-workspace {
    flex: 1;
    display: flex;
    flex-direction: column;
    min-height: 0;
  }

  @media (max-width: 768px) {
    &.form-gen-layout {
      width: 100%;
      max-width: 100%;
      margin-left: 0;
      margin-right: 0;
      padding-left: 0;
      padding-right: 0;
    }
  }

  .split-workspace {
    display: flex;
    flex-direction: row;
    align-items: stretch;
    flex: 1;
    min-height: 0;
    width: 100%;
    gap: 0;
  }

  .split-workspace--dragging {
    cursor: col-resize;
    user-select: none;

    * {
      user-select: none;
    }
  }

  .split-pane {
    display: flex;
    flex-direction: column;
    min-height: 0;
    min-width: 0;

    > .el-card {
      flex: 1;
      min-height: 0;
      width: 100%;
    }
  }

  .split-pane--right {
    flex: 1;
  }

  .split-gutter {
    flex-shrink: 0;
    width: 10px;
    margin: 0 4px;
    cursor: col-resize;
    display: flex;
    align-items: stretch;
    justify-content: center;
    border-radius: 4px;
    transition: background 0.15s ease;

    &:hover,
    .split-workspace--dragging & {
      background: rgba(94, 161, 255, 0.12);
    }

    .split-gutter__line {
      align-self: center;
      width: 3px;
      height: 48px;
      border-radius: 2px;
      background: $border-color;
      transition: background 0.15s ease;
    }

    &:hover .split-gutter__line,
    .split-workspace--dragging & .split-gutter__line {
      background: $accent-color;
    }
  }

  .split-workspace--narrow {
    flex-direction: column;

    .split-gutter {
      display: none;
    }

    .split-pane--left,
    .split-pane--right {
      width: 100% !important;
      flex: none;
    }

    .split-pane--left {
      margin-bottom: 12px;
    }
  }

  .list-card {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;

    ::v-deep .el-card__body {
      flex: 1;
      display: flex;
      flex-direction: column;
      min-height: 0;
      padding: 14px 16px 16px;
    }
  }

  .card-header--list {
    flex-wrap: wrap;
    gap: 8px 10px;
    align-items: center;

    .header-title-row {
      font-size: 16px;
      line-height: 1.4;
      font-weight: 600;
    }

    .header-count {
      font-style: normal;
      font-weight: 600;
      font-size: 13px;
      color: $accent-color;
      margin-left: 8px;
    }
  }

  .filter-section--comfortable {
    margin-bottom: 12px;
    gap: 8px 10px;

    .filter-search {
      width: 200px;
      max-width: 100%;
    }

    .filter-select {
      width: 108px;
    }
  }

  .device-list-section {
    flex: 1;
    min-height: 0;
    display: flex;
    flex-direction: column;

    .text-muted {
      color: $text-disabled;
      font-size: 13px;
    }
  }

  .device-table--readable {
    flex: 1;
    min-height: 0;

    ::v-deep .el-table__header th,
    ::v-deep .el-table__body td {
      padding: 9px 8px !important;
    }

    ::v-deep .el-table__header th .cell,
    ::v-deep .el-table__body td .cell {
      line-height: 1.45 !important;
      font-size: 13px !important;
    }

    ::v-deep .el-table__header th {
      font-weight: 600;
    }

    .issue-inline {
      display: block;
      font-size: 13px;
      line-height: 1.45;
      color: $text-secondary;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      cursor: default;
    }

    .table-action-btn {
      padding: 0 6px !important;
      font-size: 13px !important;
    }
  }

  .form-panel-card {
    height: 100%;
    display: flex;
    flex-direction: column;

    ::v-deep .el-card__body {
      flex: 1;
      min-height: 0;
      display: flex;
      flex-direction: column;
      padding: 14px 16px 16px;
    }
  }

  .form-content-scroll {
    overflow-y: auto;
    padding-right: 6px;
    flex: 1;
    min-height: 0;
  }

  .form-placeholder-card {
    .form-placeholder-body {
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px 16px;
      box-sizing: border-box;
    }
  }

  .empty-filter-hint {
    margin: 12px 0 0;
    padding: 10px 12px;
    font-size: 13px;
    color: $text-secondary;
    background: rgba(94, 161, 255, 0.06);
    border-radius: 4px;
    border-left: 3px solid $accent-color;
  }

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
    margin-bottom: 14px;
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 8px 10px;
    .filter-search {
      width: 220px;
      max-width: 100%;
    }
    .filter-select {
      width: 108px;
    }
  }
  
  .form-result-card {
    .card-header .form-actions-header {
      display: flex;
      gap: 8px;
      flex-wrap: wrap;
      justify-content: flex-end;
    }

    .batch-form-picker {
      margin-bottom: 12px;
      padding-bottom: 4px;
      border-bottom: 1px solid $border-color;
      &__title {
        font-size: 13px;
        font-weight: 600;
        color: $text-primary;
        margin-bottom: 8px;
      }
      &__item-title {
        margin-right: 8px;
        font-weight: 500;
      }
      &__snippet {
        font-size: 12px;
        color: $text-secondary;
        line-height: 1.55;
        white-space: pre-wrap;
        word-break: break-word;
      }
    }
    .batch-form-collapse {
      border: none;
      ::v-deep .el-collapse-item__header {
        height: auto;
        min-height: 42px;
        line-height: 1.45;
        padding: 8px 10px;
        flex-wrap: wrap;
        gap: 6px;
      }
      ::v-deep .el-collapse-item__wrap {
        border-bottom: none;
      }
      ::v-deep .el-collapse-item__content {
        padding-bottom: 10px;
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
        white-space: pre-line;
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
