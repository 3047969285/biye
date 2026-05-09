/**
 * 批量移除表格/查询中的设备 ID 展示；表单改为 device-select（仅显示名称+编号）
 */
const fs = require('fs')
const path = require('path')

function walk(dir, acc = []) {
  if (!fs.existsSync(dir)) return acc
  for (const f of fs.readdirSync(dir)) {
    const p = path.join(dir, f)
    const st = fs.statSync(p)
    if (st.isDirectory()) walk(p, acc)
    else if (p.endsWith('.vue')) acc.push(p)
  }
  return acc
}

function apply(content, filePath) {
  let c = content

  c = c.replace(
    /[ \t]*<el-table-column label="设备ID" align="center" prop="deviceId" min-width="320" class-name="is-device-id-col" \/>\r?\n/g,
    ''
  )

  c = c.replace(
    /      <el-form-item label="设备ID" prop="deviceId">\r?\n        <el-input\r?\n          v-model="queryParams.deviceId"\r?\n          placeholder="请输入设备ID"\r?\n          clearable\r?\n          @keyup.enter.native="handleQuery"\r?\n        \/>\r?\n      <\/el-form-item>\r?\n/g,
    ''
  )
  c = c.replace(
    /      <el-form-item label="设备ID" prop="deviceId">\r?\n        <el-input v-model="queryParams.deviceId" placeholder="请输入设备ID" clearable @keyup.enter.native="handleQuery" \/>\r?\n      <\/el-form-item>\r?\n/g,
    ''
  )

  c = c.replace(
    /            <el-form-item label="设备ID" prop="deviceId">\r?\n              <el-input v-model="form.deviceId" placeholder="请输入设备 UUID" clearable style="width: 100%" :disabled="form.statusId != null" \/>\r?\n            <\/el-form-item>/g,
    `            <el-form-item label="设备" prop="deviceId">\n              <device-select v-model="form.deviceId" :disabled="form.statusId != null" />\n            </el-form-item>`
  )

  c = c.replace(
    /            <el-form-item label="设备ID" prop="deviceId">\r?\n              <el-input v-model="form.deviceId" placeholder="请输入设备 UUID" clearable style="width: 100%" \/>\r?\n            <\/el-form-item>/g,
    `            <el-form-item label="设备" prop="deviceId">\n              <device-select v-model="form.deviceId" />\n            </el-form-item>`
  )

  c = c.replace(
    /        <el-form-item label="设备ID" prop="deviceId">\r?\n          <el-input v-model="form.deviceId" placeholder="请输入设备 UUID" clearable style="width: 100%" \/>\r?\n        <\/el-form-item>/g,
    `        <el-form-item label="设备" prop="deviceId">\n          <device-select v-model="form.deviceId" />\n        </el-form-item>`
  )

  const isParamPage = filePath.includes(['param', 'index.vue'].join(path.sep))
  if (isParamPage) {
    c = c.replace(
      /        <el-form-item label="设备ID" prop="deviceId">\r?\n          <el-input v-model="form.deviceId" placeholder="请输入设备ID" \/>\r?\n        <\/el-form-item>/g,
      `        <el-form-item label="设备" prop="deviceId">\n          <device-select v-model="form.deviceId" :disabled="form.paramId != null" />\n        </el-form-item>`
    )
  } else {
    c = c.replace(
      /        <el-form-item label="设备ID" prop="deviceId">\r?\n          <el-input v-model="form.deviceId" placeholder="请输入设备ID" \/>\r?\n        <\/el-form-item>/g,
      `        <el-form-item label="设备" prop="deviceId">\n          <device-select v-model="form.deviceId" />\n        </el-form-item>`
    )
  }

  c = c.replace(/message: "设备ID不能为空"/g, 'message: "请选择设备"')

  return c
}

const root = path.join(__dirname, '..')
const equipment = path.join(root, 'src/views/equipment')
const files = [...walk(equipment)]

for (const f of files) {
  const raw = fs.readFileSync(f, 'utf8')
  const next = apply(raw, f)
  if (next !== raw) {
    fs.writeFileSync(f, next)
    console.log('updated', path.relative(root, f))
  }
}
