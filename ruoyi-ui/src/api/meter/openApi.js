import request from '@/utils/request'

// 获取开放的点表列表（匿名）
export function getOpenMeterPoints() {
  return request({
    url: '/api/open/meter/points',
    method: 'get',
    timeout: 10000,
    // open 接口带 @Anonymous，可能没有 token 也能访问；request 拦截器会自动附 token（若存在）
  })
}

// 获取开放的点表汇总（匿名）
export function getOpenMeterSummary(params) {
  return request({
    url: '/api/open/meter/summary',
    method: 'get',
    params: params || {},
    timeout: 10000
  })
}

