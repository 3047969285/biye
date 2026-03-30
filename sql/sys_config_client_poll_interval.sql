-- 已有库增量：前端统一轮询间隔（秒），与 wind.forecast.schedule-interval-ms 默认 3 分钟对齐
-- 执行后可在「系统管理 → 参数设置」中修改键 client.poll.interval.seconds，并刷新参数缓存

INSERT INTO sys_config (config_name, config_key, config_value, config_type, create_by, create_time, remark)
SELECT '前端统一轮询间隔（秒）', 'client.poll.interval.seconds', '180', 'N', 'admin', NOW(),
       '发电预测页自动刷新、消息中心未读轮询等；30～3600；发电预测页可写本机 localStorage 覆盖'
WHERE NOT EXISTS (SELECT 1 FROM sys_config WHERE config_key = 'client.poll.interval.seconds');
