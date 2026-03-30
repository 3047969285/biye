-- 站内消息：运维表单待处理（msg_type=maintenance_form，biz_id=form_id）、
-- 待维护设备提醒（msg_type=maintenance_device_pending，biz_id=device_id）。
-- 去重由服务端按 (user_id, msg_type, biz_id) 实现；详见 SysUserMessageServiceImpl。
-- 执行前请确认库名；若 ry-vue.sql 已含本表可跳过。
CREATE TABLE IF NOT EXISTS `sys_user_message` (
  `msg_id` bigint NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `user_id` bigint NOT NULL COMMENT '接收用户ID',
  `msg_type` varchar(32) NOT NULL DEFAULT 'maintenance_form' COMMENT '消息类型',
  `title` varchar(200) NOT NULL DEFAULT '' COMMENT '标题',
  `content` varchar(1000) NOT NULL DEFAULT '' COMMENT '摘要内容',
  `biz_id` bigint NULL DEFAULT NULL COMMENT '业务主键，如运维表单 form_id',
  `read_flag` char(1) NOT NULL DEFAULT '0' COMMENT '是否已读 0否 1是',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`msg_id`),
  KEY `idx_user_read` (`user_id`, `read_flag`),
  KEY `idx_user_time` (`user_id`, `create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户站内消息';
