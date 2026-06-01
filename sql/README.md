# SQL 脚本说明

**作者：wangchangzhen

## 1. 数据库初始化（仅此一份）

| 文件 | 说明 |
|------|------|
| **`biye.sql`** | **唯一主脚本**：若依系统表 + 业务表（`eq_*`、`ai_*`、`sys_user_message` 等）、示例数据、**定时任务 `sys_job`（含 job_id 100 检查报警、101 运维表单推送默认暂停）**，以及文件末尾 **增量补丁合并**（菜单纠偏、告警 `alert_type` 回填、`sys_user_message.biz_id` 列类型纠偏等）。导入后 Quartz 按库内任务配置自动调度。 |
| `docs/论文/数据库内容/biye.sql` | 论文归档副本；应与仓库根目录 `sql/biye.sql` 保持一致（按需同步）。 |

不再维护单独的 `patch_*.sql` / `schedule_*.sql` / `增量脚本整合.sql`，避免多处不一致。

## 2. 日志文件分类（Logback）

默认日志目录：`LOG_PATH` 环境变量，未设置时为运行目录下 **`logs/`**。

| 目录/文件 | 内容 |
|-----------|------|
| `logs/sys-info.log` | 全局 INFO |
| `logs/sys-error.log` | 全局 ERROR |
| `logs/category/quartz-schedule.log` | Quartz 调度、`MaintenanceFormScheduleFacade` |
| `logs/category/alarm-maintenance.log` | 检查报警业务、`MaintenanceFormService`、`MaintenanceFormNotifyTask` |
| `logs/category/sys-user-message.log` | 站内消息写入 `SysUserMessageServiceImpl` |

## 3. 其它说明

- **站内消息**：待维护设备按 `(user_id, msg_type, biz_id)` 去重；`biz_id` 须为 **varchar（UUID）**，已在 `biye.sql` 末尾 `ALTER` 纠偏。
- **定时任务**：job **100** 默认每 **5** 分钟执行「检查报警」；job **101** 默认 **暂停**，可按需在「定时任务」监控中启用。
- **WebSocket**：检查报警成功后若有在线客户端，会广播 `type=maintenance_notice`（与前端 `main.js` 一致）。
