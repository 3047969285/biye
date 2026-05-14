# -*- coding: utf-8 -*-
"""Restructure thesis: consolidate headings, trim content, sync TOC."""
import re

with open('generate_complete_thesis.py', 'r', encoding='utf-8') as f:
    content = f.read()

changes = 0

# ========== 1. Replace TOC ==========
old_toc_start = content.find("toc = [")
old_toc_end = content.find("]", old_toc_start)
# Find the closing ] of the toc list
old_toc = content[old_toc_start:old_toc_end+1]

new_toc = """toc = [
    '1 绪论 ............................................... 1',
    '  1.1 研究背景与意义 .................................. 1',
    '  1.2 国内外研究概况 .................................. 1',
    '  1.3 研究内容与章节安排 .............................. 2',
    '  1.4 主要工作与论文结构 .............................. 2',
    '2 系统需求分析 ........................................ 3',
    '  2.1 业务功能需求 .................................... 3',
    '  2.2 非功能与安全需求 ................................ 4',
    '  2.3 用例、质量属性与术语说明 ........................ 4',
    '3 系统总体设计 ........................................ 5',
    '  3.1 逻辑架构与技术选型 .............................. 5',
    '  3.2 数据库、业务流程与部署配置 ...................... 6',
    '4 系统详细设计与实现 ................................. 8',
    '  4.1 设备多维数据与状态管理 ......................... 8',
    '  4.2 规则评估与告警联动 ............................. 9',
    '  4.3 对话、RAG 与自然语言查库 ........................ 10',
    '  4.4 运维表单与预测服务集成 ......................... 11',
    '  4.5 消息推送、权限与工程化实现 ..................... 12',
    '5 系统测试 ........................................... 13',
    '  5.1 测试环境与功能验证 ............................. 13',
    '  5.2 性能、用例与兼容性 ............................. 14',
    '  5.3 局限性与答辩准备 ............................... 15',
    '6 总结与展望 ......................................... 16',
    '参考文献 ............................................. 17',
    '致谢 ................................................. 17',
    '附录A 核心数据库表结构 ............................... 18',
    '附录B 系统部署说明 ................................... 20',
]"""

content = content.replace(old_toc, new_toc, 1)
changes += 1
print("TOC updated")

# ========== 2. Replace Chapter 1 ==========
# Find Chapter 1 boundaries
ch1_start = content.find("h1(doc, '1  绪论')")
ch1_end = content.find("doc.add_page_break()", ch1_start)
# Find the page break AFTER chapter 1
ch1_pb = content.find("doc.add_page_break()", ch1_start + 10)
ch1_pb2 = content.find("doc.add_page_break()", ch1_pb + 5)

