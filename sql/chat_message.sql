-- 聊天消息表
CREATE TABLE `chat_message` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `user_id` bigint(20) NOT NULL COMMENT '发送用户ID',
  `user_name` varchar(50) NOT NULL COMMENT '发送用户昵称',
  `content` text NOT NULL COMMENT '消息内容',
  `message_type` varchar(20) NOT NULL DEFAULT 'chat' COMMENT '消息类型（chat:聊天消息，system:系统消息）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发送时间',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  PRIMARY KEY (`id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='聊天消息表';

