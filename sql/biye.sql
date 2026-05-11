/*
 Navicat Premium Dump SQL

 Source Server         : 我的
 Source Server Type    : MySQL
 Source Server Version : 80032 (8.0.32)
 Source Host           : localhost:3306
 Source Schema         : biye

 Target Server Type    : MySQL
 Target Server Version : 80032 (8.0.32)
 File Encoding         : 65001

 Date: 21/04/2026 19:38:12
*/

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
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '智能问答对话记录表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `ai_chat_record` VALUES (28, 0, '匿名用户', 'basic', '你好', '', '2026-03-29 15:50:01');
INSERT INTO `ai_chat_record` VALUES (29, 0, '匿名用户', 'basic', '你好', '你好，我是智能电网运维专家。请问您在智能电网运行、设备维护、故障排查或系统升级等方面遇到什么具体问题？我可以提供专业建议和操作步骤。', '2026-03-29 15:53:29');
INSERT INTO `ai_chat_record` VALUES (30, 0, '匿名用户', 'rag', '你想吃什么', '', '2026-04-21 14:04:00');
INSERT INTO `ai_chat_record` VALUES (31, 0, '匿名用户', 'rag', '你想吃什么', '我是一个智能电网运维专家，没有食欲。如果你有关于智能电网运维的问题，请告诉我，我会尽力帮助你。', '2026-04-21 14:07:26');
INSERT INTO `ai_chat_record` VALUES (32, 0, '匿名用户', 'basic', '你想吃什么', '我是一个智能电网运维专家，没有食欲。我可以帮助你解决与智能电网相关的问题，例如设备故障排查、系统优化建议或运行状态分析。请告诉我你的需求。', '2026-04-21 14:08:04');
INSERT INTO `ai_chat_record` VALUES (33, 0, '匿名用户', 'basic', '220v更nb还是250v更nb', '220V和250V都是常见的电压等级，它们的“nb”（强大、优秀）取决于具体应用场景。220V是大多数国家的标准家庭用电电压，适用性广；250V通常用于特定工业或高功率设备，能承载更大负载。选择时需根据设备需求和电路设计决定，错误使用可能导致设备损坏或安全隐患。', '2026-04-21 14:09:09');

