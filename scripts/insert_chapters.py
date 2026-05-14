# -*- coding: utf-8 -*-
"""Insert missing Chapters 2, 4, 6 into the current file."""

with open('generate_complete_thesis.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Chapter 2 - insert after Chapter 1 ends (before "# ==================== CHAPTER 3 ===")
ch2_text = """
# ==================== CHAPTER 2 ====================
h1(doc, '2  系统需求分析')

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

doc.add_page_break()

"""

# Insert Chapter 2 before Chapter 3
ch3_marker = "# ==================== CHAPTER 3 ==="
content = content.replace(ch3_marker, ch2_text + "\n" + ch3_marker, 1)
print("Chapter 2 inserted")

# Chapter 4 - insert after Chapter 3 ends (before "# ==================== CHAPTER 5 ===")
ch4_text = """
# ==================== CHAPTER 4 ====================
h1(doc, '4  系统详细设计与实现')

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

doc.add_page_break()

"""

ch5_marker = "# ==================== CHAPTER 5 ==="
content = content.replace(ch5_marker, ch4_text + "\n" + ch5_marker, 1)
print("Chapter 4 inserted")

# Chapter 6 - insert after Chapter 5 ends (before "# ==================== APPENDIX A ===")
ch6_text = """
# ==================== CHAPTER 6 ====================
h1(doc, '6  总结与展望')

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

doc.add_page_break()

"""

app_a_marker = "# ==================== APPENDIX A ==="
content = content.replace(app_a_marker, ch6_text + "\n" + app_a_marker, 1)
print("Chapter 6 inserted")

with open('generate_complete_thesis.py', 'w', encoding='utf-8') as f:
    f.write(content)

print("\nAll missing chapters inserted!")
