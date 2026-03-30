# SQL 脚本说明与执行顺序

## 1. 总览

| 顺序 | 文件 | 说明 |
|------|------|------|
| ① | `ry-vue.sql` | **主库初始化**：若依系统表 + 业务表（`eq_*`、`ai_*`、`eq_wind_forecast_bind`、`sys_user_message` 等）及示例数据。新环境先执行此文件。 |
| ② | `sys_user_message.sql` | **可选增量**：旧库从备份升级且尚无 `sys_user_message` 时执行（`CREATE TABLE IF NOT EXISTS`，与主脚本末尾建表一致）。新库执行 ① 后可跳过。 |
| ③ | `sys_config_client_poll_interval.sql` | **增量**：写入 `client.poll.interval.seconds`（前端轮询间隔，与消息中心、发电预测页等一致）。`WHERE NOT EXISTS` 防重复。 |
| ④ | `sys_job_maintenance_message_notify.sql` | **增量**：插入 Quartz 任务「运维表单待处理消息推送」，调用 `maintenanceFormNotifyTask.scanPendingFormsAndNotify`。若任务已存在请手工合并或跳过。 |

## 2. 说明

- **字符集**：与主库保持一致（建议 `utf8mb4`）。
- **站内消息去重**：业务在 `SysUserMessageServiceImpl` 中按 `(user_id, msg_type, biz_id)` 控制；Redis 为运维表单推送的可选辅助，见代码与 `CacheConstants`。
- **`eq_wind_forecast_bind`**：主脚本末尾含表结构；若旧库缺 `inline_data_json` 列，可使用 `ry-vue.sql` 中 **可选升级** 段（动态 `ALTER`，可重复执行）。

## 3. 与毕业论文文档的关系

功能与表结构对应说明见 **`docs/毕业论文-功能实现.md`** 附录 B、C。
