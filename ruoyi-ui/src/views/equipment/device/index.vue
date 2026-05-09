<template>
  <div class="app-container">
    <!-- 统计卡片 -->
    <el-row :gutter="20" style="margin-bottom: 20px;">
      <el-col :span="6">
        <el-card class="status-card" shadow="hover">
          <div class="status-content">
            <div class="status-icon normal">
              <i class="el-icon-success"></i>
            </div>
            <div class="status-info">
              <div class="status-value">{{ statistics.正常 || 0 }}</div>
              <div class="status-label">正常运行</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="status-card" shadow="hover">
          <div class="status-content">
            <div class="status-icon stopped">
              <i class="el-icon-video-pause"></i>
            </div>
            <div class="status-info">
              <div class="status-value">{{ statistics.停用 || 0 }}</div>
              <div class="status-label">已停用</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="status-card" shadow="hover">
          <div class="status-content">
            <div class="status-icon maintenance">
              <i class="el-icon-setting"></i>
            </div>
            <div class="status-info">
              <div class="status-value">{{ statistics.维护中 || 0 }}</div>
              <div class="status-label">维护中</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="status-card" shadow="hover">
          <div class="status-content">
            <div class="status-icon scrapped">
              <i class="el-icon-delete"></i>
            </div>
            <div class="status-info">
              <div class="status-value">{{ statistics.已报废 || 0 }}</div>
              <div class="status-label">已报废</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 查询和工具栏 -->
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="设备编号" prop="deviceNo">
        <el-input
          v-model="queryParams.deviceNo"
          placeholder="请输入设备编号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="设备名称" prop="deviceName">
        <el-input
          v-model="queryParams.deviceName"
          placeholder="请输入设备名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="设备类型" prop="deviceType">
        <el-input
          v-model="queryParams.deviceType"
          placeholder="请输入设备类型"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="设备状态" clearable>
          <el-option label="正常" :value="1" />
          <el-option label="停用" :value="2" />
          <el-option label="维护中" :value="3" />
          <el-option label="已报废" :value="4" />
        </el-select>
      </el-form-item>
      <el-form-item label="安装位置" prop="location">
        <el-input
          v-model="queryParams.location"
          placeholder="请输入安装位置"
          clearable
          @keyup.enter.native="handleQuery"
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
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="small"
          :disabled="single"
          @click="handleUpdate"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="small"
          :disabled="multiple"
          @click="handleDelete"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-setting"
          size="small"
          :disabled="multiple"
          @click="showBatchStatusDialog"
        >批量状态变更</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <!-- 设备列表 -->
    <el-table v-loading="loading" :data="deviceList" @selection-change="handleSelectionChange" border>
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="设备编号" align="center" prop="deviceNo" min-width="120" />
      <el-table-column label="设备名称" align="center" prop="deviceName" min-width="128" />
      <el-table-column label="设备类型" align="center" prop="deviceType" min-width="100" />
      <el-table-column label="型号" align="center" prop="model" min-width="120" />
      <el-table-column label="序列号" align="center" prop="serialNumber" min-width="140" />
      <el-table-column label="制造商" align="center" prop="manufacturer" min-width="120" />
      <el-table-column label="安装位置" align="center" prop="location" min-width="150" />
      <el-table-column label="状态" align="center" prop="status" min-width="120">
        <template slot-scope="scope">
          <el-tag 
            :type="getStatusType(scope.row.status)" 
            size="small"
            style="cursor: pointer;"
            @click="handleStatusChange(scope.row)"
          >
            {{ getStatusName(scope.row.status) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="责任人" align="center" prop="responsiblePerson" min-width="100" />
      <el-table-column label="操作" align="center" width="250" fixed="right">
        <template slot-scope="scope">
          <el-button
            size="small"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
          >修改</el-button>
          <el-button
            size="small"
            type="text"
            icon="el-icon-switch-button"
            @click="handleStatusChange(scope.row)"
          >状态变更</el-button>
          <el-button
            size="small"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
          >删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 添加或修改设备对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="700px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="设备编号" prop="deviceNo">
              <el-input v-model="form.deviceNo" placeholder="请输入设备编号" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="设备名称" prop="deviceName">
              <el-input v-model="form.deviceName" placeholder="请输入设备名称" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="设备类型" prop="deviceType">
              <el-input v-model="form.deviceType" placeholder="请输入设备类型" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="型号" prop="model">
              <el-input v-model="form.model" placeholder="请输入型号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="序列号" prop="serialNumber">
              <el-input v-model="form.serialNumber" placeholder="请输入序列号" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="制造商" prop="manufacturer">
              <el-input v-model="form.manufacturer" placeholder="请输入制造商" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="安装位置" prop="location">
              <el-input v-model="form.location" placeholder="请输入安装位置" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="所属部门" prop="department">
              <el-input v-model="form.department" placeholder="请输入所属部门" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="安装日期" prop="installDate">
              <el-date-picker clearable
                v-model="form.installDate"
                type="date"
                value-format="yyyy-MM-dd"
                placeholder="请选择安装日期">
              </el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="保修到期日期" prop="warrantyExpiration">
              <el-date-picker clearable
                v-model="form.warrantyExpiration"
                type="date"
                value-format="yyyy-MM-dd"
                placeholder="请选择保修到期日期">
              </el-date-picker>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="状态" prop="status">
              <el-select v-model="form.status" placeholder="请选择状态">
                <el-option label="正常" :value="1" />
                <el-option label="停用" :value="2" />
                <el-option label="维护中" :value="3" />
                <el-option label="已报废" :value="4" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="资产价值" prop="assetValue">
              <el-input v-model="form.assetValue" placeholder="请输入资产价值" type="number" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="使用寿命（年）" prop="lifespanYears">
              <el-input v-model="form.lifespanYears" placeholder="请输入使用寿命" type="number" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="责任人" prop="responsiblePerson">
              <el-input v-model="form.responsiblePerson" placeholder="请输入责任人" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="备注" prop="remark">
              <el-input v-model="form.remark" type="textarea" placeholder="请输入内容" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 状态变更对话框 -->
    <el-dialog title="设备状态变更" :visible.sync="statusDialogVisible" width="400px" append-to-body>
      <el-form>
        <el-form-item label="当前设备">
          <div style="padding-left: 10px;">{{ currentDevice.deviceName }}</div>
        </el-form-item>
        <el-form-item label="当前状态">
          <el-tag :type="getStatusType(currentDevice.status)">
            {{ getStatusName(currentDevice.status) }}
          </el-tag>
        </el-form-item>
        <el-form-item label="更改为">
          <el-select v-model="newStatus" placeholder="请选择新状态" style="width: 100%;">
            <el-option label="正常" :value="1">
              <span style="float: left;">正常</span>
              <span style="float: right; color: #67C23A; margin-right: 15px;">●</span>
            </el-option>
            <el-option label="停用" :value="2">
              <span style="float: left;">停用</span>
              <span style="float: right; color: #909399; margin-right: 15px;">●</span>
            </el-option>
            <el-option label="维护中" :value="3">
              <span style="float: left;">维护中</span>
              <span style="float: right; color: #E6A23C; margin-right: 15px;">●</span>
            </el-option>
            <el-option label="已报废" :value="4">
              <span style="float: left;">已报废</span>
              <span style="float: right; color: #F56C6C; margin-right: 15px;">●</span>
            </el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="confirmStatusChange">确 定</el-button>
        <el-button @click="statusDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 批量状态变更对话框 -->
    <el-dialog title="批量状态变更" :visible.sync="batchStatusDialogVisible" width="400px" append-to-body>
      <el-form>
        <el-form-item label="选中设备数">
          <div style="padding-left: 10px;">{{ ids.length }} 个</div>
        </el-form-item>
        <el-form-item label="变更为">
          <el-select v-model="batchNewStatus" placeholder="请选择新状态" style="width: 100%;">
            <el-option label="正常" :value="1">
              <span style="float: left;">正常</span>
              <span style="float: right; color: #67C23A; margin-right: 15px;">●</span>
            </el-option>
            <el-option label="停用" :value="2">
              <span style="float: left;">停用</span>
              <span style="float: right; color: #909399; margin-right: 15px;">●</span>
            </el-option>
            <el-option label="维护中" :value="3">
              <span style="float: left;">维护中</span>
              <span style="float: right; color: #E6A23C; margin-right: 15px;">●</span>
            </el-option>
            <el-option label="已报废" :value="4">
              <span style="float: left;">已报废</span>
              <span style="float: right; color: #F56C6C; margin-right: 15px;">●</span>
            </el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="confirmBatchStatusChange">确 定</el-button>
        <el-button @click="batchStatusDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {
  listDevice,
  getDevice,
  delDevice,
  addDevice,
  updateDevice,
  updateDeviceStatus,
  updateDeviceStatusBatch,
  getDeviceStatistics
} from "@/api/equipment/device";

export default {
  name: "Device",
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 设备信息表格数据
      deviceList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        deviceNo: null,
        deviceName: null,
        deviceType: null,
        status: null,
        location: null,
        department: null,
        responsiblePerson: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        deviceNo: [
          { required: true, message: "设备编号不能为空", trigger: "blur" }
        ],
        deviceName: [
          { required: true, message: "设备名称不能为空", trigger: "blur" }
        ]
      },
      // 统计数据
      statistics: {},
      // 状态变更对话框
      statusDialogVisible: false,
      currentDevice: {},
      newStatus: null,
      // 批量状态变更
      batchStatusDialogVisible: false,
      batchNewStatus: null
    };
  },
  created() {
    this.getList();
    this.getStatistics();
  },
  methods: {
    /** 查询设备信息列表 */
    getList() {
      this.loading = true;
      listDevice(this.queryParams).then(response => {
        this.deviceList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    /** 获取统计信息 */
    getStatistics() {
      getDeviceStatistics().then(response => {
        this.statistics = response.data.byStatus || {};
      });
    },
    /** 取消按钮 */
    cancel() {
      this.open = false;
      this.reset();
    },
    /** 表单重置 */
    reset() {
      this.form = {
        deviceId: null,
        deviceNo: null,
        deviceName: null,
        deviceType: null,
        model: null,
        serialNumber: null,
        manufacturer: null,
        location: null,
        department: null,
        installDate: null,
        warrantyExpiration: null,
        status: 1,
        assetValue: null,
        lifespanYears: null,
        responsiblePerson: null,
        remark: null
      };
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    /** 多选框选中数据 */
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.deviceId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加设备信息";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const deviceId = row.deviceId || this.ids;
      getDevice(deviceId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改设备信息";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.deviceId != null) {
            updateDevice(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
              this.getStatistics();
            });
          } else {
            addDevice(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
              this.getStatistics();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const deviceIds = row ? row.deviceId : this.ids;
      let confirmMsg = '是否确认删除所选设备？';
      if (row && row.deviceId) {
        const name = row.deviceName || '';
        const no = row.deviceNo ? '（编号 ' + row.deviceNo + '）' : '';
        confirmMsg = '是否确认删除设备「' + name + '」' + no + '？';
      }
      this.$modal.confirm(confirmMsg).then(() => {
        return delDevice(deviceIds);
      }).then(() => {
        this.getList();
        this.getStatistics();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 状态变更操作 */
    handleStatusChange(row) {
      this.currentDevice = row;
      this.newStatus = row.status;
      this.statusDialogVisible = true;
    },
    /** 确认状态变更 */
    confirmStatusChange() {
      if (this.newStatus === this.currentDevice.status) {
        this.$modal.msgWarning("状态未变更");
        return;
      }
      updateDeviceStatus(this.currentDevice.deviceId, this.newStatus).then(response => {
        this.$modal.msgSuccess(response.msg || "状态更新成功");
        this.statusDialogVisible = false;
        this.getList();
        this.getStatistics();
      });
    },
    /** 显示批量状态变更对话框 */
    showBatchStatusDialog() {
      this.batchNewStatus = null;
      this.batchStatusDialogVisible = true;
    },
    /** 确认批量状态变更 */
    confirmBatchStatusChange() {
      if (!this.batchNewStatus) {
        this.$modal.msgWarning("请选择新状态");
        return;
      }
      updateDeviceStatusBatch(this.ids, this.batchNewStatus).then(response => {
        this.$modal.msgSuccess(response.msg || "批量状态更新成功");
        this.batchStatusDialogVisible = false;
        this.getList();
        this.getStatistics();
      });
    },
    /** 获取状态名称 */
    getStatusName(status) {
      const statusMap = {
        1: '正常',
        2: '停用',
        3: '维护中',
        4: '已报废'
      };
      return statusMap[status] || '未知';
    },
    /** 获取状态类型 */
    getStatusType(status) {
      const typeMap = {
        1: 'success',
        2: 'info',
        3: 'warning',
        4: 'danger'
      };
      return typeMap[status] || '';
    }
  }
};
</script>

<style scoped>
.status-card {
  background: rgba(30, 35, 48, 0.6);
  border: 1px solid rgba(99, 102, 241, 0.2);
  border-radius: 0;
  backdrop-filter: blur(10px);
}

.status-card ::v-deep .el-card__body {
  padding: 20px;
}

.status-content {
  display: flex;
  align-items: center;
}

.status-icon {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  margin-right: 15px;
}

.status-icon.normal {
  background: rgba(103, 194, 58, 0.1);
  color: #67C23A;
}

.status-icon.stopped {
  background: rgba(144, 147, 153, 0.1);
  color: #909399;
}

.status-icon.maintenance {
  background: rgba(230, 162, 60, 0.1);
  color: #E6A23C;
}

.status-icon.scrapped {
  background: rgba(245, 108, 108, 0.1);
  color: #F56C6C;
}

.status-info {
  flex: 1;
}

.status-value {
  font-size: 28px;
  font-weight: bold;
  color: #E2E8F0;
  margin-bottom: 5px;
}

.status-label {
  font-size: 14px;
  color: #94A3B8;
}
</style>
