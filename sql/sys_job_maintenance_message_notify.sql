-- 定时任务：扫描待处理运维表单并推送站内消息（Redis 按 formId 去重 24h）
-- 在「系统监控 → 定时任务」中也可手工新增，调用目标：maintenanceFormNotifyTask.scanPendingFormsAndNotify
-- Cron 示例：每 3 分钟  0 0/3 * * * ?
-- 默认暂停状态 job_status=1，确认无误后在界面改为「正常」并执行一次

INSERT INTO sys_job (
  job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status,
  create_by, create_time, remark
) VALUES (
  '运维表单待处理消息推送',
  'DEFAULT',
  'maintenanceFormNotifyTask.scanPendingFormsAndNotify',
  '0 0/3 * * * ?',
  '3',
  '1',
  '1',
  'admin',
  NOW(),
  '扫描 draft/pending 表单并调用 notifyMaintenanceFormPending；与实时推送共用 Redis SET NX（maintenance:form:schedule_notify:{formId}，24h）'
);
