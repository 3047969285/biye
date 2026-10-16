/**
 * 设备三维编目：类型 → 造型 / 色调；并提供演示种子数据（仅 API 失败时使用）。
 */

export const STATUS_META = {
  1: { key: 'normal', label: '正常', tone: '#2f8f6b' },
  2: { key: 'stopped', label: '停用', tone: '#8a7a6a' },
  3: { key: 'maintenance', label: '维护', tone: '#d4a017' },
  4: { key: 'scrapped', label: '报废', tone: '#c0392b' }
}

/**
 * 根据设备类型字符串推断三维造型种类。
 * @param {string} deviceType
 * @param {string} deviceName
 * @returns {'turbine'|'transformer'|'generator'|'sensor'|'breaker'|'node'}
 */
export function resolveMeshKind(deviceType, deviceName) {
  const text = `${deviceType || ''} ${deviceName || ''}`.toLowerCase()
  if (/风|turbine|风机|风力/.test(text)) return 'turbine'
  if (/变|transformer|箱变/.test(text)) return 'transformer'
  if (/发电|generator|机组/.test(text)) return 'generator'
  if (/传感|sensor|采集|表计/.test(text)) return 'sensor'
  if (/断路|开关|breaker|刀闸/.test(text)) return 'breaker'
  return 'node'
}

/**
 * @param {number|string} status
 */
export function statusLabel(status) {
  const meta = STATUS_META[Number(status)]
  return meta ? meta.label : '未知'
}

/**
 * @param {number|string} status
 */
export function statusTone(status) {
  const meta = STATUS_META[Number(status)]
  return meta ? meta.tone : '#c4a35a'
}

/** 演示种子：后端不可用时回退，须在 UI 标注 DEMO */
export const DEMO_DEVICES = [
  {
    deviceId: 'demo-wt-01',
    deviceNo: 'WT-AZORES-01',
    deviceName: '发电机1号',
    deviceType: '风力发电机',
    location: '沿海风电场 A 区',
    status: 1,
    statusName: '正常',
    totalCount: 128,
    _demo: true
  },
  {
    deviceId: 'demo-wt-02',
    deviceNo: 'WT-AZORES-02',
    deviceName: '发电机2号',
    deviceType: '风力发电机',
    location: '沿海风电场 A 区',
    status: 1,
    statusName: '正常',
    totalCount: 96,
    _demo: true
  },
  {
    deviceId: 'demo-tf-01',
    deviceNo: 'TF-CAMPO-01',
    deviceName: '主变压器 #1',
    deviceType: '电力变压器',
    location: '枢纽变电站',
    status: 3,
    statusName: '维护',
    totalCount: 54,
    _demo: true
  },
  {
    deviceId: 'demo-gn-01',
    deviceNo: 'GN-ROAST-01',
    deviceName: '备用发电机组',
    deviceType: '柴油发电机',
    location: '备用电源室',
    status: 2,
    statusName: '停用',
    totalCount: 22,
    _demo: true
  },
  {
    deviceId: 'demo-sn-01',
    deviceNo: 'SN-CUP-01',
    deviceName: '线路传感器簇',
    deviceType: '环境传感器',
    location: '10kV 馈线走廊',
    status: 1,
    statusName: '正常',
    totalCount: 210,
    _demo: true
  },
  {
    deviceId: 'demo-bk-01',
    deviceNo: 'BK-DELTA-01',
    deviceName: '出线断路器',
    deviceType: '高压断路器',
    location: '开关站 B 段',
    status: 1,
    statusName: '正常',
    totalCount: 41,
    _demo: true
  }
]

/**
 * 归一化列表接口返回。
 * @param {*} response axios / RuoYi 包装
 * @returns {{ devices: Array, fromDemo: boolean }}
 */
export function normalizeDeviceList(response) {
  const rows = (response && (response.rows || (response.data && response.data.rows))) || []
  if (Array.isArray(rows) && rows.length) {
    return {
      devices: rows.map((d) => ({
        ...d,
        statusName: d.statusName || statusLabel(d.status),
        _demo: false
      })),
      fromDemo: false
    }
  }
  return { devices: DEMO_DEVICES.slice(), fromDemo: true }
}
