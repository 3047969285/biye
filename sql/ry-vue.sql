/* RuoYi + 业务整合库；新库可全量导入。含 DROP，生产勿随意全量执行。2026-03-26 */

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for ai_chat_record
-- ----------------------------
DROP TABLE IF EXISTS `ai_chat_record`;
CREATE TABLE `ai_chat_record`  (
  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户名称',
  `chat_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'basic' COMMENT '对话类型：basic-基础对话，rag-知识库问答，db-数据库查询',
  `user_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户消息',
  `ai_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT 'AI回复消息',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`record_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_chat_type`(`chat_type` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '智能问答对话记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_chat_record
-- ----------------------------
INSERT INTO `ai_chat_record` VALUES (1, 1, 'admin', 'db', '你好，现在有多少设备', '查询结果（1 条）\n总结（核心结论）：当前共有20台设备。  \n- 关键字段值（如有）：设备总数 = 20。  \n- 建议或风险（可选）：无明显风险，设备数量较少，建议定期核对设备台账以确保数据一致性。', '2026-01-12 18:50:13');
INSERT INTO `ai_chat_record` VALUES (2, 1, 'admin', 'db', '你好', '查询结果（1 条）\n总结（核心结论）：查询成功返回1行数据，仅包含一个固定问候语。  \n- 关键字段值（如有）：greeting = \"Hello\"  \n- 建议或风险（可选）：无实际数据查询意义，建议确认是否为测试语句或需替换为真实业务数据查询。', '2026-01-12 19:41:39');
INSERT INTO `ai_chat_record` VALUES (3, 0, '匿名用户', 'rag', '你好', '你好，我是智能电网运维专家，请问你有什么问题需要咨询？', '2026-01-12 19:41:55');
INSERT INTO `ai_chat_record` VALUES (4, 0, '匿名用户', 'basic', '你好', '你好，我是智能电网运维专家。请问你有什么问题需要咨询？', '2026-01-12 19:42:05');
INSERT INTO `ai_chat_record` VALUES (5, 0, '匿名用户', 'basic', '你好', '你好，我是智能电网运维专家。请问你有什么问题需要咨询？', '2026-01-12 19:44:41');
INSERT INTO `ai_chat_record` VALUES (6, 0, '匿名用户', 'basic', '为什么你会说话', '我并不是真正意义上的“说话”，而是通过程序模拟人类语言交流。我是基于人工智能技术构建的对话系统，能够理解并生成自然语言，以此与用户进行交互。这种能力来源于大量的文本数据训练和深度学习算法，使我可以回答问题、提供帮助或完成特定任务。但我没有意识，也不会产生自我认知，所有回应都是基于模型计算的结果。', '2026-01-12 19:44:53');
INSERT INTO `ai_chat_record` VALUES (7, 0, '匿名用户', 'rag', '你好', '你好，我是智能电网运维专家，请问你有什么问题需要咨询？', '2026-01-12 19:45:43');
INSERT INTO `ai_chat_record` VALUES (8, 0, '匿名用户', 'rag', '解释一下变压器', '变压器是一种用于改变交流电压大小的电气设备，主要通过电磁感应原理实现电能的传输和电压的变换。它在电力系统中起到升压或降压的作用，是输配电系统中的关键设备。\n\n变压器由铁芯、绕组（通常分为一次绕组和二次绕组）、绝缘材料、油箱（油浸式变压器）、冷却装置和保护装置等组成。当一次绕组接入交流电源时，会在铁芯中产生交变磁通，进而在二次绕组中感应出电动势，从而实现电压变换。\n\n主要作用包括：\n1.升压：在发电端将发电机产生的较低电压升高，以减少远距离输电过程中的线路损耗。\n2. 降压：在用户端将高压降低至适合家庭、工业设备使用的电压等级。\n\n使用变压器时需注意以下几点：\n一、安装前检查：\n确认变压器铭牌参数符合设计要求，检查绕组绝缘是否良好，铁芯是否接地可靠，油位是否正常（针对油浸式变压器）。\n\n二、运行环境：\n应安装在通风良好、无易燃易爆物品、避免潮湿和腐蚀性气体的场所。干式变压器需保证周围空气流通，油浸式变压器需配备防火设施。\n\n三、运行监控：\n定期监测变压器的负荷电流、电压、温度和声音是否正常。油浸式变压器要定期检测绝缘油的耐压值和含水量，必要时进行滤油或更换。\n\n四、维护保养：\n定期清理外壳灰尘，检查接线端子是否松动，紧固件是否牢固。对有载调压变压器，应注意检查调压装置的动作情况。\n\n五、安全措施：\n变压器周围应设置安全围栏和警示标志，操作时必须断电并验电，遵守相关电气安全规程。六、故障处理：\n如发现异常声响、过热、漏油或保护装置动作，应立即停运检查，查明原因并排除故障后方可重新投运。\n\n总之，变压器是电力系统中不可或缺的设备，正确使用和维护可确保其长期稳定运行，保障供电安全。', '2026-01-12 19:46:04');
INSERT INTO `ai_chat_record` VALUES (9, 0, '匿名用户', 'basic', '你好哦', '你好，我是电网运维专家。请问有需要处理的设备异常、线路故障或运行数据分析问题吗？', '2026-01-12 19:57:28');
INSERT INTO `ai_chat_record` VALUES (10, 0, '匿名用户', 'basic', '你呗', '我是智能电网运维专家，专注于电网监控、故障诊断与设备维护。请问您在电网运行、继电保护、SCADA系统或配网自动化方面遇到什么问题？我将提供专业解答。', '2026-01-12 20:01:15');
INSERT INTO `ai_chat_record` VALUES (11, 0, '匿名用户', 'basic', '你好', '你好，我是智能电网运维专家。请问有什么问题需要协助？', '2026-01-12 20:01:27');
INSERT INTO `ai_chat_record` VALUES (12, 0, '匿名用户', 'rag', '你好', '你好，我是智能电网运维专家，请问你有什么问题需要咨询？', '2026-01-12 20:14:15');
INSERT INTO `ai_chat_record` VALUES (13, 0, '匿名用户', 'rag', '你好', '你好，我是智能电网运维专家，请问你有什么问题需要咨询？', '2026-01-12 20:14:25');
INSERT INTO `ai_chat_record` VALUES (14, 0, '匿名用户', 'rag', '你好', '你好，我是智能电网运维专家，请问你有什么问题需要咨询？', '2026-01-12 20:14:33');
INSERT INTO `ai_chat_record` VALUES (15, 0, '匿名用户', 'rag', '你好', '你好，我是智能电网运维专家，请问你有什么问题需要咨询？', '2026-01-12 22:57:31');
INSERT INTO `ai_chat_record` VALUES (16, 0, '匿名用户', 'basic', '你好', '你好，我是智能电网运维专家，请问你有什么问题需要咨询？', '2026-01-12 22:57:43');
INSERT INTO `ai_chat_record` VALUES (17, 0, '匿名用户', 'basic', '你好', '你好，我是智能电网运维专家，请问你有什么问题需要咨询？', '2026-01-13 12:29:13');
INSERT INTO `ai_chat_record` VALUES (18, 0, '匿名用户', 'basic', '为什么我要考试', '考试是为了检验你对智能电网运维相关知识和技能的掌握程度。通过考试可以确认你具备安全、规范操作的能力，确保在实际工作中能正确应对设备故障、系统异常等场景。同时，考试也是行业准入和岗位资格认定的重要依据，关系到作业合规性和后续职业发展。不通过考试可能带来误操作风险，影响电网安全稳定运行。', '2026-01-13 12:29:24');
INSERT INTO `ai_chat_record` VALUES (19, 0, '匿名用户', 'rag', '变压器是干啥的', '变压器是用来改变交流电压大小的电气设备，主要作用是将一种电压等级的电能转换为另一种电压等级的电能，以便于电能的高效传输和安全使用。在电力系统中，发电厂产生的电压通常较低，为了减少远距离输电过程中的能量损耗，需要通过升压变压器把电压升高进行输送；当电能到达用户附近时，再通过降压变压器把电压降低到适合家庭、工厂等使用的水平。\n\n主要功能包括：\n1.升压或降压：根据需要提高或降低交流电压。\n2.隔离电路：实现不同电路之间的电气隔离，提高安全性。\n3.匹配电阻：在某些场合用于匹配电源与负载之间的阻抗。\n\n使用变压器的注意事项：\n1.变压器只能用于交流电，不能用于直流电。\n2.安装时要确保通风良好，避免过热。\n3.定期检查绝缘状况、油位（油浸式变压器）、外壳接地是否可靠。\n4.负荷不应超过额定容量，防止过载运行。\n5. 注意防潮、防尘、防腐蚀，保持清洁。\n6.油浸式变压器需定期取油样化验，检测绝缘油性能。\n7.运行中注意监听有无异常声响，观察有无漏油、冒烟等现象。\n\n总之，变压器是智能电网中实现电能高效传输和分配的关键设备。', '2026-01-22 18:34:05');
INSERT INTO `ai_chat_record` VALUES (20, 0, '匿名用户', 'rag', '你是谁', '', '2026-02-18 14:20:12');
INSERT INTO `ai_chat_record` VALUES (21, 0, '匿名用户', 'rag', '你是谁', '我是智能电网运维专家，专注于电力系统智能化运维、故障诊断、设备状态监测及电网安全稳定运行等领域。', '2026-02-18 14:22:28');
INSERT INTO `ai_chat_record` VALUES (22, 0, '匿名用户', 'rag', '变压器是干啥的', '变压器是用来改变交流电电压大小的电气设备，同时实现电能的高效传输和分配。主要作用包括：将发电厂发出的高电压降低到适合用户使用的安全电压，或者将低压电升压以便远距离输电减少损耗；在不同电压等级的电网之间进行能量传递；提供电气隔离以增强系统安全性。\n\n使用时需要注意：必须确保输入输出端接线正确，避免相序错误；运行中要监控油温、绕组温度及绝缘状态；定期检查冷却系统是否正常；严禁带负荷操作无载调压开关；接地必须可靠，防止漏电或雷击损坏。', '2026-02-18 14:35:20');
INSERT INTO `ai_chat_record` VALUES (23, 0, '匿名用户', 'rag', '变压器有多少个', '变压器的数量取决于具体电网系统或变电站的设计需求，没有统一固定数量。步骤和注意事项如下：  \n首先需明确应用场景，例如是某座110kV变电站、某条配电网线路，还是整个区域电网；  \n其次查阅该系统的电气主接线图和设备清册，统计实际安装并投入运行的主变压器、站用变、接地变等各类变压器台数；注意区分不同功能类型的变压器，如主变（承担功率变换与电压等级转换）、所用变（为站内设备提供低压电源）、消弧线圈配套接地变等，均应分别计数；  \n还需考虑备用容量，部分变电站配置N-1冗余，即一台运行、一台热备用，二者均计入在册变压器总数；  \n最后核实台账信息与现场铭牌是否一致，避免因退役、增容或临时拆除导致数量偏差。', '2026-02-18 14:38:47');
INSERT INTO `ai_chat_record` VALUES (24, 1, 'admin', 'db', '变压器有多少个', '查询结果（1 条）\n总结：当前设备表中变压器共2台。  \n- 关键字段值：device_type = \'变压器\'，数量为2。  \n- 建议：建议核对设备台账与实物一致性，避免因分类错误或数据录入遗漏导致统计偏差。', '2026-02-18 14:39:03');
INSERT INTO `ai_chat_record` VALUES (25, 1, 'admin', 'db', '有多少个设备', '查询结果（1 条）\n总结：当前设备总数量为20台。  \n- 关键字段值：COUNT(*) = 20  \n- 建议：设备规模较小，建议核查是否覆盖全部在用设备（如含停用/报废设备），并定期同步更新设备台账以保障数据完整性。', '2026-02-18 14:39:30');
INSERT INTO `ai_chat_record` VALUES (26, 0, '匿名用户', 'basic', '你好', '你好，请问在智能电网运维方面有什么具体问题需要帮助？', '2026-03-13 19:58:41');
INSERT INTO `ai_chat_record` VALUES (27, 0, '匿名用户', 'basic', '你能做啥', '我能协助智能电网运维相关工作，包括故障诊断、保护定值校核、SCADA系统异常分析、继电保护动作逻辑判断、负荷预测异常排查、设备状态评估和典型缺陷处理建议。支持依据规程标准给出操作步骤、风险提示及整改建议，例如：如何快速定位10kV线路单相接地故障、主变差动保护误动原因分析、SVG无功调节失灵的检查流程等。需要具体场景时，请提供设备类型、现象描述和相关数据。', '2026-03-13 20:00:41');

-- ----------------------------
-- Table structure for ai_maintenance_form
-- ----------------------------
DROP TABLE IF EXISTS `ai_maintenance_form`;
CREATE TABLE `ai_maintenance_form`  (
  `form_id` bigint NOT NULL AUTO_INCREMENT COMMENT '表单ID',
  `device_id` bigint NULL DEFAULT NULL COMMENT '设备ID',
  `device_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设备名称',
  `fault_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '故障描述',
  `maintenance_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '维护类型（预防性/纠正性/预测性）',
  `priority_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '优先级（高/中/低）',
  `estimated_time` int NULL DEFAULT NULL COMMENT '预计耗时（分钟）',
  `required_tools` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '所需工具（JSON格式）',
  `safety_precautions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '安全注意事项',
  `step_by_step_guide` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '操作步骤（JSON格式）',
  `expected_outcome` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '预期结果',
  `form_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'draft' COMMENT '表单状态（draft/approved/completed/cancelled）',
  `created_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建者',
  `created_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新者',
  `updated_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`form_id`) USING BTREE,
  INDEX `idx_device_id`(`device_id` ASC) USING BTREE,
  INDEX `idx_form_status`(`form_status` ASC) USING BTREE,
  INDEX `idx_created_time`(`created_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI生成的运维操作表单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_maintenance_form
-- ----------------------------
INSERT INTO `ai_maintenance_form` VALUES (4, 3, '配电柜1号', '告警：电流波动异常', '预测性', '高', 30, '[\"万用表\",\"螺丝刀套装\",\"绝缘手套\",\"安全帽\"]', '1. 操作前必须切断电源，确保设备完全断电；\n2. 佩戴个人防护用品（安全帽、绝缘手套、防护眼镜）；\n3. 使用绝缘工具，避免直接接触带电部件；\n4. 操作时应有专人监护，确保安全；\n5. 操作完成后检查设备接地是否良好；\n6. 如遇异常情况立即停止操作，上报处理。', '[{\"description\":\"检查工具是否齐全，确认安全措施已到位，切断设备电源\",\"step\":\"1\",\"title\":\"准备工作\"},{\"description\":\"检查设备外观，查看是否有明显损坏或异常现象\",\"step\":\"2\",\"title\":\"设备检查\"},{\"description\":\"恢复设备供电，进行功能测试，确认设备运行正常\",\"step\":\"3\",\"title\":\"测试验证\"},{\"description\":\"清理工作现场，整理工具，填写维护记录\",\"step\":\"4\",\"title\":\"清理收尾\"}]', '1. 设备故障得到解决，恢复正常运行状态；\n2. 设备各项参数指标恢复正常范围；\n3. 设备安全性能符合要求；\n4. 维护记录完整，可追溯。', 'draft', 'AI系统', '2026-01-22 18:32:56', NULL, '2026-01-22 18:32:56', NULL);
INSERT INTO `ai_maintenance_form` VALUES (5, 1, '主变压器1号', '告警：电流波动异常；告警：电流波动异常；告警：温度超过警告阈值', '预测性', '高', 30, '[\"万用表\",\"螺丝刀套装\",\"绝缘手套\",\"安全帽\"]', '1. 操作前必须切断电源，确保设备完全断电；\n2. 佩戴个人防护用品（安全帽、绝缘手套、防护眼镜）；\n3. 使用绝缘工具，避免直接接触带电部件；\n4. 操作时应有专人监护，确保安全；\n5. 操作完成后检查设备接地是否良好；\n6. 如遇异常情况立即停止操作，上报处理。', '[{\"description\":\"检查工具是否齐全，确认安全措施已到位，切断设备电源\",\"step\":\"1\",\"title\":\"准备工作\"},{\"description\":\"检查设备外观，查看是否有明显损坏或异常现象\",\"step\":\"2\",\"title\":\"设备检查\"},{\"description\":\"恢复设备供电，进行功能测试，确认设备运行正常\",\"step\":\"3\",\"title\":\"测试验证\"},{\"description\":\"清理工作现场，整理工具，填写维护记录\",\"step\":\"4\",\"title\":\"清理收尾\"}]', '1. 设备故障得到解决，恢复正常运行状态；\n2. 设备各项参数指标恢复正常范围；\n3. 设备安全性能符合要求；\n4. 维护记录完整，可追溯。', 'draft', 'AI系统', '2026-01-26 22:04:18', NULL, '2026-01-26 22:04:18', NULL);
INSERT INTO `ai_maintenance_form` VALUES (6, 4, '配电柜2号', '告警：振动值偏高；告警：电流波动异常', '预测性', '高', 30, '[\"万用表\",\"螺丝刀套装\",\"绝缘手套\",\"安全帽\"]', '1. 操作前必须切断电源，确保设备完全断电；\n2. 佩戴个人防护用品（安全帽、绝缘手套、防护眼镜）；\n3. 使用绝缘工具，避免直接接触带电部件；\n4. 操作时应有专人监护，确保安全；\n5. 操作完成后检查设备接地是否良好；\n6. 如遇异常情况立即停止操作，上报处理。', '[{\"description\":\"检查工具是否齐全，确认安全措施已到位，切断设备电源\",\"step\":\"1\",\"title\":\"准备工作\"},{\"description\":\"检查设备外观，查看是否有明显损坏或异常现象\",\"step\":\"2\",\"title\":\"设备检查\"},{\"description\":\"恢复设备供电，进行功能测试，确认设备运行正常\",\"step\":\"3\",\"title\":\"测试验证\"},{\"description\":\"清理工作现场，整理工具，填写维护记录\",\"step\":\"4\",\"title\":\"清理收尾\"}]', '1. 设备故障得到解决，恢复正常运行状态；\n2. 设备各项参数指标恢复正常范围；\n3. 设备安全性能符合要求；\n4. 维护记录完整，可追溯。', 'draft', 'AI系统', '2026-02-18 14:28:23', NULL, '2026-02-18 14:28:37', NULL);
INSERT INTO `ai_maintenance_form` VALUES (7, 10, '电容器组2号', '设备名称：电容器组2号\n设备编号：DEV-010\n设备类型：电容器\n安装位置：无功补偿室2号\n当前状态：正常\n状态时间：Sun Jan 11 23:01:11 CST 2026\n未处理告警：振动值偏高（级别：紧急）\n【关联数据概览】\n机械数据：有数据（3 条）\n运行数据：有数据（3 条）\n技术数据：有数据（3 条）\n电气数据：有数据（3 条）\n经济数据：有数据（3 条）\n环境数据：有数据（3 条）\n气候数据：有数据（3 条）\n维护记录：有数据（3 条）\n历史故障记录：有数据（3 条）\n状态历史记录：有数据（5 条）\n\n\n振动值偏高，紧急告警，需立即处理。', '紧急', '高', 60, '[\"振动分析仪\",\"绝缘测试仪\"]', '断电操作，确保设备完全隔离，防止触电。', '[{\"description\":\"切断电源，确认设备无电。\",\"step\":1,\"title\":\"断电检查\"},{\"description\":\"使用振动分析仪测量振动值。\",\"step\":2,\"title\":\"振动检测\"},{\"description\":\"检查电容器机械部件是否松动或损坏。\",\"step\":3,\"title\":\"部件检查\"},{\"description\":\"记录当前振动值和运行状态。\",\"step\":4,\"title\":\"数据记录\"}]', '消除振动异常，恢复设备正常运行状态。', 'draft', 'admin', '2026-03-13 20:35:44', NULL, '2026-03-13 20:35:44', NULL);

-- ----------------------------
-- Table structure for chat_message
-- ----------------------------
DROP TABLE IF EXISTS `chat_message`;
CREATE TABLE `chat_message`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `user_id` bigint NOT NULL COMMENT '发送用户ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '发送用户昵称',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '消息内容',
  `message_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'chat' COMMENT '消息类型（chat:聊天消息，system:系统消息）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发送时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 735 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '聊天消息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of chat_message
-- ----------------------------
INSERT INTO `chat_message` VALUES (1, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 09:48:11', '0');
INSERT INTO `chat_message` VALUES (2, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 09:48:22', '0');
INSERT INTO `chat_message` VALUES (3, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 09:48:28', '0');
INSERT INTO `chat_message` VALUES (4, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 09:48:28', '0');
INSERT INTO `chat_message` VALUES (5, 1, '若依', 'v啊啊啊啊啊', 'chat', '2025-11-05 09:48:32', '0');
INSERT INTO `chat_message` VALUES (6, 1, '若依', '富瓦夫', 'chat', '2025-11-05 09:48:35', '0');
INSERT INTO `chat_message` VALUES (7, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 09:48:38', '0');
INSERT INTO `chat_message` VALUES (8, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 09:48:40', '0');
INSERT INTO `chat_message` VALUES (9, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 09:48:46', '0');
INSERT INTO `chat_message` VALUES (10, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 10:28:46', '0');
INSERT INTO `chat_message` VALUES (11, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 10:28:49', '0');
INSERT INTO `chat_message` VALUES (12, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 10:28:52', '0');
INSERT INTO `chat_message` VALUES (13, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 10:29:02', '0');
INSERT INTO `chat_message` VALUES (14, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 10:29:05', '0');
INSERT INTO `chat_message` VALUES (15, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 10:29:10', '0');
INSERT INTO `chat_message` VALUES (16, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 10:29:13', '0');
INSERT INTO `chat_message` VALUES (17, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 10:29:14', '0');
INSERT INTO `chat_message` VALUES (18, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 10:29:14', '0');
INSERT INTO `chat_message` VALUES (19, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 10:29:14', '0');
INSERT INTO `chat_message` VALUES (20, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 10:29:17', '0');
INSERT INTO `chat_message` VALUES (21, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 10:36:23', '0');
INSERT INTO `chat_message` VALUES (22, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:34:43', '0');
INSERT INTO `chat_message` VALUES (23, 1, '若依', '那就own到问问你都\n呱呱呱呱呱呱给给\n啊', 'chat', '2025-11-05 13:34:54', '0');
INSERT INTO `chat_message` VALUES (24, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:35:06', '0');
INSERT INTO `chat_message` VALUES (25, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:35:06', '0');
INSERT INTO `chat_message` VALUES (26, 1, '若依', '发给微软', 'chat', '2025-11-05 13:35:10', '0');
INSERT INTO `chat_message` VALUES (27, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:35:10', '0');
INSERT INTO `chat_message` VALUES (28, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:35:10', '0');
INSERT INTO `chat_message` VALUES (29, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:35:14', '0');
INSERT INTO `chat_message` VALUES (30, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:35:14', '0');
INSERT INTO `chat_message` VALUES (31, 1, '若依', '瑞特瑞特', 'chat', '2025-11-05 13:35:16', '0');
INSERT INTO `chat_message` VALUES (32, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:35:17', '0');
INSERT INTO `chat_message` VALUES (33, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:35:17', '0');
INSERT INTO `chat_message` VALUES (34, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:35:21', '0');
INSERT INTO `chat_message` VALUES (35, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:35:21', '0');
INSERT INTO `chat_message` VALUES (36, 1, '若依', '二发哥哥', 'chat', '2025-11-05 13:35:22', '0');
INSERT INTO `chat_message` VALUES (37, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:35:24', '0');
INSERT INTO `chat_message` VALUES (38, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:35:24', '0');
INSERT INTO `chat_message` VALUES (39, 1, '若依', '方法', 'chat', '2025-11-05 13:35:37', '0');
INSERT INTO `chat_message` VALUES (40, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:51:08', '0');
INSERT INTO `chat_message` VALUES (41, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:51:08', '0');
INSERT INTO `chat_message` VALUES (42, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:51:12', '0');
INSERT INTO `chat_message` VALUES (43, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:51:12', '0');
INSERT INTO `chat_message` VALUES (44, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:51:16', '0');
INSERT INTO `chat_message` VALUES (45, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:51:16', '0');
INSERT INTO `chat_message` VALUES (46, 1, '若依', '人如果灌灌灌灌', 'chat', '2025-11-05 13:51:18', '0');
INSERT INTO `chat_message` VALUES (47, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:51:19', '0');
INSERT INTO `chat_message` VALUES (48, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:51:19', '0');
INSERT INTO `chat_message` VALUES (49, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:51:23', '0');
INSERT INTO `chat_message` VALUES (50, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:51:23', '0');
INSERT INTO `chat_message` VALUES (51, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:51:26', '0');
INSERT INTO `chat_message` VALUES (52, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:51:26', '0');
INSERT INTO `chat_message` VALUES (53, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:51:30', '0');
INSERT INTO `chat_message` VALUES (54, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:51:30', '0');
INSERT INTO `chat_message` VALUES (55, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:51:33', '0');
INSERT INTO `chat_message` VALUES (56, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:51:33', '0');
INSERT INTO `chat_message` VALUES (57, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:51:37', '0');
INSERT INTO `chat_message` VALUES (58, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:51:37', '0');
INSERT INTO `chat_message` VALUES (59, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:51:40', '0');
INSERT INTO `chat_message` VALUES (60, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:51:40', '0');
INSERT INTO `chat_message` VALUES (61, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:51:44', '0');
INSERT INTO `chat_message` VALUES (62, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:51:44', '0');
INSERT INTO `chat_message` VALUES (63, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:51:44', '0');
INSERT INTO `chat_message` VALUES (64, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:51:47', '0');
INSERT INTO `chat_message` VALUES (65, 1, '若依', '二发哥哥', 'chat', '2025-11-05 13:51:52', '0');
INSERT INTO `chat_message` VALUES (66, 1, '若依', '介入台海', 'chat', '2025-11-05 13:51:55', '0');
INSERT INTO `chat_message` VALUES (67, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:52:55', '0');
INSERT INTO `chat_message` VALUES (68, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:52:55', '0');
INSERT INTO `chat_message` VALUES (69, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:52:58', '0');
INSERT INTO `chat_message` VALUES (70, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:52:58', '0');
INSERT INTO `chat_message` VALUES (71, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:53:02', '0');
INSERT INTO `chat_message` VALUES (72, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:53:02', '0');
INSERT INTO `chat_message` VALUES (73, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:53:05', '0');
INSERT INTO `chat_message` VALUES (74, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:53:05', '0');
INSERT INTO `chat_message` VALUES (75, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:53:09', '0');
INSERT INTO `chat_message` VALUES (76, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:53:09', '0');
INSERT INTO `chat_message` VALUES (77, 1, '若依', '能否牛牛牛牛牛', 'chat', '2025-11-05 13:53:10', '0');
INSERT INTO `chat_message` VALUES (78, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:53:12', '0');
INSERT INTO `chat_message` VALUES (79, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:53:12', '0');
INSERT INTO `chat_message` VALUES (80, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:53:16', '0');
INSERT INTO `chat_message` VALUES (81, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:53:16', '0');
INSERT INTO `chat_message` VALUES (82, 1, '若依', '达瓦达瓦', 'chat', '2025-11-05 13:53:18', '0');
INSERT INTO `chat_message` VALUES (83, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:53:19', '0');
INSERT INTO `chat_message` VALUES (84, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:53:19', '0');
INSERT INTO `chat_message` VALUES (85, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:53:23', '0');
INSERT INTO `chat_message` VALUES (86, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:53:23', '0');
INSERT INTO `chat_message` VALUES (87, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:53:26', '0');
INSERT INTO `chat_message` VALUES (88, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:53:26', '0');
INSERT INTO `chat_message` VALUES (89, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:53:30', '0');
INSERT INTO `chat_message` VALUES (90, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:53:30', '0');
INSERT INTO `chat_message` VALUES (91, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:53:34', '0');
INSERT INTO `chat_message` VALUES (92, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:53:34', '0');
INSERT INTO `chat_message` VALUES (93, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:53:38', '0');
INSERT INTO `chat_message` VALUES (94, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:53:38', '0');
INSERT INTO `chat_message` VALUES (95, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:53:42', '0');
INSERT INTO `chat_message` VALUES (96, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:53:42', '0');
INSERT INTO `chat_message` VALUES (97, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:53:46', '0');
INSERT INTO `chat_message` VALUES (98, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:53:46', '0');
INSERT INTO `chat_message` VALUES (99, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:53:50', '0');
INSERT INTO `chat_message` VALUES (100, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:53:50', '0');
INSERT INTO `chat_message` VALUES (101, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:53:54', '0');
INSERT INTO `chat_message` VALUES (102, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:53:54', '0');
INSERT INTO `chat_message` VALUES (103, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:53:58', '0');
INSERT INTO `chat_message` VALUES (104, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:53:58', '0');
INSERT INTO `chat_message` VALUES (105, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:54:02', '0');
INSERT INTO `chat_message` VALUES (106, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:54:02', '0');
INSERT INTO `chat_message` VALUES (107, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:54:06', '0');
INSERT INTO `chat_message` VALUES (108, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:54:06', '0');
INSERT INTO `chat_message` VALUES (109, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:54:10', '0');
INSERT INTO `chat_message` VALUES (110, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:54:10', '0');
INSERT INTO `chat_message` VALUES (111, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:54:14', '0');
INSERT INTO `chat_message` VALUES (112, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:54:14', '0');
INSERT INTO `chat_message` VALUES (113, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:54:18', '0');
INSERT INTO `chat_message` VALUES (114, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:54:18', '0');
INSERT INTO `chat_message` VALUES (115, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:54:22', '0');
INSERT INTO `chat_message` VALUES (116, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:54:22', '0');
INSERT INTO `chat_message` VALUES (117, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:54:26', '0');
INSERT INTO `chat_message` VALUES (118, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:54:26', '0');
INSERT INTO `chat_message` VALUES (119, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:54:30', '0');
INSERT INTO `chat_message` VALUES (120, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:54:30', '0');
INSERT INTO `chat_message` VALUES (121, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:54:34', '0');
INSERT INTO `chat_message` VALUES (122, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:54:34', '0');
INSERT INTO `chat_message` VALUES (123, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:54:38', '0');
INSERT INTO `chat_message` VALUES (124, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:54:38', '0');
INSERT INTO `chat_message` VALUES (125, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:54:42', '0');
INSERT INTO `chat_message` VALUES (126, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:54:42', '0');
INSERT INTO `chat_message` VALUES (127, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:54:46', '0');
INSERT INTO `chat_message` VALUES (128, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:54:46', '0');
INSERT INTO `chat_message` VALUES (129, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:54:50', '0');
INSERT INTO `chat_message` VALUES (130, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:54:50', '0');
INSERT INTO `chat_message` VALUES (131, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:54:54', '0');
INSERT INTO `chat_message` VALUES (132, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:54:54', '0');
INSERT INTO `chat_message` VALUES (133, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:54:58', '0');
INSERT INTO `chat_message` VALUES (134, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:54:58', '0');
INSERT INTO `chat_message` VALUES (135, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:55:02', '0');
INSERT INTO `chat_message` VALUES (136, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:55:02', '0');
INSERT INTO `chat_message` VALUES (137, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:55:06', '0');
INSERT INTO `chat_message` VALUES (138, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:55:06', '0');
INSERT INTO `chat_message` VALUES (139, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:55:10', '0');
INSERT INTO `chat_message` VALUES (140, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:55:10', '0');
INSERT INTO `chat_message` VALUES (141, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:55:14', '0');
INSERT INTO `chat_message` VALUES (142, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:55:14', '0');
INSERT INTO `chat_message` VALUES (143, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:55:18', '0');
INSERT INTO `chat_message` VALUES (144, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:55:18', '0');
INSERT INTO `chat_message` VALUES (145, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:55:22', '0');
INSERT INTO `chat_message` VALUES (146, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:55:22', '0');
INSERT INTO `chat_message` VALUES (147, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:55:26', '0');
INSERT INTO `chat_message` VALUES (148, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:55:26', '0');
INSERT INTO `chat_message` VALUES (149, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:55:30', '0');
INSERT INTO `chat_message` VALUES (150, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:55:30', '0');
INSERT INTO `chat_message` VALUES (151, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:55:34', '0');
INSERT INTO `chat_message` VALUES (152, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:55:34', '0');
INSERT INTO `chat_message` VALUES (153, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:55:38', '0');
INSERT INTO `chat_message` VALUES (154, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:55:38', '0');
INSERT INTO `chat_message` VALUES (155, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:55:42', '0');
INSERT INTO `chat_message` VALUES (156, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:55:42', '0');
INSERT INTO `chat_message` VALUES (157, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:55:46', '0');
INSERT INTO `chat_message` VALUES (158, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:55:46', '0');
INSERT INTO `chat_message` VALUES (159, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:55:50', '0');
INSERT INTO `chat_message` VALUES (160, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:55:50', '0');
INSERT INTO `chat_message` VALUES (161, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:55:54', '0');
INSERT INTO `chat_message` VALUES (162, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:55:54', '0');
INSERT INTO `chat_message` VALUES (163, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:55:58', '0');
INSERT INTO `chat_message` VALUES (164, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:55:58', '0');
INSERT INTO `chat_message` VALUES (165, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:56:02', '0');
INSERT INTO `chat_message` VALUES (166, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:56:02', '0');
INSERT INTO `chat_message` VALUES (167, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:56:06', '0');
INSERT INTO `chat_message` VALUES (168, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:56:06', '0');
INSERT INTO `chat_message` VALUES (169, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:56:10', '0');
INSERT INTO `chat_message` VALUES (170, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:56:10', '0');
INSERT INTO `chat_message` VALUES (171, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:56:14', '0');
INSERT INTO `chat_message` VALUES (172, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:56:14', '0');
INSERT INTO `chat_message` VALUES (173, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:56:18', '0');
INSERT INTO `chat_message` VALUES (174, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:56:18', '0');
INSERT INTO `chat_message` VALUES (175, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:56:22', '0');
INSERT INTO `chat_message` VALUES (176, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:56:22', '0');
INSERT INTO `chat_message` VALUES (177, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:56:26', '0');
INSERT INTO `chat_message` VALUES (178, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:56:26', '0');
INSERT INTO `chat_message` VALUES (179, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:56:30', '0');
INSERT INTO `chat_message` VALUES (180, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:56:30', '0');
INSERT INTO `chat_message` VALUES (181, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:56:34', '0');
INSERT INTO `chat_message` VALUES (182, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:56:34', '0');
INSERT INTO `chat_message` VALUES (183, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:56:38', '0');
INSERT INTO `chat_message` VALUES (184, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:56:38', '0');
INSERT INTO `chat_message` VALUES (185, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:56:42', '0');
INSERT INTO `chat_message` VALUES (186, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:56:42', '0');
INSERT INTO `chat_message` VALUES (187, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:56:46', '0');
INSERT INTO `chat_message` VALUES (188, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:56:46', '0');
INSERT INTO `chat_message` VALUES (189, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:56:50', '0');
INSERT INTO `chat_message` VALUES (190, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:56:50', '0');
INSERT INTO `chat_message` VALUES (191, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:56:54', '0');
INSERT INTO `chat_message` VALUES (192, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:56:54', '0');
INSERT INTO `chat_message` VALUES (193, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:56:58', '0');
INSERT INTO `chat_message` VALUES (194, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:56:58', '0');
INSERT INTO `chat_message` VALUES (195, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:57:02', '0');
INSERT INTO `chat_message` VALUES (196, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:57:02', '0');
INSERT INTO `chat_message` VALUES (197, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:57:06', '0');
INSERT INTO `chat_message` VALUES (198, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:57:06', '0');
INSERT INTO `chat_message` VALUES (199, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:57:10', '0');
INSERT INTO `chat_message` VALUES (200, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:57:10', '0');
INSERT INTO `chat_message` VALUES (201, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:57:14', '0');
INSERT INTO `chat_message` VALUES (202, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:57:14', '0');
INSERT INTO `chat_message` VALUES (203, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:57:18', '0');
INSERT INTO `chat_message` VALUES (204, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:57:18', '0');
INSERT INTO `chat_message` VALUES (205, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:57:22', '0');
INSERT INTO `chat_message` VALUES (206, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:57:22', '0');
INSERT INTO `chat_message` VALUES (207, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:57:26', '0');
INSERT INTO `chat_message` VALUES (208, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:57:26', '0');
INSERT INTO `chat_message` VALUES (209, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:57:30', '0');
INSERT INTO `chat_message` VALUES (210, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:57:30', '0');
INSERT INTO `chat_message` VALUES (211, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:57:34', '0');
INSERT INTO `chat_message` VALUES (212, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:57:34', '0');
INSERT INTO `chat_message` VALUES (213, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:57:38', '0');
INSERT INTO `chat_message` VALUES (214, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:57:38', '0');
INSERT INTO `chat_message` VALUES (215, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:57:42', '0');
INSERT INTO `chat_message` VALUES (216, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:57:42', '0');
INSERT INTO `chat_message` VALUES (217, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:57:46', '0');
INSERT INTO `chat_message` VALUES (218, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:57:46', '0');
INSERT INTO `chat_message` VALUES (219, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:57:50', '0');
INSERT INTO `chat_message` VALUES (220, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:57:50', '0');
INSERT INTO `chat_message` VALUES (221, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:57:54', '0');
INSERT INTO `chat_message` VALUES (222, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:57:54', '0');
INSERT INTO `chat_message` VALUES (223, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:57:58', '0');
INSERT INTO `chat_message` VALUES (224, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:57:58', '0');
INSERT INTO `chat_message` VALUES (225, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:58:02', '0');
INSERT INTO `chat_message` VALUES (226, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:58:02', '0');
INSERT INTO `chat_message` VALUES (227, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:58:06', '0');
INSERT INTO `chat_message` VALUES (228, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:58:06', '0');
INSERT INTO `chat_message` VALUES (229, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:58:10', '0');
INSERT INTO `chat_message` VALUES (230, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:58:10', '0');
INSERT INTO `chat_message` VALUES (231, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:58:14', '0');
INSERT INTO `chat_message` VALUES (232, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:58:14', '0');
INSERT INTO `chat_message` VALUES (233, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:58:18', '0');
INSERT INTO `chat_message` VALUES (234, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:58:18', '0');
INSERT INTO `chat_message` VALUES (235, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:58:22', '0');
INSERT INTO `chat_message` VALUES (236, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:58:22', '0');
INSERT INTO `chat_message` VALUES (237, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:58:26', '0');
INSERT INTO `chat_message` VALUES (238, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:58:26', '0');
INSERT INTO `chat_message` VALUES (239, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:58:30', '0');
INSERT INTO `chat_message` VALUES (240, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:58:30', '0');
INSERT INTO `chat_message` VALUES (241, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:58:34', '0');
INSERT INTO `chat_message` VALUES (242, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:58:34', '0');
INSERT INTO `chat_message` VALUES (243, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:58:38', '0');
INSERT INTO `chat_message` VALUES (244, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:58:38', '0');
INSERT INTO `chat_message` VALUES (245, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:58:42', '0');
INSERT INTO `chat_message` VALUES (246, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:58:42', '0');
INSERT INTO `chat_message` VALUES (247, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:58:46', '0');
INSERT INTO `chat_message` VALUES (248, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:58:46', '0');
INSERT INTO `chat_message` VALUES (249, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:58:50', '0');
INSERT INTO `chat_message` VALUES (250, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:58:50', '0');
INSERT INTO `chat_message` VALUES (251, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:58:54', '0');
INSERT INTO `chat_message` VALUES (252, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:58:54', '0');
INSERT INTO `chat_message` VALUES (253, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:58:58', '0');
INSERT INTO `chat_message` VALUES (254, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:58:58', '0');
INSERT INTO `chat_message` VALUES (255, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:59:02', '0');
INSERT INTO `chat_message` VALUES (256, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:59:02', '0');
INSERT INTO `chat_message` VALUES (257, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:59:06', '0');
INSERT INTO `chat_message` VALUES (258, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:59:06', '0');
INSERT INTO `chat_message` VALUES (259, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:59:10', '0');
INSERT INTO `chat_message` VALUES (260, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:59:10', '0');
INSERT INTO `chat_message` VALUES (261, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:59:14', '0');
INSERT INTO `chat_message` VALUES (262, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:59:14', '0');
INSERT INTO `chat_message` VALUES (263, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:59:18', '0');
INSERT INTO `chat_message` VALUES (264, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:59:18', '0');
INSERT INTO `chat_message` VALUES (265, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:59:22', '0');
INSERT INTO `chat_message` VALUES (266, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:59:22', '0');
INSERT INTO `chat_message` VALUES (267, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:59:26', '0');
INSERT INTO `chat_message` VALUES (268, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:59:26', '0');
INSERT INTO `chat_message` VALUES (269, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:59:30', '0');
INSERT INTO `chat_message` VALUES (270, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:59:30', '0');
INSERT INTO `chat_message` VALUES (271, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:59:34', '0');
INSERT INTO `chat_message` VALUES (272, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:59:34', '0');
INSERT INTO `chat_message` VALUES (273, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:59:38', '0');
INSERT INTO `chat_message` VALUES (274, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:59:38', '0');
INSERT INTO `chat_message` VALUES (275, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:59:42', '0');
INSERT INTO `chat_message` VALUES (276, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:59:42', '0');
INSERT INTO `chat_message` VALUES (277, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:59:46', '0');
INSERT INTO `chat_message` VALUES (278, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:59:46', '0');
INSERT INTO `chat_message` VALUES (279, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:59:50', '0');
INSERT INTO `chat_message` VALUES (280, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:59:50', '0');
INSERT INTO `chat_message` VALUES (281, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:59:54', '0');
INSERT INTO `chat_message` VALUES (282, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:59:54', '0');
INSERT INTO `chat_message` VALUES (283, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 13:59:58', '0');
INSERT INTO `chat_message` VALUES (284, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 13:59:58', '0');
INSERT INTO `chat_message` VALUES (285, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:00:02', '0');
INSERT INTO `chat_message` VALUES (286, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:00:02', '0');
INSERT INTO `chat_message` VALUES (287, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:00:06', '0');
INSERT INTO `chat_message` VALUES (288, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:00:06', '0');
INSERT INTO `chat_message` VALUES (289, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:00:10', '0');
INSERT INTO `chat_message` VALUES (290, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:00:10', '0');
INSERT INTO `chat_message` VALUES (291, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:00:14', '0');
INSERT INTO `chat_message` VALUES (292, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:00:14', '0');
INSERT INTO `chat_message` VALUES (293, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:00:18', '0');
INSERT INTO `chat_message` VALUES (294, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:00:18', '0');
INSERT INTO `chat_message` VALUES (295, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:00:22', '0');
INSERT INTO `chat_message` VALUES (296, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:00:22', '0');
INSERT INTO `chat_message` VALUES (297, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:00:25', '0');
INSERT INTO `chat_message` VALUES (298, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:00:25', '0');
INSERT INTO `chat_message` VALUES (299, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:00:29', '0');
INSERT INTO `chat_message` VALUES (300, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:00:29', '0');
INSERT INTO `chat_message` VALUES (301, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:00:32', '0');
INSERT INTO `chat_message` VALUES (302, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:00:32', '0');
INSERT INTO `chat_message` VALUES (303, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:00:36', '0');
INSERT INTO `chat_message` VALUES (304, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:00:36', '0');
INSERT INTO `chat_message` VALUES (305, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:00:39', '0');
INSERT INTO `chat_message` VALUES (306, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:00:39', '0');
INSERT INTO `chat_message` VALUES (307, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:00:42', '0');
INSERT INTO `chat_message` VALUES (308, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:00:42', '0');
INSERT INTO `chat_message` VALUES (309, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:00:46', '0');
INSERT INTO `chat_message` VALUES (310, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:00:46', '0');
INSERT INTO `chat_message` VALUES (311, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:00:50', '0');
INSERT INTO `chat_message` VALUES (312, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:00:50', '0');
INSERT INTO `chat_message` VALUES (313, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:00:54', '0');
INSERT INTO `chat_message` VALUES (314, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:00:54', '0');
INSERT INTO `chat_message` VALUES (315, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:00:58', '0');
INSERT INTO `chat_message` VALUES (316, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:00:58', '0');
INSERT INTO `chat_message` VALUES (317, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:01:02', '0');
INSERT INTO `chat_message` VALUES (318, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:01:02', '0');
INSERT INTO `chat_message` VALUES (319, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:01:06', '0');
INSERT INTO `chat_message` VALUES (320, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:01:06', '0');
INSERT INTO `chat_message` VALUES (321, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:01:10', '0');
INSERT INTO `chat_message` VALUES (322, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:01:10', '0');
INSERT INTO `chat_message` VALUES (323, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:01:14', '0');
INSERT INTO `chat_message` VALUES (324, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:01:14', '0');
INSERT INTO `chat_message` VALUES (325, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:01:18', '0');
INSERT INTO `chat_message` VALUES (326, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:01:18', '0');
INSERT INTO `chat_message` VALUES (327, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:01:22', '0');
INSERT INTO `chat_message` VALUES (328, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:01:22', '0');
INSERT INTO `chat_message` VALUES (329, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:01:26', '0');
INSERT INTO `chat_message` VALUES (330, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:01:26', '0');
INSERT INTO `chat_message` VALUES (331, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:01:30', '0');
INSERT INTO `chat_message` VALUES (332, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:01:30', '0');
INSERT INTO `chat_message` VALUES (333, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:01:34', '0');
INSERT INTO `chat_message` VALUES (334, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:01:34', '0');
INSERT INTO `chat_message` VALUES (335, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:01:38', '0');
INSERT INTO `chat_message` VALUES (336, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:01:38', '0');
INSERT INTO `chat_message` VALUES (337, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:01:42', '0');
INSERT INTO `chat_message` VALUES (338, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:01:42', '0');
INSERT INTO `chat_message` VALUES (339, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:01:46', '0');
INSERT INTO `chat_message` VALUES (340, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:01:46', '0');
INSERT INTO `chat_message` VALUES (341, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:01:50', '0');
INSERT INTO `chat_message` VALUES (342, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:01:50', '0');
INSERT INTO `chat_message` VALUES (343, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:01:54', '0');
INSERT INTO `chat_message` VALUES (344, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:01:54', '0');
INSERT INTO `chat_message` VALUES (345, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:01:58', '0');
INSERT INTO `chat_message` VALUES (346, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:01:58', '0');
INSERT INTO `chat_message` VALUES (347, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:02:02', '0');
INSERT INTO `chat_message` VALUES (348, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:02:02', '0');
INSERT INTO `chat_message` VALUES (349, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:02:06', '0');
INSERT INTO `chat_message` VALUES (350, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:02:06', '0');
INSERT INTO `chat_message` VALUES (351, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:02:10', '0');
INSERT INTO `chat_message` VALUES (352, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:02:10', '0');
INSERT INTO `chat_message` VALUES (353, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:02:14', '0');
INSERT INTO `chat_message` VALUES (354, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:02:14', '0');
INSERT INTO `chat_message` VALUES (355, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:02:18', '0');
INSERT INTO `chat_message` VALUES (356, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:02:18', '0');
INSERT INTO `chat_message` VALUES (357, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:02:22', '0');
INSERT INTO `chat_message` VALUES (358, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:02:22', '0');
INSERT INTO `chat_message` VALUES (359, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:02:26', '0');
INSERT INTO `chat_message` VALUES (360, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:02:26', '0');
INSERT INTO `chat_message` VALUES (361, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:02:30', '0');
INSERT INTO `chat_message` VALUES (362, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:02:30', '0');
INSERT INTO `chat_message` VALUES (363, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:02:34', '0');
INSERT INTO `chat_message` VALUES (364, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:02:34', '0');
INSERT INTO `chat_message` VALUES (365, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:02:38', '0');
INSERT INTO `chat_message` VALUES (366, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:02:38', '0');
INSERT INTO `chat_message` VALUES (367, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:02:42', '0');
INSERT INTO `chat_message` VALUES (368, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:02:42', '0');
INSERT INTO `chat_message` VALUES (369, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:02:46', '0');
INSERT INTO `chat_message` VALUES (370, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:02:46', '0');
INSERT INTO `chat_message` VALUES (371, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:02:50', '0');
INSERT INTO `chat_message` VALUES (372, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:02:50', '0');
INSERT INTO `chat_message` VALUES (373, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:02:54', '0');
INSERT INTO `chat_message` VALUES (374, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:02:54', '0');
INSERT INTO `chat_message` VALUES (375, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:02:58', '0');
INSERT INTO `chat_message` VALUES (376, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:02:58', '0');
INSERT INTO `chat_message` VALUES (377, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:03:02', '0');
INSERT INTO `chat_message` VALUES (378, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:03:02', '0');
INSERT INTO `chat_message` VALUES (379, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:03:06', '0');
INSERT INTO `chat_message` VALUES (380, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:03:06', '0');
INSERT INTO `chat_message` VALUES (381, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:03:10', '0');
INSERT INTO `chat_message` VALUES (382, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:03:10', '0');
INSERT INTO `chat_message` VALUES (383, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:03:14', '0');
INSERT INTO `chat_message` VALUES (384, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:03:14', '0');
INSERT INTO `chat_message` VALUES (385, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:03:18', '0');
INSERT INTO `chat_message` VALUES (386, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:03:18', '0');
INSERT INTO `chat_message` VALUES (387, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:03:22', '0');
INSERT INTO `chat_message` VALUES (388, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:03:22', '0');
INSERT INTO `chat_message` VALUES (389, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:03:26', '0');
INSERT INTO `chat_message` VALUES (390, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:03:26', '0');
INSERT INTO `chat_message` VALUES (391, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:03:30', '0');
INSERT INTO `chat_message` VALUES (392, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:03:30', '0');
INSERT INTO `chat_message` VALUES (393, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:03:34', '0');
INSERT INTO `chat_message` VALUES (394, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:03:34', '0');
INSERT INTO `chat_message` VALUES (395, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:03:38', '0');
INSERT INTO `chat_message` VALUES (396, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:03:38', '0');
INSERT INTO `chat_message` VALUES (397, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:03:42', '0');
INSERT INTO `chat_message` VALUES (398, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:03:42', '0');
INSERT INTO `chat_message` VALUES (399, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:03:46', '0');
INSERT INTO `chat_message` VALUES (400, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:03:46', '0');
INSERT INTO `chat_message` VALUES (401, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:03:50', '0');
INSERT INTO `chat_message` VALUES (402, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:03:50', '0');
INSERT INTO `chat_message` VALUES (403, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:03:54', '0');
INSERT INTO `chat_message` VALUES (404, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:03:54', '0');
INSERT INTO `chat_message` VALUES (405, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:03:58', '0');
INSERT INTO `chat_message` VALUES (406, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:03:58', '0');
INSERT INTO `chat_message` VALUES (407, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:04:02', '0');
INSERT INTO `chat_message` VALUES (408, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:04:02', '0');
INSERT INTO `chat_message` VALUES (409, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:04:06', '0');
INSERT INTO `chat_message` VALUES (410, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:04:06', '0');
INSERT INTO `chat_message` VALUES (411, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:04:10', '0');
INSERT INTO `chat_message` VALUES (412, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:04:10', '0');
INSERT INTO `chat_message` VALUES (413, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:04:14', '0');
INSERT INTO `chat_message` VALUES (414, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:04:14', '0');
INSERT INTO `chat_message` VALUES (415, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:04:18', '0');
INSERT INTO `chat_message` VALUES (416, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:04:18', '0');
INSERT INTO `chat_message` VALUES (417, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:04:22', '0');
INSERT INTO `chat_message` VALUES (418, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:04:22', '0');
INSERT INTO `chat_message` VALUES (419, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:04:26', '0');
INSERT INTO `chat_message` VALUES (420, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:04:26', '0');
INSERT INTO `chat_message` VALUES (421, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:04:30', '0');
INSERT INTO `chat_message` VALUES (422, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:04:30', '0');
INSERT INTO `chat_message` VALUES (423, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:04:34', '0');
INSERT INTO `chat_message` VALUES (424, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:04:34', '0');
INSERT INTO `chat_message` VALUES (425, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:04:38', '0');
INSERT INTO `chat_message` VALUES (426, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:04:38', '0');
INSERT INTO `chat_message` VALUES (427, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:04:42', '0');
INSERT INTO `chat_message` VALUES (428, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:04:42', '0');
INSERT INTO `chat_message` VALUES (429, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:04:46', '0');
INSERT INTO `chat_message` VALUES (430, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:04:46', '0');
INSERT INTO `chat_message` VALUES (431, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:04:50', '0');
INSERT INTO `chat_message` VALUES (432, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:04:50', '0');
INSERT INTO `chat_message` VALUES (433, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:04:54', '0');
INSERT INTO `chat_message` VALUES (434, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:04:54', '0');
INSERT INTO `chat_message` VALUES (435, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:04:58', '0');
INSERT INTO `chat_message` VALUES (436, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:04:58', '0');
INSERT INTO `chat_message` VALUES (437, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:05:02', '0');
INSERT INTO `chat_message` VALUES (438, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:05:02', '0');
INSERT INTO `chat_message` VALUES (439, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:05:06', '0');
INSERT INTO `chat_message` VALUES (440, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:05:06', '0');
INSERT INTO `chat_message` VALUES (441, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:05:10', '0');
INSERT INTO `chat_message` VALUES (442, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:05:10', '0');
INSERT INTO `chat_message` VALUES (443, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:05:14', '0');
INSERT INTO `chat_message` VALUES (444, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:05:14', '0');
INSERT INTO `chat_message` VALUES (445, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:05:18', '0');
INSERT INTO `chat_message` VALUES (446, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:05:18', '0');
INSERT INTO `chat_message` VALUES (447, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:05:22', '0');
INSERT INTO `chat_message` VALUES (448, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:05:22', '0');
INSERT INTO `chat_message` VALUES (449, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:05:26', '0');
INSERT INTO `chat_message` VALUES (450, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:05:26', '0');
INSERT INTO `chat_message` VALUES (451, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:05:30', '0');
INSERT INTO `chat_message` VALUES (452, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:05:30', '0');
INSERT INTO `chat_message` VALUES (453, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:05:34', '0');
INSERT INTO `chat_message` VALUES (454, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:05:34', '0');
INSERT INTO `chat_message` VALUES (455, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:05:38', '0');
INSERT INTO `chat_message` VALUES (456, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:05:38', '0');
INSERT INTO `chat_message` VALUES (457, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:05:42', '0');
INSERT INTO `chat_message` VALUES (458, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:05:42', '0');
INSERT INTO `chat_message` VALUES (459, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:05:46', '0');
INSERT INTO `chat_message` VALUES (460, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:05:46', '0');
INSERT INTO `chat_message` VALUES (461, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:05:50', '0');
INSERT INTO `chat_message` VALUES (462, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:05:50', '0');
INSERT INTO `chat_message` VALUES (463, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:05:54', '0');
INSERT INTO `chat_message` VALUES (464, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:05:54', '0');
INSERT INTO `chat_message` VALUES (465, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:05:58', '0');
INSERT INTO `chat_message` VALUES (466, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:05:58', '0');
INSERT INTO `chat_message` VALUES (467, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:06:02', '0');
INSERT INTO `chat_message` VALUES (468, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:06:02', '0');
INSERT INTO `chat_message` VALUES (469, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:06:06', '0');
INSERT INTO `chat_message` VALUES (470, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:06:06', '0');
INSERT INTO `chat_message` VALUES (471, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:06:10', '0');
INSERT INTO `chat_message` VALUES (472, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:06:10', '0');
INSERT INTO `chat_message` VALUES (473, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:06:14', '0');
INSERT INTO `chat_message` VALUES (474, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:06:14', '0');
INSERT INTO `chat_message` VALUES (475, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:06:18', '0');
INSERT INTO `chat_message` VALUES (476, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:06:18', '0');
INSERT INTO `chat_message` VALUES (477, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:06:22', '0');
INSERT INTO `chat_message` VALUES (478, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:06:22', '0');
INSERT INTO `chat_message` VALUES (479, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:06:26', '0');
INSERT INTO `chat_message` VALUES (480, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:06:26', '0');
INSERT INTO `chat_message` VALUES (481, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:06:30', '0');
INSERT INTO `chat_message` VALUES (482, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:06:30', '0');
INSERT INTO `chat_message` VALUES (483, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:06:34', '0');
INSERT INTO `chat_message` VALUES (484, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:06:34', '0');
INSERT INTO `chat_message` VALUES (485, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:06:38', '0');
INSERT INTO `chat_message` VALUES (486, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:06:38', '0');
INSERT INTO `chat_message` VALUES (487, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:06:42', '0');
INSERT INTO `chat_message` VALUES (488, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:06:42', '0');
INSERT INTO `chat_message` VALUES (489, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:06:46', '0');
INSERT INTO `chat_message` VALUES (490, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:06:46', '0');
INSERT INTO `chat_message` VALUES (491, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:06:50', '0');
INSERT INTO `chat_message` VALUES (492, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:06:50', '0');
INSERT INTO `chat_message` VALUES (493, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:06:54', '0');
INSERT INTO `chat_message` VALUES (494, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:06:54', '0');
INSERT INTO `chat_message` VALUES (495, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:06:58', '0');
INSERT INTO `chat_message` VALUES (496, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:06:58', '0');
INSERT INTO `chat_message` VALUES (497, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:07:02', '0');
INSERT INTO `chat_message` VALUES (498, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:07:02', '0');
INSERT INTO `chat_message` VALUES (499, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:07:06', '0');
INSERT INTO `chat_message` VALUES (500, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:07:06', '0');
INSERT INTO `chat_message` VALUES (501, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:07:10', '0');
INSERT INTO `chat_message` VALUES (502, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:07:10', '0');
INSERT INTO `chat_message` VALUES (503, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:07:14', '0');
INSERT INTO `chat_message` VALUES (504, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:07:14', '0');
INSERT INTO `chat_message` VALUES (505, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:07:18', '0');
INSERT INTO `chat_message` VALUES (506, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:07:18', '0');
INSERT INTO `chat_message` VALUES (507, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:07:22', '0');
INSERT INTO `chat_message` VALUES (508, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:07:22', '0');
INSERT INTO `chat_message` VALUES (509, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:07:26', '0');
INSERT INTO `chat_message` VALUES (510, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:07:26', '0');
INSERT INTO `chat_message` VALUES (511, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:07:30', '0');
INSERT INTO `chat_message` VALUES (512, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:07:30', '0');
INSERT INTO `chat_message` VALUES (513, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:07:34', '0');
INSERT INTO `chat_message` VALUES (514, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:07:34', '0');
INSERT INTO `chat_message` VALUES (515, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:07:38', '0');
INSERT INTO `chat_message` VALUES (516, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:07:38', '0');
INSERT INTO `chat_message` VALUES (517, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:07:42', '0');
INSERT INTO `chat_message` VALUES (518, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:07:42', '0');
INSERT INTO `chat_message` VALUES (519, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:07:46', '0');
INSERT INTO `chat_message` VALUES (520, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:07:46', '0');
INSERT INTO `chat_message` VALUES (521, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:07:48', '0');
INSERT INTO `chat_message` VALUES (522, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:08:56', '0');
INSERT INTO `chat_message` VALUES (523, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:08:56', '0');
INSERT INTO `chat_message` VALUES (524, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:08:56', '0');
INSERT INTO `chat_message` VALUES (525, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:09:00', '0');
INSERT INTO `chat_message` VALUES (526, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:09:00', '0');
INSERT INTO `chat_message` VALUES (527, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:09:04', '0');
INSERT INTO `chat_message` VALUES (528, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:09:04', '0');
INSERT INTO `chat_message` VALUES (529, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:09:08', '0');
INSERT INTO `chat_message` VALUES (530, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:09:08', '0');
INSERT INTO `chat_message` VALUES (531, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:09:12', '0');
INSERT INTO `chat_message` VALUES (532, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:09:12', '0');
INSERT INTO `chat_message` VALUES (533, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:09:16', '0');
INSERT INTO `chat_message` VALUES (534, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:09:16', '0');
INSERT INTO `chat_message` VALUES (535, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:09:20', '0');
INSERT INTO `chat_message` VALUES (536, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:09:20', '0');
INSERT INTO `chat_message` VALUES (537, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:09:24', '0');
INSERT INTO `chat_message` VALUES (538, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:09:24', '0');
INSERT INTO `chat_message` VALUES (539, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:09:28', '0');
INSERT INTO `chat_message` VALUES (540, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:09:28', '0');
INSERT INTO `chat_message` VALUES (541, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:09:32', '0');
INSERT INTO `chat_message` VALUES (542, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:09:32', '0');
INSERT INTO `chat_message` VALUES (543, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:09:36', '0');
INSERT INTO `chat_message` VALUES (544, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:09:36', '0');
INSERT INTO `chat_message` VALUES (545, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:09:40', '0');
INSERT INTO `chat_message` VALUES (546, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:09:40', '0');
INSERT INTO `chat_message` VALUES (547, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:09:44', '0');
INSERT INTO `chat_message` VALUES (548, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:09:44', '0');
INSERT INTO `chat_message` VALUES (549, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:09:48', '0');
INSERT INTO `chat_message` VALUES (550, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:09:48', '0');
INSERT INTO `chat_message` VALUES (551, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:09:52', '0');
INSERT INTO `chat_message` VALUES (552, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:09:52', '0');
INSERT INTO `chat_message` VALUES (553, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:09:56', '0');
INSERT INTO `chat_message` VALUES (554, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:09:56', '0');
INSERT INTO `chat_message` VALUES (555, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:10:00', '0');
INSERT INTO `chat_message` VALUES (556, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:10:00', '0');
INSERT INTO `chat_message` VALUES (557, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:10:04', '0');
INSERT INTO `chat_message` VALUES (558, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:10:04', '0');
INSERT INTO `chat_message` VALUES (559, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:10:08', '0');
INSERT INTO `chat_message` VALUES (560, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:10:08', '0');
INSERT INTO `chat_message` VALUES (561, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:10:12', '0');
INSERT INTO `chat_message` VALUES (562, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:10:12', '0');
INSERT INTO `chat_message` VALUES (563, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:10:16', '0');
INSERT INTO `chat_message` VALUES (564, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:10:16', '0');
INSERT INTO `chat_message` VALUES (565, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:10:20', '0');
INSERT INTO `chat_message` VALUES (566, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:10:20', '0');
INSERT INTO `chat_message` VALUES (567, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:10:24', '0');
INSERT INTO `chat_message` VALUES (568, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:10:24', '0');
INSERT INTO `chat_message` VALUES (569, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:10:28', '0');
INSERT INTO `chat_message` VALUES (570, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:10:28', '0');
INSERT INTO `chat_message` VALUES (571, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:10:32', '0');
INSERT INTO `chat_message` VALUES (572, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:10:32', '0');
INSERT INTO `chat_message` VALUES (573, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:10:36', '0');
INSERT INTO `chat_message` VALUES (574, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:10:36', '0');
INSERT INTO `chat_message` VALUES (575, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:10:40', '0');
INSERT INTO `chat_message` VALUES (576, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:10:40', '0');
INSERT INTO `chat_message` VALUES (577, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:10:44', '0');
INSERT INTO `chat_message` VALUES (578, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:10:44', '0');
INSERT INTO `chat_message` VALUES (579, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:10:48', '0');
INSERT INTO `chat_message` VALUES (580, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:10:48', '0');
INSERT INTO `chat_message` VALUES (581, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:10:52', '0');
INSERT INTO `chat_message` VALUES (582, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:10:52', '0');
INSERT INTO `chat_message` VALUES (583, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:10:56', '0');
INSERT INTO `chat_message` VALUES (584, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:10:56', '0');
INSERT INTO `chat_message` VALUES (585, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:11:00', '0');
INSERT INTO `chat_message` VALUES (586, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:11:00', '0');
INSERT INTO `chat_message` VALUES (587, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:11:04', '0');
INSERT INTO `chat_message` VALUES (588, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:11:04', '0');
INSERT INTO `chat_message` VALUES (589, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:11:08', '0');
INSERT INTO `chat_message` VALUES (590, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:11:08', '0');
INSERT INTO `chat_message` VALUES (591, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:11:12', '0');
INSERT INTO `chat_message` VALUES (592, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:11:12', '0');
INSERT INTO `chat_message` VALUES (593, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:11:16', '0');
INSERT INTO `chat_message` VALUES (594, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:11:16', '0');
INSERT INTO `chat_message` VALUES (595, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:11:20', '0');
INSERT INTO `chat_message` VALUES (596, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:11:20', '0');
INSERT INTO `chat_message` VALUES (597, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:11:24', '0');
INSERT INTO `chat_message` VALUES (598, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:11:24', '0');
INSERT INTO `chat_message` VALUES (599, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:11:28', '0');
INSERT INTO `chat_message` VALUES (600, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:11:28', '0');
INSERT INTO `chat_message` VALUES (601, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:11:32', '0');
INSERT INTO `chat_message` VALUES (602, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:11:32', '0');
INSERT INTO `chat_message` VALUES (603, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:11:36', '0');
INSERT INTO `chat_message` VALUES (604, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:11:36', '0');
INSERT INTO `chat_message` VALUES (605, 1, '若依', '方法美国', 'chat', '2025-11-05 14:11:42', '0');
INSERT INTO `chat_message` VALUES (606, 1, '若依', '告诉国人', 'chat', '2025-11-05 14:11:45', '0');
INSERT INTO `chat_message` VALUES (607, 1, '若依', '也容易', 'chat', '2025-11-05 14:11:47', '0');
INSERT INTO `chat_message` VALUES (608, 1, '若依', 'y热也让', 'chat', '2025-11-05 14:11:55', '0');
INSERT INTO `chat_message` VALUES (609, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:12:46', '0');
INSERT INTO `chat_message` VALUES (610, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:13:06', '0');
INSERT INTO `chat_message` VALUES (611, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:13:50', '0');
INSERT INTO `chat_message` VALUES (612, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:13:53', '0');
INSERT INTO `chat_message` VALUES (613, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:14:06', '0');
INSERT INTO `chat_message` VALUES (614, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:14:09', '0');
INSERT INTO `chat_message` VALUES (615, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:14:21', '0');
INSERT INTO `chat_message` VALUES (616, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:14:24', '0');
INSERT INTO `chat_message` VALUES (617, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:14:25', '0');
INSERT INTO `chat_message` VALUES (618, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:14:29', '0');
INSERT INTO `chat_message` VALUES (619, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:14:32', '0');
INSERT INTO `chat_message` VALUES (620, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:14:36', '0');
INSERT INTO `chat_message` VALUES (621, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:14:55', '0');
INSERT INTO `chat_message` VALUES (622, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:14:59', '0');
INSERT INTO `chat_message` VALUES (623, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:15:39', '0');
INSERT INTO `chat_message` VALUES (624, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:15:43', '0');
INSERT INTO `chat_message` VALUES (625, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:15:48', '0');
INSERT INTO `chat_message` VALUES (626, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:16:00', '0');
INSERT INTO `chat_message` VALUES (627, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:16:15', '0');
INSERT INTO `chat_message` VALUES (628, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:16:19', '0');
INSERT INTO `chat_message` VALUES (629, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:16:42', '0');
INSERT INTO `chat_message` VALUES (630, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:17:13', '0');
INSERT INTO `chat_message` VALUES (631, 1, '若依', '个人个人', 'chat', '2025-11-05 14:17:18', '0');
INSERT INTO `chat_message` VALUES (632, 1, '若依', '吊袜带', 'chat', '2025-11-05 14:17:28', '0');
INSERT INTO `chat_message` VALUES (633, 1, '若依', '达瓦达瓦', 'chat', '2025-11-05 14:17:31', '0');
INSERT INTO `chat_message` VALUES (634, 1, '若依', '合法化', 'chat', '2025-11-05 14:17:44', '0');
INSERT INTO `chat_message` VALUES (635, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:18:34', '0');
INSERT INTO `chat_message` VALUES (636, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:18:54', '0');
INSERT INTO `chat_message` VALUES (637, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:18:54', '0');
INSERT INTO `chat_message` VALUES (638, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:18:58', '0');
INSERT INTO `chat_message` VALUES (639, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:19:10', '0');
INSERT INTO `chat_message` VALUES (640, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:19:10', '0');
INSERT INTO `chat_message` VALUES (641, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:19:10', '0');
INSERT INTO `chat_message` VALUES (642, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:19:14', '0');
INSERT INTO `chat_message` VALUES (643, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:19:19', '0');
INSERT INTO `chat_message` VALUES (644, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:19:19', '0');
INSERT INTO `chat_message` VALUES (645, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:19:26', '0');
INSERT INTO `chat_message` VALUES (646, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:19:26', '0');
INSERT INTO `chat_message` VALUES (647, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:19:26', '0');
INSERT INTO `chat_message` VALUES (648, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:19:30', '0');
INSERT INTO `chat_message` VALUES (649, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:19:30', '0');
INSERT INTO `chat_message` VALUES (650, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:19:34', '0');
INSERT INTO `chat_message` VALUES (651, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:19:34', '0');
INSERT INTO `chat_message` VALUES (652, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:19:38', '0');
INSERT INTO `chat_message` VALUES (653, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:19:38', '0');
INSERT INTO `chat_message` VALUES (654, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:19:42', '0');
INSERT INTO `chat_message` VALUES (655, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:19:42', '0');
INSERT INTO `chat_message` VALUES (656, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:19:46', '0');
INSERT INTO `chat_message` VALUES (657, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:19:46', '0');
INSERT INTO `chat_message` VALUES (658, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:19:50', '0');
INSERT INTO `chat_message` VALUES (659, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:19:50', '0');
INSERT INTO `chat_message` VALUES (660, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:19:54', '0');
INSERT INTO `chat_message` VALUES (661, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:19:54', '0');
INSERT INTO `chat_message` VALUES (662, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:19:58', '0');
INSERT INTO `chat_message` VALUES (663, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:19:58', '0');
INSERT INTO `chat_message` VALUES (664, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:20:02', '0');
INSERT INTO `chat_message` VALUES (665, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:20:02', '0');
INSERT INTO `chat_message` VALUES (666, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:20:05', '0');
INSERT INTO `chat_message` VALUES (667, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:20:21', '0');
INSERT INTO `chat_message` VALUES (668, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:20:22', '0');
INSERT INTO `chat_message` VALUES (669, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:20:22', '0');
INSERT INTO `chat_message` VALUES (670, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:20:26', '0');
INSERT INTO `chat_message` VALUES (671, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:20:26', '0');
INSERT INTO `chat_message` VALUES (672, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:20:30', '0');
INSERT INTO `chat_message` VALUES (673, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:20:30', '0');
INSERT INTO `chat_message` VALUES (674, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:20:31', '0');
INSERT INTO `chat_message` VALUES (675, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:20:31', '0');
INSERT INTO `chat_message` VALUES (676, 1, '若依', '就如同就如同', 'chat', '2025-11-05 14:20:38', '0');
INSERT INTO `chat_message` VALUES (677, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:20:49', '0');
INSERT INTO `chat_message` VALUES (678, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:20:49', '0');
INSERT INTO `chat_message` VALUES (679, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:20:52', '0');
INSERT INTO `chat_message` VALUES (680, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:20:52', '0');
INSERT INTO `chat_message` VALUES (681, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:20:56', '0');
INSERT INTO `chat_message` VALUES (682, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:20:56', '0');
INSERT INTO `chat_message` VALUES (683, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:20:59', '0');
INSERT INTO `chat_message` VALUES (684, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:20:59', '0');
INSERT INTO `chat_message` VALUES (685, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:21:03', '0');
INSERT INTO `chat_message` VALUES (686, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:21:03', '0');
INSERT INTO `chat_message` VALUES (687, 1, '若依', 'v阿达vvvvv', 'chat', '2025-11-05 14:21:04', '0');
INSERT INTO `chat_message` VALUES (688, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:21:06', '0');
INSERT INTO `chat_message` VALUES (689, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:21:06', '0');
INSERT INTO `chat_message` VALUES (690, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:21:09', '0');
INSERT INTO `chat_message` VALUES (691, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:21:10', '0');
INSERT INTO `chat_message` VALUES (692, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:22:20', '0');
INSERT INTO `chat_message` VALUES (693, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:22:23', '0');
INSERT INTO `chat_message` VALUES (694, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:22:28', '0');
INSERT INTO `chat_message` VALUES (695, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:22:32', '0');
INSERT INTO `chat_message` VALUES (696, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:22:35', '0');
INSERT INTO `chat_message` VALUES (697, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:23:25', '0');
INSERT INTO `chat_message` VALUES (698, 1, '若依', '的本身并不BBS', 'chat', '2025-11-05 14:23:30', '0');
INSERT INTO `chat_message` VALUES (699, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:23:34', '0');
INSERT INTO `chat_message` VALUES (700, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:23:34', '0');
INSERT INTO `chat_message` VALUES (701, 1, '若依', '呵呵呵', 'chat', '2025-11-05 14:23:38', '0');
INSERT INTO `chat_message` VALUES (702, 1, '若依', '山工身高刚刚', 'chat', '2025-11-05 14:23:42', '0');
INSERT INTO `chat_message` VALUES (703, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:23:49', '0');
INSERT INTO `chat_message` VALUES (704, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:23:49', '0');
INSERT INTO `chat_message` VALUES (705, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:23:54', '0');
INSERT INTO `chat_message` VALUES (706, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:50:21', '0');
INSERT INTO `chat_message` VALUES (707, 1, '若依', '吊袜带', 'chat', '2025-11-05 14:50:25', '0');
INSERT INTO `chat_message` VALUES (708, 1, '若依', '吊袜带', 'chat', '2025-11-05 14:50:33', '0');
INSERT INTO `chat_message` VALUES (709, 1, '若依', '大王的', 'chat', '2025-11-05 14:50:35', '0');
INSERT INTO `chat_message` VALUES (710, 1, '若依', '达瓦低洼地', 'chat', '2025-11-05 14:50:40', '0');
INSERT INTO `chat_message` VALUES (711, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:50:54', '0');
INSERT INTO `chat_message` VALUES (712, 1, '若依', '若依 加入了聊天室', 'system', '2025-11-05 14:50:54', '0');
INSERT INTO `chat_message` VALUES (713, 1, '若依', 'vadv', 'chat', '2025-11-05 14:51:08', '0');
INSERT INTO `chat_message` VALUES (714, 1, '若依', '若依 离开了聊天室', 'system', '2025-11-05 14:52:08', '0');
INSERT INTO `chat_message` VALUES (715, 1, '若依', '若依 加入了聊天室', 'system', '2025-12-07 17:13:00', '0');
INSERT INTO `chat_message` VALUES (716, 1, '若依', '若依 离开了聊天室', 'system', '2025-12-07 17:13:12', '0');
INSERT INTO `chat_message` VALUES (717, 1, '若依', '若依 加入了聊天室', 'system', '2025-12-07 17:13:14', '0');
INSERT INTO `chat_message` VALUES (718, 1, '若依', '若依 离开了聊天室', 'system', '2025-12-07 17:13:20', '0');
INSERT INTO `chat_message` VALUES (719, 1, '若依', '若依 加入了聊天室', 'system', '2025-12-07 17:13:23', '0');
INSERT INTO `chat_message` VALUES (720, 1, '若依', '若依 离开了聊天室', 'system', '2025-12-07 17:13:28', '0');
INSERT INTO `chat_message` VALUES (721, 1, '若依', '若依 加入了聊天室', 'system', '2025-12-07 17:13:30', '0');
INSERT INTO `chat_message` VALUES (722, 1, '若依', '若依 离开了聊天室', 'system', '2025-12-07 17:13:37', '0');
INSERT INTO `chat_message` VALUES (723, 1, '若依', '若依 加入了聊天室', 'system', '2025-12-07 17:13:59', '0');
INSERT INTO `chat_message` VALUES (724, 1, '若依', '若依 离开了聊天室', 'system', '2025-12-07 17:20:06', '0');
INSERT INTO `chat_message` VALUES (725, 1, '若依', '若依 加入了聊天室', 'system', '2025-12-07 18:30:52', '0');
INSERT INTO `chat_message` VALUES (726, 1, '若依', '你好', 'chat', '2025-12-07 18:31:00', '0');
INSERT INTO `chat_message` VALUES (727, 1, '若依', '若依 加入了聊天室', 'system', '2025-12-18 17:40:12', '0');
INSERT INTO `chat_message` VALUES (728, 1, '若依', '若依 离开了聊天室', 'system', '2025-12-18 17:40:13', '0');
INSERT INTO `chat_message` VALUES (729, 1, '若依', '若依 加入了聊天室', 'system', '2025-12-18 17:42:40', '0');
INSERT INTO `chat_message` VALUES (730, 1, '若依', '若依 离开了聊天室', 'system', '2025-12-18 17:42:47', '0');
INSERT INTO `chat_message` VALUES (731, 1, '若依', '若依 加入了聊天室', 'system', '2025-12-18 17:43:01', '0');
INSERT INTO `chat_message` VALUES (732, 1, '若依', '若依 离开了聊天室', 'system', '2025-12-18 17:43:02', '0');
INSERT INTO `chat_message` VALUES (733, 1, '若依', '若依 加入了聊天室', 'system', '2025-12-18 17:43:05', '0');
INSERT INTO `chat_message` VALUES (734, 1, '若依', '若依 离开了聊天室', 'system', '2025-12-18 17:47:09', '0');

-- ----------------------------
-- Table structure for department
-- ----------------------------
DROP TABLE IF EXISTS `department`;
CREATE TABLE `department`  (
  `department_id` int NOT NULL AUTO_INCREMENT COMMENT '部门ID',
  `department_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '部门名称',
  `parent_id` int NULL DEFAULT NULL COMMENT '上级部门ID，用于表示部门层级关系',
  `chairman` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '部门负责人',
  PRIMARY KEY (`department_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '部门信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of department
-- ----------------------------
INSERT INTO `department` VALUES (1, 'uuu', 0, '发我');

-- ----------------------------
-- Table structure for eq_alert_record
-- ----------------------------
DROP TABLE IF EXISTS `eq_alert_record`;
CREATE TABLE `eq_alert_record`  (
  `alert_id` bigint NOT NULL AUTO_INCREMENT COMMENT '告警ID',
  `device_id` bigint NOT NULL COMMENT '设备ID',
  `rule_id` bigint NULL DEFAULT NULL COMMENT '规则ID',
  `alert_level` tinyint NULL DEFAULT NULL COMMENT '告警级别 1-警告 2-严重 3-紧急',
  `alert_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '告警消息',
  `triggered_time` datetime NOT NULL COMMENT '触发时间',
  `resolved_time` datetime NULL DEFAULT NULL COMMENT '解决时间',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态 1-已触发 2-已解决 3-已确认',
  `resolved_by` bigint NULL DEFAULT NULL COMMENT '解决人',
  `resolution_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '解决备注',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`alert_id`) USING BTREE,
  INDEX `idx_device_time`(`device_id` ASC, `triggered_time` ASC) USING BTREE,
  INDEX `idx_alert_level`(`alert_level` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '告警记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eq_alert_record
-- ----------------------------
INSERT INTO `eq_alert_record` VALUES (1, 1, NULL, 3, '电流波动异常', '2026-01-11 23:01:33', '2026-01-11 19:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (2, 1, NULL, 3, '温度超过警告阈值', '2026-01-11 00:01:33', '2026-01-11 18:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (3, 1, NULL, 1, '电流波动异常', '2026-01-11 16:01:33', NULL, 1, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (4, 2, NULL, 1, '振动值偏高', '2026-01-10 15:01:33', '2026-01-11 20:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (5, 2, NULL, 3, '振动值偏高', '2026-01-10 03:01:33', '2026-01-11 15:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (6, 2, NULL, 3, '振动值偏高', '2026-01-11 20:01:33', '2026-01-11 03:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (7, 3, NULL, 1, '电流波动异常', '2026-01-11 15:01:33', '2026-01-11 06:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (8, 3, NULL, 1, '负载过高', '2026-01-11 12:01:33', '2026-01-11 06:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (9, 3, NULL, 3, '电压不稳定', '2026-01-09 18:01:33', '2026-01-11 04:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (10, 4, NULL, 3, '电流波动异常', '2026-01-11 17:01:33', NULL, 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (11, 4, NULL, 1, '振动值偏高', '2026-01-10 09:01:33', '2026-01-11 10:01:33', 3, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (12, 4, NULL, 3, '电流波动异常', '2026-01-11 01:01:33', '2026-01-11 11:01:33', 1, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (13, 5, NULL, 1, '电流波动异常', '2026-01-09 04:01:33', '2026-01-11 05:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (14, 5, NULL, 1, '温度超过警告阈值', '2026-01-09 03:01:33', NULL, 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (15, 5, NULL, 1, '电压不稳定', '2026-01-10 07:01:33', '2026-01-11 16:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (16, 6, NULL, 2, '电流波动异常', '2026-01-11 05:01:33', NULL, 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (17, 6, NULL, 2, '温度超过警告阈值', '2026-01-11 04:01:33', '2026-01-11 08:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (18, 6, NULL, 1, '振动值偏高', '2026-01-09 14:01:33', '2026-01-11 02:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (19, 7, NULL, 2, '电流波动异常', '2026-01-09 22:01:33', '2026-01-11 09:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (20, 7, NULL, 3, '电流波动异常', '2026-01-09 07:01:33', '2026-01-11 22:01:33', 1, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (21, 7, NULL, 2, '负载过高', '2026-01-09 10:01:33', '2026-01-11 20:01:33', 1, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (22, 8, NULL, 2, '电压不稳定', '2026-01-11 16:01:33', '2026-01-11 06:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (23, 8, NULL, 2, '温度超过警告阈值', '2026-01-09 01:01:33', '2026-01-11 17:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (24, 8, NULL, 1, '温度超过警告阈值', '2026-01-09 14:01:33', NULL, 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (25, 9, NULL, 3, '振动值偏高', '2026-01-11 16:01:33', '2026-01-11 01:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (26, 9, NULL, 1, '电流波动异常', '2026-01-10 01:01:33', '2026-01-11 19:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (27, 9, NULL, 3, '电压不稳定', '2026-01-09 05:01:33', NULL, 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (28, 10, NULL, 1, '振动值偏高', '2026-01-09 10:01:33', '2026-01-11 10:01:33', 1, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (29, 10, NULL, 2, '振动值偏高', '2026-01-11 01:01:33', NULL, 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (30, 10, NULL, 3, '温度超过警告阈值', '2026-01-12 00:01:33', NULL, 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (31, 11, NULL, 2, '电压不稳定', '2026-01-10 11:01:33', '2026-01-11 17:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (32, 11, NULL, 3, '振动值偏高', '2026-01-09 03:01:33', NULL, 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (33, 11, NULL, 1, '电流波动异常', '2026-01-10 14:01:33', '2026-01-11 14:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (34, 12, NULL, 2, '电流波动异常', '2026-01-11 21:01:33', '2026-01-11 13:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (35, 12, NULL, 1, '负载过高', '2026-01-10 00:01:33', NULL, 1, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (36, 12, NULL, 2, '电压不稳定', '2026-01-09 02:01:33', '2026-01-11 12:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (37, 13, NULL, 2, '温度超过警告阈值', '2026-01-10 23:01:33', '2026-01-11 17:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (38, 13, NULL, 3, '电压不稳定', '2026-01-11 06:01:33', '2026-01-11 18:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (39, 13, NULL, 3, '振动值偏高', '2026-01-11 18:01:33', '2026-01-11 05:01:33', 1, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (40, 14, NULL, 1, '电流波动异常', '2026-01-10 13:01:33', '2026-01-11 02:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (41, 14, NULL, 3, '电流波动异常', '2026-01-10 14:01:33', '2026-01-11 06:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (42, 14, NULL, 2, '电流波动异常', '2026-01-10 00:01:33', '2026-01-11 02:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (43, 15, NULL, 3, '电流波动异常', '2026-01-10 02:01:33', NULL, 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (44, 15, NULL, 3, '电压不稳定', '2026-01-09 04:01:33', NULL, 3, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (45, 15, NULL, 2, '温度超过警告阈值', '2026-01-11 05:01:33', NULL, 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (46, 16, NULL, 2, '电流波动异常', '2026-01-10 17:01:33', NULL, 1, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (47, 16, NULL, 2, '电流波动异常', '2026-01-09 15:01:33', NULL, 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (48, 16, NULL, 1, '电流波动异常', '2026-01-10 03:01:33', '2026-01-11 02:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (49, 17, NULL, 3, '温度超过警告阈值', '2026-01-10 18:01:33', '2026-01-11 04:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (50, 17, NULL, 1, '负载过高', '2026-01-10 00:01:33', '2026-01-11 15:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (51, 17, NULL, 3, '振动值偏高', '2026-01-09 17:01:33', '2026-01-12 00:01:33', 1, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (52, 18, NULL, 3, '电流波动异常', '2026-01-10 10:01:33', NULL, 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (53, 18, NULL, 2, '电压不稳定', '2026-01-09 17:01:33', '2026-01-11 04:01:33', 1, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (54, 18, NULL, 3, '电流波动异常', '2026-01-09 09:01:33', NULL, 1, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (55, 19, NULL, 1, '电压不稳定', '2026-01-09 01:01:33', NULL, 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (56, 19, NULL, 1, '电压不稳定', '2026-01-10 13:01:33', '2026-01-11 05:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (57, 19, NULL, 3, '振动值偏高', '2026-01-09 12:01:33', '2026-01-11 01:01:33', 1, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (58, 20, NULL, 1, '负载过高', '2026-01-11 10:01:33', '2026-01-11 05:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (59, 20, NULL, 3, '振动值偏高', '2026-01-11 06:01:33', '2026-01-11 18:01:33', 2, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (60, 20, NULL, 1, '电流波动异常', '2026-01-09 04:01:33', '2026-01-11 21:01:33', 1, 0, '已检查并确认，恢复正常', '常规告警', '2026-01-12 00:01:33');

-- ----------------------------
-- Table structure for eq_alert_rule
-- ----------------------------
DROP TABLE IF EXISTS `eq_alert_rule`;
CREATE TABLE `eq_alert_rule`  (
  `rule_id` bigint NOT NULL AUTO_INCREMENT COMMENT '规则ID',
  `device_id` bigint NULL DEFAULT NULL COMMENT '设备ID',
  `rule_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '规则名称',
  `parameter_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '参数名称',
  `condition_type` tinyint NULL DEFAULT NULL COMMENT '条件类型 1-大于 2-小于 3-等于 4-区间',
  `threshold_value` decimal(10, 4) NULL DEFAULT NULL COMMENT '阈值',
  `threshold_unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '阈值单位',
  `alert_level` tinyint NULL DEFAULT NULL COMMENT '告警级别 1-警告 2-严重 3-紧急',
  `enabled` tinyint NULL DEFAULT 1 COMMENT '是否启用 1-启用 0-禁用',
  `notification_channels` json NULL COMMENT '通知渠道',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`rule_id`) USING BTREE,
  INDEX `idx_device_rule`(`device_id` ASC, `rule_name` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '告警规则表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eq_alert_rule
-- ----------------------------
INSERT INTO `eq_alert_rule` VALUES (1, 1, '出口压力过低', 'pressure', 2, 0.3000, 'MPa', 2, 1, NULL, NULL, NULL, '2025-12-18 13:53:20', '2025-12-18 13:53:20');
INSERT INTO `eq_alert_rule` VALUES (2, 1, '温度过高', 'temperature', 1, 80.0000, '°C', 3, 1, NULL, NULL, NULL, '2025-12-18 13:53:20', '2025-12-18 13:53:20');
INSERT INTO `eq_alert_rule` VALUES (3, 2, '电机电流过大', 'current', 1, 90.0000, 'A', 2, 1, NULL, NULL, NULL, '2025-12-18 13:53:20', '2025-12-18 13:53:20');
INSERT INTO `eq_alert_rule` VALUES (4, 2, '振动超标', 'vibration', 1, 5.0000, 'mm/s', 2, 1, NULL, NULL, NULL, '2025-12-18 13:53:20', '2025-12-18 13:53:20');

-- ----------------------------
-- Table structure for eq_climate_data
-- ----------------------------
DROP TABLE IF EXISTS `eq_climate_data`;
CREATE TABLE `eq_climate_data`  (
  `climate_id` bigint NOT NULL AUTO_INCREMENT COMMENT '气候数据ID',
  `device_id` bigint NOT NULL COMMENT '设备ID',
  `timestamp` datetime NOT NULL COMMENT '采集时间',
  `season` tinyint NULL DEFAULT NULL COMMENT '季节 1-春季 2-夏季 3-秋季 4-冬季',
  `weather_condition` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '天气状况',
  `precipitation` decimal(10, 2) NULL DEFAULT NULL COMMENT '降水量(mm)',
  `wind_speed` decimal(10, 2) NULL DEFAULT NULL COMMENT '风速(m/s)',
  `wind_direction` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '风向',
  `extreme_weather` tinyint NULL DEFAULT NULL COMMENT '极端天气 1-无 2-暴雨 3-台风 4-雷电 5-冰雹',
  `weather_duration` int NULL DEFAULT NULL COMMENT '天气持续时间(小时)',
  `temperature_extreme` tinyint NULL DEFAULT NULL COMMENT '极端温度 1-无 2-高温 3-低温',
  `natural_disaster` tinyint NULL DEFAULT NULL COMMENT '自然灾害 1-无 2-地震 3-洪水 4-火灾 5-其他',
  `disaster_intensity` tinyint NULL DEFAULT NULL COMMENT '灾害强度 1-轻度 2-中度 3-重度',
  `disaster_duration` int NULL DEFAULT NULL COMMENT '灾害持续时间(小时)',
  `air_quality_index` int NULL DEFAULT NULL COMMENT '空气质量指数',
  `pollution_level` tinyint NULL DEFAULT NULL COMMENT '污染等级 1-优 2-良 3-轻度污染 4-中度污染 5-重度污染',
  `uv_index` decimal(10, 2) NULL DEFAULT NULL COMMENT '紫外线指数',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`climate_id`) USING BTREE,
  INDEX `idx_device_time`(`device_id` ASC, `timestamp` ASC) USING BTREE,
  INDEX `idx_season`(`season` ASC) USING BTREE,
  INDEX `idx_weather`(`weather_condition` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '气候数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eq_climate_data
-- ----------------------------
INSERT INTO `eq_climate_data` VALUES (1, 1, '2026-01-11 23:01:40', 4, '晴天', 2.80, 8.10, '西南风', 0, 6, 17, 1, 3, 47, 154, 1, 0.40, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (2, 1, '2026-01-10 06:01:40', 2, '多云', 2.90, 17.30, '南风', 0, 7, 6, 1, 1, 36, 176, 3, 8.90, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (3, 1, '2026-01-11 18:01:40', 2, '阴天', 9.50, 16.80, '西风', 1, 3, -11, 1, 0, 11, 137, 5, 10.60, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (4, 2, '2026-01-12 00:01:40', 2, '多云', 1.40, 7.00, '西南风', 1, 6, 27, 1, 3, 18, 142, 3, 4.50, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (5, 2, '2026-01-11 09:01:40', 2, '阴天', 7.10, 16.40, '西北风', 0, 1, 35, 0, 3, 25, 99, 4, 1.40, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (6, 2, '2026-01-11 01:01:40', 1, '晴天', 17.60, 15.60, '西南风', 0, 23, -1, 0, 2, 39, 117, 3, 4.90, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (7, 3, '2026-01-10 12:01:40', 3, '阴天', 10.80, 3.50, '西南风', 1, 11, 26, 0, 4, 35, 151, 5, 7.50, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (8, 3, '2026-01-10 15:01:40', 3, '小雨', 12.30, 16.60, '西风', 0, 22, 15, 1, 4, 25, 162, 4, 2.20, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (9, 3, '2026-01-10 17:01:40', 3, '小雨', 16.10, 4.90, '南风', 1, 14, 4, 1, 0, 8, 98, 4, 6.70, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (10, 4, '2026-01-11 03:01:40', 3, '多云', 5.80, 16.10, '东南风', 0, 19, 33, 1, 1, 35, 171, 2, 1.80, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (11, 4, '2026-01-10 19:01:40', 3, '晴天', 6.40, 16.60, '东南风', 0, 17, 12, 0, 4, 16, 181, 5, 8.60, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (12, 4, '2026-01-10 12:01:40', 3, '晴天', 5.40, 6.80, '西风', 1, 2, 17, 0, 2, 4, 30, 5, 1.50, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (13, 5, '2026-01-11 20:01:40', 1, '小雨', 12.30, 18.80, '西北风', 0, 17, 15, 0, 0, 19, 158, 5, 3.50, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (14, 5, '2026-01-10 21:01:40', 4, '晴天', 8.50, 3.40, '东北风', 0, 17, 27, 0, 3, 33, 52, 4, 1.60, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (15, 5, '2026-01-11 01:01:40', 1, '多云', 12.70, 8.40, '西南风', 1, 23, -1, 0, 4, 23, 149, 3, 9.80, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (16, 6, '2026-01-10 10:01:40', 3, '阴天', 14.10, 5.50, '南风', 0, 11, -1, 1, 3, 42, 30, 3, 2.00, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (17, 6, '2026-01-11 01:01:40', 4, '多云', 1.70, 8.60, '东南风', 0, 13, 23, 1, 4, 47, 42, 3, 4.10, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (18, 6, '2026-01-11 19:01:40', 3, '多云', 7.50, 7.30, '东南风', 0, 16, 37, 0, 0, 10, 179, 2, 2.00, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (19, 7, '2026-01-11 17:01:40', 2, '晴天', 9.00, 5.20, '南风', 0, 22, 19, 0, 4, 33, 42, 2, 6.40, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (20, 7, '2026-01-10 21:01:40', 2, '阴天', 8.70, 0.10, '西北风', 1, 8, -10, 0, 3, 43, 140, 5, 4.50, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (21, 7, '2026-01-11 19:01:40', 2, '晴天', 0.70, 19.60, '东南风', 0, 7, 1, 0, 2, 5, 32, 5, 1.40, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (22, 8, '2026-01-11 21:01:40', 4, '阴天', 10.00, 14.80, '南风', 1, 0, 35, 0, 2, 36, 88, 4, 1.50, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (23, 8, '2026-01-10 17:01:40', 4, '小雨', 4.80, 1.30, '西风', 0, 17, 1, 0, 0, 1, 148, 4, 7.50, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (24, 8, '2026-01-10 12:01:40', 4, '晴天', 5.40, 20.00, '西南风', 1, 17, 29, 1, 2, 2, 121, 5, 7.00, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (25, 9, '2026-01-11 10:01:40', 3, '阴天', 10.40, 12.60, '西南风', 1, 3, 21, 1, 1, 44, 104, 4, 1.40, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (26, 9, '2026-01-11 04:01:40', 4, '阴天', 10.80, 21.60, '东风', 1, 15, 10, 0, 3, 1, 179, 5, 0.90, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (27, 9, '2026-01-10 03:01:40', 3, '阴天', 6.20, 10.10, '西南风', 0, 19, 37, 1, 4, 32, 147, 5, 9.30, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (28, 10, '2026-01-11 05:01:40', 3, '阴天', 6.40, 20.70, '南风', 0, 6, -7, 1, 4, 12, 80, 5, 6.90, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (29, 10, '2026-01-11 19:01:40', 4, '多云', 4.60, 12.70, '南风', 1, 7, 25, 0, 0, 2, 46, 3, 8.40, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (30, 10, '2026-01-11 12:01:40', 1, '多云', 9.70, 13.30, '南风', 1, 22, 30, 1, 3, 22, 73, 1, 4.40, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (31, 11, '2026-01-10 16:01:40', 2, '小雨', 3.00, 14.60, '东南风', 0, 14, 8, 0, 3, 28, 51, 5, 4.00, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (32, 11, '2026-01-10 10:01:40', 4, '阴天', 2.40, 18.90, '西风', 1, 9, 38, 0, 3, 32, 69, 2, 9.40, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (33, 11, '2026-01-10 02:01:40', 2, '多云', 16.40, 6.40, '西南风', 0, 0, 16, 1, 3, 19, 180, 4, 7.40, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (34, 12, '2026-01-10 02:01:40', 4, '小雨', 12.90, 8.40, '北风', 0, 2, 38, 0, 4, 5, 164, 1, 8.70, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (35, 12, '2026-01-11 05:01:40', 4, '多云', 12.20, 3.10, '西南风', 0, 23, 20, 0, 1, 17, 182, 5, 5.50, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (36, 12, '2026-01-10 19:01:40', 3, '阴天', 7.80, 0.80, '西南风', 0, 6, 7, 0, 4, 42, 104, 4, 4.70, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (37, 13, '2026-01-10 19:01:40', 4, '阴天', 3.80, 11.20, '东南风', 1, 17, 37, 0, 2, 35, 67, 1, 5.40, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (38, 13, '2026-01-11 19:01:40', 1, '多云', 6.00, 13.50, '东风', 1, 9, 13, 0, 1, 8, 169, 1, 4.30, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (39, 13, '2026-01-10 12:01:40', 3, '晴天', 9.70, 7.90, '西风', 1, 7, 26, 1, 4, 17, 79, 3, 11.10, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (40, 14, '2026-01-10 07:01:40', 3, '晴天', 1.30, 20.30, '南风', 0, 3, 0, 1, 2, 44, 51, 5, 4.20, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (41, 14, '2026-01-10 06:01:40', 2, '晴天', 5.70, 8.50, '西南风', 0, 15, -14, 0, 4, 13, 94, 2, 3.60, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (42, 14, '2026-01-10 22:01:40', 4, '多云', 0.10, 4.60, '东风', 0, 8, 9, 1, 1, 24, 156, 4, 7.70, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (43, 15, '2026-01-11 08:01:40', 4, '多云', 5.60, 20.30, '西风', 0, 3, -12, 1, 4, 23, 93, 4, 0.20, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (44, 15, '2026-01-11 19:01:40', 3, '多云', 16.40, 20.70, '东南风', 0, 23, 0, 0, 0, 24, 46, 1, 1.50, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (45, 15, '2026-01-11 09:01:40', 1, '晴天', 2.60, 5.10, '西南风', 0, 5, 37, 1, 3, 5, 140, 2, 3.70, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (46, 16, '2026-01-10 17:01:40', 2, '多云', 6.20, 3.70, '南风', 0, 3, 22, 1, 2, 12, 179, 1, 6.90, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (47, 16, '2026-01-10 21:01:40', 1, '多云', 11.60, 1.00, '西南风', 1, 5, 12, 1, 3, 15, 150, 5, 5.20, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (48, 16, '2026-01-11 12:01:40', 1, '多云', 14.00, 3.50, '西南风', 1, 21, 38, 1, 1, 16, 136, 3, 1.40, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (49, 17, '2026-01-11 13:01:40', 4, '小雨', 12.80, 7.10, '西南风', 0, 23, 3, 1, 3, 4, 66, 5, 1.40, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (50, 17, '2026-01-10 16:01:40', 1, '晴天', 15.50, 15.20, '南风', 0, 8, 37, 0, 4, 7, 82, 2, 6.00, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (51, 17, '2026-01-10 22:01:40', 2, '阴天', 3.00, 9.80, '西南风', 1, 10, 13, 0, 3, 8, 178, 2, 8.00, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (52, 18, '2026-01-11 06:01:40', 4, '阴天', 3.60, 8.50, '西南风', 1, 9, -3, 1, 3, 46, 133, 3, 5.70, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (53, 18, '2026-01-10 06:01:40', 4, '晴天', 2.60, 1.90, '东风', 1, 20, 37, 1, 3, 24, 144, 2, 9.30, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (54, 18, '2026-01-11 12:01:40', 4, '晴天', 15.10, 15.50, '东风', 1, 13, -12, 1, 4, 39, 78, 1, 9.10, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (55, 19, '2026-01-11 07:01:40', 2, '阴天', 11.70, 13.40, '东风', 1, 21, 19, 0, 0, 19, 93, 5, 3.30, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (56, 19, '2026-01-10 17:01:40', 2, '多云', 13.70, 15.90, '西风', 1, 19, -3, 1, 2, 1, 86, 4, 10.30, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (57, 19, '2026-01-10 05:01:40', 4, '多云', 7.60, 19.80, '西北风', 0, 14, -13, 0, 3, 24, 92, 3, 4.70, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (58, 20, '2026-01-11 07:01:40', 3, '晴天', 4.40, 3.80, '东南风', 0, 12, -13, 1, 1, 32, 82, 4, 5.30, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (59, 20, '2026-01-11 18:01:40', 2, '晴天', 12.60, 2.90, '西风', 0, 20, -6, 0, 1, 16, 125, 1, 7.80, '2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (60, 20, '2026-01-10 04:01:40', 3, '多云', 4.40, 3.90, '西风', 0, 11, -5, 0, 4, 1, 96, 1, 4.00, '2026-01-12 00:01:40');

-- ----------------------------
-- Table structure for eq_device
-- ----------------------------
DROP TABLE IF EXISTS `eq_device`;
CREATE TABLE `eq_device`  (
  `device_id` bigint NOT NULL AUTO_INCREMENT COMMENT '设备ID',
  `device_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备编号',
  `device_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备名称',
  `device_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '设备类型',
  `model` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '设备型号',
  `serial_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '序列号',
  `manufacturer` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '制造商',
  `location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '安装位置',
  `department` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '所属部门',
  `install_date` datetime NULL DEFAULT NULL COMMENT '安装日期',
  `warranty_expiration` datetime NULL DEFAULT NULL COMMENT '保修到期日期',
  `status` tinyint NULL DEFAULT 1 COMMENT '设备状态 1-正常 2-停用 3-维护 4-报废',
  `asset_value` decimal(12, 2) NULL DEFAULT NULL COMMENT '资产价值',
  `lifespan_years` tinyint NULL DEFAULT NULL COMMENT '使用寿命(年)',
  `responsible_person` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '责任人',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`device_id`) USING BTREE,
  INDEX `idx_device_no`(`device_no` ASC) USING BTREE,
  INDEX `idx_device_type`(`device_type` ASC) USING BTREE,
  INDEX `idx_location`(`location` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '设备信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eq_device
-- ----------------------------
INSERT INTO `eq_device` VALUES (1, 'DEV-001', '主变压器1号', '变压器', 'SFZ10-31500/110', 'BYQ-20210001', '华为技术有限公司', '主厂房A区1层', '运维部', '2021-01-15 00:00:00', '2031-01-15 00:00:00', 1, 1500000.00, 20, '张工', '主要供电设备', 'admin', '2026-01-12 00:01:08', 'admin', '2026-02-18 14:28:53');
INSERT INTO `eq_device` VALUES (2, 'DEV-002', '主变压器2号', '变压器', 'SFZ10-31500/110', 'BYQ-20210002', '华为技术有限公司', '主厂房A区2层', '运维部', '2021-02-20 00:00:00', '2031-02-20 00:00:00', 1, 1500000.00, 20, '张工', '备用供电设备', 'admin', '2026-01-12 00:01:08', 'admin', '2026-01-15 21:19:39');
INSERT INTO `eq_device` VALUES (3, 'DEV-003', '配电柜1号', '配电柜', 'GGD-3200A', 'PDG-20210101', '施耐德电气', '配电室A区', '运维部', '2021-03-10 00:00:00', '2031-03-10 00:00:00', 1, 80000.00, 15, '李工', '主配电设备', 'admin', '2026-01-12 00:01:08', '', '2026-01-12 00:01:08');
INSERT INTO `eq_device` VALUES (4, 'DEV-004', '配电柜2号', '配电柜', 'GGD-3200A', 'PDG-20210102', '施耐德电气', '配电室B区', '运维部', '2021-03-15 00:00:00', '2031-03-15 00:00:00', 1, 80000.00, 15, '李工', '备用配电设备', 'admin', '2026-01-12 00:01:08', '', '2026-01-12 00:01:08');
INSERT INTO `eq_device` VALUES (5, 'DEV-005', '断路器1号', '断路器', 'DW15-2000', 'DLQ-20210201', 'ABB集团', '开关站1号位', '运维部', '2021-04-05 00:00:00', '2031-04-05 00:00:00', 1, 120000.00, 15, '王工', '主线路保护', 'admin', '2026-01-12 00:01:08', '', '2026-01-12 00:01:08');
INSERT INTO `eq_device` VALUES (6, 'DEV-006', '断路器2号', '断路器', 'DW15-2000', 'DLQ-20210202', 'ABB集团', '开关站2号位', '运维部', '2021-04-10 00:00:00', '2031-04-10 00:00:00', 1, 120000.00, 15, '王工', '备用线路保护', 'admin', '2026-01-12 00:01:08', '', '2026-01-12 00:01:08');
INSERT INTO `eq_device` VALUES (7, 'DEV-007', '发电机1号', '发电机', 'FDJ-5000KW', 'FDJ-20210301', '西门子', '发电机房A区', '运维部', '2021-05-01 00:00:00', '2031-05-01 00:00:00', 1, 2500000.00, 25, '赵工', '主发电设备', 'admin', '2026-01-12 00:01:08', '', '2026-01-12 00:01:08');
INSERT INTO `eq_device` VALUES (8, 'DEV-008', '发电机2号', '发电机', 'FDJ-5000KW', 'FDJ-20210302', '西门子', '发电机房B区', '运维部', '2021-05-15 00:00:00', '2031-05-15 00:00:00', 1, 2500000.00, 25, '赵工', '备用发电设备', 'admin', '2026-01-12 00:01:08', '', '2026-01-12 00:01:08');
INSERT INTO `eq_device` VALUES (9, 'DEV-009', '电容器组1号', '电容器', 'BFM11/√3-300-1W', 'DRQ-20210401', '思源电气', '无功补偿室1号', '运维部', '2021-06-01 00:00:00', '2031-06-01 00:00:00', 1, 150000.00, 12, '钱工', '无功补偿设备', 'admin', '2026-01-12 00:01:08', '', '2026-01-12 00:01:08');
INSERT INTO `eq_device` VALUES (10, 'DEV-010', '电容器组2号', '电容器', 'BFM11/√3-300-1W', 'DRQ-20210402', '思源电气', '无功补偿室2号', '运维部', '2021-06-10 00:00:00', '2031-06-10 00:00:00', 1, 150000.00, 12, '钱工', '备用补偿设备', 'admin', '2026-01-12 00:01:08', '', '2026-01-12 00:01:08');
INSERT INTO `eq_device` VALUES (11, 'DEV-011', '互感器1号', '互感器', 'JDZX10-10', 'HGQ-20210501', '正泰电器', '计量室1号位', '运维部', '2021-07-01 00:00:00', '2031-07-01 00:00:00', 1, 35000.00, 10, '孙工', '电压测量设备', 'admin', '2026-01-12 00:01:08', '', '2026-01-12 00:01:08');
INSERT INTO `eq_device` VALUES (12, 'DEV-012', '互感器2号', '互感器', 'JDZX10-10', 'HGQ-20210502', '正泰电器', '计量室2号位', '运维部', '2021-07-05 00:00:00', '2031-07-05 00:00:00', 1, 35000.00, 10, '孙工', '备用测量设备', 'admin', '2026-01-12 00:01:08', '', '2026-01-12 00:01:08');
INSERT INTO `eq_device` VALUES (13, 'DEV-013', '避雷器1号', '避雷器', 'HY5WS-17/50', 'BLQ-20210601', '金冠电气', '室外A区1号杆', '运维部', '2021-08-01 00:00:00', '2031-08-01 00:00:00', 1, 28000.00, 10, '周工', '雷电保护设备', 'admin', '2026-01-12 00:01:08', '', '2026-01-12 00:01:08');
INSERT INTO `eq_device` VALUES (14, 'DEV-014', '避雷器2号', '避雷器', 'HY5WS-17/50', 'BLQ-20210602', '金冠电气', '室外B区1号杆', '运维部', '2021-08-05 00:00:00', '2031-08-05 00:00:00', 1, 28000.00, 10, '周工', '备用保护设备', 'admin', '2026-01-12 00:01:08', '', '2026-01-12 00:01:08');
INSERT INTO `eq_device` VALUES (15, 'DEV-015', '隔离开关1号', '隔离开关', 'GW4-110', 'GLKG-20210701', '平高电气', '开关场A区', '运维部', '2021-09-01 00:00:00', '2031-09-01 00:00:00', 1, 95000.00, 15, '吴工', '线路隔离设备', 'admin', '2026-01-12 00:01:08', '', '2026-01-12 00:01:08');
INSERT INTO `eq_device` VALUES (16, 'DEV-016', '隔离开关2号', '隔离开关', 'GW4-110', 'GLKG-20210702', '平高电气', '开关场B区', '运维部', '2021-09-10 00:00:00', '2031-09-10 00:00:00', 1, 95000.00, 15, '吴工', '备用隔离设备', 'admin', '2026-01-12 00:01:08', '', '2026-01-12 00:01:08');
INSERT INTO `eq_device` VALUES (17, 'DEV-017', 'UPS电源1号', 'UPS', 'C3K-3KVA', 'UPS-20210801', '山特电子', '监控室A区', '运维部', '2021-10-01 00:00:00', '2026-10-01 00:00:00', 1, 45000.00, 8, '郑工', '不间断电源', 'admin', '2026-01-12 00:01:08', '', '2026-01-12 00:01:08');
INSERT INTO `eq_device` VALUES (18, 'DEV-018', 'UPS电源2号', 'UPS', 'C3K-3KVA', 'UPS-20210802', '山特电子', '监控室B区', '运维部', '2021-10-05 00:00:00', '2026-10-05 00:00:00', 1, 45000.00, 8, '郑工', '备用电源', 'admin', '2026-01-12 00:01:08', '', '2026-01-12 00:01:08');
INSERT INTO `eq_device` VALUES (19, 'DEV-019', '直流屏1号', '直流屏', 'GZDW-50Ah/220V', 'ZLP-20210901', '许继电气', '直流室A区', '运维部', '2021-11-01 00:00:00', '2031-11-01 00:00:00', 1, 68000.00, 15, '冯工', '直流供电设备', 'admin', '2026-01-12 00:01:08', '', '2026-01-12 00:01:08');
INSERT INTO `eq_device` VALUES (20, 'DEV-020', '直流屏2号', '直流屏', 'GZDW-50Ah/220V', 'ZLP-20210902', '许继电气', '直流室B区', '运维部', '2021-11-10 00:00:00', '2031-11-10 00:00:00', 1, 68000.00, 15, '冯工', '备用直流电源', 'admin', '2026-01-12 00:01:08', '', '2026-01-12 00:01:08');
INSERT INTO `eq_device` VALUES (21, 'WIND-FD001', '风力发电机组 FD001', '风力发电', 'FD001-GRU', 'FD001-SN', '风电场', '风电场一期', '运维部', '2024-06-01 00:00:00', '2034-06-01 00:00:00', 1, 3200000.00, 25, '运维', 'GRU 预测数据源设备（与 FD001.xlsx / predict.py 对应）', 'admin', '2026-03-29 00:00:00', '', '2026-03-29 00:00:00');

-- ----------------------------
-- Table structure for eq_device_param
-- ----------------------------
DROP TABLE IF EXISTS `eq_device_param`;
CREATE TABLE `eq_device_param`  (
  `param_id` bigint NOT NULL AUTO_INCREMENT COMMENT '参数ID',
  `device_id` bigint NOT NULL COMMENT '设备ID',
  `parameter_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '参数名称',
  `parameter_value` decimal(10, 4) NULL DEFAULT NULL COMMENT '参数值',
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '单位',
  `default_value` decimal(10, 4) NULL DEFAULT NULL COMMENT '默认值',
  `min_value` decimal(10, 4) NULL DEFAULT NULL COMMENT '最小值',
  `max_value` decimal(10, 4) NULL DEFAULT NULL COMMENT '最大值',
  `critical_threshold` decimal(10, 4) NULL DEFAULT NULL COMMENT '临界阈值',
  `warning_threshold` decimal(10, 4) NULL DEFAULT NULL COMMENT '警告阈值',
  `last_updated` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`param_id`) USING BTREE,
  UNIQUE INDEX `uk_device_parameter`(`device_id` ASC, `parameter_name` ASC) USING BTREE,
  INDEX `idx_device_parameter`(`device_id` ASC, `parameter_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 145 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '设备参数表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eq_device_param
-- ----------------------------
INSERT INTO `eq_device_param` VALUES (1, 1, '额定电压', 110.0000, 'kV', 110.0000, 105.0000, 115.0000, 118.0000, 116.0000, '2026-01-12 00:01:12', '设备额定电压', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (2, 2, '额定电压', 110.0000, 'kV', 110.0000, 105.0000, 115.0000, 118.0000, 116.0000, '2026-01-12 00:01:12', '设备额定电压', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (3, 3, '额定电压', 110.0000, 'kV', 110.0000, 105.0000, 115.0000, 118.0000, 116.0000, '2026-01-12 00:01:12', '设备额定电压', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (4, 4, '额定电压', 110.0000, 'kV', 110.0000, 105.0000, 115.0000, 118.0000, 116.0000, '2026-01-12 00:01:12', '设备额定电压', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (5, 5, '额定电压', 110.0000, 'kV', 110.0000, 105.0000, 115.0000, 118.0000, 116.0000, '2026-01-12 00:01:12', '设备额定电压', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (6, 6, '额定电压', 110.0000, 'kV', 110.0000, 105.0000, 115.0000, 118.0000, 116.0000, '2026-01-12 00:01:12', '设备额定电压', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (7, 7, '额定电压', 110.0000, 'kV', 110.0000, 105.0000, 115.0000, 118.0000, 116.0000, '2026-01-12 00:01:12', '设备额定电压', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (8, 8, '额定电压', 110.0000, 'kV', 110.0000, 105.0000, 115.0000, 118.0000, 116.0000, '2026-01-12 00:01:12', '设备额定电压', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (9, 9, '额定电压', 110.0000, 'kV', 110.0000, 105.0000, 115.0000, 118.0000, 116.0000, '2026-01-12 00:01:12', '设备额定电压', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (10, 10, '额定电压', 110.0000, 'kV', 110.0000, 105.0000, 115.0000, 118.0000, 116.0000, '2026-01-12 00:01:12', '设备额定电压', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (11, 11, '额定电压', 110.0000, 'kV', 110.0000, 105.0000, 115.0000, 118.0000, 116.0000, '2026-01-12 00:01:12', '设备额定电压', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (12, 12, '额定电压', 110.0000, 'kV', 110.0000, 105.0000, 115.0000, 118.0000, 116.0000, '2026-01-12 00:01:12', '设备额定电压', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (13, 13, '额定电压', 110.0000, 'kV', 110.0000, 105.0000, 115.0000, 118.0000, 116.0000, '2026-01-12 00:01:12', '设备额定电压', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (14, 14, '额定电压', 110.0000, 'kV', 110.0000, 105.0000, 115.0000, 118.0000, 116.0000, '2026-01-12 00:01:12', '设备额定电压', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (15, 15, '额定电压', 110.0000, 'kV', 110.0000, 105.0000, 115.0000, 118.0000, 116.0000, '2026-01-12 00:01:12', '设备额定电压', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (16, 16, '额定电压', 110.0000, 'kV', 110.0000, 105.0000, 115.0000, 118.0000, 116.0000, '2026-01-12 00:01:12', '设备额定电压', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (17, 17, '额定电压', 110.0000, 'kV', 110.0000, 105.0000, 115.0000, 118.0000, 116.0000, '2026-01-12 00:01:12', '设备额定电压', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (18, 18, '额定电压', 110.0000, 'kV', 110.0000, 105.0000, 115.0000, 118.0000, 116.0000, '2026-01-12 00:01:12', '设备额定电压', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (19, 19, '额定电压', 110.0000, 'kV', 110.0000, 105.0000, 115.0000, 118.0000, 116.0000, '2026-01-12 00:01:12', '设备额定电压', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (20, 20, '额定电压', 110.0000, 'kV', 110.0000, 105.0000, 115.0000, 118.0000, 116.0000, '2026-01-12 00:01:12', '设备额定电压', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (32, 1, '额定电流', 165.0000, 'A', 165.0000, 0.0000, 200.0000, 195.0000, 185.0000, '2026-01-12 00:01:12', '设备额定电流', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (33, 2, '额定电流', 165.0000, 'A', 165.0000, 0.0000, 200.0000, 195.0000, 185.0000, '2026-01-12 00:01:12', '设备额定电流', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (34, 3, '额定电流', 165.0000, 'A', 165.0000, 0.0000, 200.0000, 195.0000, 185.0000, '2026-01-12 00:01:12', '设备额定电流', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (35, 4, '额定电流', 165.0000, 'A', 165.0000, 0.0000, 200.0000, 195.0000, 185.0000, '2026-01-12 00:01:12', '设备额定电流', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (36, 5, '额定电流', 165.0000, 'A', 165.0000, 0.0000, 200.0000, 195.0000, 185.0000, '2026-01-12 00:01:12', '设备额定电流', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (37, 6, '额定电流', 165.0000, 'A', 165.0000, 0.0000, 200.0000, 195.0000, 185.0000, '2026-01-12 00:01:12', '设备额定电流', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (38, 7, '额定电流', 165.0000, 'A', 165.0000, 0.0000, 200.0000, 195.0000, 185.0000, '2026-01-12 00:01:12', '设备额定电流', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (39, 8, '额定电流', 165.0000, 'A', 165.0000, 0.0000, 200.0000, 195.0000, 185.0000, '2026-01-12 00:01:12', '设备额定电流', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (40, 9, '额定电流', 165.0000, 'A', 165.0000, 0.0000, 200.0000, 195.0000, 185.0000, '2026-01-12 00:01:12', '设备额定电流', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (41, 10, '额定电流', 165.0000, 'A', 165.0000, 0.0000, 200.0000, 195.0000, 185.0000, '2026-01-12 00:01:12', '设备额定电流', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (42, 11, '额定电流', 165.0000, 'A', 165.0000, 0.0000, 200.0000, 195.0000, 185.0000, '2026-01-12 00:01:12', '设备额定电流', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (43, 12, '额定电流', 165.0000, 'A', 165.0000, 0.0000, 200.0000, 195.0000, 185.0000, '2026-01-12 00:01:12', '设备额定电流', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (44, 13, '额定电流', 165.0000, 'A', 165.0000, 0.0000, 200.0000, 195.0000, 185.0000, '2026-01-12 00:01:12', '设备额定电流', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (45, 14, '额定电流', 165.0000, 'A', 165.0000, 0.0000, 200.0000, 195.0000, 185.0000, '2026-01-12 00:01:12', '设备额定电流', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (46, 15, '额定电流', 165.0000, 'A', 165.0000, 0.0000, 200.0000, 195.0000, 185.0000, '2026-01-12 00:01:12', '设备额定电流', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (47, 16, '额定电流', 165.0000, 'A', 165.0000, 0.0000, 200.0000, 195.0000, 185.0000, '2026-01-12 00:01:12', '设备额定电流', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (48, 17, '额定电流', 165.0000, 'A', 165.0000, 0.0000, 200.0000, 195.0000, 185.0000, '2026-01-12 00:01:12', '设备额定电流', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (49, 18, '额定电流', 165.0000, 'A', 165.0000, 0.0000, 200.0000, 195.0000, 185.0000, '2026-01-12 00:01:12', '设备额定电流', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (50, 19, '额定电流', 165.0000, 'A', 165.0000, 0.0000, 200.0000, 195.0000, 185.0000, '2026-01-12 00:01:12', '设备额定电流', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (51, 20, '额定电流', 165.0000, 'A', 165.0000, 0.0000, 200.0000, 195.0000, 185.0000, '2026-01-12 00:01:12', '设备额定电流', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (63, 1, '额定功率', 18.0000, 'MW', 18.0000, 0.0000, 25.0000, 24.0000, 22.0000, '2026-01-12 00:01:12', '设备额定功率', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (64, 2, '额定功率', 18.0000, 'MW', 18.0000, 0.0000, 25.0000, 24.0000, 22.0000, '2026-01-12 00:01:12', '设备额定功率', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (65, 3, '额定功率', 18.0000, 'MW', 18.0000, 0.0000, 25.0000, 24.0000, 22.0000, '2026-01-12 00:01:12', '设备额定功率', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (66, 4, '额定功率', 18.0000, 'MW', 18.0000, 0.0000, 25.0000, 24.0000, 22.0000, '2026-01-12 00:01:12', '设备额定功率', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (67, 5, '额定功率', 18.0000, 'MW', 18.0000, 0.0000, 25.0000, 24.0000, 22.0000, '2026-01-12 00:01:12', '设备额定功率', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (68, 6, '额定功率', 18.0000, 'MW', 18.0000, 0.0000, 25.0000, 24.0000, 22.0000, '2026-01-12 00:01:12', '设备额定功率', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (69, 7, '额定功率', 18.0000, 'MW', 18.0000, 0.0000, 25.0000, 24.0000, 22.0000, '2026-01-12 00:01:12', '设备额定功率', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (70, 8, '额定功率', 18.0000, 'MW', 18.0000, 0.0000, 25.0000, 24.0000, 22.0000, '2026-01-12 00:01:12', '设备额定功率', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (71, 9, '额定功率', 18.0000, 'MW', 18.0000, 0.0000, 25.0000, 24.0000, 22.0000, '2026-01-12 00:01:12', '设备额定功率', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (72, 10, '额定功率', 18.0000, 'MW', 18.0000, 0.0000, 25.0000, 24.0000, 22.0000, '2026-01-12 00:01:12', '设备额定功率', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (73, 11, '额定功率', 18.0000, 'MW', 18.0000, 0.0000, 25.0000, 24.0000, 22.0000, '2026-01-12 00:01:12', '设备额定功率', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (74, 12, '额定功率', 18.0000, 'MW', 18.0000, 0.0000, 25.0000, 24.0000, 22.0000, '2026-01-12 00:01:12', '设备额定功率', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (75, 13, '额定功率', 18.0000, 'MW', 18.0000, 0.0000, 25.0000, 24.0000, 22.0000, '2026-01-12 00:01:12', '设备额定功率', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (76, 14, '额定功率', 18.0000, 'MW', 18.0000, 0.0000, 25.0000, 24.0000, 22.0000, '2026-01-12 00:01:12', '设备额定功率', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (77, 15, '额定功率', 18.0000, 'MW', 18.0000, 0.0000, 25.0000, 24.0000, 22.0000, '2026-01-12 00:01:12', '设备额定功率', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (78, 16, '额定功率', 18.0000, 'MW', 18.0000, 0.0000, 25.0000, 24.0000, 22.0000, '2026-01-12 00:01:12', '设备额定功率', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (79, 17, '额定功率', 18.0000, 'MW', 18.0000, 0.0000, 25.0000, 24.0000, 22.0000, '2026-01-12 00:01:12', '设备额定功率', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (80, 18, '额定功率', 18.0000, 'MW', 18.0000, 0.0000, 25.0000, 24.0000, 22.0000, '2026-01-12 00:01:12', '设备额定功率', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (81, 19, '额定功率', 18.0000, 'MW', 18.0000, 0.0000, 25.0000, 24.0000, 22.0000, '2026-01-12 00:01:12', '设备额定功率', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (82, 20, '额定功率', 18.0000, 'MW', 18.0000, 0.0000, 25.0000, 24.0000, 22.0000, '2026-01-12 00:01:12', '设备额定功率', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (94, 1, '工作温度', 65.0000, '℃', 65.0000, -10.0000, 85.0000, 90.0000, 80.0000, '2026-01-12 00:01:12', '设备工作温度', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (95, 2, '工作温度', 65.0000, '℃', 65.0000, -10.0000, 85.0000, 90.0000, 80.0000, '2026-01-12 00:01:12', '设备工作温度', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (96, 3, '工作温度', 65.0000, '℃', 65.0000, -10.0000, 85.0000, 90.0000, 80.0000, '2026-01-12 00:01:12', '设备工作温度', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (97, 4, '工作温度', 65.0000, '℃', 65.0000, -10.0000, 85.0000, 90.0000, 80.0000, '2026-01-12 00:01:12', '设备工作温度', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (98, 5, '工作温度', 65.0000, '℃', 65.0000, -10.0000, 85.0000, 90.0000, 80.0000, '2026-01-12 00:01:12', '设备工作温度', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (99, 6, '工作温度', 65.0000, '℃', 65.0000, -10.0000, 85.0000, 90.0000, 80.0000, '2026-01-12 00:01:12', '设备工作温度', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (100, 7, '工作温度', 65.0000, '℃', 65.0000, -10.0000, 85.0000, 90.0000, 80.0000, '2026-01-12 00:01:12', '设备工作温度', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (101, 8, '工作温度', 65.0000, '℃', 65.0000, -10.0000, 85.0000, 90.0000, 80.0000, '2026-01-12 00:01:12', '设备工作温度', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (102, 9, '工作温度', 65.0000, '℃', 65.0000, -10.0000, 85.0000, 90.0000, 80.0000, '2026-01-12 00:01:12', '设备工作温度', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (103, 10, '工作温度', 65.0000, '℃', 65.0000, -10.0000, 85.0000, 90.0000, 80.0000, '2026-01-12 00:01:12', '设备工作温度', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (104, 11, '工作温度', 65.0000, '℃', 65.0000, -10.0000, 85.0000, 90.0000, 80.0000, '2026-01-12 00:01:12', '设备工作温度', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (105, 12, '工作温度', 65.0000, '℃', 65.0000, -10.0000, 85.0000, 90.0000, 80.0000, '2026-01-12 00:01:12', '设备工作温度', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (106, 13, '工作温度', 65.0000, '℃', 65.0000, -10.0000, 85.0000, 90.0000, 80.0000, '2026-01-12 00:01:12', '设备工作温度', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (107, 14, '工作温度', 65.0000, '℃', 65.0000, -10.0000, 85.0000, 90.0000, 80.0000, '2026-01-12 00:01:12', '设备工作温度', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (108, 15, '工作温度', 65.0000, '℃', 65.0000, -10.0000, 85.0000, 90.0000, 80.0000, '2026-01-12 00:01:12', '设备工作温度', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (109, 16, '工作温度', 65.0000, '℃', 65.0000, -10.0000, 85.0000, 90.0000, 80.0000, '2026-01-12 00:01:12', '设备工作温度', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (110, 17, '工作温度', 65.0000, '℃', 65.0000, -10.0000, 85.0000, 90.0000, 80.0000, '2026-01-12 00:01:12', '设备工作温度', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (111, 18, '工作温度', 65.0000, '℃', 65.0000, -10.0000, 85.0000, 90.0000, 80.0000, '2026-01-12 00:01:12', '设备工作温度', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (112, 19, '工作温度', 65.0000, '℃', 65.0000, -10.0000, 85.0000, 90.0000, 80.0000, '2026-01-12 00:01:12', '设备工作温度', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (113, 20, '工作温度', 65.0000, '℃', 65.0000, -10.0000, 85.0000, 90.0000, 80.0000, '2026-01-12 00:01:12', '设备工作温度', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (125, 1, '绝缘电阻', 1000.0000, 'MΩ', 1000.0000, 500.0000, 5000.0000, 400.0000, 500.0000, '2026-01-12 00:01:12', '绝缘电阻值', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (126, 2, '绝缘电阻', 1000.0000, 'MΩ', 1000.0000, 500.0000, 5000.0000, 400.0000, 500.0000, '2026-01-12 00:01:12', '绝缘电阻值', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (127, 3, '绝缘电阻', 1000.0000, 'MΩ', 1000.0000, 500.0000, 5000.0000, 400.0000, 500.0000, '2026-01-12 00:01:12', '绝缘电阻值', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (128, 4, '绝缘电阻', 1000.0000, 'MΩ', 1000.0000, 500.0000, 5000.0000, 400.0000, 500.0000, '2026-01-12 00:01:12', '绝缘电阻值', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (129, 5, '绝缘电阻', 1000.0000, 'MΩ', 1000.0000, 500.0000, 5000.0000, 400.0000, 500.0000, '2026-01-12 00:01:12', '绝缘电阻值', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (130, 6, '绝缘电阻', 1000.0000, 'MΩ', 1000.0000, 500.0000, 5000.0000, 400.0000, 500.0000, '2026-01-12 00:01:12', '绝缘电阻值', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (131, 7, '绝缘电阻', 1000.0000, 'MΩ', 1000.0000, 500.0000, 5000.0000, 400.0000, 500.0000, '2026-01-12 00:01:12', '绝缘电阻值', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (132, 8, '绝缘电阻', 1000.0000, 'MΩ', 1000.0000, 500.0000, 5000.0000, 400.0000, 500.0000, '2026-01-12 00:01:12', '绝缘电阻值', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (133, 9, '绝缘电阻', 1000.0000, 'MΩ', 1000.0000, 500.0000, 5000.0000, 400.0000, 500.0000, '2026-01-12 00:01:12', '绝缘电阻值', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (134, 10, '绝缘电阻', 1000.0000, 'MΩ', 1000.0000, 500.0000, 5000.0000, 400.0000, 500.0000, '2026-01-12 00:01:12', '绝缘电阻值', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (135, 11, '绝缘电阻', 1000.0000, 'MΩ', 1000.0000, 500.0000, 5000.0000, 400.0000, 500.0000, '2026-01-12 00:01:12', '绝缘电阻值', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (136, 12, '绝缘电阻', 1000.0000, 'MΩ', 1000.0000, 500.0000, 5000.0000, 400.0000, 500.0000, '2026-01-12 00:01:12', '绝缘电阻值', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (137, 13, '绝缘电阻', 1000.0000, 'MΩ', 1000.0000, 500.0000, 5000.0000, 400.0000, 500.0000, '2026-01-12 00:01:12', '绝缘电阻值', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (138, 14, '绝缘电阻', 1000.0000, 'MΩ', 1000.0000, 500.0000, 5000.0000, 400.0000, 500.0000, '2026-01-12 00:01:12', '绝缘电阻值', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (139, 15, '绝缘电阻', 1000.0000, 'MΩ', 1000.0000, 500.0000, 5000.0000, 400.0000, 500.0000, '2026-01-12 00:01:12', '绝缘电阻值', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (140, 16, '绝缘电阻', 1000.0000, 'MΩ', 1000.0000, 500.0000, 5000.0000, 400.0000, 500.0000, '2026-01-12 00:01:12', '绝缘电阻值', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (141, 17, '绝缘电阻', 1000.0000, 'MΩ', 1000.0000, 500.0000, 5000.0000, 400.0000, 500.0000, '2026-01-12 00:01:12', '绝缘电阻值', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (142, 18, '绝缘电阻', 1000.0000, 'MΩ', 1000.0000, 500.0000, 5000.0000, 400.0000, 500.0000, '2026-01-12 00:01:12', '绝缘电阻值', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (143, 19, '绝缘电阻', 1000.0000, 'MΩ', 1000.0000, 500.0000, 5000.0000, 400.0000, 500.0000, '2026-01-12 00:01:12', '绝缘电阻值', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (144, 20, '绝缘电阻', 1000.0000, 'MΩ', 1000.0000, 500.0000, 5000.0000, 400.0000, 500.0000, '2026-01-12 00:01:12', '绝缘电阻值', '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');

-- ----------------------------
-- Table structure for eq_device_rule
-- ----------------------------
DROP TABLE IF EXISTS `eq_device_rule`;
CREATE TABLE `eq_device_rule`  (
  `rule_id` bigint NOT NULL AUTO_INCREMENT COMMENT '规则ID',
  `device_id` bigint NULL DEFAULT NULL COMMENT '设备ID',
  `rule_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '规则名称',
  `parameter_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '参数名称',
  `condition_type` int NULL DEFAULT NULL COMMENT '条件类型1大于 2小于 3等于 4区间',
  `threshold_value` decimal(18, 2) NULL DEFAULT NULL COMMENT '阈值',
  `threshold_unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '阈值单位',
  `alert_level` int NULL DEFAULT NULL COMMENT '报警等级 1警报 2严重 3紧急',
  `enabled` int NULL DEFAULT NULL COMMENT '是否启用 1启用 0禁用',
  `notification_channels` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '通知渠道',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`rule_id`) USING BTREE,
  INDEX `idx_device_id`(`device_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 83 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '设备规则表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eq_device_rule
-- ----------------------------
INSERT INTO `eq_device_rule` VALUES (1, 1, '温度超限规则', '温度', 1, 85.00, '℃', 2, 1, '短信,邮件', NULL);
INSERT INTO `eq_device_rule` VALUES (2, 2, '温度超限规则', '温度', 1, 85.00, '℃', 2, 1, '短信,邮件', NULL);
INSERT INTO `eq_device_rule` VALUES (3, 3, '温度超限规则', '温度', 1, 85.00, '℃', 2, 1, '短信,邮件', NULL);
INSERT INTO `eq_device_rule` VALUES (4, 4, '温度超限规则', '温度', 1, 85.00, '℃', 2, 1, '短信,邮件', NULL);
INSERT INTO `eq_device_rule` VALUES (5, 5, '温度超限规则', '温度', 1, 85.00, '℃', 2, 1, '短信,邮件', NULL);
INSERT INTO `eq_device_rule` VALUES (6, 6, '温度超限规则', '温度', 1, 85.00, '℃', 2, 1, '短信,邮件', NULL);
INSERT INTO `eq_device_rule` VALUES (7, 7, '温度超限规则', '温度', 1, 85.00, '℃', 2, 1, '短信,邮件', NULL);
INSERT INTO `eq_device_rule` VALUES (8, 8, '温度超限规则', '温度', 1, 85.00, '℃', 2, 1, '短信,邮件', NULL);
INSERT INTO `eq_device_rule` VALUES (9, 9, '温度超限规则', '温度', 1, 85.00, '℃', 2, 1, '短信,邮件', NULL);
INSERT INTO `eq_device_rule` VALUES (10, 10, '温度超限规则', '温度', 1, 85.00, '℃', 2, 1, '短信,邮件', NULL);
INSERT INTO `eq_device_rule` VALUES (11, 11, '温度超限规则', '温度', 1, 85.00, '℃', 2, 1, '短信,邮件', NULL);
INSERT INTO `eq_device_rule` VALUES (12, 12, '温度超限规则', '温度', 1, 85.00, '℃', 2, 1, '短信,邮件', NULL);
INSERT INTO `eq_device_rule` VALUES (13, 13, '温度超限规则', '温度', 1, 85.00, '℃', 2, 1, '短信,邮件', NULL);
INSERT INTO `eq_device_rule` VALUES (14, 14, '温度超限规则', '温度', 1, 85.00, '℃', 2, 1, '短信,邮件', NULL);
INSERT INTO `eq_device_rule` VALUES (15, 15, '温度超限规则', '温度', 1, 85.00, '℃', 2, 1, '短信,邮件', NULL);
INSERT INTO `eq_device_rule` VALUES (16, 16, '温度超限规则', '温度', 1, 85.00, '℃', 2, 1, '短信,邮件', NULL);
INSERT INTO `eq_device_rule` VALUES (17, 17, '温度超限规则', '温度', 1, 85.00, '℃', 2, 1, '短信,邮件', NULL);
INSERT INTO `eq_device_rule` VALUES (18, 18, '温度超限规则', '温度', 1, 85.00, '℃', 2, 1, '短信,邮件', NULL);
INSERT INTO `eq_device_rule` VALUES (19, 19, '温度超限规则', '温度', 1, 85.00, '℃', 2, 1, '短信,邮件', NULL);
INSERT INTO `eq_device_rule` VALUES (20, 20, '温度超限规则', '温度', 1, 85.00, '℃', 2, 1, '短信,邮件', NULL);
INSERT INTO `eq_device_rule` VALUES (32, 1, '电流过载规则', '电流', 1, 200.00, 'A', 3, 1, '短信,邮件,电话', NULL);
INSERT INTO `eq_device_rule` VALUES (33, 2, '电流过载规则', '电流', 1, 200.00, 'A', 3, 1, '短信,邮件,电话', NULL);
INSERT INTO `eq_device_rule` VALUES (34, 3, '电流过载规则', '电流', 1, 200.00, 'A', 3, 1, '短信,邮件,电话', NULL);
INSERT INTO `eq_device_rule` VALUES (35, 4, '电流过载规则', '电流', 1, 200.00, 'A', 3, 1, '短信,邮件,电话', NULL);
INSERT INTO `eq_device_rule` VALUES (36, 5, '电流过载规则', '电流', 1, 200.00, 'A', 3, 1, '短信,邮件,电话', NULL);
INSERT INTO `eq_device_rule` VALUES (37, 6, '电流过载规则', '电流', 1, 200.00, 'A', 3, 1, '短信,邮件,电话', NULL);
INSERT INTO `eq_device_rule` VALUES (38, 7, '电流过载规则', '电流', 1, 200.00, 'A', 3, 1, '短信,邮件,电话', NULL);
INSERT INTO `eq_device_rule` VALUES (39, 8, '电流过载规则', '电流', 1, 200.00, 'A', 3, 1, '短信,邮件,电话', NULL);
INSERT INTO `eq_device_rule` VALUES (40, 9, '电流过载规则', '电流', 1, 200.00, 'A', 3, 1, '短信,邮件,电话', NULL);
INSERT INTO `eq_device_rule` VALUES (41, 10, '电流过载规则', '电流', 1, 200.00, 'A', 3, 1, '短信,邮件,电话', NULL);
INSERT INTO `eq_device_rule` VALUES (42, 11, '电流过载规则', '电流', 1, 200.00, 'A', 3, 1, '短信,邮件,电话', NULL);
INSERT INTO `eq_device_rule` VALUES (43, 12, '电流过载规则', '电流', 1, 200.00, 'A', 3, 1, '短信,邮件,电话', NULL);
INSERT INTO `eq_device_rule` VALUES (44, 13, '电流过载规则', '电流', 1, 200.00, 'A', 3, 1, '短信,邮件,电话', NULL);
INSERT INTO `eq_device_rule` VALUES (45, 14, '电流过载规则', '电流', 1, 200.00, 'A', 3, 1, '短信,邮件,电话', NULL);
INSERT INTO `eq_device_rule` VALUES (46, 15, '电流过载规则', '电流', 1, 200.00, 'A', 3, 1, '短信,邮件,电话', NULL);
INSERT INTO `eq_device_rule` VALUES (47, 16, '电流过载规则', '电流', 1, 200.00, 'A', 3, 1, '短信,邮件,电话', NULL);
INSERT INTO `eq_device_rule` VALUES (48, 17, '电流过载规则', '电流', 1, 200.00, 'A', 3, 1, '短信,邮件,电话', NULL);
INSERT INTO `eq_device_rule` VALUES (49, 18, '电流过载规则', '电流', 1, 200.00, 'A', 3, 1, '短信,邮件,电话', NULL);
INSERT INTO `eq_device_rule` VALUES (50, 19, '电流过载规则', '电流', 1, 200.00, 'A', 3, 1, '短信,邮件,电话', NULL);
INSERT INTO `eq_device_rule` VALUES (51, 20, '电流过载规则', '电流', 1, 200.00, 'A', 3, 1, '短信,邮件,电话', NULL);
INSERT INTO `eq_device_rule` VALUES (63, 1, '电压异常规则', '电压', 4, 110.00, 'kV', 2, 1, '短信', NULL);
INSERT INTO `eq_device_rule` VALUES (64, 2, '电压异常规则', '电压', 4, 110.00, 'kV', 2, 1, '短信', NULL);
INSERT INTO `eq_device_rule` VALUES (65, 3, '电压异常规则', '电压', 4, 110.00, 'kV', 2, 1, '短信', NULL);
INSERT INTO `eq_device_rule` VALUES (66, 4, '电压异常规则', '电压', 4, 110.00, 'kV', 2, 1, '短信', NULL);
INSERT INTO `eq_device_rule` VALUES (67, 5, '电压异常规则', '电压', 4, 110.00, 'kV', 2, 1, '短信', NULL);
INSERT INTO `eq_device_rule` VALUES (68, 6, '电压异常规则', '电压', 4, 110.00, 'kV', 2, 1, '短信', NULL);
INSERT INTO `eq_device_rule` VALUES (69, 7, '电压异常规则', '电压', 4, 110.00, 'kV', 2, 1, '短信', NULL);
INSERT INTO `eq_device_rule` VALUES (70, 8, '电压异常规则', '电压', 4, 110.00, 'kV', 2, 1, '短信', NULL);
INSERT INTO `eq_device_rule` VALUES (71, 9, '电压异常规则', '电压', 4, 110.00, 'kV', 2, 1, '短信', NULL);
INSERT INTO `eq_device_rule` VALUES (72, 10, '电压异常规则', '电压', 4, 110.00, 'kV', 2, 1, '短信', NULL);
INSERT INTO `eq_device_rule` VALUES (73, 11, '电压异常规则', '电压', 4, 110.00, 'kV', 2, 1, '短信', NULL);
INSERT INTO `eq_device_rule` VALUES (74, 12, '电压异常规则', '电压', 4, 110.00, 'kV', 2, 1, '短信', NULL);
INSERT INTO `eq_device_rule` VALUES (75, 13, '电压异常规则', '电压', 4, 110.00, 'kV', 2, 1, '短信', NULL);
INSERT INTO `eq_device_rule` VALUES (76, 14, '电压异常规则', '电压', 4, 110.00, 'kV', 2, 1, '短信', NULL);
INSERT INTO `eq_device_rule` VALUES (77, 15, '电压异常规则', '电压', 4, 110.00, 'kV', 2, 1, '短信', NULL);
INSERT INTO `eq_device_rule` VALUES (78, 16, '电压异常规则', '电压', 4, 110.00, 'kV', 2, 1, '短信', NULL);
INSERT INTO `eq_device_rule` VALUES (79, 17, '电压异常规则', '电压', 4, 110.00, 'kV', 2, 1, '短信', NULL);
INSERT INTO `eq_device_rule` VALUES (80, 18, '电压异常规则', '电压', 4, 110.00, 'kV', 2, 1, '短信', NULL);
INSERT INTO `eq_device_rule` VALUES (81, 19, '电压异常规则', '电压', 4, 110.00, 'kV', 2, 1, '短信', NULL);
INSERT INTO `eq_device_rule` VALUES (82, 20, '电压异常规则', '电压', 4, 110.00, 'kV', 2, 1, '短信', NULL);

-- ----------------------------
-- Table structure for eq_device_stat
-- ----------------------------
DROP TABLE IF EXISTS `eq_device_stat`;
CREATE TABLE `eq_device_stat`  (
  `stat_id` bigint NOT NULL AUTO_INCREMENT COMMENT '统计ID',
  `device_id` bigint NOT NULL COMMENT '设备ID',
  `stat_date` date NOT NULL COMMENT '统计日期',
  `total_runtime_hours` decimal(10, 2) NULL DEFAULT NULL COMMENT '总运行小时数',
  `total_fault_count` int NULL DEFAULT NULL COMMENT '总故障次数',
  `total_maintenance_count` int NULL DEFAULT NULL COMMENT '总维护次数',
  `average_temperature` decimal(10, 2) NULL DEFAULT NULL COMMENT '平均温度(°C)',
  `maximum_temperature` decimal(10, 2) NULL DEFAULT NULL COMMENT '最高温度(°C)',
  `minimum_temperature` decimal(10, 2) NULL DEFAULT NULL COMMENT '最低温度(°C)',
  `average_power` decimal(10, 4) NULL DEFAULT NULL COMMENT '平均功率(kW)',
  `uptime_percentage` decimal(5, 2) NULL DEFAULT NULL COMMENT '运行率(%)',
  `downtime_minutes` int NULL DEFAULT NULL COMMENT '停机分钟数',
  `maintenance_cost` decimal(10, 2) NULL DEFAULT NULL COMMENT '维护成本',
  `fault_rate_per_hour` decimal(10, 4) NULL DEFAULT NULL COMMENT '故障率(次/小时)',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`stat_id`) USING BTREE,
  UNIQUE INDEX `uk_device_date`(`device_id` ASC, `stat_date` ASC) USING BTREE,
  INDEX `idx_device_date`(`device_id` ASC, `stat_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 141 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '设备统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eq_device_stat
-- ----------------------------
INSERT INTO `eq_device_stat` VALUES (1, 1, '2026-01-06', 20.40, 2, 0, 67.50, 81.50, 53.30, 17.8000, 98.00, 80, 737.83, 0.0059, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (2, 1, '2026-01-07', 22.40, 0, 0, 70.20, 79.20, 50.10, 16.9000, 95.60, 118, 1559.42, 0.0068, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (3, 1, '2026-01-08', 23.20, 0, 1, 60.60, 75.60, 57.30, 19.3000, 97.00, 103, 2167.06, 0.0058, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (4, 1, '2026-01-09', 21.50, 0, 1, 62.60, 79.90, 57.60, 21.6000, 98.40, 92, 1142.14, 0.0028, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (5, 1, '2026-01-10', 21.80, 1, 1, 70.70, 82.60, 50.60, 21.4000, 98.30, 81, 2399.56, 0.0071, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (6, 1, '2026-01-11', 22.80, 1, 1, 61.00, 77.30, 52.40, 21.0000, 95.10, 98, 608.81, 0.0082, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (7, 1, '2026-01-12', 23.70, 0, 1, 64.00, 78.00, 58.60, 20.5000, 98.40, 20, 1174.30, 0.0016, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (8, 2, '2026-01-06', 23.20, 1, 0, 60.40, 72.00, 55.70, 18.7000, 97.40, 69, 752.48, 0.0089, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (9, 2, '2026-01-07', 20.20, 1, 0, 63.60, 71.60, 58.20, 21.1000, 96.40, 56, 1078.76, 0.0004, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (10, 2, '2026-01-08', 21.40, 1, 0, 64.40, 75.80, 50.60, 16.1000, 97.10, 21, 1135.56, 0.0006, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (11, 2, '2026-01-09', 21.40, 1, 0, 62.70, 83.10, 58.40, 19.6000, 96.40, 7, 981.24, 0.0001, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (12, 2, '2026-01-10', 21.40, 2, 0, 62.10, 75.20, 53.20, 19.5000, 98.30, 56, 2264.60, 0.0099, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (13, 2, '2026-01-11', 21.20, 1, 1, 64.90, 74.10, 53.90, 16.1000, 97.00, 9, 2315.71, 0.0030, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (14, 2, '2026-01-12', 23.10, 2, 1, 62.00, 81.90, 55.90, 19.3000, 98.80, 15, 2101.81, 0.0061, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (15, 3, '2026-01-06', 22.60, 1, 0, 71.90, 74.50, 51.10, 20.3000, 99.00, 117, 2317.04, 0.0061, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (16, 3, '2026-01-07', 21.20, 2, 1, 72.50, 76.20, 55.60, 19.4000, 95.20, 76, 529.30, 0.0017, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (17, 3, '2026-01-08', 23.20, 1, 0, 68.50, 82.70, 55.10, 15.2000, 97.50, 119, 756.54, 0.0065, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (18, 3, '2026-01-09', 23.50, 1, 0, 61.40, 70.80, 59.80, 21.1000, 98.40, 115, 1005.09, 0.0039, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (19, 3, '2026-01-10', 20.70, 2, 1, 73.10, 75.50, 52.30, 15.5000, 97.30, 90, 539.42, 0.0083, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (20, 3, '2026-01-11', 20.40, 0, 1, 64.80, 83.80, 56.50, 18.8000, 96.70, 86, 1105.66, 0.0036, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (21, 3, '2026-01-12', 23.60, 1, 0, 62.10, 73.30, 56.80, 20.9000, 97.60, 9, 1311.10, 0.0080, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (22, 4, '2026-01-06', 23.10, 1, 0, 70.70, 77.30, 52.90, 15.0000, 95.60, 84, 713.10, 0.0041, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (23, 4, '2026-01-07', 22.90, 1, 1, 65.60, 71.30, 53.10, 17.3000, 96.90, 70, 1436.30, 0.0058, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (24, 4, '2026-01-08', 22.10, 2, 1, 66.20, 74.80, 53.70, 22.2000, 96.40, 13, 1440.17, 0.0002, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (25, 4, '2026-01-09', 22.80, 1, 0, 68.30, 73.10, 53.80, 17.1000, 95.80, 27, 1571.04, 0.0098, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (26, 4, '2026-01-10', 21.20, 1, 0, 64.30, 75.90, 51.20, 18.2000, 97.60, 6, 1159.84, 0.0048, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (27, 4, '2026-01-11', 21.60, 1, 1, 60.90, 84.90, 57.90, 22.6000, 96.50, 2, 2448.28, 0.0082, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (28, 4, '2026-01-12', 20.70, 1, 0, 63.90, 82.30, 53.20, 16.0000, 97.60, 113, 1967.46, 0.0084, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (29, 5, '2026-01-06', 23.90, 1, 0, 64.30, 71.80, 57.40, 17.8000, 97.10, 65, 831.19, 0.0020, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (30, 5, '2026-01-07', 21.90, 2, 1, 74.90, 83.30, 54.60, 19.9000, 97.90, 86, 1398.29, 0.0009, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (31, 5, '2026-01-08', 20.40, 0, 0, 67.30, 73.80, 57.90, 16.5000, 97.40, 47, 859.44, 0.0072, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (32, 5, '2026-01-09', 20.30, 0, 1, 73.40, 76.20, 53.70, 20.0000, 95.00, 19, 2108.37, 0.0052, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (33, 5, '2026-01-10', 20.80, 1, 1, 67.10, 70.40, 56.90, 18.0000, 98.30, 113, 1061.06, 0.0057, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (34, 5, '2026-01-11', 24.00, 0, 0, 60.60, 71.50, 53.80, 19.7000, 98.10, 17, 1253.70, 0.0046, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (35, 5, '2026-01-12', 20.70, 1, 1, 64.10, 73.20, 52.50, 19.7000, 95.80, 25, 1449.90, 0.0074, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (36, 6, '2026-01-06', 21.10, 0, 1, 67.50, 77.40, 59.60, 17.6000, 98.00, 87, 1333.34, 0.0090, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (37, 6, '2026-01-07', 21.10, 1, 0, 66.30, 75.10, 54.60, 17.3000, 95.20, 41, 1711.67, 0.0099, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (38, 6, '2026-01-08', 20.60, 2, 0, 63.80, 75.80, 51.50, 19.9000, 97.30, 11, 1962.55, 0.0037, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (39, 6, '2026-01-09', 22.50, 0, 0, 63.60, 80.50, 58.00, 22.1000, 95.10, 53, 828.94, 0.0049, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (40, 6, '2026-01-10', 23.80, 0, 1, 73.50, 72.50, 51.40, 16.6000, 97.40, 40, 2373.43, 0.0066, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (41, 6, '2026-01-11', 21.90, 1, 1, 66.50, 83.70, 52.60, 19.5000, 95.20, 66, 1736.02, 0.0043, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (42, 6, '2026-01-12', 21.10, 0, 1, 60.50, 77.00, 52.50, 21.6000, 96.50, 49, 2371.22, 0.0044, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (43, 7, '2026-01-06', 21.60, 1, 0, 62.80, 83.00, 57.80, 17.4000, 95.60, 97, 1759.71, 0.0072, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (44, 7, '2026-01-07', 22.90, 1, 1, 63.70, 78.20, 50.10, 18.2000, 98.90, 83, 1575.41, 0.0060, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (45, 7, '2026-01-08', 21.60, 0, 1, 68.50, 70.10, 53.20, 19.8000, 95.20, 50, 2418.26, 0.0054, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (46, 7, '2026-01-09', 23.30, 1, 1, 73.40, 83.60, 58.40, 18.8000, 98.50, 113, 717.98, 0.0070, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (47, 7, '2026-01-10', 20.70, 2, 1, 62.40, 73.40, 56.60, 20.0000, 95.50, 92, 1468.18, 0.0010, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (48, 7, '2026-01-11', 20.20, 2, 1, 74.70, 73.40, 52.00, 17.5000, 98.70, 91, 2497.11, 0.0071, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (49, 7, '2026-01-12', 22.20, 1, 0, 61.90, 77.10, 59.80, 18.8000, 96.80, 102, 2301.63, 0.0094, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (50, 8, '2026-01-06', 23.90, 0, 1, 73.00, 76.00, 54.10, 21.7000, 98.80, 27, 1080.12, 0.0077, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (51, 8, '2026-01-07', 20.00, 2, 0, 74.20, 78.20, 58.90, 21.4000, 96.30, 32, 1171.08, 0.0088, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (52, 8, '2026-01-08', 21.50, 0, 0, 63.50, 77.90, 59.40, 16.0000, 98.30, 90, 1070.77, 0.0016, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (53, 8, '2026-01-09', 23.80, 0, 1, 60.30, 75.40, 57.40, 19.9000, 98.50, 58, 2162.33, 0.0070, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (54, 8, '2026-01-10', 24.00, 2, 0, 74.10, 82.20, 52.40, 21.2000, 95.50, 40, 1093.12, 0.0047, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (55, 8, '2026-01-11', 21.80, 2, 0, 67.20, 74.80, 51.60, 21.7000, 97.70, 112, 1739.92, 0.0029, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (56, 8, '2026-01-12', 22.40, 0, 1, 63.40, 75.00, 59.70, 21.8000, 96.40, 22, 2286.03, 0.0090, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (57, 9, '2026-01-06', 23.30, 1, 1, 74.10, 71.30, 56.20, 21.6000, 96.20, 117, 2493.38, 0.0006, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (58, 9, '2026-01-07', 21.20, 0, 1, 64.40, 78.00, 57.90, 17.8000, 96.60, 109, 1247.28, 0.0013, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (59, 9, '2026-01-08', 22.20, 1, 0, 68.90, 78.30, 59.90, 17.4000, 97.10, 80, 2160.71, 0.0013, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (60, 9, '2026-01-09', 20.60, 1, 1, 68.70, 73.10, 53.10, 22.3000, 97.60, 54, 1239.32, 0.0048, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (61, 9, '2026-01-10', 21.10, 2, 1, 70.10, 80.00, 53.20, 19.8000, 95.20, 50, 2464.85, 0.0064, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (62, 9, '2026-01-11', 21.00, 0, 1, 64.90, 71.10, 53.70, 20.0000, 95.10, 27, 656.82, 0.0071, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (63, 9, '2026-01-12', 21.20, 1, 0, 66.90, 83.40, 50.80, 20.9000, 96.80, 0, 1893.70, 0.0046, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (64, 10, '2026-01-06', 20.90, 2, 0, 66.10, 79.10, 58.20, 17.3000, 98.80, 107, 1800.50, 0.0055, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (65, 10, '2026-01-07', 23.20, 1, 0, 63.80, 82.40, 53.70, 18.0000, 98.10, 90, 1359.81, 0.0089, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (66, 10, '2026-01-08', 20.70, 0, 0, 68.20, 76.80, 56.40, 21.5000, 95.70, 50, 1671.26, 0.0066, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (67, 10, '2026-01-09', 22.30, 2, 0, 70.10, 71.40, 54.30, 21.9000, 95.10, 61, 1500.75, 0.0097, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (68, 10, '2026-01-10', 21.40, 2, 0, 60.00, 80.80, 55.80, 21.1000, 95.30, 8, 749.11, 0.0042, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (69, 10, '2026-01-11', 22.90, 0, 0, 64.30, 71.50, 56.30, 21.9000, 96.60, 53, 504.08, 0.0068, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (70, 10, '2026-01-12', 21.60, 2, 1, 70.70, 70.90, 51.50, 19.7000, 96.80, 63, 1043.90, 0.0078, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (71, 11, '2026-01-06', 20.30, 0, 1, 67.90, 83.10, 58.00, 17.8000, 96.40, 89, 1824.18, 0.0007, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (72, 11, '2026-01-07', 21.40, 1, 1, 69.50, 73.10, 51.50, 16.0000, 95.60, 51, 1810.81, 0.0100, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (73, 11, '2026-01-08', 20.10, 0, 1, 60.00, 83.80, 55.90, 16.5000, 95.60, 27, 1890.86, 0.0078, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (74, 11, '2026-01-09', 23.20, 2, 1, 71.50, 84.30, 54.80, 19.3000, 96.00, 77, 1418.71, 0.0037, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (75, 11, '2026-01-10', 21.80, 0, 1, 67.90, 81.20, 51.60, 19.6000, 96.50, 16, 1663.88, 0.0049, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (76, 11, '2026-01-11', 22.90, 0, 0, 69.80, 71.30, 54.80, 16.1000, 95.90, 82, 2063.59, 0.0085, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (77, 11, '2026-01-12', 23.60, 2, 0, 64.80, 82.20, 51.00, 15.6000, 95.30, 14, 1261.87, 0.0055, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (78, 12, '2026-01-06', 22.50, 1, 0, 64.70, 78.80, 59.90, 16.7000, 95.40, 99, 2207.42, 0.0079, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (79, 12, '2026-01-07', 21.50, 1, 0, 73.10, 78.80, 53.10, 21.4000, 95.30, 115, 1657.64, 0.0002, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (80, 12, '2026-01-08', 21.40, 2, 0, 70.30, 76.10, 59.60, 19.7000, 95.20, 53, 759.18, 0.0030, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (81, 12, '2026-01-09', 20.40, 1, 1, 61.60, 72.40, 54.80, 22.5000, 95.90, 37, 2300.85, 0.0056, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (82, 12, '2026-01-10', 20.40, 2, 1, 70.30, 79.50, 50.90, 19.5000, 97.10, 112, 767.26, 0.0085, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (83, 12, '2026-01-11', 23.30, 1, 1, 73.90, 84.80, 51.60, 21.8000, 98.00, 24, 2077.59, 0.0032, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (84, 12, '2026-01-12', 20.90, 0, 0, 60.70, 73.40, 60.00, 17.5000, 97.30, 107, 2055.57, 0.0020, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (85, 13, '2026-01-06', 22.70, 2, 1, 61.80, 83.70, 52.00, 17.2000, 98.20, 14, 953.81, 0.0077, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (86, 13, '2026-01-07', 20.70, 1, 0, 73.00, 75.90, 53.60, 19.8000, 98.80, 111, 2117.32, 0.0025, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (87, 13, '2026-01-08', 23.30, 1, 1, 70.10, 79.10, 50.20, 17.4000, 96.60, 16, 1426.76, 0.0091, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (88, 13, '2026-01-09', 20.70, 0, 1, 68.80, 85.00, 52.40, 16.7000, 96.30, 118, 2406.45, 0.0081, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (89, 13, '2026-01-10', 20.90, 1, 0, 66.70, 82.50, 58.50, 20.9000, 95.60, 69, 1344.07, 0.0037, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (90, 13, '2026-01-11', 22.30, 2, 1, 64.80, 83.70, 56.00, 17.1000, 97.10, 94, 1255.48, 0.0054, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (91, 13, '2026-01-12', 22.20, 0, 0, 73.00, 72.50, 52.10, 19.6000, 95.90, 52, 1486.78, 0.0015, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (92, 14, '2026-01-06', 21.10, 2, 1, 60.90, 75.00, 54.60, 17.6000, 96.00, 36, 1961.79, 0.0075, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (93, 14, '2026-01-07', 22.20, 1, 0, 70.10, 72.80, 59.10, 22.9000, 95.90, 16, 542.69, 0.0069, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (94, 14, '2026-01-08', 21.60, 2, 1, 71.70, 75.10, 53.40, 20.5000, 96.60, 112, 1487.79, 0.0066, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (95, 14, '2026-01-09', 23.20, 0, 1, 66.40, 75.20, 54.60, 17.2000, 98.90, 8, 1342.98, 0.0089, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (96, 14, '2026-01-10', 20.80, 0, 1, 74.40, 82.80, 53.90, 18.0000, 97.80, 47, 2239.09, 0.0016, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (97, 14, '2026-01-11', 20.80, 1, 1, 65.50, 83.30, 53.40, 15.3000, 95.70, 84, 555.69, 0.0003, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (98, 14, '2026-01-12', 20.30, 0, 1, 60.50, 75.20, 56.30, 16.0000, 97.80, 15, 1613.18, 0.0039, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (99, 15, '2026-01-06', 21.20, 0, 1, 67.70, 77.20, 58.80, 22.5000, 95.10, 45, 2081.81, 0.0082, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (100, 15, '2026-01-07', 22.80, 0, 0, 63.00, 71.90, 50.50, 21.8000, 95.40, 110, 1176.60, 0.0092, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (101, 15, '2026-01-08', 22.40, 0, 0, 71.50, 84.80, 56.50, 17.2000, 96.70, 31, 619.17, 0.0051, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (102, 15, '2026-01-09', 21.60, 1, 1, 65.00, 83.90, 56.20, 17.5000, 97.90, 82, 1009.17, 0.0021, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (103, 15, '2026-01-10', 21.20, 2, 0, 68.90, 75.40, 60.00, 22.3000, 97.20, 9, 1933.48, 0.0034, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (104, 15, '2026-01-11', 22.20, 2, 0, 65.80, 78.20, 55.60, 16.1000, 95.20, 92, 1999.72, 0.0043, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (105, 15, '2026-01-12', 23.60, 0, 0, 69.50, 76.60, 53.20, 17.3000, 96.80, 47, 1788.72, 0.0003, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (106, 16, '2026-01-06', 20.80, 2, 1, 73.30, 80.00, 56.80, 18.1000, 98.70, 52, 1325.59, 0.0076, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (107, 16, '2026-01-07', 22.20, 1, 1, 62.20, 79.00, 55.60, 22.9000, 96.10, 50, 1038.82, 0.0008, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (108, 16, '2026-01-08', 22.40, 2, 0, 67.90, 70.80, 57.10, 18.0000, 98.00, 75, 2316.72, 0.0064, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (109, 16, '2026-01-09', 22.00, 1, 0, 64.10, 82.90, 54.70, 21.2000, 96.90, 2, 1916.99, 0.0047, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (110, 16, '2026-01-10', 20.90, 2, 1, 61.80, 71.10, 50.10, 21.5000, 95.20, 97, 2301.06, 0.0007, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (111, 16, '2026-01-11', 22.60, 0, 0, 74.90, 74.80, 56.10, 15.6000, 97.20, 61, 2356.74, 0.0010, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (112, 16, '2026-01-12', 22.90, 0, 0, 61.40, 73.40, 58.70, 20.4000, 98.10, 99, 2140.02, 0.0062, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (113, 17, '2026-01-06', 22.50, 0, 1, 73.50, 82.60, 55.10, 15.1000, 97.10, 72, 1384.49, 0.0040, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (114, 17, '2026-01-07', 22.70, 0, 1, 74.20, 80.70, 57.40, 19.4000, 97.20, 6, 1780.21, 0.0004, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (115, 17, '2026-01-08', 21.20, 0, 1, 69.00, 83.10, 55.80, 17.2000, 97.40, 27, 1133.13, 0.0090, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (116, 17, '2026-01-09', 22.20, 0, 1, 60.10, 71.90, 56.20, 20.8000, 98.00, 65, 1471.63, 0.0080, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (117, 17, '2026-01-10', 22.20, 1, 0, 63.50, 74.60, 58.40, 17.2000, 98.40, 48, 1513.62, 0.0031, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (118, 17, '2026-01-11', 20.10, 0, 1, 64.20, 76.60, 53.70, 19.3000, 97.30, 36, 2046.47, 0.0095, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (119, 17, '2026-01-12', 21.70, 0, 1, 61.40, 78.60, 56.00, 17.1000, 97.10, 93, 1216.54, 0.0045, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (120, 18, '2026-01-06', 20.80, 1, 0, 67.30, 70.70, 57.70, 20.6000, 95.90, 0, 1194.73, 0.0072, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (121, 18, '2026-01-07', 22.30, 2, 1, 63.40, 77.30, 57.60, 17.7000, 96.60, 113, 1638.14, 0.0000, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (122, 18, '2026-01-08', 21.20, 1, 1, 62.50, 78.40, 53.20, 22.1000, 97.00, 105, 2243.27, 0.0071, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (123, 18, '2026-01-09', 23.80, 1, 0, 74.60, 80.80, 56.70, 16.4000, 98.40, 92, 1038.18, 0.0004, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (124, 18, '2026-01-10', 21.60, 2, 0, 64.20, 72.20, 59.10, 15.7000, 97.80, 32, 978.58, 0.0038, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (125, 18, '2026-01-11', 20.80, 2, 1, 60.80, 71.20, 52.20, 22.1000, 98.10, 22, 1740.74, 0.0054, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (126, 18, '2026-01-12', 23.40, 1, 1, 61.40, 80.00, 50.50, 17.0000, 95.50, 104, 2419.46, 0.0019, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (127, 19, '2026-01-06', 20.40, 2, 0, 62.80, 76.30, 55.30, 18.2000, 96.70, 113, 1364.90, 0.0032, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (128, 19, '2026-01-07', 21.30, 1, 0, 61.20, 82.40, 58.90, 22.8000, 95.70, 1, 1515.81, 0.0050, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (129, 19, '2026-01-08', 23.90, 1, 0, 74.80, 82.40, 51.80, 18.4000, 97.20, 64, 548.76, 0.0050, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (130, 19, '2026-01-09', 21.70, 1, 1, 72.90, 71.80, 50.00, 20.3000, 96.20, 66, 2164.62, 0.0051, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (131, 19, '2026-01-10', 20.10, 1, 0, 60.00, 76.40, 51.10, 17.3000, 95.30, 63, 1349.90, 0.0054, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (132, 19, '2026-01-11', 21.60, 1, 1, 71.30, 75.80, 56.70, 16.5000, 98.70, 6, 1478.73, 0.0030, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (133, 19, '2026-01-12', 20.10, 0, 1, 69.70, 81.10, 57.50, 19.2000, 96.50, 34, 1181.02, 0.0083, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (134, 20, '2026-01-06', 20.50, 0, 0, 71.90, 74.30, 50.40, 17.6000, 97.10, 74, 1590.17, 0.0086, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (135, 20, '2026-01-07', 22.70, 2, 0, 74.90, 80.30, 54.50, 16.5000, 97.30, 41, 2492.89, 0.0094, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (136, 20, '2026-01-08', 22.80, 2, 0, 70.70, 77.60, 53.70, 17.7000, 97.40, 115, 533.75, 0.0020, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (137, 20, '2026-01-09', 23.80, 0, 1, 67.30, 72.00, 52.10, 20.3000, 97.60, 35, 1526.12, 0.0068, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (138, 20, '2026-01-10', 23.40, 0, 1, 70.20, 75.30, 57.10, 18.8000, 96.10, 107, 1831.90, 0.0065, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (139, 20, '2026-01-11', 21.10, 1, 0, 74.60, 72.00, 57.40, 17.4000, 96.10, 61, 1925.21, 0.0003, NULL, '2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (140, 20, '2026-01-12', 20.00, 2, 1, 64.90, 81.50, 58.60, 15.1000, 96.90, 46, 1466.06, 0.0025, NULL, '2026-01-12 00:01:33');

-- ----------------------------
-- Table structure for eq_device_status
-- ----------------------------
DROP TABLE IF EXISTS `eq_device_status`;
CREATE TABLE `eq_device_status`  (
  `status_id` bigint NOT NULL AUTO_INCREMENT COMMENT '状态ID',
  `device_id` bigint NOT NULL COMMENT '设备ID',
  `timestamp` datetime NOT NULL COMMENT '采集时间',
  `temperature` decimal(10, 2) NULL DEFAULT NULL COMMENT '温度(°C)',
  `humidity` decimal(10, 2) NULL DEFAULT NULL COMMENT '湿度(%)',
  `pressure` decimal(10, 3) NULL DEFAULT NULL COMMENT '压力(bar)',
  `vibration` decimal(10, 6) NULL DEFAULT NULL COMMENT '振动(mm/s)',
  `current` decimal(10, 4) NULL DEFAULT NULL COMMENT '电流(A)',
  `voltage` decimal(10, 2) NULL DEFAULT NULL COMMENT '电压(V)',
  `power` decimal(10, 4) NULL DEFAULT NULL COMMENT '功率(kW)',
  `rpm` decimal(10, 2) NULL DEFAULT NULL COMMENT '转速(rpm)',
  `flow_rate` decimal(10, 4) NULL DEFAULT NULL COMMENT '流量(m³/h)',
  `liquid_level` decimal(10, 2) NULL DEFAULT NULL COMMENT '液位(cm)',
  `status` tinyint NULL DEFAULT NULL COMMENT '运行状态 1-正常 2-警告 3-错误 4-离线',
  `runtime_hours` decimal(10, 2) NULL DEFAULT NULL COMMENT '累计运行小时数',
  `start_count` int NULL DEFAULT NULL COMMENT '启动次数',
  `fault_count` int NULL DEFAULT NULL COMMENT '故障次数',
  `alarm_count` int NULL DEFAULT NULL COMMENT '报警次数',
  `efficiency` decimal(5, 2) NULL DEFAULT NULL COMMENT '运行效率(%)',
  `load_factor` decimal(5, 2) NULL DEFAULT NULL COMMENT '负载率(%)',
  `ambient_temp` decimal(10, 2) NULL DEFAULT NULL COMMENT '环境温度(°C)',
  `ambient_humidity` decimal(10, 2) NULL DEFAULT NULL COMMENT '环境湿度(%)',
  `noise_level` decimal(10, 2) NULL DEFAULT NULL COMMENT '噪音(dB)',
  `air_quality` decimal(10, 2) NULL DEFAULT NULL COMMENT '空气质量指数',
  `fault_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '故障代码',
  `fault_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '故障描述',
  `maintenance_required` tinyint NULL DEFAULT 0 COMMENT '是否需要维护 1-是 0-否',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`status_id`) USING BTREE,
  INDEX `idx_device_time`(`device_id` ASC, `timestamp` ASC) USING BTREE,
  INDEX `idx_timestamp`(`timestamp` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_fault_code`(`fault_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '设备状态历史表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eq_device_status
-- ----------------------------
INSERT INTO `eq_device_status` VALUES (1, 1, '2026-01-09 17:01:11', 58.70, 47.30, 101.100, 3.270000, 180.2000, 107.60, 18.2000, 1571.00, 51.3000, 76.60, 1, 26166.00, 169, 4, 2, 90.40, 0.85, 28.00, 38.10, 71.20, 98.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (2, 1, '2026-01-11 23:01:11', 66.30, 44.50, 102.300, 1.430000, 165.7000, 112.00, 16.7000, 1440.00, 60.6000, 73.70, 1, 25708.00, 181, 1, 11, 95.90, 0.93, 24.80, 54.90, 73.80, 95.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (3, 1, '2026-01-09 03:01:11', 76.70, 52.10, 101.300, 1.960000, 158.7000, 111.20, 14.7000, 1507.00, 74.1000, 84.00, 1, 24705.00, 126, 1, 2, 91.60, 0.79, 23.70, 54.40, 61.30, 86.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (4, 1, '2026-01-07 23:01:11', 75.50, 53.30, 102.600, 2.070000, 150.3000, 112.50, 18.4000, 1563.00, 88.1000, 71.10, 1, 24688.00, 161, 4, 6, 95.80, 0.92, 24.50, 52.70, 64.50, 89.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (5, 1, '2026-01-09 21:01:11', 60.30, 55.40, 100.600, 3.140000, 197.3000, 111.40, 17.0000, 1524.00, 60.1000, 64.10, 1, 18905.00, 196, 3, 2, 91.40, 0.76, 27.90, 53.80, 65.30, 90.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (6, 2, '2026-01-09 14:01:11', 64.60, 49.20, 100.400, 1.870000, 142.8000, 109.50, 20.8000, 1463.00, 77.3000, 83.30, 1, 20976.00, 188, 4, 2, 96.50, 0.79, 24.70, 48.20, 58.10, 88.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (7, 2, '2026-01-11 09:01:11', 79.00, 48.20, 100.500, 2.790000, 169.5000, 111.60, 22.4000, 1446.00, 81.4000, 73.40, 1, 22076.00, 123, 4, 10, 91.00, 0.92, 22.70, 51.00, 67.80, 93.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (8, 2, '2026-01-11 07:01:11', 80.00, 51.20, 102.400, 1.970000, 152.6000, 107.60, 21.9000, 1543.00, 60.1000, 85.70, 1, 26199.00, 181, 1, 3, 90.10, 0.75, 28.80, 50.20, 58.60, 85.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (9, 2, '2026-01-07 01:01:11', 77.60, 50.90, 100.000, 2.290000, 146.7000, 108.90, 14.1000, 1444.00, 54.4000, 83.40, 1, 25585.00, 178, 1, 7, 93.40, 0.76, 22.10, 43.20, 66.30, 92.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (10, 2, '2026-01-11 02:01:11', 63.20, 41.60, 101.300, 3.570000, 141.8000, 111.00, 22.0000, 1449.00, 92.5000, 75.20, 1, 29822.00, 128, 0, 1, 93.90, 0.70, 26.60, 52.40, 66.80, 85.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (11, 3, '2026-01-08 11:01:11', 64.80, 56.70, 103.000, 2.390000, 160.4000, 109.20, 19.3000, 1540.00, 96.5000, 76.30, 1, 29213.00, 84, 2, 9, 97.40, 0.74, 22.30, 49.60, 63.20, 92.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (12, 3, '2026-01-09 10:01:11', 58.70, 43.50, 101.300, 2.800000, 183.6000, 112.90, 14.0000, 1499.00, 74.5000, 88.50, 1, 21334.00, 145, 5, 9, 91.30, 0.84, 23.80, 46.70, 72.60, 96.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (13, 3, '2026-01-10 16:01:11', 56.50, 49.40, 100.500, 2.500000, 196.9000, 108.70, 17.8000, 1431.00, 82.9000, 84.50, 1, 19242.00, 88, 0, 11, 96.60, 0.75, 25.40, 47.80, 68.50, 90.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (14, 3, '2026-01-07 13:01:11', 66.10, 50.30, 100.700, 3.090000, 184.1000, 111.10, 21.2000, 1569.00, 53.7000, 84.80, 1, 29042.00, 93, 4, 8, 92.30, 0.75, 22.70, 52.50, 58.10, 92.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (15, 3, '2026-01-10 01:01:11', 68.00, 48.40, 101.600, 2.320000, 175.1000, 111.20, 16.6000, 1499.00, 85.0000, 60.20, 1, 29153.00, 155, 2, 11, 95.00, 0.78, 27.40, 45.50, 61.20, 93.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (16, 4, '2026-01-09 20:01:11', 64.40, 51.50, 102.200, 3.940000, 181.2000, 110.40, 17.8000, 1487.00, 52.8000, 88.90, 1, 25769.00, 121, 4, 11, 92.00, 0.82, 26.90, 49.00, 64.90, 86.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (17, 4, '2026-01-10 23:01:11', 75.10, 47.70, 101.500, 2.230000, 170.9000, 109.40, 15.5000, 1546.00, 60.7000, 86.20, 1, 26712.00, 81, 5, 3, 97.20, 0.85, 24.40, 50.30, 69.80, 89.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (18, 4, '2026-01-09 17:01:11', 64.30, 49.50, 100.800, 3.600000, 173.9000, 108.60, 18.2000, 1482.00, 90.4000, 84.20, 1, 25363.00, 157, 2, 11, 96.70, 0.74, 24.60, 40.20, 69.30, 99.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (19, 4, '2026-01-08 12:01:11', 72.60, 48.30, 102.900, 2.570000, 185.8000, 108.70, 23.2000, 1570.00, 76.3000, 61.90, 1, 26881.00, 141, 2, 1, 95.80, 0.74, 27.20, 50.90, 72.40, 99.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (20, 4, '2026-01-10 20:01:11', 63.00, 57.90, 101.500, 3.660000, 193.6000, 112.60, 17.4000, 1459.00, 72.8000, 71.80, 1, 25149.00, 175, 1, 7, 95.10, 0.76, 23.90, 46.10, 69.80, 85.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (21, 5, '2026-01-11 17:01:11', 60.90, 59.80, 100.700, 1.650000, 162.8000, 108.70, 14.7000, 1527.00, 98.1000, 87.00, 1, 25327.00, 122, 5, 8, 94.70, 0.92, 27.40, 50.00, 66.70, 91.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (22, 5, '2026-01-08 18:01:11', 79.10, 57.10, 101.100, 1.920000, 164.6000, 107.90, 18.3000, 1552.00, 76.2000, 69.90, 1, 18848.00, 124, 3, 0, 91.90, 0.73, 29.00, 38.30, 66.10, 89.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (23, 5, '2026-01-11 05:01:11', 76.10, 54.90, 100.600, 3.230000, 147.6000, 109.80, 20.3000, 1587.00, 90.3000, 66.60, 1, 26104.00, 166, 3, 8, 96.00, 0.87, 22.90, 46.90, 63.10, 98.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (24, 5, '2026-01-08 09:01:11', 76.50, 42.30, 100.000, 3.060000, 164.8000, 107.00, 21.8000, 1576.00, 53.5000, 81.20, 1, 21842.00, 138, 2, 10, 96.40, 0.83, 22.80, 38.40, 71.50, 98.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (25, 5, '2026-01-11 05:01:11', 57.00, 58.50, 101.100, 1.220000, 156.0000, 107.80, 21.6000, 1493.00, 52.9000, 86.60, 1, 21114.00, 156, 2, 1, 92.90, 0.82, 24.00, 52.60, 67.00, 86.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (26, 6, '2026-01-08 00:01:11', 75.00, 51.60, 101.500, 3.120000, 143.8000, 108.40, 22.1000, 1493.00, 95.1000, 63.20, 1, 27851.00, 174, 2, 0, 95.00, 0.72, 26.50, 47.10, 74.80, 90.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (27, 6, '2026-01-08 00:01:11', 79.30, 48.70, 100.800, 1.110000, 162.1000, 112.10, 19.7000, 1529.00, 75.9000, 79.60, 1, 26543.00, 152, 5, 6, 90.20, 0.83, 26.70, 43.90, 74.50, 97.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (28, 6, '2026-01-11 09:01:11', 60.50, 54.40, 102.800, 2.660000, 196.1000, 107.10, 16.7000, 1458.00, 83.4000, 73.70, 1, 21446.00, 87, 2, 0, 96.80, 0.73, 23.20, 43.60, 61.40, 85.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (29, 6, '2026-01-09 19:01:11', 60.00, 53.20, 102.100, 2.480000, 162.8000, 110.00, 23.8000, 1525.00, 59.6000, 62.50, 1, 28046.00, 192, 1, 0, 96.50, 0.91, 28.60, 47.30, 62.70, 96.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (30, 6, '2026-01-07 12:01:11', 61.70, 52.80, 101.200, 1.230000, 151.2000, 111.90, 23.4000, 1516.00, 54.8000, 82.10, 1, 22723.00, 171, 3, 9, 91.90, 0.89, 22.20, 53.30, 64.70, 89.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (31, 7, '2026-01-10 20:01:11', 63.20, 58.60, 102.000, 2.680000, 187.5000, 108.90, 14.0000, 1437.00, 96.3000, 62.20, 1, 25056.00, 166, 4, 11, 93.90, 0.82, 28.80, 52.20, 69.00, 96.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (32, 7, '2026-01-08 08:01:11', 66.50, 42.00, 100.300, 1.840000, 143.4000, 110.10, 14.4000, 1570.00, 58.3000, 68.00, 1, 27955.00, 122, 1, 3, 95.40, 0.82, 24.90, 44.20, 70.80, 94.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (33, 7, '2026-01-11 20:01:11', 60.00, 58.00, 102.700, 3.490000, 166.0000, 111.70, 14.6000, 1461.00, 66.6000, 82.40, 1, 26876.00, 134, 0, 11, 93.70, 0.83, 23.20, 42.20, 71.30, 87.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (34, 7, '2026-01-09 10:01:11', 56.80, 56.20, 102.500, 3.080000, 199.4000, 113.10, 18.0000, 1476.00, 85.2000, 71.40, 1, 27441.00, 175, 3, 7, 93.20, 0.72, 23.40, 48.70, 69.00, 89.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (35, 7, '2026-01-08 10:01:11', 70.10, 57.20, 101.500, 3.710000, 141.3000, 109.80, 23.5000, 1504.00, 88.6000, 68.90, 1, 19983.00, 192, 1, 1, 90.50, 0.94, 26.70, 39.50, 69.40, 86.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (36, 8, '2026-01-09 20:01:11', 78.20, 46.20, 102.300, 3.910000, 170.5000, 111.40, 20.4000, 1459.00, 78.0000, 87.40, 1, 28707.00, 166, 5, 4, 92.30, 0.75, 23.60, 44.60, 63.50, 91.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (37, 8, '2026-01-10 16:01:11', 55.20, 44.50, 100.300, 3.660000, 145.2000, 112.40, 20.3000, 1562.00, 58.9000, 73.60, 1, 26720.00, 113, 1, 2, 92.20, 0.91, 24.80, 42.60, 62.90, 94.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (38, 8, '2026-01-10 13:01:11', 69.40, 59.90, 100.700, 1.730000, 169.0000, 111.80, 23.7000, 1556.00, 50.6000, 81.30, 1, 24228.00, 135, 4, 4, 96.20, 0.86, 29.40, 49.50, 68.10, 99.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (39, 8, '2026-01-07 01:01:11', 57.50, 50.30, 100.800, 3.410000, 152.7000, 111.50, 20.1000, 1418.00, 82.4000, 88.70, 1, 28153.00, 122, 1, 1, 97.60, 0.79, 22.00, 53.10, 65.50, 93.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (40, 8, '2026-01-10 04:01:11', 60.90, 41.40, 101.900, 3.990000, 143.3000, 109.00, 16.7000, 1498.00, 82.1000, 82.10, 1, 27137.00, 151, 4, 8, 92.20, 0.79, 22.10, 54.30, 70.90, 98.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (41, 9, '2026-01-10 15:01:11', 71.70, 50.10, 101.500, 1.200000, 187.0000, 112.00, 16.5000, 1418.00, 85.5000, 68.20, 1, 20813.00, 122, 0, 3, 90.80, 0.88, 24.80, 47.20, 69.40, 95.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (42, 9, '2026-01-08 20:01:11', 79.80, 41.00, 100.800, 1.710000, 161.3000, 107.40, 16.3000, 1596.00, 60.9000, 64.10, 1, 18439.00, 172, 4, 4, 96.20, 0.86, 29.50, 50.90, 74.40, 93.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (43, 9, '2026-01-07 22:01:11', 66.60, 57.20, 102.800, 1.100000, 163.3000, 112.90, 14.5000, 1544.00, 73.0000, 64.00, 1, 21509.00, 87, 2, 10, 92.20, 0.86, 25.10, 38.10, 72.80, 89.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (44, 9, '2026-01-11 18:01:11', 61.60, 43.20, 100.000, 2.750000, 192.8000, 111.50, 19.9000, 1403.00, 65.5000, 74.90, 1, 24691.00, 115, 4, 2, 93.30, 0.84, 26.10, 53.90, 59.90, 96.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (45, 9, '2026-01-09 13:01:11', 59.20, 47.10, 100.800, 1.950000, 185.0000, 112.60, 21.5000, 1469.00, 74.7000, 72.70, 1, 25694.00, 191, 4, 10, 91.90, 0.83, 28.70, 49.10, 71.00, 97.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (46, 10, '2026-01-11 23:01:11', 67.30, 48.20, 101.700, 2.930000, 169.7000, 110.80, 16.2000, 1499.00, 90.3000, 76.30, 1, 21580.00, 183, 2, 5, 91.50, 0.82, 28.80, 51.40, 64.60, 93.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (47, 10, '2026-01-08 02:01:11', 59.30, 50.00, 102.900, 2.100000, 195.0000, 110.40, 20.6000, 1567.00, 61.5000, 78.80, 1, 23401.00, 124, 2, 4, 91.70, 0.71, 26.80, 52.80, 67.40, 87.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (48, 10, '2026-01-11 08:01:11', 59.90, 51.40, 100.800, 2.850000, 157.5000, 111.20, 15.6000, 1593.00, 68.3000, 87.70, 1, 24238.00, 179, 3, 5, 94.40, 0.79, 23.80, 38.10, 63.90, 95.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (49, 10, '2026-01-09 05:01:11', 71.00, 50.30, 102.000, 3.310000, 191.1000, 113.70, 16.1000, 1435.00, 63.5000, 84.40, 1, 21011.00, 178, 2, 3, 92.50, 0.89, 28.40, 51.10, 65.70, 99.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (50, 10, '2026-01-09 22:01:11', 60.80, 58.00, 102.400, 2.040000, 158.2000, 110.30, 18.7000, 1581.00, 57.3000, 60.10, 1, 24844.00, 181, 3, 0, 96.50, 0.91, 27.50, 54.40, 71.00, 98.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (51, 11, '2026-01-10 13:01:11', 73.40, 55.80, 102.200, 2.010000, 167.1000, 108.80, 23.3000, 1572.00, 76.2000, 61.10, 1, 25331.00, 193, 5, 7, 94.30, 0.89, 23.30, 47.50, 63.20, 97.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (52, 11, '2026-01-10 05:01:11', 61.30, 43.40, 100.300, 3.840000, 167.6000, 110.20, 23.3000, 1448.00, 71.6000, 73.00, 1, 28502.00, 88, 4, 5, 92.10, 0.90, 24.40, 39.20, 65.20, 98.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (53, 11, '2026-01-10 12:01:11', 74.50, 59.80, 101.800, 1.110000, 163.1000, 112.70, 23.2000, 1428.00, 98.2000, 71.80, 1, 18898.00, 103, 4, 1, 92.90, 0.81, 23.10, 43.80, 63.00, 91.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (54, 11, '2026-01-09 20:01:11', 75.10, 54.10, 100.300, 2.170000, 178.8000, 107.40, 17.8000, 1543.00, 72.6000, 62.90, 1, 19603.00, 125, 2, 3, 96.80, 0.82, 28.60, 50.00, 59.00, 87.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (55, 11, '2026-01-08 15:01:11', 76.70, 46.20, 102.800, 3.350000, 145.5000, 107.80, 16.7000, 1408.00, 69.2000, 84.00, 1, 28059.00, 175, 2, 11, 92.50, 0.88, 27.80, 45.30, 74.50, 93.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (56, 12, '2026-01-07 10:01:11', 77.50, 54.70, 102.900, 3.060000, 169.5000, 109.80, 19.4000, 1496.00, 90.2000, 77.00, 1, 23066.00, 129, 4, 8, 91.60, 0.92, 28.40, 44.20, 65.10, 99.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (57, 12, '2026-01-08 08:01:11', 72.10, 44.20, 103.000, 1.960000, 177.9000, 108.40, 14.9000, 1574.00, 54.5000, 84.90, 1, 28481.00, 185, 4, 3, 90.40, 0.80, 29.30, 43.30, 72.00, 87.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (58, 12, '2026-01-09 18:01:11', 72.80, 43.90, 102.500, 2.800000, 169.5000, 111.60, 22.3000, 1434.00, 68.0000, 68.70, 1, 22502.00, 80, 5, 4, 92.90, 0.85, 29.20, 50.50, 74.50, 94.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (59, 12, '2026-01-10 13:01:11', 69.00, 58.30, 102.700, 3.080000, 188.4000, 113.70, 17.3000, 1562.00, 53.2000, 86.50, 1, 20766.00, 139, 4, 6, 91.00, 0.73, 24.10, 54.10, 73.80, 97.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (60, 12, '2026-01-10 20:01:11', 74.40, 43.10, 101.400, 3.530000, 190.0000, 111.40, 20.7000, 1493.00, 65.5000, 64.40, 1, 27745.00, 153, 3, 4, 97.40, 0.83, 28.90, 50.10, 74.50, 95.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (61, 13, '2026-01-08 08:01:11', 67.70, 46.20, 100.100, 1.820000, 154.6000, 109.80, 16.5000, 1415.00, 80.9000, 85.80, 1, 23455.00, 162, 0, 4, 93.50, 0.74, 25.90, 54.50, 64.80, 86.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (62, 13, '2026-01-11 04:01:11', 71.30, 54.60, 102.100, 1.870000, 161.5000, 113.50, 19.6000, 1402.00, 69.3000, 86.90, 1, 21798.00, 187, 3, 11, 92.40, 0.84, 29.50, 54.70, 59.50, 92.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (63, 13, '2026-01-10 17:01:11', 74.60, 42.80, 101.000, 1.970000, 174.1000, 113.10, 20.7000, 1548.00, 84.7000, 67.10, 1, 19271.00, 178, 4, 4, 95.70, 0.79, 27.30, 41.90, 60.70, 86.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (64, 13, '2026-01-12 00:01:11', 73.60, 53.90, 100.700, 1.420000, 197.7000, 109.80, 14.9000, 1449.00, 98.7000, 63.90, 1, 26714.00, 109, 0, 5, 91.00, 0.77, 22.50, 45.20, 74.20, 92.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (65, 13, '2026-01-09 01:01:11', 68.10, 56.20, 101.500, 1.100000, 180.9000, 109.20, 19.1000, 1520.00, 74.7000, 79.90, 1, 27982.00, 100, 2, 3, 92.20, 0.85, 22.90, 51.30, 67.80, 93.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (66, 14, '2026-01-07 01:01:11', 63.50, 54.40, 101.700, 3.060000, 183.9000, 111.20, 21.9000, 1434.00, 74.5000, 87.70, 1, 19822.00, 198, 2, 5, 96.50, 0.87, 22.10, 54.60, 72.60, 90.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (67, 14, '2026-01-10 19:01:11', 58.30, 58.40, 100.600, 1.800000, 183.5000, 112.70, 23.2000, 1425.00, 94.3000, 61.40, 1, 25005.00, 172, 0, 3, 90.40, 0.80, 28.40, 52.10, 70.70, 88.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (68, 14, '2026-01-11 20:01:11', 65.50, 59.80, 102.100, 2.380000, 154.1000, 112.60, 17.1000, 1428.00, 89.0000, 74.20, 1, 18347.00, 166, 3, 5, 96.10, 0.80, 28.30, 49.50, 58.30, 86.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (69, 14, '2026-01-10 14:01:11', 61.20, 47.40, 100.300, 2.310000, 191.2000, 113.70, 16.2000, 1442.00, 70.9000, 73.60, 1, 18050.00, 159, 1, 7, 97.90, 0.74, 29.40, 39.10, 67.70, 94.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (70, 14, '2026-01-09 01:01:11', 80.00, 44.00, 100.000, 2.230000, 142.9000, 107.10, 23.2000, 1507.00, 97.6000, 64.30, 1, 28282.00, 182, 4, 11, 96.10, 0.92, 22.60, 51.20, 68.90, 98.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (71, 15, '2026-01-09 11:01:11', 77.10, 57.80, 102.400, 1.850000, 143.0000, 109.80, 22.6000, 1417.00, 93.4000, 62.20, 1, 27149.00, 151, 4, 7, 97.30, 0.91, 24.80, 43.20, 66.00, 91.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (72, 15, '2026-01-08 02:01:11', 70.50, 54.50, 102.300, 3.080000, 148.9000, 111.60, 22.4000, 1443.00, 78.6000, 66.40, 1, 22241.00, 94, 3, 5, 93.60, 0.95, 26.80, 38.70, 64.50, 96.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (73, 15, '2026-01-08 01:01:11', 70.80, 55.30, 102.800, 2.070000, 199.6000, 113.30, 18.9000, 1553.00, 68.6000, 76.50, 1, 25721.00, 147, 5, 8, 90.20, 0.93, 26.80, 40.90, 58.90, 96.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (74, 15, '2026-01-08 18:01:11', 79.80, 59.70, 102.800, 3.360000, 145.3000, 107.60, 15.6000, 1505.00, 58.3000, 67.40, 1, 26933.00, 197, 3, 4, 95.70, 0.84, 27.40, 49.70, 65.30, 85.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (75, 15, '2026-01-11 22:01:11', 77.70, 49.80, 102.200, 1.560000, 183.8000, 107.70, 16.8000, 1422.00, 85.8000, 67.60, 1, 19321.00, 175, 3, 10, 92.00, 0.89, 29.80, 49.10, 63.80, 95.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (76, 16, '2026-01-08 19:01:11', 55.40, 42.90, 102.000, 3.900000, 187.9000, 107.60, 14.4000, 1590.00, 82.1000, 70.40, 1, 27614.00, 196, 2, 3, 92.50, 0.84, 28.30, 43.10, 60.50, 97.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (77, 16, '2026-01-08 09:01:11', 58.80, 51.30, 101.100, 1.380000, 172.8000, 109.50, 15.3000, 1517.00, 77.3000, 88.90, 1, 20215.00, 83, 3, 11, 96.30, 0.74, 26.30, 40.40, 59.90, 86.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (78, 16, '2026-01-10 17:01:11', 79.30, 41.20, 101.100, 3.110000, 163.4000, 112.90, 14.5000, 1541.00, 69.6000, 85.20, 1, 18281.00, 151, 5, 9, 91.50, 0.84, 23.70, 45.30, 66.20, 87.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (79, 16, '2026-01-10 18:01:11', 76.00, 48.80, 102.000, 1.180000, 156.9000, 108.50, 16.6000, 1525.00, 67.9000, 87.30, 1, 23760.00, 160, 5, 6, 96.60, 0.85, 26.10, 51.40, 64.80, 94.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (80, 16, '2026-01-12 00:01:11', 57.70, 50.50, 100.900, 3.580000, 166.2000, 111.30, 21.4000, 1572.00, 55.1000, 87.50, 1, 21420.00, 160, 2, 5, 97.50, 0.75, 23.70, 45.50, 68.00, 94.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (81, 17, '2026-01-10 07:01:11', 76.20, 44.30, 101.600, 1.100000, 173.4000, 111.80, 21.3000, 1522.00, 93.8000, 76.20, 1, 18781.00, 165, 2, 7, 91.30, 0.92, 29.90, 42.00, 61.80, 91.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (82, 17, '2026-01-10 04:01:11', 70.80, 40.80, 100.900, 2.360000, 159.5000, 108.80, 17.4000, 1583.00, 78.1000, 61.70, 1, 25125.00, 176, 1, 8, 97.90, 0.89, 28.20, 48.30, 70.20, 96.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (83, 17, '2026-01-08 15:01:11', 57.60, 49.50, 100.200, 3.690000, 157.4000, 112.30, 23.4000, 1486.00, 66.8000, 71.30, 1, 28528.00, 110, 3, 5, 93.20, 0.85, 28.80, 45.10, 67.00, 90.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (84, 17, '2026-01-10 01:01:11', 74.80, 55.50, 101.500, 1.330000, 145.8000, 108.10, 18.6000, 1573.00, 97.1000, 63.30, 1, 26685.00, 114, 1, 6, 95.60, 0.94, 27.80, 50.70, 67.40, 92.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (85, 17, '2026-01-07 04:01:11', 61.80, 49.10, 101.400, 3.880000, 163.7000, 107.70, 17.2000, 1460.00, 77.2000, 84.60, 1, 23531.00, 181, 5, 8, 90.60, 0.74, 27.40, 52.10, 60.30, 87.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (86, 18, '2026-01-09 08:01:11', 57.60, 58.50, 100.900, 3.300000, 194.7000, 108.80, 19.3000, 1582.00, 97.9000, 61.50, 1, 22464.00, 165, 2, 1, 92.60, 0.75, 22.20, 47.00, 67.80, 89.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (87, 18, '2026-01-08 11:01:11', 72.40, 47.00, 102.000, 1.680000, 150.0000, 108.10, 16.8000, 1582.00, 86.6000, 87.80, 1, 23185.00, 126, 3, 11, 97.30, 0.87, 27.70, 46.00, 62.00, 96.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (88, 18, '2026-01-11 18:01:11', 55.70, 59.30, 102.200, 3.540000, 199.3000, 109.80, 14.2000, 1585.00, 78.5000, 61.80, 1, 25161.00, 176, 1, 8, 96.10, 0.89, 26.00, 41.90, 69.20, 93.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (89, 18, '2026-01-07 01:01:11', 59.80, 59.50, 100.900, 2.680000, 194.7000, 113.10, 20.4000, 1515.00, 98.0000, 62.10, 1, 23741.00, 101, 2, 8, 92.30, 0.76, 24.30, 50.70, 72.80, 86.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (90, 18, '2026-01-07 01:01:11', 70.10, 40.80, 101.200, 3.430000, 193.4000, 107.10, 18.3000, 1418.00, 58.5000, 77.20, 1, 22344.00, 90, 2, 5, 92.70, 0.76, 24.30, 48.80, 63.50, 95.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (91, 19, '2026-01-09 01:01:11', 76.10, 48.60, 101.900, 3.530000, 159.9000, 107.90, 20.5000, 1576.00, 72.7000, 78.60, 1, 26775.00, 176, 4, 7, 96.40, 0.72, 29.50, 46.50, 69.50, 98.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (92, 19, '2026-01-10 08:01:11', 56.70, 46.50, 101.300, 1.470000, 170.1000, 107.30, 20.9000, 1469.00, 82.9000, 67.50, 1, 21221.00, 151, 1, 1, 97.40, 0.78, 29.10, 45.40, 67.10, 90.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (93, 19, '2026-01-10 22:01:11', 80.00, 46.70, 102.100, 2.240000, 140.6000, 112.70, 14.5000, 1558.00, 90.5000, 80.40, 1, 29612.00, 175, 0, 0, 90.40, 0.72, 23.60, 51.00, 62.20, 99.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (94, 19, '2026-01-07 09:01:11', 75.90, 47.80, 101.400, 1.260000, 144.9000, 108.00, 18.7000, 1582.00, 57.5000, 60.50, 1, 25570.00, 92, 3, 10, 94.40, 0.71, 26.80, 52.50, 66.00, 97.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (95, 19, '2026-01-09 03:01:11', 67.80, 56.30, 101.600, 1.760000, 178.9000, 110.40, 18.6000, 1572.00, 96.3000, 61.20, 1, 23160.00, 83, 5, 1, 91.20, 0.78, 23.90, 41.40, 62.60, 96.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (96, 20, '2026-01-11 23:01:11', 73.70, 54.40, 101.000, 2.700000, 187.6000, 108.90, 23.8000, 1414.00, 72.0000, 89.40, 1, 24839.00, 189, 5, 6, 92.30, 0.88, 27.50, 43.70, 68.00, 98.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (97, 20, '2026-01-07 13:01:11', 72.40, 55.60, 102.400, 3.130000, 147.8000, 110.60, 15.7000, 1465.00, 55.5000, 77.20, 1, 24479.00, 197, 1, 4, 92.10, 0.72, 26.50, 48.30, 63.60, 97.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (98, 20, '2026-01-10 20:01:11', 71.60, 51.80, 102.900, 1.020000, 150.6000, 113.00, 21.6000, 1445.00, 92.9000, 78.10, 1, 23384.00, 131, 4, 8, 92.60, 0.79, 28.70, 40.10, 59.40, 85.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (99, 20, '2026-01-07 04:01:11', 72.90, 53.40, 100.600, 1.120000, 173.9000, 112.00, 22.5000, 1424.00, 53.4000, 89.20, 1, 25839.00, 122, 4, 10, 91.50, 0.75, 24.90, 42.30, 61.20, 87.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (100, 20, '2026-01-10 07:01:11', 59.40, 56.80, 102.000, 3.640000, 161.4000, 108.00, 20.4000, 1553.00, 96.1000, 69.20, 1, 27231.00, 191, 1, 9, 91.50, 0.81, 26.60, 48.40, 63.70, 97.00, NULL, NULL, 0, '运行正常', '2026-01-12 00:01:11');

-- ----------------------------
-- Table structure for eq_economic_data
-- ----------------------------
DROP TABLE IF EXISTS `eq_economic_data`;
CREATE TABLE `eq_economic_data`  (
  `economic_id` bigint NOT NULL AUTO_INCREMENT COMMENT '经济数据ID',
  `device_id` bigint NOT NULL COMMENT '设备ID',
  `timestamp` datetime NOT NULL COMMENT '记录时间',
  `maintenance_cost` decimal(10, 2) NULL DEFAULT NULL COMMENT '维护成本',
  `energy_consumption` decimal(10, 4) NULL DEFAULT NULL COMMENT '能耗(kWh)',
  `labor_cost` decimal(10, 2) NULL DEFAULT NULL COMMENT '人工成本',
  `parts_cost` decimal(10, 2) NULL DEFAULT NULL COMMENT '配件成本',
  `downtime_cost` decimal(10, 2) NULL DEFAULT NULL COMMENT '停机损失',
  `roi` decimal(10, 4) NULL DEFAULT NULL COMMENT '投资回报率(%)',
  `npv` decimal(10, 2) NULL DEFAULT NULL COMMENT '净现值',
  `payback_period` decimal(10, 2) NULL DEFAULT NULL COMMENT '投资回收期(年)',
  `annual_budget` decimal(10, 2) NULL DEFAULT NULL COMMENT '年度预算',
  `actual_spending` decimal(10, 2) NULL DEFAULT NULL COMMENT '实际支出',
  `budget_utilization` decimal(10, 4) NULL DEFAULT NULL COMMENT '预算利用率(%)',
  `regulatory_compliance` tinyint NULL DEFAULT NULL COMMENT '法规符合度(%)',
  `environmental_impact` tinyint NULL DEFAULT NULL COMMENT '环境影响评级 1-优秀 2-良好 3-一般 4-较差',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`economic_id`) USING BTREE,
  INDEX `idx_device_time`(`device_id` ASC, `timestamp` ASC) USING BTREE,
  INDEX `idx_cost`(`maintenance_cost` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '经济数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eq_economic_data
-- ----------------------------
INSERT INTO `eq_economic_data` VALUES (1, 1, '2025-11-14 00:01:36', 1806.62, 2541.1500, 1597.48, 733.78, 1116.18, 0.2420, 47359.64, 3.50, 59069.62, 47095.42, 79.9000, 93, 1, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (2, 1, '2025-11-26 00:01:36', 5705.60, 1319.4100, 1923.19, 375.21, 223.66, 0.2220, 56585.23, 2.30, 94173.35, 52989.28, 90.9000, 83, 1, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (3, 1, '2025-12-27 00:01:36', 1056.47, 1115.7400, 996.40, 499.29, 852.75, 0.1680, 110508.33, 5.40, 98956.07, 48331.03, 94.8000, 88, 4, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (4, 2, '2025-12-03 00:01:36', 3270.49, 1149.3000, 2104.46, 1021.91, 903.00, 0.2170, 142671.04, 3.40, 67340.62, 42322.64, 79.4000, 96, 1, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (5, 2, '2025-12-27 00:01:36', 2510.76, 2261.8900, 1625.98, 1077.87, 209.72, 0.1020, 111025.30, 6.50, 92997.39, 42335.87, 88.6000, 85, 1, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (6, 2, '2026-01-04 00:01:36', 2011.85, 1939.8300, 1108.84, 808.00, 557.30, 0.2300, 80241.45, 2.20, 58067.07, 71759.33, 75.9000, 83, 2, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (7, 3, '2025-12-03 00:01:36', 1884.11, 2649.8000, 1853.69, 512.69, 221.96, 0.1330, 96991.13, 5.20, 60513.23, 59524.96, 85.8000, 88, 2, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (8, 3, '2025-12-11 00:01:36', 4240.04, 2089.5900, 1052.75, 514.66, 836.12, 0.1440, 146831.67, 6.30, 85078.85, 55356.41, 87.0000, 97, 1, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (9, 3, '2025-12-06 00:01:36', 4855.80, 2965.2700, 1625.58, 401.56, 983.57, 0.1710, 80102.97, 2.40, 64992.68, 54291.57, 88.8000, 89, 2, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (10, 4, '2025-12-17 00:01:36', 1194.28, 2714.0000, 1167.16, 1020.32, 767.70, 0.1030, 148251.02, 5.00, 78710.44, 56042.55, 76.2000, 85, 4, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (11, 4, '2026-01-03 00:01:36', 5439.45, 2902.5600, 912.16, 959.30, 896.34, 0.0820, 145531.80, 6.60, 96221.81, 55485.25, 93.9000, 93, 3, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (12, 4, '2025-12-27 00:01:36', 2810.73, 2931.2700, 1864.15, 1070.37, 686.55, 0.1720, 72250.65, 6.00, 77607.03, 74301.89, 78.1000, 89, 4, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (13, 5, '2025-12-19 00:01:36', 1543.97, 1314.4800, 1153.86, 728.40, 969.77, 0.1210, 139755.87, 6.70, 60919.00, 73141.87, 75.5000, 96, 3, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (14, 5, '2025-11-14 00:01:36', 2315.50, 1405.2000, 731.65, 315.42, 233.04, 0.0980, 90976.31, 7.20, 51107.44, 62918.01, 84.6000, 95, 4, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (15, 5, '2025-11-14 00:01:36', 1862.23, 2753.9700, 2185.89, 498.57, 469.26, 0.1820, 66060.06, 3.20, 69377.07, 55486.85, 86.2000, 94, 1, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (16, 6, '2025-12-25 00:01:36', 1972.89, 615.0900, 1669.67, 375.30, 731.29, 0.1440, 74037.37, 3.60, 73637.11, 66202.71, 84.9000, 93, 1, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (17, 6, '2025-12-18 00:01:36', 4812.74, 1866.6900, 1368.61, 770.94, 806.16, 0.1250, 98068.71, 6.40, 57372.20, 64255.18, 80.1000, 92, 2, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (18, 6, '2025-12-18 00:01:36', 4666.58, 1433.1100, 1699.41, 469.31, 259.38, 0.1930, 58829.24, 6.00, 98401.70, 77002.47, 79.1000, 91, 1, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (19, 7, '2025-12-18 00:01:36', 3150.08, 2712.8100, 903.36, 317.99, 905.70, 0.1580, 64756.69, 5.30, 61186.06, 60055.92, 86.1000, 89, 3, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (20, 7, '2025-12-12 00:01:36', 5517.18, 2851.7500, 2189.79, 415.10, 939.77, 0.1250, 57272.87, 6.70, 78143.57, 60980.92, 87.9000, 95, 1, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (21, 7, '2025-12-27 00:01:36', 5718.52, 2734.8600, 1657.91, 708.97, 840.25, 0.1930, 88806.32, 2.50, 58231.76, 65804.33, 82.5000, 84, 3, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (22, 8, '2025-12-07 00:01:36', 2143.69, 1271.6100, 1985.51, 587.28, 424.51, 0.0880, 103015.68, 5.80, 73876.42, 62795.67, 77.0000, 97, 3, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (23, 8, '2026-01-07 00:01:36', 4184.05, 2771.9300, 1650.15, 652.67, 503.90, 0.1130, 52693.78, 6.70, 82854.20, 83167.44, 91.5000, 85, 4, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (24, 8, '2026-01-08 00:01:36', 1422.62, 993.0200, 1798.71, 356.60, 356.33, 0.1770, 84693.41, 3.10, 88781.14, 54952.69, 81.7000, 92, 2, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (25, 9, '2025-11-22 00:01:36', 1635.64, 707.8400, 751.43, 1037.62, 707.28, 0.2110, 79618.36, 4.00, 84938.86, 61652.30, 81.2000, 83, 3, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (26, 9, '2025-12-05 00:01:36', 3229.78, 1245.4700, 929.62, 996.66, 1094.88, 0.2270, 110624.73, 5.20, 91052.14, 61941.68, 94.5000, 88, 1, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (27, 9, '2025-12-18 00:01:36', 4720.62, 1589.0800, 2118.67, 637.61, 472.74, 0.0970, 115358.06, 2.30, 63838.70, 49525.02, 79.6000, 90, 4, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (28, 10, '2025-12-02 00:01:36', 5662.96, 1972.6600, 921.33, 1076.45, 610.13, 0.1040, 93779.40, 7.40, 56777.67, 83209.76, 82.9000, 83, 2, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (29, 10, '2026-01-07 00:01:36', 4287.64, 2999.4800, 739.57, 406.02, 783.49, 0.1680, 134135.69, 6.10, 93894.57, 55060.69, 75.8000, 85, 4, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (30, 10, '2025-12-02 00:01:36', 5338.43, 1201.7200, 1900.56, 427.84, 597.88, 0.1670, 82411.05, 3.50, 59436.93, 48510.29, 82.6000, 87, 3, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (31, 11, '2025-12-10 00:01:36', 2322.54, 2117.2200, 1361.38, 511.16, 1196.97, 0.1130, 147285.64, 3.80, 76804.41, 76239.41, 83.4000, 92, 1, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (32, 11, '2025-12-08 00:01:36', 3917.19, 861.6000, 2159.33, 644.41, 433.88, 0.2290, 117208.32, 6.80, 98068.74, 57648.63, 76.5000, 85, 4, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (33, 11, '2025-12-19 00:01:36', 4254.00, 525.1000, 846.70, 667.11, 201.02, 0.1870, 59619.02, 6.90, 81806.86, 73677.64, 91.7000, 96, 1, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (34, 12, '2025-11-26 00:01:36', 4147.91, 2420.5600, 2128.57, 665.78, 628.97, 0.2110, 105794.49, 5.50, 57009.52, 83859.10, 84.1000, 87, 2, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (35, 12, '2025-12-03 00:01:36', 2822.06, 2483.6600, 2011.13, 1092.02, 527.90, 0.1940, 83147.89, 6.90, 97593.13, 55040.41, 91.3000, 83, 4, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (36, 12, '2025-12-18 00:01:36', 2560.11, 1251.4700, 1550.32, 1046.11, 1162.52, 0.0830, 64529.64, 7.30, 93561.86, 71439.25, 92.6000, 86, 4, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (37, 13, '2025-12-17 00:01:36', 4079.30, 2359.0500, 2005.79, 397.41, 1197.26, 0.1860, 56888.17, 6.20, 58792.28, 74646.55, 81.4000, 86, 3, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (38, 13, '2025-11-27 00:01:36', 2512.86, 912.2000, 2075.02, 371.02, 893.81, 0.1140, 142890.74, 2.30, 73462.66, 48396.41, 85.5000, 83, 4, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (39, 13, '2025-12-09 00:01:36', 4096.29, 1414.1300, 2155.74, 904.42, 1066.11, 0.0910, 120767.99, 4.50, 95771.09, 54803.91, 93.0000, 90, 4, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (40, 14, '2025-12-04 00:01:36', 4874.35, 2766.7000, 1013.17, 559.10, 1193.01, 0.2490, 148755.32, 7.80, 91884.42, 53822.50, 75.5000, 85, 4, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (41, 14, '2025-11-20 00:01:36', 4847.25, 943.7200, 1568.62, 590.36, 277.48, 0.1310, 72335.76, 4.40, 62458.79, 41249.21, 82.8000, 95, 1, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (42, 14, '2025-12-23 00:01:36', 1597.31, 1951.7600, 1517.70, 1086.85, 482.42, 0.1580, 93275.22, 7.50, 59686.64, 50118.22, 85.9000, 82, 3, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (43, 15, '2025-11-29 00:01:36', 1122.49, 2685.0700, 1144.98, 988.94, 615.90, 0.1640, 69386.48, 6.00, 83484.17, 54784.90, 87.7000, 84, 1, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (44, 15, '2025-12-12 00:01:36', 3762.20, 1016.2300, 1262.72, 505.00, 355.81, 0.0820, 106324.86, 7.30, 84730.31, 76224.26, 93.8000, 86, 3, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (45, 15, '2025-12-27 00:01:36', 3447.68, 2052.4000, 1654.29, 554.47, 881.87, 0.1570, 69135.61, 6.70, 61526.32, 76025.33, 81.2000, 84, 4, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (46, 16, '2025-11-30 00:01:36', 1674.67, 1709.9400, 722.61, 798.75, 271.99, 0.1630, 69385.60, 6.20, 88233.93, 73594.62, 83.8000, 97, 2, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (47, 16, '2025-12-19 00:01:36', 4311.86, 746.7200, 1459.48, 488.44, 858.76, 0.1800, 145761.53, 2.20, 65207.89, 58492.94, 77.8000, 89, 4, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (48, 16, '2025-12-20 00:01:36', 1387.88, 1005.3300, 1866.89, 526.58, 282.37, 0.1760, 104196.66, 2.80, 98520.89, 60476.74, 82.3000, 89, 1, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (49, 17, '2025-12-11 00:01:36', 1827.63, 1005.8100, 1472.58, 1074.62, 496.25, 0.1780, 149294.65, 3.40, 60305.83, 54355.21, 94.5000, 96, 3, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (50, 17, '2025-11-30 00:01:36', 3716.69, 1818.8100, 711.41, 664.36, 454.42, 0.2340, 125383.56, 2.70, 62790.62, 82640.69, 94.4000, 82, 1, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (51, 17, '2025-12-05 00:01:36', 5214.58, 1161.8000, 1892.29, 444.10, 716.07, 0.0870, 113423.60, 2.80, 86838.05, 52094.75, 77.7000, 95, 4, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (52, 18, '2025-11-16 00:01:36', 1167.13, 1285.5600, 1406.28, 629.26, 845.32, 0.2490, 47465.86, 2.90, 81914.79, 74480.33, 93.3000, 86, 3, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (53, 18, '2025-12-15 00:01:36', 2875.84, 1637.5500, 924.39, 606.33, 665.76, 0.1110, 97822.35, 7.90, 68325.16, 80818.97, 83.7000, 89, 4, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (54, 18, '2025-12-11 00:01:36', 4879.72, 1106.6000, 2028.06, 859.15, 1038.60, 0.0960, 146320.89, 5.20, 89344.61, 54642.82, 80.3000, 87, 4, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (55, 19, '2025-11-24 00:01:36', 1901.95, 1584.4400, 1641.57, 969.78, 502.99, 0.0810, 56269.45, 5.20, 65618.38, 84155.20, 94.4000, 96, 3, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (56, 19, '2025-12-26 00:01:36', 4419.98, 1822.7100, 1590.16, 603.95, 319.39, 0.1580, 142373.51, 3.60, 77274.94, 81892.07, 75.4000, 86, 2, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (57, 19, '2025-12-26 00:01:36', 1591.01, 2338.7400, 1184.32, 626.33, 270.93, 0.1020, 91389.26, 6.90, 87792.30, 54871.52, 82.7000, 96, 3, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (58, 20, '2025-11-29 00:01:36', 2092.07, 2609.4300, 1545.42, 529.41, 942.96, 0.2250, 49594.92, 5.90, 57239.77, 74124.83, 82.1000, 90, 2, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (59, 20, '2025-11-20 00:01:36', 5979.92, 1274.1900, 1540.64, 998.49, 884.30, 0.2160, 145580.00, 4.30, 52072.93, 42618.51, 78.3000, 92, 4, '2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (60, 20, '2025-11-14 00:01:36', 3716.54, 2413.7100, 996.24, 852.82, 1062.66, 0.1210, 109365.37, 4.10, 94157.98, 57212.30, 80.3000, 84, 1, '2026-01-12 00:01:36');

-- ----------------------------
-- Table structure for eq_electrical_data
-- ----------------------------
DROP TABLE IF EXISTS `eq_electrical_data`;
CREATE TABLE `eq_electrical_data`  (
  `electrical_id` bigint NOT NULL AUTO_INCREMENT COMMENT '电气数据ID',
  `device_id` bigint NOT NULL COMMENT '设备ID',
  `timestamp` datetime NOT NULL COMMENT '采集时间',
  `voltage_l1` decimal(10, 2) NULL DEFAULT NULL COMMENT 'L1相电压(V)',
  `voltage_l2` decimal(10, 2) NULL DEFAULT NULL COMMENT 'L2相电压(V)',
  `voltage_l3` decimal(10, 2) NULL DEFAULT NULL COMMENT 'L3相电压(V)',
  `voltage_unbalance` decimal(10, 4) NULL DEFAULT NULL COMMENT '电压不平衡率(%)',
  `frequency` decimal(10, 2) NULL DEFAULT NULL COMMENT '电网频率(Hz)',
  `voltage_fluctuation` decimal(10, 4) NULL DEFAULT NULL COMMENT '电压波动率(%)',
  `current_l1` decimal(10, 4) NULL DEFAULT NULL COMMENT 'L1相电流(A)',
  `current_l2` decimal(10, 4) NULL DEFAULT NULL COMMENT 'L2相电流(A)',
  `current_l3` decimal(10, 4) NULL DEFAULT NULL COMMENT 'L3相电流(A)',
  `current_unbalance` decimal(10, 4) NULL DEFAULT NULL COMMENT '电流不平衡率(%)',
  `total_current` decimal(10, 4) NULL DEFAULT NULL COMMENT '总电流(A)',
  `active_power` decimal(10, 4) NULL DEFAULT NULL COMMENT '有功功率(kW)',
  `reactive_power` decimal(10, 4) NULL DEFAULT NULL COMMENT '无功功率(kVar)',
  `apparent_power` decimal(10, 4) NULL DEFAULT NULL COMMENT '视在功率(kVA)',
  `power_factor` decimal(10, 4) NULL DEFAULT NULL COMMENT '功率因数',
  `efficiency` decimal(10, 4) NULL DEFAULT NULL COMMENT '效率(%)',
  `harmonics_voltage` json NULL COMMENT '电压谐波含量',
  `harmonics_current` json NULL COMMENT '电流谐波含量',
  `total_harmonic_distortion` decimal(10, 4) NULL DEFAULT NULL COMMENT '总谐波失真率(%)',
  `voltage_thd` decimal(10, 4) NULL DEFAULT NULL COMMENT '电压总谐波失真率(%)',
  `current_thd` decimal(10, 4) NULL DEFAULT NULL COMMENT '电流总谐波失真率(%)',
  `electromagnetic_interference` decimal(10, 4) NULL DEFAULT NULL COMMENT '电磁干扰强度(dB)',
  `grounding_resistance` decimal(10, 4) NULL DEFAULT NULL COMMENT '接地电阻(Ω)',
  `shielding_effectiveness` decimal(10, 4) NULL DEFAULT NULL COMMENT '屏蔽效果(dB)',
  `electrical_grade` tinyint NULL DEFAULT NULL COMMENT '电气等级 1-优良 2-良好 3-一般 4-较差',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`electrical_id`) USING BTREE,
  INDEX `idx_device_time`(`device_id` ASC, `timestamp` ASC) USING BTREE,
  INDEX `idx_voltage`(`voltage_l1` ASC) USING BTREE,
  INDEX `idx_current`(`current_l1` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '电气数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eq_electrical_data
-- ----------------------------
INSERT INTO `eq_electrical_data` VALUES (1, 1, '2026-01-11 10:40:52', 109.95, 108.17, 111.01, 0.7231, 49.84, 1.0997, 170.2938, 176.9818, 184.0275, 0.6128, 491.9514, 18.3629, 2.4958, 19.9765, 0.8737, 95.0638, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.3150, 1.1452, 2.1436, 30.4331, 2.4293, 92.5817, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (2, 1, '2026-01-11 14:40:52', 109.53, 108.22, 112.53, 0.8537, 50.11, 1.6122, 162.8312, 161.6057, 174.5347, 0.5238, 540.3973, 22.9648, 2.8056, 19.8355, 0.9460, 95.6952, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 4.8437, 1.8618, 2.9322, 35.2196, 1.2455, 85.8073, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (3, 1, '2026-01-11 16:40:52', 107.48, 112.52, 112.16, 0.6380, 49.95, 2.8911, 174.9721, 164.7609, 153.8882, 2.0106, 525.8388, 21.0324, 3.8952, 23.5157, 0.8513, 92.4242, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 4.0418, 1.1516, 3.0114, 39.1662, 1.0603, 85.2572, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (4, 2, '2026-01-11 07:40:52', 113.68, 111.77, 110.80, 1.3457, 50.09, 1.9524, 147.3619, 158.9495, 162.6620, 0.0974, 548.4900, 21.4437, 2.5421, 20.3784, 0.8983, 93.8002, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 2.5758, 1.4393, 3.5671, 49.0575, 0.8946, 86.2788, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (5, 2, '2026-01-10 08:40:52', 107.89, 107.52, 113.91, 1.4260, 50.04, 2.6538, 172.3972, 162.5658, 150.6371, 1.3659, 540.0643, 15.2361, 4.9544, 21.0957, 0.9026, 92.9110, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.9179, 2.4464, 4.0946, 36.4257, 1.5237, 90.9541, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (6, 2, '2026-01-11 04:40:52', 112.47, 111.52, 113.17, 0.9457, 50.09, 0.5233, 177.2393, 147.6473, 151.5185, 1.6434, 480.4400, 21.9076, 3.4397, 23.1090, 0.8754, 94.0134, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 4.6141, 2.1056, 2.4498, 31.8263, 0.5135, 92.5972, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (7, 3, '2026-01-10 19:40:52', 112.10, 112.65, 112.93, 1.6290, 50.01, 0.6426, 166.4378, 178.2701, 157.0374, 0.3584, 529.4899, 19.5445, 4.0868, 22.0385, 0.8375, 92.2199, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 4.7693, 1.6989, 4.9343, 46.8419, 1.0523, 93.5455, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (8, 3, '2026-01-10 17:40:52', 113.69, 112.63, 108.10, 0.7482, 49.96, 2.5899, 150.6342, 146.6250, 181.2223, 2.7491, 466.7010, 14.7736, 4.7862, 20.0861, 0.8471, 93.5595, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.0554, 1.1824, 3.2014, 44.5758, 1.3851, 85.2642, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (9, 3, '2026-01-10 03:40:52', 109.11, 111.74, 110.37, 0.7586, 49.98, 0.3380, 154.5843, 177.7117, 189.8057, 2.3929, 450.1099, 19.5135, 2.1792, 20.6871, 0.8450, 90.4348, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 4.5251, 1.9563, 4.5966, 47.8644, 2.2390, 91.6795, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (10, 4, '2026-01-10 17:40:52', 107.47, 109.65, 111.83, 0.6334, 50.01, 1.8400, 168.7915, 181.1556, 164.4033, 2.2366, 493.4187, 22.4086, 3.1067, 17.3328, 0.8422, 91.8176, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.8146, 2.7581, 3.7422, 35.3282, 1.6798, 86.5021, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (11, 4, '2026-01-11 03:40:52', 109.36, 109.23, 111.06, 1.8892, 50.19, 0.2423, 165.4796, 146.4942, 181.0325, 2.7120, 461.7801, 21.8932, 2.0952, 21.2201, 0.8951, 89.2956, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 2.0617, 2.4282, 3.5262, 38.0299, 1.4625, 87.0168, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (12, 4, '2026-01-11 14:40:52', 109.79, 109.35, 110.40, 0.8416, 50.06, 2.9080, 185.8445, 173.3625, 164.2789, 0.7538, 547.1100, 14.9151, 3.7853, 22.3641, 0.8981, 96.2461, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.2641, 2.2659, 4.7020, 42.0901, 1.1411, 92.8911, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (13, 5, '2026-01-10 22:40:52', 112.67, 109.77, 110.81, 1.0759, 49.82, 1.9902, 151.7767, 179.3267, 161.3035, 1.5692, 502.8355, 14.6536, 4.3342, 22.3791, 0.8333, 89.2165, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.5749, 1.5196, 4.1727, 46.8357, 0.5723, 91.5550, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (14, 5, '2026-01-10 06:40:52', 113.19, 112.53, 109.06, 0.2016, 50.05, 2.4222, 152.6997, 164.4989, 174.3952, 2.8986, 537.1345, 18.1230, 4.0296, 17.0660, 0.8314, 88.3384, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 2.4021, 2.1372, 3.3226, 39.9718, 0.8407, 88.5593, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (15, 5, '2026-01-11 11:40:52', 110.99, 107.19, 109.98, 0.0890, 50.18, 1.7949, 151.8599, 188.5277, 162.0589, 2.9807, 533.0651, 15.5526, 3.1118, 19.6836, 0.8979, 96.2096, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.2252, 2.1583, 4.0119, 42.3136, 0.6330, 89.8535, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (16, 6, '2026-01-10 16:40:52', 112.05, 110.95, 111.58, 1.1676, 50.18, 0.0569, 155.4697, 149.7878, 182.5299, 2.5524, 525.2005, 15.8686, 4.3463, 19.3015, 0.8411, 93.9752, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 4.1337, 2.5272, 4.0528, 32.6121, 1.7004, 91.0914, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (17, 6, '2026-01-11 05:40:52', 108.79, 107.59, 111.57, 0.0274, 49.84, 1.5100, 153.5517, 164.8080, 173.3848, 2.5000, 477.4342, 21.8454, 3.6066, 17.5003, 0.9147, 91.4271, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.7861, 2.8974, 4.8721, 48.8163, 2.1639, 88.3728, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (18, 6, '2026-01-10 03:40:52', 107.93, 112.89, 112.66, 1.0331, 49.86, 0.7274, 178.1677, 188.1070, 171.0316, 0.0558, 485.7551, 20.5877, 3.7615, 22.9192, 0.9426, 92.7052, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.6154, 1.5616, 4.3654, 32.0007, 0.7695, 88.7373, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (19, 7, '2026-01-11 15:40:52', 111.27, 110.12, 109.78, 1.3061, 49.83, 1.2052, 180.6460, 178.9969, 163.0464, 2.2161, 499.0386, 16.1226, 4.1241, 23.6618, 0.8347, 94.9909, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.1313, 2.5764, 4.4293, 43.6844, 2.4836, 94.0626, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (20, 7, '2026-01-11 22:40:52', 111.46, 107.02, 107.70, 0.9892, 49.87, 1.1300, 161.5202, 176.7493, 164.1863, 0.0456, 529.6845, 22.4480, 2.9084, 22.5840, 0.8998, 96.1409, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 2.9768, 1.3713, 4.8548, 34.0183, 0.7996, 86.4635, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (21, 7, '2026-01-10 02:40:52', 107.10, 108.10, 112.20, 0.4858, 50.19, 0.5899, 146.2586, 169.7483, 174.9655, 2.0389, 490.0385, 22.6677, 3.8426, 18.4549, 0.8380, 95.8766, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 4.2150, 1.6575, 3.2863, 33.1522, 1.5034, 85.3567, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (22, 8, '2026-01-11 12:40:52', 108.94, 111.23, 108.35, 0.3066, 49.87, 1.4155, 181.0045, 171.3257, 168.6149, 2.6065, 526.9847, 16.1846, 4.7123, 23.3388, 0.8599, 96.7015, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.8072, 1.8033, 2.6027, 45.9919, 1.2906, 90.7766, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (23, 8, '2026-01-10 11:40:52', 112.52, 111.23, 111.59, 0.9313, 49.94, 1.2328, 188.6468, 172.7572, 152.8457, 0.0638, 508.3273, 21.6732, 3.5392, 17.0604, 0.8898, 92.7025, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 4.5665, 2.7335, 4.3016, 34.7155, 2.2546, 91.7911, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (24, 8, '2026-01-10 11:40:52', 111.30, 112.10, 112.59, 1.6194, 50.06, 2.4873, 153.5748, 165.9455, 179.0031, 1.1453, 514.1915, 14.5787, 3.1873, 23.2872, 0.9191, 91.5344, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.6215, 2.2843, 3.7680, 30.4039, 1.1659, 91.0420, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (25, 9, '2026-01-11 10:40:52', 109.97, 108.57, 112.97, 1.1845, 49.96, 0.6825, 187.0739, 189.6575, 152.0659, 2.4238, 506.8602, 17.7729, 3.1708, 22.5490, 0.8657, 92.0591, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 2.4124, 1.9392, 4.8071, 35.3922, 1.5819, 93.9603, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (26, 9, '2026-01-10 20:40:52', 109.93, 109.09, 108.68, 0.5993, 50.11, 0.0043, 175.0104, 159.8607, 174.2721, 0.7852, 485.7239, 14.0087, 4.7994, 22.3021, 0.8917, 93.8366, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.1255, 1.2496, 3.4955, 32.3620, 0.6900, 86.2080, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (27, 9, '2026-01-11 13:40:52', 108.43, 109.29, 107.13, 0.2250, 50.00, 0.5972, 166.3053, 179.6508, 164.3380, 2.5159, 540.3891, 14.0324, 2.9190, 21.1666, 0.9122, 96.6335, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 2.7838, 2.4325, 4.3926, 46.7774, 2.1035, 89.9210, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (28, 10, '2026-01-10 10:40:52', 112.84, 112.42, 109.56, 1.0172, 49.98, 2.0850, 151.4171, 173.2594, 177.0458, 2.0301, 474.7039, 15.8463, 2.8537, 23.4598, 0.8520, 92.9583, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 4.7846, 1.3071, 4.9492, 39.0953, 1.1492, 87.5869, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (29, 10, '2026-01-10 09:40:52', 108.06, 109.06, 107.09, 0.3643, 50.15, 2.4512, 166.0252, 184.8208, 146.0284, 1.3786, 472.9165, 20.9047, 2.4454, 20.5260, 0.9210, 92.6948, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 2.2171, 2.9069, 3.6503, 47.8034, 2.1011, 88.3219, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (30, 10, '2026-01-11 10:40:52', 112.06, 111.98, 109.72, 1.6194, 50.15, 2.9541, 157.3837, 163.9851, 157.7745, 0.4611, 541.6933, 15.1117, 4.6005, 24.7084, 0.8561, 89.9579, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 2.9812, 1.0959, 2.7759, 32.9840, 2.4403, 89.0318, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (31, 11, '2026-01-11 09:40:52', 108.90, 109.84, 108.48, 1.6821, 50.03, 0.9979, 187.7384, 178.7861, 185.7152, 0.8145, 514.3176, 17.6123, 2.2319, 18.4598, 0.9116, 96.5460, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 2.6954, 2.1903, 2.8409, 42.3213, 0.9789, 88.4905, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (32, 11, '2026-01-11 20:40:52', 109.49, 110.63, 110.67, 0.1323, 50.10, 1.7710, 175.5228, 172.9210, 148.0367, 1.4280, 467.7621, 18.1406, 4.3024, 20.6566, 0.9480, 93.4381, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 4.3101, 1.4376, 4.3516, 35.2591, 2.4263, 85.2690, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (33, 11, '2026-01-11 18:40:52', 113.91, 110.51, 110.84, 0.4776, 50.02, 0.0570, 165.4215, 154.5405, 176.4382, 2.5713, 468.9629, 17.3915, 2.9459, 20.5680, 0.8641, 88.8251, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.6807, 2.1074, 2.2630, 45.5466, 1.7473, 92.8619, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (34, 12, '2026-01-10 03:40:52', 110.69, 112.70, 110.42, 1.9971, 50.01, 1.9301, 173.5014, 155.6540, 157.7659, 2.1245, 518.9765, 16.9190, 3.6571, 23.3105, 0.8644, 88.6850, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.4447, 1.4045, 3.6996, 34.5201, 1.3608, 89.7391, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (35, 12, '2026-01-10 02:40:52', 111.31, 108.20, 107.03, 1.0220, 50.02, 0.5178, 155.7858, 175.6260, 175.7728, 1.1324, 533.5788, 14.4190, 4.1763, 20.8997, 0.8613, 96.4280, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.2926, 2.2519, 4.5112, 36.1496, 0.5525, 87.0876, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (36, 12, '2026-01-11 15:40:52', 107.70, 113.34, 108.59, 0.8306, 49.96, 2.2182, 167.7601, 158.9833, 146.6361, 0.7487, 463.8761, 22.5060, 2.9278, 22.6876, 0.9052, 88.0208, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 2.3884, 2.2821, 4.4506, 33.2225, 1.2101, 87.9197, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (37, 13, '2026-01-11 20:40:52', 109.12, 108.55, 108.38, 0.6441, 49.81, 0.3911, 171.7293, 171.0455, 150.0398, 2.4708, 528.2064, 17.9554, 4.5538, 24.5025, 0.8462, 96.6310, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 4.7288, 2.9173, 2.1934, 38.9263, 0.5765, 93.5218, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (38, 13, '2026-01-11 16:40:52', 110.04, 111.54, 113.58, 1.5083, 50.18, 1.4695, 171.9043, 168.3926, 181.2502, 1.4049, 542.4788, 15.9715, 2.9628, 24.5797, 0.9229, 88.3031, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 4.4838, 1.0975, 4.2799, 43.0699, 2.4752, 94.7763, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (39, 13, '2026-01-10 15:40:52', 111.84, 109.65, 112.71, 1.8848, 49.91, 1.5071, 177.1386, 147.8713, 152.9405, 2.0726, 542.4949, 18.9694, 4.9578, 19.1853, 0.8790, 90.2064, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 4.6373, 2.4673, 2.0927, 49.0711, 1.8502, 90.1472, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (40, 14, '2026-01-11 15:40:52', 109.40, 107.86, 111.09, 1.1098, 49.81, 1.3140, 150.7727, 159.7354, 156.3591, 0.8393, 514.1547, 17.3160, 4.7527, 20.8603, 0.9092, 96.5215, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 2.8427, 2.6961, 3.1928, 38.8753, 0.5521, 92.9901, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (41, 14, '2026-01-11 16:40:52', 108.30, 109.58, 109.00, 0.6400, 50.10, 2.2824, 170.7205, 170.8945, 152.3111, 0.2581, 544.2813, 18.1034, 3.3537, 24.1064, 0.8405, 95.7434, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.8245, 2.4356, 4.2936, 43.3848, 0.6052, 87.5528, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (42, 14, '2026-01-10 09:40:52', 112.46, 109.94, 112.31, 1.0657, 49.96, 1.0362, 170.2266, 179.5045, 151.8425, 1.3799, 534.3730, 21.5484, 3.9871, 23.3658, 0.9490, 93.7040, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 4.6324, 2.3522, 4.2442, 44.2414, 1.1323, 89.4455, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (43, 15, '2026-01-11 23:40:52', 109.56, 112.01, 110.38, 0.5299, 50.15, 1.7701, 159.3620, 182.1573, 152.7007, 1.1354, 487.9004, 20.8363, 3.9828, 17.2071, 0.8476, 94.5550, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 4.5128, 1.4431, 3.7847, 36.1986, 2.0298, 93.9477, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (44, 15, '2026-01-11 14:40:52', 110.63, 113.72, 108.69, 0.6592, 50.17, 1.8822, 161.5270, 187.9351, 175.0948, 1.4446, 490.1298, 19.0573, 3.8171, 19.7423, 0.9376, 92.5577, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.7651, 2.1491, 2.3226, 46.2820, 1.9958, 87.9715, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (45, 15, '2026-01-11 09:40:52', 113.08, 109.69, 109.23, 0.8812, 49.90, 2.7250, 181.1603, 158.1775, 147.4066, 1.1667, 528.4078, 20.7831, 3.2485, 23.5582, 0.9320, 95.9261, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.2357, 2.3633, 2.5176, 46.3542, 1.6419, 89.0174, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (46, 16, '2026-01-11 11:40:52', 110.37, 111.08, 110.31, 1.2321, 50.06, 1.3726, 158.6886, 151.6772, 182.3201, 2.1046, 451.9652, 22.9430, 4.7281, 21.5265, 0.8421, 96.0746, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 4.2031, 1.4988, 2.1317, 39.4272, 0.9502, 92.1130, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (47, 16, '2026-01-11 11:40:52', 112.03, 112.43, 112.07, 0.5822, 49.91, 1.6413, 184.7462, 179.8727, 155.1251, 2.4005, 482.5780, 16.0559, 2.4945, 18.1103, 0.8539, 93.8113, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 2.9215, 2.5848, 2.1213, 46.5018, 0.5082, 90.4526, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (48, 16, '2026-01-10 04:40:52', 110.70, 112.88, 111.31, 1.1171, 50.18, 0.1485, 163.5595, 186.1158, 159.9004, 2.7436, 507.9366, 15.3788, 2.0836, 22.4385, 0.8679, 93.3772, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 4.2269, 1.1968, 2.7952, 30.6013, 1.2103, 91.8563, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (49, 17, '2026-01-10 12:40:52', 111.86, 108.41, 113.47, 0.0331, 49.92, 1.5096, 171.2947, 163.5395, 158.8132, 0.8965, 507.3317, 22.7306, 2.3911, 22.9333, 0.8681, 91.6095, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 4.5595, 1.3661, 3.0673, 34.5933, 0.6620, 92.1611, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (50, 17, '2026-01-10 23:40:52', 111.78, 112.58, 113.57, 0.5951, 50.07, 1.4319, 161.4042, 162.5860, 183.7174, 0.3886, 456.6507, 22.4954, 3.5605, 23.1516, 0.8641, 89.1474, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 4.1622, 1.5189, 2.4052, 47.9382, 0.6588, 92.0624, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (51, 17, '2026-01-11 08:40:52', 112.97, 108.58, 111.00, 0.3557, 49.87, 1.0315, 153.6779, 186.9700, 148.8164, 1.8781, 537.5809, 18.5081, 4.6312, 24.0615, 0.9239, 90.6299, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 4.9050, 1.1054, 3.0754, 42.6837, 0.6911, 90.7528, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (52, 18, '2026-01-11 14:40:52', 109.41, 107.38, 108.67, 0.0558, 49.97, 0.1226, 186.8348, 168.6555, 182.7729, 1.8599, 508.1572, 14.4320, 3.4859, 19.6597, 0.8512, 96.8481, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 4.6842, 2.6385, 3.2360, 42.0441, 2.0502, 85.6877, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (53, 18, '2026-01-10 06:40:52', 109.65, 108.62, 107.15, 0.8244, 50.20, 2.2523, 179.2606, 169.9506, 166.9711, 2.3336, 492.4596, 21.1044, 4.0193, 24.9786, 0.9461, 96.4480, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 2.9658, 1.1505, 3.2316, 46.5388, 2.3061, 85.3438, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (54, 18, '2026-01-11 14:40:52', 111.66, 111.87, 110.37, 0.6374, 49.86, 2.3848, 168.5809, 155.5900, 172.2073, 0.9511, 527.1367, 22.1515, 2.6435, 19.8428, 0.8460, 94.0009, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.8023, 1.4072, 2.6471, 39.3539, 1.8828, 85.5379, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (55, 19, '2026-01-10 09:40:52', 110.36, 113.71, 109.48, 1.7939, 49.97, 1.2475, 181.6774, 182.2514, 176.2248, 2.9580, 534.8338, 16.5532, 4.6203, 21.1293, 0.9453, 90.5378, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.1627, 1.3529, 4.1589, 31.3742, 0.8694, 92.1738, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (56, 19, '2026-01-12 00:40:52', 113.73, 112.38, 113.74, 1.0110, 50.06, 2.0492, 167.3038, 164.3031, 174.6042, 0.0074, 453.8774, 15.6779, 4.4476, 21.1602, 0.8483, 90.0245, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.6642, 1.3326, 2.5020, 36.7556, 0.8738, 94.2112, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (57, 19, '2026-01-11 02:40:52', 108.20, 110.31, 112.96, 1.6714, 50.05, 1.8647, 155.3812, 157.9924, 178.8183, 2.6743, 470.2614, 17.0489, 2.2580, 20.3096, 0.9273, 96.1149, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.8776, 2.3898, 3.7909, 48.0012, 1.9188, 93.4691, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (58, 20, '2026-01-10 01:40:52', 111.44, 108.41, 107.72, 1.8250, 49.90, 1.5702, 183.7193, 177.9394, 148.5392, 0.5919, 525.0480, 15.4449, 3.6539, 19.1983, 0.9164, 95.7606, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 4.1601, 1.5440, 2.5998, 33.6742, 1.1374, 85.4236, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (59, 20, '2026-01-11 17:40:52', 113.93, 110.48, 110.58, 0.1382, 50.12, 2.5349, 180.7046, 164.4537, 180.1547, 1.8275, 520.2186, 20.1509, 2.9318, 21.0215, 0.8998, 92.0029, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 2.7693, 1.1627, 3.9124, 48.8647, 2.1076, 86.8925, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (60, 20, '2026-01-11 19:40:52', 113.50, 109.25, 112.77, 0.3080, 49.92, 0.0898, 156.4566, 153.2405, 151.8327, 0.6295, 509.3588, 17.0463, 4.7349, 21.3418, 0.9474, 90.6548, '{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}', '{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}', 3.1736, 1.3192, 3.8734, 42.8689, 1.1877, 92.8883, 2, '2026-01-12 00:40:52');

-- ----------------------------
-- Table structure for eq_environment_data
-- ----------------------------
DROP TABLE IF EXISTS `eq_environment_data`;
CREATE TABLE `eq_environment_data`  (
  `env_id` bigint NOT NULL AUTO_INCREMENT COMMENT '环境数据ID',
  `device_id` bigint NOT NULL COMMENT '设备ID',
  `timestamp` datetime NOT NULL COMMENT '采集时间',
  `ambient_temperature` decimal(10, 2) NULL DEFAULT NULL COMMENT '环境温度(°C)',
  `device_temperature` decimal(10, 2) NULL DEFAULT NULL COMMENT '设备温度(°C)',
  `temperature_change_rate` decimal(10, 4) NULL DEFAULT NULL COMMENT '温度变化率(°C/min)',
  `extreme_high_temp` decimal(10, 2) NULL DEFAULT NULL COMMENT '极端高温(°C)',
  `extreme_low_temp` decimal(10, 2) NULL DEFAULT NULL COMMENT '极端低温(°C)',
  `humidity` decimal(10, 2) NULL DEFAULT NULL COMMENT '相对湿度(%)',
  `dew_point` decimal(10, 2) NULL DEFAULT NULL COMMENT '露点温度(°C)',
  `moisture_content` decimal(10, 4) NULL DEFAULT NULL COMMENT '水分含量',
  `humidity_fluctuation` decimal(10, 2) NULL DEFAULT NULL COMMENT '湿度波动率(%)',
  `vibration_x` decimal(10, 6) NULL DEFAULT NULL COMMENT 'X轴振动(mm/s)',
  `vibration_y` decimal(10, 6) NULL DEFAULT NULL COMMENT 'Y轴振动(mm/s)',
  `vibration_z` decimal(10, 6) NULL DEFAULT NULL COMMENT 'Z轴振动(mm/s)',
  `vibration_frequency` decimal(10, 2) NULL DEFAULT NULL COMMENT '振动频率(Hz)',
  `shock_impact` int NULL DEFAULT NULL COMMENT '冲击次数',
  `max_vibration_level` decimal(10, 4) NULL DEFAULT NULL COMMENT '最大振动级别',
  `environment_grade` tinyint NULL DEFAULT NULL COMMENT '环境等级 1-优良 2-良好 3-一般 4-较差',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`env_id`) USING BTREE,
  INDEX `idx_device_time`(`device_id` ASC, `timestamp` ASC) USING BTREE,
  INDEX `idx_temperature`(`ambient_temperature` ASC) USING BTREE,
  INDEX `idx_humidity`(`humidity` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '环境数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eq_environment_data
-- ----------------------------
INSERT INTO `eq_environment_data` VALUES (1, 1, '2026-01-10 11:01:34', 22.10, 73.00, 1.0800, 83.00, 57.10, 41.30, 16.20, 11.5400, 2.00, 0.109000, 0.125000, 0.299000, 50.60, 2, 2.2600, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (2, 1, '2026-01-10 21:01:34', 28.00, 64.10, 1.9000, 75.40, 52.70, 43.30, 13.90, 7.2600, 4.80, 0.237000, 1.431000, 0.445000, 54.70, 1, 4.7600, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (3, 1, '2026-01-10 12:01:34', 24.80, 60.70, -1.3200, 79.90, 59.40, 43.50, 14.10, 8.2000, 1.80, 1.681000, 0.244000, 0.175000, 45.70, 0, 2.7800, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (4, 2, '2026-01-11 11:01:34', 24.10, 61.80, 0.5900, 82.10, 56.00, 57.20, 15.70, 7.1300, 1.80, 0.398000, 1.785000, 1.728000, 51.40, 3, 2.5300, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (5, 2, '2026-01-10 20:01:34', 28.80, 71.90, 0.0600, 81.80, 58.60, 43.90, 17.50, 14.3000, 2.10, 0.542000, 0.235000, 1.551000, 50.20, 1, 4.6900, 2, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (6, 2, '2026-01-11 08:01:34', 28.70, 65.40, -1.6800, 78.90, 56.90, 44.70, 14.50, 8.1800, 1.30, 0.595000, 1.471000, 1.571000, 52.20, 1, 2.2800, 2, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (7, 3, '2026-01-11 12:01:34', 22.00, 62.50, -0.3200, 79.90, 51.70, 46.90, 15.00, 7.6900, 4.30, 0.999000, 1.823000, 0.121000, 50.70, 3, 3.7400, 2, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (8, 3, '2026-01-10 06:01:34', 26.40, 70.30, 1.4600, 81.50, 56.60, 45.40, 17.00, 10.0600, 2.10, 1.223000, 1.558000, 0.121000, 54.70, 3, 3.0300, 2, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (9, 3, '2026-01-10 10:01:34', 27.50, 64.90, -0.7300, 81.50, 53.10, 50.90, 10.00, 7.4800, 1.20, 0.883000, 0.992000, 0.311000, 47.90, 5, 2.1500, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (10, 4, '2026-01-11 09:01:34', 27.50, 75.40, 0.7400, 75.60, 52.30, 59.90, 12.70, 8.5400, 4.90, 1.582000, 0.085000, 1.680000, 45.70, 4, 4.9600, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (11, 4, '2026-01-11 19:01:34', 22.90, 60.50, 0.8100, 76.80, 57.90, 46.70, 16.20, 14.3300, 3.90, 0.298000, 0.754000, 0.876000, 45.60, 5, 4.2100, 2, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (12, 4, '2026-01-11 02:01:34', 20.90, 60.00, -1.3000, 81.00, 55.00, 52.60, 18.40, 7.0800, 2.60, 1.910000, 0.457000, 0.554000, 52.00, 3, 2.7500, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (13, 5, '2026-01-11 04:01:34', 24.30, 77.00, -1.8700, 80.70, 57.70, 41.10, 13.90, 10.1300, 2.00, 0.940000, 0.291000, 0.633000, 46.50, 4, 3.4600, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (14, 5, '2026-01-10 04:01:34', 23.60, 58.90, -1.4900, 80.20, 52.10, 49.20, 19.00, 14.6900, 0.70, 1.674000, 1.478000, 0.369000, 52.00, 5, 4.2200, 2, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (15, 5, '2026-01-10 14:01:34', 22.50, 59.40, 0.3500, 82.40, 59.40, 48.20, 15.20, 6.8300, 1.80, 0.573000, 0.663000, 1.598000, 45.00, 3, 2.0500, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (16, 6, '2026-01-11 11:01:34', 26.50, 66.70, -1.9100, 84.20, 55.40, 58.30, 10.10, 7.6100, 1.40, 1.285000, 0.716000, 1.724000, 47.40, 3, 2.7400, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (17, 6, '2026-01-10 22:01:34', 23.60, 61.30, 0.7400, 84.70, 58.00, 40.30, 11.00, 7.1000, 3.70, 0.120000, 0.171000, 0.498000, 54.90, 1, 4.9300, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (18, 6, '2026-01-10 15:01:34', 25.10, 67.90, 0.9200, 78.00, 52.90, 50.40, 19.50, 5.3600, 1.70, 1.228000, 0.074000, 0.686000, 51.00, 5, 2.4200, 2, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (19, 7, '2026-01-11 13:01:34', 20.10, 65.30, 0.5100, 76.40, 58.20, 53.10, 19.60, 12.4000, 4.10, 1.801000, 0.061000, 0.901000, 46.60, 2, 4.4000, 2, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (20, 7, '2026-01-10 14:01:34', 27.20, 67.40, 1.9700, 81.80, 54.00, 59.60, 17.00, 10.6700, 3.60, 1.895000, 1.097000, 1.798000, 53.50, 3, 2.6800, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (21, 7, '2026-01-10 17:01:34', 29.20, 71.40, -0.8900, 80.60, 59.80, 42.70, 11.20, 14.8000, 2.60, 1.415000, 1.898000, 1.245000, 47.70, 2, 3.5300, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (22, 8, '2026-01-11 11:01:34', 29.40, 76.60, -0.3700, 80.10, 53.00, 59.60, 10.10, 6.1100, 2.60, 0.540000, 1.577000, 0.263000, 47.90, 0, 3.4100, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (23, 8, '2026-01-11 10:01:34', 21.00, 70.90, 0.5100, 78.80, 50.00, 57.50, 14.10, 9.2000, 4.30, 0.051000, 1.109000, 1.393000, 53.20, 0, 3.7500, 2, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (24, 8, '2026-01-10 16:01:34', 27.70, 75.10, 0.3300, 80.90, 51.90, 42.50, 14.30, 10.5700, 2.40, 1.492000, 0.562000, 0.333000, 54.90, 2, 2.8400, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (25, 9, '2026-01-11 05:01:34', 28.50, 58.80, 0.5600, 76.00, 55.60, 48.90, 18.10, 10.7500, 2.20, 0.918000, 1.969000, 1.090000, 52.70, 1, 4.3500, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (26, 9, '2026-01-10 02:01:34', 20.60, 66.20, 0.8000, 78.80, 58.00, 57.10, 19.30, 5.6600, 2.60, 0.871000, 1.195000, 1.362000, 51.10, 0, 2.7900, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (27, 9, '2026-01-11 01:01:34', 27.10, 59.20, -1.4400, 80.40, 52.90, 56.10, 12.40, 12.4200, 4.90, 1.412000, 1.142000, 1.473000, 54.70, 3, 2.8300, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (28, 10, '2026-01-10 22:01:34', 23.30, 79.70, 1.7800, 82.60, 59.80, 51.20, 10.80, 10.7200, 3.20, 0.899000, 0.699000, 0.795000, 54.40, 3, 4.1800, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (29, 10, '2026-01-11 08:01:34', 24.10, 58.80, 1.7400, 80.60, 50.20, 46.80, 19.40, 10.0100, 3.40, 1.868000, 1.215000, 0.470000, 48.50, 0, 2.7300, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (30, 10, '2026-01-11 04:01:34', 20.40, 78.00, -0.2400, 79.70, 50.30, 54.30, 16.10, 13.3800, 1.80, 0.498000, 0.374000, 0.378000, 48.80, 2, 3.7700, 2, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (31, 11, '2026-01-10 11:01:34', 21.90, 71.10, -0.3400, 77.90, 51.80, 39.20, 17.20, 9.5300, 0.50, 0.228000, 0.575000, 0.192000, 51.20, 4, 2.4000, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (32, 11, '2026-01-10 02:01:34', 30.00, 60.30, 0.1300, 78.40, 51.20, 50.60, 15.10, 13.1400, 2.70, 0.589000, 1.662000, 0.542000, 53.60, 2, 4.7000, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (33, 11, '2026-01-11 09:01:34', 26.30, 61.20, 1.4200, 83.40, 56.10, 50.20, 19.40, 5.1900, 1.40, 0.755000, 0.052000, 1.996000, 54.10, 3, 2.2500, 2, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (34, 12, '2026-01-11 06:01:34', 27.80, 74.30, -0.6300, 79.90, 54.40, 54.30, 13.60, 10.8900, 4.30, 1.096000, 0.301000, 0.215000, 45.90, 1, 2.8500, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (35, 12, '2026-01-10 20:01:34', 26.70, 70.80, 1.6200, 82.80, 51.80, 50.50, 13.00, 12.7400, 4.90, 1.199000, 0.087000, 0.839000, 54.70, 3, 5.0000, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (36, 12, '2026-01-11 12:01:34', 25.90, 60.70, 1.4500, 84.40, 51.30, 55.60, 16.30, 12.4200, 4.10, 1.758000, 1.864000, 0.048000, 48.20, 3, 4.2700, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (37, 13, '2026-01-11 02:01:34', 29.30, 62.60, -0.9400, 82.00, 57.00, 46.50, 18.40, 5.5600, 3.80, 1.179000, 1.386000, 1.391000, 49.00, 5, 3.1000, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (38, 13, '2026-01-11 07:01:34', 25.40, 71.80, 0.0400, 81.60, 57.90, 59.40, 14.80, 9.7700, 4.70, 0.635000, 1.477000, 1.482000, 49.90, 1, 3.8900, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (39, 13, '2026-01-10 21:01:34', 23.70, 60.80, 0.1100, 77.60, 57.40, 57.70, 12.60, 11.3400, 1.90, 1.986000, 1.653000, 0.310000, 47.90, 0, 2.4400, 2, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (40, 14, '2026-01-11 16:01:34', 26.70, 76.40, -1.2500, 79.30, 55.70, 50.10, 10.60, 11.5700, 0.50, 1.033000, 0.579000, 1.794000, 51.20, 2, 2.4300, 2, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (41, 14, '2026-01-11 16:01:34', 23.60, 63.20, -1.5900, 83.10, 57.30, 43.40, 10.30, 9.1800, 5.00, 1.446000, 1.257000, 1.948000, 54.80, 5, 2.1100, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (42, 14, '2026-01-10 07:01:34', 27.30, 59.30, -1.6000, 78.30, 53.30, 52.90, 13.90, 14.2400, 2.20, 0.917000, 1.908000, 0.791000, 46.10, 2, 3.7700, 2, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (43, 15, '2026-01-11 17:01:34', 24.40, 73.60, -1.0300, 75.80, 56.60, 39.80, 14.10, 13.2000, 4.30, 1.733000, 1.471000, 0.156000, 46.80, 3, 4.5800, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (44, 15, '2026-01-10 14:01:34', 28.30, 79.30, -0.5600, 83.90, 53.80, 42.80, 19.50, 5.9000, 3.00, 1.511000, 1.925000, 1.095000, 53.50, 3, 3.3600, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (45, 15, '2026-01-10 03:01:34', 23.70, 79.90, 1.4500, 78.30, 50.50, 43.90, 12.00, 6.7200, 1.40, 1.703000, 0.873000, 1.258000, 53.30, 1, 4.7800, 2, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (46, 16, '2026-01-11 20:01:34', 21.20, 65.80, -0.4300, 84.00, 53.30, 58.60, 16.90, 11.6400, 1.20, 0.388000, 0.518000, 1.425000, 52.80, 4, 3.7500, 2, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (47, 16, '2026-01-11 23:01:34', 24.80, 64.90, -1.5300, 81.50, 59.20, 51.60, 13.30, 13.2300, 0.60, 0.194000, 0.288000, 0.861000, 52.20, 2, 3.1400, 2, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (48, 16, '2026-01-10 12:01:34', 28.30, 77.80, -1.9900, 78.20, 55.70, 57.70, 17.70, 6.7900, 2.90, 0.688000, 1.984000, 1.853000, 51.60, 3, 3.6600, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (49, 17, '2026-01-10 18:01:34', 23.80, 58.00, 1.4800, 78.40, 51.00, 48.30, 10.50, 13.5700, 0.60, 0.118000, 1.833000, 0.811000, 47.80, 1, 2.1600, 2, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (50, 17, '2026-01-11 02:01:34', 22.10, 71.90, 0.0600, 81.80, 58.70, 44.20, 18.10, 7.1000, 3.10, 0.907000, 0.837000, 1.461000, 49.00, 4, 4.3900, 2, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (51, 17, '2026-01-10 22:01:34', 29.90, 64.80, 0.2500, 83.90, 57.50, 39.60, 11.20, 8.9700, 3.10, 1.788000, 1.238000, 0.825000, 47.10, 4, 2.9900, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (52, 18, '2026-01-11 05:01:34', 21.90, 74.10, -1.6400, 77.60, 50.20, 45.10, 15.60, 13.4700, 2.70, 0.337000, 0.433000, 1.156000, 47.40, 2, 3.8000, 2, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (53, 18, '2026-01-11 11:01:34', 25.10, 74.50, -1.1600, 83.00, 53.70, 48.10, 11.80, 10.1600, 0.20, 1.352000, 0.490000, 0.395000, 47.50, 3, 3.7700, 2, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (54, 18, '2026-01-10 03:01:34', 28.70, 69.70, -1.8400, 81.10, 59.50, 57.60, 16.10, 9.0200, 0.80, 1.238000, 1.201000, 0.291000, 54.30, 1, 2.6100, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (55, 19, '2026-01-11 00:01:34', 22.60, 75.10, -1.5700, 77.00, 57.00, 57.30, 13.00, 13.7800, 2.40, 1.534000, 0.788000, 1.338000, 46.60, 4, 3.6300, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (56, 19, '2026-01-10 09:01:34', 22.80, 78.30, 1.0600, 75.50, 59.70, 53.10, 15.30, 10.9700, 2.00, 0.317000, 1.246000, 1.276000, 48.20, 3, 3.5100, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (57, 19, '2026-01-10 16:01:34', 20.50, 62.90, 1.9300, 77.30, 52.20, 46.50, 12.90, 7.6900, 2.40, 1.239000, 1.285000, 0.708000, 53.40, 1, 2.6300, 2, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (58, 20, '2026-01-11 04:01:34', 23.30, 65.70, 1.0200, 82.30, 53.80, 53.60, 14.20, 14.4500, 2.40, 1.117000, 0.713000, 0.214000, 49.70, 0, 3.8900, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (59, 20, '2026-01-10 12:01:34', 24.20, 75.70, 1.1200, 79.80, 50.40, 55.30, 18.00, 11.5600, 4.30, 0.762000, 0.592000, 0.674000, 53.00, 5, 3.3900, 1, '2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (60, 20, '2026-01-10 19:01:34', 28.80, 70.30, -1.4000, 75.80, 59.40, 47.80, 14.20, 12.7300, 3.00, 1.338000, 1.106000, 1.514000, 46.30, 2, 3.2900, 1, '2026-01-12 00:01:34');

-- ----------------------------
-- Table structure for eq_fault_record
-- ----------------------------
DROP TABLE IF EXISTS `eq_fault_record`;
CREATE TABLE `eq_fault_record`  (
  `fault_id` bigint NOT NULL AUTO_INCREMENT COMMENT '故障ID',
  `device_id` bigint NOT NULL COMMENT '设备ID',
  `fault_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '故障代码',
  `fault_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '故障描述',
  `fault_level` tinyint NULL DEFAULT NULL COMMENT '故障等级 1-紧急 2-严重 3-一般 4-轻微',
  `detected_time` datetime NOT NULL COMMENT '发现时间',
  `resolved_time` datetime NULL DEFAULT NULL COMMENT '解决时间',
  `resolution_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '解决备注',
  `root_cause` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '根本原因',
  `repair_duration` int NULL DEFAULT NULL COMMENT '修复时长(分钟)',
  `repair_cost` decimal(10, 2) NULL DEFAULT NULL COMMENT '维修成本',
  `parts_replaced` json NULL COMMENT '更换部件',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态 1-未解决 2-已解决 3-处理中',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`fault_id`) USING BTREE,
  INDEX `idx_device_time`(`device_id` ASC, `detected_time` ASC) USING BTREE,
  INDEX `idx_fault_code`(`fault_code` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '故障记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eq_fault_record
-- ----------------------------
INSERT INTO `eq_fault_record` VALUES (1, 1, 'F1888', '温度过高报警', 2, '2025-12-02 00:40:52', '2025-12-26 00:40:52', '故障已修复，设备恢复正常运行', '操作不当', 64, 1125.90, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (2, 1, 'F3035', '绝缘故障', 2, '2025-11-29 00:40:52', '2025-12-16 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 112, 2853.41, '[\"继电器\", \"保险丝\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (3, 1, 'F9101', '机械磨损', 1, '2025-11-22 00:40:52', '2025-12-23 00:40:52', '故障已修复，设备恢复正常运行', '操作不当', 134, 1011.27, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (4, 2, 'F7372', '机械磨损', 4, '2025-12-04 00:40:52', '2026-01-10 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 48, 907.84, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (5, 2, 'F7356', '机械磨损', 1, '2025-11-20 00:40:52', '2026-01-02 00:40:52', '故障已修复，设备恢复正常运行', '操作不当', 51, 3321.60, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (6, 2, 'F9727', '温度过高报警', 4, '2025-11-03 00:40:52', '2025-12-28 00:40:52', '故障已修复，设备恢复正常运行', '操作不当', 74, 786.61, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (7, 3, 'F5447', '电流过载', 3, '2025-11-17 00:40:52', '2025-12-25 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 144, 1977.53, '[\"继电器\", \"保险丝\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (8, 3, 'F5558', '绝缘故障', 1, '2025-10-31 00:40:52', '2026-01-10 00:40:52', '故障已修复，设备恢复正常运行', '部件老化', 114, 3348.68, '[\"继电器\", \"保险丝\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (9, 3, 'F4381', '机械磨损', 3, '2025-12-06 00:40:52', '2025-12-17 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 66, 2193.84, '[\"继电器\", \"保险丝\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (10, 4, 'F8656', '电流过载', 1, '2025-10-25 00:40:52', '2025-12-16 00:40:52', '故障已修复，设备恢复正常运行', '部件老化', 92, 1916.20, '[\"继电器\", \"保险丝\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (11, 4, 'F5661', '温度过高报警', 3, '2025-11-27 00:40:52', '2025-12-25 00:40:52', '故障已修复，设备恢复正常运行', '部件老化', 55, 1869.38, '[\"继电器\", \"保险丝\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (12, 4, 'F8197', '电压异常波动', 1, '2025-12-05 00:40:52', '2025-12-30 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 92, 1460.71, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (13, 5, 'F2643', '机械磨损', 3, '2025-11-16 00:40:52', '2025-12-28 00:40:52', '故障已修复，设备恢复正常运行', '部件老化', 71, 1133.72, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (14, 5, 'F5086', '温度过高报警', 3, '2025-10-16 00:40:52', '2025-12-22 00:40:52', '故障已修复，设备恢复正常运行', '操作不当', 149, 844.91, '[\"继电器\", \"保险丝\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (15, 5, 'F5846', '机械磨损', 1, '2025-12-08 00:40:52', '2025-12-16 00:40:52', '故障已修复，设备恢复正常运行', '部件老化', 75, 1267.65, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (16, 6, 'F9076', '电压异常波动', 3, '2025-11-15 00:40:52', '2026-01-09 00:40:52', '故障已修复，设备恢复正常运行', '部件老化', 78, 2266.81, '[\"继电器\", \"保险丝\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (17, 6, 'F8673', '电压异常波动', 4, '2025-11-30 00:40:52', '2025-12-31 00:40:52', '故障已修复，设备恢复正常运行', '操作不当', 123, 2539.13, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (18, 6, 'F3480', '电压异常波动', 1, '2025-12-12 00:40:52', '2025-12-20 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 132, 2692.46, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (19, 7, 'F3807', '温度过高报警', 2, '2025-10-16 00:40:52', '2025-12-18 00:40:52', '故障已修复，设备恢复正常运行', '部件老化', 117, 3248.57, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (20, 7, 'F2595', '绝缘故障', 1, '2025-11-18 00:40:52', '2025-12-22 00:40:52', '故障已修复，设备恢复正常运行', '操作不当', 106, 779.55, '[\"继电器\", \"保险丝\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (21, 7, 'F5719', '机械磨损', 1, '2025-10-26 00:40:52', '2025-12-24 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 141, 1541.83, '[\"继电器\", \"保险丝\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (22, 8, 'F7325', '绝缘故障', 1, '2025-12-05 00:40:52', '2026-01-12 00:40:52', '故障已修复，设备恢复正常运行', '操作不当', 50, 3334.64, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (23, 8, 'F2567', '温度过高报警', 4, '2025-11-30 00:40:52', '2025-12-22 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 66, 3093.10, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (24, 8, 'F4801', '机械磨损', 1, '2025-11-12 00:40:52', '2025-12-18 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 57, 2999.11, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (25, 9, 'F9564', '温度过高报警', 3, '2025-12-11 00:40:52', '2025-12-29 00:40:52', '故障已修复，设备恢复正常运行', '操作不当', 60, 1195.76, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (26, 9, 'F3196', '电压异常波动', 3, '2025-11-09 00:40:52', '2026-01-05 00:40:52', '故障已修复，设备恢复正常运行', '操作不当', 105, 2660.59, '[\"继电器\", \"保险丝\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (27, 9, 'F5129', '电压异常波动', 1, '2025-10-26 00:40:52', '2026-01-02 00:40:52', '故障已修复，设备恢复正常运行', '部件老化', 63, 2407.68, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (28, 10, 'F7800', '绝缘故障', 3, '2025-10-25 00:40:52', '2026-01-05 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 127, 3302.38, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (29, 10, 'F4682', '温度过高报警', 2, '2025-10-22 00:40:52', '2026-01-04 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 46, 1420.96, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (30, 10, 'F6680', '机械磨损', 1, '2025-11-03 00:40:52', '2025-12-23 00:40:52', '故障已修复，设备恢复正常运行', '操作不当', 33, 3122.29, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (31, 11, 'F8549', '温度过高报警', 1, '2025-11-19 00:40:52', '2025-12-20 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 87, 764.70, '[\"继电器\", \"保险丝\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (32, 11, 'F7407', '电流过载', 3, '2025-10-18 00:40:52', '2025-12-28 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 32, 3487.86, '[\"继电器\", \"保险丝\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (33, 11, 'F5921', '电压异常波动', 2, '2025-12-08 00:40:52', '2026-01-08 00:40:52', '故障已修复，设备恢复正常运行', '操作不当', 56, 1968.28, '[\"继电器\", \"保险丝\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (34, 12, 'F4886', '机械磨损', 4, '2025-11-11 00:40:52', '2026-01-03 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 120, 3326.33, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (35, 12, 'F5106', '机械磨损', 1, '2025-12-01 00:40:52', '2025-12-28 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 149, 1240.82, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (36, 12, 'F5923', '机械磨损', 1, '2025-10-16 00:40:52', '2026-01-02 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 144, 1635.08, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (37, 13, 'F1230', '电压异常波动', 1, '2025-11-25 00:40:52', '2026-01-03 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 87, 1480.07, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (38, 13, 'F9766', '温度过高报警', 3, '2025-10-18 00:40:52', '2026-01-12 00:40:52', '故障已修复，设备恢复正常运行', '部件老化', 139, 539.58, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (39, 13, 'F6443', '电压异常波动', 2, '2025-10-29 00:40:52', '2025-12-24 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 136, 2163.37, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (40, 14, 'F8671', '机械磨损', 1, '2025-12-03 00:40:52', '2026-01-05 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 126, 3235.11, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (41, 14, 'F9490', '温度过高报警', 3, '2025-11-04 00:40:52', '2026-01-08 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 81, 2930.45, '[\"继电器\", \"保险丝\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (42, 14, 'F4606', '绝缘故障', 2, '2025-11-14 00:40:52', '2025-12-28 00:40:52', '故障已修复，设备恢复正常运行', '部件老化', 120, 2364.96, '[\"继电器\", \"保险丝\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (43, 15, 'F3723', '电压异常波动', 1, '2025-10-30 00:40:52', '2026-01-06 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 144, 3405.74, '[\"继电器\", \"保险丝\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (44, 15, 'F1511', '温度过高报警', 2, '2025-10-21 00:40:52', '2026-01-01 00:40:52', '故障已修复，设备恢复正常运行', '部件老化', 131, 2497.30, '[\"继电器\", \"保险丝\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (45, 15, 'F9087', '电压异常波动', 1, '2025-10-18 00:40:52', '2025-12-30 00:40:52', '故障已修复，设备恢复正常运行', '操作不当', 142, 1393.00, '[\"继电器\", \"保险丝\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (46, 16, 'F5566', '电流过载', 4, '2025-11-24 00:40:52', '2025-12-22 00:40:52', '故障已修复，设备恢复正常运行', '操作不当', 110, 2538.48, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (47, 16, 'F9287', '电流过载', 2, '2025-11-06 00:40:52', '2025-12-15 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 103, 1656.67, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (48, 16, 'F3663', '温度过高报警', 1, '2025-12-05 00:40:52', '2026-01-06 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 137, 1550.31, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (49, 17, 'F2995', '机械磨损', 1, '2025-11-15 00:40:52', '2026-01-07 00:40:52', '故障已修复，设备恢复正常运行', '操作不当', 138, 621.85, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (50, 17, 'F4285', '温度过高报警', 3, '2025-10-24 00:40:52', '2025-12-27 00:40:52', '故障已修复，设备恢复正常运行', '部件老化', 43, 880.66, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (51, 17, 'F1874', '电流过载', 3, '2025-10-31 00:40:52', '2025-12-28 00:40:52', '故障已修复，设备恢复正常运行', '操作不当', 58, 961.74, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (52, 18, 'F7910', '绝缘故障', 1, '2025-10-20 00:40:52', '2025-12-15 00:40:52', '故障已修复，设备恢复正常运行', '部件老化', 89, 1194.76, '[\"继电器\", \"保险丝\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (53, 18, 'F7337', '电流过载', 2, '2025-12-12 00:40:52', '2026-01-05 00:40:52', '故障已修复，设备恢复正常运行', '部件老化', 65, 3011.49, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (54, 18, 'F9689', '机械磨损', 4, '2025-11-30 00:40:52', '2025-12-23 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 122, 2207.53, '[\"继电器\", \"保险丝\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (55, 19, 'F9188', '机械磨损', 1, '2025-10-22 00:40:52', '2025-12-16 00:40:52', '故障已修复，设备恢复正常运行', '环境因素', 136, 2438.52, '[\"继电器\", \"保险丝\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (56, 19, 'F9585', '电压异常波动', 2, '2025-11-17 00:40:52', '2026-01-04 00:40:52', '故障已修复，设备恢复正常运行', '部件老化', 83, 750.12, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (57, 19, 'F1806', '温度过高报警', 4, '2025-12-12 00:40:52', '2026-01-04 00:40:52', '故障已修复，设备恢复正常运行', '部件老化', 124, 3388.20, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (58, 20, 'F4148', '电流过载', 4, '2025-11-02 00:40:52', '2025-12-28 00:40:52', '故障已修复，设备恢复正常运行', '操作不当', 124, 2209.83, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (59, 20, 'F7012', '机械磨损', 3, '2025-12-09 00:40:52', '2025-12-22 00:40:52', '故障已修复，设备恢复正常运行', '部件老化', 59, 1771.53, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (60, 20, 'F6603', '机械磨损', 1, '2025-12-05 00:40:52', '2025-12-23 00:40:52', '故障已修复，设备恢复正常运行', '部件老化', 147, 3089.83, '[\"接触器\"]', 2, '故障已解决', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');

-- ----------------------------
-- Table structure for eq_maintenance_record
-- ----------------------------
DROP TABLE IF EXISTS `eq_maintenance_record`;
CREATE TABLE `eq_maintenance_record`  (
  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `device_id` bigint NOT NULL COMMENT '设备ID',
  `maintenance_type` tinyint NULL DEFAULT NULL COMMENT '维护类型 1-预防性 2-纠正性 3-预测性',
  `maintenance_date` datetime NOT NULL COMMENT '维护日期',
  `next_maintenance_date` datetime NULL DEFAULT NULL COMMENT '下次维护日期',
  `maintenance_cost` decimal(10, 2) NULL DEFAULT NULL COMMENT '维护成本',
  `performed_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '执行人员',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '维护描述',
  `parts_replaced` json NULL COMMENT '更换部件',
  `technician_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '技术人员备注',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态 1-已完成 2-已安排 3-进行中 4-已取消',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`record_id`) USING BTREE,
  INDEX `idx_device_date`(`device_id` ASC, `maintenance_date` ASC) USING BTREE,
  INDEX `idx_maintenance_type`(`maintenance_type` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '维护记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eq_maintenance_record
-- ----------------------------
INSERT INTO `eq_maintenance_record` VALUES (1, 1, 1, '2025-12-27 00:40:52', '2026-03-28 00:40:52', 2003.29, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (2, 1, 1, '2025-10-16 00:40:52', '2026-02-20 00:40:52', 4283.64, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (3, 1, 1, '2025-11-15 00:40:52', '2026-03-29 00:40:52', 4602.38, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (4, 2, 1, '2025-12-26 00:40:52', '2026-02-28 00:40:52', 4532.05, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (5, 2, 1, '2025-11-26 00:40:52', '2026-04-10 00:40:52', 2299.43, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (6, 2, 1, '2025-11-12 00:40:52', '2026-03-09 00:40:52', 1589.21, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (7, 3, 1, '2025-12-06 00:40:52', '2026-03-22 00:40:52', 1052.35, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (8, 3, 1, '2026-01-03 00:40:52', '2026-03-11 00:40:52', 1279.60, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (9, 3, 1, '2025-10-22 00:40:52', '2026-03-07 00:40:52', 1954.12, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (10, 4, 1, '2025-10-15 00:40:52', '2026-02-24 00:40:52', 1780.73, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (11, 4, 1, '2025-12-19 00:40:52', '2026-03-31 00:40:52', 1697.45, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (12, 4, 1, '2025-12-01 00:40:52', '2026-03-31 00:40:52', 3716.52, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (13, 5, 1, '2025-10-19 00:40:52', '2026-03-24 00:40:52', 3489.98, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (14, 5, 1, '2026-01-09 00:40:52', '2026-03-01 00:40:52', 2852.44, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (15, 5, 1, '2025-12-10 00:40:52', '2026-03-11 00:40:52', 1965.87, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (16, 6, 1, '2025-11-02 00:40:52', '2026-02-25 00:40:52', 4254.07, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (17, 6, 1, '2025-12-12 00:40:52', '2026-03-02 00:40:52', 3246.89, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (18, 6, 1, '2025-10-29 00:40:52', '2026-03-12 00:40:52', 4891.64, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (19, 7, 1, '2025-12-10 00:40:52', '2026-04-09 00:40:52', 3665.36, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (20, 7, 1, '2025-12-02 00:40:52', '2026-02-27 00:40:52', 1154.28, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (21, 7, 1, '2025-12-12 00:40:52', '2026-03-20 00:40:52', 1377.45, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (22, 8, 1, '2025-11-21 00:40:52', '2026-03-22 00:40:52', 3030.42, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (23, 8, 1, '2025-11-22 00:40:52', '2026-03-04 00:40:52', 1242.35, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (24, 8, 1, '2025-12-23 00:40:52', '2026-04-09 00:40:52', 1566.34, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (25, 9, 1, '2025-11-01 00:40:52', '2026-03-20 00:40:52', 3763.54, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (26, 9, 1, '2025-11-21 00:40:52', '2026-04-02 00:40:52', 2792.44, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (27, 9, 1, '2025-11-08 00:40:52', '2026-02-27 00:40:52', 1779.19, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (28, 10, 1, '2025-12-30 00:40:52', '2026-02-22 00:40:52', 2939.51, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (29, 10, 1, '2025-10-28 00:40:52', '2026-04-01 00:40:52', 3122.77, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (30, 10, 1, '2025-12-26 00:40:52', '2026-03-06 00:40:52', 2454.82, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (31, 11, 1, '2025-11-15 00:40:52', '2026-02-19 00:40:52', 4070.92, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (32, 11, 1, '2025-12-06 00:40:52', '2026-03-29 00:40:52', 3393.77, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (33, 11, 1, '2025-11-12 00:40:52', '2026-03-21 00:40:52', 1586.69, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (34, 12, 1, '2025-11-01 00:40:52', '2026-03-18 00:40:52', 3303.63, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (35, 12, 1, '2026-01-05 00:40:52', '2026-03-23 00:40:52', 1449.67, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (36, 12, 1, '2025-11-24 00:40:52', '2026-03-08 00:40:52', 2775.62, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (37, 13, 1, '2025-10-18 00:40:52', '2026-03-11 00:40:52', 2908.17, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (38, 13, 1, '2025-10-17 00:40:52', '2026-03-08 00:40:52', 1712.33, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (39, 13, 1, '2025-11-16 00:40:52', '2026-03-22 00:40:52', 2465.78, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (40, 14, 1, '2025-10-27 00:40:52', '2026-02-24 00:40:52', 3029.62, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (41, 14, 1, '2025-10-26 00:40:52', '2026-04-03 00:40:52', 3793.21, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (42, 14, 1, '2025-10-24 00:40:52', '2026-03-05 00:40:52', 1657.45, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (43, 15, 1, '2025-11-09 00:40:52', '2026-02-16 00:40:52', 2179.23, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (44, 15, 1, '2025-12-25 00:40:52', '2026-02-20 00:40:52', 1587.34, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (45, 15, 1, '2025-12-19 00:40:52', '2026-04-07 00:40:52', 4147.93, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (46, 16, 1, '2025-12-28 00:40:52', '2026-03-13 00:40:52', 4975.98, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (47, 16, 1, '2025-12-02 00:40:52', '2026-03-02 00:40:52', 2084.71, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (48, 16, 1, '2025-12-11 00:40:52', '2026-04-11 00:40:52', 4425.13, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (49, 17, 1, '2025-12-15 00:40:52', '2026-02-12 00:40:52', 1723.16, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (50, 17, 1, '2025-10-31 00:40:52', '2026-03-16 00:40:52', 2374.05, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (51, 17, 1, '2026-01-09 00:40:52', '2026-02-19 00:40:52', 3398.79, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (52, 18, 1, '2025-11-22 00:40:52', '2026-02-16 00:40:52', 3804.01, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (53, 18, 1, '2025-12-21 00:40:52', '2026-02-18 00:40:52', 4553.78, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (54, 18, 1, '2026-01-06 00:40:52', '2026-03-23 00:40:52', 1594.38, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (55, 19, 1, '2025-11-08 00:40:52', '2026-02-24 00:40:52', 4598.25, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (56, 19, 1, '2025-10-29 00:40:52', '2026-03-12 00:40:52', 4811.49, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (57, 19, 1, '2025-12-18 00:40:52', '2026-03-16 00:40:52', 4766.26, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (58, 20, 1, '2026-01-10 00:40:52', '2026-03-03 00:40:52', 3391.02, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (59, 20, 1, '2025-10-17 00:40:52', '2026-02-14 00:40:52', 2592.72, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (60, 20, 1, '2025-11-01 00:40:52', '2026-04-01 00:40:52', 3859.87, '维护班组A', '定期预防性维护检查', '[\"滤芯\", \"密封圈\"]', '设备运行正常，无异常', 1, '维护完成', 'admin', '2026-01-12 00:40:52', '', '2026-01-12 00:40:52');

-- ----------------------------
-- Table structure for eq_mechanical_data
-- ----------------------------
DROP TABLE IF EXISTS `eq_mechanical_data`;
CREATE TABLE `eq_mechanical_data`  (
  `mechanical_id` bigint NOT NULL AUTO_INCREMENT COMMENT '机械数据ID',
  `device_id` bigint NOT NULL COMMENT '设备ID',
  `timestamp` datetime NOT NULL COMMENT '采集时间',
  `load_weight` decimal(10, 2) NULL DEFAULT NULL COMMENT '载荷重量(kg)',
  `load_ratio` decimal(10, 4) NULL DEFAULT NULL COMMENT '载荷比率(%)',
  `stress_level` decimal(10, 4) NULL DEFAULT NULL COMMENT '应力水平(MPa)',
  `fatigue_cycles` int NULL DEFAULT NULL COMMENT '疲劳循环次数',
  `overload_times` int NULL DEFAULT NULL COMMENT '超载次数',
  `vibration_amplitude` decimal(10, 6) NULL DEFAULT NULL COMMENT '振动幅值(mm)',
  `vibration_velocity` decimal(10, 6) NULL DEFAULT NULL COMMENT '振动速度(mm/s)',
  `vibration_acceleration` decimal(10, 6) NULL DEFAULT NULL COMMENT '振动加速度(g)',
  `vibration_spectrum` json NULL COMMENT '振动频谱数据',
  `vibration_direction` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '振动方向',
  `corrosion_rate` decimal(10, 6) NULL DEFAULT NULL COMMENT '腐蚀速率(mm/year)',
  `corrosion_depth` decimal(10, 4) NULL DEFAULT NULL COMMENT '腐蚀深度(mm)',
  `surface_condition` tinyint NULL DEFAULT NULL COMMENT '表面状态 1-良好 2-一般 3-较差 4-严重',
  `coating_thickness` decimal(10, 4) NULL DEFAULT NULL COMMENT '涂层厚度(mm)',
  `material_temperature` decimal(10, 2) NULL DEFAULT NULL COMMENT '材料温度(°C)',
  `thermal_expansion` decimal(10, 6) NULL DEFAULT NULL COMMENT '热膨胀系数',
  `material_hardness` decimal(10, 4) NULL DEFAULT NULL COMMENT '材料硬度(HRC)',
  `mechanical_grade` tinyint NULL DEFAULT NULL COMMENT '机械等级 1-优良 2-良好 3-一般 4-较差',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`mechanical_id`) USING BTREE,
  INDEX `idx_device_time`(`device_id` ASC, `timestamp` ASC) USING BTREE,
  INDEX `idx_load`(`load_weight` ASC) USING BTREE,
  INDEX `idx_vibration`(`vibration_amplitude` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '机械数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eq_mechanical_data
-- ----------------------------
INSERT INTO `eq_mechanical_data` VALUES (1, 1, '2026-01-11 15:40:52', 7936.25, 77.3890, 93.3398, 27907, 5, 3.100864, 19.757655, 2.369176, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.270943, 1.2850, 1, 127.8671, 20.23, 1.329560, 205.6583, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (2, 1, '2026-01-10 13:40:52', 16494.95, 79.8037, 66.0613, 53598, 8, 1.696738, 5.053993, 2.905021, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.356383, 0.8692, 4, 159.5694, 85.77, 2.287412, 155.0129, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (3, 1, '2026-01-11 07:40:52', 14746.57, 63.3252, 63.3050, 16220, 2, 5.176217, 12.181657, 5.343296, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.384120, 0.6832, 2, 108.4594, 76.18, 0.798192, 194.1263, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (4, 2, '2026-01-11 00:40:52', 10005.17, 67.7642, 118.2362, 28455, 9, 1.150343, 9.368436, 1.012323, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.132787, 1.4733, 2, 145.0789, 49.17, 2.409349, 216.2160, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (5, 2, '2026-01-11 02:40:52', 17227.22, 80.8108, 66.7508, 50816, 5, 0.045284, 12.817404, 4.163985, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.513131, 0.6098, 3, 128.3986, 77.73, 0.069343, 245.1221, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (6, 2, '2026-01-10 22:40:52', 16096.65, 58.3062, 66.4396, 46352, 0, 0.979736, 13.454135, 2.822747, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.214102, 0.3347, 3, 136.9314, 31.83, 0.159912, 230.4547, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (7, 3, '2026-01-10 03:40:52', 5512.30, 77.2810, 139.4415, 38545, 2, 2.588908, 11.058971, 5.057373, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.260793, 1.1796, 1, 178.3532, 29.17, 0.250234, 154.6383, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (8, 3, '2026-01-11 00:40:52', 5827.32, 55.5907, 122.8853, 42226, 0, 2.122586, 13.149063, 4.488945, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.584467, 0.1252, 2, 120.9397, 56.18, 2.145179, 238.8316, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (9, 3, '2026-01-10 11:40:52', 8201.26, 88.1177, 144.0529, 53663, 6, 1.012960, 6.594752, 2.021900, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.158268, 0.5319, 2, 157.1835, 83.73, 2.091965, 226.8036, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (10, 4, '2026-01-10 20:40:52', 16558.86, 60.6207, 92.0576, 47471, 4, 5.861598, 12.514997, 4.150687, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.048128, 0.5967, 4, 52.4349, 49.28, 1.907923, 215.5184, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (11, 4, '2026-01-11 09:40:52', 10931.13, 61.3959, 109.4823, 35162, 8, 1.681493, 5.485428, 3.617251, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.193989, 0.2509, 3, 100.5649, 34.13, 2.269574, 244.6639, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (12, 4, '2026-01-11 12:40:52', 8086.17, 71.9174, 113.3142, 49755, 0, 5.440351, 9.507188, 0.504104, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.513042, 0.9021, 1, 62.3905, 87.22, 2.210678, 238.3281, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (13, 5, '2026-01-11 11:40:52', 5245.27, 73.1287, 82.4136, 19841, 0, 3.989339, 5.850120, 3.417464, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.061412, 2.0002, 3, 55.2612, 38.60, 0.143021, 200.9182, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (14, 5, '2026-01-10 07:40:52', 17070.56, 72.8619, 55.6015, 58638, 6, 5.456607, 17.578317, 3.074603, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.359148, 2.2672, 3, 195.8105, 71.19, 0.811003, 215.9819, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (15, 5, '2026-01-12 00:40:52', 16979.74, 56.2962, 123.9041, 41604, 10, 5.671329, 16.731930, 1.215318, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.126730, 0.1796, 3, 108.8961, 90.53, 0.464643, 173.9540, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (16, 6, '2026-01-11 11:40:52', 18878.71, 83.4725, 74.1630, 57307, 9, 4.167313, 15.987926, 3.812854, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.202725, 1.2351, 2, 169.0619, 69.87, 1.903437, 240.4797, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (17, 6, '2026-01-10 20:40:52', 6170.86, 87.3552, 67.5891, 23723, 9, 2.550770, 12.420774, 2.280534, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.563924, 0.2361, 3, 196.8777, 95.19, 1.917969, 146.2478, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (18, 6, '2026-01-10 12:40:52', 11913.75, 62.4248, 105.5702, 20889, 5, 4.803288, 11.619532, 5.397300, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.242886, 1.5453, 4, 126.6702, 18.47, 1.119823, 168.3584, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (19, 7, '2026-01-11 16:40:52', 13126.86, 66.4296, 141.7587, 40649, 4, 5.943711, 17.256697, 1.354312, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.198491, 1.3701, 3, 59.6932, 36.91, 2.171666, 213.4077, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (20, 7, '2026-01-11 10:40:52', 12970.97, 86.3005, 127.8911, 21743, 10, 5.837824, 4.085350, 1.038800, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.174423, 2.2128, 3, 62.4216, 91.91, 0.423337, 159.9896, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (21, 7, '2026-01-10 20:40:52', 10175.00, 59.4698, 95.4761, 9066, 7, 1.440946, 7.516667, 2.392427, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.017882, 1.1246, 1, 114.7296, 81.11, 1.246896, 164.4012, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (22, 8, '2026-01-10 20:40:52', 14167.10, 69.9200, 68.6355, 52025, 6, 1.497575, 13.188297, 1.112777, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.049314, 1.8526, 2, 55.8352, 97.84, 1.647209, 184.1922, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (23, 8, '2026-01-11 09:40:52', 19572.86, 85.8411, 96.0262, 48887, 5, 0.054266, 13.991408, 0.975909, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.436234, 2.0693, 4, 92.1183, 71.11, 0.815787, 217.3036, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (24, 8, '2026-01-11 12:40:52', 18091.52, 77.3937, 103.4793, 52993, 7, 4.089804, 11.067422, 1.318336, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.584983, 0.9882, 1, 56.0746, 34.64, 2.000179, 186.1293, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (25, 9, '2026-01-10 19:40:52', 10519.39, 61.5749, 120.2728, 9084, 10, 4.233483, 14.672211, 1.591623, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.478767, 1.7949, 1, 173.0585, 62.51, 0.589393, 202.7711, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (26, 9, '2026-01-10 21:40:52', 15345.86, 84.4487, 53.3590, 53441, 1, 0.186500, 16.220696, 4.128587, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.305328, 1.3320, 1, 58.6410, 20.31, 2.192707, 176.5790, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (27, 9, '2026-01-11 02:40:52', 14944.70, 56.3743, 60.1404, 39365, 6, 0.641744, 16.558330, 3.518031, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.303541, 1.3487, 1, 88.3942, 88.58, 1.159981, 222.4516, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (28, 10, '2026-01-11 12:40:52', 11228.51, 70.9141, 141.4001, 19773, 4, 1.258428, 18.644729, 5.236319, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.066222, 1.4514, 3, 63.0863, 89.21, 2.480043, 182.2583, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (29, 10, '2026-01-10 04:40:52', 7788.68, 69.1823, 78.1444, 26859, 9, 1.464353, 13.936554, 2.364982, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.534242, 1.1159, 3, 116.9662, 70.43, 2.010614, 155.8091, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (30, 10, '2026-01-11 15:40:52', 15191.82, 86.2963, 84.1055, 17340, 8, 2.191549, 11.740977, 2.116403, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.513004, 1.9503, 2, 97.3346, 73.88, 0.985228, 242.2557, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (31, 11, '2026-01-11 02:40:52', 19731.71, 73.1339, 112.2901, 41797, 3, 4.117234, 11.190089, 1.441429, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.240948, 0.5701, 4, 198.9250, 31.04, 2.039783, 208.2629, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (32, 11, '2026-01-12 00:40:52', 10200.53, 86.0992, 74.4153, 46224, 9, 5.817457, 9.487864, 4.531144, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.355298, 2.3858, 4, 62.4095, 65.27, 1.363232, 249.6969, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (33, 11, '2026-01-10 12:40:52', 15783.43, 69.3851, 133.7904, 59745, 4, 1.247754, 15.581303, 5.476401, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.023215, 1.9468, 4, 130.5343, 52.96, 1.190563, 155.7194, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (34, 12, '2026-01-11 20:40:52', 8281.67, 56.0595, 81.5978, 41900, 2, 0.685660, 18.869406, 2.019297, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.446902, 1.3258, 2, 121.7009, 36.26, 1.572549, 195.0815, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (35, 12, '2026-01-11 22:40:52', 16744.28, 83.3039, 113.6562, 51851, 2, 4.466291, 19.317687, 3.268158, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.491738, 1.0239, 3, 156.0610, 84.87, 2.320072, 165.3265, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (36, 12, '2026-01-11 08:40:52', 6252.27, 79.0960, 47.0982, 9796, 1, 2.761558, 19.407365, 2.670112, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.062454, 1.6919, 1, 95.7279, 52.59, 0.318630, 184.0276, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (37, 13, '2026-01-11 12:40:52', 18381.55, 79.4280, 128.2838, 53347, 10, 1.726478, 11.941860, 3.592962, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.098124, 0.0153, 3, 150.5998, 82.51, 2.223779, 154.1908, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (38, 13, '2026-01-10 21:40:52', 13723.87, 65.1375, 110.6237, 21312, 4, 1.544217, 5.145777, 3.429735, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.490002, 2.3466, 1, 107.0087, 40.20, 0.383256, 245.2150, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (39, 13, '2026-01-10 15:40:52', 12844.65, 78.4588, 117.7532, 31591, 2, 3.526178, 9.907778, 0.915456, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.173680, 1.3102, 4, 74.1366, 74.07, 2.136926, 168.3760, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (40, 14, '2026-01-11 21:40:52', 15758.70, 70.6009, 47.5146, 48691, 9, 5.137447, 16.142760, 1.629444, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.351431, 0.9264, 1, 101.8169, 62.76, 1.574010, 198.5972, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (41, 14, '2026-01-10 11:40:52', 19021.00, 66.7808, 135.9859, 24789, 0, 0.632258, 11.719545, 0.981145, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.527978, 0.7466, 4, 102.4098, 41.96, 0.874171, 236.5438, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (42, 14, '2026-01-10 04:40:52', 15956.15, 87.5338, 87.6201, 20527, 10, 1.269522, 5.557328, 4.759519, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.169133, 1.2672, 3, 188.0775, 63.03, 2.441472, 169.7219, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (43, 15, '2026-01-10 23:40:52', 18600.52, 88.9397, 56.6483, 41569, 9, 3.229743, 4.103511, 2.587378, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.052453, 0.5830, 4, 171.9468, 49.48, 1.156113, 161.8566, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (44, 15, '2026-01-10 20:40:52', 15677.02, 85.2237, 58.4642, 10628, 9, 1.132004, 9.426295, 1.148578, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.459954, 2.3488, 2, 71.4025, 71.99, 1.952130, 242.5597, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (45, 15, '2026-01-10 14:40:52', 15713.47, 71.6440, 64.0516, 32990, 9, 5.107576, 14.887982, 4.743531, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.278432, 1.7854, 1, 161.3779, 35.89, 2.095484, 201.3395, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (46, 16, '2026-01-11 13:40:52', 14448.47, 74.9667, 138.7958, 47261, 1, 1.268655, 16.340445, 1.610309, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.189716, 0.4789, 1, 118.0055, 44.87, 0.562968, 160.0169, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (47, 16, '2026-01-10 12:40:52', 15590.24, 66.0657, 87.8024, 12665, 2, 5.155444, 13.906577, 3.090415, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.066248, 0.8832, 2, 62.9264, 40.39, 0.045114, 173.4783, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (48, 16, '2026-01-10 15:40:52', 13201.78, 82.5427, 66.9807, 43666, 8, 5.697766, 9.499955, 4.849266, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.588337, 2.3718, 4, 70.3919, 51.87, 1.434751, 211.1803, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (49, 17, '2026-01-11 12:40:52', 19999.34, 62.9200, 58.8134, 58903, 5, 3.377402, 9.035287, 4.924132, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.447359, 0.7199, 1, 68.3813, 29.92, 0.686443, 243.3446, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (50, 17, '2026-01-11 01:40:52', 17701.79, 83.7410, 101.3612, 19458, 5, 4.776766, 12.101266, 1.216314, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.334107, 0.4806, 2, 180.8814, 59.92, 2.315628, 155.2404, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (51, 17, '2026-01-11 12:40:52', 6120.73, 86.7523, 59.5323, 58460, 4, 1.635434, 4.841808, 2.726741, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.005080, 2.0891, 1, 84.8042, 85.72, 0.896451, 178.1286, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (52, 18, '2026-01-10 21:40:52', 8915.36, 84.6962, 78.6715, 11016, 3, 2.797012, 9.547378, 2.175249, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.102257, 2.3670, 1, 87.3160, 75.15, 1.664999, 170.0936, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (53, 18, '2026-01-11 12:40:52', 15964.60, 87.7523, 90.7314, 27257, 5, 3.687165, 10.996819, 2.214616, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.590877, 1.7896, 3, 196.3478, 18.64, 0.274505, 200.1818, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (54, 18, '2026-01-10 05:40:52', 14871.06, 77.8412, 68.5942, 16617, 1, 1.650646, 18.595023, 4.178109, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.300507, 1.6990, 4, 112.9777, 59.53, 0.540825, 204.0555, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (55, 19, '2026-01-11 18:40:52', 6453.78, 68.3376, 91.7556, 12327, 0, 0.910184, 12.282466, 1.165893, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.099071, 1.2170, 4, 81.0837, 46.54, 0.104935, 162.3932, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (56, 19, '2026-01-12 00:40:52', 19462.46, 82.5798, 49.2790, 51668, 0, 5.183797, 5.437429, 4.786491, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.307783, 1.2849, 1, 139.8773, 97.39, 0.011649, 157.4636, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (57, 19, '2026-01-10 23:40:52', 19505.41, 62.7294, 65.6777, 24750, 0, 0.797961, 13.685286, 3.638356, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '水平', 0.437288, 1.6924, 1, 193.9744, 35.25, 0.421632, 167.2650, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (58, 20, '2026-01-11 18:40:52', 4215.21, 78.1517, 73.0387, 26238, 10, 4.264949, 15.140664, 2.244915, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.139954, 0.4954, 2, 178.3938, 53.26, 1.420234, 202.8048, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (59, 20, '2026-01-10 20:40:52', 16886.67, 63.9894, 136.1354, 37601, 2, 3.025990, 16.710321, 2.794901, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.108983, 0.4326, 2, 57.7736, 54.99, 0.020978, 217.3012, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (60, 20, '2026-01-11 23:40:52', 17785.08, 63.3637, 109.0618, 25350, 9, 1.134622, 10.903146, 3.449610, '{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}', '垂直', 0.303950, 1.4178, 2, 181.0391, 54.16, 1.429410, 201.2751, 3, '2026-01-12 00:40:52');

-- ----------------------------
-- Table structure for eq_operational_data
-- ----------------------------
DROP TABLE IF EXISTS `eq_operational_data`;
CREATE TABLE `eq_operational_data`  (
  `operational_id` bigint NOT NULL AUTO_INCREMENT COMMENT '操作数据ID',
  `device_id` bigint NOT NULL COMMENT '设备ID',
  `timestamp` datetime NOT NULL COMMENT '操作时间',
  `operator_id` bigint NULL DEFAULT NULL COMMENT '操作员ID',
  `operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作员姓名',
  `operator_skill_level` tinyint NULL DEFAULT NULL COMMENT '操作技能等级 1-初级 2-中级 3-高级 4-专家',
  `training_completion` tinyint NULL DEFAULT NULL COMMENT '培训完成度(%)',
  `operation_type` tinyint NULL DEFAULT NULL COMMENT '操作类型 1-开机 2-关机 3-调试 4-维护 5-故障处理',
  `operation_duration` int NULL DEFAULT NULL COMMENT '操作持续时间(秒)',
  `operation_result` tinyint NULL DEFAULT NULL COMMENT '操作结果 1-成功 2-失败 3-警告',
  `operation_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '操作备注',
  `maintenance_type` tinyint NULL DEFAULT NULL COMMENT '维护类型 1-预防性 2-纠正性 3-预测性 4-紧急',
  `maintenance_duration` int NULL DEFAULT NULL COMMENT '维护持续时间(分钟)',
  `maintenance_cost` decimal(10, 2) NULL DEFAULT NULL COMMENT '维护成本',
  `parts_used` json NULL COMMENT '使用部件',
  `operator_performance_score` decimal(10, 4) NULL DEFAULT NULL COMMENT '操作员绩效评分',
  `safety_compliance` tinyint NULL DEFAULT NULL COMMENT '安全合规度(%)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`operational_id`) USING BTREE,
  INDEX `idx_device_time`(`device_id` ASC, `timestamp` ASC) USING BTREE,
  INDEX `idx_operator`(`operator_id` ASC) USING BTREE,
  INDEX `idx_operation`(`operation_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '操作数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eq_operational_data
-- ----------------------------
INSERT INTO `eq_operational_data` VALUES (1, 1, '2026-01-11 09:40:52', 1018, '操作员8', 4, 95, 1, 28, 1, '操作正常，无异常', 4, 74, 692.92, '[\"滤芯\"]', 89.5957, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (2, 1, '2026-01-11 01:40:52', 1070, '操作员16', 3, 71, 4, 61, 1, '操作顺利完成', 1, 61, 407.49, '[\"密封圈\", \"润滑油\"]', 77.8571, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (3, 1, '2026-01-10 21:40:52', 1062, '操作员29', 4, 79, 1, 132, 1, '操作顺利完成', 3, 59, 958.24, '[\"密封圈\", \"润滑油\"]', 89.9251, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (4, 2, '2026-01-10 02:40:52', 1072, '操作员19', 4, 91, 5, 51, 1, '操作正常，无异常', 2, 48, 773.54, '[\"密封圈\", \"润滑油\"]', 85.1607, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (5, 2, '2026-01-11 10:40:52', 1077, '操作员8', 4, 89, 4, 67, 1, '操作完成，有轻微警告', 3, 73, 477.95, '[\"密封圈\", \"润滑油\"]', 93.7747, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (6, 2, '2026-01-09 21:40:52', 1064, '操作员1', 2, 72, 4, 56, 1, '操作顺利完成', 3, 41, 262.69, '[\"滤芯\"]', 77.0014, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (7, 3, '2026-01-11 10:40:52', 1009, '操作员25', 4, 97, 5, 27, 1, '操作顺利完成', 4, 45, 426.93, '[\"密封圈\", \"润滑油\"]', 86.9112, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (8, 3, '2026-01-09 18:40:52', 1089, '操作员4', 2, 89, 1, 144, 1, '操作顺利完成', 3, 32, 876.11, '[\"滤芯\"]', 78.8615, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (9, 3, '2026-01-11 20:40:52', 1053, '操作员14', 3, 95, 3, 79, 2, '操作完成，有轻微警告', 2, 46, 559.44, '[\"密封圈\", \"润滑油\"]', 93.7944, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (10, 4, '2026-01-09 14:40:52', 1088, '操作员29', 2, 92, 3, 131, 2, '操作正常，无异常', 3, 31, 392.05, '[\"滤芯\"]', 76.7990, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (11, 4, '2026-01-10 09:40:52', 1066, '操作员19', 2, 89, 5, 137, 1, '操作顺利完成', 1, 47, 220.70, '[\"密封圈\", \"润滑油\"]', 84.8874, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (12, 4, '2026-01-11 13:40:52', 1002, '操作员18', 4, 94, 2, 63, 1, '操作顺利完成', 1, 56, 468.85, '[\"密封圈\", \"润滑油\"]', 75.9293, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (13, 5, '2026-01-09 11:40:52', 1010, '操作员27', 2, 75, 2, 72, 1, '操作完成，有轻微警告', 4, 66, 496.37, '[\"滤芯\"]', 82.9462, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (14, 5, '2026-01-11 09:40:52', 1083, '操作员16', 2, 89, 1, 94, 1, '操作正常，无异常', 1, 40, 611.77, '[\"滤芯\"]', 75.4894, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (15, 5, '2026-01-09 13:40:52', 1062, '操作员18', 2, 95, 5, 97, 1, '操作顺利完成', 4, 41, 429.91, '[\"滤芯\"]', 91.4497, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (16, 6, '2026-01-11 22:40:52', 1010, '操作员12', 3, 91, 5, 28, 1, '操作顺利完成', 1, 42, 664.59, '[\"密封圈\", \"润滑油\"]', 92.1339, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (17, 6, '2026-01-11 21:40:52', 1009, '操作员8', 2, 78, 2, 39, 1, '操作正常，无异常', 3, 70, 849.12, '[\"滤芯\"]', 76.4332, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (18, 6, '2026-01-11 20:40:52', 1094, '操作员15', 3, 84, 4, 123, 1, '操作正常，无异常', 1, 58, 936.90, '[\"滤芯\"]', 84.9318, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (19, 7, '2026-01-11 14:40:52', 1035, '操作员9', 3, 74, 3, 46, 1, '操作顺利完成', 1, 49, 628.10, '[\"密封圈\", \"润滑油\"]', 76.6446, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (20, 7, '2026-01-09 19:40:52', 1094, '操作员14', 3, 87, 5, 71, 1, '操作正常，无异常', 4, 23, 945.78, '[\"滤芯\"]', 81.2339, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (21, 7, '2026-01-10 10:40:52', 1099, '操作员10', 3, 71, 3, 54, 1, '操作顺利完成', 1, 69, 601.61, '[\"密封圈\", \"润滑油\"]', 83.0136, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (22, 8, '2026-01-11 18:40:52', 1050, '操作员6', 3, 96, 5, 149, 1, '操作正常，无异常', 4, 59, 559.56, '[\"滤芯\"]', 90.1626, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (23, 8, '2026-01-10 23:40:52', 1062, '操作员1', 2, 95, 4, 74, 1, '操作正常，无异常', 2, 56, 545.30, '[\"滤芯\"]', 77.1274, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (24, 8, '2026-01-11 15:40:52', 1081, '操作员20', 4, 95, 1, 84, 1, '操作顺利完成', 4, 63, 721.70, '[\"密封圈\", \"润滑油\"]', 81.7009, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (25, 9, '2026-01-10 13:40:52', 1019, '操作员13', 3, 87, 1, 46, 1, '操作顺利完成', 2, 20, 251.17, '[\"滤芯\"]', 94.4606, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (26, 9, '2026-01-09 07:40:52', 1027, '操作员18', 2, 87, 4, 42, 1, '操作顺利完成', 4, 34, 906.43, '[\"滤芯\"]', 87.7835, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (27, 9, '2026-01-11 10:40:52', 1052, '操作员30', 3, 70, 5, 106, 1, '操作顺利完成', 1, 70, 903.13, '[\"密封圈\", \"润滑油\"]', 85.7961, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (28, 10, '2026-01-11 00:40:52', 1036, '操作员22', 3, 86, 1, 119, 1, '操作正常，无异常', 2, 60, 949.31, '[\"滤芯\"]', 81.6755, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (29, 10, '2026-01-09 07:40:52', 1042, '操作员10', 3, 97, 3, 90, 1, '操作正常，无异常', 4, 35, 418.84, '[\"滤芯\"]', 75.0285, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (30, 10, '2026-01-10 08:40:52', 1009, '操作员22', 3, 90, 2, 64, 1, '操作正常，无异常', 3, 74, 268.62, '[\"滤芯\"]', 75.1092, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (31, 11, '2026-01-11 01:40:52', 1066, '操作员8', 2, 96, 3, 83, 1, '操作正常，无异常', 1, 71, 371.48, '[\"滤芯\"]', 88.8041, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (32, 11, '2026-01-11 11:40:52', 1098, '操作员9', 3, 70, 2, 68, 2, '操作完成，有轻微警告', 1, 42, 263.99, '[\"滤芯\"]', 93.4118, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (33, 11, '2026-01-09 17:40:52', 1034, '操作员12', 4, 72, 5, 86, 1, '操作顺利完成', 3, 38, 411.29, '[\"滤芯\"]', 75.4229, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (34, 12, '2026-01-11 23:40:52', 1028, '操作员9', 3, 72, 4, 28, 1, '操作正常，无异常', 1, 22, 206.32, '[\"密封圈\", \"润滑油\"]', 81.5782, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (35, 12, '2026-01-11 12:40:52', 1100, '操作员13', 2, 84, 5, 39, 2, '操作顺利完成', 2, 71, 898.87, '[\"密封圈\", \"润滑油\"]', 79.3003, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (36, 12, '2026-01-11 08:40:52', 1100, '操作员10', 3, 91, 1, 146, 1, '操作正常，无异常', 1, 65, 813.56, '[\"滤芯\"]', 80.6998, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (37, 13, '2026-01-10 12:40:52', 1015, '操作员6', 3, 87, 4, 87, 1, '操作顺利完成', 4, 69, 411.18, '[\"密封圈\", \"润滑油\"]', 80.0656, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (38, 13, '2026-01-10 17:40:52', 1087, '操作员1', 3, 80, 2, 81, 1, '操作正常，无异常', 3, 17, 334.53, '[\"密封圈\", \"润滑油\"]', 77.7109, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (39, 13, '2026-01-11 20:40:52', 1083, '操作员29', 2, 88, 1, 145, 1, '操作完成，有轻微警告', 1, 49, 823.07, '[\"滤芯\"]', 83.9989, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (40, 14, '2026-01-10 10:40:52', 1037, '操作员6', 4, 98, 5, 34, 1, '操作正常，无异常', 2, 45, 537.01, '[\"密封圈\", \"润滑油\"]', 89.0959, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (41, 14, '2026-01-10 05:40:52', 1078, '操作员2', 4, 87, 1, 88, 1, '操作顺利完成', 1, 16, 911.65, '[\"滤芯\"]', 79.3363, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (42, 14, '2026-01-11 16:40:52', 1071, '操作员7', 4, 95, 3, 74, 1, '操作正常，无异常', 4, 36, 282.67, '[\"滤芯\"]', 94.1220, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (43, 15, '2026-01-11 08:40:52', 1092, '操作员27', 3, 85, 4, 149, 2, '操作顺利完成', 2, 52, 280.75, '[\"密封圈\", \"润滑油\"]', 90.3140, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (44, 15, '2026-01-10 02:40:52', 1024, '操作员9', 3, 79, 4, 99, 2, '操作顺利完成', 4, 20, 856.39, '[\"密封圈\", \"润滑油\"]', 88.7131, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (45, 15, '2026-01-10 02:40:52', 1040, '操作员2', 2, 72, 2, 84, 1, '操作顺利完成', 1, 57, 458.99, '[\"密封圈\", \"润滑油\"]', 85.7577, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (46, 16, '2026-01-11 02:40:52', 1098, '操作员30', 4, 94, 1, 94, 1, '操作顺利完成', 4, 74, 769.32, '[\"密封圈\", \"润滑油\"]', 89.2229, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (47, 16, '2026-01-11 17:40:52', 1100, '操作员19', 2, 99, 3, 64, 1, '操作顺利完成', 3, 44, 377.76, '[\"密封圈\", \"润滑油\"]', 86.0964, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (48, 16, '2026-01-10 09:40:52', 1019, '操作员9', 4, 94, 2, 122, 1, '操作正常，无异常', 1, 43, 829.33, '[\"密封圈\", \"润滑油\"]', 79.4947, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (49, 17, '2026-01-11 11:40:52', 1024, '操作员18', 2, 83, 3, 58, 1, '操作正常，无异常', 3, 51, 502.14, '[\"滤芯\"]', 80.4921, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (50, 17, '2026-01-09 14:40:52', 1071, '操作员3', 2, 73, 4, 78, 2, '操作正常，无异常', 4, 43, 576.04, '[\"密封圈\", \"润滑油\"]', 78.7561, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (51, 17, '2026-01-11 00:40:52', 1015, '操作员22', 2, 94, 3, 115, 1, '操作正常，无异常', 3, 39, 216.44, '[\"密封圈\", \"润滑油\"]', 81.0431, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (52, 18, '2026-01-10 08:40:52', 1011, '操作员26', 4, 71, 3, 56, 2, '操作顺利完成', 3, 52, 652.33, '[\"密封圈\", \"润滑油\"]', 77.2834, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (53, 18, '2026-01-11 19:40:52', 1035, '操作员16', 3, 94, 4, 118, 2, '操作顺利完成', 3, 59, 949.28, '[\"滤芯\"]', 85.5349, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (54, 18, '2026-01-10 07:40:52', 1020, '操作员8', 4, 89, 2, 63, 1, '操作正常，无异常', 2, 33, 295.62, '[\"密封圈\", \"润滑油\"]', 77.0060, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (55, 19, '2026-01-09 13:40:52', 1088, '操作员27', 4, 99, 5, 48, 1, '操作正常，无异常', 4, 72, 285.15, '[\"密封圈\", \"润滑油\"]', 93.2611, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (56, 19, '2026-01-10 20:40:52', 1008, '操作员6', 4, 75, 4, 117, 1, '操作顺利完成', 3, 70, 874.76, '[\"滤芯\"]', 89.0037, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (57, 19, '2026-01-09 21:40:52', 1008, '操作员8', 4, 71, 3, 33, 2, '操作正常，无异常', 2, 60, 978.50, '[\"密封圈\", \"润滑油\"]', 76.0142, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (58, 20, '2026-01-11 10:40:52', 1062, '操作员14', 3, 88, 5, 124, 1, '操作正常，无异常', 1, 74, 917.96, '[\"密封圈\", \"润滑油\"]', 94.0939, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (59, 20, '2026-01-11 20:40:52', 1076, '操作员18', 4, 89, 1, 145, 1, '操作顺利完成', 2, 67, 231.69, '[\"密封圈\", \"润滑油\"]', 90.1225, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (60, 20, '2026-01-12 00:40:52', 1089, '操作员12', 2, 75, 1, 29, 2, '操作正常，无异常', 1, 68, 485.88, '[\"滤芯\"]', 83.6313, 4, '2026-01-12 00:40:52');

-- ----------------------------
-- Table structure for eq_prediction
-- ----------------------------
DROP TABLE IF EXISTS `eq_prediction`;
CREATE TABLE `eq_prediction`  (
  `prediction_id` bigint NOT NULL AUTO_INCREMENT COMMENT '预测ID',
  `device_id` bigint NOT NULL COMMENT '设备ID',
  `prediction_time` datetime NOT NULL COMMENT '预测时间',
  `predicted_status` tinyint NULL DEFAULT NULL COMMENT '预测状态 1-正常 2-警告 3-错误 4-离线',
  `prediction_confidence` decimal(5, 4) NULL DEFAULT NULL COMMENT '预测置信度',
  `risk_level` tinyint NULL DEFAULT NULL COMMENT '风险等级 1-低 2-中 3-高',
  `expected_failure_time` datetime NULL DEFAULT NULL COMMENT '预计故障时间',
  `recommended_action` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '建议措施',
  `preventive_cost` decimal(10, 2) NULL DEFAULT NULL COMMENT '预防成本',
  `action_taken` tinyint NULL DEFAULT 1 COMMENT '采取行动 1-待处理 2-已处理 3-忽略',
  `action_taken_date` datetime NULL DEFAULT NULL COMMENT '行动时间',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`prediction_id`) USING BTREE,
  INDEX `idx_device_time`(`device_id` ASC, `prediction_time` ASC) USING BTREE,
  INDEX `idx_predicted_status`(`predicted_status` ASC) USING BTREE,
  INDEX `idx_risk_level`(`risk_level` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '预测结果表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eq_prediction
-- ----------------------------
INSERT INTO `eq_prediction` VALUES (1, 1, '2023-12-01 10:00:00', 2, 0.8567, 2, '2024-02-15 10:00:00', '建议在下次计划停机时检查轴承', 1500.00, 1, NULL, NULL, '', '2025-12-18 13:53:20', '', '2025-12-18 13:53:20');
INSERT INTO `eq_prediction` VALUES (2, 2, '2023-12-01 10:00:00', 1, 0.9234, 1, NULL, '设备状态良好，继续监控', 0.00, 1, NULL, NULL, '', '2025-12-18 13:53:20', '', '2025-12-18 13:53:20');

-- ----------------------------
-- Table structure for eq_sensor
-- ----------------------------
DROP TABLE IF EXISTS `eq_sensor`;
CREATE TABLE `eq_sensor`  (
  `sensor_id` bigint NOT NULL AUTO_INCREMENT COMMENT '传感器ID',
  `device_id` bigint NOT NULL COMMENT '设备ID',
  `sensor_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '传感器类型',
  `sensor_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '传感器名称',
  `location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '安装位置',
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '单位',
  `calibration_date` datetime NULL DEFAULT NULL COMMENT '校准日期',
  `next_calibration_date` datetime NULL DEFAULT NULL COMMENT '下次校准日期',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态 1-启用 2-停用 3-校准中',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`sensor_id`) USING BTREE,
  INDEX `idx_device_sensor`(`device_id` ASC, `sensor_type` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 114 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '传感器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eq_sensor
-- ----------------------------
INSERT INTO `eq_sensor` VALUES (1, 1, '温度传感器', '温度传感器-DEV-001', '主厂房A区1层', '℃', '2025-12-13 00:01:12', '2026-12-13 00:01:12', 1, NULL, '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (2, 2, '温度传感器', '温度传感器-DEV-002', '主厂房A区2层', '℃', '2025-12-13 00:01:12', '2026-12-13 00:01:12', 1, NULL, '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (3, 3, '温度传感器', '温度传感器-DEV-003', '配电室A区', '℃', '2025-12-13 00:01:12', '2026-12-13 00:01:12', 1, NULL, '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (4, 4, '温度传感器', '温度传感器-DEV-004', '配电室B区', '℃', '2025-12-13 00:01:12', '2026-12-13 00:01:12', 1, NULL, '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (5, 5, '温度传感器', '温度传感器-DEV-005', '开关站1号位', '℃', '2025-12-13 00:01:12', '2026-12-13 00:01:12', 1, NULL, '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (6, 6, '温度传感器', '温度传感器-DEV-006', '开关站2号位', '℃', '2025-12-13 00:01:12', '2026-12-13 00:01:12', 1, NULL, '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (7, 7, '温度传感器', '温度传感器-DEV-007', '发电机房A区', '℃', '2025-12-13 00:01:12', '2026-12-13 00:01:12', 1, NULL, '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (8, 8, '温度传感器', '温度传感器-DEV-008', '发电机房B区', '℃', '2025-12-13 00:01:12', '2026-12-13 00:01:12', 1, NULL, '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (9, 9, '温度传感器', '温度传感器-DEV-009', '无功补偿室1号', '℃', '2025-12-13 00:01:12', '2026-12-13 00:01:12', 1, NULL, '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (10, 10, '温度传感器', '温度传感器-DEV-010', '无功补偿室2号', '℃', '2025-12-13 00:01:12', '2026-12-13 00:01:12', 1, NULL, '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (11, 11, '温度传感器', '温度传感器-DEV-011', '计量室1号位', '℃', '2025-12-13 00:01:12', '2026-12-13 00:01:12', 1, NULL, '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (12, 12, '温度传感器', '温度传感器-DEV-012', '计量室2号位', '℃', '2025-12-13 00:01:12', '2026-12-13 00:01:12', 1, NULL, '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (13, 13, '温度传感器', '温度传感器-DEV-013', '室外A区1号杆', '℃', '2025-12-13 00:01:12', '2026-12-13 00:01:12', 1, NULL, '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (14, 14, '温度传感器', '温度传感器-DEV-014', '室外B区1号杆', '℃', '2025-12-13 00:01:12', '2026-12-13 00:01:12', 1, NULL, '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (15, 15, '温度传感器', '温度传感器-DEV-015', '开关场A区', '℃', '2025-12-13 00:01:12', '2026-12-13 00:01:12', 1, NULL, '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (16, 16, '温度传感器', '温度传感器-DEV-016', '开关场B区', '℃', '2025-12-13 00:01:12', '2026-12-13 00:01:12', 1, NULL, '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (17, 17, '温度传感器', '温度传感器-DEV-017', '监控室A区', '℃', '2025-12-13 00:01:12', '2026-12-13 00:01:12', 1, NULL, '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (18, 18, '温度传感器', '温度传感器-DEV-018', '监控室B区', '℃', '2025-12-13 00:01:12', '2026-12-13 00:01:12', 1, NULL, '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (19, 19, '温度传感器', '温度传感器-DEV-019', '直流室A区', '℃', '2025-12-13 00:01:12', '2026-12-13 00:01:12', 1, NULL, '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (20, 20, '温度传感器', '温度传感器-DEV-020', '直流室B区', '℃', '2025-12-13 00:01:12', '2026-12-13 00:01:12', 1, NULL, '', '2026-01-12 00:01:12', '', '2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (32, 1, '湿度传感器', '湿度传感器-DEV-001', '主厂房A区1层', '%', '2025-11-28 00:01:13', '2026-11-28 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (33, 2, '湿度传感器', '湿度传感器-DEV-002', '主厂房A区2层', '%', '2025-11-28 00:01:13', '2026-11-28 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (34, 3, '湿度传感器', '湿度传感器-DEV-003', '配电室A区', '%', '2025-11-28 00:01:13', '2026-11-28 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (35, 4, '湿度传感器', '湿度传感器-DEV-004', '配电室B区', '%', '2025-11-28 00:01:13', '2026-11-28 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (36, 5, '湿度传感器', '湿度传感器-DEV-005', '开关站1号位', '%', '2025-11-28 00:01:13', '2026-11-28 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (37, 6, '湿度传感器', '湿度传感器-DEV-006', '开关站2号位', '%', '2025-11-28 00:01:13', '2026-11-28 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (38, 7, '湿度传感器', '湿度传感器-DEV-007', '发电机房A区', '%', '2025-11-28 00:01:13', '2026-11-28 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (39, 8, '湿度传感器', '湿度传感器-DEV-008', '发电机房B区', '%', '2025-11-28 00:01:13', '2026-11-28 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (40, 9, '湿度传感器', '湿度传感器-DEV-009', '无功补偿室1号', '%', '2025-11-28 00:01:13', '2026-11-28 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (41, 10, '湿度传感器', '湿度传感器-DEV-010', '无功补偿室2号', '%', '2025-11-28 00:01:13', '2026-11-28 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (42, 11, '湿度传感器', '湿度传感器-DEV-011', '计量室1号位', '%', '2025-11-28 00:01:13', '2026-11-28 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (43, 12, '湿度传感器', '湿度传感器-DEV-012', '计量室2号位', '%', '2025-11-28 00:01:13', '2026-11-28 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (44, 13, '湿度传感器', '湿度传感器-DEV-013', '室外A区1号杆', '%', '2025-11-28 00:01:13', '2026-11-28 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (45, 14, '湿度传感器', '湿度传感器-DEV-014', '室外B区1号杆', '%', '2025-11-28 00:01:13', '2026-11-28 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (46, 15, '湿度传感器', '湿度传感器-DEV-015', '开关场A区', '%', '2025-11-28 00:01:13', '2026-11-28 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (47, 16, '湿度传感器', '湿度传感器-DEV-016', '开关场B区', '%', '2025-11-28 00:01:13', '2026-11-28 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (48, 17, '湿度传感器', '湿度传感器-DEV-017', '监控室A区', '%', '2025-11-28 00:01:13', '2026-11-28 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (49, 18, '湿度传感器', '湿度传感器-DEV-018', '监控室B区', '%', '2025-11-28 00:01:13', '2026-11-28 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (50, 19, '湿度传感器', '湿度传感器-DEV-019', '直流室A区', '%', '2025-11-28 00:01:13', '2026-11-28 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (51, 20, '湿度传感器', '湿度传感器-DEV-020', '直流室B区', '%', '2025-11-28 00:01:13', '2026-11-28 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (63, 1, '电流传感器', '电流传感器-DEV-001', '主厂房A区1层', 'A', '2025-11-13 00:01:13', '2026-11-13 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (64, 2, '电流传感器', '电流传感器-DEV-002', '主厂房A区2层', 'A', '2025-11-13 00:01:13', '2026-11-13 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (65, 3, '电流传感器', '电流传感器-DEV-003', '配电室A区', 'A', '2025-11-13 00:01:13', '2026-11-13 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (66, 4, '电流传感器', '电流传感器-DEV-004', '配电室B区', 'A', '2025-11-13 00:01:13', '2026-11-13 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (67, 5, '电流传感器', '电流传感器-DEV-005', '开关站1号位', 'A', '2025-11-13 00:01:13', '2026-11-13 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (68, 6, '电流传感器', '电流传感器-DEV-006', '开关站2号位', 'A', '2025-11-13 00:01:13', '2026-11-13 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (69, 7, '电流传感器', '电流传感器-DEV-007', '发电机房A区', 'A', '2025-11-13 00:01:13', '2026-11-13 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (70, 8, '电流传感器', '电流传感器-DEV-008', '发电机房B区', 'A', '2025-11-13 00:01:13', '2026-11-13 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (71, 9, '电流传感器', '电流传感器-DEV-009', '无功补偿室1号', 'A', '2025-11-13 00:01:13', '2026-11-13 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (72, 10, '电流传感器', '电流传感器-DEV-010', '无功补偿室2号', 'A', '2025-11-13 00:01:13', '2026-11-13 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (73, 11, '电流传感器', '电流传感器-DEV-011', '计量室1号位', 'A', '2025-11-13 00:01:13', '2026-11-13 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (74, 12, '电流传感器', '电流传感器-DEV-012', '计量室2号位', 'A', '2025-11-13 00:01:13', '2026-11-13 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (75, 13, '电流传感器', '电流传感器-DEV-013', '室外A区1号杆', 'A', '2025-11-13 00:01:13', '2026-11-13 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (76, 14, '电流传感器', '电流传感器-DEV-014', '室外B区1号杆', 'A', '2025-11-13 00:01:13', '2026-11-13 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (77, 15, '电流传感器', '电流传感器-DEV-015', '开关场A区', 'A', '2025-11-13 00:01:13', '2026-11-13 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (78, 16, '电流传感器', '电流传感器-DEV-016', '开关场B区', 'A', '2025-11-13 00:01:13', '2026-11-13 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (79, 17, '电流传感器', '电流传感器-DEV-017', '监控室A区', 'A', '2025-11-13 00:01:13', '2026-11-13 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (80, 18, '电流传感器', '电流传感器-DEV-018', '监控室B区', 'A', '2025-11-13 00:01:13', '2026-11-13 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (81, 19, '电流传感器', '电流传感器-DEV-019', '直流室A区', 'A', '2025-11-13 00:01:13', '2026-11-13 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (82, 20, '电流传感器', '电流传感器-DEV-020', '直流室B区', 'A', '2025-11-13 00:01:13', '2026-11-13 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (94, 1, '电压传感器', '电压传感器-DEV-001', '主厂房A区1层', 'kV', '2025-12-23 00:01:13', '2026-12-23 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (95, 2, '电压传感器', '电压传感器-DEV-002', '主厂房A区2层', 'kV', '2025-12-23 00:01:13', '2026-12-23 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (96, 3, '电压传感器', '电压传感器-DEV-003', '配电室A区', 'kV', '2025-12-23 00:01:13', '2026-12-23 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (97, 4, '电压传感器', '电压传感器-DEV-004', '配电室B区', 'kV', '2025-12-23 00:01:13', '2026-12-23 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (98, 5, '电压传感器', '电压传感器-DEV-005', '开关站1号位', 'kV', '2025-12-23 00:01:13', '2026-12-23 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (99, 6, '电压传感器', '电压传感器-DEV-006', '开关站2号位', 'kV', '2025-12-23 00:01:13', '2026-12-23 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (100, 7, '电压传感器', '电压传感器-DEV-007', '发电机房A区', 'kV', '2025-12-23 00:01:13', '2026-12-23 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (101, 8, '电压传感器', '电压传感器-DEV-008', '发电机房B区', 'kV', '2025-12-23 00:01:13', '2026-12-23 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (102, 9, '电压传感器', '电压传感器-DEV-009', '无功补偿室1号', 'kV', '2025-12-23 00:01:13', '2026-12-23 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (103, 10, '电压传感器', '电压传感器-DEV-010', '无功补偿室2号', 'kV', '2025-12-23 00:01:13', '2026-12-23 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (104, 11, '电压传感器', '电压传感器-DEV-011', '计量室1号位', 'kV', '2025-12-23 00:01:13', '2026-12-23 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (105, 12, '电压传感器', '电压传感器-DEV-012', '计量室2号位', 'kV', '2025-12-23 00:01:13', '2026-12-23 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (106, 13, '电压传感器', '电压传感器-DEV-013', '室外A区1号杆', 'kV', '2025-12-23 00:01:13', '2026-12-23 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (107, 14, '电压传感器', '电压传感器-DEV-014', '室外B区1号杆', 'kV', '2025-12-23 00:01:13', '2026-12-23 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (108, 15, '电压传感器', '电压传感器-DEV-015', '开关场A区', 'kV', '2025-12-23 00:01:13', '2026-12-23 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (109, 16, '电压传感器', '电压传感器-DEV-016', '开关场B区', 'kV', '2025-12-23 00:01:13', '2026-12-23 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (110, 17, '电压传感器', '电压传感器-DEV-017', '监控室A区', 'kV', '2025-12-23 00:01:13', '2026-12-23 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (111, 18, '电压传感器', '电压传感器-DEV-018', '监控室B区', 'kV', '2025-12-23 00:01:13', '2026-12-23 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (112, 19, '电压传感器', '电压传感器-DEV-019', '直流室A区', 'kV', '2025-12-23 00:01:13', '2026-12-23 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (113, 20, '电压传感器', '电压传感器-DEV-020', '直流室B区', 'kV', '2025-12-23 00:01:13', '2026-12-23 00:01:13', 1, NULL, '', '2026-01-12 00:01:13', '', '2026-01-12 00:01:13');

-- ----------------------------
-- Table structure for eq_technology_data
-- ----------------------------
DROP TABLE IF EXISTS `eq_technology_data`;
CREATE TABLE `eq_technology_data`  (
  `tech_id` bigint NOT NULL AUTO_INCREMENT COMMENT '技术数据ID',
  `device_id` bigint NOT NULL COMMENT '设备ID',
  `timestamp` datetime NOT NULL COMMENT '更新时间',
  `technology_level` tinyint NULL DEFAULT NULL COMMENT '技术水平 1-落后 2-一般 3-先进 4-领先',
  `upgrade_status` tinyint NULL DEFAULT NULL COMMENT '升级状态 1-无需升级 2-计划升级 3-正在升级 4-已完成',
  `standard_compliance` json NULL COMMENT '标准符合情况',
  `certification_status` tinyint NULL DEFAULT NULL COMMENT '认证状态 1-有效 2-过期 3-待审核',
  `software_version` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '软件版本',
  `firmware_version` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '固件版本',
  `system_updates` int NULL DEFAULT NULL COMMENT '系统更新次数',
  `digitalization_level` tinyint NULL DEFAULT NULL COMMENT '数字化水平 1-低 2-中 3-高 4-超高',
  `connectivity_level` tinyint NULL DEFAULT NULL COMMENT '连接性水平 1-无连接 2-基础连接 3-智能连接 4-全连接',
  `technology_maturity` tinyint NULL DEFAULT NULL COMMENT '技术成熟度 1-试验 2-试用 3-推广 4-成熟',
  `obsolescence_risk` tinyint NULL DEFAULT NULL COMMENT '淘汰风险 1-低 2-中 3-高 4-极高',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`tech_id`) USING BTREE,
  INDEX `idx_device_time`(`device_id` ASC, `timestamp` ASC) USING BTREE,
  INDEX `idx_tech_level`(`technology_level` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '技术数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eq_technology_data
-- ----------------------------
INSERT INTO `eq_technology_data` VALUES (1, 1, '2025-10-16 00:40:52', 3, 3, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 3, 'V2.3.8', 'FW2.2.7', 6, 2, 2, 2, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (2, 1, '2025-11-30 00:40:52', 2, 3, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 3, 'V2.9.3', 'FW2.4.8', 14, 4, 2, 4, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (3, 1, '2025-10-21 00:40:52', 4, 1, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 1, 'V1.9.9', 'FW1.2.3', 7, 4, 2, 4, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (4, 2, '2025-10-22 00:40:52', 3, 1, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 2, 'V3.7.16', 'FW2.3.8', 6, 4, 2, 4, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (5, 2, '2025-12-24 00:40:52', 4, 3, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 1, 'V2.4.1', 'FW2.3.1', 24, 3, 2, 3, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (6, 2, '2026-01-11 00:40:52', 2, 2, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 2, 'V2.9.15', 'FW2.0.0', 22, 2, 3, 2, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (7, 3, '2025-12-31 00:40:52', 3, 2, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 1, 'V2.4.16', 'FW2.3.0', 6, 2, 3, 4, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (8, 3, '2025-11-23 00:40:52', 4, 2, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 1, 'V2.4.0', 'FW2.4.9', 10, 3, 2, 4, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (9, 3, '2025-12-19 00:40:52', 2, 3, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 1, 'V3.4.19', 'FW2.2.4', 12, 4, 2, 4, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (10, 4, '2025-11-25 00:40:52', 4, 3, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 2, 'V3.3.15', 'FW2.2.1', 14, 2, 4, 4, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (11, 4, '2025-12-08 00:40:52', 3, 3, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 1, 'V1.8.11', 'FW1.4.7', 6, 2, 2, 3, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (12, 4, '2025-11-23 00:40:52', 3, 2, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 2, 'V3.7.2', 'FW1.0.9', 6, 3, 4, 4, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (13, 5, '2025-11-17 00:40:52', 2, 3, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 1, 'V3.1.3', 'FW1.0.1', 16, 3, 3, 2, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (14, 5, '2025-10-29 00:40:52', 4, 3, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 1, 'V3.7.13', 'FW1.2.7', 9, 4, 4, 2, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (15, 5, '2025-12-17 00:40:52', 4, 1, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 3, 'V2.9.7', 'FW1.2.7', 16, 3, 4, 2, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (16, 6, '2025-10-25 00:40:52', 3, 2, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 3, 'V2.2.3', 'FW1.0.4', 21, 4, 2, 2, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (17, 6, '2025-12-21 00:40:52', 3, 2, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 2, 'V3.4.10', 'FW1.1.4', 11, 2, 4, 4, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (18, 6, '2025-10-19 00:40:52', 2, 2, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 1, 'V1.9.4', 'FW1.1.0', 14, 2, 4, 2, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (19, 7, '2026-01-12 00:40:52', 4, 2, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 3, 'V2.0.5', 'FW1.0.9', 13, 3, 3, 4, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (20, 7, '2025-12-27 00:40:52', 4, 1, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 1, 'V2.4.17', 'FW1.3.9', 24, 4, 3, 3, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (21, 7, '2025-11-25 00:40:52', 4, 3, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 1, 'V2.8.10', 'FW1.4.5', 9, 3, 2, 3, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (22, 8, '2025-11-17 00:40:52', 4, 1, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 3, 'V3.1.5', 'FW1.1.6', 6, 3, 3, 2, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (23, 8, '2025-12-27 00:40:52', 4, 3, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 2, 'V2.6.15', 'FW1.3.4', 6, 2, 4, 3, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (24, 8, '2025-10-25 00:40:52', 4, 2, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 1, 'V3.1.6', 'FW1.0.8', 20, 3, 4, 4, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (25, 9, '2025-11-16 00:40:52', 3, 2, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 1, 'V3.1.7', 'FW1.2.4', 21, 4, 3, 2, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (26, 9, '2025-11-03 00:40:52', 3, 2, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 3, 'V3.3.4', 'FW1.2.1', 8, 2, 3, 3, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (27, 9, '2025-12-30 00:40:52', 2, 1, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 3, 'V3.3.8', 'FW1.3.7', 23, 2, 2, 4, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (28, 10, '2025-11-26 00:40:52', 3, 1, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 1, 'V1.7.15', 'FW1.0.9', 15, 4, 2, 2, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (29, 10, '2025-10-24 00:40:52', 3, 1, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 1, 'V1.0.4', 'FW2.0.3', 21, 4, 2, 3, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (30, 10, '2025-10-20 00:40:52', 3, 2, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 3, 'V1.8.3', 'FW1.3.2', 17, 3, 3, 2, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (31, 11, '2025-12-07 00:40:52', 4, 3, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 2, 'V3.1.8', 'FW2.2.1', 6, 4, 3, 4, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (32, 11, '2025-10-22 00:40:52', 3, 2, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 3, 'V1.6.12', 'FW2.3.1', 16, 2, 4, 4, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (33, 11, '2025-12-19 00:40:52', 4, 1, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 2, 'V2.0.2', 'FW1.4.3', 5, 4, 4, 3, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (34, 12, '2025-11-28 00:40:52', 2, 3, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 2, 'V1.6.17', 'FW1.2.1', 9, 4, 3, 4, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (35, 12, '2025-10-31 00:40:52', 3, 3, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 2, 'V1.0.1', 'FW1.1.9', 6, 3, 4, 2, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (36, 12, '2025-12-22 00:40:52', 2, 1, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 3, 'V2.9.18', 'FW2.2.8', 17, 4, 4, 4, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (37, 13, '2025-11-23 00:40:52', 2, 2, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 2, 'V1.1.17', 'FW1.2.7', 6, 2, 2, 4, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (38, 13, '2025-12-31 00:40:52', 4, 2, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 2, 'V3.0.4', 'FW2.0.1', 23, 2, 4, 2, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (39, 13, '2025-10-28 00:40:52', 3, 1, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 3, 'V1.9.6', 'FW2.0.1', 8, 3, 3, 2, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (40, 14, '2026-01-10 00:40:52', 3, 3, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 2, 'V3.0.3', 'FW2.4.0', 19, 3, 3, 2, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (41, 14, '2025-12-27 00:40:52', 2, 1, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 3, 'V2.0.2', 'FW1.4.8', 15, 2, 4, 3, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (42, 14, '2025-11-06 00:40:52', 2, 1, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 3, 'V1.0.12', 'FW1.2.9', 11, 4, 3, 2, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (43, 15, '2025-11-30 00:40:52', 2, 3, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 1, 'V1.6.7', 'FW2.4.4', 10, 2, 3, 3, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (44, 15, '2025-12-23 00:40:52', 3, 1, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 3, 'V2.1.13', 'FW2.4.9', 13, 2, 2, 3, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (45, 15, '2026-01-08 00:40:52', 4, 3, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 1, 'V2.7.10', 'FW1.1.7', 23, 3, 3, 3, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (46, 16, '2025-12-23 00:40:52', 3, 1, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 2, 'V1.1.15', 'FW2.1.1', 20, 3, 3, 3, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (47, 16, '2025-12-29 00:40:52', 3, 2, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 1, 'V1.6.0', 'FW1.1.0', 15, 3, 2, 4, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (48, 16, '2025-12-28 00:40:52', 2, 3, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 2, 'V2.2.7', 'FW2.1.1', 20, 3, 3, 2, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (49, 17, '2025-11-12 00:40:52', 4, 2, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 1, 'V1.2.10', 'FW2.1.8', 15, 2, 3, 3, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (50, 17, '2025-12-23 00:40:52', 3, 1, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 1, 'V1.6.19', 'FW2.3.9', 14, 3, 3, 3, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (51, 17, '2025-10-15 00:40:52', 2, 2, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 2, 'V2.8.18', 'FW1.4.9', 12, 4, 4, 4, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (52, 18, '2025-12-22 00:40:52', 4, 1, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 2, 'V3.8.4', 'FW2.1.9', 22, 3, 2, 2, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (53, 18, '2025-12-19 00:40:52', 2, 1, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 3, 'V1.4.3', 'FW2.1.6', 18, 2, 3, 2, 1, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (54, 18, '2025-11-18 00:40:52', 3, 1, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 3, 'V3.0.5', 'FW1.3.6', 20, 4, 2, 2, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (55, 19, '2026-01-03 00:40:52', 4, 2, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 3, 'V1.3.12', 'FW1.0.8', 22, 4, 2, 4, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (56, 19, '2025-11-30 00:40:52', 4, 3, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 3, 'V2.6.19', 'FW2.4.4', 20, 3, 2, 3, 4, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (57, 19, '2025-10-18 00:40:52', 2, 3, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 1, 'V1.3.12', 'FW1.3.2', 10, 3, 2, 3, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (58, 20, '2025-11-26 00:40:52', 3, 1, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 2, 'V3.6.9', 'FW1.0.3', 13, 2, 4, 3, 2, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (59, 20, '2025-10-21 00:40:52', 3, 2, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 1, 'V2.5.8', 'FW1.1.8', 15, 4, 3, 4, 3, '2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (60, 20, '2025-12-11 00:40:52', 4, 1, '{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}', 2, 'V1.3.18', 'FW2.1.4', 12, 3, 4, 4, 2, '2026-01-12 00:40:52');

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (1, 'sys_config', '参数配置表', NULL, NULL, 'SysConfig', 'crud', 'element-plus', 'com.ruoyi.system', 'system', 'config', '参数配置', 'ruoyi', '0', '/', '{}', 'admin', '2025-10-31 15:55:05', '', '2025-10-31 16:44:40', NULL);
INSERT INTO `gen_table` VALUES (2, 'sys_dept', '部门表', NULL, NULL, 'SysDept', 'crud', '', 'com.ruoyi.system', 'system', 'dept', '部门', 'ruoyi', '0', '/', NULL, 'admin', '2025-10-31 16:51:53', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (3, 'sys_dict_data', '字典数据表', NULL, NULL, 'SysDictData', 'crud', '', 'com.ruoyi.system', 'system', 'data', '字典数据', 'ruoyi', '0', '/', NULL, 'admin', '2025-10-31 16:51:53', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (4, 'sys_dict_type', '字典类型表', NULL, NULL, 'SysDictType', 'crud', '', 'com.ruoyi.system', 'system', 'type', '字典类型', 'ruoyi', '0', '/', NULL, 'admin', '2025-10-31 16:51:53', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (5, 'sys_job', '定时任务调度表', NULL, NULL, 'SysJob', 'crud', '', 'com.ruoyi.system', 'system', 'job', '定时任务调度', 'ruoyi', '0', '/', NULL, 'admin', '2025-10-31 16:51:53', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (6, 'sys_job_log', '定时任务调度日志表', NULL, NULL, 'SysJobLog', 'crud', '', 'com.ruoyi.system', 'system', 'log', '定时任务调度日志', 'ruoyi', '0', '/', NULL, 'admin', '2025-10-31 16:51:53', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (7, 'sys_logininfor', '系统访问记录', NULL, NULL, 'SysLogininfor', 'crud', '', 'com.ruoyi.system', 'system', 'logininfor', '系统访问记录', 'ruoyi', '0', '/', NULL, 'admin', '2025-10-31 16:51:53', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (8, 'sys_menu', '菜单权限表', NULL, NULL, 'SysMenu', 'crud', '', 'com.ruoyi.system', 'system', 'menu', '菜单权限', 'ruoyi', '0', '/', NULL, 'admin', '2025-10-31 16:51:53', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (9, 'sys_notice', '通知公告表', NULL, NULL, 'SysNotice', 'crud', '', 'com.ruoyi.system', 'system', 'notice', '通知公告', 'ruoyi', '0', '/', NULL, 'admin', '2025-10-31 16:51:53', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (10, 'sys_oper_log', '操作日志记录', NULL, NULL, 'SysOperLog', 'crud', '', 'com.ruoyi.system', 'system', 'log', '操作日志记录', 'ruoyi', '0', '/', NULL, 'admin', '2025-10-31 16:51:53', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (11, 'sys_post', '岗位信息表', NULL, NULL, 'SysPost', 'crud', '', 'com.ruoyi.system', 'system', 'post', '岗位信息', 'ruoyi', '0', '/', NULL, 'admin', '2025-10-31 16:51:53', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (12, 't_user', '用户表', NULL, NULL, 'TUser', 'crud', 'element-plus', 'com.ruoyi.system', 'jingyes', 'user', '用户', 'ruoyi', '0', '/', '{\"parentMenuId\":1}', 'admin', '2025-10-31 17:15:49', '', '2025-10-31 17:17:20', NULL);
INSERT INTO `gen_table` VALUES (13, 'qcl_user', '用户表', NULL, NULL, 'QclUser', 'crud', 'element-plus', 'com.ruoyi.qcluser', 'qcluser', 'qcluser', '用户', 'ruoyi', '0', '/', '{}', 'admin', '2025-11-03 08:57:15', '', '2025-11-03 08:59:53', NULL);
INSERT INTO `gen_table` VALUES (14, 'good_type', '商品分类表', 'good', 'type_id', 'GoodType', 'sub', 'element-plus', 'com.qcl.good', 'good', 'type', '分类管理', '风格', '0', '/', '{\"parentMenuId\":2012}', 'admin', '2025-11-03 09:16:23', '', '2025-11-03 15:55:02', NULL);
INSERT INTO `gen_table` VALUES (15, 'good', '商品信息', NULL, NULL, 'Good', 'crud', 'element-plus', 'com.qcl.good', 'good', 'good', '管理商品', '风格', '0', '/', '{\"parentMenuId\":2012}', 'admin', '2025-11-03 09:20:57', '', '2025-11-03 09:22:59', NULL);
INSERT INTO `gen_table` VALUES (16, 'department', '部门信息表', '', '', 'Department', 'tree', 'element-plus', 'com.ruoyi.deparment', 'deparment', 'department', '部门信息', 'ruoyi', '0', '/', '{\"treeCode\":\"department_id\",\"treeName\":\"department_name\",\"treeParentCode\":\"parent_id\",\"parentMenuId\":3}', 'admin', '2025-11-03 16:01:44', '', '2025-11-03 16:21:01', NULL);

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 154 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (1, 1, 'config_id', '参数主键', 'int', 'Long', 'configId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-10-31 15:55:05', '', '2025-10-31 16:44:40');
INSERT INTO `gen_table_column` VALUES (2, 1, 'config_name', '参数名称', 'varchar(100)', 'String', 'configName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2025-10-31 15:55:05', '', '2025-10-31 16:44:40');
INSERT INTO `gen_table_column` VALUES (3, 1, 'config_key', '参数键名', 'varchar(100)', 'String', 'configKey', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-10-31 15:55:05', '', '2025-10-31 16:44:40');
INSERT INTO `gen_table_column` VALUES (4, 1, 'config_value', '参数键值', 'varchar(500)', 'String', 'configValue', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 4, 'admin', '2025-10-31 15:55:05', '', '2025-10-31 16:44:40');
INSERT INTO `gen_table_column` VALUES (5, 1, 'config_type', '系统内置（Y是 N否）', 'char(1)', 'String', 'configType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 5, 'admin', '2025-10-31 15:55:05', '', '2025-10-31 16:44:40');
INSERT INTO `gen_table_column` VALUES (6, 1, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 6, 'admin', '2025-10-31 15:55:05', '', '2025-10-31 16:44:40');
INSERT INTO `gen_table_column` VALUES (7, 1, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 7, 'admin', '2025-10-31 15:55:05', '', '2025-10-31 16:44:40');
INSERT INTO `gen_table_column` VALUES (8, 1, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 8, 'admin', '2025-10-31 15:55:05', '', '2025-10-31 16:44:40');
INSERT INTO `gen_table_column` VALUES (9, 1, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 9, 'admin', '2025-10-31 15:55:05', '', '2025-10-31 16:44:40');
INSERT INTO `gen_table_column` VALUES (10, 1, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 10, 'admin', '2025-10-31 15:55:05', '', '2025-10-31 16:44:40');
INSERT INTO `gen_table_column` VALUES (11, 2, 'dept_id', '部门id', 'bigint', 'Long', 'deptId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (12, 2, 'parent_id', '父部门id', 'bigint', 'Long', 'parentId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (13, 2, 'ancestors', '祖级列表', 'varchar(50)', 'String', 'ancestors', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (14, 2, 'dept_name', '部门名称', 'varchar(30)', 'String', 'deptName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (15, 2, 'order_num', '显示顺序', 'int', 'Long', 'orderNum', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (16, 2, 'leader', '负责人', 'varchar(20)', 'String', 'leader', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (17, 2, 'phone', '联系电话', 'varchar(11)', 'String', 'phone', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (18, 2, 'email', '邮箱', 'varchar(50)', 'String', 'email', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (19, 2, 'status', '部门状态（0正常 1停用）', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 9, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (20, 2, 'del_flag', '删除标志（0代表存在 2代表删除）', 'char(1)', 'String', 'delFlag', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 10, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (21, 2, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 11, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (22, 2, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 12, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (23, 2, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 13, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (24, 2, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 14, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (25, 3, 'dict_code', '字典编码', 'bigint', 'Long', 'dictCode', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (26, 3, 'dict_sort', '字典排序', 'int', 'Long', 'dictSort', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (27, 3, 'dict_label', '字典标签', 'varchar(100)', 'String', 'dictLabel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (28, 3, 'dict_value', '字典键值', 'varchar(100)', 'String', 'dictValue', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (29, 3, 'dict_type', '字典类型', 'varchar(100)', 'String', 'dictType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 5, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (30, 3, 'css_class', '样式属性（其他样式扩展）', 'varchar(100)', 'String', 'cssClass', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (31, 3, 'list_class', '表格回显样式', 'varchar(100)', 'String', 'listClass', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (32, 3, 'is_default', '是否默认（Y是 N否）', 'char(1)', 'String', 'isDefault', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (33, 3, 'status', '状态（0正常 1停用）', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 9, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (34, 3, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 10, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (35, 3, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 11, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (36, 3, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 12, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (37, 3, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (38, 3, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 14, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (39, 4, 'dict_id', '字典主键', 'bigint', 'Long', 'dictId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (40, 4, 'dict_name', '字典名称', 'varchar(100)', 'String', 'dictName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (41, 4, 'dict_type', '字典类型', 'varchar(100)', 'String', 'dictType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 3, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (42, 4, 'status', '状态（0正常 1停用）', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 4, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (43, 4, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 5, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (44, 4, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 6, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (45, 4, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 7, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (46, 4, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 8, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (47, 4, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 9, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (48, 5, 'job_id', '任务ID', 'bigint', 'Long', 'jobId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (49, 5, 'job_name', '任务名称', 'varchar(64)', 'String', 'jobName', '1', '0', '0', '1', NULL, NULL, NULL, 'LIKE', 'input', '', 2, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (50, 5, 'job_group', '任务组名', 'varchar(64)', 'String', 'jobGroup', '1', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 3, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (51, 5, 'invoke_target', '调用目标字符串', 'varchar(500)', 'String', 'invokeTarget', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'textarea', '', 4, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (52, 5, 'cron_expression', 'cron执行表达式', 'varchar(255)', 'String', 'cronExpression', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (53, 5, 'misfire_policy', '计划执行错误策略（1立即执行 2执行一次 3放弃执行）', 'varchar(20)', 'String', 'misfirePolicy', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (54, 5, 'concurrent', '是否并发执行（0允许 1禁止）', 'char(1)', 'String', 'concurrent', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (55, 5, 'status', '状态（0正常 1暂停）', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 8, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (56, 5, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 9, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (57, 5, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 10, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (58, 5, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 11, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (59, 5, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 12, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (60, 5, 'remark', '备注信息', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 13, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (61, 6, 'job_log_id', '任务日志ID', 'bigint', 'Long', 'jobLogId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (62, 6, 'job_name', '任务名称', 'varchar(64)', 'String', 'jobName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (63, 6, 'job_group', '任务组名', 'varchar(64)', 'String', 'jobGroup', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (64, 6, 'invoke_target', '调用目标字符串', 'varchar(500)', 'String', 'invokeTarget', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'textarea', '', 4, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (65, 6, 'job_message', '日志信息', 'varchar(500)', 'String', 'jobMessage', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 5, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (66, 6, 'status', '执行状态（0正常 1失败）', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 6, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (67, 6, 'exception_info', '异常信息', 'varchar(2000)', 'String', 'exceptionInfo', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 7, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (68, 6, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 8, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (69, 7, 'info_id', '访问ID', 'bigint', 'Long', 'infoId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (70, 7, 'user_name', '用户账号', 'varchar(50)', 'String', 'userName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (71, 7, 'ipaddr', '登录IP地址', 'varchar(128)', 'String', 'ipaddr', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (72, 7, 'login_location', '登录地点', 'varchar(255)', 'String', 'loginLocation', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (73, 7, 'browser', '浏览器类型', 'varchar(50)', 'String', 'browser', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (74, 7, 'os', '操作系统', 'varchar(50)', 'String', 'os', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (75, 7, 'status', '登录状态（0成功 1失败）', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 7, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (76, 7, 'msg', '提示消息', 'varchar(255)', 'String', 'msg', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (77, 7, 'login_time', '访问时间', 'datetime', 'Date', 'loginTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 9, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (78, 8, 'menu_id', '菜单ID', 'bigint', 'Long', 'menuId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (79, 8, 'menu_name', '菜单名称', 'varchar(50)', 'String', 'menuName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (80, 8, 'parent_id', '父菜单ID', 'bigint', 'Long', 'parentId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (81, 8, 'order_num', '显示顺序', 'int', 'Long', 'orderNum', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (82, 8, 'path', '路由地址', 'varchar(200)', 'String', 'path', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (83, 8, 'component', '组件路径', 'varchar(255)', 'String', 'component', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (84, 8, 'query', '路由参数', 'varchar(255)', 'String', 'query', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (85, 8, 'route_name', '路由名称', 'varchar(50)', 'String', 'routeName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (86, 8, 'is_frame', '是否为外链（0是 1否）', 'int', 'Long', 'isFrame', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (87, 8, 'is_cache', '是否缓存（0缓存 1不缓存）', 'int', 'Long', 'isCache', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (88, 8, 'menu_type', '菜单类型（M目录 C菜单 F按钮）', 'char(1)', 'String', 'menuType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 11, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (89, 8, 'visible', '菜单状态（0显示 1隐藏）', 'char(1)', 'String', 'visible', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (90, 8, 'status', '菜单状态（0正常 1停用）', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 13, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (91, 8, 'perms', '权限标识', 'varchar(100)', 'String', 'perms', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (92, 8, 'icon', '菜单图标', 'varchar(100)', 'String', 'icon', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (93, 8, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 16, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (94, 8, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 17, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (95, 8, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 18, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (96, 8, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 19, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (97, 8, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 20, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (98, 9, 'notice_id', '公告ID', 'int', 'Long', 'noticeId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (99, 9, 'notice_title', '公告标题', 'varchar(50)', 'String', 'noticeTitle', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (100, 9, 'notice_type', '公告类型（1通知 2公告）', 'char(1)', 'String', 'noticeType', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', '', 3, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (101, 9, 'notice_content', '公告内容', 'longblob', 'String', 'noticeContent', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'editor', '', 4, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (102, 9, 'status', '公告状态（0正常 1关闭）', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 5, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (103, 9, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 6, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (104, 9, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 7, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (105, 9, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 8, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (106, 9, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 9, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (107, 9, 'remark', '备注', 'varchar(255)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'input', '', 10, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (108, 10, 'oper_id', '日志主键', 'bigint', 'Long', 'operId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (109, 10, 'title', '模块标题', 'varchar(50)', 'String', 'title', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (110, 10, 'business_type', '业务类型（0其它 1新增 2修改 3删除）', 'int', 'Long', 'businessType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 3, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (111, 10, 'method', '方法名称', 'varchar(200)', 'String', 'method', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (112, 10, 'request_method', '请求方式', 'varchar(10)', 'String', 'requestMethod', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (113, 10, 'operator_type', '操作类别（0其它 1后台用户 2手机端用户）', 'int', 'Long', 'operatorType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 6, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (114, 10, 'oper_name', '操作人员', 'varchar(50)', 'String', 'operName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (115, 10, 'dept_name', '部门名称', 'varchar(50)', 'String', 'deptName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (116, 10, 'oper_url', '请求URL', 'varchar(255)', 'String', 'operUrl', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (117, 10, 'oper_ip', '主机地址', 'varchar(128)', 'String', 'operIp', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (118, 10, 'oper_location', '操作地点', 'varchar(255)', 'String', 'operLocation', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (119, 10, 'oper_param', '请求参数', 'varchar(2000)', 'String', 'operParam', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 12, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (120, 10, 'json_result', '返回参数', 'varchar(2000)', 'String', 'jsonResult', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 13, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (121, 10, 'status', '操作状态（0正常 1异常）', 'int', 'Long', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 14, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (122, 10, 'error_msg', '错误消息', 'varchar(2000)', 'String', 'errorMsg', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 15, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (123, 10, 'oper_time', '操作时间', 'datetime', 'Date', 'operTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 16, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (124, 10, 'cost_time', '消耗时间', 'bigint', 'Long', 'costTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 17, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (125, 11, 'post_id', '岗位ID', 'bigint', 'Long', 'postId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (126, 11, 'post_code', '岗位编码', 'varchar(64)', 'String', 'postCode', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (127, 11, 'post_name', '岗位名称', 'varchar(50)', 'String', 'postName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (128, 11, 'post_sort', '显示顺序', 'int', 'Long', 'postSort', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (129, 11, 'status', '状态（0正常 1停用）', 'char(1)', 'String', 'status', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'radio', '', 5, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (130, 11, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 6, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (131, 11, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 7, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (132, 11, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 8, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (133, 11, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 9, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (134, 11, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 10, 'admin', '2025-10-31 16:51:53', '', NULL);
INSERT INTO `gen_table_column` VALUES (135, 12, 'id', '主键ID', 'bigint unsigned', 'String', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', NULL, '', 1, 'admin', '2025-10-31 17:15:49', '', '2025-10-31 17:17:20');
INSERT INTO `gen_table_column` VALUES (136, 12, 'name', '姓名', 'varchar(30)', 'String', 'name', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2025-10-31 17:15:49', '', '2025-10-31 17:17:20');
INSERT INTO `gen_table_column` VALUES (137, 12, 'age', '年龄', 'int', 'Long', 'age', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-10-31 17:15:49', '', '2025-10-31 17:17:20');
INSERT INTO `gen_table_column` VALUES (138, 12, 'gender', '性别，0：女 1：男', 'tinyint', 'Long', 'gender', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-10-31 17:15:49', '', '2025-10-31 17:17:20');
INSERT INTO `gen_table_column` VALUES (139, 13, 'id', '编号', 'int', 'Long', 'id', '1', '1', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 1, 'admin', '2025-11-03 08:57:15', '', '2025-11-03 08:59:53');
INSERT INTO `gen_table_column` VALUES (140, 13, 'name', '姓名', 'varchar(20)', 'String', 'name', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-11-03 08:57:15', '', '2025-11-03 08:59:53');
INSERT INTO `gen_table_column` VALUES (141, 13, 'education', '学历', 'varchar(20)', 'String', 'education', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-11-03 08:57:15', '', '2025-11-03 08:59:53');
INSERT INTO `gen_table_column` VALUES (142, 13, 'age', '年龄', 'int', 'Long', 'age', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-11-03 08:57:15', '', '2025-11-03 08:59:53');
INSERT INTO `gen_table_column` VALUES (143, 14, 'type_id', '自增ID', 'int', 'Long', 'typeId', '1', '1', '0', '1', '1', '1', '1', 'EQ', 'input', '', 1, 'admin', '2025-11-03 09:16:23', '', '2025-11-03 15:55:02');
INSERT INTO `gen_table_column` VALUES (144, 14, 'type_name', '类型名称', 'varchar(255)', 'String', 'typeName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2025-11-03 09:16:23', '', '2025-11-03 15:55:02');
INSERT INTO `gen_table_column` VALUES (145, 15, 'good_id', '自增ID', 'int', 'Long', 'goodId', '1', '1', '0', '1', '1', '1', '1', 'EQ', 'input', '', 1, 'admin', '2025-11-03 09:20:57', '', '2025-11-03 09:22:59');
INSERT INTO `gen_table_column` VALUES (146, 15, 'good_name', '商品名称', 'varchar(255)', 'String', 'goodName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2025-11-03 09:20:57', '', '2025-11-03 09:22:59');
INSERT INTO `gen_table_column` VALUES (147, 15, 'price', '价格', 'decimal(10,2)', 'BigDecimal', 'price', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-11-03 09:20:57', '', '2025-11-03 09:22:59');
INSERT INTO `gen_table_column` VALUES (148, 15, 'image_url', '图片链接', 'varchar(255)', 'String', 'imageUrl', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'imageUpload', '', 4, 'admin', '2025-11-03 09:20:57', '', '2025-11-03 09:22:59');
INSERT INTO `gen_table_column` VALUES (149, 15, 'type_id', '类型ID', 'int', 'Long', 'typeId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-11-03 09:20:57', '', '2025-11-03 09:22:59');
INSERT INTO `gen_table_column` VALUES (150, 16, 'department_id', '部门ID', 'int', 'Long', 'departmentId', '1', '1', '0', '1', '1', '1', '1', 'EQ', 'input', '', 1, 'admin', '2025-11-03 16:01:44', '', '2025-11-03 16:21:01');
INSERT INTO `gen_table_column` VALUES (151, 16, 'department_name', '部门名称', 'varchar(100)', 'String', 'departmentName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2025-11-03 16:01:44', '', '2025-11-03 16:21:01');
INSERT INTO `gen_table_column` VALUES (152, 16, 'parent_id', '上级部门ID，用于表示部门层级关系', 'int', 'Long', 'parentId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-11-03 16:01:44', '', '2025-11-03 16:21:01');
INSERT INTO `gen_table_column` VALUES (153, 16, 'chairman', '部门负责人', 'varchar(100)', 'String', 'chairman', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-11-03 16:01:44', '', '2025-11-03 16:21:01');

-- ----------------------------
-- Table structure for qcl_user
-- ----------------------------
DROP TABLE IF EXISTS `qcl_user`;
CREATE TABLE `qcl_user`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '姓名',
  `education` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学历',
  `age` int NULL DEFAULT NULL COMMENT '年龄',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qcl_user
-- ----------------------------
INSERT INTO `qcl_user` VALUES (1, '王对', '本科', 22);

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '日历信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '已触发的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '任务详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '暂停的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '调度器状态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name` ASC, `job_name` ASC, `job_group` ASC) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '触发器详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2025-10-31 15:23:03', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2025-10-31 15:23:03', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2025-10-31 15:23:03', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2025-10-31 15:23:03', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2025-10-31 15:23:03', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2025-10-31 15:23:03', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` VALUES (7, '用户管理-初始密码修改策略', 'sys.account.initPasswordModify', '1', 'Y', 'admin', '2025-10-31 15:23:03', '', NULL, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (8, '用户管理-账号密码更新周期', 'sys.account.passwordValidateDays', '0', 'Y', 'admin', '2025-10-31 15:23:03', '', NULL, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (9, '前端统一轮询间隔（秒）', 'client.poll.interval.seconds', '180', 'N', 'admin', '2025-10-31 15:23:03', '', NULL, '发电预测页自动刷新、消息中心未读轮询等；30～3600；发电预测页可写本机 localStorage 覆盖');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '大风车科技', 0, '若依', '15888888888', '3047969285@qq.com', '0', '0', 'admin', '2025-10-31 15:23:03', 'admin', '2026-03-13 22:55:34');
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '烟台总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-10-31 15:23:03', 'admin', '2026-03-13 22:56:17');
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '济南分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-10-31 15:23:03', 'admin', '2026-03-13 22:56:25');
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-10-31 15:23:03', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-10-31 15:23:03', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-10-31 15:23:03', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-10-31 15:23:03', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-10-31 15:23:03', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-10-31 15:23:03', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-10-31 15:23:03', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (100, 10, '1', '1', 'course_subject', '1', 'default', 'N', '0', 'admin', '2025-10-31 16:48:07', 'admin', '2025-10-31 17:13:28', '你好\n');
INSERT INTO `sys_dict_data` VALUES (101, 10, '2', '2', 'course_subject', '2', 'default', 'N', '0', 'admin', '2025-10-31 16:50:32', 'admin', '2025-10-31 17:13:33', '我好');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '登录状态列表');
INSERT INTO `sys_dict_type` VALUES (100, '课程学科', 'course_subject', '0', 'admin', '2025-10-31 16:37:20', 'admin', '2025-11-03 08:30:14', '课程学科');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '定时任务调度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_job` VALUES (100, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '0 0/1 * * * ?', '1', '1', '0', 'admin', '2026-03-13 21:17:37', '', '2026-03-13 21:17:46', '聚合需维护设备状态；并调用 maintenanceFormNotifyTask 扫描 draft/pending 表单推送站内消息（需 Redis）。可与「运维表单待处理消息推送」二选一或并存（并存时扫描更频，Redis 去重防重复通知）');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 227 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------
INSERT INTO `sys_job_log` VALUES (1, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：8毫秒', '0', '', '2026-03-13 21:18:00');
INSERT INTO `sys_job_log` VALUES (2, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-13 21:19:00');
INSERT INTO `sys_job_log` VALUES (3, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-13 21:20:00');
INSERT INTO `sys_job_log` VALUES (4, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：8毫秒', '0', '', '2026-03-13 21:21:00');
INSERT INTO `sys_job_log` VALUES (5, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：11毫秒', '0', '', '2026-03-13 21:22:00');
INSERT INTO `sys_job_log` VALUES (6, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：8毫秒', '0', '', '2026-03-13 21:24:00');
INSERT INTO `sys_job_log` VALUES (7, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-13 21:25:00');
INSERT INTO `sys_job_log` VALUES (8, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-13 21:26:00');
INSERT INTO `sys_job_log` VALUES (9, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-13 21:27:00');
INSERT INTO `sys_job_log` VALUES (10, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-13 21:28:00');
INSERT INTO `sys_job_log` VALUES (11, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-13 21:29:00');
INSERT INTO `sys_job_log` VALUES (12, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-13 21:30:00');
INSERT INTO `sys_job_log` VALUES (13, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-13 21:31:00');
INSERT INTO `sys_job_log` VALUES (14, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-13 21:32:00');
INSERT INTO `sys_job_log` VALUES (15, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-13 21:33:00');
INSERT INTO `sys_job_log` VALUES (16, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-13 21:34:00');
INSERT INTO `sys_job_log` VALUES (17, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-13 21:35:00');
INSERT INTO `sys_job_log` VALUES (18, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-13 21:36:00');
INSERT INTO `sys_job_log` VALUES (19, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-13 21:37:00');
INSERT INTO `sys_job_log` VALUES (20, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：11毫秒', '0', '', '2026-03-13 21:38:00');
INSERT INTO `sys_job_log` VALUES (21, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-13 21:39:00');
INSERT INTO `sys_job_log` VALUES (22, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：48毫秒', '0', '', '2026-03-13 22:49:00');
INSERT INTO `sys_job_log` VALUES (23, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：13毫秒', '0', '', '2026-03-13 22:50:00');
INSERT INTO `sys_job_log` VALUES (24, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-13 22:51:00');
INSERT INTO `sys_job_log` VALUES (25, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-13 22:52:00');
INSERT INTO `sys_job_log` VALUES (26, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-13 22:53:00');
INSERT INTO `sys_job_log` VALUES (27, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-13 22:54:00');
INSERT INTO `sys_job_log` VALUES (28, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：9毫秒', '0', '', '2026-03-13 22:55:00');
INSERT INTO `sys_job_log` VALUES (29, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-13 22:56:00');
INSERT INTO `sys_job_log` VALUES (30, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-13 22:57:00');
INSERT INTO `sys_job_log` VALUES (31, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-13 22:58:00');
INSERT INTO `sys_job_log` VALUES (32, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-13 22:59:00');
INSERT INTO `sys_job_log` VALUES (33, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-13 23:00:00');
INSERT INTO `sys_job_log` VALUES (34, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-13 23:01:00');
INSERT INTO `sys_job_log` VALUES (35, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-13 23:02:00');
INSERT INTO `sys_job_log` VALUES (36, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-13 23:03:00');
INSERT INTO `sys_job_log` VALUES (37, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-13 23:04:00');
INSERT INTO `sys_job_log` VALUES (38, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：12毫秒', '0', '', '2026-03-13 23:05:00');
INSERT INTO `sys_job_log` VALUES (39, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：12毫秒', '0', '', '2026-03-13 23:06:00');
INSERT INTO `sys_job_log` VALUES (40, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-13 23:07:00');
INSERT INTO `sys_job_log` VALUES (41, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：10毫秒', '0', '', '2026-03-13 23:08:00');
INSERT INTO `sys_job_log` VALUES (42, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：21毫秒', '0', '', '2026-03-13 23:09:00');
INSERT INTO `sys_job_log` VALUES (43, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：19毫秒', '0', '', '2026-03-13 23:10:00');
INSERT INTO `sys_job_log` VALUES (44, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-13 23:11:00');
INSERT INTO `sys_job_log` VALUES (45, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：8毫秒', '0', '', '2026-03-13 23:13:00');
INSERT INTO `sys_job_log` VALUES (46, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-13 23:14:00');
INSERT INTO `sys_job_log` VALUES (47, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-13 23:15:00');
INSERT INTO `sys_job_log` VALUES (48, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-13 23:16:00');
INSERT INTO `sys_job_log` VALUES (49, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：10毫秒', '0', '', '2026-03-13 23:17:00');
INSERT INTO `sys_job_log` VALUES (50, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-13 23:18:00');
INSERT INTO `sys_job_log` VALUES (51, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-13 23:19:00');
INSERT INTO `sys_job_log` VALUES (52, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-13 23:20:00');
INSERT INTO `sys_job_log` VALUES (53, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-13 23:21:00');
INSERT INTO `sys_job_log` VALUES (54, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-13 23:22:00');
INSERT INTO `sys_job_log` VALUES (55, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-13 23:23:00');
INSERT INTO `sys_job_log` VALUES (56, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-13 23:24:00');
INSERT INTO `sys_job_log` VALUES (57, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-13 23:25:00');
INSERT INTO `sys_job_log` VALUES (58, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-13 23:26:00');
INSERT INTO `sys_job_log` VALUES (59, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-13 23:27:00');
INSERT INTO `sys_job_log` VALUES (60, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-13 23:28:00');
INSERT INTO `sys_job_log` VALUES (61, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-13 23:29:00');
INSERT INTO `sys_job_log` VALUES (62, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：10毫秒', '0', '', '2026-03-13 23:30:00');
INSERT INTO `sys_job_log` VALUES (63, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-13 23:31:00');
INSERT INTO `sys_job_log` VALUES (64, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-13 23:32:00');
INSERT INTO `sys_job_log` VALUES (65, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-13 23:33:00');
INSERT INTO `sys_job_log` VALUES (66, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-13 23:34:00');
INSERT INTO `sys_job_log` VALUES (67, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-13 23:35:00');
INSERT INTO `sys_job_log` VALUES (68, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-13 23:36:00');
INSERT INTO `sys_job_log` VALUES (69, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-13 23:37:00');
INSERT INTO `sys_job_log` VALUES (70, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-13 23:38:00');
INSERT INTO `sys_job_log` VALUES (71, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-13 23:39:00');
INSERT INTO `sys_job_log` VALUES (72, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：47毫秒', '0', '', '2026-03-16 20:20:00');
INSERT INTO `sys_job_log` VALUES (73, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：15毫秒', '0', '', '2026-03-16 20:21:00');
INSERT INTO `sys_job_log` VALUES (74, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-16 20:22:00');
INSERT INTO `sys_job_log` VALUES (75, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：59毫秒', '0', '', '2026-03-16 20:32:00');
INSERT INTO `sys_job_log` VALUES (76, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：11毫秒', '0', '', '2026-03-16 20:33:00');
INSERT INTO `sys_job_log` VALUES (77, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：13毫秒', '0', '', '2026-03-16 20:34:00');
INSERT INTO `sys_job_log` VALUES (78, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：16毫秒', '0', '', '2026-03-16 20:35:00');
INSERT INTO `sys_job_log` VALUES (79, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：11毫秒', '0', '', '2026-03-16 20:36:00');
INSERT INTO `sys_job_log` VALUES (80, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-16 20:37:00');
INSERT INTO `sys_job_log` VALUES (81, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-16 20:38:00');
INSERT INTO `sys_job_log` VALUES (82, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：9毫秒', '0', '', '2026-03-16 20:39:00');
INSERT INTO `sys_job_log` VALUES (83, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：10毫秒', '0', '', '2026-03-16 20:40:00');
INSERT INTO `sys_job_log` VALUES (84, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：8毫秒', '0', '', '2026-03-16 20:41:00');
INSERT INTO `sys_job_log` VALUES (85, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-16 20:42:00');
INSERT INTO `sys_job_log` VALUES (86, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：9毫秒', '0', '', '2026-03-16 20:43:00');
INSERT INTO `sys_job_log` VALUES (87, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-16 20:44:00');
INSERT INTO `sys_job_log` VALUES (88, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-16 20:45:00');
INSERT INTO `sys_job_log` VALUES (89, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-16 20:46:00');
INSERT INTO `sys_job_log` VALUES (90, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-16 20:47:00');
INSERT INTO `sys_job_log` VALUES (91, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：9毫秒', '0', '', '2026-03-16 20:48:00');
INSERT INTO `sys_job_log` VALUES (92, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：10毫秒', '0', '', '2026-03-16 20:49:00');
INSERT INTO `sys_job_log` VALUES (93, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：28毫秒', '0', '', '2026-03-16 20:50:00');
INSERT INTO `sys_job_log` VALUES (94, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：13毫秒', '0', '', '2026-03-16 20:51:00');
INSERT INTO `sys_job_log` VALUES (95, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：32毫秒', '0', '', '2026-03-16 20:53:00');
INSERT INTO `sys_job_log` VALUES (96, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：12毫秒', '0', '', '2026-03-16 20:54:00');
INSERT INTO `sys_job_log` VALUES (97, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-16 20:55:00');
INSERT INTO `sys_job_log` VALUES (98, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：461毫秒', '0', '', '2026-03-24 09:13:00');
INSERT INTO `sys_job_log` VALUES (99, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-24 09:14:00');
INSERT INTO `sys_job_log` VALUES (100, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：338毫秒', '0', '', '2026-03-24 09:15:00');
INSERT INTO `sys_job_log` VALUES (101, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：492毫秒', '0', '', '2026-03-24 09:17:00');
INSERT INTO `sys_job_log` VALUES (102, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 09:18:00');
INSERT INTO `sys_job_log` VALUES (103, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-24 09:19:00');
INSERT INTO `sys_job_log` VALUES (104, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 09:20:00');
INSERT INTO `sys_job_log` VALUES (105, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 09:21:00');
INSERT INTO `sys_job_log` VALUES (106, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-24 09:22:00');
INSERT INTO `sys_job_log` VALUES (107, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：420毫秒', '0', '', '2026-03-24 09:24:00');
INSERT INTO `sys_job_log` VALUES (108, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：344毫秒', '0', '', '2026-03-24 09:25:00');
INSERT INTO `sys_job_log` VALUES (109, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：321毫秒', '0', '', '2026-03-24 09:27:00');
INSERT INTO `sys_job_log` VALUES (110, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：331毫秒', '0', '', '2026-03-24 09:28:00');
INSERT INTO `sys_job_log` VALUES (111, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-24 09:29:00');
INSERT INTO `sys_job_log` VALUES (112, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：9毫秒', '0', '', '2026-03-24 09:30:00');
INSERT INTO `sys_job_log` VALUES (113, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：8毫秒', '0', '', '2026-03-24 09:31:00');
INSERT INTO `sys_job_log` VALUES (114, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 09:32:00');
INSERT INTO `sys_job_log` VALUES (115, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-24 09:33:00');
INSERT INTO `sys_job_log` VALUES (116, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 09:34:00');
INSERT INTO `sys_job_log` VALUES (117, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-24 09:35:00');
INSERT INTO `sys_job_log` VALUES (118, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 09:36:00');
INSERT INTO `sys_job_log` VALUES (119, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：8毫秒', '0', '', '2026-03-24 09:37:00');
INSERT INTO `sys_job_log` VALUES (120, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 09:38:00');
INSERT INTO `sys_job_log` VALUES (121, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 09:39:00');
INSERT INTO `sys_job_log` VALUES (122, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 09:40:00');
INSERT INTO `sys_job_log` VALUES (123, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 09:41:00');
INSERT INTO `sys_job_log` VALUES (124, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-24 09:42:00');
INSERT INTO `sys_job_log` VALUES (125, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 09:43:00');
INSERT INTO `sys_job_log` VALUES (126, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 09:44:00');
INSERT INTO `sys_job_log` VALUES (127, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：14毫秒', '0', '', '2026-03-24 09:45:00');
INSERT INTO `sys_job_log` VALUES (128, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：519毫秒', '0', '', '2026-03-24 09:56:00');
INSERT INTO `sys_job_log` VALUES (129, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 09:57:00');
INSERT INTO `sys_job_log` VALUES (130, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 09:58:00');
INSERT INTO `sys_job_log` VALUES (131, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-24 09:59:00');
INSERT INTO `sys_job_log` VALUES (132, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：8毫秒', '0', '', '2026-03-24 10:00:00');
INSERT INTO `sys_job_log` VALUES (133, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 10:01:00');
INSERT INTO `sys_job_log` VALUES (134, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：429毫秒', '0', '', '2026-03-24 10:31:00');
INSERT INTO `sys_job_log` VALUES (135, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-24 10:32:00');
INSERT INTO `sys_job_log` VALUES (136, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：9毫秒', '0', '', '2026-03-24 10:33:00');
INSERT INTO `sys_job_log` VALUES (137, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 10:34:00');
INSERT INTO `sys_job_log` VALUES (138, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：505毫秒', '0', '', '2026-03-24 11:36:00');
INSERT INTO `sys_job_log` VALUES (139, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 11:37:00');
INSERT INTO `sys_job_log` VALUES (140, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：322毫秒', '0', '', '2026-03-24 11:39:00');
INSERT INTO `sys_job_log` VALUES (141, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-24 11:40:00');
INSERT INTO `sys_job_log` VALUES (142, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：346毫秒', '0', '', '2026-03-24 11:41:00');
INSERT INTO `sys_job_log` VALUES (143, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：8毫秒', '0', '', '2026-03-24 11:42:00');
INSERT INTO `sys_job_log` VALUES (144, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：8毫秒', '0', '', '2026-03-24 11:43:00');
INSERT INTO `sys_job_log` VALUES (145, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 11:44:00');
INSERT INTO `sys_job_log` VALUES (146, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：338毫秒', '0', '', '2026-03-24 11:47:00');
INSERT INTO `sys_job_log` VALUES (147, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-24 11:48:00');
INSERT INTO `sys_job_log` VALUES (148, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：8毫秒', '0', '', '2026-03-24 11:49:00');
INSERT INTO `sys_job_log` VALUES (149, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-24 11:50:00');
INSERT INTO `sys_job_log` VALUES (150, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：320毫秒', '0', '', '2026-03-24 11:52:00');
INSERT INTO `sys_job_log` VALUES (151, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 11:53:00');
INSERT INTO `sys_job_log` VALUES (152, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：9毫秒', '0', '', '2026-03-24 11:54:00');
INSERT INTO `sys_job_log` VALUES (153, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 11:55:00');
INSERT INTO `sys_job_log` VALUES (154, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 11:56:00');
INSERT INTO `sys_job_log` VALUES (155, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-24 11:57:00');
INSERT INTO `sys_job_log` VALUES (156, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 11:58:00');
INSERT INTO `sys_job_log` VALUES (157, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-24 11:59:00');
INSERT INTO `sys_job_log` VALUES (158, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-24 12:00:00');
INSERT INTO `sys_job_log` VALUES (159, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-24 12:01:00');
INSERT INTO `sys_job_log` VALUES (160, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 12:02:00');
INSERT INTO `sys_job_log` VALUES (161, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 12:03:00');
INSERT INTO `sys_job_log` VALUES (162, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 12:04:00');
INSERT INTO `sys_job_log` VALUES (163, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：8毫秒', '0', '', '2026-03-24 12:05:00');
INSERT INTO `sys_job_log` VALUES (164, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 12:06:00');
INSERT INTO `sys_job_log` VALUES (165, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 12:07:00');
INSERT INTO `sys_job_log` VALUES (166, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 12:08:00');
INSERT INTO `sys_job_log` VALUES (167, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 12:09:00');
INSERT INTO `sys_job_log` VALUES (168, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 12:10:00');
INSERT INTO `sys_job_log` VALUES (169, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 12:11:00');
INSERT INTO `sys_job_log` VALUES (170, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 12:12:00');
INSERT INTO `sys_job_log` VALUES (171, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 12:13:00');
INSERT INTO `sys_job_log` VALUES (172, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 12:14:00');
INSERT INTO `sys_job_log` VALUES (173, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 12:15:00');
INSERT INTO `sys_job_log` VALUES (174, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 12:16:00');
INSERT INTO `sys_job_log` VALUES (175, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 12:17:00');
INSERT INTO `sys_job_log` VALUES (176, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 12:18:00');
INSERT INTO `sys_job_log` VALUES (177, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 12:19:00');
INSERT INTO `sys_job_log` VALUES (178, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 12:20:00');
INSERT INTO `sys_job_log` VALUES (179, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 12:21:00');
INSERT INTO `sys_job_log` VALUES (180, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 12:22:00');
INSERT INTO `sys_job_log` VALUES (181, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 12:23:00');
INSERT INTO `sys_job_log` VALUES (182, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 12:24:00');
INSERT INTO `sys_job_log` VALUES (183, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 12:25:00');
INSERT INTO `sys_job_log` VALUES (184, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 12:26:00');
INSERT INTO `sys_job_log` VALUES (185, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 12:27:00');
INSERT INTO `sys_job_log` VALUES (186, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 12:28:00');
INSERT INTO `sys_job_log` VALUES (187, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 12:29:00');
INSERT INTO `sys_job_log` VALUES (188, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 12:30:00');
INSERT INTO `sys_job_log` VALUES (189, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 12:31:00');
INSERT INTO `sys_job_log` VALUES (190, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 12:32:00');
INSERT INTO `sys_job_log` VALUES (191, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 12:33:00');
INSERT INTO `sys_job_log` VALUES (192, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 12:34:00');
INSERT INTO `sys_job_log` VALUES (193, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 12:35:00');
INSERT INTO `sys_job_log` VALUES (194, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 12:36:00');
INSERT INTO `sys_job_log` VALUES (195, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 12:37:00');
INSERT INTO `sys_job_log` VALUES (196, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 12:38:00');
INSERT INTO `sys_job_log` VALUES (197, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 12:39:00');
INSERT INTO `sys_job_log` VALUES (198, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 12:40:00');
INSERT INTO `sys_job_log` VALUES (199, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 12:41:00');
INSERT INTO `sys_job_log` VALUES (200, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 12:42:00');
INSERT INTO `sys_job_log` VALUES (201, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 12:43:00');
INSERT INTO `sys_job_log` VALUES (202, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-24 12:44:00');
INSERT INTO `sys_job_log` VALUES (203, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-24 12:45:00');
INSERT INTO `sys_job_log` VALUES (204, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 12:46:00');
INSERT INTO `sys_job_log` VALUES (205, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 12:47:00');
INSERT INTO `sys_job_log` VALUES (206, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 12:48:00');
INSERT INTO `sys_job_log` VALUES (207, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 12:49:00');
INSERT INTO `sys_job_log` VALUES (208, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 12:50:00');
INSERT INTO `sys_job_log` VALUES (209, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 12:51:00');
INSERT INTO `sys_job_log` VALUES (210, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 12:52:00');
INSERT INTO `sys_job_log` VALUES (211, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 12:53:00');
INSERT INTO `sys_job_log` VALUES (212, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 12:54:00');
INSERT INTO `sys_job_log` VALUES (213, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-24 12:55:00');
INSERT INTO `sys_job_log` VALUES (214, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-24 12:56:00');
INSERT INTO `sys_job_log` VALUES (215, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 12:57:00');
INSERT INTO `sys_job_log` VALUES (216, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 12:58:00');
INSERT INTO `sys_job_log` VALUES (217, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 12:59:00');
INSERT INTO `sys_job_log` VALUES (218, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 13:00:00');
INSERT INTO `sys_job_log` VALUES (219, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 13:01:00');
INSERT INTO `sys_job_log` VALUES (220, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-24 13:02:00');
INSERT INTO `sys_job_log` VALUES (221, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 13:03:00');
INSERT INTO `sys_job_log` VALUES (222, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-24 13:04:00');
INSERT INTO `sys_job_log` VALUES (223, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-24 13:05:00');
INSERT INTO `sys_job_log` VALUES (224, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-24 13:06:00');
INSERT INTO `sys_job_log` VALUES (225, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 13:07:00');
INSERT INTO `sys_job_log` VALUES (226, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-24 13:08:00');

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 249 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-31 15:49:40');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2025-10-31 16:30:07');
INSERT INTO `sys_logininfor` VALUES (102, 'xb', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-31 16:30:14');
INSERT INTO `sys_logininfor` VALUES (103, 'xb', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2025-10-31 16:30:23');
INSERT INTO `sys_logininfor` VALUES (104, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-31 16:30:27');
INSERT INTO `sys_logininfor` VALUES (105, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2025-10-31 16:31:09');
INSERT INTO `sys_logininfor` VALUES (106, 'xb', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-31 16:31:14');
INSERT INTO `sys_logininfor` VALUES (107, 'xb', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2025-10-31 16:34:28');
INSERT INTO `sys_logininfor` VALUES (108, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2025-10-31 16:34:34');
INSERT INTO `sys_logininfor` VALUES (109, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-31 16:34:38');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-03 08:28:51');
INSERT INTO `sys_logininfor` VALUES (111, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-03 08:53:25');
INSERT INTO `sys_logininfor` VALUES (112, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-03 10:29:53');
INSERT INTO `sys_logininfor` VALUES (113, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-03 10:30:47');
INSERT INTO `sys_logininfor` VALUES (114, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2025-11-03 10:31:57');
INSERT INTO `sys_logininfor` VALUES (115, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2025-11-03 10:31:58');
INSERT INTO `sys_logininfor` VALUES (116, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-03 10:32:01');
INSERT INTO `sys_logininfor` VALUES (117, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-03 10:33:21');
INSERT INTO `sys_logininfor` VALUES (118, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-03 10:54:19');
INSERT INTO `sys_logininfor` VALUES (119, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-03 13:08:55');
INSERT INTO `sys_logininfor` VALUES (120, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-03 15:19:18');
INSERT INTO `sys_logininfor` VALUES (121, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-03 15:32:22');
INSERT INTO `sys_logininfor` VALUES (122, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-03 15:43:16');
INSERT INTO `sys_logininfor` VALUES (123, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-03 15:48:50');
INSERT INTO `sys_logininfor` VALUES (124, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-03 15:52:39');
INSERT INTO `sys_logininfor` VALUES (125, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-03 16:19:05');
INSERT INTO `sys_logininfor` VALUES (126, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2025-11-05 08:52:02');
INSERT INTO `sys_logininfor` VALUES (127, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-05 08:52:05');
INSERT INTO `sys_logininfor` VALUES (128, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-05 08:57:42');
INSERT INTO `sys_logininfor` VALUES (129, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-05 09:02:05');
INSERT INTO `sys_logininfor` VALUES (130, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-05 10:28:42');
INSERT INTO `sys_logininfor` VALUES (131, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-05 13:34:40');
INSERT INTO `sys_logininfor` VALUES (132, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-05 14:17:10');
INSERT INTO `sys_logininfor` VALUES (133, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-05 14:50:19');
INSERT INTO `sys_logininfor` VALUES (134, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-06 20:47:44');
INSERT INTO `sys_logininfor` VALUES (135, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-07 17:12:56');
INSERT INTO `sys_logininfor` VALUES (136, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-07 18:30:45');
INSERT INTO `sys_logininfor` VALUES (137, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-07 19:34:22');
INSERT INTO `sys_logininfor` VALUES (138, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-18 17:35:37');
INSERT INTO `sys_logininfor` VALUES (139, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2025-12-18 17:54:13');
INSERT INTO `sys_logininfor` VALUES (140, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-18 17:54:18');
INSERT INTO `sys_logininfor` VALUES (141, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-03 21:32:49');
INSERT INTO `sys_logininfor` VALUES (142, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-03 22:26:02');
INSERT INTO `sys_logininfor` VALUES (143, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-03 22:27:33');
INSERT INTO `sys_logininfor` VALUES (144, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-03 23:14:57');
INSERT INTO `sys_logininfor` VALUES (145, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-05 18:55:32');
INSERT INTO `sys_logininfor` VALUES (146, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-05 19:06:28');
INSERT INTO `sys_logininfor` VALUES (147, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-05 19:06:40');
INSERT INTO `sys_logininfor` VALUES (148, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-05 19:19:41');
INSERT INTO `sys_logininfor` VALUES (149, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-06 15:17:55');
INSERT INTO `sys_logininfor` VALUES (150, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-06 19:02:52');
INSERT INTO `sys_logininfor` VALUES (151, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2026-01-06 19:06:01');
INSERT INTO `sys_logininfor` VALUES (152, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-06 19:06:05');
INSERT INTO `sys_logininfor` VALUES (153, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-06 19:09:27');
INSERT INTO `sys_logininfor` VALUES (154, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-06 19:15:40');
INSERT INTO `sys_logininfor` VALUES (155, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-06 19:26:18');
INSERT INTO `sys_logininfor` VALUES (156, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-06 19:26:22');
INSERT INTO `sys_logininfor` VALUES (157, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-06 19:29:20');
INSERT INTO `sys_logininfor` VALUES (158, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-06 19:29:23');
INSERT INTO `sys_logininfor` VALUES (159, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-06 20:16:55');
INSERT INTO `sys_logininfor` VALUES (160, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-06 20:41:32');
INSERT INTO `sys_logininfor` VALUES (161, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-06 20:41:39');
INSERT INTO `sys_logininfor` VALUES (162, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-06 20:41:43');
INSERT INTO `sys_logininfor` VALUES (163, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-06 20:45:26');
INSERT INTO `sys_logininfor` VALUES (164, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-06 20:49:23');
INSERT INTO `sys_logininfor` VALUES (165, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2026-01-06 20:50:50');
INSERT INTO `sys_logininfor` VALUES (166, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-06 20:59:51');
INSERT INTO `sys_logininfor` VALUES (167, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-06 20:59:52');
INSERT INTO `sys_logininfor` VALUES (168, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-06 20:59:53');
INSERT INTO `sys_logininfor` VALUES (169, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-06 21:01:27');
INSERT INTO `sys_logininfor` VALUES (170, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-06 21:01:28');
INSERT INTO `sys_logininfor` VALUES (171, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-06 21:01:29');
INSERT INTO `sys_logininfor` VALUES (172, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-06 21:01:29');
INSERT INTO `sys_logininfor` VALUES (173, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-06 21:01:30');
INSERT INTO `sys_logininfor` VALUES (174, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-06 21:01:31');
INSERT INTO `sys_logininfor` VALUES (175, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-06 21:01:32');
INSERT INTO `sys_logininfor` VALUES (176, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-06 21:01:32');
INSERT INTO `sys_logininfor` VALUES (177, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-06 21:01:33');
INSERT INTO `sys_logininfor` VALUES (178, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-06 21:01:33');
INSERT INTO `sys_logininfor` VALUES (179, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-06 21:01:34');
INSERT INTO `sys_logininfor` VALUES (180, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2026-01-06 21:04:14');
INSERT INTO `sys_logininfor` VALUES (181, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-06 21:08:26');
INSERT INTO `sys_logininfor` VALUES (182, 'admin', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2026-01-06 21:28:51');
INSERT INTO `sys_logininfor` VALUES (183, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-06 22:29:47');
INSERT INTO `sys_logininfor` VALUES (184, 'admin', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2026-01-07 21:20:49');
INSERT INTO `sys_logininfor` VALUES (185, 'admin', '127.0.0.1', '内网IP', 'Unknown', 'Unknown', '0', '登录成功', '2026-01-07 21:48:40');
INSERT INTO `sys_logininfor` VALUES (186, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-07 22:31:54');
INSERT INTO `sys_logininfor` VALUES (187, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-07 22:47:02');
INSERT INTO `sys_logininfor` VALUES (188, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-08 00:39:07');
INSERT INTO `sys_logininfor` VALUES (189, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-08 08:39:39');
INSERT INTO `sys_logininfor` VALUES (190, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-08 14:02:31');
INSERT INTO `sys_logininfor` VALUES (191, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-08 19:28:12');
INSERT INTO `sys_logininfor` VALUES (192, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-08 22:44:41');
INSERT INTO `sys_logininfor` VALUES (193, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-08 23:46:56');
INSERT INTO `sys_logininfor` VALUES (194, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-09 08:33:36');
INSERT INTO `sys_logininfor` VALUES (195, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-09 09:37:20');
INSERT INTO `sys_logininfor` VALUES (196, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-09 10:34:13');
INSERT INTO `sys_logininfor` VALUES (197, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-09 12:15:08');
INSERT INTO `sys_logininfor` VALUES (198, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-10 18:24:39');
INSERT INTO `sys_logininfor` VALUES (199, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-10 21:07:39');
INSERT INTO `sys_logininfor` VALUES (200, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-10 22:15:05');
INSERT INTO `sys_logininfor` VALUES (201, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-10 23:01:59');
INSERT INTO `sys_logininfor` VALUES (202, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-11 00:17:00');
INSERT INTO `sys_logininfor` VALUES (203, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-11 00:52:27');
INSERT INTO `sys_logininfor` VALUES (204, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-11 16:55:29');
INSERT INTO `sys_logininfor` VALUES (205, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-11 18:45:15');
INSERT INTO `sys_logininfor` VALUES (206, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-11 20:26:37');
INSERT INTO `sys_logininfor` VALUES (207, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-11 22:10:43');
INSERT INTO `sys_logininfor` VALUES (208, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-11 23:24:15');
INSERT INTO `sys_logininfor` VALUES (209, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-12 00:21:46');
INSERT INTO `sys_logininfor` VALUES (210, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-12 18:47:46');
INSERT INTO `sys_logininfor` VALUES (211, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-12 19:06:27');
INSERT INTO `sys_logininfor` VALUES (212, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-12 22:56:42');
INSERT INTO `sys_logininfor` VALUES (213, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-13 12:28:17');
INSERT INTO `sys_logininfor` VALUES (214, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-15 18:54:50');
INSERT INTO `sys_logininfor` VALUES (215, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-15 21:03:52');
INSERT INTO `sys_logininfor` VALUES (216, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-15 21:17:42');
INSERT INTO `sys_logininfor` VALUES (217, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-15 21:33:21');
INSERT INTO `sys_logininfor` VALUES (218, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-15 21:42:54');
INSERT INTO `sys_logininfor` VALUES (219, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-15 22:02:00');
INSERT INTO `sys_logininfor` VALUES (220, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-15 22:14:52');
INSERT INTO `sys_logininfor` VALUES (221, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-15 23:15:28');
INSERT INTO `sys_logininfor` VALUES (222, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-22 15:47:03');
INSERT INTO `sys_logininfor` VALUES (223, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-22 15:47:05');
INSERT INTO `sys_logininfor` VALUES (224, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-22 15:53:01');
INSERT INTO `sys_logininfor` VALUES (225, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-22 15:54:52');
INSERT INTO `sys_logininfor` VALUES (226, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-22 15:55:41');
INSERT INTO `sys_logininfor` VALUES (227, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-22 15:55:42');
INSERT INTO `sys_logininfor` VALUES (228, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-22 15:55:43');
INSERT INTO `sys_logininfor` VALUES (229, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-22 15:55:57');
INSERT INTO `sys_logininfor` VALUES (230, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-22 15:58:19');
INSERT INTO `sys_logininfor` VALUES (231, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-22 18:31:39');
INSERT INTO `sys_logininfor` VALUES (232, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-26 21:54:19');
INSERT INTO `sys_logininfor` VALUES (233, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-02-18 14:19:38');
INSERT INTO `sys_logininfor` VALUES (234, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-02-19 20:16:37');
INSERT INTO `sys_logininfor` VALUES (235, 'xmgl', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '用户不存在/密码错误', '2026-03-13 18:26:19');
INSERT INTO `sys_logininfor` VALUES (236, 'xmgl', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '用户不存在/密码错误', '2026-03-13 18:26:23');
INSERT INTO `sys_logininfor` VALUES (237, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '用户不存在/密码错误', '2026-03-13 18:26:25');
INSERT INTO `sys_logininfor` VALUES (238, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '用户不存在/密码错误', '2026-03-13 18:26:26');
INSERT INTO `sys_logininfor` VALUES (239, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '用户不存在/密码错误', '2026-03-13 18:26:34');
INSERT INTO `sys_logininfor` VALUES (240, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-03-13 18:26:37');
INSERT INTO `sys_logininfor` VALUES (241, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-03-13 19:46:01');
INSERT INTO `sys_logininfor` VALUES (242, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-03-13 22:53:56');
INSERT INTO `sys_logininfor` VALUES (243, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '用户不存在/密码错误', '2026-03-16 20:21:08');
INSERT INTO `sys_logininfor` VALUES (244, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '用户不存在/密码错误', '2026-03-16 20:21:13');
INSERT INTO `sys_logininfor` VALUES (245, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-03-16 20:21:17');
INSERT INTO `sys_logininfor` VALUES (246, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '用户不存在/密码错误', '2026-03-18 16:49:06');
INSERT INTO `sys_logininfor` VALUES (247, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '用户不存在/密码错误', '2026-03-18 16:49:07');
INSERT INTO `sys_logininfor` VALUES (248, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-03-18 16:49:10');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2144 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 10, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2025-10-31 15:23:03', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 11, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2025-10-31 15:23:03', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', '', 1, 0, 'M', '1', '0', '', 'tool', 'admin', '2025-10-31 15:23:03', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, '若依官网', 0, 4, 'http://ruoyi.vip', NULL, '', '', 0, 0, 'M', '1', '0', '', 'guide', 'admin', '2025-10-31 15:23:03', '', NULL, '若依官网地址');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2025-10-31 15:23:03', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2025-10-31 15:23:03', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 0, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'M', '1', '0', 'system:menu:list', 'tree-table', 'admin', '2025-10-31 15:23:03', 'admin', '2025-10-31 16:26:55', '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2025-10-31 15:23:03', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2025-10-31 15:23:03', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2025-10-31 15:23:03', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2025-10-31 15:23:03', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2025-10-31 15:23:03', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2025-10-31 15:23:03', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2025-10-31 15:23:03', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2025-10-31 15:23:03', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '1', '0', 'monitor:druid:list', 'druid', 'admin', '2025-10-31 15:23:03', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2025-10-31 15:23:03', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2025-10-31 15:23:03', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2025-10-31 15:23:03', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '1', '0', 'tool:build:list', 'build', 'admin', '2025-10-31 15:23:03', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '1', '0', 'tool:gen:list', 'code', 'admin', '2025-10-31 15:23:03', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '1', '0', 'tool:swagger:list', 'swagger', 'admin', '2025-10-31 15:23:03', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (200, '发电预测', 0, 3, 'power-forecast', 'powerForecast/index', '', '', 1, 0, 'C', '0', '0', 'power:forecast:list', 'chart', 'admin', '2026-01-06 19:25:04', '', NULL, '发电预测菜单');
INSERT INTO `sys_menu` VALUES (201, '智能运维表单生成', 0, 4, 'maintenance-form', 'ai/maintenance-form/index', '', '', 1, 0, 'C', '0', '0', 'ai:maintenance:form', 'form', 'admin', '2026-01-15 21:48:02', '', NULL, '智能运维表单生成菜单');
INSERT INTO `sys_menu` VALUES (202, '设备管理', 0, 5, 'equipment', 'equipment/manage/index', '', '', 1, 0, 'C', '0', '0', '', 'tool', 'admin', '2026-01-06 19:25:04', '', NULL, '??????');
INSERT INTO `sys_menu` VALUES (205, '智能问答', 0, 6, 'ai-chat', 'ai/chat/index', '', '', 1, 0, 'C', '0', '0', 'ai:chat:list', 'message', 'admin', '2026-01-06 19:25:04', '', NULL, '??????');
INSERT INTO `sys_menu` VALUES (206, '智能运维表单生成', 205, 2, 'maintenance-form', 'ai/maintenance-form/index', '', '', 1, 0, 'C', '0', '0', 'ai:maintenance:form', 'form', 'admin', '2026-01-15 21:32:04', '', NULL, '智能运维表单生成菜单');
INSERT INTO `sys_menu` VALUES (210, '数据获取', 0, 7, 'data-acquisition', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'chart', 'admin', '2026-01-08 22:43:56', '', NULL, '数据获取目录');
INSERT INTO `sys_menu` VALUES (211, '设备状态', 210, 1, 'equipment-status', 'equipment/status/index', NULL, '', 1, 0, 'C', '0', '0', 'equipment:status:list', 'monitor', 'admin', '2026-01-08 22:43:56', '', NULL, '设备状态菜单');
INSERT INTO `sys_menu` VALUES (212, '设备参数', 210, 2, 'device-param', 'equipment/param/index', NULL, '', 1, 0, 'C', '0', '0', 'equipment:deviceParam:list', 'edit', 'admin', '2026-01-08 22:43:56', '', NULL, '设备参数菜单');
INSERT INTO `sys_menu` VALUES (213, '维护记录', 210, 3, 'maintenance-record', 'equipment/maintenance/index', NULL, '', 1, 0, 'C', '0', '0', 'equipment:maintenanceRecord:list', 'form', 'admin', '2026-01-08 22:43:56', '', NULL, '维护记录菜单');
INSERT INTO `sys_menu` VALUES (214, '告警记录', 210, 4, 'alert-record', 'equipment/alert/index', NULL, '', 1, 0, 'C', '0', '0', 'equipment:alertRecord:list', 'message', 'admin', '2026-01-08 22:43:56', '', NULL, '告警记录菜单');
INSERT INTO `sys_menu` VALUES (215, '环境数据', 210, 5, 'environment-data', 'equipment/environment/index', NULL, '', 1, 0, 'C', '0', '0', 'equipment:environmentData:list', 'tree', 'admin', '2026-01-08 22:43:56', '', NULL, '环境数据菜单');
INSERT INTO `sys_menu` VALUES (216, '经济数据', 210, 6, 'economic-data', 'equipment/economic/index', NULL, '', 1, 0, 'C', '0', '0', 'equipment:economicData:list', 'money', 'admin', '2026-01-08 22:43:56', '', NULL, '经济数据菜单');
INSERT INTO `sys_menu` VALUES (217, '电气数据', 210, 7, 'electrical-data', 'equipment/electrical/index', NULL, '', 1, 0, 'C', '0', '0', 'equipment:electricalData:list', 'component', 'admin', '2026-01-08 22:43:57', '', NULL, '电气数据菜单');
INSERT INTO `sys_menu` VALUES (218, '技术数据', 210, 8, 'technology-data', 'equipment/technology/index', NULL, '', 1, 0, 'C', '0', '0', 'equipment:technologyData:list', 'code', 'admin', '2026-01-08 22:43:57', '', NULL, '技术数据菜单');
INSERT INTO `sys_menu` VALUES (219, '传感器', 210, 9, 'sensor', 'equipment/sensor/index', NULL, '', 1, 0, 'C', '0', '0', 'equipment:sensor:list', 'eye', 'admin', '2026-01-08 22:43:57', '', NULL, '传感器菜单');
INSERT INTO `sys_menu` VALUES (220, '设备统计', 210, 10, 'device-stat', 'equipment/stat/index', NULL, '', 1, 0, 'C', '0', '0', 'equipment:deviceStat:list', 'chart', 'admin', '2026-01-08 22:43:57', '', NULL, '设备统计菜单');
INSERT INTO `sys_menu` VALUES (221, '操作数据', 210, 11, 'operational-data', 'equipment/operational/index', NULL, '', 1, 0, 'C', '0', '0', 'equipment:operationalData:list', 'skill', 'admin', '2026-01-08 22:43:57', '', NULL, '操作数据菜单');
INSERT INTO `sys_menu` VALUES (222, '机械数据', 210, 12, 'mechanical-data', 'equipment/mechanical/index', NULL, '', 1, 0, 'C', '0', '0', 'equipment:mechanicalData:list', 'tool', 'admin', '2026-01-08 22:43:57', '', NULL, '机械数据菜单');
INSERT INTO `sys_menu` VALUES (223, '故障记录', 210, 13, 'fault-record', 'equipment/fault/index', NULL, '', 1, 0, 'C', '0', '0', 'equipment:faultRecord:list', 'bug', 'admin', '2026-01-08 22:43:58', '', NULL, '故障记录菜单');
INSERT INTO `sys_menu` VALUES (224, '气候数据', 210, 14, 'climate-data', 'equipment/climate/index', NULL, '', 1, 0, 'C', '0', '0', 'equipment:climateData:list', 'cloudy', 'admin', '2026-01-08 22:43:58', '', NULL, '气候数据菜单');
INSERT INTO `sys_menu` VALUES (225, '设备规则', 210, 15, 'device-rule', 'equipment/rule/index', NULL, '', 1, 0, 'C', '0', '0', 'equipment:deviceRule:list', 'guide', 'admin', '2026-01-08 22:43:58', '', NULL, '设备规则菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2025-10-31 15:23:03', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2025-10-31 15:23:03', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '1', '0', 'system:menu:query', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '1', '0', 'system:menu:add', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '1', '0', 'system:menu:edit', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '1', '0', 'system:menu:remove', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '1', '0', 'tool:gen:query', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '1', '0', 'tool:gen:edit', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '1', '0', 'tool:gen:remove', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '1', '0', 'tool:gen:import', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '1', '0', 'tool:gen:preview', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '1', '0', 'tool:gen:code', '#', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2000, '设备状态查询', 211, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:status:query', '#', 'admin', '2026-01-08 22:43:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2001, '设备状态新增', 211, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:status:add', '#', 'admin', '2026-01-08 22:43:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2002, '设备状态修改', 211, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:status:edit', '#', 'admin', '2026-01-08 22:43:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2003, '设备状态删除', 211, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:status:remove', '#', 'admin', '2026-01-08 22:43:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2010, '设备参数查询', 212, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:deviceParam:query', '#', 'admin', '2026-01-08 22:43:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2011, '查询', 201, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'ai:maintenance:form:query', '#', 'admin', '2026-01-15 21:48:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2012, '生成', 201, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'ai:maintenance:form:generate', '#', 'admin', '2026-01-15 21:48:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2013, '保存', 201, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'ai:maintenance:form:save', '#', 'admin', '2026-01-15 21:48:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2020, '维护记录查询', 213, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:maintenanceRecord:query', '#', 'admin', '2026-01-08 22:43:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2021, '维护记录新增', 213, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:maintenanceRecord:add', '#', 'admin', '2026-01-08 22:43:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2022, '维护记录修改', 213, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:maintenanceRecord:edit', '#', 'admin', '2026-01-08 22:43:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2023, '维护记录删除', 213, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:maintenanceRecord:remove', '#', 'admin', '2026-01-08 22:43:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2030, '告警记录查询', 214, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:alertRecord:query', '#', 'admin', '2026-01-08 22:43:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2031, '告警记录新增', 214, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:alertRecord:add', '#', 'admin', '2026-01-08 22:43:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2032, '告警记录修改', 214, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:alertRecord:edit', '#', 'admin', '2026-01-08 22:43:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2033, '告警记录删除', 214, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:alertRecord:remove', '#', 'admin', '2026-01-08 22:43:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2040, '环境数据查询', 215, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:environmentData:query', '#', 'admin', '2026-01-08 22:43:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2041, '环境数据新增', 215, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:environmentData:add', '#', 'admin', '2026-01-08 22:43:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2042, '环境数据修改', 215, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:environmentData:edit', '#', 'admin', '2026-01-08 22:43:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2043, '环境数据删除', 215, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:environmentData:remove', '#', 'admin', '2026-01-08 22:43:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2050, '经济数据查询', 216, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:economicData:query', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2051, '经济数据新增', 216, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:economicData:add', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2052, '经济数据修改', 216, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:economicData:edit', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2053, '经济数据删除', 216, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:economicData:remove', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2060, '电气数据查询', 217, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:electricalData:query', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2061, '查询', 217, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'ai:maintenance:form:query', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2062, '生成', 217, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'ai:maintenance:form:generate', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2063, '保存', 217, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'ai:maintenance:form:save', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2070, '技术数据查询', 218, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:technologyData:query', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2071, '技术数据新增', 218, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:technologyData:add', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2072, '技术数据修改', 218, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:technologyData:edit', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2073, '技术数据删除', 218, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:technologyData:remove', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2080, '传感器查询', 219, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:sensor:query', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2081, '传感器新增', 219, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:sensor:add', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2082, '传感器修改', 219, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:sensor:edit', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2083, '传感器删除', 219, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:sensor:remove', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2090, '设备统计查询', 220, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:deviceStat:query', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2091, '设备统计新增', 220, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:deviceStat:add', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2092, '设备统计修改', 220, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:deviceStat:edit', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2093, '设备统计删除', 220, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:deviceStat:remove', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2100, '操作数据查询', 221, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:operationalData:query', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2101, '操作数据新增', 221, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:operationalData:add', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2102, '操作数据修改', 221, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:operationalData:edit', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2103, '操作数据删除', 221, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:operationalData:remove', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2110, '机械数据查询', 222, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:mechanicalData:query', '#', 'admin', '2026-01-08 22:43:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2111, '机械数据新增', 222, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:mechanicalData:add', '#', 'admin', '2026-01-08 22:43:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2112, '机械数据修改', 222, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:mechanicalData:edit', '#', 'admin', '2026-01-08 22:43:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2113, '机械数据删除', 222, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:mechanicalData:remove', '#', 'admin', '2026-01-08 22:43:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2120, '故障记录查询', 223, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:faultRecord:query', '#', 'admin', '2026-01-08 22:43:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2121, '故障记录新增', 223, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:faultRecord:add', '#', 'admin', '2026-01-08 22:43:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2122, '故障记录修改', 223, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:faultRecord:edit', '#', 'admin', '2026-01-08 22:43:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2123, '故障记录删除', 223, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:faultRecord:remove', '#', 'admin', '2026-01-08 22:43:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2130, '气候数据查询', 224, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:climateData:query', '#', 'admin', '2026-01-08 22:43:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2131, '气候数据新增', 224, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:climateData:add', '#', 'admin', '2026-01-08 22:43:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2132, '气候数据修改', 224, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:climateData:edit', '#', 'admin', '2026-01-08 22:43:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2133, '气候数据删除', 224, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:climateData:remove', '#', 'admin', '2026-01-08 22:43:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2140, '设备规则查询', 225, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:deviceRule:query', '#', 'admin', '2026-01-08 22:43:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2141, '设备规则新增', 225, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:deviceRule:add', '#', 'admin', '2026-01-08 22:43:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2142, '设备规则修改', 225, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:deviceRule:edit', '#', 'admin', '2026-01-08 22:43:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2143, '设备规则删除', 225, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:deviceRule:remove', '#', 'admin', '2026-01-08 22:43:58', '', NULL, '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2025-10-31 15:23:03', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 若依系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2025-10-31 15:23:03', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 235 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"sys_config\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 15:55:05', 57);
INSERT INTO `sys_oper_log` VALUES (101, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"email\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuName\":\"邮件\",\"menuType\":\"M\",\"orderNum\":9,\"params\":{},\"parentId\":0,\"path\":\"email\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"新增菜单\'邮件\'失败，地址必须以http(s)://开头\",\"code\":500}', 0, NULL, '2025-10-31 16:20:05', 8);
INSERT INTO `sys_oper_log` VALUES (102, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/menu/index\",\"createTime\":\"2025-10-31 15:23:03\",\"icon\":\"tree-table\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":102,\"menuName\":\"菜单管理\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":1,\"path\":\"menu\",\"perms\":\"system:menu:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 16:26:30', 8);
INSERT INTO `sys_oper_log` VALUES (103, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/menu/index\",\"createTime\":\"2025-10-31 15:23:03\",\"icon\":\"tree-table\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":102,\"menuName\":\"菜单管理\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"menu\",\"perms\":\"system:menu:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 16:26:55', 7);
INSERT INTO `sys_oper_log` VALUES (104, '角色管理', 1, 'com.ruoyi.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[102,1012,1013,1014,1015],\"params\":{},\"remark\":\"666\",\"roleId\":100,\"roleKey\":\"0\",\"roleName\":\"ooo\",\"roleSort\":3,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 16:28:44', 15);
INSERT INTO `sys_oper_log` VALUES (105, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"小板\",\"params\":{},\"postIds\":[],\"roleIds\":[],\"status\":\"0\",\"userId\":100,\"userName\":\"xb\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 16:29:38', 96);
INSERT INTO `sys_oper_log` VALUES (106, '角色管理', 4, 'com.ruoyi.web.controller.system.SysRoleController.selectAuthUserAll()', 'PUT', 1, 'admin', '研发部门', '/system/role/authUser/selectAll', '127.0.0.1', '内网IP', '{\"roleId\":\"100\",\"userIds\":\"100\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 16:31:04', 4);
INSERT INTO `sys_oper_log` VALUES (107, '字典类型', 1, 'com.ruoyi.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"课程学科\",\"dictType\":\"course_subject\",\"params\":{},\"remark\":\"课程学科\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 16:37:20', 9);
INSERT INTO `sys_oper_log` VALUES (108, '字典类型', 5, 'com.ruoyi.web.controller.system.SysDictTypeController.export()', 'POST', 1, 'admin', '研发部门', '/system/dict/type/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"dictName\":\"课程学科\",\"pageNum\":\"2\"}', NULL, 0, NULL, '2025-10-31 16:41:30', 660);
INSERT INTO `sys_oper_log` VALUES (109, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"sys_config\"}', NULL, 0, NULL, '2025-10-31 16:42:46', 176);
INSERT INTO `sys_oper_log` VALUES (110, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"config\",\"className\":\"SysConfig\",\"columns\":[{\"capJavaField\":\"ConfigId\",\"columnComment\":\"参数主键\",\"columnId\":1,\"columnName\":\"config_id\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2025-10-31 15:55:05\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"configId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ConfigName\",\"columnComment\":\"参数名称\",\"columnId\":2,\"columnName\":\"config_name\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-31 15:55:05\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"configName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ConfigKey\",\"columnComment\":\"参数键名\",\"columnId\":3,\"columnName\":\"config_key\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-31 15:55:05\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"configKey\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ConfigValue\",\"columnComment\":\"参数键值\",\"columnId\":4,\"columnName\":\"config_value\",\"columnType\":\"varchar(500)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-31 15:55:05\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"textarea\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"is', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 16:44:40', 34);
INSERT INTO `sys_oper_log` VALUES (111, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"111\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2025-10-31 16:45:53', 3);
INSERT INTO `sys_oper_log` VALUES (112, '字典类型', 9, 'com.ruoyi.web.controller.system.SysDictTypeController.refreshCache()', 'DELETE', 1, 'admin', '研发部门', '/system/dict/type/refreshCache', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 16:46:32', 9);
INSERT INTO `sys_oper_log` VALUES (113, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"cssClass\":\"11\",\"default\":false,\"dictLabel\":\"int\",\"dictSort\":5,\"dictType\":\"course_subject\",\"dictValue\":\"www\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 16:48:07', 7);
INSERT INTO `sys_oper_log` VALUES (114, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-10-31 16:48:07\",\"cssClass\":\"11\",\"default\":false,\"dictCode\":100,\"dictLabel\":\"int\",\"dictSort\":5,\"dictType\":\"course_subject\",\"dictValue\":\"www\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"remark\":\"你好\\n\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 16:48:22', 8);
INSERT INTO `sys_oper_log` VALUES (115, '字典数据', 5, 'com.ruoyi.web.controller.system.SysDictDataController.export()', 'POST', 1, 'admin', '研发部门', '/system/dict/data/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\",\"dictType\":\"course_subject\"}', NULL, 0, NULL, '2025-10-31 16:49:22', 29);
INSERT INTO `sys_oper_log` VALUES (116, '字典数据', 5, 'com.ruoyi.web.controller.system.SysDictDataController.export()', 'POST', 1, 'admin', '研发部门', '/system/dict/data/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\",\"dictType\":\"course_subject\"}', NULL, 0, NULL, '2025-10-31 16:49:25', 24);
INSERT INTO `sys_oper_log` VALUES (117, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"cssClass\":\"22\",\"default\":false,\"dictLabel\":\"一样\",\"dictSort\":4,\"dictType\":\"course_subject\",\"dictValue\":\"22\",\"listClass\":\"default\",\"params\":{},\"remark\":\"我好\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 16:50:32', 8);
INSERT INTO `sys_oper_log` VALUES (118, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"sys_dept,sys_dict_data,sys_dict_type,sys_job,sys_job_log,sys_logininfor,sys_menu,sys_notice,sys_oper_log,sys_post\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 16:51:53', 270);
INSERT INTO `sys_oper_log` VALUES (119, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"create table \\\"课程管理\\\"\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2025-10-31 17:04:08', 50);
INSERT INTO `sys_oper_log` VALUES (120, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"create table \\\"课程管理\\\"\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2025-10-31 17:04:09', 3);
INSERT INTO `sys_oper_log` VALUES (121, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-10-31 16:50:32\",\"cssClass\":\"1\",\"default\":false,\"dictCode\":101,\"dictLabel\":\"一样\",\"dictSort\":4,\"dictType\":\"course_subject\",\"dictValue\":\"1\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"remark\":\"我好\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 17:13:05', 6);
INSERT INTO `sys_oper_log` VALUES (122, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-10-31 16:48:07\",\"cssClass\":\"1\",\"default\":false,\"dictCode\":100,\"dictLabel\":\"1\",\"dictSort\":5,\"dictType\":\"course_subject\",\"dictValue\":\"1\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"remark\":\"你好\\n\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 17:13:13', 6);
INSERT INTO `sys_oper_log` VALUES (123, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-10-31 16:50:32\",\"cssClass\":\"2\",\"default\":false,\"dictCode\":101,\"dictLabel\":\"2\",\"dictSort\":4,\"dictType\":\"course_subject\",\"dictValue\":\"2\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"remark\":\"我好\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 17:13:20', 6);
INSERT INTO `sys_oper_log` VALUES (124, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-10-31 16:48:07\",\"cssClass\":\"1\",\"default\":false,\"dictCode\":100,\"dictLabel\":\"1\",\"dictSort\":10,\"dictType\":\"course_subject\",\"dictValue\":\"1\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"remark\":\"你好\\n\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 17:13:28', 5);
INSERT INTO `sys_oper_log` VALUES (125, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-10-31 16:50:32\",\"cssClass\":\"2\",\"default\":false,\"dictCode\":101,\"dictLabel\":\"2\",\"dictSort\":10,\"dictType\":\"course_subject\",\"dictValue\":\"2\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"remark\":\"我好\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 17:13:33', 6);
INSERT INTO `sys_oper_log` VALUES (126, '字典数据', 5, 'com.ruoyi.web.controller.system.SysDictDataController.export()', 'POST', 1, 'admin', '研发部门', '/system/dict/data/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\",\"dictType\":\"course_subject\"}', NULL, 0, NULL, '2025-10-31 17:13:52', 22);
INSERT INTO `sys_oper_log` VALUES (127, '字典类型', 9, 'com.ruoyi.web.controller.system.SysDictTypeController.refreshCache()', 'DELETE', 1, 'admin', '研发部门', '/system/dict/type/refreshCache', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 17:14:00', 9);
INSERT INTO `sys_oper_log` VALUES (128, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"CREATE TABLE `t_user` (\\n  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT \'主键ID\',\\n  `name` varchar(30) NOT NULL DEFAULT \'\' COMMENT \'姓名\',\\n  `age` int(11) NULL DEFAULT NULL COMMENT \'年龄\',\\n  `gender` tinyint(2) NOT NULL DEFAULT 0 COMMENT \'性别，0：女 1：男\',\\n  PRIMARY KEY (`id`)\\n) COMMENT = \'用户表\';\\n\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 17:15:49', 41);
INSERT INTO `sys_oper_log` VALUES (129, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"user\",\"className\":\"TUser\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键ID\",\"columnId\":135,\"columnName\":\"id\",\"columnType\":\"bigint unsigned\",\"createBy\":\"admin\",\"createTime\":\"2025-10-31 17:15:49\",\"dictType\":\"\",\"edit\":false,\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":12,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"姓名\",\"columnId\":136,\"columnName\":\"name\",\"columnType\":\"varchar(30)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-31 17:15:49\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":12,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Age\",\"columnComment\":\"年龄\",\"columnId\":137,\"columnName\":\"age\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2025-10-31 17:15:49\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"age\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":12,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Gender\",\"columnComment\":\"性别，0：女 1：男\",\"columnId\":138,\"columnName\":\"gender\",\"columnType\":\"tinyint\",\"createBy\":\"admin\",\"createTime\":\"2025-10-31 17:15:49\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"gender\",\"javaType\":\"Long\",\"list\":true,\"params\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 17:17:20', 14);
INSERT INTO `sys_oper_log` VALUES (130, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"t_user\"}', NULL, 0, NULL, '2025-10-31 17:17:29', 35);
INSERT INTO `sys_oper_log` VALUES (131, '用户', 1, 'com.ruoyi.system.controller.TUserController.add()', 'POST', 1, 'admin', '研发部门', '/jingyes/user', '127.0.0.1', '内网IP', '{\"age\":22,\"gender\":1,\"id\":\"1\",\"name\":\"俄格\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 17:39:28', 132);
INSERT INTO `sys_oper_log` VALUES (132, '用户', 2, 'com.ruoyi.system.controller.TUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/jingyes/user', '127.0.0.1', '内网IP', '{\"age\":22,\"gender\":0,\"id\":\"1\",\"name\":\"俄格\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 17:39:33', 6);
INSERT INTO `sys_oper_log` VALUES (133, '用户', 1, 'com.ruoyi.system.controller.TUserController.add()', 'POST', 1, 'admin', '研发部门', '/jingyes/user', '127.0.0.1', '内网IP', '{\"age\":22,\"gender\":1,\"id\":\"2\",\"name\":\"买买买\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 17:39:46', 5);
INSERT INTO `sys_oper_log` VALUES (134, '用户', 3, 'com.ruoyi.system.controller.TUserController.remove()', 'DELETE', 1, 'admin', '研发部门', '/jingyes/user/1', '127.0.0.1', '内网IP', '[\"1\"]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 17:40:10', 6);
INSERT INTO `sys_oper_log` VALUES (135, '字典类型', 2, 'com.ruoyi.web.controller.system.SysDictTypeController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-10-31 16:37:20\",\"dictId\":100,\"dictName\":\"课程学科\",\"dictType\":\"course_subject\",\"params\":{},\"remark\":\"课程学科\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 08:30:14', 22);
INSERT INTO `sys_oper_log` VALUES (136, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"create table qcl_user\\n(\\n    id        int(11) auto_increment comment \'编号\',\\n    name      varchar(20) null comment \'姓名\',\\n    education varchar(20) null comment \'学历\',\\n    age       int         null comment \'年龄\',\\n    primary key (id)\\n) comment \'用户表\';\\n\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 08:57:15', 214);
INSERT INTO `sys_oper_log` VALUES (137, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"qcluser\",\"className\":\"QclUser\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"编号\",\"columnId\":139,\"columnName\":\"id\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 08:57:15\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"1\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":true,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":13,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"姓名\",\"columnId\":140,\"columnName\":\"name\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 08:57:15\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":13,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Education\",\"columnComment\":\"学历\",\"columnId\":141,\"columnName\":\"education\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 08:57:15\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"education\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":13,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Age\",\"columnComment\":\"年龄\",\"columnId\":142,\"columnName\":\"age\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 08:57:15\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"ja', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 08:59:53', 21);
INSERT INTO `sys_oper_log` VALUES (138, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"qcl_user\"}', NULL, 0, NULL, '2025-11-03 09:00:24', 122);
INSERT INTO `sys_oper_log` VALUES (139, '用户', 1, 'com.ruoyi.qcluser.controller.QclUserController.add()', 'POST', 1, 'admin', '研发部门', '/qcluser/qcluser', '127.0.0.1', '内网IP', '{\"age\":22,\"education\":\"本科\",\"id\":1,\"name\":\"王对\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 09:14:09', 10);
INSERT INTO `sys_oper_log` VALUES (140, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"-- 商品类型表\\nCREATE TABLE `good_type` (\\n    `type_id` INT AUTO_INCREMENT COMMENT \'自增ID\',\\n    `type_name` VARCHAR(255) NOT NULL COMMENT \'类型名称\',\\n    PRIMARY KEY (`type_id`) -- 主键\\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=\'商品类型\';\\n\\n-- 商品表\\nCREATE TABLE `good` (\\n    `good_id` INT AUTO_INCREMENT COMMENT \'自增ID\',\\n    `good_name` VARCHAR(255) NOT NULL COMMENT \'商品名称\',\\n    `price` DECIMAL(10, 2) NOT NULL COMMENT \'价格\',\\n    `image_url` VARCHAR(255) COMMENT \'图片链接\',\\n    `type_id` INT COMMENT \'类型ID\',\\n    FOREIGN KEY (`type_id`) REFERENCES `good_type`(`type_id`) \\n        ON DELETE CASCADE ON UPDATE CASCADE, -- 级联操作\\n    PRIMARY KEY (`good_id`) -- 主键\\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=\'商品信息\';\\n\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2025-11-03 09:15:44', 7);
INSERT INTO `sys_oper_log` VALUES (141, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"-- 商品类型表\\nCREATE TABLE `good_type` (\\n    `type_id` INT AUTO_INCREMENT COMMENT \'自增ID\',\\n    `type_name` VARCHAR(255) NOT NULL COMMENT \'类型名称\',\\n    PRIMARY KEY (`type_id`) -- 主键\\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=\'商品类型\';\\n\\n\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 09:16:23', 41);
INSERT INTO `sys_oper_log` VALUES (142, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"-- 商品表\\nCREATE TABLE `good` (\\n    `good_id` INT AUTO_INCREMENT COMMENT \'自增ID\',\\n    `good_name` VARCHAR(255) NOT NULL COMMENT \'商品名称\',\\n    `price` DECIMAL(10, 2) NOT NULL COMMENT \'价格\',\\n    `image_url` VARCHAR(255) COMMENT \'图片链接\',\\n    `type_id` INT COMMENT \'类型ID\',\\n    FOREIGN KEY (`type_id`) REFERENCES `good_type`(`type_id`) \\n        ON DELETE CASCADE ON UPDATE CASCADE, -- 级联操作\\n    PRIMARY KEY (`good_id`) -- 主键\\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=\'商品信息\';\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2025-11-03 09:16:35', 1);
INSERT INTO `sys_oper_log` VALUES (143, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"-- 商品表\\nCREATE TABLE `good` (\\n    `good_id` INT AUTO_INCREMENT COMMENT \'自增ID\',\\n    `good_name` VARCHAR(255) NOT NULL COMMENT \'商品名称\',\\n    `price` DECIMAL(10, 2) NOT NULL COMMENT \'价格\',\\n    `image_url` VARCHAR(255) COMMENT \'图片链接\',\\n    `type_id` INT COMMENT \'类型ID\',\\n    FOREIGN KEY (`type_id`) REFERENCES `good_type`(`type_id`) \\n        ON DELETE CASCADE ON UPDATE CASCADE, -- 级联操作\\n    PRIMARY KEY (`good_id`) -- 主键\\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=\'商品信息\';\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2025-11-03 09:16:56', 2);
INSERT INTO `sys_oper_log` VALUES (144, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"chart\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"商品管理\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"good\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 09:20:11', 9);
INSERT INTO `sys_oper_log` VALUES (145, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"good\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 09:20:57', 20);
INSERT INTO `sys_oper_log` VALUES (146, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"good\",\"className\":\"Good\",\"columns\":[{\"capJavaField\":\"GoodId\",\"columnComment\":\"自增ID\",\"columnId\":145,\"columnName\":\"good_id\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 09:20:57\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"goodId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":15,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"GoodName\",\"columnComment\":\"商品名称\",\"columnId\":146,\"columnName\":\"good_name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 09:20:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"goodName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":15,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Price\",\"columnComment\":\"价格\",\"columnId\":147,\"columnName\":\"price\",\"columnType\":\"decimal(10,2)\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 09:20:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"price\",\"javaType\":\"BigDecimal\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":15,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ImageUrl\",\"columnComment\":\"图片链接\",\"columnId\":148,\"columnName\":\"image_url\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 09:20:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 09:21:31', 20);
INSERT INTO `sys_oper_log` VALUES (147, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"good\",\"className\":\"Good\",\"columns\":[{\"capJavaField\":\"GoodId\",\"columnComment\":\"自增ID\",\"columnId\":145,\"columnName\":\"good_id\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 09:20:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"1\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"goodId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":true,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":15,\"updateBy\":\"\",\"updateTime\":\"2025-11-03 09:21:31\",\"usableColumn\":false},{\"capJavaField\":\"GoodName\",\"columnComment\":\"商品名称\",\"columnId\":146,\"columnName\":\"good_name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 09:20:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"goodName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":15,\"updateBy\":\"\",\"updateTime\":\"2025-11-03 09:21:31\",\"usableColumn\":false},{\"capJavaField\":\"Price\",\"columnComment\":\"价格\",\"columnId\":147,\"columnName\":\"price\",\"columnType\":\"decimal(10,2)\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 09:20:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"price\",\"javaType\":\"BigDecimal\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":15,\"updateBy\":\"\",\"updateTime\":\"2025-11-03 09:21:31\",\"usableColumn\":false},{\"capJavaField\":\"ImageUrl\",\"columnComment\":\"图片链接\",\"columnId\":148,\"columnName\":\"image_url\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 09:20:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 09:22:59', 13);
INSERT INTO `sys_oper_log` VALUES (148, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"type\",\"className\":\"GoodType\",\"columns\":[{\"capJavaField\":\"TypeId\",\"columnComment\":\"自增ID\",\"columnId\":143,\"columnName\":\"type_id\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 09:16:23\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"typeId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":14,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"TypeName\",\"columnComment\":\"类型名称\",\"columnId\":144,\"columnName\":\"type_name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 09:16:23\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"typeName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":14,\"updateBy\":\"\",\"usableColumn\":false}],\"crud\":false,\"functionAuthor\":\"风格\",\"functionName\":\"分类管理\",\"genPath\":\"/\",\"genType\":\"0\",\"moduleName\":\"good\",\"options\":\"{\\\"parentMenuId\\\":2012}\",\"packageName\":\"com.qcl.good\",\"params\":{\"parentMenuId\":2012},\"parentMenuId\":2012,\"sub\":true,\"subTableFkName\":\"type_id\",\"subTableName\":\"good\",\"tableComment\":\"商品分类表\",\"tableId\":14,\"tableName\":\"good_type\",\"tplCategory\":\"sub\",\"tplWebType\":\"element-plus\",\"tree\":false}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 09:24:54', 8);
INSERT INTO `sys_oper_log` VALUES (149, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"good,good_type\"}', NULL, 0, NULL, '2025-11-03 09:25:18', 82);
INSERT INTO `sys_oper_log` VALUES (150, '用户', 1, 'com.ruoyi.system.controller.TUserController.add()', 'POST', 1, 'admin', '研发部门', '/jingyes/user', '127.0.0.1', '内网IP', '{\"age\":1,\"gender\":0,\"id\":\"3\",\"name\":\"55\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 10:58:17', 13);
INSERT INTO `sys_oper_log` VALUES (151, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"type\",\"className\":\"GoodType\",\"columns\":[{\"capJavaField\":\"TypeId\",\"columnComment\":\"自增ID\",\"columnId\":143,\"columnName\":\"type_id\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 09:16:23\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"1\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"typeId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":true,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":14,\"updateBy\":\"\",\"updateTime\":\"2025-11-03 09:24:54\",\"usableColumn\":false},{\"capJavaField\":\"TypeName\",\"columnComment\":\"类型名称\",\"columnId\":144,\"columnName\":\"type_name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 09:16:23\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"typeName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":14,\"updateBy\":\"\",\"updateTime\":\"2025-11-03 09:24:54\",\"usableColumn\":false}],\"crud\":false,\"functionAuthor\":\"风格\",\"functionName\":\"分类管理\",\"genPath\":\"/\",\"genType\":\"0\",\"moduleName\":\"good\",\"options\":\"{\\\"parentMenuId\\\":2012}\",\"packageName\":\"com.qcl.good\",\"params\":{\"parentMenuId\":2012},\"parentMenuId\":2012,\"sub\":true,\"subTableFkName\":\"type_id\",\"subTableName\":\"good\",\"tableComment\":\"商品分类表\",\"tableId\":14,\"tableName\":\"good_type\",\"tplCategory\":\"sub\",\"tplWebType\":\"element-plus\",\"tree\":false}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 15:55:02', 30);
INSERT INTO `sys_oper_log` VALUES (152, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"department\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 16:01:44', 30);
INSERT INTO `sys_oper_log` VALUES (153, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"department\",\"className\":\"Department\",\"columns\":[{\"capJavaField\":\"DepartmentId\",\"columnComment\":\"部门ID\",\"columnId\":150,\"columnName\":\"department_id\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 16:01:44\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"1\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"departmentId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":true,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":16,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"DepartmentName\",\"columnComment\":\"部门名称\",\"columnId\":151,\"columnName\":\"department_name\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 16:01:44\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"departmentName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":16,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ParentId\",\"columnComment\":\"上级部门ID，用于表示部门层级关系\",\"columnId\":152,\"columnName\":\"parent_id\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 16:01:44\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"parentId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":16,\"updateBy\":\"\",\"usableColumn\":true},{\"capJavaField\":\"Chairman\",\"columnComment\":\"部门负责人\",\"columnId\":153,\"columnName\":\"chairman\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 16:01:44\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 16:03:13', 12);
INSERT INTO `sys_oper_log` VALUES (154, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"department\"}', NULL, 0, NULL, '2025-11-03 16:03:25', 146);
INSERT INTO `sys_oper_log` VALUES (155, '字典类型', 9, 'com.ruoyi.web.controller.system.SysDictTypeController.refreshCache()', 'DELETE', 1, 'admin', '研发部门', '/system/dict/type/refreshCache', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 16:13:49', 15);
INSERT INTO `sys_oper_log` VALUES (156, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/department', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 16:20:19', 54);
INSERT INTO `sys_oper_log` VALUES (157, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"department\",\"className\":\"Department\",\"columns\":[{\"capJavaField\":\"DepartmentId\",\"columnComment\":\"部门ID\",\"columnId\":150,\"columnName\":\"department_id\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 16:01:44\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"1\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"departmentId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":true,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":16,\"updateBy\":\"\",\"updateTime\":\"2025-11-03 16:20:19\",\"usableColumn\":false},{\"capJavaField\":\"DepartmentName\",\"columnComment\":\"部门名称\",\"columnId\":151,\"columnName\":\"department_name\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 16:01:44\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"departmentName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":16,\"updateBy\":\"\",\"updateTime\":\"2025-11-03 16:20:19\",\"usableColumn\":false},{\"capJavaField\":\"ParentId\",\"columnComment\":\"上级部门ID，用于表示部门层级关系\",\"columnId\":152,\"columnName\":\"parent_id\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2025-11-03 16:01:44\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"parentId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":16,\"updateBy\":\"\",\"updateTime\":\"2025-11-03 16:20:19\",\"usableColumn\":true},{\"capJavaField\":\"Chairman\",\"columnComment\":\"部门负责人\",\"columnId\":153,\"columnName\":\"chairman\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"20', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 16:21:01', 28);
INSERT INTO `sys_oper_log` VALUES (158, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"department\"}', NULL, 0, NULL, '2025-11-03 16:21:05', 151);
INSERT INTO `sys_oper_log` VALUES (159, '部门信息', 1, 'com.ruoyi.deparment.controller.DepartmentController.add()', 'POST', 1, 'admin', '研发部门', '/deparment/department', '127.0.0.1', '内网IP', '{\"chairman\":\"发我\",\"children\":[],\"departmentId\":1,\"departmentName\":\"uuu\",\"params\":{},\"parentId\":0}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 16:24:02', 110);
INSERT INTO `sys_oper_log` VALUES (160, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2012', '127.0.0.1', '内网IP', '2012', '{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}', 0, NULL, '2025-12-18 17:41:39', 7);
INSERT INTO `sys_oper_log` VALUES (161, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2018', '127.0.0.1', '内网IP', '2018', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-18 17:41:48', 26);
INSERT INTO `sys_oper_log` VALUES (162, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2017', '127.0.0.1', '内网IP', '2017', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-18 17:41:51', 14);
INSERT INTO `sys_oper_log` VALUES (163, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2016', '127.0.0.1', '内网IP', '2016', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-18 17:41:53', 12);
INSERT INTO `sys_oper_log` VALUES (164, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2015', '127.0.0.1', '内网IP', '2015', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-18 17:41:55', 13);
INSERT INTO `sys_oper_log` VALUES (165, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2014', '127.0.0.1', '内网IP', '2014', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-18 17:41:57', 17);
INSERT INTO `sys_oper_log` VALUES (166, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2013', '127.0.0.1', '内网IP', '2013', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-18 17:42:09', 24);
INSERT INTO `sys_oper_log` VALUES (167, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2012', '127.0.0.1', '内网IP', '2012', '{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}', 0, NULL, '2025-12-18 17:42:12', 6);
INSERT INTO `sys_oper_log` VALUES (168, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2019', '127.0.0.1', '内网IP', '2019', '{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}', 0, NULL, '2025-12-18 17:42:16', 3);
INSERT INTO `sys_oper_log` VALUES (169, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2020', '127.0.0.1', '内网IP', '2020', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-18 17:42:21', 15);
INSERT INTO `sys_oper_log` VALUES (170, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2021', '127.0.0.1', '内网IP', '2021', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-18 17:42:23', 12);
INSERT INTO `sys_oper_log` VALUES (171, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2022', '127.0.0.1', '内网IP', '2022', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-18 17:42:25', 22);
INSERT INTO `sys_oper_log` VALUES (172, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2023', '127.0.0.1', '内网IP', '2023', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-18 17:42:27', 13);
INSERT INTO `sys_oper_log` VALUES (173, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2024', '127.0.0.1', '内网IP', '2024', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-18 17:42:29', 13);
INSERT INTO `sys_oper_log` VALUES (174, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2019', '127.0.0.1', '内网IP', '2019', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-18 17:42:32', 17);
INSERT INTO `sys_oper_log` VALUES (175, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2012', '127.0.0.1', '内网IP', '2012', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-18 17:42:36', 12);
INSERT INTO `sys_oper_log` VALUES (176, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2005', '127.0.0.1', '内网IP', '2005', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-03 22:27:54', 91);
INSERT INTO `sys_oper_log` VALUES (177, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2004', '127.0.0.1', '内网IP', '2004', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-03 22:27:56', 21);
INSERT INTO `sys_oper_log` VALUES (178, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/101', '127.0.0.1', '内网IP', '101', '{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}', 0, NULL, '2026-01-03 22:27:58', 7);
INSERT INTO `sys_oper_log` VALUES (179, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2003', '127.0.0.1', '内网IP', '2003', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-03 22:28:05', 13);
INSERT INTO `sys_oper_log` VALUES (180, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2002', '127.0.0.1', '内网IP', '2002', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-03 22:28:08', 23);
INSERT INTO `sys_oper_log` VALUES (181, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2001', '127.0.0.1', '内网IP', '2001', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-03 22:28:10', 19);
INSERT INTO `sys_oper_log` VALUES (182, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2000', '127.0.0.1', '内网IP', '2000', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-03 22:28:12', 20);
INSERT INTO `sys_oper_log` VALUES (183, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/1011', '127.0.0.1', '内网IP', '1011', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-01-03 22:28:40', 10);
INSERT INTO `sys_oper_log` VALUES (184, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/117', '127.0.0.1', '内网IP', '117', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-01-03 23:48:00', 19);
INSERT INTO `sys_oper_log` VALUES (185, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/116', '127.0.0.1', '内网IP', '116', '{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}', 0, NULL, '2026-01-03 23:48:02', 7);
INSERT INTO `sys_oper_log` VALUES (186, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/117', '127.0.0.1', '内网IP', '117', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-01-03 23:48:08', 8);
INSERT INTO `sys_oper_log` VALUES (187, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/115', '127.0.0.1', '内网IP', '115', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-01-03 23:49:20', 40);
INSERT INTO `sys_oper_log` VALUES (188, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/1060', '127.0.0.1', '内网IP', '1060', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-01-03 23:49:45', 96);
INSERT INTO `sys_oper_log` VALUES (189, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/115', '127.0.0.1', '内网IP', '115', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-01-03 23:49:57', 34);
INSERT INTO `sys_oper_log` VALUES (190, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/1029', '127.0.0.1', '内网IP', '1029', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-01-03 23:50:16', 29);
INSERT INTO `sys_oper_log` VALUES (191, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'admin', '研发部门', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/01/06/014bc547f6e341f0b3715005c7ad4c71.png\",\"code\":200}', 0, NULL, '2026-01-06 19:59:17', 105);
INSERT INTO `sys_oper_log` VALUES (192, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '研发部门', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"3047969285@qq.com\",\"nickName\":\"若依\",\"params\":{},\"phonenumber\":\"18853471291\",\"sex\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-06 19:59:52', 18);
INSERT INTO `sys_oper_log` VALUES (193, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '研发部门', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"3047969285@qq.com\",\"nickName\":\"王昌振\",\"params\":{},\"phonenumber\":\"18853471291\",\"sex\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-06 20:41:24', 30);
INSERT INTO `sys_oper_log` VALUES (194, '设备信息', 2, 'com.ruoyi.web.controller.equipment.EqDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/device', '127.0.0.1', '内网IP', '{\"assetValue\":2000,\"createBy\":\"\",\"createTime\":\"2025-12-18 13:53:20\",\"department\":\"自动化部\",\"deviceId\":3,\"deviceName\":\"温度传感器C\",\"deviceNo\":\"SENSOR001\",\"deviceType\":\"温度传感器\",\"installDate\":\"2023-01-15 09:00:00\",\"lifespanYears\":5,\"location\":\"A区控制柜\",\"manufacturer\":\"欧姆龙\",\"model\":\"PT100\",\"params\":{},\"remark\":\"监控电机温度\",\"responsiblePerson\":\"王工\",\"serialNumber\":\"SN2023003\",\"status\":1,\"updateBy\":\"admin\",\"updateTime\":\"2026-01-08 01:41:31\",\"warrantyExpiration\":\"2025-01-15 09:00:00\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-08 01:41:31', 59);
INSERT INTO `sys_oper_log` VALUES (195, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2025-10-31 15:23:03\",\"delFlag\":\"0\",\"dept\":{\"ancestors\":\"0,100,101\",\"children\":[],\"deptId\":105,\"deptName\":\"测试部门\",\"leader\":\"若依\",\"orderNum\":3,\"params\":{},\"parentId\":101,\"status\":\"0\"},\"deptId\":105,\"email\":\"504204693@qq.com\",\"loginDate\":\"2025-10-31 15:23:03\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"若依\",\"params\":{},\"phonenumber\":\"15666666666\",\"postIds\":[2],\"pwdUpdateDate\":\"2025-10-31 15:23:03\",\"remark\":\"测试员\",\"roleIds\":[2],\"roles\":[{\"admin\":false,\"dataScope\":\"2\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\"}],\"sex\":\"1\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":2,\"userName\":\"ry\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-08 01:44:50', 25);
INSERT INTO `sys_oper_log` VALUES (196, '设备信息', 3, 'com.ruoyi.web.controller.equipment.EqDeviceController.remove()', 'DELETE', 1, 'admin', '研发部门', '/equipment/device/3,2,1', '127.0.0.1', '内网IP', '[3,2,1]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-08 01:56:43', 8);
INSERT INTO `sys_oper_log` VALUES (197, '设备信息', 1, 'com.ruoyi.web.controller.equipment.EqDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/equipment/device', '127.0.0.1', '内网IP', '{\"assetValue\":19900,\"createBy\":\"admin\",\"createTime\":\"2026-01-08 14:04:19\",\"department\":\"济南\",\"deviceId\":4,\"deviceName\":\"济南\",\"deviceNo\":\"dgsggge\",\"deviceType\":\"324\",\"installDate\":\"2026-01-08 00:00:00\",\"lifespanYears\":3,\"location\":\"济南\",\"manufacturer\":\"济南\",\"model\":\"济南\",\"params\":{},\"remark\":\"测试\",\"responsiblePerson\":\"韩信\",\"serialNumber\":\"34234\",\"status\":1,\"warrantyExpiration\":\"2027-01-14 00:00:00\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-08 14:04:19', 38);
INSERT INTO `sys_oper_log` VALUES (198, '设备信息', 2, 'com.ruoyi.web.controller.equipment.EqDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/device', '127.0.0.1', '内网IP', '{\"assetValue\":19900,\"createBy\":\"admin\",\"createTime\":\"2026-01-08 14:04:19\",\"department\":\"济南\",\"deviceId\":4,\"deviceName\":\"济南\",\"deviceNo\":\"dgsggge\",\"deviceType\":\"324\",\"installDate\":\"2026-01-08 00:00:00\",\"lifespanYears\":3,\"location\":\"济南\",\"manufacturer\":\"济南\",\"model\":\"济南\",\"params\":{},\"remark\":\"测试\",\"responsiblePerson\":\"韩信\",\"serialNumber\":\"34234\",\"status\":1,\"updateBy\":\"admin\",\"updateTime\":\"2026-01-08 14:04:25\",\"warrantyExpiration\":\"2027-01-14 00:00:00\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-08 14:04:25', 8);
INSERT INTO `sys_oper_log` VALUES (199, '设备信息', 3, 'com.ruoyi.web.controller.equipment.EqDeviceController.remove()', 'DELETE', 1, 'admin', '研发部门', '/equipment/device/4', '127.0.0.1', '内网IP', '[4]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-09 09:38:54', 47);
INSERT INTO `sys_oper_log` VALUES (200, '告警记录', 2, 'com.ruoyi.web.controller.equipment.EqAlertRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/alertRecord', '127.0.0.1', '内网IP', '{\"alertId\":3,\"alertLevel\":1,\"alertMessage\":\"电压不稳定\",\"deviceId\":1,\"deviceName\":\"主变压器1号\",\"deviceNo\":\"DEV-001\",\"params\":{},\"remark\":\"常规告警\",\"resolutionNotes\":\"已检查并确认，恢复正常\",\"resolvedBy\":0,\"resolvedTime\":\"2026-01-11 14:10:53\",\"status\":1,\"triggeredTime\":\"2026-01-11 12:10:53\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-11 23:38:30', 29);
INSERT INTO `sys_oper_log` VALUES (201, '设备信息', 2, 'com.ruoyi.web.controller.equipment.EqDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/device', '127.0.0.1', '内网IP', '{\"assetValue\":1500000,\"createBy\":\"admin\",\"createTime\":\"2026-01-12 00:01:08\",\"department\":\"运维部\",\"deviceId\":1,\"deviceName\":\"主变压器1号\",\"deviceNo\":\"DEV-001\",\"deviceType\":\"变压器\",\"installDate\":\"2021-01-15 00:00:00\",\"lifespanYears\":20,\"location\":\"主厂房A区1层\",\"manufacturer\":\"华为技术有限公司\",\"model\":\"SFZ10-31500/110\",\"params\":{},\"remark\":\"主要供电设备\",\"responsiblePerson\":\"张工\",\"serialNumber\":\"BYQ-20210001\",\"status\":3,\"updateBy\":\"admin\",\"updateTime\":\"2026-01-15 21:18:19\",\"warrantyExpiration\":\"2031-01-15 00:00:00\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-15 21:18:19', 28);
INSERT INTO `sys_oper_log` VALUES (202, '设备信息', 2, 'com.ruoyi.web.controller.equipment.EqDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/device', '127.0.0.1', '内网IP', '{\"assetValue\":1500000,\"createBy\":\"admin\",\"createTime\":\"2026-01-12 00:01:08\",\"department\":\"运维部\",\"deviceId\":1,\"deviceName\":\"主变压器1号\",\"deviceNo\":\"DEV-001\",\"deviceType\":\"变压器\",\"installDate\":\"2021-01-15 00:00:00\",\"lifespanYears\":20,\"location\":\"主厂房A区1层\",\"manufacturer\":\"华为技术有限公司\",\"model\":\"SFZ10-31500/110\",\"params\":{},\"remark\":\"主要供电设备\",\"responsiblePerson\":\"张工\",\"serialNumber\":\"BYQ-20210001\",\"status\":3,\"updateBy\":\"admin\",\"updateTime\":\"2026-01-15 21:19:37\",\"warrantyExpiration\":\"2031-01-15 00:00:00\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-15 21:19:37', 6);
INSERT INTO `sys_oper_log` VALUES (203, '设备信息', 2, 'com.ruoyi.web.controller.equipment.EqDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/device', '127.0.0.1', '内网IP', '{\"assetValue\":1500000,\"createBy\":\"admin\",\"createTime\":\"2026-01-12 00:01:08\",\"department\":\"运维部\",\"deviceId\":2,\"deviceName\":\"主变压器2号\",\"deviceNo\":\"DEV-002\",\"deviceType\":\"变压器\",\"installDate\":\"2021-02-20 00:00:00\",\"lifespanYears\":20,\"location\":\"主厂房A区2层\",\"manufacturer\":\"华为技术有限公司\",\"model\":\"SFZ10-31500/110\",\"params\":{},\"remark\":\"备用供电设备\",\"responsiblePerson\":\"张工\",\"serialNumber\":\"BYQ-20210002\",\"status\":1,\"updateBy\":\"admin\",\"updateTime\":\"2026-01-15 21:19:39\",\"warrantyExpiration\":\"2031-02-20 00:00:00\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-15 21:19:39', 6);
INSERT INTO `sys_oper_log` VALUES (204, '故障记录', 2, 'com.ruoyi.web.controller.equipment.EqFaultRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/faultRecord', '127.0.0.1', '内网IP', '{\"detectedTime\":\"2025-11-22 00:40:52\",\"deviceId\":1,\"deviceName\":\"主变压器1号\",\"deviceNo\":\"DEV-001\",\"faultCode\":\"F9101\",\"faultDescription\":\"机械磨损\",\"faultId\":3,\"faultLevel\":\"1\",\"params\":{},\"partsReplaced\":\"[\\\"接触器\\\"]\",\"remark\":\"故障已解决\",\"repairCost\":1011.27,\"repairDuration\":134,\"resolutionNotes\":\"故障已修复，设备恢复正常运行\",\"resolvedTime\":\"2025-12-23 00:40:52\",\"rootCause\":\"操作不当\",\"status\":2}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 21:55:51', 29);
INSERT INTO `sys_oper_log` VALUES (205, '告警记录', 2, 'com.ruoyi.web.controller.equipment.EqAlertRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/alertRecord', '127.0.0.1', '内网IP', '{\"alertId\":1,\"alertLevel\":3,\"alertMessage\":\"电流波动异常\",\"deviceId\":1,\"deviceName\":\"主变压器1号\",\"deviceNo\":\"DEV-001\",\"params\":{},\"remark\":\"常规告警\",\"resolutionNotes\":\"已检查并确认，恢复正常\",\"resolvedBy\":0,\"resolvedTime\":\"2026-01-11 19:01:33\",\"status\":1,\"triggeredTime\":\"2026-01-11 23:01:33\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 22:03:13', 24);
INSERT INTO `sys_oper_log` VALUES (206, '告警记录', 2, 'com.ruoyi.web.controller.equipment.EqAlertRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/alertRecord', '127.0.0.1', '内网IP', '{\"alertId\":3,\"alertLevel\":1,\"alertMessage\":\"电流波动异常\",\"deviceId\":1,\"deviceName\":\"主变压器1号\",\"deviceNo\":\"DEV-001\",\"params\":{},\"remark\":\"常规告警\",\"resolutionNotes\":\"已检查并确认，恢复正常\",\"resolvedBy\":0,\"status\":1,\"triggeredTime\":\"2026-01-11 16:01:33\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 22:03:42', 42);
INSERT INTO `sys_oper_log` VALUES (207, '告警记录', 2, 'com.ruoyi.web.controller.equipment.EqAlertRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/alertRecord', '127.0.0.1', '内网IP', '{\"alertId\":2,\"alertLevel\":3,\"alertMessage\":\"温度超过警告阈值\",\"deviceId\":1,\"deviceName\":\"主变压器1号\",\"deviceNo\":\"DEV-001\",\"params\":{},\"remark\":\"常规告警\",\"resolutionNotes\":\"已检查并确认，恢复正常\",\"resolvedBy\":0,\"resolvedTime\":\"2026-01-11 18:01:33\",\"status\":1,\"triggeredTime\":\"2026-01-11 00:01:33\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 22:03:48', 7);
INSERT INTO `sys_oper_log` VALUES (208, '告警记录', 2, 'com.ruoyi.web.controller.equipment.EqAlertRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/alertRecord', '127.0.0.1', '内网IP', '{\"alertId\":6,\"alertLevel\":3,\"alertMessage\":\"振动值偏高\",\"deviceId\":2,\"deviceName\":\"主变压器2号\",\"deviceNo\":\"DEV-002\",\"params\":{},\"remark\":\"常规告警\",\"resolutionNotes\":\"已检查并确认，恢复正常\",\"resolvedBy\":0,\"resolvedTime\":\"2026-01-11 03:01:33\",\"status\":1,\"triggeredTime\":\"2026-01-11 20:01:33\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 22:27:58', 6);
INSERT INTO `sys_oper_log` VALUES (209, '告警记录', 2, 'com.ruoyi.web.controller.equipment.EqAlertRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/alertRecord', '127.0.0.1', '内网IP', '{\"alertId\":1,\"alertLevel\":3,\"alertMessage\":\"电流波动异常\",\"deviceId\":1,\"deviceName\":\"主变压器1号\",\"deviceNo\":\"DEV-001\",\"params\":{},\"remark\":\"常规告警\",\"resolutionNotes\":\"已检查并确认，恢复正常\",\"resolvedBy\":0,\"resolvedTime\":\"2026-01-11 19:01:33\",\"status\":2,\"triggeredTime\":\"2026-01-11 23:01:33\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 22:34:16', 4);
INSERT INTO `sys_oper_log` VALUES (210, '告警记录', 2, 'com.ruoyi.web.controller.equipment.EqAlertRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/alertRecord', '127.0.0.1', '内网IP', '{\"alertId\":3,\"alertLevel\":1,\"alertMessage\":\"电流波动异常\",\"deviceId\":1,\"deviceName\":\"主变压器1号\",\"deviceNo\":\"DEV-001\",\"params\":{},\"remark\":\"常规告警\",\"resolutionNotes\":\"已检查并确认，恢复正常\",\"resolvedBy\":0,\"status\":2,\"triggeredTime\":\"2026-01-11 16:01:33\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 22:35:18', 4);
INSERT INTO `sys_oper_log` VALUES (211, '告警记录', 2, 'com.ruoyi.web.controller.equipment.EqAlertRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/alertRecord', '127.0.0.1', '内网IP', '{\"alertId\":2,\"alertLevel\":3,\"alertMessage\":\"温度超过警告阈值\",\"deviceId\":1,\"deviceName\":\"主变压器1号\",\"deviceNo\":\"DEV-001\",\"params\":{},\"remark\":\"常规告警\",\"resolutionNotes\":\"已检查并确认，恢复正常\",\"resolvedBy\":0,\"resolvedTime\":\"2026-01-11 18:01:33\",\"status\":2,\"triggeredTime\":\"2026-01-11 00:01:33\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 22:35:24', 5);
INSERT INTO `sys_oper_log` VALUES (212, '告警记录', 2, 'com.ruoyi.web.controller.equipment.EqAlertRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/alertRecord', '127.0.0.1', '内网IP', '{\"alertId\":6,\"alertLevel\":3,\"alertMessage\":\"振动值偏高\",\"deviceId\":2,\"deviceName\":\"主变压器2号\",\"deviceNo\":\"DEV-002\",\"params\":{},\"remark\":\"常规告警\",\"resolutionNotes\":\"已检查并确认，恢复正常\",\"resolvedBy\":0,\"resolvedTime\":\"2026-01-11 03:01:33\",\"status\":2,\"triggeredTime\":\"2026-01-11 20:01:33\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 22:56:10', 5);
INSERT INTO `sys_oper_log` VALUES (213, '告警记录', 2, 'com.ruoyi.web.controller.equipment.EqAlertRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/alertRecord', '127.0.0.1', '内网IP', '{\"alertId\":7,\"alertLevel\":1,\"alertMessage\":\"电流波动异常\",\"deviceId\":3,\"deviceName\":\"配电柜1号\",\"deviceNo\":\"DEV-003\",\"params\":{},\"remark\":\"常规告警\",\"resolutionNotes\":\"已检查并确认，恢复正常\",\"resolvedBy\":0,\"resolvedTime\":\"2026-01-11 06:01:33\",\"status\":2,\"triggeredTime\":\"2026-01-11 15:01:33\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 23:02:52', 28);
INSERT INTO `sys_oper_log` VALUES (214, '设备信息', 2, 'com.ruoyi.web.controller.equipment.EqDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/device', '127.0.0.1', '内网IP', '{\"assetValue\":1500000,\"createBy\":\"admin\",\"createTime\":\"2026-01-12 00:01:08\",\"department\":\"运维部\",\"deviceId\":1,\"deviceName\":\"主变压器1号\",\"deviceNo\":\"DEV-001\",\"deviceType\":\"变压器\",\"installDate\":\"2021-01-15 00:00:00\",\"lifespanYears\":20,\"location\":\"主厂房A区1层\",\"manufacturer\":\"华为技术有限公司\",\"model\":\"SFZ10-31500/110\",\"params\":{},\"remark\":\"主要供电设备\",\"responsiblePerson\":\"张工\",\"serialNumber\":\"BYQ-20210001\",\"status\":1,\"updateBy\":\"admin\",\"updateTime\":\"2026-02-18 14:28:53\",\"warrantyExpiration\":\"2031-01-15 00:00:00\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-18 14:28:53', 24);
INSERT INTO `sys_oper_log` VALUES (215, '告警记录', 2, 'com.ruoyi.web.controller.equipment.EqAlertRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/alertRecord', '127.0.0.1', '内网IP', '{\"alertId\":11,\"alertLevel\":1,\"alertMessage\":\"振动值偏高\",\"deviceId\":4,\"deviceName\":\"配电柜2号\",\"deviceNo\":\"DEV-004\",\"params\":{},\"remark\":\"常规告警\",\"resolutionNotes\":\"已检查并确认，恢复正常\",\"resolvedBy\":0,\"resolvedTime\":\"2026-01-11 10:01:33\",\"status\":3,\"triggeredTime\":\"2026-01-10 09:01:33\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-18 14:29:37', 10);
INSERT INTO `sys_oper_log` VALUES (216, '故障记录', 2, 'com.ruoyi.web.controller.equipment.EqFaultRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/faultRecord', '127.0.0.1', '内网IP', '{\"detectedTime\":\"2025-11-22 00:40:52\",\"deviceId\":1,\"deviceName\":\"主变压器1号\",\"deviceNo\":\"DEV-001\",\"faultCode\":\"F9101\",\"faultDescription\":\"机械磨损\",\"faultId\":3,\"faultLevel\":\"1\",\"params\":{},\"partsReplaced\":\"[\\\"接触器\\\"]\",\"remark\":\"故障已解决\",\"repairCost\":1011.27,\"repairDuration\":134,\"resolutionNotes\":\"故障已修复，设备恢复正常运行\",\"resolvedTime\":\"2025-12-23 00:40:52\",\"rootCause\":\"操作不当\",\"status\":2}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-18 14:30:00', 5);
INSERT INTO `sys_oper_log` VALUES (217, '告警记录', 2, 'com.ruoyi.web.controller.equipment.EqAlertRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/alertRecord', '127.0.0.1', '内网IP', '{\"alertId\":19,\"alertLevel\":2,\"alertMessage\":\"电流波动异常\",\"deviceId\":7,\"deviceName\":\"发电机1号\",\"deviceNo\":\"DEV-007\",\"params\":{},\"remark\":\"常规告警\",\"resolutionNotes\":\"已检查并确认，恢复正常\",\"resolvedBy\":0,\"resolvedTime\":\"2026-01-11 09:01:33\",\"status\":2,\"triggeredTime\":\"2026-01-09 22:01:33\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-18 14:30:45', 4);
INSERT INTO `sys_oper_log` VALUES (218, '告警记录', 2, 'com.ruoyi.web.controller.equipment.EqAlertRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/alertRecord', '127.0.0.1', '内网IP', '{\"alertId\":44,\"alertLevel\":3,\"alertMessage\":\"电压不稳定\",\"deviceId\":15,\"deviceName\":\"隔离开关1号\",\"deviceNo\":\"DEV-015\",\"params\":{},\"remark\":\"常规告警\",\"resolutionNotes\":\"已检查并确认，恢复正常\",\"resolvedBy\":0,\"status\":3,\"triggeredTime\":\"2026-01-09 04:01:33\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-18 14:31:00', 3);
INSERT INTO `sys_oper_log` VALUES (219, '告警记录', 2, 'com.ruoyi.web.controller.equipment.EqAlertRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/alertRecord', '127.0.0.1', '内网IP', '{\"alertId\":3,\"alertLevel\":1,\"alertMessage\":\"电流波动异常\",\"deviceId\":1,\"deviceName\":\"主变压器1号\",\"deviceNo\":\"DEV-001\",\"params\":{},\"remark\":\"常规告警\",\"resolutionNotes\":\"已检查并确认，恢复正常\",\"resolvedBy\":0,\"status\":3,\"triggeredTime\":\"2026-01-11 16:01:33\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-18 14:31:04', 3);
INSERT INTO `sys_oper_log` VALUES (220, '告警记录', 2, 'com.ruoyi.web.controller.equipment.EqAlertRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/alertRecord', '127.0.0.1', '内网IP', '{\"alertId\":3,\"alertLevel\":1,\"alertMessage\":\"电流波动异常\",\"deviceId\":1,\"deviceName\":\"主变压器1号\",\"deviceNo\":\"DEV-001\",\"params\":{},\"remark\":\"常规告警\",\"resolutionNotes\":\"已检查并确认，恢复正常\",\"resolvedBy\":0,\"status\":2,\"triggeredTime\":\"2026-01-11 16:01:33\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-18 14:31:08', 4);
INSERT INTO `sys_oper_log` VALUES (221, '告警记录', 2, 'com.ruoyi.web.controller.equipment.EqAlertRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/alertRecord', '127.0.0.1', '内网IP', '{\"alertId\":50,\"alertLevel\":1,\"alertMessage\":\"负载过高\",\"deviceId\":17,\"deviceName\":\"UPS电源1号\",\"deviceNo\":\"DEV-017\",\"params\":{},\"remark\":\"常规告警\",\"resolutionNotes\":\"已检查并确认，恢复正常\",\"resolvedBy\":0,\"resolvedTime\":\"2026-01-11 15:01:33\",\"status\":2,\"triggeredTime\":\"2026-01-10 00:01:33\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-18 14:31:15', 3);
INSERT INTO `sys_oper_log` VALUES (222, '告警记录', 2, 'com.ruoyi.web.controller.equipment.EqAlertRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/alertRecord', '127.0.0.1', '内网IP', '{\"alertId\":15,\"alertLevel\":1,\"alertMessage\":\"电压不稳定\",\"deviceId\":5,\"deviceName\":\"断路器1号\",\"deviceNo\":\"DEV-005\",\"params\":{},\"remark\":\"常规告警\",\"resolutionNotes\":\"已检查并确认，恢复正常\",\"resolvedBy\":0,\"resolvedTime\":\"2026-01-11 16:01:33\",\"status\":2,\"triggeredTime\":\"2026-01-10 07:01:33\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-18 14:31:30', 4);
INSERT INTO `sys_oper_log` VALUES (223, '告警记录', 2, 'com.ruoyi.web.controller.equipment.EqAlertRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/alertRecord', '127.0.0.1', '内网IP', '{\"alertId\":26,\"alertLevel\":1,\"alertMessage\":\"电流波动异常\",\"deviceId\":9,\"deviceName\":\"电容器组1号\",\"deviceNo\":\"DEV-009\",\"params\":{},\"remark\":\"常规告警\",\"resolutionNotes\":\"已检查并确认，恢复正常\",\"resolvedBy\":0,\"resolvedTime\":\"2026-01-11 19:01:33\",\"status\":2,\"triggeredTime\":\"2026-01-10 01:01:33\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-13 21:03:57', 26);
INSERT INTO `sys_oper_log` VALUES (224, '告警记录', 2, 'com.ruoyi.web.controller.equipment.EqAlertRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/alertRecord', '127.0.0.1', '内网IP', '{\"alertId\":3,\"alertLevel\":1,\"alertMessage\":\"电流波动异常\",\"deviceId\":1,\"deviceName\":\"主变压器1号\",\"deviceNo\":\"DEV-001\",\"params\":{},\"remark\":\"常规告警\",\"resolutionNotes\":\"已检查并确认，恢复正常\",\"resolvedBy\":0,\"status\":1,\"triggeredTime\":\"2026-01-11 16:01:33\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-13 21:05:02', 4);
INSERT INTO `sys_oper_log` VALUES (225, '定时任务', 1, 'com.ruoyi.quartz.controller.SysJobController.add()', 'POST', 1, 'admin', '研发部门', '/monitor/job', '127.0.0.1', '内网IP', '{\"concurrent\":\"0\",\"cronExpression\":\"0 0/1 * * * ?\",\"invokeTarget\":\"maintenanceFormService.notifyDevicesRequiringMaintenance\",\"jobGroup\":\"DEFAULT\",\"jobName\":\"定时检查报警\",\"misfirePolicy\":\"1\",\"nextValidTime\":\"2026-03-13 21:16:00\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"新增任务\'定时检查报警\'失败，目标字符串不在白名单内\",\"code\":500}', 0, NULL, '2026-03-13 21:15:22', 2);
INSERT INTO `sys_oper_log` VALUES (226, '定时任务', 1, 'com.ruoyi.quartz.controller.SysJobController.add()', 'POST', 1, 'admin', '研发部门', '/monitor/job', '127.0.0.1', '内网IP', '{\"concurrent\":\"0\",\"cronExpression\":\"0 0/1 * * * ?\",\"invokeTarget\":\"maintenanceFormService.notifyDevicesRequiringMaintenance\",\"jobGroup\":\"DEFAULT\",\"jobName\":\"定时检查报警\",\"misfirePolicy\":\"1\",\"nextValidTime\":\"2026-03-13 21:16:00\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"新增任务\'定时检查报警\'失败，目标字符串不在白名单内\",\"code\":500}', 0, NULL, '2026-03-13 21:15:25', 1);
INSERT INTO `sys_oper_log` VALUES (227, '定时任务', 1, 'com.ruoyi.quartz.controller.SysJobController.add()', 'POST', 1, 'admin', '研发部门', '/monitor/job', '127.0.0.1', '内网IP', '{\"concurrent\":\"0\",\"cronExpression\":\"0 0/1 * * * ?\",\"invokeTarget\":\"maintenanceFormService.notifyDevicesRequiringMaintenance\",\"jobGroup\":\"DEFAULT\",\"jobName\":\"定时检查报警\",\"misfirePolicy\":\"1\",\"nextValidTime\":\"2026-03-13 21:16:00\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"新增任务\'定时检查报警\'失败，目标字符串不在白名单内\",\"code\":500}', 0, NULL, '2026-03-13 21:15:30', 0);
INSERT INTO `sys_oper_log` VALUES (228, '定时任务', 5, 'com.ruoyi.quartz.controller.SysJobController.export()', 'POST', 1, 'admin', '研发部门', '/monitor/job/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2026-03-13 21:17:12', 763);
INSERT INTO `sys_oper_log` VALUES (229, '定时任务', 1, 'com.ruoyi.quartz.controller.SysJobController.add()', 'POST', 1, 'admin', '研发部门', '/monitor/job', '127.0.0.1', '内网IP', '{\"concurrent\":\"1\",\"createBy\":\"admin\",\"cronExpression\":\"0 0/1 * * * ?\",\"invokeTarget\":\"maintenanceFormService.notifyDevicesRequiringMaintenance\",\"jobGroup\":\"DEFAULT\",\"jobId\":100,\"jobName\":\"检查报警\",\"misfirePolicy\":\"1\",\"nextValidTime\":\"2026-03-13 21:18:00\",\"params\":{},\"status\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-13 21:17:37', 20);
INSERT INTO `sys_oper_log` VALUES (230, '定时任务', 2, 'com.ruoyi.quartz.controller.SysJobController.changeStatus()', 'PUT', 1, 'admin', '研发部门', '/monitor/job/changeStatus', '127.0.0.1', '内网IP', '{\"jobId\":100,\"misfirePolicy\":\"0\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-13 21:17:46', 8);
INSERT INTO `sys_oper_log` VALUES (231, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0\",\"children\":[],\"deptId\":100,\"deptName\":\"大风车科技\",\"email\":\"3047969285@qq.com\",\"leader\":\"若依\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-13 22:55:34', 16);
INSERT INTO `sys_oper_log` VALUES (232, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"children\":[],\"deptId\":101,\"deptName\":\"深圳总公司\",\"email\":\"ry@qq.com\",\"leader\":\"若依\",\"orderNum\":1,\"params\":{},\"parentId\":100,\"parentName\":\"大风车科技\",\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-13 22:56:01', 10);
INSERT INTO `sys_oper_log` VALUES (233, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"children\":[],\"deptId\":101,\"deptName\":\"烟台总公司\",\"email\":\"ry@qq.com\",\"leader\":\"若依\",\"orderNum\":1,\"params\":{},\"parentId\":100,\"parentName\":\"大风车科技\",\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-13 22:56:17', 9);
INSERT INTO `sys_oper_log` VALUES (234, '部门管理', 2, 'com.ruoyi.web.controller.system.SysDeptController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dept', '127.0.0.1', '内网IP', '{\"ancestors\":\"0,100\",\"children\":[],\"deptId\":102,\"deptName\":\"济南分公司\",\"email\":\"ry@qq.com\",\"leader\":\"若依\",\"orderNum\":2,\"params\":{},\"parentId\":100,\"parentName\":\"大风车科技\",\"phone\":\"15888888888\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-13 22:56:25', 9);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2025-10-31 15:23:03', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2025-10-31 15:23:03', '', NULL, '普通角色');
INSERT INTO `sys_role` VALUES (100, 'ooo', '0', 3, '1', 1, 1, '0', '0', 'admin', '2025-10-31 16:28:44', '', NULL, '666');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色和部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (1, 201);
INSERT INTO `sys_role_menu` VALUES (1, 200);
INSERT INTO `sys_role_menu` VALUES (1, 206);
INSERT INTO `sys_role_menu` VALUES (1, 2011);
INSERT INTO `sys_role_menu` VALUES (1, 2012);
INSERT INTO `sys_role_menu` VALUES (1, 2013);
INSERT INTO `sys_role_menu` VALUES (1, 2061);
INSERT INTO `sys_role_menu` VALUES (1, 2062);
INSERT INTO `sys_role_menu` VALUES (1, 2063);
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 3);
INSERT INTO `sys_role_menu` VALUES (2, 4);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 115);
INSERT INTO `sys_role_menu` VALUES (2, 116);
INSERT INTO `sys_role_menu` VALUES (2, 117);
INSERT INTO `sys_role_menu` VALUES (2, 201);
INSERT INTO `sys_role_menu` VALUES (2, 206);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 1055);
INSERT INTO `sys_role_menu` VALUES (2, 1056);
INSERT INTO `sys_role_menu` VALUES (2, 1057);
INSERT INTO `sys_role_menu` VALUES (2, 1058);
INSERT INTO `sys_role_menu` VALUES (2, 1059);
INSERT INTO `sys_role_menu` VALUES (2, 1060);
INSERT INTO `sys_role_menu` VALUES (2, 2011);
INSERT INTO `sys_role_menu` VALUES (2, 2012);
INSERT INTO `sys_role_menu` VALUES (2, 2013);
INSERT INTO `sys_role_menu` VALUES (2, 2061);
INSERT INTO `sys_role_menu` VALUES (2, 2062);
INSERT INTO `sys_role_menu` VALUES (2, 2063);
INSERT INTO `sys_role_menu` VALUES (100, 102);
INSERT INTO `sys_role_menu` VALUES (100, 1012);
INSERT INTO `sys_role_menu` VALUES (100, 1013);
INSERT INTO `sys_role_menu` VALUES (100, 1014);
INSERT INTO `sys_role_menu` VALUES (100, 1015);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime NULL DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '王昌振', '00', '3047969285@qq.com', '18853471291', '0', '/profile/avatar/2026/01/06/014bc547f6e341f0b3715005c7ad4c71.png', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-03-18 16:49:11', '2025-10-31 15:23:03', 'admin', '2025-10-31 15:23:03', '', '2026-01-06 20:41:24', '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', '504204693@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-10-31 15:23:03', '2025-10-31 15:23:03', 'admin', '2025-10-31 15:23:03', 'admin', '2026-01-08 01:44:50', '测试员');
INSERT INTO `sys_user` VALUES (100, NULL, 'xb', '小板', '00', '', '', '0', '', '$2a$10$pAzOgZkw25WiXECl0AXJeOaibPlYbXTMrHkTg04Ydys6vN2MCcmkC', '0', '0', '127.0.0.1', '2025-10-31 16:31:15', NULL, 'admin', '2025-10-31 16:29:38', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);
INSERT INTO `sys_user_role` VALUES (100, 100);

-- ----------------------------
-- Table structure for t_user
-- ----------------------------
DROP TABLE IF EXISTS `t_user`;
CREATE TABLE `t_user`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '姓名',
  `age` int NULL DEFAULT NULL COMMENT '年龄',
  `gender` tinyint NOT NULL DEFAULT 0 COMMENT '性别，0：女 1：男',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_user
-- ----------------------------
INSERT INTO `t_user` VALUES (2, '买买买', 22, 1);
INSERT INTO `t_user` VALUES (3, '55', 1, 0);

-- ----------------------------
-- 风力预测：每台设备绑定的模型与 Excel 路径（绝对路径或 /profile 相对上传路径）
-- ----------------------------
DROP TABLE IF EXISTS `eq_wind_forecast_bind`;
CREATE TABLE `eq_wind_forecast_bind`  (
  `device_id` bigint NOT NULL COMMENT '设备ID',
  `model_path` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'GRU 模型 .h5 绝对路径',
  `feature_excel_path` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '特征 Excel 绝对路径',
  `real_excel_path` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '实测功率 Excel 绝对路径',
  `inline_data_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '页面编辑的风速+功率序列 JSON，预测时生成临时 Excel',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`device_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '风力预测设备数据绑定' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 可选升级：旧库已存在 eq_wind_forecast_bind 但缺少 inline_data_json 时补齐（可重复执行）
-- ----------------------------
SET @db := DATABASE();
SET @exists := (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'eq_wind_forecast_bind' AND COLUMN_NAME = 'inline_data_json'
);
SET @sql := IF(
  @exists = 0,
  'ALTER TABLE `eq_wind_forecast_bind` ADD COLUMN `inline_data_json` longtext NULL COMMENT ''页面编辑的风速+功率序列 JSON'' AFTER `real_excel_path`',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- ----------------------------
-- 站内消息（与 sql/sys_user_message.sql 一致；单独文件便于旧库增量）
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sys_user_message` (
  `msg_id` bigint NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `user_id` bigint NOT NULL COMMENT '接收用户ID',
  `msg_type` varchar(32) NOT NULL DEFAULT 'maintenance_form' COMMENT '消息类型',
  `title` varchar(200) NOT NULL DEFAULT '' COMMENT '标题',
  `content` varchar(1000) NOT NULL DEFAULT '' COMMENT '摘要内容',
  `biz_id` bigint NULL DEFAULT NULL COMMENT '业务主键，如 form_id / device_id',
  `read_flag` char(1) NOT NULL DEFAULT '0' COMMENT '是否已读 0否 1是',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`msg_id`),
  KEY `idx_user_read` (`user_id`, `read_flag`),
  KEY `idx_user_time` (`user_id`, `create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户站内消息';

SET FOREIGN_KEY_CHECKS = 1;