new_ch1 = """h1(doc, '1  绪论')

h2(doc, '1.1  研究背景与意义')
body(doc, (
    '电力系统作为国家能源基础设施的核心组成部分，其安全稳定运行直接关系到国民经济与社会生活的正常运转。'
    '随着智能电网建设的深入推进，电网规模持续扩大，设备种类与数量急剧增加，运维管理的复杂度也不断攀升。'
    '当前，电网运维工作普遍面临数据分散异构、知识获取成本高、告警信息孤岛和预测性维护能力不足等挑战。'
    '近年来，以大语言模型为代表的人工智能技术取得了突破性进展，Spring AI 框架作为 Java 生态中接入 AI 能力的重要桥梁，'
    '为 AI 与传统企业级应用的集成提供了标准化的编程模型。'
))
body(doc, (
    '在此背景下，本文设计并实现了一套基于 Spring AI 的智能电网运维管理平台，旨在通过融合大语言模型、'
    '检索增强生成（RAG）、时序预测等 AI 技术与传统运维业务，构建集设备管理、状态监测、智能问答、'
    '工单流转、功率预测于一体的综合性运维解决方案，提升故障响应与处理的效率。'
))

h2(doc, '1.2  国内外研究概况')
body(doc, (
    '在智能电网运维领域，国内外学者开展了广泛的研究工作。在设备状态监测方面，基于 SCADA 系统的在线监测技术'
    '已较为成熟，机器学习方法被广泛用于设备状态评估与故障诊断。高芳[12]对基于机器学习的电气设备故障检测方法'
    '进行了系统综述。在风电功率预测方面，刘茂强等[2]提出了基于 GRU 网络的超短期预测方法，取得了优于传统'
    'ARIMA 和 LSTM 网络的预测精度。张胜等[3]系统总结了深度学习在功率预测中的应用进展。'
))
body(doc, (
    '在检索增强生成技术方面，Lewis 等[4]首次提出了 RAG 架构，将预训练语言模型与外部知识检索相结合，'
    '为构建领域特定的智能问答系统提供了新的范式。在企业级框架方面，RuoYi-Vue 作为基于 Spring Boot 和 Vue 的'
    '快速开发框架，内置了用户管理、代码生成等常用模块。Spring AI 框架为 Java 开发者提供了与通义大模型等'
    'AI 服务的统一编程接口。综合分析现有研究，在 Java 技术栈中将 Spring AI 与运维业务进行工程化融合方面，'
    '仍缺乏系统性的实践案例，本文基于上述背景展开研究。'
))

h2(doc, '1.3  研究内容与章节安排')
body(doc, '本文围绕智能电网运维平台的建设，主要开展了以下研究工作。')
body(doc, (
    '设备运维数据管理：设计并实现设备台账信息管理、状态监测数据录入与更新等功能，提供统一的数据管理视图。'
    '规则引擎与告警管理：建立设备状态规则评估机制，实现状态变化时的规则匹配与告警触发，'
    '通过去重策略抑制告警风暴。基于 RAG 的智能知识库问答：通过文档切分、向量化存储与语义检索，'
    '实现运维手册的自然语言查询。自然语言数据库查询：利用大模型实现自然语言到 SQL 的转换。'
    '运维工单全流程管理：实现从故障上报到处理完结的闭环管理，支持 AI 辅助生成工单摘要。'
    '风电功率预测：基于 GRU 神经网络构建预测模型，通过 Java-Python 桥接实现工程化部署。'
    '系统集成与测试：在 RuoYi-Vue 框架基础上将上述模块集成为统一平台，并进行功能测试与验证。'
))

h2(doc, '1.4  主要工作与论文结构')
body(doc, (
    '本文的主要工作包括：在 RuoYi-Vue 框架基础上扩展 Spring AI 能力，实现设备管理、告警管理、智能问答、'
    '自然语言查库、工单管理、功率预测和消息通知等七大功能模块；采用 RAG 技术构建运维知识库问答系统；'
    '基于 GRU 网络实现风电功率预测，通过 Java-Python 桥接完成跨语言服务集成。'
    '本文共分为六章：第一章介绍研究背景与现状；第二章进行需求分析；第三章阐述系统总体设计；'
    '第四章详述各模块的设计与实现；第五章展示测试结果；第六章总结与展望。'
))
"""

# Find the exact Chapter 1 section to replace
pattern_ch1 = r"h1\(doc, '1  绪论'\).*?doc\.add_page_break\(\)\s*"
# Be more precise - match from ch1 h1 to the page break before Chapter 2
ch1_section = content[ch1_start:ch1_pb2+22]
if "h1(doc, '1  绪论')" in ch1_section:
    # The chapter ends at doc.add_page_break() + \n before Chapter 2
    content = content.replace(ch1_section, new_ch1 + "\n", 1)
    changes += 1
    print("Chapter 1 replaced")
else:
    print("Chapter 1 NOT found")

# ========== 3. Replace Chapter 2 ==========
ch2_start = content.find("h1(doc, '2  系统需求分析')")
ch2_pb = content.find("doc.add_page_break()", ch2_start + 5)
ch2_pb2 = content.find("doc.add_page_break()", ch2_pb + 5)

new_ch2 = """h1(doc, '2  系统需求分析')

body(doc, (
    '本章从业务需求、功能需求和非功能需求三个方面对智能电网运维管理平台进行需求分析，'
    '明确系统的功能边界与约束条件，为后续设计与实现提供依据。'
))

h2(doc, '2.1  业务功能需求')
body(doc, (
    '系统的核心业务需求覆盖以下六个方面。设备台账管理：对电网设备的基础信息进行统一管理，'
    '支持增删改查操作和全生命周期追踪。设备状态监测与告警：接收并存储运行状态数据，'
    '预设规则自动触发告警，具备告警去重与聚合能力。运维知识查询：提供基于 RAG 的自然语言问答接口，'
    '使运维人员通过提问方式获取设备手册和故障案例等知识。运维工单管理：提供从故障发现、工单创建、'
    '任务分配到结果确认的闭环管理流程。风电功率预测：基于 GRU 网络的风电功率时序预测，'
    '为调度部门提供出力预估。站内消息通知：提供告警通知、工单提醒等消息的发送与管理功能。'
))

h2(doc, '2.2  非功能与安全需求')
body(doc, (
    '系统在可用性、安全性和性能方面需满足以下非功能需求。可用性方面，AI 服务调用失败时应降级处理，'
    '前端给出明确的可读错误提示。安全性方面，采用 RBAC 权限控制模型，不同角色用户只能访问授权范围内的功能；'
    'API 接口需经身份验证与授权检查；SQL 查询采用参数化方式执行，防范注入攻击。'
    '可维护性方面，遵循模块化设计原则，关键业务逻辑有完善的日志记录。'
    '性能方面，页面加载与数据查询响应应在可接受时间范围内，AI 接口设置合理超时控制。'
))

h2(doc, '2.3  用例、质量属性与术语说明')
body(doc, (
    '系统的主要用例包括：系统管理员进行用户管理、角色分配和系统配置；运维人员进行设备台账维护、'
    '状态数据录入、告警查看与处理、知识库问答、工单操作和预测查询等。'
    '在可行性方面，系统后端采用 Spring Boot 3 框架，Spring AI 提供了与主流大模型对接的统一抽象，'
    '前端使用 Vue 2 和 Element UI，技术方案成熟可行。系统基于开源框架开发，成本可控。'
    'B/S 架构使用户通过浏览器即可访问，操作简便。'
))
body(doc, (
    '系统在数据安全方面遵循合规要求：设备运行状态数据在企业内网传输存储，'
    '数据库连接和 API Key 等敏感信息加密存储。AI 对话功能对用户输入进行脱敏处理后再发送至模型。'
    '文中涉及的主要术语缩写包括：RAG（检索增强生成）、GRU（门控循环单元）、'
    'RBAC（基于角色的访问控制）、SCADA（数据采集与监视控制系统）。'
))
"""

