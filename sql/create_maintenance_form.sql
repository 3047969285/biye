-- 智能电网运维操作表单表
CREATE TABLE IF NOT EXISTS `ai_maintenance_form` (
  `form_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '表单ID',
  `device_id` bigint(20) DEFAULT NULL COMMENT '设备ID',
  `device_name` varchar(100) DEFAULT NULL COMMENT '设备名称',
  `fault_description` text COMMENT '故障描述',
  `maintenance_type` varchar(50) DEFAULT NULL COMMENT '维护类型（预防性/纠正性/预测性）',
  `priority_level` varchar(20) DEFAULT NULL COMMENT '优先级（高/中/低）',
  `estimated_time` int(11) DEFAULT NULL COMMENT '预计耗时（分钟）',
  `required_tools` text COMMENT '所需工具（JSON格式）',
  `safety_precautions` text COMMENT '安全注意事项',
  `step_by_step_guide` text COMMENT '操作步骤（JSON格式）',
  `expected_outcome` text COMMENT '预期结果',
  `form_status` varchar(20) DEFAULT 'draft' COMMENT '表单状态（draft/approved/completed/cancelled）',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建者',
  `created_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新者',
  `updated_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`form_id`),
  KEY `idx_device_id` (`device_id`),
  KEY `idx_form_status` (`form_status`),
  KEY `idx_created_time` (`created_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI生成的运维操作表单';

-- 插入示例数据
INSERT INTO `ai_maintenance_form` VALUES 
(1, 1001, '变压器T-101', '变压器温度异常，显示过热警告', '纠正性', '高', 120, 
'["红外测温仪", "绝缘电阻测试仪", "螺丝刀套装", "万用表", "安全手套"]',
'1. 断开变压器电源\n2. 确认无电后挂接地线\n3. 穿戴绝缘防护用品\n4. 保持安全距离\n5. 使用绝缘工具操作',
'[{"step": 1, "action": "断电操作", "detail": "按照操作规程断开变压器所有电源开关，验证无电"}, {"step": 2, "action": "温度检测", "detail": "使用红外测温仪测量变压器各部位温度，记录数据"}, {"step": 3, "action": "外观检查", "detail": "检查变压器外壳、散热器、油位指示器等，查找异常"}, {"step": 4, "action": "绝缘测试", "detail": "使用绝缘电阻测试仪测试绕组绝缘电阻"}, {"step": 5, "action": "清理维护", "detail": "清理变压器表面灰尘，检查散热风扇运行状态"}, {"step": 6, "action": "送电测试", "detail": "恢复供电，监测运行温度30分钟"}]',
'变压器温度恢复正常范围（≤85℃），无异常声音和气味，绝缘电阻合格',
'approved', 'admin', '2025-01-07 10:00:00', NULL, '2025-01-07 10:00:00', '紧急维护任务'),

(2, 1002, '开关柜K-205', '开关柜出现间歇性跳闸', '预测性', '中', 90,
'["接触电阻测试仪", "红外热像仪", "扭力扳手", "清洁剂", "防护用品"]',
'1. 提前通知用户停电计划\n2. 验证停电后进行操作\n3. 注意高压危险标识\n4. 双人作业制度\n5. 做好应急预案',
'[{"step": 1, "action": "停电验电", "detail": "按停电流程操作，使用验电器确认无电"}, {"step": 2, "action": "接触检查", "detail": "检查开关触头接触情况，测量接触电阻"}, {"step": 3, "action": "热成像扫描", "detail": "使用红外热像仪扫描开关柜内部，查找热点"}, {"step": 4, "action": "紧固螺栓", "detail": "使用扭力扳手按标准力矩紧固所有连接螺栓"}, {"step": 5, "action": "清洁除尘", "detail": "清洁开关柜内部，去除灰尘和异物"}, {"step": 6, "action": "调试测试", "detail": "送电后进行空载和负载测试"}]',
'开关柜运行稳定，无跳闸现象，接触电阻≤100μΩ，无异常发热点',
'draft', 'system', '2025-01-07 11:30:00', NULL, '2025-01-07 11:30:00', '定期预防性维护');