-- ----------------------------
-- Table structure for ai_maintenance_form
-- ----------------------------
DROP TABLE IF EXISTS `ai_maintenance_form`;
CREATE TABLE `ai_maintenance_form`  (
  `form_id` bigint NOT NULL AUTO_INCREMENT COMMENT '表单ID',
  `device_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '设备ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI生成的运维操作表单' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_maintenance_form
-- ----------------------------
INSERT INTO `ai_maintenance_form` VALUES (4,'37464ae6-85a6-5ce3-9add-965f746ec79a','配电柜1号','告警：电流波动异常','预测性','高',30,'[\"万用表\",\"螺丝刀套装\",\"绝缘手套\",\"安全帽\"]','1. 操作前必须切断电源，确保设备完全断电；\n2. 佩戴个人防护用品（安全帽、绝缘手套、防护眼镜）；\n3. 使用绝缘工具，避免直接接触带电部件；\n4. 操作时应有专人监护，确保安全；\n5. 操作完成后检查设备接地是否良好；\n6. 如遇异常情况立即停止操作，上报处理。','[{\"description\":\"检查工具是否齐全，确认安全措施已到位，切断设备电源\",\"step\":\"1\",\"title\":\"准备工作\"},{\"description\":\"检查设备外观，查看是否有明显损坏或异常现象\",\"step\":\"2\",\"title\":\"设备检查\"},{\"description\":\"恢复设备供电，进行功能测试，确认设备运行正常\",\"step\":\"3\",\"title\":\"测试验证\"},{\"description\":\"清理工作现场，整理工具，填写维护记录\",\"step\":\"4\",\"title\":\"清理收尾\"}]','1. 设备故障得到解决，恢复正常运行状态；\n2. 设备各项参数指标恢复正常范围；\n3. 设备安全性能符合要求；\n4. 维护记录完整，可追溯。','draft','AI系统','2026-01-22 18:32:56',NULL,'2026-01-22 18:32:56',NULL);
INSERT INTO `ai_maintenance_form` VALUES (5,'7beaf415-6c5b-5e16-abd7-04c21500858d','主变压器1号','告警：电流波动异常；告警：电流波动异常；告警：温度超过警告阈值','预测性','高',30,'[\"万用表\",\"螺丝刀套装\",\"绝缘手套\",\"安全帽\"]','1. 操作前必须切断电源，确保设备完全断电；\n2. 佩戴个人防护用品（安全帽、绝缘手套、防护眼镜）；\n3. 使用绝缘工具，避免直接接触带电部件；\n4. 操作时应有专人监护，确保安全；\n5. 操作完成后检查设备接地是否良好；\n6. 如遇异常情况立即停止操作，上报处理。','[{\"description\":\"检查工具是否齐全，确认安全措施已到位，切断设备电源\",\"step\":\"1\",\"title\":\"准备工作\"},{\"description\":\"检查设备外观，查看是否有明显损坏或异常现象\",\"step\":\"2\",\"title\":\"设备检查\"},{\"description\":\"恢复设备供电，进行功能测试，确认设备运行正常\",\"step\":\"3\",\"title\":\"测试验证\"},{\"description\":\"清理工作现场，整理工具，填写维护记录\",\"step\":\"4\",\"title\":\"清理收尾\"}]','1. 设备故障得到解决，恢复正常运行状态；\n2. 设备各项参数指标恢复正常范围；\n3. 设备安全性能符合要求；\n4. 维护记录完整，可追溯。','draft','AI系统','2026-01-26 22:04:18',NULL,'2026-01-26 22:04:18',NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 735 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '聊天消息表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '部门信息表' ROW_FORMAT = DYNAMIC;

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
  `device_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备ID',
  `rule_id` bigint NULL DEFAULT NULL COMMENT '规则ID',
  `alert_level` tinyint NULL DEFAULT NULL COMMENT '告警级别 1-警告 2-严重 3-紧急',
  `alert_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '告警类型',
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
) ENGINE = InnoDB AUTO_INCREMENT = 73 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '告警记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eq_alert_record
-- ----------------------------
INSERT INTO `eq_alert_record` VALUES (1,'7beaf415-6c5b-5e16-abd7-04c21500858d',NULL,3,NULL,'电流波动异常','2026-01-11 23:01:33','2026-01-11 19:01:33',2,0,'已检查并确认，恢复正常','常规告警','2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (2,'7beaf415-6c5b-5e16-abd7-04c21500858d',NULL,3,NULL,'温度超过警告阈值','2026-01-11 00:01:33','2026-01-11 18:01:33',2,0,'已检查并确认，恢复正常','常规告警','2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (3,'7beaf415-6c5b-5e16-abd7-04c21500858d',NULL,1,NULL,'电流波动异常','2026-01-11 16:01:33',NULL,2,0,'已检查并确认，恢复正常','常规告警','2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (7,'37464ae6-85a6-5ce3-9add-965f746ec79a',NULL,1,NULL,'电流波动异常','2026-01-11 15:01:33','2026-01-11 06:01:33',2,0,'已检查并确认，恢复正常','常规告警','2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (8,'37464ae6-85a6-5ce3-9add-965f746ec79a',NULL,1,NULL,'负载过高','2026-01-11 12:01:33','2026-01-11 06:01:33',2,0,'已检查并确认，恢复正常','常规告警','2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (9,'37464ae6-85a6-5ce3-9add-965f746ec79a',NULL,3,NULL,'电压不稳定','2026-01-09 18:01:33','2026-01-11 04:01:33',2,0,'已检查并确认，恢复正常','常规告警','2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (19,'57330e93-592e-5318-b0c2-6d3ff8846bb6',NULL,2,NULL,'电流波动异常','2026-01-09 22:01:33','2026-01-11 09:01:33',2,0,'已检查并确认，恢复正常','常规告警','2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (20,'57330e93-592e-5318-b0c2-6d3ff8846bb6',NULL,3,NULL,'电流波动异常','2026-01-09 07:01:33','2026-01-11 22:01:33',1,0,'已检查并确认，恢复正常','常规告警','2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (21,'57330e93-592e-5318-b0c2-6d3ff8846bb6',NULL,2,NULL,'负载过高','2026-01-09 10:01:33','2026-01-11 20:01:33',1,0,'已检查并确认，恢复正常','常规告警','2026-01-12 00:01:33');
INSERT INTO `eq_alert_record` VALUES (61,'7beaf415-6c5b-5e16-abd7-04c21500858d',63,2,NULL,'规则[电压异常规则]触发：参数[voltage]当前值 112 kV，条件类型=区间外，阈值 110','2026-03-27 08:33:36',NULL,1,NULL,NULL,'规则引擎','2026-03-27 08:33:35');
INSERT INTO `eq_alert_record` VALUES (62,'7beaf415-6c5b-5e16-abd7-04c21500858d',1,2,NULL,'规则[温度超限规则]触发：参数[temperature]当前值 188 ℃，条件类型=大于，阈值 85','2026-03-27 08:33:36',NULL,1,NULL,NULL,'规则引擎','2026-03-27 08:33:35');
INSERT INTO `eq_alert_record` VALUES (64,'57330e93-592e-5318-b0c2-6d3ff8846bb6',69,2,NULL,'规则[电压异常规则]触发：参数[voltage]当前值 111.7 kV，条件类型=区间外，阈值 110','2026-03-29 15:36:46',NULL,1,NULL,NULL,'规则引擎','2026-03-29 15:36:46');

-- ----------------------------
-- Table structure for eq_climate_data
-- ----------------------------
DROP TABLE IF EXISTS `eq_climate_data`;
CREATE TABLE `eq_climate_data`  (
  `climate_id` bigint NOT NULL AUTO_INCREMENT COMMENT '气候数据ID',
  `device_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '气候数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eq_climate_data
-- ----------------------------
INSERT INTO `eq_climate_data` VALUES (1,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-11 23:01:40',4,'晴天',2.80,8.10,'西南风',0,6,17,1,3,47,154,1,0.40,'2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (2,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-10 06:01:40',2,'多云',2.90,17.30,'南风',0,7,6,1,1,36,176,3,8.90,'2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (3,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-11 18:01:40',2,'阴天',9.50,16.80,'西风',1,3,-11,1,0,11,137,5,10.60,'2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (7,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-10 12:01:40',3,'阴天',10.80,3.50,'西南风',1,11,26,0,4,35,151,5,7.50,'2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (8,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-10 15:01:40',3,'小雨',12.30,16.60,'西风',0,22,15,1,4,25,162,4,2.20,'2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (9,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-10 17:01:40',3,'小雨',16.10,4.90,'南风',1,14,4,1,0,8,98,4,6.70,'2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (19,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-11 17:01:40',2,'晴天',9.00,5.20,'南风',0,22,19,0,4,33,42,2,6.40,'2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (20,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-10 21:01:40',2,'阴天',8.70,0.10,'西北风',1,8,-10,0,3,43,140,5,4.50,'2026-01-12 00:01:40');
INSERT INTO `eq_climate_data` VALUES (21,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-11 19:01:40',2,'晴天',0.70,19.60,'东南风',0,7,1,0,2,5,32,5,1.40,'2026-01-12 00:01:40');

-- ----------------------------
-- Table structure for eq_device
-- ----------------------------
DROP TABLE IF EXISTS `eq_device`;
CREATE TABLE `eq_device`  (
  `device_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备ID',
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '设备信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eq_device
-- ----------------------------
INSERT INTO `eq_device` VALUES ('7beaf415-6c5b-5e16-abd7-04c21500858d','DEV-001','主变压器1号','变压器','SFZ10-31500/110','BYQ-20210001','华为技术有限公司','主厂房A区1层','运维部','2021-01-15 00:00:00','2031-01-15 00:00:00',1,1500000.00,20,'张工','主要供电设备','admin','2026-01-12 00:01:08','admin','2026-02-18 14:28:53');
INSERT INTO `eq_device` VALUES ('37464ae6-85a6-5ce3-9add-965f746ec79a','DEV-003','配电柜1号','配电柜','GGD-3200A','PDG-20210101','施耐德电气','配电室A区','运维部','2021-03-10 00:00:00','2031-03-10 00:00:00',1,80000.00,15,'李工','主配电设备','admin','2026-01-12 00:01:08','','2026-01-12 00:01:08');
INSERT INTO `eq_device` VALUES ('57330e93-592e-5318-b0c2-6d3ff8846bb6','DEV-007','发电机1号','发电机','FDJ-5000KW','FDJ-20210301','西门子','发电机房A区','运维部','2021-05-01 00:00:00','2031-05-01 00:00:00',1,2500000.00,25,'赵工','主发电设备','admin','2026-01-12 00:01:08','','2026-01-12 00:01:08');

-- ----------------------------
-- Table structure for eq_device_param
-- ----------------------------
DROP TABLE IF EXISTS `eq_device_param`;
CREATE TABLE `eq_device_param`  (
  `param_id` bigint NOT NULL AUTO_INCREMENT COMMENT '参数ID',
  `device_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 145 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '设备参数表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eq_device_param
-- ----------------------------
INSERT INTO `eq_device_param` VALUES (1,'7beaf415-6c5b-5e16-abd7-04c21500858d','额定电压',110.0000,'kV',110.0000,105.0000,115.0000,118.0000,116.0000,'2026-01-12 00:01:12','设备额定电压','','2026-01-12 00:01:12','','2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (3,'37464ae6-85a6-5ce3-9add-965f746ec79a','额定电压',110.0000,'kV',110.0000,105.0000,115.0000,118.0000,116.0000,'2026-01-12 00:01:12','设备额定电压','','2026-01-12 00:01:12','','2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (7,'57330e93-592e-5318-b0c2-6d3ff8846bb6','额定电压',110.0000,'kV',110.0000,105.0000,115.0000,118.0000,116.0000,'2026-01-12 00:01:12','设备额定电压','','2026-01-12 00:01:12','','2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (32,'7beaf415-6c5b-5e16-abd7-04c21500858d','额定电流',165.0000,'A',165.0000,0.0000,200.0000,195.0000,185.0000,'2026-01-12 00:01:12','设备额定电流','','2026-01-12 00:01:12','','2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (34,'37464ae6-85a6-5ce3-9add-965f746ec79a','额定电流',165.0000,'A',165.0000,0.0000,200.0000,195.0000,185.0000,'2026-01-12 00:01:12','设备额定电流','','2026-01-12 00:01:12','','2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (38,'57330e93-592e-5318-b0c2-6d3ff8846bb6','额定电流',165.0000,'A',165.0000,0.0000,200.0000,195.0000,185.0000,'2026-01-12 00:01:12','设备额定电流','','2026-01-12 00:01:12','','2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (63,'7beaf415-6c5b-5e16-abd7-04c21500858d','额定功率',18.0000,'MW',18.0000,0.0000,25.0000,24.0000,22.0000,'2026-01-12 00:01:12','设备额定功率','','2026-01-12 00:01:12','','2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (65,'37464ae6-85a6-5ce3-9add-965f746ec79a','额定功率',18.0000,'MW',18.0000,0.0000,25.0000,24.0000,22.0000,'2026-01-12 00:01:12','设备额定功率','','2026-01-12 00:01:12','','2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (69,'57330e93-592e-5318-b0c2-6d3ff8846bb6','额定功率',18.0000,'MW',18.0000,0.0000,25.0000,24.0000,22.0000,'2026-01-12 00:01:12','设备额定功率','','2026-01-12 00:01:12','','2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (94,'7beaf415-6c5b-5e16-abd7-04c21500858d','工作温度',65.0000,'℃',65.0000,-10.0000,85.0000,90.0000,80.0000,'2026-01-12 00:01:12','设备工作温度','','2026-01-12 00:01:12','','2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (96,'37464ae6-85a6-5ce3-9add-965f746ec79a','工作温度',65.0000,'℃',65.0000,-10.0000,85.0000,90.0000,80.0000,'2026-01-12 00:01:12','设备工作温度','','2026-01-12 00:01:12','','2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (100,'57330e93-592e-5318-b0c2-6d3ff8846bb6','工作温度',65.0000,'℃',65.0000,-10.0000,85.0000,90.0000,80.0000,'2026-01-12 00:01:12','设备工作温度','','2026-01-12 00:01:12','','2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (125,'7beaf415-6c5b-5e16-abd7-04c21500858d','绝缘电阻',1000.0000,'MΩ',1000.0000,500.0000,5000.0000,400.0000,500.0000,'2026-01-12 00:01:12','绝缘电阻值','','2026-01-12 00:01:12','','2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (127,'37464ae6-85a6-5ce3-9add-965f746ec79a','绝缘电阻',1000.0000,'MΩ',1000.0000,500.0000,5000.0000,400.0000,500.0000,'2026-01-12 00:01:12','绝缘电阻值','','2026-01-12 00:01:12','','2026-01-12 00:01:12');
INSERT INTO `eq_device_param` VALUES (131,'57330e93-592e-5318-b0c2-6d3ff8846bb6','绝缘电阻',1000.0000,'MΩ',1000.0000,500.0000,5000.0000,400.0000,500.0000,'2026-01-12 00:01:12','绝缘电阻值','','2026-01-12 00:01:12','','2026-01-12 00:01:12');

-- ----------------------------
-- Table structure for eq_device_rule
-- ----------------------------
DROP TABLE IF EXISTS `eq_device_rule`;
CREATE TABLE `eq_device_rule`  (
  `rule_id` bigint NOT NULL AUTO_INCREMENT COMMENT '规则ID',
  `device_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '设备ID',
  `rule_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '规则名称',
  `parameter_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '参数名称',
  `condition_type` int NULL DEFAULT NULL COMMENT '条件类型1大于 2小于 3等于 4区间',
  `threshold_value` decimal(18, 2) NULL DEFAULT NULL COMMENT '阈值',
  `threshold_unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '阈值单位',
  `alert_level` int NULL DEFAULT NULL COMMENT '报警等级 1警报 2严重 3紧急',
  `enabled` int NULL DEFAULT NULL COMMENT '是否启用 1启用 0禁用',
  `notification_channels` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '通知渠道（前端/WebSocket 推送填 websocket）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`rule_id`) USING BTREE,
  INDEX `idx_device_id`(`device_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 83 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '设备规则表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eq_device_rule
-- ----------------------------
INSERT INTO `eq_device_rule` VALUES (1,'7beaf415-6c5b-5e16-abd7-04c21500858d','温度超限规则','温度',1,85.00,'℃',2,1,'websocket',NULL);
INSERT INTO `eq_device_rule` VALUES (3,'37464ae6-85a6-5ce3-9add-965f746ec79a','温度超限规则','温度',1,85.00,'℃',2,1,'websocket',NULL);
INSERT INTO `eq_device_rule` VALUES (7,'57330e93-592e-5318-b0c2-6d3ff8846bb6','温度超限规则','温度',1,85.00,'℃',2,1,'websocket',NULL);
INSERT INTO `eq_device_rule` VALUES (32,'7beaf415-6c5b-5e16-abd7-04c21500858d','电流过载规则','电流',1,200.00,'A',3,1,'websocket',NULL);
INSERT INTO `eq_device_rule` VALUES (34,'37464ae6-85a6-5ce3-9add-965f746ec79a','电流过载规则','电流',1,200.00,'A',3,1,'websocket',NULL);
INSERT INTO `eq_device_rule` VALUES (38,'57330e93-592e-5318-b0c2-6d3ff8846bb6','电流过载规则','电流',1,200.00,'A',3,1,'websocket',NULL);
INSERT INTO `eq_device_rule` VALUES (63,'7beaf415-6c5b-5e16-abd7-04c21500858d','电压异常规则','电压',4,110.00,'kV',2,1,'websocket',NULL);
INSERT INTO `eq_device_rule` VALUES (65,'37464ae6-85a6-5ce3-9add-965f746ec79a','电压异常规则','电压',4,110.00,'kV',2,1,'websocket',NULL);
INSERT INTO `eq_device_rule` VALUES (69,'57330e93-592e-5318-b0c2-6d3ff8846bb6','电压异常规则','电压',4,110.00,'kV',2,1,'websocket',NULL);

-- ----------------------------
-- Table structure for eq_device_stat
-- ----------------------------
DROP TABLE IF EXISTS `eq_device_stat`;
CREATE TABLE `eq_device_stat`  (
  `stat_id` bigint NOT NULL AUTO_INCREMENT COMMENT '统计ID',
  `device_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 151 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '设备统计表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eq_device_stat
-- ----------------------------
INSERT INTO `eq_device_stat` VALUES (1,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-06',20.40,2,0,67.50,81.50,53.30,17.8000,98.00,80,737.83,0.0059,NULL,'2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (2,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-07',22.40,0,0,70.20,79.20,50.10,16.9000,95.60,118,1559.42,0.0068,NULL,'2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (3,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-08',23.20,0,1,60.60,75.60,57.30,19.3000,97.00,103,2167.06,0.0058,NULL,'2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (4,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-09',21.50,0,1,62.60,79.90,57.60,21.6000,98.40,92,1142.14,0.0028,NULL,'2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (5,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-10',21.80,1,1,70.70,82.60,50.60,21.4000,98.30,81,2399.56,0.0071,NULL,'2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (6,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-11',22.80,1,1,61.00,77.30,52.40,21.0000,95.10,98,608.81,0.0082,NULL,'2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (7,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-12',23.70,0,1,64.00,78.00,58.60,20.5000,98.40,20,1174.30,0.0016,NULL,'2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (15,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-06',22.60,1,0,71.90,74.50,51.10,20.3000,99.00,117,2317.04,0.0061,NULL,'2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (16,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-07',21.20,2,1,72.50,76.20,55.60,19.4000,95.20,76,529.30,0.0017,NULL,'2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (17,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-08',23.20,1,0,68.50,82.70,55.10,15.2000,97.50,119,756.54,0.0065,NULL,'2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (18,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-09',23.50,1,0,61.40,70.80,59.80,21.1000,98.40,115,1005.09,0.0039,NULL,'2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (19,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-10',20.70,2,1,73.10,75.50,52.30,15.5000,97.30,90,539.42,0.0083,NULL,'2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (20,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-11',20.40,0,1,64.80,83.80,56.50,18.8000,96.70,86,1105.66,0.0036,NULL,'2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (21,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-12',23.60,1,0,62.10,73.30,56.80,20.9000,97.60,9,1311.10,0.0080,NULL,'2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (43,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-06',21.60,1,0,62.80,83.00,57.80,17.4000,95.60,97,1759.71,0.0072,NULL,'2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (44,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-07',22.90,1,1,63.70,78.20,50.10,18.2000,98.90,83,1575.41,0.0060,NULL,'2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (45,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-08',21.60,0,1,68.50,70.10,53.20,19.8000,95.20,50,2418.26,0.0054,NULL,'2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (46,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-09',23.30,1,1,73.40,83.60,58.40,18.8000,98.50,113,717.98,0.0070,NULL,'2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (47,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-10',20.70,2,1,62.40,73.40,56.60,20.0000,95.50,92,1468.18,0.0010,NULL,'2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (48,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-11',20.20,2,1,74.70,73.40,52.00,17.5000,98.70,91,2497.11,0.0071,NULL,'2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (49,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-12',22.20,1,0,61.90,77.10,59.80,18.8000,96.80,102,2301.63,0.0094,NULL,'2026-01-12 00:01:33');
INSERT INTO `eq_device_stat` VALUES (146,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-03-29',50.00,NULL,NULL,NULL,NULL,NULL,4.8698,100.00,NULL,NULL,NULL,'WIND_FORECAST','2026-03-29 21:58:06');
-- ----------------------------
-- Table structure for eq_device_status
-- ----------------------------
DROP TABLE IF EXISTS `eq_device_status`;
CREATE TABLE `eq_device_status`  (
  `status_id` bigint NOT NULL AUTO_INCREMENT COMMENT '状态ID',
  `device_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '设备状态历史表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eq_device_status
-- ----------------------------
INSERT INTO `eq_device_status` VALUES (1,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-09 17:01:11',58.70,47.30,101.100,3.270000,180.2000,107.60,18.2000,1571.00,51.3000,76.60,1,26166.00,169,4,2,90.40,0.85,28.00,38.10,71.20,98.00,NULL,NULL,0,'运行正常','2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (2,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-11 23:01:11',188.00,44.50,102.300,1.430000,165.7000,112.00,16.7000,1440.00,60.6000,73.70,3,25708.00,181,1,11,95.90,0.93,24.80,54.90,73.80,95.00,NULL,NULL,1,'运行正常','2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (3,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-09 03:01:11',76.70,52.10,101.300,1.960000,158.7000,111.20,14.7000,1507.00,74.1000,84.00,1,24705.00,126,1,2,91.60,0.79,23.70,54.40,61.30,86.00,NULL,NULL,0,'运行正常','2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (4,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-07 23:01:11',75.50,53.30,102.600,2.070000,150.3000,112.50,18.4000,1563.00,88.1000,71.10,1,24688.00,161,4,6,95.80,0.92,24.50,52.70,64.50,89.00,NULL,NULL,0,'运行正常','2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (5,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-09 21:01:11',60.30,55.40,100.600,3.140000,197.3000,111.40,17.0000,1524.00,60.1000,64.10,1,18905.00,196,3,2,91.40,0.76,27.90,53.80,65.30,90.00,NULL,NULL,0,'运行正常','2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (11,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-08 11:01:11',64.80,56.70,103.000,2.390000,160.4000,109.20,19.3000,1540.00,96.5000,76.30,1,29213.00,84,2,9,97.40,0.74,22.30,49.60,63.20,92.00,NULL,NULL,0,'运行正常','2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (12,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-09 10:01:11',58.70,43.50,101.300,2.800000,183.6000,112.90,14.0000,1499.00,74.5000,88.50,1,21334.00,145,5,9,91.30,0.84,23.80,46.70,72.60,96.00,NULL,NULL,0,'运行正常','2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (13,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-10 16:01:11',56.50,49.40,100.500,2.500000,196.9000,108.70,17.8000,1431.00,82.9000,84.50,1,19242.00,88,0,11,96.60,0.75,25.40,47.80,68.50,90.00,NULL,NULL,0,'运行正常','2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (14,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-07 13:01:11',66.10,50.30,100.700,3.090000,184.1000,111.10,21.2000,1569.00,53.7000,84.80,1,29042.00,93,4,8,92.30,0.75,22.70,52.50,58.10,92.00,NULL,NULL,0,'运行正常','2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (15,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-10 01:01:11',68.00,48.40,101.600,2.320000,175.1000,111.20,16.6000,1499.00,85.0000,60.20,1,29153.00,155,2,11,95.00,0.78,27.40,45.50,61.20,93.00,NULL,NULL,0,'运行正常','2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (31,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-10 20:01:11',63.20,58.60,102.000,2.680000,187.5000,108.90,14.0000,1437.00,96.3000,62.20,1,25056.00,166,4,11,93.90,0.82,28.80,52.20,69.00,96.00,NULL,NULL,0,'运行正常','2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (32,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-08 08:01:11',66.50,42.00,100.300,1.840000,143.4000,110.10,14.4000,1570.00,58.3000,68.00,1,27955.00,122,1,3,95.40,0.82,24.90,44.20,70.80,94.00,NULL,NULL,0,'运行正常','2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (33,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-11 20:01:11',60.00,58.00,102.700,3.490000,166.0000,111.70,14.6000,1461.00,66.6000,82.40,3,26876.00,134,0,11,93.70,0.83,23.20,42.20,71.30,87.00,NULL,NULL,1,'运行正常','2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (34,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-09 10:01:11',56.80,56.20,102.500,3.080000,199.4000,113.10,18.0000,1476.00,85.2000,71.40,1,27441.00,175,3,7,93.20,0.72,23.40,48.70,69.00,89.00,NULL,NULL,0,'运行正常','2026-01-12 00:01:11');
INSERT INTO `eq_device_status` VALUES (35,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-08 10:01:11',70.10,57.20,101.500,3.710000,141.3000,109.80,23.5000,1504.00,88.6000,68.90,1,19983.00,192,1,1,90.50,0.94,26.70,39.50,69.40,86.00,NULL,NULL,0,'运行正常','2026-01-12 00:01:11');

-- ----------------------------
-- Table structure for eq_economic_data
-- ----------------------------
DROP TABLE IF EXISTS `eq_economic_data`;
CREATE TABLE `eq_economic_data`  (
  `economic_id` bigint NOT NULL AUTO_INCREMENT COMMENT '经济数据ID',
  `device_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '经济数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eq_economic_data
-- ----------------------------
INSERT INTO `eq_economic_data` VALUES (1,'7beaf415-6c5b-5e16-abd7-04c21500858d','2025-11-14 00:01:36',1806.62,2541.1500,1597.48,733.78,1116.18,0.2420,47359.64,3.50,59069.62,47095.42,79.9000,93,1,'2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (2,'7beaf415-6c5b-5e16-abd7-04c21500858d','2025-11-26 00:01:36',5705.60,1319.4100,1923.19,375.21,223.66,0.2220,56585.23,2.30,94173.35,52989.28,90.9000,83,1,'2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (3,'7beaf415-6c5b-5e16-abd7-04c21500858d','2025-12-27 00:01:36',1056.47,1115.7400,996.40,499.29,852.75,0.1680,110508.33,5.40,98956.07,48331.03,94.8000,88,4,'2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (7,'37464ae6-85a6-5ce3-9add-965f746ec79a','2025-12-03 00:01:36',1884.11,2649.8000,1853.69,512.69,221.96,0.1330,96991.13,5.20,60513.23,59524.96,85.8000,88,2,'2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (8,'37464ae6-85a6-5ce3-9add-965f746ec79a','2025-12-11 00:01:36',4240.04,2089.5900,1052.75,514.66,836.12,0.1440,146831.67,6.30,85078.85,55356.41,87.0000,97,1,'2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (9,'37464ae6-85a6-5ce3-9add-965f746ec79a','2025-12-06 00:01:36',4855.80,2965.2700,1625.58,401.56,983.57,0.1710,80102.97,2.40,64992.68,54291.57,88.8000,89,2,'2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (19,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2025-12-18 00:01:36',3150.08,2712.8100,903.36,317.99,905.70,0.1580,64756.69,5.30,61186.06,60055.92,86.1000,89,3,'2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (20,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2025-12-12 00:01:36',5517.18,2851.7500,2189.79,415.10,939.77,0.1250,57272.87,6.70,78143.57,60980.92,87.9000,95,1,'2026-01-12 00:01:36');
INSERT INTO `eq_economic_data` VALUES (21,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2025-12-27 00:01:36',5718.52,2734.8600,1657.91,708.97,840.25,0.1930,88806.32,2.50,58231.76,65804.33,82.5000,84,3,'2026-01-12 00:01:36');

-- ----------------------------
-- Table structure for eq_electrical_data
-- ----------------------------
DROP TABLE IF EXISTS `eq_electrical_data`;
CREATE TABLE `eq_electrical_data`  (
  `electrical_id` bigint NOT NULL AUTO_INCREMENT COMMENT '电气数据ID',
  `device_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '电气数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eq_electrical_data
-- ----------------------------
INSERT INTO `eq_electrical_data` VALUES (1,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-11 10:40:52',109.95,108.17,111.01,0.7231,49.84,1.0997,170.2938,176.9818,184.0275,0.6128,491.9514,18.3629,2.4958,19.9765,0.8737,95.0638,'{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}','{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}',3.3150,1.1452,2.1436,30.4331,2.4293,92.5817,2,'2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (2,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-11 14:40:52',109.53,108.22,112.53,0.8537,50.11,1.6122,162.8312,161.6057,174.5347,0.5238,540.3973,22.9648,2.8056,19.8355,0.9460,95.6952,'{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}','{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}',4.8437,1.8618,2.9322,35.2196,1.2455,85.8073,1,'2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (3,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-11 16:40:52',107.48,112.52,112.16,0.6380,49.95,2.8911,174.9721,164.7609,153.8882,2.0106,525.8388,21.0324,3.8952,23.5157,0.8513,92.4242,'{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}','{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}',4.0418,1.1516,3.0114,39.1662,1.0603,85.2572,1,'2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (7,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-10 19:40:52',112.10,112.65,112.93,1.6290,50.01,0.6426,166.4378,178.2701,157.0374,0.3584,529.4899,19.5445,4.0868,22.0385,0.8375,92.2199,'{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}','{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}',4.7693,1.6989,4.9343,46.8419,1.0523,93.5455,1,'2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (8,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-10 17:40:52',113.69,112.63,108.10,0.7482,49.96,2.5899,150.6342,146.6250,181.2223,2.7491,466.7010,14.7736,4.7862,20.0861,0.8471,93.5595,'{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}','{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}',3.0554,1.1824,3.2014,44.5758,1.3851,85.2642,2,'2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (9,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-10 03:40:52',109.11,111.74,110.37,0.7586,49.98,0.3380,154.5843,177.7117,189.8057,2.3929,450.1099,19.5135,2.1792,20.6871,0.8450,90.4348,'{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}','{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}',4.5251,1.9563,4.5966,47.8644,2.2390,91.6795,2,'2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (19,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-11 15:40:52',111.27,110.12,109.78,1.3061,49.83,1.2052,180.6460,178.9969,163.0464,2.2161,499.0386,16.1226,4.1241,23.6618,0.8347,94.9909,'{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}','{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}',3.1313,2.5764,4.4293,43.6844,2.4836,94.0626,2,'2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (20,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-11 22:40:52',111.46,107.02,107.70,0.9892,49.87,1.1300,161.5202,176.7493,164.1863,0.0456,529.6845,22.4480,2.9084,22.5840,0.8998,96.1409,'{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}','{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}',2.9768,1.3713,4.8548,34.0183,0.7996,86.4635,1,'2026-01-12 00:40:52');
INSERT INTO `eq_electrical_data` VALUES (21,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-10 02:40:52',107.10,108.10,112.20,0.4858,50.19,0.5899,146.2586,169.7483,174.9655,2.0389,490.0385,22.6677,3.8426,18.4549,0.8380,95.8766,'{\"V3\": 2.5, \"V5\": 1.8, \"V7\": 1.2}','{\"I3\": 4.2, \"I5\": 3.1, \"I7\": 2.0}',4.2150,1.6575,3.2863,33.1522,1.5034,85.3567,2,'2026-01-12 00:40:52');

-- ----------------------------
-- Table structure for eq_environment_data
-- ----------------------------
DROP TABLE IF EXISTS `eq_environment_data`;
CREATE TABLE `eq_environment_data`  (
  `env_id` bigint NOT NULL AUTO_INCREMENT COMMENT '环境数据ID',
  `device_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '环境数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eq_environment_data
-- ----------------------------
INSERT INTO `eq_environment_data` VALUES (1,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-10 11:01:34',22.10,73.00,1.0800,83.00,57.10,41.30,16.20,11.5400,2.00,0.109000,0.125000,0.299000,50.60,2,2.2600,1,'2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (2,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-10 21:01:34',28.00,64.10,1.9000,75.40,52.70,43.30,13.90,7.2600,4.80,0.237000,1.431000,0.445000,54.70,1,4.7600,1,'2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (3,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-10 12:01:34',24.80,60.70,-1.3200,79.90,59.40,43.50,14.10,8.2000,1.80,1.681000,0.244000,0.175000,45.70,0,2.7800,1,'2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (7,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-11 12:01:34',22.00,62.50,-0.3200,79.90,51.70,46.90,15.00,7.6900,4.30,0.999000,1.823000,0.121000,50.70,3,3.7400,2,'2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (8,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-10 06:01:34',26.40,70.30,1.4600,81.50,56.60,45.40,17.00,10.0600,2.10,1.223000,1.558000,0.121000,54.70,3,3.0300,2,'2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (9,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-10 10:01:34',27.50,64.90,-0.7300,81.50,53.10,50.90,10.00,7.4800,1.20,0.883000,0.992000,0.311000,47.90,5,2.1500,1,'2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (19,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-11 13:01:34',20.10,65.30,0.5100,76.40,58.20,53.10,19.60,12.4000,4.10,1.801000,0.061000,0.901000,46.60,2,4.4000,2,'2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (20,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-10 14:01:34',27.20,67.40,1.9700,81.80,54.00,59.60,17.00,10.6700,3.60,1.895000,1.097000,1.798000,53.50,3,2.6800,1,'2026-01-12 00:01:34');
INSERT INTO `eq_environment_data` VALUES (21,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-10 17:01:34',29.20,71.40,-0.8900,80.60,59.80,42.70,11.20,14.8000,2.60,1.415000,1.898000,1.245000,47.70,2,3.5300,1,'2026-01-12 00:01:34');

-- ----------------------------
-- Table structure for eq_fault_record
-- ----------------------------
DROP TABLE IF EXISTS `eq_fault_record`;
CREATE TABLE `eq_fault_record`  (
  `fault_id` bigint NOT NULL AUTO_INCREMENT COMMENT '故障ID',
  `device_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '故障记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eq_fault_record
-- ----------------------------
INSERT INTO `eq_fault_record` VALUES (1,'7beaf415-6c5b-5e16-abd7-04c21500858d','F1888','温度过高报警',2,'2025-12-02 00:40:52','2025-12-26 00:40:52','故障已修复，设备恢复正常运行','操作不当',64,1125.90,'[\"接触器\"]',2,'故障已解决','admin','2026-01-12 00:40:52','','2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (2,'7beaf415-6c5b-5e16-abd7-04c21500858d','F3035','绝缘故障',2,'2025-11-29 00:40:52','2025-12-16 00:40:52','故障已修复，设备恢复正常运行','环境因素',112,2853.41,'[\"继电器\", \"保险丝\"]',2,'故障已解决','admin','2026-01-12 00:40:52','','2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (3,'7beaf415-6c5b-5e16-abd7-04c21500858d','F9101','机械磨损',1,'2025-11-22 00:40:52','2025-12-23 00:40:52','故障已修复，设备恢复正常运行','操作不当',134,1011.27,'[\"接触器\"]',2,'故障已解决','admin','2026-01-12 00:40:52','','2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (7,'37464ae6-85a6-5ce3-9add-965f746ec79a','F5447','电流过载',3,'2025-11-17 00:40:52','2025-12-25 00:40:52','故障已修复，设备恢复正常运行','环境因素',144,1977.53,'[\"继电器\", \"保险丝\"]',2,'故障已解决','admin','2026-01-12 00:40:52','','2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (8,'37464ae6-85a6-5ce3-9add-965f746ec79a','F5558','绝缘故障',1,'2025-10-31 00:40:52','2026-01-10 00:40:52','故障已修复，设备恢复正常运行','部件老化',114,3348.68,'[\"继电器\", \"保险丝\"]',2,'故障已解决','admin','2026-01-12 00:40:52','','2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (9,'37464ae6-85a6-5ce3-9add-965f746ec79a','F4381','机械磨损',3,'2025-12-06 00:40:52','2025-12-17 00:40:52','故障已修复，设备恢复正常运行','环境因素',66,2193.84,'[\"继电器\", \"保险丝\"]',2,'故障已解决','admin','2026-01-12 00:40:52','','2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (19,'57330e93-592e-5318-b0c2-6d3ff8846bb6','F3807','温度过高报警',2,'2025-10-16 00:40:52','2025-12-18 00:40:52','故障已修复，设备恢复正常运行','部件老化',117,3248.57,'[\"接触器\"]',2,'故障已解决','admin','2026-01-12 00:40:52','','2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (20,'57330e93-592e-5318-b0c2-6d3ff8846bb6','F2595','绝缘故障',1,'2025-11-18 00:40:52','2025-12-22 00:40:52','故障已修复，设备恢复正常运行','操作不当',106,779.55,'[\"继电器\", \"保险丝\"]',2,'故障已解决','admin','2026-01-12 00:40:52','','2026-01-12 00:40:52');
INSERT INTO `eq_fault_record` VALUES (21,'57330e93-592e-5318-b0c2-6d3ff8846bb6','F5719','机械磨损',1,'2025-10-26 00:40:52','2025-12-24 00:40:52','故障已修复，设备恢复正常运行','环境因素',141,1541.83,'[\"继电器\", \"保险丝\"]',2,'故障已解决','admin','2026-01-12 00:40:52','','2026-01-12 00:40:52');

-- ----------------------------
-- Table structure for eq_maintenance_record
-- ----------------------------
DROP TABLE IF EXISTS `eq_maintenance_record`;
CREATE TABLE `eq_maintenance_record`  (
  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `device_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '维护记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eq_maintenance_record
-- ----------------------------
INSERT INTO `eq_maintenance_record` VALUES (1,'7beaf415-6c5b-5e16-abd7-04c21500858d',1,'2025-12-27 00:40:52','2026-03-28 00:40:52',2003.29,'维护班组A','定期预防性维护检查','[\"滤芯\", \"密封圈\"]','设备运行正常，无异常',1,'维护完成','admin','2026-01-12 00:40:52','','2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (2,'7beaf415-6c5b-5e16-abd7-04c21500858d',1,'2025-10-16 00:40:52','2026-02-20 00:40:52',4283.64,'维护班组A','定期预防性维护检查','[\"滤芯\", \"密封圈\"]','设备运行正常，无异常',1,'维护完成','admin','2026-01-12 00:40:52','','2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (3,'7beaf415-6c5b-5e16-abd7-04c21500858d',1,'2025-11-15 00:40:52','2026-03-29 00:40:52',4602.38,'维护班组A','定期预防性维护检查','[\"滤芯\", \"密封圈\"]','设备运行正常，无异常',1,'维护完成','admin','2026-01-12 00:40:52','','2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (7,'37464ae6-85a6-5ce3-9add-965f746ec79a',1,'2025-12-06 00:40:52','2026-03-22 00:40:52',1052.35,'维护班组A','定期预防性维护检查','[\"滤芯\", \"密封圈\"]','设备运行正常，无异常',1,'维护完成','admin','2026-01-12 00:40:52','','2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (8,'37464ae6-85a6-5ce3-9add-965f746ec79a',1,'2026-01-03 00:40:52','2026-03-11 00:40:52',1279.60,'维护班组A','定期预防性维护检查','[\"滤芯\", \"密封圈\"]','设备运行正常，无异常',1,'维护完成','admin','2026-01-12 00:40:52','','2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (9,'37464ae6-85a6-5ce3-9add-965f746ec79a',1,'2025-10-22 00:40:52','2026-03-07 00:40:52',1954.12,'维护班组A','定期预防性维护检查','[\"滤芯\", \"密封圈\"]','设备运行正常，无异常',1,'维护完成','admin','2026-01-12 00:40:52','','2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (19,'57330e93-592e-5318-b0c2-6d3ff8846bb6',1,'2025-12-10 00:40:52','2026-04-09 00:40:52',3665.36,'维护班组A','定期预防性维护检查','[\"滤芯\", \"密封圈\"]','设备运行正常，无异常',1,'维护完成','admin','2026-01-12 00:40:52','','2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (20,'57330e93-592e-5318-b0c2-6d3ff8846bb6',1,'2025-12-02 00:40:52','2026-02-27 00:40:52',1154.28,'维护班组A','定期预防性维护检查','[\"滤芯\", \"密封圈\"]','设备运行正常，无异常',1,'维护完成','admin','2026-01-12 00:40:52','','2026-01-12 00:40:52');
INSERT INTO `eq_maintenance_record` VALUES (21,'57330e93-592e-5318-b0c2-6d3ff8846bb6',1,'2025-12-12 00:40:52','2026-03-20 00:40:52',1377.45,'维护班组A','定期预防性维护检查','[\"滤芯\", \"密封圈\"]','设备运行正常，无异常',1,'维护完成','admin','2026-01-12 00:40:52','','2026-01-12 00:40:52');

-- ----------------------------
-- Table structure for eq_mechanical_data
-- ----------------------------
DROP TABLE IF EXISTS `eq_mechanical_data`;
CREATE TABLE `eq_mechanical_data`  (
  `mechanical_id` bigint NOT NULL AUTO_INCREMENT COMMENT '机械数据ID',
  `device_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '机械数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eq_mechanical_data
-- ----------------------------
INSERT INTO `eq_mechanical_data` VALUES (1,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-11 15:40:52',7936.25,77.3890,93.3398,27907,5,3.100864,19.757655,2.369176,'{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}','垂直',0.270943,1.2850,1,127.8671,20.23,1.329560,205.6583,1,'2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (2,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-10 13:40:52',16494.95,79.8037,66.0613,53598,8,1.696738,5.053993,2.905021,'{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}','水平',0.356383,0.8692,4,159.5694,85.77,2.287412,155.0129,3,'2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (3,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-11 07:40:52',14746.57,63.3252,63.3050,16220,2,5.176217,12.181657,5.343296,'{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}','水平',0.384120,0.6832,2,108.4594,76.18,0.798192,194.1263,2,'2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (7,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-10 03:40:52',5512.30,77.2810,139.4415,38545,2,2.588908,11.058971,5.057373,'{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}','水平',0.260793,1.1796,1,178.3532,29.17,0.250234,154.6383,1,'2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (8,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-11 00:40:52',5827.32,55.5907,122.8853,42226,0,2.122586,13.149063,4.488945,'{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}','水平',0.584467,0.1252,2,120.9397,56.18,2.145179,238.8316,3,'2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (9,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-10 11:40:52',8201.26,88.1177,144.0529,53663,6,1.012960,6.594752,2.021900,'{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}','水平',0.158268,0.5319,2,157.1835,83.73,2.091965,226.8036,2,'2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (19,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-11 16:40:52',13126.86,66.4296,141.7587,40649,4,5.943711,17.256697,1.354312,'{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}','水平',0.198491,1.3701,3,59.6932,36.91,2.171666,213.4077,2,'2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (20,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-11 10:40:52',12970.97,86.3005,127.8911,21743,10,5.837824,4.085350,1.038800,'{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}','垂直',0.174423,2.2128,3,62.4216,91.91,0.423337,159.9896,1,'2026-01-12 00:40:52');
INSERT INTO `eq_mechanical_data` VALUES (21,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-10 20:40:52',10175.00,59.4698,95.4761,9066,7,1.440946,7.516667,2.392427,'{\"freq_10\": 0.5, \"freq_20\": 1.2, \"freq_50\": 2.8}','水平',0.017882,1.1246,1,114.7296,81.11,1.246896,164.4012,2,'2026-01-12 00:40:52');

-- ----------------------------
-- Table structure for eq_operational_data
-- ----------------------------
DROP TABLE IF EXISTS `eq_operational_data`;
CREATE TABLE `eq_operational_data`  (
  `operational_id` bigint NOT NULL AUTO_INCREMENT COMMENT '操作数据ID',
  `device_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '操作数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eq_operational_data
-- ----------------------------
INSERT INTO `eq_operational_data` VALUES (1,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-11 09:40:52',1018,'操作员8',4,95,1,28,1,'操作正常，无异常',4,74,692.92,'[\"滤芯\"]',89.5957,2,'2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (2,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-11 01:40:52',1070,'操作员16',3,71,4,61,1,'操作顺利完成',1,61,407.49,'[\"密封圈\", \"润滑油\"]',77.8571,4,'2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (3,'7beaf415-6c5b-5e16-abd7-04c21500858d','2026-01-10 21:40:52',1062,'操作员29',4,79,1,132,1,'操作顺利完成',3,59,958.24,'[\"密封圈\", \"润滑油\"]',89.9251,1,'2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (7,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-11 10:40:52',1009,'操作员25',4,97,5,27,1,'操作顺利完成',4,45,426.93,'[\"密封圈\", \"润滑油\"]',86.9112,2,'2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (8,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-09 18:40:52',1089,'操作员4',2,89,1,144,1,'操作顺利完成',3,32,876.11,'[\"滤芯\"]',78.8615,4,'2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (9,'37464ae6-85a6-5ce3-9add-965f746ec79a','2026-01-11 20:40:52',1053,'操作员14',3,95,3,79,2,'操作完成，有轻微警告',2,46,559.44,'[\"密封圈\", \"润滑油\"]',93.7944,3,'2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (19,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-11 14:40:52',1035,'操作员9',3,74,3,46,1,'操作顺利完成',1,49,628.10,'[\"密封圈\", \"润滑油\"]',76.6446,3,'2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (20,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-09 19:40:52',1094,'操作员14',3,87,5,71,1,'操作正常，无异常',4,23,945.78,'[\"滤芯\"]',81.2339,4,'2026-01-12 00:40:52');
INSERT INTO `eq_operational_data` VALUES (21,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-10 10:40:52',1099,'操作员10',3,71,3,54,1,'操作顺利完成',1,69,601.61,'[\"密封圈\", \"润滑油\"]',83.0136,3,'2026-01-12 00:40:52');

-- ----------------------------
-- Table structure for eq_prediction
-- ----------------------------
DROP TABLE IF EXISTS `eq_prediction`;
CREATE TABLE `eq_prediction`  (
  `prediction_id` bigint NOT NULL AUTO_INCREMENT COMMENT '预测ID',
  `device_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '预测结果表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eq_prediction
-- ----------------------------

-- ----------------------------
-- Table structure for eq_sensor
-- ----------------------------
DROP TABLE IF EXISTS `eq_sensor`;
CREATE TABLE `eq_sensor`  (
  `sensor_id` bigint NOT NULL AUTO_INCREMENT COMMENT '传感器ID',
  `device_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 114 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '传感器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eq_sensor
-- ----------------------------
INSERT INTO `eq_sensor` VALUES (1,'7beaf415-6c5b-5e16-abd7-04c21500858d','温度传感器','温度传感器-DEV-001','主厂房A区1层','℃','2025-12-13 00:01:12','2026-12-13 00:01:12',1,NULL,'','2026-01-12 00:01:12','','2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (3,'37464ae6-85a6-5ce3-9add-965f746ec79a','温度传感器','温度传感器-DEV-003','配电室A区','℃','2025-12-13 00:01:12','2026-12-13 00:01:12',1,NULL,'','2026-01-12 00:01:12','','2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (7,'57330e93-592e-5318-b0c2-6d3ff8846bb6','温度传感器','温度传感器-DEV-007','发电机房A区','℃','2025-12-13 00:01:12','2026-12-13 00:01:12',1,NULL,'','2026-01-12 00:01:12','','2026-01-12 00:01:12');
INSERT INTO `eq_sensor` VALUES (32,'7beaf415-6c5b-5e16-abd7-04c21500858d','湿度传感器','湿度传感器-DEV-001','主厂房A区1层','%','2025-11-28 00:01:13','2026-11-28 00:01:13',1,NULL,'','2026-01-12 00:01:13','','2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (34,'37464ae6-85a6-5ce3-9add-965f746ec79a','湿度传感器','湿度传感器-DEV-003','配电室A区','%','2025-11-28 00:01:13','2026-11-28 00:01:13',1,NULL,'','2026-01-12 00:01:13','','2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (38,'57330e93-592e-5318-b0c2-6d3ff8846bb6','湿度传感器','湿度传感器-DEV-007','发电机房A区','%','2025-11-28 00:01:13','2026-11-28 00:01:13',1,NULL,'','2026-01-12 00:01:13','','2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (63,'7beaf415-6c5b-5e16-abd7-04c21500858d','电流传感器','电流传感器-DEV-001','主厂房A区1层','A','2025-11-13 00:01:13','2026-11-13 00:01:13',1,NULL,'','2026-01-12 00:01:13','','2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (65,'37464ae6-85a6-5ce3-9add-965f746ec79a','电流传感器','电流传感器-DEV-003','配电室A区','A','2025-11-13 00:01:13','2026-11-13 00:01:13',1,NULL,'','2026-01-12 00:01:13','','2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (69,'57330e93-592e-5318-b0c2-6d3ff8846bb6','电流传感器','电流传感器-DEV-007','发电机房A区','A','2025-11-13 00:01:13','2026-11-13 00:01:13',1,NULL,'','2026-01-12 00:01:13','','2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (94,'7beaf415-6c5b-5e16-abd7-04c21500858d','电压传感器','电压传感器-DEV-001','主厂房A区1层','kV','2025-12-23 00:01:13','2026-12-23 00:01:13',1,NULL,'','2026-01-12 00:01:13','','2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (96,'37464ae6-85a6-5ce3-9add-965f746ec79a','电压传感器','电压传感器-DEV-003','配电室A区','kV','2025-12-23 00:01:13','2026-12-23 00:01:13',1,NULL,'','2026-01-12 00:01:13','','2026-01-12 00:01:13');
INSERT INTO `eq_sensor` VALUES (100,'57330e93-592e-5318-b0c2-6d3ff8846bb6','电压传感器','电压传感器-DEV-007','发电机房A区','kV','2025-12-23 00:01:13','2026-12-23 00:01:13',1,NULL,'','2026-01-12 00:01:13','','2026-01-12 00:01:13');

-- ----------------------------
-- Table structure for eq_technology_data
-- ----------------------------
DROP TABLE IF EXISTS `eq_technology_data`;
CREATE TABLE `eq_technology_data`  (
  `tech_id` bigint NOT NULL AUTO_INCREMENT COMMENT '技术数据ID',
  `device_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备ID',
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
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '技术数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of eq_technology_data
-- ----------------------------
INSERT INTO `eq_technology_data` VALUES (1,'7beaf415-6c5b-5e16-abd7-04c21500858d','2025-10-16 00:40:52',3,3,'{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}',3,'V2.3.8','FW2.2.7',6,2,2,2,3,'2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (2,'7beaf415-6c5b-5e16-abd7-04c21500858d','2025-11-30 00:40:52',2,3,'{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}',3,'V2.9.3','FW2.4.8',14,4,2,4,4,'2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (3,'7beaf415-6c5b-5e16-abd7-04c21500858d','2025-10-21 00:40:52',4,1,'{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}',1,'V1.9.9','FW1.2.3',7,4,2,4,1,'2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (7,'37464ae6-85a6-5ce3-9add-965f746ec79a','2025-12-31 00:40:52',3,2,'{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}',1,'V2.4.16','FW2.3.0',6,2,3,4,4,'2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (8,'37464ae6-85a6-5ce3-9add-965f746ec79a','2025-11-23 00:40:52',4,2,'{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}',1,'V2.4.0','FW2.4.9',10,3,2,4,1,'2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (9,'37464ae6-85a6-5ce3-9add-965f746ec79a','2025-12-19 00:40:52',2,3,'{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}',1,'V3.4.19','FW2.2.4',12,4,2,4,3,'2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (19,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2026-01-12 00:40:52',4,2,'{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}',3,'V2.0.5','FW1.0.9',13,3,3,4,2,'2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (20,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2025-12-27 00:40:52',4,1,'{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}',1,'V2.4.17','FW1.3.9',24,4,3,3,3,'2026-01-12 00:40:52');
INSERT INTO `eq_technology_data` VALUES (21,'57330e93-592e-5318-b0c2-6d3ff8846bb6','2025-11-25 00:40:52',4,3,'{\"IEC 61850\": \"符合\", \"IEEE 1547\": \"部分符合\", \"GB/T 19001-2016\": \"符合\"}',1,'V2.8.10','FW1.4.5',9,3,2,3,4,'2026-01-12 00:40:52');

-- ----------------------------
-- Table structure for eq_wind_forecast_bind
-- ----------------------------
DROP TABLE IF EXISTS `eq_wind_forecast_bind`;
CREATE TABLE `eq_wind_forecast_bind`  (
  `device_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备ID',
  `model_path` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'GRU 模型 .h5 绝对路径',
  `feature_excel_path` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '特征 Excel 绝对路径',
  `real_excel_path` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '实测功率 Excel 绝对路径',
  `inline_data_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '页面编辑的风速+功率序列 JSON',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`device_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '风力预测设备数据绑定' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eq_wind_forecast_bind
-- ----------------------------
INSERT INTO `eq_wind_forecast_bind` VALUES ('57330e93-592e-5318-b0c2-6d3ff8846bb6',NULL,NULL,NULL,'','2026-03-29 17:02:21');

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
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '代码生成业务表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 154 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '日历信息表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '已触发的触发器表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '任务详细信息表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '暂停的触发器表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '调度器状态表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '触发器详细信息表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '参数配置表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '定时任务调度表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2025-10-31 15:23:03', '', NULL, '');
INSERT INTO `sys_job` VALUES (100, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '0 0/5 * * * ?', '1', '1', '0', 'admin', '2026-03-13 21:17:37', '', '2026-03-13 21:17:46', '聚合需维护设备并同步站内消息；扫描 draft/pending 运维表单。Redis 可选（表单推送去重）。');
INSERT INTO `sys_job` VALUES (101, '运维表单待处理消息推送', 'DEFAULT', 'maintenanceFormNotifyTask.scanPendingFormsAndNotify', '0 0/10 * * * ?', '1', '1', '1', 'admin', '2026-05-09 10:00:00', '', NULL, '可选：单独扫描表单；默认暂停(status=1)。若「检查报警」已涵盖可在监控中心启用本任务或保持暂停。');

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
) ENGINE = InnoDB AUTO_INCREMENT = 1176 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `sys_job_log` VALUES (227, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-26 22:02:00');
INSERT INTO `sys_job_log` VALUES (228, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-26 22:03:00');
INSERT INTO `sys_job_log` VALUES (229, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：11毫秒', '0', '', '2026-03-26 22:08:00');
INSERT INTO `sys_job_log` VALUES (230, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-26 22:09:00');
INSERT INTO `sys_job_log` VALUES (231, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-26 22:10:00');
INSERT INTO `sys_job_log` VALUES (232, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-26 22:11:00');
INSERT INTO `sys_job_log` VALUES (233, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-26 22:12:00');
INSERT INTO `sys_job_log` VALUES (234, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-26 22:13:00');
INSERT INTO `sys_job_log` VALUES (235, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-26 22:14:00');
INSERT INTO `sys_job_log` VALUES (236, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-26 22:15:00');
INSERT INTO `sys_job_log` VALUES (237, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-26 22:16:00');
INSERT INTO `sys_job_log` VALUES (238, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-26 22:17:00');
INSERT INTO `sys_job_log` VALUES (239, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-26 22:18:00');
INSERT INTO `sys_job_log` VALUES (240, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-26 22:19:00');
INSERT INTO `sys_job_log` VALUES (241, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-26 22:20:00');
INSERT INTO `sys_job_log` VALUES (242, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：17毫秒', '0', '', '2026-03-26 22:26:00');
INSERT INTO `sys_job_log` VALUES (243, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-26 22:27:00');
INSERT INTO `sys_job_log` VALUES (244, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-26 22:28:00');
INSERT INTO `sys_job_log` VALUES (245, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-26 22:29:00');
INSERT INTO `sys_job_log` VALUES (246, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-26 22:30:00');
INSERT INTO `sys_job_log` VALUES (247, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-26 22:31:00');
INSERT INTO `sys_job_log` VALUES (248, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-26 22:32:00');
INSERT INTO `sys_job_log` VALUES (249, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-26 22:33:00');
INSERT INTO `sys_job_log` VALUES (250, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-26 22:34:00');
INSERT INTO `sys_job_log` VALUES (251, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-26 22:35:00');
INSERT INTO `sys_job_log` VALUES (252, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-26 22:36:00');
INSERT INTO `sys_job_log` VALUES (253, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-26 22:37:00');
INSERT INTO `sys_job_log` VALUES (254, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：92毫秒', '0', '', '2026-03-27 00:07:00');
INSERT INTO `sys_job_log` VALUES (255, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 00:08:00');
INSERT INTO `sys_job_log` VALUES (256, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 00:09:00');
INSERT INTO `sys_job_log` VALUES (257, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 00:10:00');
INSERT INTO `sys_job_log` VALUES (258, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 00:11:00');
INSERT INTO `sys_job_log` VALUES (259, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 00:12:00');
INSERT INTO `sys_job_log` VALUES (260, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 00:13:00');
INSERT INTO `sys_job_log` VALUES (261, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 00:14:00');
INSERT INTO `sys_job_log` VALUES (262, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 00:15:00');
INSERT INTO `sys_job_log` VALUES (263, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-27 00:16:00');
INSERT INTO `sys_job_log` VALUES (264, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 00:17:00');
INSERT INTO `sys_job_log` VALUES (265, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 00:18:00');
INSERT INTO `sys_job_log` VALUES (266, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 00:19:00');
INSERT INTO `sys_job_log` VALUES (267, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 00:20:00');
INSERT INTO `sys_job_log` VALUES (268, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 00:21:00');
INSERT INTO `sys_job_log` VALUES (269, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 00:22:00');
INSERT INTO `sys_job_log` VALUES (270, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 00:23:00');
INSERT INTO `sys_job_log` VALUES (271, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 00:24:00');
INSERT INTO `sys_job_log` VALUES (272, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 00:25:00');
INSERT INTO `sys_job_log` VALUES (273, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 00:26:00');
INSERT INTO `sys_job_log` VALUES (274, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 00:27:00');
INSERT INTO `sys_job_log` VALUES (275, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 00:28:00');
INSERT INTO `sys_job_log` VALUES (276, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 00:29:00');
INSERT INTO `sys_job_log` VALUES (277, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 00:30:00');
INSERT INTO `sys_job_log` VALUES (278, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 00:31:00');
INSERT INTO `sys_job_log` VALUES (279, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 00:32:00');
INSERT INTO `sys_job_log` VALUES (280, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 00:33:00');
INSERT INTO `sys_job_log` VALUES (281, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 00:34:00');
INSERT INTO `sys_job_log` VALUES (282, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 00:35:00');
INSERT INTO `sys_job_log` VALUES (283, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 00:36:00');
INSERT INTO `sys_job_log` VALUES (284, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 00:37:00');
INSERT INTO `sys_job_log` VALUES (285, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 00:38:00');
INSERT INTO `sys_job_log` VALUES (286, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 00:39:00');
INSERT INTO `sys_job_log` VALUES (287, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 00:40:00');
INSERT INTO `sys_job_log` VALUES (288, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 08:14:00');
INSERT INTO `sys_job_log` VALUES (289, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 08:15:00');
INSERT INTO `sys_job_log` VALUES (290, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 08:16:00');
INSERT INTO `sys_job_log` VALUES (291, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-27 08:17:00');
INSERT INTO `sys_job_log` VALUES (292, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：10毫秒', '0', '', '2026-03-27 08:18:00');
INSERT INTO `sys_job_log` VALUES (293, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 08:19:00');
INSERT INTO `sys_job_log` VALUES (294, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 08:20:00');
INSERT INTO `sys_job_log` VALUES (295, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 08:21:00');
INSERT INTO `sys_job_log` VALUES (296, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 08:22:00');
INSERT INTO `sys_job_log` VALUES (297, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 08:23:00');
INSERT INTO `sys_job_log` VALUES (298, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 08:24:00');
INSERT INTO `sys_job_log` VALUES (299, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 08:25:00');
INSERT INTO `sys_job_log` VALUES (300, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 08:26:00');
INSERT INTO `sys_job_log` VALUES (301, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 08:27:00');
INSERT INTO `sys_job_log` VALUES (302, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：47毫秒', '0', '', '2026-03-27 08:28:00');
INSERT INTO `sys_job_log` VALUES (303, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-27 08:34:00');
INSERT INTO `sys_job_log` VALUES (304, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 08:35:00');
INSERT INTO `sys_job_log` VALUES (305, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-27 08:36:00');
INSERT INTO `sys_job_log` VALUES (306, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 08:37:00');
INSERT INTO `sys_job_log` VALUES (307, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 08:38:00');
INSERT INTO `sys_job_log` VALUES (308, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：16毫秒', '0', '', '2026-03-27 08:39:00');
INSERT INTO `sys_job_log` VALUES (309, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-27 08:40:00');
INSERT INTO `sys_job_log` VALUES (310, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-27 08:41:00');
INSERT INTO `sys_job_log` VALUES (311, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-27 08:42:00');
INSERT INTO `sys_job_log` VALUES (312, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-27 08:43:00');
INSERT INTO `sys_job_log` VALUES (313, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-27 08:44:00');
INSERT INTO `sys_job_log` VALUES (314, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 08:45:00');
INSERT INTO `sys_job_log` VALUES (315, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-27 08:46:00');
INSERT INTO `sys_job_log` VALUES (316, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 08:47:00');
INSERT INTO `sys_job_log` VALUES (317, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-27 08:48:00');
INSERT INTO `sys_job_log` VALUES (318, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-27 08:49:00');
INSERT INTO `sys_job_log` VALUES (319, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 08:50:00');
INSERT INTO `sys_job_log` VALUES (320, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 08:51:00');
INSERT INTO `sys_job_log` VALUES (321, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 08:52:00');
INSERT INTO `sys_job_log` VALUES (322, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 08:53:00');
INSERT INTO `sys_job_log` VALUES (323, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 08:54:00');
INSERT INTO `sys_job_log` VALUES (324, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 08:55:00');
INSERT INTO `sys_job_log` VALUES (325, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 08:56:00');
INSERT INTO `sys_job_log` VALUES (326, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 08:57:00');
INSERT INTO `sys_job_log` VALUES (327, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-27 08:58:00');
INSERT INTO `sys_job_log` VALUES (328, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 08:59:00');
INSERT INTO `sys_job_log` VALUES (329, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:00:00');
INSERT INTO `sys_job_log` VALUES (330, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 09:01:00');
INSERT INTO `sys_job_log` VALUES (331, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:02:00');
INSERT INTO `sys_job_log` VALUES (332, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 09:03:00');
INSERT INTO `sys_job_log` VALUES (333, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 09:04:00');
INSERT INTO `sys_job_log` VALUES (334, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:05:00');
INSERT INTO `sys_job_log` VALUES (335, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:06:00');
INSERT INTO `sys_job_log` VALUES (336, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:07:00');
INSERT INTO `sys_job_log` VALUES (337, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:08:00');
INSERT INTO `sys_job_log` VALUES (338, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 09:09:00');
INSERT INTO `sys_job_log` VALUES (339, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-27 09:10:00');
INSERT INTO `sys_job_log` VALUES (340, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:11:00');
INSERT INTO `sys_job_log` VALUES (341, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-27 09:12:00');
INSERT INTO `sys_job_log` VALUES (342, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:13:00');
INSERT INTO `sys_job_log` VALUES (343, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:14:00');
INSERT INTO `sys_job_log` VALUES (344, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 09:15:00');
INSERT INTO `sys_job_log` VALUES (345, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 09:16:00');
INSERT INTO `sys_job_log` VALUES (346, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:17:00');
INSERT INTO `sys_job_log` VALUES (347, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:18:00');
INSERT INTO `sys_job_log` VALUES (348, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 09:19:00');
INSERT INTO `sys_job_log` VALUES (349, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 09:20:00');
INSERT INTO `sys_job_log` VALUES (350, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:21:00');
INSERT INTO `sys_job_log` VALUES (351, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:22:00');
INSERT INTO `sys_job_log` VALUES (352, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:23:00');
INSERT INTO `sys_job_log` VALUES (353, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:24:00');
INSERT INTO `sys_job_log` VALUES (354, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:25:00');
INSERT INTO `sys_job_log` VALUES (355, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:26:00');
INSERT INTO `sys_job_log` VALUES (356, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:27:00');
INSERT INTO `sys_job_log` VALUES (357, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 09:28:00');
INSERT INTO `sys_job_log` VALUES (358, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:29:00');
INSERT INTO `sys_job_log` VALUES (359, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 09:30:00');
INSERT INTO `sys_job_log` VALUES (360, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:31:00');
INSERT INTO `sys_job_log` VALUES (361, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:32:00');
INSERT INTO `sys_job_log` VALUES (362, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 09:33:00');
INSERT INTO `sys_job_log` VALUES (363, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 09:34:00');
INSERT INTO `sys_job_log` VALUES (364, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 09:35:00');
INSERT INTO `sys_job_log` VALUES (365, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:36:00');
INSERT INTO `sys_job_log` VALUES (366, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:37:00');
INSERT INTO `sys_job_log` VALUES (367, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:38:00');
INSERT INTO `sys_job_log` VALUES (368, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:39:00');
INSERT INTO `sys_job_log` VALUES (369, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:40:00');
INSERT INTO `sys_job_log` VALUES (370, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:41:00');
INSERT INTO `sys_job_log` VALUES (371, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 09:42:00');
INSERT INTO `sys_job_log` VALUES (372, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:43:00');
INSERT INTO `sys_job_log` VALUES (373, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:44:00');
INSERT INTO `sys_job_log` VALUES (374, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:45:00');
INSERT INTO `sys_job_log` VALUES (375, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:46:00');
INSERT INTO `sys_job_log` VALUES (376, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:47:00');
INSERT INTO `sys_job_log` VALUES (377, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:48:00');
INSERT INTO `sys_job_log` VALUES (378, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:49:00');
INSERT INTO `sys_job_log` VALUES (379, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 09:50:00');
INSERT INTO `sys_job_log` VALUES (380, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 09:51:00');
INSERT INTO `sys_job_log` VALUES (381, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 09:52:00');
INSERT INTO `sys_job_log` VALUES (382, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:53:00');
INSERT INTO `sys_job_log` VALUES (383, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 09:54:00');
INSERT INTO `sys_job_log` VALUES (384, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:55:00');
INSERT INTO `sys_job_log` VALUES (385, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:56:00');
INSERT INTO `sys_job_log` VALUES (386, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:57:00');
INSERT INTO `sys_job_log` VALUES (387, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 09:58:00');
INSERT INTO `sys_job_log` VALUES (388, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 09:59:00');
INSERT INTO `sys_job_log` VALUES (389, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:00:00');
INSERT INTO `sys_job_log` VALUES (390, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:01:00');
INSERT INTO `sys_job_log` VALUES (391, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:02:00');
INSERT INTO `sys_job_log` VALUES (392, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:03:00');
INSERT INTO `sys_job_log` VALUES (393, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:04:00');
INSERT INTO `sys_job_log` VALUES (394, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:05:00');
INSERT INTO `sys_job_log` VALUES (395, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:06:00');
INSERT INTO `sys_job_log` VALUES (396, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:07:00');
INSERT INTO `sys_job_log` VALUES (397, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:08:00');
INSERT INTO `sys_job_log` VALUES (398, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:09:00');
INSERT INTO `sys_job_log` VALUES (399, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:10:00');
INSERT INTO `sys_job_log` VALUES (400, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:11:00');
INSERT INTO `sys_job_log` VALUES (401, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:12:00');
INSERT INTO `sys_job_log` VALUES (402, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:13:00');
INSERT INTO `sys_job_log` VALUES (403, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:14:00');
INSERT INTO `sys_job_log` VALUES (404, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:15:00');
INSERT INTO `sys_job_log` VALUES (405, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:16:00');
INSERT INTO `sys_job_log` VALUES (406, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:17:00');
INSERT INTO `sys_job_log` VALUES (407, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:18:00');
INSERT INTO `sys_job_log` VALUES (408, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:19:00');
INSERT INTO `sys_job_log` VALUES (409, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:20:00');
INSERT INTO `sys_job_log` VALUES (410, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:21:00');
INSERT INTO `sys_job_log` VALUES (411, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:22:00');
INSERT INTO `sys_job_log` VALUES (412, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:23:00');
INSERT INTO `sys_job_log` VALUES (413, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:24:00');
INSERT INTO `sys_job_log` VALUES (414, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:25:00');
INSERT INTO `sys_job_log` VALUES (415, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:26:00');
INSERT INTO `sys_job_log` VALUES (416, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-27 10:27:00');
INSERT INTO `sys_job_log` VALUES (417, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:28:00');
INSERT INTO `sys_job_log` VALUES (418, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:29:00');
INSERT INTO `sys_job_log` VALUES (419, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:30:00');
INSERT INTO `sys_job_log` VALUES (420, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:31:00');
INSERT INTO `sys_job_log` VALUES (421, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:32:00');
INSERT INTO `sys_job_log` VALUES (422, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:33:00');
INSERT INTO `sys_job_log` VALUES (423, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:34:00');
INSERT INTO `sys_job_log` VALUES (424, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:35:00');
INSERT INTO `sys_job_log` VALUES (425, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:36:00');
INSERT INTO `sys_job_log` VALUES (426, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:37:00');
INSERT INTO `sys_job_log` VALUES (427, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:38:00');
INSERT INTO `sys_job_log` VALUES (428, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:39:00');
INSERT INTO `sys_job_log` VALUES (429, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:40:00');
INSERT INTO `sys_job_log` VALUES (430, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:41:00');
INSERT INTO `sys_job_log` VALUES (431, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:42:00');
INSERT INTO `sys_job_log` VALUES (432, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:43:00');
INSERT INTO `sys_job_log` VALUES (433, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:44:00');
INSERT INTO `sys_job_log` VALUES (434, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:45:00');
INSERT INTO `sys_job_log` VALUES (435, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:46:00');
INSERT INTO `sys_job_log` VALUES (436, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:47:00');
INSERT INTO `sys_job_log` VALUES (437, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:48:00');
INSERT INTO `sys_job_log` VALUES (438, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 10:49:00');
INSERT INTO `sys_job_log` VALUES (439, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:50:00');
INSERT INTO `sys_job_log` VALUES (440, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:51:00');
INSERT INTO `sys_job_log` VALUES (441, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:52:00');
INSERT INTO `sys_job_log` VALUES (442, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:53:00');
INSERT INTO `sys_job_log` VALUES (443, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:54:00');
INSERT INTO `sys_job_log` VALUES (444, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:55:00');
INSERT INTO `sys_job_log` VALUES (445, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:56:00');
INSERT INTO `sys_job_log` VALUES (446, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:57:00');
INSERT INTO `sys_job_log` VALUES (447, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:58:00');
INSERT INTO `sys_job_log` VALUES (448, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 10:59:00');
INSERT INTO `sys_job_log` VALUES (449, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 11:00:00');
INSERT INTO `sys_job_log` VALUES (450, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 11:01:00');
INSERT INTO `sys_job_log` VALUES (451, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 11:02:00');
INSERT INTO `sys_job_log` VALUES (452, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 11:03:00');
INSERT INTO `sys_job_log` VALUES (453, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 11:04:00');
INSERT INTO `sys_job_log` VALUES (454, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 11:05:00');
INSERT INTO `sys_job_log` VALUES (455, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 11:06:00');
INSERT INTO `sys_job_log` VALUES (456, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 11:07:00');
INSERT INTO `sys_job_log` VALUES (457, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 11:08:00');
INSERT INTO `sys_job_log` VALUES (458, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 11:09:00');
INSERT INTO `sys_job_log` VALUES (459, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 11:10:00');
INSERT INTO `sys_job_log` VALUES (460, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 11:11:00');
INSERT INTO `sys_job_log` VALUES (461, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 11:12:00');
INSERT INTO `sys_job_log` VALUES (462, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 11:13:00');
INSERT INTO `sys_job_log` VALUES (463, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 11:14:00');
INSERT INTO `sys_job_log` VALUES (464, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 11:15:00');
INSERT INTO `sys_job_log` VALUES (465, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 11:16:00');
INSERT INTO `sys_job_log` VALUES (466, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 11:17:00');
INSERT INTO `sys_job_log` VALUES (467, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 11:18:00');
INSERT INTO `sys_job_log` VALUES (468, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 11:19:00');
INSERT INTO `sys_job_log` VALUES (469, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 11:20:00');
INSERT INTO `sys_job_log` VALUES (470, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 11:21:00');
INSERT INTO `sys_job_log` VALUES (471, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 11:22:00');
INSERT INTO `sys_job_log` VALUES (472, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 11:23:00');
INSERT INTO `sys_job_log` VALUES (473, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-27 11:24:00');
INSERT INTO `sys_job_log` VALUES (474, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-27 11:25:00');
INSERT INTO `sys_job_log` VALUES (475, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：90毫秒', '0', '', '2026-03-29 11:40:00');
INSERT INTO `sys_job_log` VALUES (476, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 11:41:00');
INSERT INTO `sys_job_log` VALUES (477, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：14毫秒', '0', '', '2026-03-29 11:42:00');
INSERT INTO `sys_job_log` VALUES (478, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 11:43:00');
INSERT INTO `sys_job_log` VALUES (479, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 11:44:00');
INSERT INTO `sys_job_log` VALUES (480, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 11:45:00');
INSERT INTO `sys_job_log` VALUES (481, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 11:46:00');
INSERT INTO `sys_job_log` VALUES (482, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 11:47:00');
INSERT INTO `sys_job_log` VALUES (483, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 11:48:00');
INSERT INTO `sys_job_log` VALUES (484, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 11:49:00');
INSERT INTO `sys_job_log` VALUES (485, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：12毫秒', '0', '', '2026-03-29 11:51:00');
INSERT INTO `sys_job_log` VALUES (486, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 11:52:00');
INSERT INTO `sys_job_log` VALUES (487, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 11:53:00');
INSERT INTO `sys_job_log` VALUES (488, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-29 11:54:00');
INSERT INTO `sys_job_log` VALUES (489, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 11:55:00');
INSERT INTO `sys_job_log` VALUES (490, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 11:56:00');
INSERT INTO `sys_job_log` VALUES (491, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 11:57:00');
INSERT INTO `sys_job_log` VALUES (492, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-29 11:58:00');
INSERT INTO `sys_job_log` VALUES (493, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 11:59:00');
INSERT INTO `sys_job_log` VALUES (494, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 12:00:00');
INSERT INTO `sys_job_log` VALUES (495, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：11毫秒', '0', '', '2026-03-29 12:01:00');
INSERT INTO `sys_job_log` VALUES (496, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 12:02:00');
INSERT INTO `sys_job_log` VALUES (497, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 12:03:00');
INSERT INTO `sys_job_log` VALUES (498, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 12:04:00');
INSERT INTO `sys_job_log` VALUES (499, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 12:05:00');
INSERT INTO `sys_job_log` VALUES (500, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 12:06:00');
INSERT INTO `sys_job_log` VALUES (501, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 12:07:00');
INSERT INTO `sys_job_log` VALUES (502, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 12:08:00');
INSERT INTO `sys_job_log` VALUES (503, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 12:09:00');
INSERT INTO `sys_job_log` VALUES (504, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 12:10:00');
INSERT INTO `sys_job_log` VALUES (505, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 12:11:00');
INSERT INTO `sys_job_log` VALUES (506, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 12:12:00');
INSERT INTO `sys_job_log` VALUES (507, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 12:13:00');
INSERT INTO `sys_job_log` VALUES (508, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 12:14:00');
INSERT INTO `sys_job_log` VALUES (509, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 12:15:00');
INSERT INTO `sys_job_log` VALUES (510, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 12:16:00');
INSERT INTO `sys_job_log` VALUES (511, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 12:17:00');
INSERT INTO `sys_job_log` VALUES (512, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 12:18:00');
INSERT INTO `sys_job_log` VALUES (513, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 12:19:00');
INSERT INTO `sys_job_log` VALUES (514, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-29 12:20:00');
INSERT INTO `sys_job_log` VALUES (515, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 12:21:00');
INSERT INTO `sys_job_log` VALUES (516, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 12:22:00');
INSERT INTO `sys_job_log` VALUES (517, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 12:23:00');
INSERT INTO `sys_job_log` VALUES (518, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-29 12:24:00');
INSERT INTO `sys_job_log` VALUES (519, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 12:25:00');
INSERT INTO `sys_job_log` VALUES (520, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 12:26:00');
INSERT INTO `sys_job_log` VALUES (521, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 12:27:00');
INSERT INTO `sys_job_log` VALUES (522, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 12:28:00');
INSERT INTO `sys_job_log` VALUES (523, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 12:29:00');
INSERT INTO `sys_job_log` VALUES (524, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 12:30:00');
INSERT INTO `sys_job_log` VALUES (525, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 12:31:00');
INSERT INTO `sys_job_log` VALUES (526, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 12:32:00');
INSERT INTO `sys_job_log` VALUES (527, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 12:33:00');
INSERT INTO `sys_job_log` VALUES (528, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 12:34:00');
INSERT INTO `sys_job_log` VALUES (529, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 12:35:00');
INSERT INTO `sys_job_log` VALUES (530, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 12:36:00');
INSERT INTO `sys_job_log` VALUES (531, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 12:37:00');
INSERT INTO `sys_job_log` VALUES (532, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 12:38:00');
INSERT INTO `sys_job_log` VALUES (533, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 12:39:00');
INSERT INTO `sys_job_log` VALUES (534, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 12:40:00');
INSERT INTO `sys_job_log` VALUES (535, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 12:41:00');
INSERT INTO `sys_job_log` VALUES (536, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 12:42:00');
INSERT INTO `sys_job_log` VALUES (537, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 12:43:00');
INSERT INTO `sys_job_log` VALUES (538, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 12:44:00');
INSERT INTO `sys_job_log` VALUES (539, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 12:45:00');
INSERT INTO `sys_job_log` VALUES (540, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 12:46:00');
INSERT INTO `sys_job_log` VALUES (541, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 12:47:00');
INSERT INTO `sys_job_log` VALUES (542, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 12:48:00');
INSERT INTO `sys_job_log` VALUES (543, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 12:49:00');
INSERT INTO `sys_job_log` VALUES (544, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 12:50:00');
INSERT INTO `sys_job_log` VALUES (545, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 12:51:00');
INSERT INTO `sys_job_log` VALUES (546, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 12:52:00');
INSERT INTO `sys_job_log` VALUES (547, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 12:53:00');
INSERT INTO `sys_job_log` VALUES (548, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 12:54:00');
INSERT INTO `sys_job_log` VALUES (549, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 12:55:00');
INSERT INTO `sys_job_log` VALUES (550, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 12:56:00');
INSERT INTO `sys_job_log` VALUES (551, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 12:57:00');
INSERT INTO `sys_job_log` VALUES (552, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 12:58:00');
INSERT INTO `sys_job_log` VALUES (553, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 12:59:00');
INSERT INTO `sys_job_log` VALUES (554, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:00:00');
INSERT INTO `sys_job_log` VALUES (555, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:01:00');
INSERT INTO `sys_job_log` VALUES (556, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:02:00');
INSERT INTO `sys_job_log` VALUES (557, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 13:03:00');
INSERT INTO `sys_job_log` VALUES (558, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:04:00');
INSERT INTO `sys_job_log` VALUES (559, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:05:00');
INSERT INTO `sys_job_log` VALUES (560, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:06:00');
INSERT INTO `sys_job_log` VALUES (561, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:07:00');
INSERT INTO `sys_job_log` VALUES (562, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:08:00');
INSERT INTO `sys_job_log` VALUES (563, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:09:00');
INSERT INTO `sys_job_log` VALUES (564, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:10:00');
INSERT INTO `sys_job_log` VALUES (565, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:11:00');
INSERT INTO `sys_job_log` VALUES (566, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:12:00');
INSERT INTO `sys_job_log` VALUES (567, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:13:00');
INSERT INTO `sys_job_log` VALUES (568, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 13:14:00');
INSERT INTO `sys_job_log` VALUES (569, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:15:00');
INSERT INTO `sys_job_log` VALUES (570, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:16:00');
INSERT INTO `sys_job_log` VALUES (571, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:17:00');
INSERT INTO `sys_job_log` VALUES (572, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:18:00');
INSERT INTO `sys_job_log` VALUES (573, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 13:19:00');
INSERT INTO `sys_job_log` VALUES (574, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:20:00');
INSERT INTO `sys_job_log` VALUES (575, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 13:21:00');
INSERT INTO `sys_job_log` VALUES (576, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:22:00');
INSERT INTO `sys_job_log` VALUES (577, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:23:00');
INSERT INTO `sys_job_log` VALUES (578, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:24:00');
INSERT INTO `sys_job_log` VALUES (579, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:25:00');
INSERT INTO `sys_job_log` VALUES (580, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 13:26:00');
INSERT INTO `sys_job_log` VALUES (581, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:27:00');
INSERT INTO `sys_job_log` VALUES (582, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:28:00');
INSERT INTO `sys_job_log` VALUES (583, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:29:00');
INSERT INTO `sys_job_log` VALUES (584, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:30:00');
INSERT INTO `sys_job_log` VALUES (585, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:31:00');
INSERT INTO `sys_job_log` VALUES (586, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 13:32:00');
INSERT INTO `sys_job_log` VALUES (587, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 13:33:00');
INSERT INTO `sys_job_log` VALUES (588, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 13:34:00');
INSERT INTO `sys_job_log` VALUES (589, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:35:00');
INSERT INTO `sys_job_log` VALUES (590, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:36:00');
INSERT INTO `sys_job_log` VALUES (591, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 13:37:00');
INSERT INTO `sys_job_log` VALUES (592, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 13:38:00');
INSERT INTO `sys_job_log` VALUES (593, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:39:00');
INSERT INTO `sys_job_log` VALUES (594, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:40:00');
INSERT INTO `sys_job_log` VALUES (595, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:41:00');
INSERT INTO `sys_job_log` VALUES (596, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:42:00');
INSERT INTO `sys_job_log` VALUES (597, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:43:00');
INSERT INTO `sys_job_log` VALUES (598, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 13:44:00');
INSERT INTO `sys_job_log` VALUES (599, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:45:00');
INSERT INTO `sys_job_log` VALUES (600, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:46:00');
INSERT INTO `sys_job_log` VALUES (601, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 13:47:00');
INSERT INTO `sys_job_log` VALUES (602, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 13:48:00');
INSERT INTO `sys_job_log` VALUES (603, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:49:00');
INSERT INTO `sys_job_log` VALUES (604, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:50:00');
INSERT INTO `sys_job_log` VALUES (605, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:51:00');
INSERT INTO `sys_job_log` VALUES (606, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:52:00');
INSERT INTO `sys_job_log` VALUES (607, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:53:00');
INSERT INTO `sys_job_log` VALUES (608, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:54:00');
INSERT INTO `sys_job_log` VALUES (609, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:55:00');
INSERT INTO `sys_job_log` VALUES (610, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:56:00');
INSERT INTO `sys_job_log` VALUES (611, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:57:00');
INSERT INTO `sys_job_log` VALUES (612, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 13:58:00');
INSERT INTO `sys_job_log` VALUES (613, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 13:59:00');
INSERT INTO `sys_job_log` VALUES (614, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:00:00');
INSERT INTO `sys_job_log` VALUES (615, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:01:00');
INSERT INTO `sys_job_log` VALUES (616, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:02:00');
INSERT INTO `sys_job_log` VALUES (617, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:03:00');
INSERT INTO `sys_job_log` VALUES (618, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 14:04:00');
INSERT INTO `sys_job_log` VALUES (619, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:05:00');
INSERT INTO `sys_job_log` VALUES (620, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 14:06:00');
INSERT INTO `sys_job_log` VALUES (621, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 14:07:00');
INSERT INTO `sys_job_log` VALUES (622, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 14:08:00');
INSERT INTO `sys_job_log` VALUES (623, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:09:00');
INSERT INTO `sys_job_log` VALUES (624, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:10:00');
INSERT INTO `sys_job_log` VALUES (625, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:11:00');
INSERT INTO `sys_job_log` VALUES (626, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:12:00');
INSERT INTO `sys_job_log` VALUES (627, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:13:00');
INSERT INTO `sys_job_log` VALUES (628, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:14:00');
INSERT INTO `sys_job_log` VALUES (629, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:15:00');
INSERT INTO `sys_job_log` VALUES (630, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 14:16:00');
INSERT INTO `sys_job_log` VALUES (631, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:17:00');
INSERT INTO `sys_job_log` VALUES (632, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:18:00');
INSERT INTO `sys_job_log` VALUES (633, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 14:19:00');
INSERT INTO `sys_job_log` VALUES (634, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 14:20:00');
INSERT INTO `sys_job_log` VALUES (635, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:21:00');
INSERT INTO `sys_job_log` VALUES (636, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 14:22:00');
INSERT INTO `sys_job_log` VALUES (637, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 14:23:00');
INSERT INTO `sys_job_log` VALUES (638, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:24:00');
INSERT INTO `sys_job_log` VALUES (639, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 14:25:00');
INSERT INTO `sys_job_log` VALUES (640, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:26:00');
INSERT INTO `sys_job_log` VALUES (641, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:27:00');
INSERT INTO `sys_job_log` VALUES (642, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:28:00');
INSERT INTO `sys_job_log` VALUES (643, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:29:00');
INSERT INTO `sys_job_log` VALUES (644, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:30:00');
INSERT INTO `sys_job_log` VALUES (645, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:31:00');
INSERT INTO `sys_job_log` VALUES (646, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:32:00');
INSERT INTO `sys_job_log` VALUES (647, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:33:00');
INSERT INTO `sys_job_log` VALUES (648, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:34:00');
INSERT INTO `sys_job_log` VALUES (649, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:35:00');
INSERT INTO `sys_job_log` VALUES (650, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:36:00');
INSERT INTO `sys_job_log` VALUES (651, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 14:37:00');
INSERT INTO `sys_job_log` VALUES (652, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:38:00');
INSERT INTO `sys_job_log` VALUES (653, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 14:39:00');
INSERT INTO `sys_job_log` VALUES (654, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:40:00');
INSERT INTO `sys_job_log` VALUES (655, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 14:41:00');
INSERT INTO `sys_job_log` VALUES (656, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:42:00');
INSERT INTO `sys_job_log` VALUES (657, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:43:00');
INSERT INTO `sys_job_log` VALUES (658, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 14:44:00');
INSERT INTO `sys_job_log` VALUES (659, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：1毫秒', '0', '', '2026-03-29 14:45:00');
INSERT INTO `sys_job_log` VALUES (660, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:46:00');
INSERT INTO `sys_job_log` VALUES (661, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:47:00');
INSERT INTO `sys_job_log` VALUES (662, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:48:00');
INSERT INTO `sys_job_log` VALUES (663, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 14:49:00');
INSERT INTO `sys_job_log` VALUES (664, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 14:50:00');
INSERT INTO `sys_job_log` VALUES (665, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:51:00');
INSERT INTO `sys_job_log` VALUES (666, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:52:00');
INSERT INTO `sys_job_log` VALUES (667, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 14:53:00');
INSERT INTO `sys_job_log` VALUES (668, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:54:00');
INSERT INTO `sys_job_log` VALUES (669, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:55:00');
INSERT INTO `sys_job_log` VALUES (670, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:56:00');
INSERT INTO `sys_job_log` VALUES (671, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:57:00');
INSERT INTO `sys_job_log` VALUES (672, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 14:58:00');
INSERT INTO `sys_job_log` VALUES (673, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 14:59:00');
INSERT INTO `sys_job_log` VALUES (674, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 15:00:00');
INSERT INTO `sys_job_log` VALUES (675, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 15:01:00');
INSERT INTO `sys_job_log` VALUES (676, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 15:02:00');
INSERT INTO `sys_job_log` VALUES (677, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 15:03:00');
INSERT INTO `sys_job_log` VALUES (678, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 15:04:00');
INSERT INTO `sys_job_log` VALUES (679, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 15:05:00');
INSERT INTO `sys_job_log` VALUES (680, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 15:06:00');
INSERT INTO `sys_job_log` VALUES (681, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 15:07:00');
INSERT INTO `sys_job_log` VALUES (682, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 15:08:00');
INSERT INTO `sys_job_log` VALUES (683, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 15:09:00');
INSERT INTO `sys_job_log` VALUES (684, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 15:10:00');
INSERT INTO `sys_job_log` VALUES (685, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 15:11:00');
INSERT INTO `sys_job_log` VALUES (686, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 15:12:00');
INSERT INTO `sys_job_log` VALUES (687, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 15:13:00');
INSERT INTO `sys_job_log` VALUES (688, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 15:14:00');
INSERT INTO `sys_job_log` VALUES (689, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 15:15:00');
INSERT INTO `sys_job_log` VALUES (690, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-29 15:16:00');
INSERT INTO `sys_job_log` VALUES (691, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 15:17:00');
INSERT INTO `sys_job_log` VALUES (692, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 15:18:00');
INSERT INTO `sys_job_log` VALUES (693, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 15:19:00');
INSERT INTO `sys_job_log` VALUES (694, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 15:20:00');
INSERT INTO `sys_job_log` VALUES (695, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 15:21:00');
INSERT INTO `sys_job_log` VALUES (696, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 15:22:00');
INSERT INTO `sys_job_log` VALUES (697, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 15:23:00');
INSERT INTO `sys_job_log` VALUES (698, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 15:24:00');
INSERT INTO `sys_job_log` VALUES (699, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 15:25:00');
INSERT INTO `sys_job_log` VALUES (700, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：13毫秒', '0', '', '2026-03-29 15:26:00');
INSERT INTO `sys_job_log` VALUES (701, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 15:27:00');
INSERT INTO `sys_job_log` VALUES (702, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 15:28:00');
INSERT INTO `sys_job_log` VALUES (703, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 15:29:00');
INSERT INTO `sys_job_log` VALUES (704, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 15:30:00');
INSERT INTO `sys_job_log` VALUES (705, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 15:31:00');
INSERT INTO `sys_job_log` VALUES (706, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 15:32:00');
INSERT INTO `sys_job_log` VALUES (707, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 15:33:00');
INSERT INTO `sys_job_log` VALUES (708, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 15:34:00');
INSERT INTO `sys_job_log` VALUES (709, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 15:35:00');
INSERT INTO `sys_job_log` VALUES (710, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 15:36:00');
INSERT INTO `sys_job_log` VALUES (711, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 15:37:00');
INSERT INTO `sys_job_log` VALUES (712, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 15:38:00');
INSERT INTO `sys_job_log` VALUES (713, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 15:39:00');
INSERT INTO `sys_job_log` VALUES (714, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 15:40:00');
INSERT INTO `sys_job_log` VALUES (715, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 15:41:00');
INSERT INTO `sys_job_log` VALUES (716, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 15:42:00');
INSERT INTO `sys_job_log` VALUES (717, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 15:43:00');
INSERT INTO `sys_job_log` VALUES (718, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 15:44:00');
INSERT INTO `sys_job_log` VALUES (719, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 15:45:00');
INSERT INTO `sys_job_log` VALUES (720, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 15:46:00');
INSERT INTO `sys_job_log` VALUES (721, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 15:47:00');
INSERT INTO `sys_job_log` VALUES (722, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：106毫秒', '0', '', '2026-03-29 15:48:00');
INSERT INTO `sys_job_log` VALUES (723, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 15:49:00');
INSERT INTO `sys_job_log` VALUES (724, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 15:50:00');
INSERT INTO `sys_job_log` VALUES (725, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 15:51:00');
INSERT INTO `sys_job_log` VALUES (726, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 15:52:00');
INSERT INTO `sys_job_log` VALUES (727, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 15:53:00');
INSERT INTO `sys_job_log` VALUES (728, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-29 15:54:00');
INSERT INTO `sys_job_log` VALUES (729, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 15:55:00');
INSERT INTO `sys_job_log` VALUES (730, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 15:56:00');
INSERT INTO `sys_job_log` VALUES (731, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：9毫秒', '0', '', '2026-03-29 15:57:00');
INSERT INTO `sys_job_log` VALUES (732, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-29 15:58:00');
INSERT INTO `sys_job_log` VALUES (733, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：9毫秒', '0', '', '2026-03-29 15:59:00');
INSERT INTO `sys_job_log` VALUES (734, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-29 16:00:00');
INSERT INTO `sys_job_log` VALUES (735, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 16:01:00');
INSERT INTO `sys_job_log` VALUES (736, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:02:00');
INSERT INTO `sys_job_log` VALUES (737, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 16:03:00');
INSERT INTO `sys_job_log` VALUES (738, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 16:04:00');
INSERT INTO `sys_job_log` VALUES (739, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 16:05:00');
INSERT INTO `sys_job_log` VALUES (740, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 16:06:00');
INSERT INTO `sys_job_log` VALUES (741, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 16:07:00');
INSERT INTO `sys_job_log` VALUES (742, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 16:08:00');
INSERT INTO `sys_job_log` VALUES (743, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 16:09:00');
INSERT INTO `sys_job_log` VALUES (744, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:10:00');
INSERT INTO `sys_job_log` VALUES (745, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 16:11:00');
INSERT INTO `sys_job_log` VALUES (746, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 16:12:00');
INSERT INTO `sys_job_log` VALUES (747, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:13:00');
INSERT INTO `sys_job_log` VALUES (748, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 16:14:00');
INSERT INTO `sys_job_log` VALUES (749, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:15:00');
INSERT INTO `sys_job_log` VALUES (750, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:16:00');
INSERT INTO `sys_job_log` VALUES (751, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 16:17:00');
INSERT INTO `sys_job_log` VALUES (752, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 16:18:00');
INSERT INTO `sys_job_log` VALUES (753, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 16:19:00');
INSERT INTO `sys_job_log` VALUES (754, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:20:00');
INSERT INTO `sys_job_log` VALUES (755, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:21:00');
INSERT INTO `sys_job_log` VALUES (756, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:22:00');
INSERT INTO `sys_job_log` VALUES (757, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:23:00');
INSERT INTO `sys_job_log` VALUES (758, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 16:24:00');
INSERT INTO `sys_job_log` VALUES (759, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:25:00');
INSERT INTO `sys_job_log` VALUES (760, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:26:00');
INSERT INTO `sys_job_log` VALUES (761, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 16:27:00');
INSERT INTO `sys_job_log` VALUES (762, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:28:00');
INSERT INTO `sys_job_log` VALUES (763, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:29:00');
INSERT INTO `sys_job_log` VALUES (764, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:30:00');
INSERT INTO `sys_job_log` VALUES (765, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 16:31:00');
INSERT INTO `sys_job_log` VALUES (766, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:32:00');
INSERT INTO `sys_job_log` VALUES (767, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:33:00');
INSERT INTO `sys_job_log` VALUES (768, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 16:34:00');
INSERT INTO `sys_job_log` VALUES (769, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 16:35:00');
INSERT INTO `sys_job_log` VALUES (770, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 16:36:00');
INSERT INTO `sys_job_log` VALUES (771, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:37:00');
INSERT INTO `sys_job_log` VALUES (772, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 16:38:00');
INSERT INTO `sys_job_log` VALUES (773, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 16:39:00');
INSERT INTO `sys_job_log` VALUES (774, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:40:00');
INSERT INTO `sys_job_log` VALUES (775, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 16:41:00');
INSERT INTO `sys_job_log` VALUES (776, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:42:00');
INSERT INTO `sys_job_log` VALUES (777, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 16:43:00');
INSERT INTO `sys_job_log` VALUES (778, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-29 16:44:00');
INSERT INTO `sys_job_log` VALUES (779, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:45:00');
INSERT INTO `sys_job_log` VALUES (780, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:46:00');
INSERT INTO `sys_job_log` VALUES (781, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:47:00');
INSERT INTO `sys_job_log` VALUES (782, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 16:48:00');
INSERT INTO `sys_job_log` VALUES (783, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：56毫秒', '0', '', '2026-03-29 16:49:00');
INSERT INTO `sys_job_log` VALUES (784, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:50:00');
INSERT INTO `sys_job_log` VALUES (785, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 16:51:00');
INSERT INTO `sys_job_log` VALUES (786, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 16:52:00');
INSERT INTO `sys_job_log` VALUES (787, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 16:53:00');
INSERT INTO `sys_job_log` VALUES (788, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：18毫秒', '0', '', '2026-03-29 16:54:00');
INSERT INTO `sys_job_log` VALUES (789, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-29 16:55:00');
INSERT INTO `sys_job_log` VALUES (790, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 16:56:00');
INSERT INTO `sys_job_log` VALUES (791, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：11毫秒', '0', '', '2026-03-29 16:58:00');
INSERT INTO `sys_job_log` VALUES (792, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 16:59:00');
INSERT INTO `sys_job_log` VALUES (793, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:00:00');
INSERT INTO `sys_job_log` VALUES (794, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 17:01:00');
INSERT INTO `sys_job_log` VALUES (795, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:02:00');
INSERT INTO `sys_job_log` VALUES (796, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：8毫秒', '0', '', '2026-03-29 17:03:00');
INSERT INTO `sys_job_log` VALUES (797, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:04:00');
INSERT INTO `sys_job_log` VALUES (798, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:05:00');
INSERT INTO `sys_job_log` VALUES (799, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:06:00');
INSERT INTO `sys_job_log` VALUES (800, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：9毫秒', '0', '', '2026-03-29 17:07:00');
INSERT INTO `sys_job_log` VALUES (801, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 17:08:00');
INSERT INTO `sys_job_log` VALUES (802, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-29 17:09:00');
INSERT INTO `sys_job_log` VALUES (803, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:10:00');
INSERT INTO `sys_job_log` VALUES (804, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:11:00');
INSERT INTO `sys_job_log` VALUES (805, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-29 17:12:00');
INSERT INTO `sys_job_log` VALUES (806, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:13:00');
INSERT INTO `sys_job_log` VALUES (807, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 17:14:00');
INSERT INTO `sys_job_log` VALUES (808, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 17:15:00');
INSERT INTO `sys_job_log` VALUES (809, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-29 17:16:00');
INSERT INTO `sys_job_log` VALUES (810, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 17:17:00');
INSERT INTO `sys_job_log` VALUES (811, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:18:00');
INSERT INTO `sys_job_log` VALUES (812, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:19:00');
INSERT INTO `sys_job_log` VALUES (813, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：12毫秒', '0', '', '2026-03-29 17:20:00');
INSERT INTO `sys_job_log` VALUES (814, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 17:21:00');
INSERT INTO `sys_job_log` VALUES (815, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：34毫秒', '0', '', '2026-03-29 17:22:00');
INSERT INTO `sys_job_log` VALUES (816, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 17:23:00');
INSERT INTO `sys_job_log` VALUES (817, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 17:24:00');
INSERT INTO `sys_job_log` VALUES (818, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 17:25:00');
INSERT INTO `sys_job_log` VALUES (819, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 17:26:00');
INSERT INTO `sys_job_log` VALUES (820, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 17:27:00');
INSERT INTO `sys_job_log` VALUES (821, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 17:28:00');
INSERT INTO `sys_job_log` VALUES (822, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 17:29:00');
INSERT INTO `sys_job_log` VALUES (823, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 17:30:00');
INSERT INTO `sys_job_log` VALUES (824, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 17:31:00');
INSERT INTO `sys_job_log` VALUES (825, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 17:32:00');
INSERT INTO `sys_job_log` VALUES (826, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:33:00');
INSERT INTO `sys_job_log` VALUES (827, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：12毫秒', '0', '', '2026-03-29 17:34:00');
INSERT INTO `sys_job_log` VALUES (828, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 17:35:00');
INSERT INTO `sys_job_log` VALUES (829, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:36:00');
INSERT INTO `sys_job_log` VALUES (830, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 17:37:00');
INSERT INTO `sys_job_log` VALUES (831, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 17:38:00');
INSERT INTO `sys_job_log` VALUES (832, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:39:00');
INSERT INTO `sys_job_log` VALUES (833, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:40:00');
INSERT INTO `sys_job_log` VALUES (834, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:41:00');
INSERT INTO `sys_job_log` VALUES (835, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:42:00');
INSERT INTO `sys_job_log` VALUES (836, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:43:00');
INSERT INTO `sys_job_log` VALUES (837, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:44:00');
INSERT INTO `sys_job_log` VALUES (838, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：9毫秒', '0', '', '2026-03-29 17:46:00');
INSERT INTO `sys_job_log` VALUES (839, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:47:00');
INSERT INTO `sys_job_log` VALUES (840, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:48:00');
INSERT INTO `sys_job_log` VALUES (841, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:49:00');
INSERT INTO `sys_job_log` VALUES (842, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:50:00');
INSERT INTO `sys_job_log` VALUES (843, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：13毫秒', '0', '', '2026-03-29 17:51:00');
INSERT INTO `sys_job_log` VALUES (844, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-29 17:52:00');
INSERT INTO `sys_job_log` VALUES (845, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:53:00');
INSERT INTO `sys_job_log` VALUES (846, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：13毫秒', '0', '', '2026-03-29 17:54:00');
INSERT INTO `sys_job_log` VALUES (847, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 17:55:00');
INSERT INTO `sys_job_log` VALUES (848, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 17:56:00');
INSERT INTO `sys_job_log` VALUES (849, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 17:57:00');
INSERT INTO `sys_job_log` VALUES (850, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-29 17:58:00');
INSERT INTO `sys_job_log` VALUES (851, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 17:59:00');
INSERT INTO `sys_job_log` VALUES (852, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:00:00');
INSERT INTO `sys_job_log` VALUES (853, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:01:00');
INSERT INTO `sys_job_log` VALUES (854, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:02:00');
INSERT INTO `sys_job_log` VALUES (855, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:03:00');
INSERT INTO `sys_job_log` VALUES (856, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:04:00');
INSERT INTO `sys_job_log` VALUES (857, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 18:05:00');
INSERT INTO `sys_job_log` VALUES (858, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:06:00');
INSERT INTO `sys_job_log` VALUES (859, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 18:07:00');
INSERT INTO `sys_job_log` VALUES (860, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:08:00');
INSERT INTO `sys_job_log` VALUES (861, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 18:09:00');
INSERT INTO `sys_job_log` VALUES (862, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 18:10:00');
INSERT INTO `sys_job_log` VALUES (863, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 18:11:00');
INSERT INTO `sys_job_log` VALUES (864, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 18:12:00');
INSERT INTO `sys_job_log` VALUES (865, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:13:00');
INSERT INTO `sys_job_log` VALUES (866, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:14:00');
INSERT INTO `sys_job_log` VALUES (867, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:15:00');
INSERT INTO `sys_job_log` VALUES (868, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 18:16:00');
INSERT INTO `sys_job_log` VALUES (869, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 18:17:00');
INSERT INTO `sys_job_log` VALUES (870, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 18:18:00');
INSERT INTO `sys_job_log` VALUES (871, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 18:19:00');
INSERT INTO `sys_job_log` VALUES (872, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 18:20:00');
INSERT INTO `sys_job_log` VALUES (873, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 18:21:00');
INSERT INTO `sys_job_log` VALUES (874, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 18:22:00');
INSERT INTO `sys_job_log` VALUES (875, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：9毫秒', '0', '', '2026-03-29 18:23:00');
INSERT INTO `sys_job_log` VALUES (876, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 18:24:00');
INSERT INTO `sys_job_log` VALUES (877, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:25:00');
INSERT INTO `sys_job_log` VALUES (878, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:26:00');
INSERT INTO `sys_job_log` VALUES (879, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：9毫秒', '0', '', '2026-03-29 18:27:00');
INSERT INTO `sys_job_log` VALUES (880, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:28:00');
INSERT INTO `sys_job_log` VALUES (881, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:29:00');
INSERT INTO `sys_job_log` VALUES (882, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:30:00');
INSERT INTO `sys_job_log` VALUES (883, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:31:00');
INSERT INTO `sys_job_log` VALUES (884, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:32:00');
INSERT INTO `sys_job_log` VALUES (885, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:33:00');
INSERT INTO `sys_job_log` VALUES (886, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：11毫秒', '0', '', '2026-03-29 18:34:00');
INSERT INTO `sys_job_log` VALUES (887, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 18:35:00');
INSERT INTO `sys_job_log` VALUES (888, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:36:00');
INSERT INTO `sys_job_log` VALUES (889, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:37:00');
INSERT INTO `sys_job_log` VALUES (890, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:38:00');
INSERT INTO `sys_job_log` VALUES (891, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-29 18:39:00');
INSERT INTO `sys_job_log` VALUES (892, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 18:40:00');
INSERT INTO `sys_job_log` VALUES (893, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:41:00');
INSERT INTO `sys_job_log` VALUES (894, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 18:42:00');
INSERT INTO `sys_job_log` VALUES (895, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：11毫秒', '0', '', '2026-03-29 18:43:00');
INSERT INTO `sys_job_log` VALUES (896, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-29 18:44:00');
INSERT INTO `sys_job_log` VALUES (897, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:45:00');
INSERT INTO `sys_job_log` VALUES (898, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：9毫秒', '0', '', '2026-03-29 18:46:00');
INSERT INTO `sys_job_log` VALUES (899, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 18:47:00');
INSERT INTO `sys_job_log` VALUES (900, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:48:00');
INSERT INTO `sys_job_log` VALUES (901, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:49:00');
INSERT INTO `sys_job_log` VALUES (902, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:50:00');
INSERT INTO `sys_job_log` VALUES (903, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:51:00');
INSERT INTO `sys_job_log` VALUES (904, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 18:52:00');
INSERT INTO `sys_job_log` VALUES (905, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:53:00');
INSERT INTO `sys_job_log` VALUES (906, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 18:54:00');
INSERT INTO `sys_job_log` VALUES (907, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 18:55:00');
INSERT INTO `sys_job_log` VALUES (908, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：8毫秒', '0', '', '2026-03-29 18:56:00');
INSERT INTO `sys_job_log` VALUES (909, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-29 18:57:00');
INSERT INTO `sys_job_log` VALUES (910, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 18:58:00');
INSERT INTO `sys_job_log` VALUES (911, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 18:59:00');
INSERT INTO `sys_job_log` VALUES (912, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:00:00');
INSERT INTO `sys_job_log` VALUES (913, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 19:01:00');
INSERT INTO `sys_job_log` VALUES (914, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 19:02:00');
INSERT INTO `sys_job_log` VALUES (915, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:03:00');
INSERT INTO `sys_job_log` VALUES (916, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 19:04:00');
INSERT INTO `sys_job_log` VALUES (917, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 19:05:00');
INSERT INTO `sys_job_log` VALUES (918, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-29 19:06:00');
INSERT INTO `sys_job_log` VALUES (919, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 19:07:00');
INSERT INTO `sys_job_log` VALUES (920, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:08:00');
INSERT INTO `sys_job_log` VALUES (921, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:09:00');
INSERT INTO `sys_job_log` VALUES (922, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：8毫秒', '0', '', '2026-03-29 19:10:00');
INSERT INTO `sys_job_log` VALUES (923, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 19:11:00');
INSERT INTO `sys_job_log` VALUES (924, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:12:00');
INSERT INTO `sys_job_log` VALUES (925, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:13:00');
INSERT INTO `sys_job_log` VALUES (926, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：12毫秒', '0', '', '2026-03-29 19:14:00');
INSERT INTO `sys_job_log` VALUES (927, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-29 19:15:00');
INSERT INTO `sys_job_log` VALUES (928, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 19:16:00');
INSERT INTO `sys_job_log` VALUES (929, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:17:00');
INSERT INTO `sys_job_log` VALUES (930, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:18:00');
INSERT INTO `sys_job_log` VALUES (931, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:19:00');
INSERT INTO `sys_job_log` VALUES (932, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 19:20:00');
INSERT INTO `sys_job_log` VALUES (933, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:21:00');
INSERT INTO `sys_job_log` VALUES (934, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:23:00');
INSERT INTO `sys_job_log` VALUES (935, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:24:00');
INSERT INTO `sys_job_log` VALUES (936, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:25:00');
INSERT INTO `sys_job_log` VALUES (937, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 19:26:00');
INSERT INTO `sys_job_log` VALUES (938, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:27:00');
INSERT INTO `sys_job_log` VALUES (939, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:28:00');
INSERT INTO `sys_job_log` VALUES (940, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 19:29:00');
INSERT INTO `sys_job_log` VALUES (941, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：16毫秒', '0', '', '2026-03-29 19:30:01');
INSERT INTO `sys_job_log` VALUES (942, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-29 19:31:00');
INSERT INTO `sys_job_log` VALUES (943, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:32:00');
INSERT INTO `sys_job_log` VALUES (944, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 19:33:00');
INSERT INTO `sys_job_log` VALUES (945, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:34:00');
INSERT INTO `sys_job_log` VALUES (946, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:35:00');
INSERT INTO `sys_job_log` VALUES (947, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:36:00');
INSERT INTO `sys_job_log` VALUES (948, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：13毫秒', '0', '', '2026-03-29 19:37:00');
INSERT INTO `sys_job_log` VALUES (949, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:38:00');
INSERT INTO `sys_job_log` VALUES (950, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:39:00');
INSERT INTO `sys_job_log` VALUES (951, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：43毫秒', '0', '', '2026-03-29 19:40:00');
INSERT INTO `sys_job_log` VALUES (952, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 19:41:00');
INSERT INTO `sys_job_log` VALUES (953, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:42:00');
INSERT INTO `sys_job_log` VALUES (954, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:43:00');
INSERT INTO `sys_job_log` VALUES (955, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:44:00');
INSERT INTO `sys_job_log` VALUES (956, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 19:45:00');
INSERT INTO `sys_job_log` VALUES (957, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:46:00');
INSERT INTO `sys_job_log` VALUES (958, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:47:00');
INSERT INTO `sys_job_log` VALUES (959, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 19:48:00');
INSERT INTO `sys_job_log` VALUES (960, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 19:49:00');
INSERT INTO `sys_job_log` VALUES (961, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:50:00');
INSERT INTO `sys_job_log` VALUES (962, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:51:00');
INSERT INTO `sys_job_log` VALUES (963, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 19:52:00');
INSERT INTO `sys_job_log` VALUES (964, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:53:00');
INSERT INTO `sys_job_log` VALUES (965, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 19:54:00');
INSERT INTO `sys_job_log` VALUES (966, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 19:55:00');
INSERT INTO `sys_job_log` VALUES (967, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 19:56:00');
INSERT INTO `sys_job_log` VALUES (968, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 19:57:00');
INSERT INTO `sys_job_log` VALUES (969, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 19:58:00');
INSERT INTO `sys_job_log` VALUES (970, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 19:59:00');
INSERT INTO `sys_job_log` VALUES (971, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 20:00:00');
INSERT INTO `sys_job_log` VALUES (972, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 20:01:00');
INSERT INTO `sys_job_log` VALUES (973, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 20:02:00');
INSERT INTO `sys_job_log` VALUES (974, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 20:03:00');
INSERT INTO `sys_job_log` VALUES (975, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 20:04:00');
INSERT INTO `sys_job_log` VALUES (976, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 20:05:00');
INSERT INTO `sys_job_log` VALUES (977, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 20:06:00');
INSERT INTO `sys_job_log` VALUES (978, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 20:07:00');
INSERT INTO `sys_job_log` VALUES (979, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 20:08:00');
INSERT INTO `sys_job_log` VALUES (980, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 20:09:00');
INSERT INTO `sys_job_log` VALUES (981, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 20:10:00');
INSERT INTO `sys_job_log` VALUES (982, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 20:11:00');
INSERT INTO `sys_job_log` VALUES (983, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 20:12:00');
INSERT INTO `sys_job_log` VALUES (984, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 20:13:00');
INSERT INTO `sys_job_log` VALUES (985, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 20:14:00');
INSERT INTO `sys_job_log` VALUES (986, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 20:15:00');
INSERT INTO `sys_job_log` VALUES (987, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 20:16:00');
INSERT INTO `sys_job_log` VALUES (988, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 20:17:00');
INSERT INTO `sys_job_log` VALUES (989, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 20:18:00');
INSERT INTO `sys_job_log` VALUES (990, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 20:19:00');
INSERT INTO `sys_job_log` VALUES (991, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 20:20:00');
INSERT INTO `sys_job_log` VALUES (992, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 20:21:00');
INSERT INTO `sys_job_log` VALUES (993, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 20:22:00');
INSERT INTO `sys_job_log` VALUES (994, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：51毫秒', '0', '', '2026-03-29 20:23:00');
INSERT INTO `sys_job_log` VALUES (995, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 20:24:00');
INSERT INTO `sys_job_log` VALUES (996, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 20:25:00');
INSERT INTO `sys_job_log` VALUES (997, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：2毫秒', '0', '', '2026-03-29 20:26:00');
INSERT INTO `sys_job_log` VALUES (998, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 20:27:00');
INSERT INTO `sys_job_log` VALUES (999, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 20:28:00');
INSERT INTO `sys_job_log` VALUES (1000, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 20:29:00');
INSERT INTO `sys_job_log` VALUES (1001, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：26毫秒', '0', '', '2026-03-29 21:00:00');
INSERT INTO `sys_job_log` VALUES (1002, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-29 21:01:00');
INSERT INTO `sys_job_log` VALUES (1003, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-29 21:02:00');
INSERT INTO `sys_job_log` VALUES (1004, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 21:03:00');
INSERT INTO `sys_job_log` VALUES (1005, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 21:04:00');
INSERT INTO `sys_job_log` VALUES (1006, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 21:05:00');
INSERT INTO `sys_job_log` VALUES (1007, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 21:06:00');
INSERT INTO `sys_job_log` VALUES (1008, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 21:07:00');
INSERT INTO `sys_job_log` VALUES (1009, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：21毫秒', '0', '', '2026-03-29 21:08:00');
INSERT INTO `sys_job_log` VALUES (1010, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：101毫秒', '0', '', '2026-03-29 21:09:00');
INSERT INTO `sys_job_log` VALUES (1011, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 21:10:00');
INSERT INTO `sys_job_log` VALUES (1012, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 21:11:00');
INSERT INTO `sys_job_log` VALUES (1013, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 21:12:00');
INSERT INTO `sys_job_log` VALUES (1014, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 21:13:00');
INSERT INTO `sys_job_log` VALUES (1015, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 21:14:00');
INSERT INTO `sys_job_log` VALUES (1016, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 21:15:00');
INSERT INTO `sys_job_log` VALUES (1017, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 21:16:00');
INSERT INTO `sys_job_log` VALUES (1018, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 21:17:00');
INSERT INTO `sys_job_log` VALUES (1019, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 21:18:00');
INSERT INTO `sys_job_log` VALUES (1020, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 21:19:00');
INSERT INTO `sys_job_log` VALUES (1021, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 21:20:00');
INSERT INTO `sys_job_log` VALUES (1022, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 21:21:00');
INSERT INTO `sys_job_log` VALUES (1023, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 21:22:00');
INSERT INTO `sys_job_log` VALUES (1024, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 21:23:00');
INSERT INTO `sys_job_log` VALUES (1025, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 21:24:00');
INSERT INTO `sys_job_log` VALUES (1026, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 21:25:00');
INSERT INTO `sys_job_log` VALUES (1027, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-29 21:26:00');
INSERT INTO `sys_job_log` VALUES (1028, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 21:27:00');
INSERT INTO `sys_job_log` VALUES (1029, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 21:28:00');
INSERT INTO `sys_job_log` VALUES (1030, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 21:29:00');
INSERT INTO `sys_job_log` VALUES (1031, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-29 21:30:00');
INSERT INTO `sys_job_log` VALUES (1032, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：11毫秒', '0', '', '2026-03-29 21:31:00');
INSERT INTO `sys_job_log` VALUES (1033, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：11毫秒', '0', '', '2026-03-29 21:32:00');
INSERT INTO `sys_job_log` VALUES (1034, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：5毫秒', '0', '', '2026-03-29 21:33:00');
INSERT INTO `sys_job_log` VALUES (1035, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 21:34:00');
INSERT INTO `sys_job_log` VALUES (1036, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 21:35:00');
INSERT INTO `sys_job_log` VALUES (1037, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-29 21:36:00');
INSERT INTO `sys_job_log` VALUES (1038, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-29 21:37:00');
INSERT INTO `sys_job_log` VALUES (1039, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 21:38:00');
INSERT INTO `sys_job_log` VALUES (1040, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：4毫秒', '0', '', '2026-03-29 21:39:00');
INSERT INTO `sys_job_log` VALUES (1041, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 21:40:00');
INSERT INTO `sys_job_log` VALUES (1042, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：3毫秒', '0', '', '2026-03-29 21:41:00');
INSERT INTO `sys_job_log` VALUES (1043, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：35毫秒', '0', '', '2026-03-29 21:43:00');
INSERT INTO `sys_job_log` VALUES (1044, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：11毫秒', '0', '', '2026-03-29 21:44:00');
INSERT INTO `sys_job_log` VALUES (1045, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：8毫秒', '0', '', '2026-03-29 21:45:00');
INSERT INTO `sys_job_log` VALUES (1046, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：6毫秒', '0', '', '2026-03-29 21:46:00');
INSERT INTO `sys_job_log` VALUES (1047, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：8毫秒', '0', '', '2026-03-29 21:47:00');
INSERT INTO `sys_job_log` VALUES (1048, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：12毫秒', '0', '', '2026-03-29 21:48:00');
INSERT INTO `sys_job_log` VALUES (1049, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-29 21:49:00');
INSERT INTO `sys_job_log` VALUES (1050, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：7毫秒', '0', '', '2026-03-29 21:50:00');
INSERT INTO `sys_job_log` VALUES (1051, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：8毫秒', '0', '', '2026-03-29 21:51:00');
INSERT INTO `sys_job_log` VALUES (1052, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：8毫秒', '0', '', '2026-03-29 21:52:00');
INSERT INTO `sys_job_log` VALUES (1053, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：12毫秒', '0', '', '2026-03-29 21:53:00');
INSERT INTO `sys_job_log` VALUES (1054, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：37毫秒', '0', '', '2026-03-29 21:54:00');
INSERT INTO `sys_job_log` VALUES (1055, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：20毫秒', '0', '', '2026-03-29 21:55:00');
INSERT INTO `sys_job_log` VALUES (1056, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：19毫秒', '0', '', '2026-03-29 21:56:00');
INSERT INTO `sys_job_log` VALUES (1057, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：20毫秒', '0', '', '2026-03-29 21:57:00');
INSERT INTO `sys_job_log` VALUES (1058, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：13毫秒', '0', '', '2026-03-29 21:58:00');
INSERT INTO `sys_job_log` VALUES (1059, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：31毫秒', '0', '', '2026-03-29 22:00:00');
INSERT INTO `sys_job_log` VALUES (1060, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：19毫秒', '0', '', '2026-03-29 22:01:00');
INSERT INTO `sys_job_log` VALUES (1061, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：14毫秒', '0', '', '2026-03-29 22:02:00');
INSERT INTO `sys_job_log` VALUES (1062, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：26毫秒', '0', '', '2026-03-29 22:03:00');
INSERT INTO `sys_job_log` VALUES (1063, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：15毫秒', '0', '', '2026-03-29 22:04:00');
INSERT INTO `sys_job_log` VALUES (1064, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：23毫秒', '0', '', '2026-03-29 22:06:00');
INSERT INTO `sys_job_log` VALUES (1065, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：18毫秒', '0', '', '2026-03-29 22:07:00');
INSERT INTO `sys_job_log` VALUES (1066, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：16毫秒', '0', '', '2026-03-29 22:08:00');
INSERT INTO `sys_job_log` VALUES (1067, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：21毫秒', '0', '', '2026-03-29 22:09:00');
INSERT INTO `sys_job_log` VALUES (1068, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：12毫秒', '0', '', '2026-03-29 22:10:00');
INSERT INTO `sys_job_log` VALUES (1069, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：100毫秒', '0', '', '2026-03-29 22:11:00');
INSERT INTO `sys_job_log` VALUES (1070, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：15毫秒', '0', '', '2026-03-29 22:12:00');
INSERT INTO `sys_job_log` VALUES (1071, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：14毫秒', '0', '', '2026-03-29 22:13:00');
INSERT INTO `sys_job_log` VALUES (1072, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：13毫秒', '0', '', '2026-03-29 22:14:00');
INSERT INTO `sys_job_log` VALUES (1073, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：26毫秒', '0', '', '2026-03-29 22:16:00');
INSERT INTO `sys_job_log` VALUES (1074, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：18毫秒', '0', '', '2026-03-29 22:17:00');
INSERT INTO `sys_job_log` VALUES (1075, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：17毫秒', '0', '', '2026-03-29 22:18:00');
INSERT INTO `sys_job_log` VALUES (1076, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：18毫秒', '0', '', '2026-03-29 22:19:00');
INSERT INTO `sys_job_log` VALUES (1077, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：28毫秒', '0', '', '2026-03-29 22:20:00');
INSERT INTO `sys_job_log` VALUES (1078, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：21毫秒', '0', '', '2026-03-29 22:21:00');
INSERT INTO `sys_job_log` VALUES (1079, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：16毫秒', '0', '', '2026-03-29 22:22:00');
INSERT INTO `sys_job_log` VALUES (1080, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：14毫秒', '0', '', '2026-03-29 22:23:00');
INSERT INTO `sys_job_log` VALUES (1081, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：49毫秒', '0', '', '2026-03-29 22:24:00');
INSERT INTO `sys_job_log` VALUES (1082, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：41毫秒', '0', '', '2026-03-29 22:25:00');
INSERT INTO `sys_job_log` VALUES (1083, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：32毫秒', '0', '', '2026-03-29 22:26:00');
INSERT INTO `sys_job_log` VALUES (1084, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：30毫秒', '0', '', '2026-03-29 22:27:00');
INSERT INTO `sys_job_log` VALUES (1085, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：29毫秒', '0', '', '2026-03-29 22:28:00');
INSERT INTO `sys_job_log` VALUES (1086, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：26毫秒', '0', '', '2026-03-29 22:29:00');
INSERT INTO `sys_job_log` VALUES (1087, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：26毫秒', '0', '', '2026-03-29 22:30:00');
INSERT INTO `sys_job_log` VALUES (1088, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：25毫秒', '0', '', '2026-03-29 22:31:00');
INSERT INTO `sys_job_log` VALUES (1089, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：132毫秒', '0', '', '2026-03-29 22:32:00');
INSERT INTO `sys_job_log` VALUES (1090, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：24毫秒', '0', '', '2026-03-29 22:33:00');
INSERT INTO `sys_job_log` VALUES (1091, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：29毫秒', '0', '', '2026-03-29 22:34:00');
INSERT INTO `sys_job_log` VALUES (1092, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：23毫秒', '0', '', '2026-03-29 22:35:00');
INSERT INTO `sys_job_log` VALUES (1093, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：23毫秒', '0', '', '2026-03-29 22:36:00');
INSERT INTO `sys_job_log` VALUES (1094, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：22毫秒', '0', '', '2026-03-29 22:37:00');
INSERT INTO `sys_job_log` VALUES (1095, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：26毫秒', '0', '', '2026-03-29 22:38:00');
INSERT INTO `sys_job_log` VALUES (1096, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：28毫秒', '0', '', '2026-03-29 22:39:00');
INSERT INTO `sys_job_log` VALUES (1097, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：22毫秒', '0', '', '2026-03-29 22:40:00');
INSERT INTO `sys_job_log` VALUES (1098, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：27毫秒', '0', '', '2026-03-29 22:41:00');
INSERT INTO `sys_job_log` VALUES (1099, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：24毫秒', '0', '', '2026-03-29 22:42:00');
INSERT INTO `sys_job_log` VALUES (1100, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：24毫秒', '0', '', '2026-03-29 22:43:00');
INSERT INTO `sys_job_log` VALUES (1101, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：23毫秒', '0', '', '2026-03-29 22:44:00');
INSERT INTO `sys_job_log` VALUES (1102, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：25毫秒', '0', '', '2026-03-29 22:45:00');
INSERT INTO `sys_job_log` VALUES (1103, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：26毫秒', '0', '', '2026-03-29 22:46:00');
INSERT INTO `sys_job_log` VALUES (1104, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：24毫秒', '0', '', '2026-03-29 22:47:00');
INSERT INTO `sys_job_log` VALUES (1105, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：22毫秒', '0', '', '2026-03-29 22:48:00');
INSERT INTO `sys_job_log` VALUES (1106, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：24毫秒', '0', '', '2026-03-29 22:49:00');
INSERT INTO `sys_job_log` VALUES (1107, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：24毫秒', '0', '', '2026-03-29 22:50:00');
INSERT INTO `sys_job_log` VALUES (1108, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：23毫秒', '0', '', '2026-03-29 22:51:00');
INSERT INTO `sys_job_log` VALUES (1109, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：23毫秒', '0', '', '2026-03-29 22:52:00');
INSERT INTO `sys_job_log` VALUES (1110, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：24毫秒', '0', '', '2026-03-29 22:53:00');
INSERT INTO `sys_job_log` VALUES (1111, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：26毫秒', '0', '', '2026-03-29 22:54:00');
INSERT INTO `sys_job_log` VALUES (1112, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：22毫秒', '0', '', '2026-03-29 22:55:00');
INSERT INTO `sys_job_log` VALUES (1113, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：189毫秒', '0', '', '2026-03-30 22:53:00');
INSERT INTO `sys_job_log` VALUES (1114, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：29毫秒', '0', '', '2026-03-30 22:54:00');
INSERT INTO `sys_job_log` VALUES (1115, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：31毫秒', '0', '', '2026-03-30 22:55:00');
INSERT INTO `sys_job_log` VALUES (1116, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：26毫秒', '0', '', '2026-03-30 22:56:00');
INSERT INTO `sys_job_log` VALUES (1117, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：27毫秒', '0', '', '2026-03-30 22:57:00');
INSERT INTO `sys_job_log` VALUES (1118, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：87毫秒', '0', '', '2026-04-21 13:57:00');
INSERT INTO `sys_job_log` VALUES (1119, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：35毫秒', '0', '', '2026-04-21 13:58:00');
INSERT INTO `sys_job_log` VALUES (1120, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：28毫秒', '0', '', '2026-04-21 13:59:00');
INSERT INTO `sys_job_log` VALUES (1121, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：57毫秒', '0', '', '2026-04-21 14:00:00');
INSERT INTO `sys_job_log` VALUES (1122, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：37毫秒', '0', '', '2026-04-21 14:01:00');
INSERT INTO `sys_job_log` VALUES (1123, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：27毫秒', '0', '', '2026-04-21 14:02:00');
INSERT INTO `sys_job_log` VALUES (1124, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：29毫秒', '0', '', '2026-04-21 14:03:00');
INSERT INTO `sys_job_log` VALUES (1125, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：31毫秒', '0', '', '2026-04-21 14:04:00');
INSERT INTO `sys_job_log` VALUES (1126, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：23毫秒', '0', '', '2026-04-21 14:05:00');
INSERT INTO `sys_job_log` VALUES (1127, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：24毫秒', '0', '', '2026-04-21 14:06:00');
INSERT INTO `sys_job_log` VALUES (1128, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：23毫秒', '0', '', '2026-04-21 14:07:00');
INSERT INTO `sys_job_log` VALUES (1129, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：37毫秒', '0', '', '2026-04-21 14:08:00');
INSERT INTO `sys_job_log` VALUES (1130, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：23毫秒', '0', '', '2026-04-21 14:09:00');
INSERT INTO `sys_job_log` VALUES (1131, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：25毫秒', '0', '', '2026-04-21 14:10:00');
INSERT INTO `sys_job_log` VALUES (1132, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：22毫秒', '0', '', '2026-04-21 14:11:00');
INSERT INTO `sys_job_log` VALUES (1133, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：24毫秒', '0', '', '2026-04-21 14:12:00');
INSERT INTO `sys_job_log` VALUES (1134, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：22毫秒', '0', '', '2026-04-21 14:13:00');
INSERT INTO `sys_job_log` VALUES (1135, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：25毫秒', '0', '', '2026-04-21 14:14:00');
INSERT INTO `sys_job_log` VALUES (1136, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：28毫秒', '0', '', '2026-04-21 14:15:00');
INSERT INTO `sys_job_log` VALUES (1137, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：25毫秒', '0', '', '2026-04-21 14:16:00');
INSERT INTO `sys_job_log` VALUES (1138, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：23毫秒', '0', '', '2026-04-21 14:17:00');
INSERT INTO `sys_job_log` VALUES (1139, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：24毫秒', '0', '', '2026-04-21 14:18:00');
INSERT INTO `sys_job_log` VALUES (1140, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：29毫秒', '0', '', '2026-04-21 14:19:00');
INSERT INTO `sys_job_log` VALUES (1141, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：27毫秒', '0', '', '2026-04-21 14:20:00');
INSERT INTO `sys_job_log` VALUES (1142, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：22毫秒', '0', '', '2026-04-21 14:21:00');
INSERT INTO `sys_job_log` VALUES (1143, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：20毫秒', '0', '', '2026-04-21 14:22:00');
INSERT INTO `sys_job_log` VALUES (1144, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：21毫秒', '0', '', '2026-04-21 14:23:00');
INSERT INTO `sys_job_log` VALUES (1145, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：21毫秒', '0', '', '2026-04-21 14:24:00');
INSERT INTO `sys_job_log` VALUES (1146, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：22毫秒', '0', '', '2026-04-21 14:25:00');
INSERT INTO `sys_job_log` VALUES (1147, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：22毫秒', '0', '', '2026-04-21 14:26:00');
INSERT INTO `sys_job_log` VALUES (1148, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：53毫秒', '0', '', '2026-04-21 14:27:00');
INSERT INTO `sys_job_log` VALUES (1149, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：44毫秒', '0', '', '2026-04-21 14:28:00');
INSERT INTO `sys_job_log` VALUES (1150, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：33毫秒', '0', '', '2026-04-21 14:29:00');
INSERT INTO `sys_job_log` VALUES (1151, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：32毫秒', '0', '', '2026-04-21 14:30:00');
INSERT INTO `sys_job_log` VALUES (1152, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：30毫秒', '0', '', '2026-04-21 14:31:00');
INSERT INTO `sys_job_log` VALUES (1153, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：26毫秒', '0', '', '2026-04-21 14:32:00');
INSERT INTO `sys_job_log` VALUES (1154, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：28毫秒', '0', '', '2026-04-21 14:33:00');
INSERT INTO `sys_job_log` VALUES (1155, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：24毫秒', '0', '', '2026-04-21 14:34:00');
INSERT INTO `sys_job_log` VALUES (1156, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：29毫秒', '0', '', '2026-04-21 14:35:00');
INSERT INTO `sys_job_log` VALUES (1157, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：30毫秒', '0', '', '2026-04-21 14:36:00');
INSERT INTO `sys_job_log` VALUES (1158, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：35毫秒', '0', '', '2026-04-21 14:37:00');
INSERT INTO `sys_job_log` VALUES (1159, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：26毫秒', '0', '', '2026-04-21 14:38:00');
INSERT INTO `sys_job_log` VALUES (1160, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：23毫秒', '0', '', '2026-04-21 14:39:00');
INSERT INTO `sys_job_log` VALUES (1161, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：22毫秒', '0', '', '2026-04-21 14:40:00');
INSERT INTO `sys_job_log` VALUES (1162, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：21毫秒', '0', '', '2026-04-21 14:41:00');
INSERT INTO `sys_job_log` VALUES (1163, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：21毫秒', '0', '', '2026-04-21 14:42:00');
INSERT INTO `sys_job_log` VALUES (1164, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：22毫秒', '0', '', '2026-04-21 14:43:00');
INSERT INTO `sys_job_log` VALUES (1165, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：21毫秒', '0', '', '2026-04-21 14:44:00');
INSERT INTO `sys_job_log` VALUES (1166, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：22毫秒', '0', '', '2026-04-21 14:45:00');
INSERT INTO `sys_job_log` VALUES (1167, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：21毫秒', '0', '', '2026-04-21 14:46:00');
INSERT INTO `sys_job_log` VALUES (1168, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：21毫秒', '0', '', '2026-04-21 14:47:00');
INSERT INTO `sys_job_log` VALUES (1169, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：21毫秒', '0', '', '2026-04-21 14:48:00');
INSERT INTO `sys_job_log` VALUES (1170, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：21毫秒', '0', '', '2026-04-21 14:49:00');
INSERT INTO `sys_job_log` VALUES (1171, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：21毫秒', '0', '', '2026-04-21 14:50:00');
INSERT INTO `sys_job_log` VALUES (1172, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：51毫秒', '0', '', '2026-04-21 18:27:00');
INSERT INTO `sys_job_log` VALUES (1173, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：42毫秒', '0', '', '2026-04-21 18:28:00');
INSERT INTO `sys_job_log` VALUES (1174, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：34毫秒', '0', '', '2026-04-21 18:29:00');
INSERT INTO `sys_job_log` VALUES (1175, '检查报警', 'DEFAULT', 'maintenanceFormService.notifyDevicesRequiringMaintenance', '检查报警 总共耗时：28毫秒', '0', '', '2026-04-21 18:30:00');

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
) ENGINE = InnoDB AUTO_INCREMENT = 257 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统访问记录' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `sys_logininfor` VALUES (249, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-03-27 00:07:07');
INSERT INTO `sys_logininfor` VALUES (250, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-03-27 08:13:43');
INSERT INTO `sys_logininfor` VALUES (251, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-03-27 09:19:42');
INSERT INTO `sys_logininfor` VALUES (252, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-03-29 11:42:18');
INSERT INTO `sys_logininfor` VALUES (253, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-03-29 15:15:55');
INSERT INTO `sys_logininfor` VALUES (254, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-03-29 21:08:05');
INSERT INTO `sys_logininfor` VALUES (255, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-03-30 22:52:23');
INSERT INTO `sys_logininfor` VALUES (256, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-04-21 13:57:37');

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
) ENGINE = InnoDB AUTO_INCREMENT = 2144 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '菜单权限表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `sys_menu` VALUES (226, '预测结果', 210, 16, 'prediction', 'equipment/prediction/index', NULL, '', 1, 0, 'C', '0', '0', 'equipment:prediction:list', 'education', 'admin', '2026-05-11 12:00:00', '', NULL, '预测结果菜单');
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
INSERT INTO `sys_menu` VALUES (227, '预测结果查询', 226, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:prediction:query', '#', 'admin', '2026-05-11 12:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (228, '预测结果新增', 226, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:prediction:add', '#', 'admin', '2026-05-11 12:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (229, '预测结果修改', 226, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:prediction:edit', '#', 'admin', '2026-05-11 12:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (230, '预测结果删除', 226, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'equipment:prediction:remove', '#', 'admin', '2026-05-11 12:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (231, '预测数据', 210, 17, 'prediction-data', 'equipment/predictionData/index', NULL, '', 1, 0, 'C', '0', '0', 'equipment:prediction:list', 'chart', 'admin', '2026-05-11 12:00:00', '', NULL, '数据获取-预测数据（eq_prediction）');

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
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '通知公告表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 244 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '操作日志记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (101, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"email\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuName\":\"邮件\",\"menuType\":\"M\",\"orderNum\":9,\"params\":{},\"parentId\":0,\"path\":\"email\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"新增菜单\'邮件\'失败，地址必须以http(s)://开头\",\"code\":500}', 0, NULL, '2025-10-31 16:20:05', 8);
INSERT INTO `sys_oper_log` VALUES (102, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/menu/index\",\"createTime\":\"2025-10-31 15:23:03\",\"icon\":\"tree-table\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":102,\"menuName\":\"菜单管理\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":1,\"path\":\"menu\",\"perms\":\"system:menu:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 16:26:30', 8);
INSERT INTO `sys_oper_log` VALUES (103, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/menu/index\",\"createTime\":\"2025-10-31 15:23:03\",\"icon\":\"tree-table\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":102,\"menuName\":\"菜单管理\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"menu\",\"perms\":\"system:menu:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 16:26:55', 7);
INSERT INTO `sys_oper_log` VALUES (104, '角色管理', 1, 'com.ruoyi.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[102,1012,1013,1014,1015],\"params\":{},\"remark\":\"666\",\"roleId\":100,\"roleKey\":\"0\",\"roleName\":\"ooo\",\"roleSort\":3,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 16:28:44', 15);
INSERT INTO `sys_oper_log` VALUES (105, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"小板\",\"params\":{},\"postIds\":[],\"roleIds\":[],\"status\":\"0\",\"userId\":100,\"userName\":\"xb\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 16:29:38', 96);
INSERT INTO `sys_oper_log` VALUES (106, '角色管理', 4, 'com.ruoyi.web.controller.system.SysRoleController.selectAuthUserAll()', 'PUT', 1, 'admin', '研发部门', '/system/role/authUser/selectAll', '127.0.0.1', '内网IP', '{\"roleId\":\"100\",\"userIds\":\"100\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 16:31:04', 4);
INSERT INTO `sys_oper_log` VALUES (107, '字典类型', 1, 'com.ruoyi.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"课程学科\",\"dictType\":\"course_subject\",\"params\":{},\"remark\":\"课程学科\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 16:37:20', 9);
INSERT INTO `sys_oper_log` VALUES (108, '字典类型', 5, 'com.ruoyi.web.controller.system.SysDictTypeController.export()', 'POST', 1, 'admin', '研发部门', '/system/dict/type/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"dictName\":\"课程学科\",\"pageNum\":\"2\"}', NULL, 0, NULL, '2025-10-31 16:41:30', 660);
INSERT INTO `sys_oper_log` VALUES (112, '字典类型', 9, 'com.ruoyi.web.controller.system.SysDictTypeController.refreshCache()', 'DELETE', 1, 'admin', '研发部门', '/system/dict/type/refreshCache', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 16:46:32', 9);
INSERT INTO `sys_oper_log` VALUES (113, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"cssClass\":\"11\",\"default\":false,\"dictLabel\":\"int\",\"dictSort\":5,\"dictType\":\"course_subject\",\"dictValue\":\"www\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 16:48:07', 7);
INSERT INTO `sys_oper_log` VALUES (114, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-10-31 16:48:07\",\"cssClass\":\"11\",\"default\":false,\"dictCode\":100,\"dictLabel\":\"int\",\"dictSort\":5,\"dictType\":\"course_subject\",\"dictValue\":\"www\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"remark\":\"你好\\n\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 16:48:22', 8);
INSERT INTO `sys_oper_log` VALUES (115, '字典数据', 5, 'com.ruoyi.web.controller.system.SysDictDataController.export()', 'POST', 1, 'admin', '研发部门', '/system/dict/data/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\",\"dictType\":\"course_subject\"}', NULL, 0, NULL, '2025-10-31 16:49:22', 29);
INSERT INTO `sys_oper_log` VALUES (116, '字典数据', 5, 'com.ruoyi.web.controller.system.SysDictDataController.export()', 'POST', 1, 'admin', '研发部门', '/system/dict/data/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\",\"dictType\":\"course_subject\"}', NULL, 0, NULL, '2025-10-31 16:49:25', 24);
INSERT INTO `sys_oper_log` VALUES (117, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"cssClass\":\"22\",\"default\":false,\"dictLabel\":\"一样\",\"dictSort\":4,\"dictType\":\"course_subject\",\"dictValue\":\"22\",\"listClass\":\"default\",\"params\":{},\"remark\":\"我好\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 16:50:32', 8);
INSERT INTO `sys_oper_log` VALUES (121, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-10-31 16:50:32\",\"cssClass\":\"1\",\"default\":false,\"dictCode\":101,\"dictLabel\":\"一样\",\"dictSort\":4,\"dictType\":\"course_subject\",\"dictValue\":\"1\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"remark\":\"我好\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 17:13:05', 6);
INSERT INTO `sys_oper_log` VALUES (122, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-10-31 16:48:07\",\"cssClass\":\"1\",\"default\":false,\"dictCode\":100,\"dictLabel\":\"1\",\"dictSort\":5,\"dictType\":\"course_subject\",\"dictValue\":\"1\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"remark\":\"你好\\n\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 17:13:13', 6);
INSERT INTO `sys_oper_log` VALUES (123, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-10-31 16:50:32\",\"cssClass\":\"2\",\"default\":false,\"dictCode\":101,\"dictLabel\":\"2\",\"dictSort\":4,\"dictType\":\"course_subject\",\"dictValue\":\"2\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"remark\":\"我好\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 17:13:20', 6);
INSERT INTO `sys_oper_log` VALUES (124, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-10-31 16:48:07\",\"cssClass\":\"1\",\"default\":false,\"dictCode\":100,\"dictLabel\":\"1\",\"dictSort\":10,\"dictType\":\"course_subject\",\"dictValue\":\"1\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"remark\":\"你好\\n\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 17:13:28', 5);
INSERT INTO `sys_oper_log` VALUES (125, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-10-31 16:50:32\",\"cssClass\":\"2\",\"default\":false,\"dictCode\":101,\"dictLabel\":\"2\",\"dictSort\":10,\"dictType\":\"course_subject\",\"dictValue\":\"2\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"remark\":\"我好\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 17:13:33', 6);
INSERT INTO `sys_oper_log` VALUES (126, '字典数据', 5, 'com.ruoyi.web.controller.system.SysDictDataController.export()', 'POST', 1, 'admin', '研发部门', '/system/dict/data/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\",\"dictType\":\"course_subject\"}', NULL, 0, NULL, '2025-10-31 17:13:52', 22);
INSERT INTO `sys_oper_log` VALUES (127, '字典类型', 9, 'com.ruoyi.web.controller.system.SysDictTypeController.refreshCache()', 'DELETE', 1, 'admin', '研发部门', '/system/dict/type/refreshCache', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 17:14:00', 9);
INSERT INTO `sys_oper_log` VALUES (131, '用户', 1, 'com.ruoyi.system.controller.TUserController.add()', 'POST', 1, 'admin', '研发部门', '/jingyes/user', '127.0.0.1', '内网IP', '{\"age\":22,\"gender\":1,\"id\":\"1\",\"name\":\"俄格\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 17:39:28', 132);
INSERT INTO `sys_oper_log` VALUES (132, '用户', 2, 'com.ruoyi.system.controller.TUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/jingyes/user', '127.0.0.1', '内网IP', '{\"age\":22,\"gender\":0,\"id\":\"1\",\"name\":\"俄格\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 17:39:33', 6);
INSERT INTO `sys_oper_log` VALUES (133, '用户', 1, 'com.ruoyi.system.controller.TUserController.add()', 'POST', 1, 'admin', '研发部门', '/jingyes/user', '127.0.0.1', '内网IP', '{\"age\":22,\"gender\":1,\"id\":\"2\",\"name\":\"买买买\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 17:39:46', 5);
INSERT INTO `sys_oper_log` VALUES (134, '用户', 3, 'com.ruoyi.system.controller.TUserController.remove()', 'DELETE', 1, 'admin', '研发部门', '/jingyes/user/1', '127.0.0.1', '内网IP', '[\"1\"]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-31 17:40:10', 6);
INSERT INTO `sys_oper_log` VALUES (135, '字典类型', 2, 'com.ruoyi.web.controller.system.SysDictTypeController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-10-31 16:37:20\",\"dictId\":100,\"dictName\":\"课程学科\",\"dictType\":\"course_subject\",\"params\":{},\"remark\":\"课程学科\",\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 08:30:14', 22);
INSERT INTO `sys_oper_log` VALUES (139, '用户', 1, 'com.ruoyi.qcluser.controller.QclUserController.add()', 'POST', 1, 'admin', '研发部门', '/qcluser/qcluser', '127.0.0.1', '内网IP', '{\"age\":22,\"education\":\"本科\",\"id\":1,\"name\":\"王对\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 09:14:09', 10);
INSERT INTO `sys_oper_log` VALUES (144, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"chart\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"商品管理\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"good\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 09:20:11', 9);
INSERT INTO `sys_oper_log` VALUES (150, '用户', 1, 'com.ruoyi.system.controller.TUserController.add()', 'POST', 1, 'admin', '研发部门', '/jingyes/user', '127.0.0.1', '内网IP', '{\"age\":1,\"gender\":0,\"id\":\"3\",\"name\":\"55\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 10:58:17', 13);
INSERT INTO `sys_oper_log` VALUES (155, '字典类型', 9, 'com.ruoyi.web.controller.system.SysDictTypeController.refreshCache()', 'DELETE', 1, 'admin', '研发部门', '/system/dict/type/refreshCache', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-03 16:13:49', 15);
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
INSERT INTO `sys_oper_log` VALUES (235, '告警记录', 2, 'com.ruoyi.web.controller.equipment.EqAlertRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/alertRecord', '127.0.0.1', '内网IP', '{\"alertId\":3,\"alertLevel\":1,\"alertMessage\":\"电流波动异常\",\"deviceId\":1,\"deviceName\":\"主变压器1号\",\"deviceNo\":\"DEV-001\",\"params\":{},\"remark\":\"常规告警\",\"resolutionNotes\":\"已检查并确认，恢复正常\",\"resolvedBy\":0,\"status\":2,\"triggeredTime\":\"2026-01-11 16:01:33\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-27 08:18:20', 13);
INSERT INTO `sys_oper_log` VALUES (236, '设备运行状态', 2, 'com.ruoyi.web.controller.equipment.EqDeviceStatusController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/deviceStatus', '127.0.0.1', '内网IP', '{\"airQuality\":95,\"alarmCount\":11,\"ambientHumidity\":54.9,\"ambientTemp\":24.8,\"current\":0,\"deviceId\":1,\"deviceName\":\"主变压器1号\",\"deviceNo\":\"DEV-001\",\"efficiency\":95.9,\"faultCount\":1,\"flowRate\":60.6,\"humidity\":44.5,\"liquidLevel\":73.7,\"loadFactor\":0.93,\"maintenanceRequired\":0,\"noiseLevel\":73.8,\"params\":{},\"power\":16.7,\"pressure\":102.3,\"remark\":\"运行正常\",\"rpm\":1440,\"runtimeHours\":25708,\"startCount\":181,\"status\":1,\"statusId\":2,\"temperature\":80,\"timestamp\":\"2026-01-11 23:01:11\",\"vibration\":1.43,\"voltage\":112}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'current_val\' in \'field list\'\r\n### The error may exist in file [D:\\项目\\biye\\ruoyi-system\\target\\classes\\mapper\\system\\EqDeviceStatusMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.EqDeviceStatusMapper.updateEqDeviceStatus-Inline\r\n### The error occurred while setting parameters\r\n### SQL: update eq_device_status          SET device_id = ?,             timestamp = ?,             temperature = ?,             humidity = ?,             pressure = ?,             vibration = ?,             current_val = ?,             voltage = ?,             power = ?,             rpm = ?,             flow_rate = ?,             liquid_level = ?,             status = ?,             runtime_hours = ?,             start_count = ?,             fault_count = ?,             alarm_count = ?,             efficiency = ?,             load_factor = ?,             ambient_temp = ?,             ambient_humidity = ?,             noise_level = ?,             air_quality = ?,                                       maintenance_required = ?,             remark = ?          where status_id = ?\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'current_val\' in \'field list\'\n; bad SQL grammar []', '2026-03-27 08:27:15', 96);
INSERT INTO `sys_oper_log` VALUES (237, '设备运行状态', 2, 'com.ruoyi.web.controller.equipment.EqDeviceStatusController.edit()', 'PUT', 1, 'admin', '研发部门', '/equipment/deviceStatus', '127.0.0.1', '内网IP', '{\"airQuality\":95,\"alarmCount\":11,\"ambientHumidity\":54.9,\"ambientTemp\":24.8,\"current\":165.7,\"deviceId\":1,\"deviceName\":\"主变压器1号\",\"deviceNo\":\"DEV-001\",\"efficiency\":95.9,\"faultCount\":1,\"flowRate\":60.6,\"humidity\":44.5,\"liquidLevel\":73.7,\"loadFactor\":0.93,\"maintenanceRequired\":0,\"noiseLevel\":73.8,\"params\":{},\"power\":16.7,\"pressure\":102.3,\"remark\":\"运行正常\",\"rpm\":1440,\"runtimeHours\":25708,\"startCount\":181,\"status\":1,\"statusId\":2,\"temperature\":188,\"timestamp\":\"2026-01-11 23:01:11\",\"vibration\":1.43,\"voltage\":112}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-27 08:33:35', 36);
INSERT INTO `sys_oper_log` VALUES (238, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'admin', '研发部门', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/03/29/3ead25acb8024d36b5696f32fb99d4b6.jpg\",\"code\":200}', 0, NULL, '2026-03-29 19:16:13', 50);
INSERT INTO `sys_oper_log` VALUES (239, '定时任务', 2, 'com.ruoyi.quartz.controller.SysJobController.edit()', 'PUT', 1, 'admin', '研发部门', '/monitor/job', '127.0.0.1', '内网IP', '', '{\"msg\":\"修改任务\'检查报警\'失败，Cron表达式不正确\",\"code\":500}', 0, NULL, '2026-03-29 21:35:19', 7);
INSERT INTO `sys_oper_log` VALUES (240, '设备统计', 3, 'com.ruoyi.web.controller.equipment.EqDeviceStatController.remove()', 'DELETE', 1, 'admin', '研发部门', '/equipment/deviceStat/143', '127.0.0.1', '内网IP', '[143]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-29 21:37:26', 9);
INSERT INTO `sys_oper_log` VALUES (241, '设备统计', 3, 'com.ruoyi.web.controller.equipment.EqDeviceStatController.remove()', 'DELETE', 1, 'admin', '研发部门', '/equipment/deviceStat/145', '127.0.0.1', '内网IP', '[145]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-29 21:57:49', 8);
INSERT INTO `sys_oper_log` VALUES (242, '设备统计', 3, 'com.ruoyi.web.controller.equipment.EqDeviceStatController.remove()', 'DELETE', 1, 'admin', '研发部门', '/equipment/deviceStat/144', '127.0.0.1', '内网IP', '[144]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-29 21:57:53', 3);
INSERT INTO `sys_oper_log` VALUES (243, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '研发部门', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"3047969285@qq.com\",\"nickName\":\"王昌振\",\"params\":{},\"phonenumber\":\"18853471291\",\"sex\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-04-21 14:41:45', 9);

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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '岗位信息表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色信息表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色和部门关联表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (1, 200);
INSERT INTO `sys_role_menu` VALUES (1, 201);
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
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '王昌振', '00', '3047969285@qq.com', '18853471291', '0', '/profile/avatar/2026/03/29/3ead25acb8024d36b5696f32fb99d4b6.jpg', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-03-30 22:52:24', '2025-10-31 15:23:03', 'admin', '2025-10-31 15:23:03', '', '2026-04-21 14:41:45', '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', '504204693@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-10-31 15:23:03', '2025-10-31 15:23:03', 'admin', '2025-10-31 15:23:03', 'admin', '2026-01-08 01:44:50', '测试员');
INSERT INTO `sys_user` VALUES (100, NULL, 'xb', '小板', '00', '', '', '0', '', '$2a$10$pAzOgZkw25WiXECl0AXJeOaibPlYbXTMrHkTg04Ydys6vN2MCcmkC', '0', '0', '127.0.0.1', '2025-10-31 16:31:15', NULL, 'admin', '2025-10-31 16:29:38', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_user_message
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_message`;
CREATE TABLE `sys_user_message`  (
  `msg_id` bigint NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `user_id` bigint NOT NULL COMMENT '接收用户ID',
  `msg_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'maintenance_form' COMMENT '消息类型',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '标题',
  `content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '摘要内容',
  `biz_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '业务主键：运维表单 form_id 或设备 device_id（UUID），统一字符串存储',
  `read_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '是否已读 0否 1是',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`msg_id`) USING BTREE,
  INDEX `idx_user_read`(`user_id` ASC, `read_flag` ASC) USING BTREE,
  INDEX `idx_user_time`(`user_id` ASC, `create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1234 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户站内消息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_message
-- ----------------------------
INSERT INTO `sys_user_message` VALUES (103, 1, 'maintenance_device_pending', '设备待维护', '设备「主变压器1号」当前需维护（优先级：高），请到运维表单页处理。', '7beaf415-6c5b-5e16-abd7-04c21500858d','1', '2026-03-29 21:56:00');
INSERT INTO `sys_user_message` VALUES (105, 1, 'maintenance_device_pending', '设备待维护', '设备「发电机1号」当前需维护（优先级：高），请到运维表单页处理。', '57330e93-592e-5318-b0c2-6d3ff8846bb6','1', '2026-03-29 21:56:00');
INSERT INTO `sys_user_message` VALUES (193, 1, 'maintenance_device_pending', '设备待维护', '设备「主变压器1号」当前需维护（优先级：高），请到运维表单页处理。', '7beaf415-6c5b-5e16-abd7-04c21500858d','1', '2026-03-29 21:58:00');
INSERT INTO `sys_user_message` VALUES (195, 1, 'maintenance_device_pending', '设备待维护', '设备「发电机1号」当前需维护（优先级：高），请到运维表单页处理。', '57330e93-592e-5318-b0c2-6d3ff8846bb6','1', '2026-03-29 21:58:00');
INSERT INTO `sys_user_message` VALUES (373, 1, 'maintenance_device_pending', '设备待维护', '设备「主变压器1号」当前需维护（优先级：高），请到运维表单页处理。', '7beaf415-6c5b-5e16-abd7-04c21500858d','1', '2026-03-29 22:03:00');
INSERT INTO `sys_user_message` VALUES (375, 1, 'maintenance_device_pending', '设备待维护', '设备「发电机1号」当前需维护（优先级：高），请到运维表单页处理。', '57330e93-592e-5318-b0c2-6d3ff8846bb6','1', '2026-03-29 22:03:00');
INSERT INTO `sys_user_message` VALUES (469, 1, 'maintenance_device_pending', '设备待维护', '设备「主变压器1号」当前需维护（优先级：高），请到运维表单页处理。', '7beaf415-6c5b-5e16-abd7-04c21500858d','1', '2026-03-29 22:06:00');
INSERT INTO `sys_user_message` VALUES (471, 1, 'maintenance_device_pending', '设备待维护', '设备「发电机1号」当前需维护（优先级：高），请到运维表单页处理。', '57330e93-592e-5318-b0c2-6d3ff8846bb6','1', '2026-03-29 22:06:00');
INSERT INTO `sys_user_message` VALUES (559, 1, 'maintenance_device_pending', '设备待维护', '设备「主变压器1号」当前需维护（优先级：高），请到运维表单页处理。', '7beaf415-6c5b-5e16-abd7-04c21500858d','1', '2026-03-29 22:08:00');
INSERT INTO `sys_user_message` VALUES (561, 1, 'maintenance_device_pending', '设备待维护', '设备「发电机1号」当前需维护（优先级：高），请到运维表单页处理。', '57330e93-592e-5318-b0c2-6d3ff8846bb6','1', '2026-03-29 22:08:00');
INSERT INTO `sys_user_message` VALUES (1054, 1, 'maintenance_device_pending', '设备待维护', '设备「主变压器1号」当前需维护（优先级：高），请到运维表单页处理。', '7beaf415-6c5b-5e16-abd7-04c21500858d','1', '2026-03-29 22:20:00');
INSERT INTO `sys_user_message` VALUES (1056, 1, 'maintenance_device_pending', '设备待维护', '设备「发电机1号」当前需维护（优先级：高），请到运维表单页处理。', '57330e93-592e-5318-b0c2-6d3ff8846bb6','1', '2026-03-29 22:20:00');
INSERT INTO `sys_user_message` VALUES (1189, 1, 'maintenance_device_pending', '设备待维护', '设备「主变压器1号」当前需维护（优先级：高），请到运维表单页处理。', '7beaf415-6c5b-5e16-abd7-04c21500858d','1', '2026-03-29 22:23:00');
INSERT INTO `sys_user_message` VALUES (1191, 1, 'maintenance_device_pending', '设备待维护', '设备「发电机1号」当前需维护（优先级：高），请到运维表单页处理。', '57330e93-592e-5318-b0c2-6d3ff8846bb6','1', '2026-03-29 22:23:00');
INSERT INTO `sys_user_message` VALUES (1204, 2, 'maintenance_device_pending', '设备待维护', '设备「主变压器1号」当前需维护（优先级：高），请到运维表单页处理。', '7beaf415-6c5b-5e16-abd7-04c21500858d','0', '2026-03-29 22:23:00');
INSERT INTO `sys_user_message` VALUES (1206, 2, 'maintenance_device_pending', '设备待维护', '设备「发电机1号」当前需维护（优先级：高），请到运维表单页处理。', '57330e93-592e-5318-b0c2-6d3ff8846bb6','0', '2026-03-29 22:23:00');
INSERT INTO `sys_user_message` VALUES (1219, 100, 'maintenance_device_pending', '设备待维护', '设备「主变压器1号」当前需维护（优先级：高），请到运维表单页处理。', '7beaf415-6c5b-5e16-abd7-04c21500858d','0', '2026-03-29 22:23:00');
INSERT INTO `sys_user_message` VALUES (1221, 100, 'maintenance_device_pending', '设备待维护', '设备「发电机1号」当前需维护（优先级：高），请到运维表单页处理。', '57330e93-592e-5318-b0c2-6d3ff8846bb6','0', '2026-03-29 22:23:00');

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户和角色关联表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_user
-- ----------------------------
INSERT INTO `t_user` VALUES (2, '买买买', 22, 1);
INSERT INTO `t_user` VALUES (3, '55', 1, 0);

-- ----------------------------
-- 增量补丁合并（发电预测菜单纠偏 + 移除演示设备 21 + 告警/站内消息列数据）
-- Quartz 任务已写入上文 sys_job（job_id 100/101）；导入本文件后即入库，启动应用后按状态与 cron 调度。
-- 全新库：DELETE/UPDATE 无匹配行时安全；ALTER biz_id 与新建表一致时等价无变更。
-- bind-device-id 请在 application.yml wind.forecast 中与设备 UUID 对齐。
-- ----------------------------
DELETE FROM eq_device_stat WHERE device_id = '4f7a0ac3-4605-53a7-bf78-02d9a2b14fe6';
DELETE FROM eq_wind_forecast_bind WHERE device_id = '4f7a0ac3-4605-53a7-bf78-02d9a2b14fe6';
DELETE FROM eq_device WHERE device_id = '4f7a0ac3-4605-53a7-bf78-02d9a2b14fe6';

UPDATE sys_menu SET
  menu_name   = '发电预测',
  parent_id   = 0,
  order_num   = 3,
  path        = 'power-forecast',
  component   = 'powerForecast/index',
  query       = '',
  route_name  = '',
  is_frame    = 1,
  is_cache    = 0,
  menu_type   = 'C',
  visible     = '0',
  status      = '0',
  perms       = 'power:forecast:list',
  icon        = 'chart',
  remark      = '发电预测菜单（component 须与 ruoyi-ui/views/powerForecast/index.vue 一致）'
WHERE menu_id = 200;

-- ----------------------------
-- 告警 alert_type 回填 + 站内消息 biz_id 列纠偏（与增量补丁合并；全新库执行无害，旧库数值型 biz_id 可修复 UUID NOT IN 报错）
-- ----------------------------
UPDATE eq_alert_record
SET alert_type = TRIM(
        SUBSTRING_INDEX(
            SUBSTRING_INDEX(alert_message, '规则[', -1),
            ']',
            1
        )
    )
WHERE alert_message LIKE '%规则[%'
  AND alert_message LIKE '%]触发%'
  AND (alert_type IS NULL OR TRIM(alert_type) = '');

UPDATE eq_alert_record
SET alert_type = '规则告警'
WHERE (alert_type IS NULL OR TRIM(alert_type) = '')
  AND (rule_id IS NOT NULL OR remark LIKE '%规则引擎%');

UPDATE eq_alert_record
SET alert_type = '手工录入'
WHERE alert_type IS NULL OR TRIM(alert_type) = '';

ALTER TABLE sys_user_message
    MODIFY COLUMN biz_id varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL
    COMMENT '业务主键：运维表单 form_id 或设备 device_id（UUID），统一字符串存储';

SET FOREIGN_KEY_CHECKS = 1;