ch2_section = content[ch2_start:ch2_pb2+22]
if "h1(doc, '2  系统需求分析')" in ch2_section:
    content = content.replace(ch2_section, new_ch2 + "\n", 1)
    changes += 1
    print("Chapter 2 replaced")
else:
    print("Chapter 2 NOT found")

# ========== 4. Replace Chapter 3 ==========
ch3_start = content.find("h1(doc, '3  系统总体设计')")
ch3_pb = content.find("doc.add_page_break()", ch3_start + 5)
ch3_pb2 = content.find("doc.add_page_break()", ch3_pb + 5)

new_ch3 = """h1(doc, '3  系统总体设计')

body(doc, (
    '本章从系统架构、技术选型、数据库设计和业务流程四个方面对系统进行总体设计，'
    '为第四章的详细实现提供蓝图。'
))

h2(doc, '3.1  逻辑架构与技术选型')
body(doc, (
    '系统整体采用前后端分离架构。后端基于 Spring Boot 3.2 框架搭建，前端基于 Vue 2 与 Element UI 实现。'
    '系统在 RuoYi-Vue 框架基础上进行二次开发，充分利用其 RBAC 权限管理、代码生成器、日志记录等基础设施。'
    '架构自底向上分为数据层、服务层和展示层。数据层由 MySQL 数据库和 Redis 缓存构成；'
    '服务层包含多个 Maven 子模块，每个子模块封装独立的业务逻辑；展示层使用 Vue Router 进行路由管理，'
    '通过 Vuex 进行全局状态管理。'
))
body(doc, (
    '技术选型方面，后端选用 Spring Boot 3.2.x 与 Java 21，Spring AI 提供 ChatClient、VectorStore 等抽象，'
    '屏蔽不同大模型 API 的差异。数据持久层选用 MyBatis 配合 PageHelper 实现分页。'
    'AI 模型训练与推理由 Python 环境完成，使用 TensorFlow 构建 GRU 网络，通过 FastAPI 提供 HTTP API。'
    '向量存储初期采用 SimpleVectorStore，AI 模型选用阿里云通义大模型，'
    '通过 Spring AI 的 DashScope 适配器实现集成。'
))

# System architecture figure
add_figure_placeholder(doc, '图3.1 系统逻辑架构图', '图3.1 系统逻辑架构图')

# Technology stack table
make_three_line_table(doc,
    ['层次', '技术选型', '说明'],
    [
        ['后端框架', 'Spring Boot 3.2 + Spring AI', '企业级应用开发与AI集成'],
        ['前端框架', 'Vue 2 + Element UI', '单页应用与组件化开发'],
        ['数据持久层', 'MySQL 8 + MyBatis', '结构化数据存储与ORM'],
        ['缓存层', 'Redis 6（可选）', '热点数据缓存加速'],
        ['AI 引擎', '通义大模型 DashScope', '语言理解与生成能力'],
        ['预测引擎', 'TensorFlow + Python', 'GRU时序预测模型'],
        ['向量存储', 'SimpleVectorStore', '文档嵌入向量检索'],
    ],
    caption='表3.1 系统技术栈选型',
)

h2(doc, '3.2  数据库、业务流程与部署配置')
body(doc, (
    '系统数据库采用 MySQL 8，字符集统一为 utf8mb4。核心业务表包括设备台账表（eq_device）、'
    '设备状态表（eq_device_status）、告警记录表（eq_alert）、运维工单表（ai_maintenance_form）、'
    'AI 对话记录表（ai_chat_record）和风电功率预测表（eq_prediction）。以下列出各表结构。'
    '此外还包括设备类型表（eq_device_type）、告警规则表（eq_alert_rule）、'
    '设备绑定关系表（eq_wind_forecast_bind）和站内消息表（sys_user_message）等辅助业务表。'
))

body(doc, (
    '设备台账表（eq_device）是系统核心主表，用于存储电网设备基础信息，'
    '是设备管理、告警管理和工单管理等多项功能的数据基础。'
))
make_three_line_table(doc,
    ['字段名', '类型', '约束', '说明'],
    [
        ['device_id', 'BIGINT', 'PRIMARY KEY', '设备编号，自增主键'],
        ['device_name', 'VARCHAR(100)', 'NOT NULL', '设备名称'],
        ['device_type', 'VARCHAR(50)', 'INDEX', '设备类型编码'],
        ['specification', 'VARCHAR(100)', '', '规格型号'],
        ['location', 'VARCHAR(200)', '', '安装位置'],
        ['commission_date', 'DATE', '', '投运日期'],
        ['manufacturer', 'VARCHAR(100)', '', '制造商名称'],
        ['device_status', 'VARCHAR(20)', "DEFAULT 'normal'", '设备状态'],
        ['create_time', 'DATETIME', 'NOT NULL', '创建时间'],
        ['update_time', 'DATETIME', '', '更新时间'],
    ],
    caption='表3.2 eq_device（设备台账表）结构',
)
body(doc, (
    '设备状态表（eq_device_status）用于存储设备运行状态数据，与设备台账表通过 device_id 外键关联，'
    '为告警评估提供数据源。'
))
make_three_line_table(doc,
    ['字段名', '类型', '约束', '说明'],
    [
        ['status_id', 'BIGINT', 'PRIMARY KEY', '状态编号，自增主键'],
        ['device_id', 'BIGINT', 'FOREIGN KEY', '关联eq_device.device_id'],
        ['temperature', 'DECIMAL(10,2)', '', '设备温度（℃）'],
        ['voltage', 'DECIMAL(10,2)', '', '运行电压（kV）'],
        ['current', 'DECIMAL(10,2)', '', '运行电流（A）'],
        ['power_factor', 'DECIMAL(5,4)', '', '功率因数'],
        ['status_desc', 'VARCHAR(500)', '', '状态描述信息'],
        ['record_time', 'DATETIME', 'NOT NULL', '数据记录时间'],
    ],
    caption='表3.3 eq_device_status（设备状态表）结构',
)
body(doc, '告警记录表（eq_alert）记录系统触发的告警事件，是运维人员了解设备异常状态的主要信息来源。')
make_three_line_table(doc,
    ['字段名', '类型', '约束', '说明'],
    [
        ['alert_id', 'BIGINT', 'PRIMARY KEY', '告警编号，自增主键'],
        ['device_id', 'BIGINT', 'INDEX', '关联设备编号'],
        ['alert_type', 'VARCHAR(50)', 'NOT NULL', '告警类型编码'],
        ['alert_level', 'VARCHAR(20)', 'NOT NULL', '告警级别：一般/严重/紧急'],
        ['alert_content', 'TEXT', '', '告警内容描述'],
        ['trigger_time', 'DATETIME', 'NOT NULL', '告警触发时间'],
        ['confirm_status', 'VARCHAR(20)', "DEFAULT 'pending'", '确认状态'],
        ['handler', 'VARCHAR(50)', '', '处理人用户名'],
        ['handle_time', 'DATETIME', '', '处理时间'],
        ['handle_result', 'VARCHAR(500)', '', '处理结果'],
    ],
    caption='表3.4 eq_alert（告警记录表）结构',
)
body(doc, '运维工单表（ai_maintenance_form）存储工单的流转信息，记录工单生命周期中各环节的操作数据。')
make_three_line_table(doc,
    ['字段名', '类型', '约束', '说明'],
    [
        ['form_id', 'BIGINT', 'PRIMARY KEY', '工单编号，自增主键'],
        ['device_id', 'BIGINT', 'INDEX', '关联设备编号'],
        ['title', 'VARCHAR(200)', 'NOT NULL', '工单标题'],
        ['content', 'TEXT', '', '工单详细内容'],
        ['ai_summary', 'VARCHAR(500)', '', 'AI生成工单摘要'],
        ['status', 'VARCHAR(20)', "DEFAULT 'pending'", '工单状态'],
        ['create_by', 'VARCHAR(50)', 'NOT NULL', '创建人'],
        ['create_time', 'DATETIME', 'NOT NULL', '创建时间'],
        ['handler', 'VARCHAR(50)', '', '处理人'],
        ['finish_time', 'DATETIME', '', '完成时间'],
    ],
    caption='表3.5 ai_maintenance_form（运维工单表）结构',
)
body(doc, 'AI 对话记录表（ai_chat_record）用于存储用户与 AI 助手的对话历史，支持用户回顾之前的问答内容。')
make_three_line_table(doc,
    ['字段名', '类型', '约束', '说明'],
    [
        ['id', 'BIGINT', 'PRIMARY KEY', '记录编号，自增主键'],
        ['session_id', 'VARCHAR(100)', 'INDEX', '会话编号'],
        ['question', 'TEXT', 'NOT NULL', '用户提问内容'],
        ['answer', 'TEXT', '', 'AI回答内容'],
        ['mode', 'VARCHAR(20)', "DEFAULT 'free'", '对话模式'],
        ['create_time', 'DATETIME', 'NOT NULL', '创建时间'],
    ],
    caption='表3.6 ai_chat_record（AI对话记录表）结构',
)
body(doc, '风电功率预测表（eq_prediction）存储功率预测的详细结果，与设备统计表（eq_device_stat）配合使用。')
make_three_line_table(doc,
    ['字段名', '类型', '约束', '说明'],
    [
        ['id', 'BIGINT', 'PRIMARY KEY', '预测编号，自增主键'],
        ['device_id', 'BIGINT', 'INDEX', '关联设备编号'],
        ['prediction_time', 'DATETIME', 'NOT NULL', '预测时间点'],
        ['actual_power', 'DECIMAL(10,2)', '', '实际功率（kW）'],
        ['predicted_power', 'DECIMAL(10,2)', 'NOT NULL', '预测功率（kW）'],
        ['step', 'INT', '', '预测步长'],
        ['create_time', 'DATETIME', 'NOT NULL', '创建时间'],
    ],
    caption='表3.7 eq_prediction（风电功率预测表）结构',
)

add_figure_placeholder(doc, '图3.2 数据库E-R图', '图3.2 系统核心数据库E-R图')

body(doc, (
    '关键业务处理流程如下。设备状态监测与告警流程：系统接收运行状态数据并持久化至设备状态表，'
    '随后自动调用规则引擎遍历当前设备关联的告警规则，条件满足时生成告警记录，'
    '并通过站内消息通知相关运维人员。AI 知识问答流程：用户在前端输入问题，'
    '系统根据对话模式选择处理策略——知识库模式下进行向量检索后调用大模型生成答案，'
    '自由对话模式直接调用大模型，数据库查询模式将自然语言转换为 SQL 执行。'
    '风电功率预测流程：运维人员触发预测后，后端通过 HTTP 向 Python 服务发送请求，'
    'Python 端加载 GRU 模型执行预测并返回结果。'
))
body(doc, (
    '系统接口遵循 RESTful 风格，设备接口以 /equipment 为前缀，AI 接口以 /springai 为前缀。'
    '响应遵循统一格式 {"code": 200, "data": {...}, "msg": "操作成功"}。'
    'AI 对话支持同步和流式（SSE）两种响应模式。系统安全架构从 JWT 身份认证、RBAC 权限控制和'
    '数据安全三个维度设计，遵循最小权限原则。开发运行环境为 JDK 21、Spring Boot 3.2.x、'
    'Vue 2.7、MySQL 8.0，Spring AI 版本 0.8.x 通过 spring-ai-bom 管理依赖。'
))
"""

