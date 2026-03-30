<template>
  <div class="app-container">
    <!-- 查询和工具栏 -->
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="90px">
      <el-form-item label="点编码" prop="pointCode">
        <el-input
          v-model="queryParams.pointCode"
          placeholder="请输入点编码"
          clearable
          @keyup.enter.native="handleQuery"
          style="width: 260px"
        />
      </el-form-item>
      <el-form-item label="点名称" prop="pointName">
        <el-input
          v-model="queryParams.pointName"
          placeholder="请输入点名称"
          clearable
          @keyup.enter.native="handleQuery"
          style="width: 260px"
        />
      </el-form-item>
      <el-form-item label="从站地址" prop="slaveId">
        <el-input
          v-model="queryParams.slaveId"
          placeholder="默认 1"
          clearable
          @keyup.enter.native="handleQuery"
          style="width: 180px"
        />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="点状态" clearable style="width: 180px">
          <el-option label="正常" :value="'0'" />
          <el-option label="停用" :value="'1'" />
        </el-select>
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
          v-hasPermi="['meter:point:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['meter:point:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['meter:point:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-upload"
          size="mini"
          @click="openImportDialog"
          v-hasPermi="['meter:point:import']"
        >批量导入</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <!-- 列表 -->
    <el-table v-loading="loading" :data="pointList" @selection-change="handleSelectionChange" border>
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="点编码" align="center" prop="pointCode" :show-overflow-tooltip="true" />
      <el-table-column label="点名称" align="center" prop="pointName" :show-overflow-tooltip="true" />
      <el-table-column label="从站地址" align="center" prop="slaveId" width="110" />
      <el-table-column label="寄存器偏移" align="center" prop="addrOffset" width="140" />
      <el-table-column label="寄存器类型" align="center" prop="registerType" width="120" />
      <el-table-column label="数据类型" align="center" prop="dataType" width="120" />
      <el-table-column label="字交换" align="center" prop="wordSwap" width="100">
        <template slot-scope="scope">
          <span>{{ scope.row.wordSwap === '1' ? '是' : '否' }}</span>
        </template>
      </el-table-column>
      <el-table-column label="工程系数" align="center" prop="scale" width="160" :show-overflow-tooltip="true" />
      <el-table-column label="工程加偏" align="center" prop="valueOffset" width="160" :show-overflow-tooltip="true" />
      <el-table-column label="单位" align="center" prop="unit" width="120" :show-overflow-tooltip="true" />
      <el-table-column label="排序" align="center" prop="sortOrder" width="90" />
      <el-table-column label="状态" align="center" prop="status" width="100">
        <template slot-scope="scope">
          <el-tag :type="scope.row.status === '0' ? 'success' : 'info'">{{ scope.row.status === '0' ? '正常' : '停用' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="200">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['meter:point:edit']">
            修改
          </el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['meter:point:remove']">
            删除
          </el-button>
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

    <!-- 新增/修改 -->
    <el-dialog :title="title" :visible.sync="open" width="820px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <el-row :gutter="10">
          <el-col :span="12">
            <el-form-item label="点编码" prop="pointCode">
              <el-input v-model="form.pointCode" placeholder="点编码唯一" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="点名称" prop="pointName">
              <el-input v-model="form.pointName" placeholder="用于对外展示" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="10">
          <el-col :span="8">
            <el-form-item label="从站地址" prop="slaveId">
              <el-input v-model="form.slaveId" placeholder="默认 1" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="寄存器偏移" prop="addrOffset">
              <el-input v-model="form.addrOffset" placeholder="相对 baseAddress（0 起）" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="寄存器类型" prop="registerType">
              <el-select v-model="form.registerType" placeholder="0/1">
                <el-option label="保持寄存器 FC03（0）" :value="0" />
                <el-option label="输入寄存器 FC04（1）" :value="1" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="10">
          <el-col :span="8">
            <el-form-item label="数据类型" prop="dataType">
              <el-select v-model="form.dataType" placeholder="UINT16">
                <el-option label="UINT16" :value="'UINT16'" />
                <el-option label="INT16" :value="'INT16'" />
                <el-option label="UINT32" :value="'UINT32'" />
                <el-option label="INT32" :value="'INT32'" />
                <el-option label="FLOAT32" :value="'FLOAT32'" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="字交换" prop="wordSwap">
              <el-select v-model="form.wordSwap" placeholder="0">
                <el-option label="否（0）" :value="'0'" />
                <el-option label="是（1）" :value="'1'" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="排序" prop="sortOrder">
              <el-input v-model="form.sortOrder" placeholder="默认 0" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="10">
          <el-col :span="8">
            <el-form-item label="工程系数 scale" prop="scale">
              <el-input v-model="form.scale" placeholder="默认 1" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="工程加偏 valueOffset" prop="valueOffset">
              <el-input v-model="form.valueOffset" placeholder="默认 0" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="单位 unit" prop="unit">
              <el-input v-model="form.unit" placeholder="可选" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="6">
            <el-form-item label="状态 status" prop="status">
              <el-radio-group v-model="form.status">
                <el-radio :label="'0'">正常</el-radio>
                <el-radio :label="'1'">停用</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 批量导入 -->
    <el-dialog title="批量导入点表（JSON数组）" :visible.sync="importOpen" width="920px" append-to-body>
      <el-form label-width="140px">
        <el-form-item label="更新策略">
          <el-radio-group v-model="importUpdateSupport">
            <el-radio :label="false">仅新增</el-radio>
            <el-radio :label="true">更新已有点</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="JSON数组">
          <el-input
            type="textarea"
            :rows="14"
            v-model="importJsonText"
            placeholder='示例：[{ "pointCode":"P001","pointName":"有功功率","slaveId":1,"addrOffset":0,"registerType":0,"dataType":"UINT16","wordSwap":"0","scale":1,"valueOffset":0,"unit":"kW","sortOrder":1,"status":"0"}]'
          />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="importOpen = false">取 消</el-button>
        <el-button type="primary" @click="submitImport">开始导入</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listMeterPoint, getMeterPoint, addMeterPoint, updateMeterPoint, delMeterPoint, importMeterPoints } from '@/api/meter/point'

export default {
  name: 'MeterPoint',
  data() {
    return {
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
      // 列表数据
      pointList: [],
      // 弹出层标题
      title: '',
      // 是否显示弹出层
      open: false,
      // 导入弹出层
      importOpen: false,
      importUpdateSupport: false,
      importJsonText: '',
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        pointCode: undefined,
        pointName: undefined,
        slaveId: undefined,
        status: undefined
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        pointCode: [{ required: true, message: '点编码不能为空', trigger: 'blur' }],
        pointName: [{ required: true, message: '点名称不能为空', trigger: 'blur' }]
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.queryParams.pointCode = undefined
      this.queryParams.pointName = undefined
      this.queryParams.slaveId = undefined
      this.queryParams.status = undefined
      this.handleQuery()
    },
    getList() {
      this.loading = true
      listMeterPoint(this.queryParams).then(response => {
        this.pointList = response.rows
        this.total = response.total
        this.loading = false
      }).catch(() => {
        this.loading = false
      })
    },
    // 取消按钮
    cancel() {
      this.open = false
      this.reset()
    },
    // 表单重置
    reset() {
      this.form = {
        pointId: undefined,
        pointCode: undefined,
        pointName: undefined,
        slaveId: 1,
        addrOffset: 0,
        registerType: 0,
        dataType: 'UINT16',
        wordSwap: '0',
        scale: 1,
        valueOffset: 0,
        unit: undefined,
        sortOrder: 0,
        status: '0'
      }
      if (this.$refs.form) {
        this.$refs.form.clearValidate()
      }
    },
    /** 查询选择项 */
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.pointId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset()
      this.open = true
      this.title = '添加电表点表'
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      const rowData = row || this.pointList.find(v => v.pointId === this.ids[0])
      const pointId = rowData ? (rowData.pointId || this.ids) : this.ids
      if (!pointId) return
      this.reset()
      getMeterPoint(pointId).then(response => {
        this.form = response.data || {}
        this.open = true
        this.title = '修改电表点表'
      })
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs.form.validate(valid => {
        if (valid) {
          // delete/create 区分：pointId 是否存在
          if (this.form.pointId != null) {
            updateMeterPoint(this.form).then(() => {
              this.$modal.msgSuccess('修改成功')
              this.open = false
              this.getList()
            })
          } else {
            addMeterPoint(this.form).then(() => {
              this.$modal.msgSuccess('新增成功')
              this.open = false
              this.getList()
            })
          }
        }
      })
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const pointIds = row ? row.pointId : this.ids
      if (!pointIds || (Array.isArray(pointIds) && pointIds.length === 0)) return
      this.$modal.confirm('是否确认删除选中的点表？').then(() => {
        return delMeterPoint(pointIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess('删除成功')
      }).catch(() => {})
    },
    openImportDialog() {
      this.importOpen = true
      this.importUpdateSupport = false
      this.importJsonText = ''
    },
    normalizeImportItem(item) {
      const o = { ...item }
      if (o.wordSwap !== undefined && o.wordSwap !== null && o.wordSwap !== '') {
        o.wordSwap = String(o.wordSwap)
      }
      if (o.status !== undefined && o.status !== null && o.status !== '') {
        o.status = String(o.status)
      }
      if (o.delFlag !== undefined && o.delFlag !== null && o.delFlag !== '') {
        o.delFlag = String(o.delFlag)
      }
      return o
    },
    submitImport() {
      let list = null
      try {
        list = JSON.parse(this.importJsonText || '[]')
      } catch (e) {
        this.$modal.msgError('JSON 解析失败，请检查输入内容')
        return
      }
      if (!Array.isArray(list) || list.length === 0) {
        this.$modal.msgWarning('导入数据为空')
        return
      }
      const normalized = list.map(i => this.normalizeImportItem(i))
      importMeterPoints(normalized, this.importUpdateSupport).then(() => {
        this.$modal.msgSuccess('导入完成')
        this.importOpen = false
        this.getList()
      })
    }
  }
}
</script>

<style scoped>
.app-container {
  padding: 20px;
}
</style>

