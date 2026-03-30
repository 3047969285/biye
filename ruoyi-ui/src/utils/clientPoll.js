const STORAGE_KEY = 'client.poll.interval.seconds'
const MIN_SEC = 30
const MAX_SEC = 3600
const FALLBACK_SEC = 180

/** 与 {@code setClientPollIntervalSec} 触发的事件名一致，供消息中心等监听 */
export const CLIENT_POLL_INTERVAL_EVENT = 'client-poll-interval-changed'

function clampSec(n) {
  if (!Number.isFinite(n)) return FALLBACK_SEC
  return Math.min(MAX_SEC, Math.max(MIN_SEC, Math.round(n)))
}

/**
 * 浏览器端统一轮询间隔（秒）。优先读 localStorage（发电预测页可改），否则用服务端默认。
 * @param {number|string|undefined|null} serverDefaultSec 来自参数配置或 /wind/forecast/latest 的 config
 */
export function getClientPollIntervalSec(serverDefaultSec) {
  const def = clampSec(parseInt(serverDefaultSec, 10))
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (raw == null || raw === '') return def
    const n = parseInt(raw, 10)
    if (!Number.isFinite(n)) return def
    return clampSec(n)
  } catch (e) {
    return def
  }
}

/**
 * 写入本机偏好并通知其他组件重启定时器
 * @param {number|string} sec
 * @returns {boolean}
 */
export function setClientPollIntervalSec(sec) {
  const n = clampSec(parseInt(sec, 10))
  try {
    localStorage.setItem(STORAGE_KEY, String(n))
    if (typeof window !== 'undefined') {
      window.dispatchEvent(new CustomEvent(CLIENT_POLL_INTERVAL_EVENT, { detail: n }))
    }
    return true
  } catch (e) {
    return false
  }
}

export { MIN_SEC as CLIENT_POLL_MIN_SEC, MAX_SEC as CLIENT_POLL_MAX_SEC, FALLBACK_SEC as CLIENT_POLL_FALLBACK_SEC }