ch3_section = content[ch3_start:ch3_pb2+22]
if "h1(doc, '3  系统总体设计')" in ch3_section:
    content = content.replace(ch3_section, new_ch3 + "\n", 1)
    changes += 1
    print("Chapter 3 replaced")
else:
    print("Chapter 3 NOT found")

# ========== 5. Replace Chapter 4 ==========
ch4_start = content.find("h1(doc, '4  系统详细设计与实现')")
ch4_pb = content.find("doc.add_page_break()", ch4_start + 5)
ch4_pb2 = content.find("doc.add_page_break()", ch4_pb + 5)

new_ch4 = """h1(doc, '4  系统详细设计与实现')

body(doc, (
    '本章按照功能模块划分，分别阐述各核心模块的详细设计与实现方案。'
    '每个模块遵循 Controller-Service-Mapper 的分层结构组织，并说明前端对应的页面路由与调用关系。'
))

h2(doc, '4.1  设备多维数据与状态管理')
body(doc, (
    '设备运维数据管理模块是系统的基础数据模块。EqDeviceController 映射 /equipment/device 路径，'
    'EqDeviceServiceImpl 负责设备信息的增删改查。设备状态由 EqDeviceStatusServiceImpl 管理，'
    '提供状态数据的录入、更新和历史查询。设备删除操作涉及级联清理（状态、告警、工单和预测数据），'
    '通过 @Transactional 注解确保原子性。'
))
body(doc, (
    '前端页面位于 ruoyi-ui/src/views/equipment 目录，使用 el-table 和 el-pagination 实现数据展示与分页。'
    '设备状态管理引入 Redis 缓存提升查询性能，以 "eq:status:{deviceId}" 为 key 缓存最新状态，'
    '新数据写入时自动更新缓存。Excel 导入导出通过 RuoYi 内置工具类实现，'
    '批量导入时使用 Apache POI 解析文件并逐行校验。'
))

h2(doc, '4.2  规则评估与告警联动')
body(doc, (
    '规则引擎模块实现设备状态变化的自动评估与告警触发。核心接口 IEqDeviceRuleTriggerService 定义规则触发契约，'
    'IEqDeviceRuleEvaluationService 封装规则匹配逻辑，包括阈值比较、条件组合和时间窗口过滤。'
    '状态数据写入后自动调用 evaluateAfterStatusChange() 方法触发规则评估，匹配成功的规则生成告警记录。'
))
body(doc, (
    '规则表达式由监测指标、比较运算符和阈值三部分组成。系统使用策略模式组织不同数据类型的比较逻辑。'
    '告警去重采用状态窗口策略，在窗口时间内同类告警不重复触发。'
    '告警处理支持确认、转派和关闭三种操作，均记录操作日志。'
    '系统还提供 reevaluateRulesByDeviceId() 方法，支持在规则变更后重新评估设备状态。'
))

# Rule configuration table
make_three_line_table(doc,
    ['规则名称', '条件表达式', '告警级别', '说明'],
    [
        ['高温告警', 'temperature > 85', '严重', '设备温度超上限'],
        ['电压越限', 'voltage < 95 OR voltage > 115', '紧急', '电压超出正常运行范围'],
        ['功率因数低', 'power_factor < 0.85', '一般', '功率因数偏低需关注'],
        ['电流过载', 'current > 120% I_n', '严重', '电流超额定值120%'],
    ],
    caption='表4.1 告警规则配置示例',
)

h2(doc, '4.3  对话、RAG 与自然语言查库')
body(doc, (
    '智能对话模块基于 Spring AI 框架构建。AiDeomController 映射 /springai/chat 路径，'
    '提供普通对话和流式对话接口。RagController 映射 /springai/rag 路径，'
    '提供文档上传、知识库清除和问答接口。RAG 流程为：文档切分（500 Token 块大小，50 Token 重叠度）→'
    '向量化存储→用户问题向量检索（Top-3）→提示词拼接→大模型生成答案。'
    '文档解析支持 TXT、PDF、DOCX 格式。'
))
body(doc, (
    '自然语言数据库查询由 DatabaseQueryController 实现，映射 /springai/db 路径。'
    '系统将自然语言问题与表结构信息封装为提示词，调用大模型生成 SQL。'
    '安全性设三层防护：语句类型过滤（仅 SELECT）、关键词黑名单和结果集限制（LIMIT）。'
    'NL2SQL 功能的提示词中预先封装表名、字段名和字段注释，引导模型生成符合 MySQL 语法的语句。'
    '对话历史由 ChatHistoryController 管理，记录保存在 ai_chat_record 表中，支持按会话 ID 查询。'
))

add_figure_placeholder(doc, '图4.1 RAG知识库问答流程图', '图4.1 RAG知识库问答流程示意图')

h2(doc, '4.4  运维表单与预测服务集成')
body(doc, (
    '运维工单管理由 MaintenanceFormController 实现，映射 /springai/maintenance-form 路径。'
    '系统支持 AI 辅助生成工单摘要，将工单内容发送给大模型提取关键信息。'
    '工单状态按"待处理→处理中→待审核→已完成"流转，不通过时退回处理中状态。'
    'MaintenanceFormNotifyTask 定时任务扫描超时工单并发送催办通知，基于 Quartz 调度实现。'
))
body(doc, (
    '风电功率预测模块采用 GRU 神经网络，网络使用两层级联结构（第一层 64 单元，第二层 32 单元），'
    'Dropout 层防止过拟合。WindForecastController 映射 /wind/forecast 路径，'
    'WindForecastBridgeService 通过 HTTP POST 向 Python FastAPI 服务发送预测参数。'
    'Java-Python 通信数据格式为 JSON，超时 30 秒。预测结果写入采用双表策略：'
    'eq_prediction 存储明细数据，eq_device_stat 存储聚合指标。'
    '前端使用 ECharts 展示预测曲线，设备绑定关系通过 eq_wind_forecast_bind 表管理。'
))

add_figure_placeholder(doc, '图4.2 运维工单流转流程图', '图4.2 运维工单全生命周期流转流程')

h2(doc, '4.5  消息推送、权限与工程化实现')
body(doc, (
    '站内消息模块由 SysUserMessageController 实现，映射 /system/user-message 路径，'
    '支持告警通知、工单提醒和系统公告的发送与查询。前端 MessageCenter 组件通过定时轮询获取未读计数。'
    '权限管理基于 RuoYi-Vue 的 RBAC 机制，使用 @PreAuthorize 注解进行接口级控制，'
    '前端通过 v-hasPermi 指令控制元素可见性。系统预定义管理员和普通运维人员两个角色。'
))
body(doc, (
    '前端采用 Vue 2 + Element UI + SPA 架构，Vue Router 实现懒加载，Vuex 管理全局状态。'
    'AI 流式对话使用 EventSource API 实现逐字输出。系统使用 @RestControllerAdvice 进行全局异常处理，'
    'SLF4J + Logback 进行日志记录。事务管理使用 @Transactional 声明式注解，'
    'AI 服务等非核心业务调用采用 try-catch 降级处理。代码包结构以 com.thor 为根包，'
    '按业务模块组织，每个子包内部分为 controller、service、domain、mapper 四层。'
))

add_figure_placeholder(doc, '图4.3 权限模型示意图', '图4.3 RBAC权限模型示意图')
"""

