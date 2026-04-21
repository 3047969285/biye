<template>
  <div class="app-container">
    <el-form :model="queryParams" size="small" :inline="true" label-width="90px">
      <el-form-item label="表地址">
        <el-input v-model="queryParams.meterAddress" placeholder="如 123456789012" clearable style="width: 220px" />
      </el-form-item>
      <el-form-item label="DI编码">
        <el-input v-model="queryParams.diCode" placeholder="如 00010000" clearable style="width: 180px" />
      </el-form-item>
      <el-form-item label="点位编码">
        <el-input v-model="queryParams.pointCode" placeholder="pointCode" clearable style="width: 200px" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" size="mini" icon="el-icon-search" @click="handleQuery">查询</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="rows" border>
      <el-table-column label="采样时间" prop="readTime" width="170" />
      <el-table-column label="表地址" prop="meterAddress" min-width="150" />
      <el-table-column label="DI" prop="diCode" width="120" />
      <el-table-column label="点位编码" prop="pointCode" min-width="160" />
      <el-table-column label="点位名称" prop="pointName" min-width="180" />
      <el-table-column label="值" prop="value" width="110" />
      <el-table-column label="单位" prop="unit" width="80" />
      <el-table-column label="来源" prop="source" width="90" />
    </el-table>
  </div>
</template>

<script>
import { listDl645Latest } from '@/api/meter/dl645'

export default {
  name: 'MeterDl645',
  data() {
    return {
      loading: false,
      rows: [],
      queryParams: {
        meterAddress: undefined,
        diCode: undefined,
        pointCode: undefined,
        pageNum: 1,
        pageSize: 20
      }
    }
  },
  created() {
    this.handleQuery()
  },
  methods: {
    handleQuery() {
      this.loading = true
      listDl645Latest(this.queryParams)
        .then(res => {
          const body = (res && res.data) || {}
          this.rows = body.rows || []
        })
        .catch(() => {
          this.rows = []
        })
        .finally(() => {
          this.loading = false
        })
    }
  }
}
</script>
