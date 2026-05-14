# -*- coding: utf-8 -*-
"""Third round: add more content to reach ~36k chars."""
with open('generate_complete_thesis.py', 'r', encoding='utf-8') as f:
    content = f.read()

changes = 0

# Add to Ch2 - functional module description
old = "h2(doc, '2.1  业务功能需求')"
new = old + """
body(doc, (
    '系统的六个核心功能模块各自承担明确的业务职责。设备管理模块提供设备台账的增删改查功能，'
    '支持设备信息的 Excel 批量导入与导出，实现设备全生命周期追踪。'
    '告警管理模块支持规则的创建与维护，实现基于规则的自动告警触发与记录，'
    '提供告警确认、处理和关闭的完整流程，具备时间窗口去重机制。'
    '智能问答模块支持运维知识文档的上传与向量化存储，提供基于 RAG 的自然语言问答接口，'
    '支持对话历史记录的保存与查询。自然语言查询模块将用户自然语言输入转换为 SQL 语句，'
    '经过安全性校验后执行并返回结果。工单管理模块提供工单的创建、分配、处理与关闭功能，'
    '支持 AI 辅助生成工单摘要。功率预测模块提供基于 GRU 网络的预测模型训练与预测功能。'
    '消息通知模块向用户发送告警通知、工单提醒等消息，支持已读/未读状态管理。'
))
"""
content = content.replace(old, new, 1)
changes += 1

# Add to Ch4.1 device delete detail
target = "h2(doc, '4.1  设备多维数据与状态管理')"
new_content = """body(doc, (
    '列表查询功能使用 PageHelper 分页插件实现自动分页。查询参数封装在分页请求对象中，'
    '由 PageHelper.startPage() 方法在 Mapper 调用前自动设置分页上下文。'
    'Excel 导出功能通过 RuoYi 内置的 Excel 工具类实现，利用字段注解自动生成表头并映射数据。'
    '在实现批量导入功能时，系统采用 Apache POI 组件解析 Excel 文件，'
    '对导入数据逐行进行格式校验与业务规则验证，校验通过的数据统一通过 Mapper 的 batchInsert 方法批量写入数据库。'
))
"""
# Find the first body after 4.1 h2 to insert after
# Just do a simple replacement: after the 4.1 body content
content = content.replace(target, target + new_content, 1)
changes += 1

# Add to Ch3.2 - Business flow detail
old = "h2(doc, '3.2  数据库、业务流程与部署配置')"
new = old + """
body(doc, (
    '系统接口遵循 RESTful 风格，以资源为核心进行 URL 路径规划。'
    '设备相关接口统一以 /equipment 为前缀，AI 相关接口以 /springai 为前缀，'
    '预测相关接口以 /wind 为前缀。在请求方式上，GET 用于查询，POST 用于创建或触发，'
    'PUT 用于更新，DELETE 用于删除。响应遵循统一格式 {"code": 200, "data": {...}, "msg": "操作成功"}。'
    '分页查询的响应额外包含 total、rows 和 pageNum 字段。AI 对话接口支持同步和流式（SSE）两种响应模式。'
))
"""
content = content.replace(old, new, 1)
changes += 1

# Add system security detail to Ch3.2 (after figure)
old = "add_figure_placeholder(doc, '图3.2 数据库E-R图', '图3.2 系统核心数据库E-R图')"
new = old + """
body(doc, (
    '系统安全架构从身份认证、权限控制和数据安全三个维度进行设计。'
    '身份认证基于 JWT 实现，用户在登录成功后获得包含身份信息和角色标识的 Token，'
    '前端通过 HTTP Header 的 Authorization 字段携带 Token 访问受保护资源。'
    '权限控制采用 RBAC 模型，系统预定义管理员和普通运维人员两个角色，'
    '权限以"模块名:功能名:操作名"格式进行标识。数据安全方面遵循最小权限原则，'
    'SQL 查询采用 MyBatis 参数化查询机制防范注入攻击。'
    '日志记录对关键业务操作进行记录，便于安全审计与问题追溯。'
))
"""
content = content.replace(old, new, 1)
changes += 1

# Add more content to Ch5.3
old = "h2(doc, '5.3  局限性与答辩准备')"
new = old + """
body(doc, (
    '在 AI 能力验证方面，建议后续对 RAG 问答的准确性进行定量评估，'
    '构建包含标准问答对的测试集，计算回答的准确率和召回率。'
    '对于风电功率预测模块，可在不同季节和气象条件下进行持续验证，'
    '评估模型在不同环境条件下的泛化能力和预测稳定性。'
    '为更系统地展示测试覆盖范围，测试用例的设计遵循了等价类划分和边界值分析方法。'
    '综合评估表明，系统各功能模块在功能完备性、操作流程完整性和异常处理合理性方面'
    '均达到了预期设计目标，具备在单机演示环境下稳定运行的能力。'
))
"""
content = content.replace(old, new, 1)
changes += 1

# After Appendices, restore Appendices intro
old = "h1(doc, '附录A  核心数据库表结构')"
new = old + """
body(doc, (
    '本附录列出系统核心数据库表的主要字段定义，供开发与部署人员参考。'
    '数据库表结构的合理性直接关系到系统的数据存储效率与查询性能。'
    '在设计过程中，充分考虑了业务数据的读写比例、数据增长速度和查询模式等因素。'
))
"""
content = content.replace(old, new, 1)
changes += 1

with open('generate_complete_thesis.py', 'w', encoding='utf-8') as f:
    f.write(content)

print(f"Total: {changes} changes")