ch4_section = content[ch4_start:ch4_pb2+22]
if "h1(doc, '4  系统详细设计与实现')" in ch4_section:
    content = content.replace(ch4_section, new_ch4 + "\n", 1)
    changes += 1
    print("Chapter 4 replaced")
else:
    print("Chapter 4 NOT found")

# ========== 6. Replace Chapter 5 ==========
ch5_start = content.find("h1(doc, '5  系统测试')")
ch5_pb = content.find("doc.add_page_break()", ch5_start + 5)
ch5_pb2 = content.find("doc.add_page_break()", ch5_pb + 5)

new_ch5 = """h1(doc, '5  系统测试')

body(doc, (
    '本章对系统各功能模块进行测试验证。测试在单机环境中进行，涵盖功能测试、异常场景测试和兼容性验证。'
))

h2(doc, '5.1  测试环境与功能验证')
body(doc, (
    '测试环境：操作系统 Windows 11，JDK 21 + Spring Boot 3.2.x，MySQL 8，Redis 6（可选），'
    'Chromium 内核浏览器。测试步骤按模块逐项展开，先初始化数据库，再启动后端与前端服务，'
    '以不同角色账号登录验证各功能模块。'
))
body(doc, (
    '功能测试覆盖设备台账管理、设备状态录入、告警触发与查看、AI 智能问答（知识库/自由对话/数据库查询模式）、'
    '运维工单创建与流转、风电功率预测、站内消息收发等核心业务流程。所有 15 个核心测试用例均通过。'
    '设备管理模块的增删改查操作正常，级联删除正确提示关联范围。'
    '告警模块在超阈值数据写入后自动触发规则，去重机制有效抑制重复告警。'
    'AI 问答各模式下响应正确，RAG 检索能够准确回答知识库文档内容。'
    '工单流转状态变更正常触发消息通知，功率预测模块成功调用 Python 服务并返回结果。'
    '权限控制机制有效区分不同角色的访问边界，越权请求正确返回 403。'
))

# Test case table
make_three_line_table(doc,
    ['测试模块', '测试用例', '预期结果', '实际结果'],
    [
        ['设备管理', '添加新设备', '设备信息保存成功，列表正确显示', '通过'],
        ['设备管理', '按类型筛选设备', '返回对应类型的设备列表', '通过'],
        ['设备管理', '导出Excel', '生成含查询结果的Excel文件', '通过'],
        ['告警管理', '阈值触发告警', '超阈值数据写入后自动生成告警', '通过'],
        ['告警管理', '告警确认操作', '确认后告警状态更新为已确认', '通过'],
        ['AI问答', '知识库模式提问', '答案包含上传文档的相关信息', '通过'],
        ['AI问答', '自由对话模式', '模型返回合理的自然语言回答', '通过'],
        ['AI问答', '数据库查询模式', '正确生成SQL并返回查询结果', '通过'],
        ['工单管理', '创建运维工单', '工单生成并在列表中显示', '通过'],
        ['工单管理', '工单流转审批', '状态按待处理-处理中-已完成流转', '通过'],
        ['工单管理', 'AI生成摘要', '自动提取关键信息生成工单摘要', '通过'],
        ['功率预测', '执行预测', '返回预测曲线并与实际数据对比', '通过'],
        ['功率预测', '未绑定设备预测', '使用全局配置数据回退预测', '通过'],
        ['消息通知', '告警消息推送', '相关用户收到对应告警通知', '通过'],
        ['权限控制', '越权访问API', '未授权请求返回403状态码', '通过'],
    ],
    caption='表5.1 系统功能测试用例及结果',
)

add_figure_placeholder(doc, '图5.1 设备管理页面测试截图', '图5.1 设备管理模块测试截图')
add_figure_placeholder(doc, '图5.2 AI问答功能测试截图', '图5.2 智能问答模块测试截图')
add_figure_placeholder(doc, '图5.3 告警管理页面测试截图', '图5.3 告警管理功能测试截图')

h2(doc, '5.2  性能、用例与兼容性')
body(doc, (
    '性能测试方面，AI 接口在正常网络条件下响应时间约 3-5 秒。设备列表页在千条数据量级下加载时间在 2 秒以内。'
    '数据库带索引的主键查询在 10 毫秒以内，条件筛选分页查询在 100 毫秒以内。'
    '兼容性测试在 Edge 120、Chrome 120、Firefox 121 浏览器上进行，分辨率覆盖 1920x1080 和 1366x768，'
    '界面布局正确，未发现兼容性问题。异常场景测试覆盖 AI 服务不可用、Python 预测服务异常、'
    '数据删除级联保护和文件上传异常等，系统在各异常情况下均给出明确的错误提示。'
))

h2(doc, '5.3  局限性与答辩准备')
body(doc, (
    '当前测试主要在单机环境下进行，未开展大规模并发压力测试。后续可使用 JMeter 对核心 API 进行压力测试，'
    '开展安全渗透测试，并在真实运维环境中验证长时间运行稳定性。'
    'AI 能力验证方面，建议构建标准问答测试集对 RAG 准确性进行定量评估，'
    '对风电功率预测模型在不同季节条件下的泛化能力进行持续验证。'
    '综合评估表明，系统各功能模块运行稳定可靠，具备在单机演示环境下稳定运行的能力。'
))
"""

