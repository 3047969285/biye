<template>
  <div class="app-container">
    <!-- 搜索区域 -->
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" label-width="80px">
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
      <el-form-item label="设备状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option label="正常" :value="1" />
          <el-option label="停用" :value="2" />
          <el-option label="维护" :value="3" />
          <el-option label="报废" :value="4" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="small" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="small" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 操作按钮 -->
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
          type="danger"
          plain
          icon="el-icon-delete"
          size="small"
          :disabled="multiple"
          @click="handleDelete"
        >删除</el-button>
      </el-col>
    </el-row>

    <!-- 数据表格 -->
    <el-table v-loading="loading" :data="deviceList" @selection-change="handleSelectionChange" border>
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="设备编号" align="center" prop="deviceNo" min-width="140" />
      <el-table-column label="设备名称" align="center" prop="deviceName" min-width="128" />
      <el-table-column label="设备类型" align="center" prop="deviceType" min-width="120" />
      <el-table-column label="设备型号" align="center" prop="model" min-width="120" />
      <el-table-column label="制造商" align="center" prop="manufacturer" min-width="140" />
      <el-table-column label="安装位置" align="center" prop="location" min-width="140" />
      <el-table-column label="所属部门" align="center" prop="department" min-width="120" />
      <el-table-column label="设备状态" align="center" prop="status" min-width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status === 1" type="success" @click="handleStatusChange(scope.row)">正常</el-tag>
          <el-tag v-else-if="scope.row.status === 2" type="info" @click="handleStatusChange(scope.row)">停用</el-tag>
          <el-tag v-else-if="scope.row.status === 3" type="warning" @click="handleStatusChange(scope.row)">维护</el-tag>
          <el-tag v-else-if="scope.row.status === 4" type="danger" @click="handleStatusChange(scope.row)">报废</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="责任人" align="center" prop="responsiblePerson" min-width="100" />
      <el-table-column label="操作" align="center" width="180" fixed="right">
        <template slot-scope="scope">
          <el-button size="small" type="text" @click="handleUpdate(scope.row)">编辑</el-button>
          <el-button size="small" type="text" @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 添加或修改对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
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
            <el-form-item label="设备型号" prop="model">
              <el-input v-model="form.model" placeholder="请输入设备型号" />
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
              <el-date-picker v-model="form.installDate" type="date" placeholder="选择日期" value-format="yyyy-MM-dd"></el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="保修到期日期" prop="warrantyExpiration">
              <el-date-picker v-model="form.warrantyExpiration" type="date" placeholder="选择日期" value-format="yyyy-MM-dd"></el-date-picker>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="设备状态" prop="status">
              <el-select v-model="form.status" placeholder="请选择状态">
                <el-option label="正常" :value="1" />
                <el-option label="停用" :value="2" />
                <el-option label="维护" :value="3" />
                <el-option label="报废" :value="4" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="资产价值" prop="assetValue">
              <el-input-number v-model="form.assetValue" :min="0" :precision="2" placeholder="请输入资产价值" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="使用寿命(年)" prop="lifespanYears">
              <el-input-number v-model="form.lifespanYears" :min="0" placeholder="请输入使用寿命" />
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
              <el-input v-model="form.remark" type="textarea" placeholder="请输入备注" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancel">取 消</el-button>
        <el-button type="primary" @click="submitForm">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listDevice, getDevice, addDevice, updateDevice, delDevice, updateDeviceStatus } from "@/api/equipment/device";

export default {
  name: "EquipmentManage",
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
      // 总条数
      total: 0,
      // 设备表格数据
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
        status: null
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
        ],
        deviceType: [
          { required: true, message: "设备类型不能为空", trigger: "blur" }
        ]
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询设备列表 */
    getList() {
      this.loading = true;
      listDevice(this.queryParams).then(response => {
        this.deviceList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
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
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.deviceId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加设备";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const deviceId = row.deviceId || this.ids
      getDevice(deviceId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改设备";
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
            });
          } else {
            addDevice(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
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
      this.$modal.confirm(confirmMsg).then(function() {
        return delDevice(deviceIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 状态切换 */
    handleStatusChange(row) {
      const statusNames = ['', '正常', '停用', '维护', '报废'];
      const newStatus = (row.status % 4) + 1;
      this.$modal.confirm('确认切换"' + row.deviceName + '"的状态为"' + statusNames[newStatus] + '"吗？').then(function() {
        return updateDeviceStatus(row.deviceId, newStatus);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("状态修改成功");
      }).catch(() => {});
    }
  }
};
</script>

<style scoped>
.app-container {
  padding: 20px;
}

.el-tag {
  cursor: pointer;
}
</style>