ch5_section = content[ch5_start:ch5_pb2+22]
if "h1(doc, '5  系统测试')" in ch5_section:
    content = content.replace(ch5_section, new_ch5 + "\n", 1)
    changes += 1
    print("Chapter 5 replaced")
else:
    print("Chapter 5 NOT found")

# ========== 7. Replace Chapter 6 ==========
ch6_start = content.find("h1(doc, '6  总结与展望')")
ch6_pb = content.find("doc.add_page_break()", ch6_start + 5)

new_ch6 = """h1(doc, '6  总结与展望')

body(doc, (
    '本文基于 Spring AI 框架设计并实现了一套智能电网运维管理平台，从设备数据管理、状态监测告警、'
    '智能问答、数据库查询、工单管理、功率预测到消息通知，覆盖了电网运维工作的主要环节。'
    '通过 Spring AI 框架统一接入通义大模型，利用 RAG 技术构建运维知识库问答系统，'
    '采用 GRU 神经网络进行风电功率预测并通过 Java-Python 桥接实现工程化部署。'
    'RBAC 权限控制机制贯穿整个系统，保障数据访问安全。'
    '测试结果表明系统各功能模块运行稳定可靠，能够有效提升电网运维工作的信息化与智能化水平。'
))
body(doc, (
    '然而，由于研究时间和实验条件的限制，当前系统仍存在若干待改进之处。'
    'RAG 知识库检索精度受限于固定块大小的切分策略；功率预测模型的泛化能力有待在实际风电场环境中进一步验证；'
    '系统的安全性防护措施有待完善。后续可从以下方面展开：引入多轮对话上下文管理机制提升问答体验；'
    '探索知识图谱与 RAG 相结合实现更精准的故障定位；增加移动端适配；'
    '引入 WebSocket 实现告警实时推送；将自动化测试和 CI/CD 纳入开发流程。'
))
"""

ch6_section = content[ch6_start:ch6_pb+22]
if "h1(doc, '6  总结与展望')" in ch6_section:
    content = content.replace(ch6_section, new_ch6 + "\n", 1)
    changes += 1
    print("Chapter 6 replaced")
else:
    print("Chapter 6 NOT found")

# ========== Save ==========
with open('generate_complete_thesis.py', 'w', encoding='utf-8') as f:
    f.write(content)

print(f"\nTotal changes: {changes}")
print("Done!")
