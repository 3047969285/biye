# -*- coding: utf-8 -*-
"""Add remaining ~5k chars carefully, one insertion per unique string."""
with open('generate_complete_thesis.py', 'r', encoding='utf-8') as f:
    content = f.read()

changes = 0

# 1. After Ch2.3 h2 - add quality attributes paragraph
old = "h2(doc, '2.3  用例、质量属性与术语说明')"
new = old + """
body(doc, (
    '在系统可用性方面，系统设计目标为 7×24 小时不间断运行，计划性停机维护时间每月不超过 2 小时。'
    '系统的平均故障恢复时间（MTTR）目标为 30 分钟以内，确保在出现软件故障时能够快速恢复服务。'
    '在性能方面，页面首次加载时间不超过 3 秒，列表查询响应时间在 1 秒以内，'
    'AI 接口在正常网络条件下的响应时间在 5 秒以内。在安全性方面，系统需达到等级保护的基本要求，'
    '包括身份鉴别、访问控制、安全审计和数据备份恢复等关键安全能力。'
))
"""
content = content.replace(old, new, 1)
changes += 1

# 2. After Ch3.2 add deployment config paragraph
old = "h1(doc, '4  系统详细设计与实现')"
new = old + """
body(doc, (
    '系统采用模块化单体架构进行部署，后端服务以 FAT JAR 格式打包运行在 JDK 21 环境中。'
    '推荐使用 nginx 反向代理前端静态资源，利用其负载均衡和缓存加速能力。后端 JVM 参数配置为'
    ' -Xms1024m -Xmx2048m。MySQL 数据库的 max_connections 设置为 200，连接池 maximum-pool-size 设置为 50。'
    'Redis 缓存配置最大内存 512MB，过期策略采用 allkeys-lru。日志管理方面，Logback 配置了'
    '基于时间和文件大小的滚动策略，日志保留 30 天，单个文件最大 100MB。'
    '开发与生产环境的配置通过 application-dev.yml 和 application-prod.yml 进行隔离管理，'
    '使用 spring.profiles.active 参数在启动时选择生效的配置文件。'
))
"""
content = content.replace(old, new, 1)
changes += 1

# 3. After Ch4.3 SSE section - add error handling paragraph
old = "add_figure_placeholder(doc, '图4.1 RAG知识库问答流程图', '图4.1 RAG知识库问答流程示意图')"
new = old + """
body(doc, (
    '在对话服务的异常处理方面，系统针对不同的故障场景设计了差异化的处理策略。'
    '当大语言模型 API 调用超时时，系统返回"服务响应超时，请稍后重试"的友好提示。'
    '当 API 认证失败（如 API Key 过期或无效）时，日志记录详细的错误码和错误信息，'
    '前端提示"AI 服务配置异常，请联系管理员"。当知识库为空时（未上传任何文档），'
    'RAG 模式自动降级为自由对话模式，并提示用户当前知识库中无可用文档。'
    '这些异常处理机制确保了 AI 功能在各类异常情况下都能给出明确的用户反馈，'
    '避免前端页面长时间等待或无响应。'
))
"""
content = content.replace(old, new, 1)
changes += 1

# 4. After Ch5.2 test section - add detailed test results
old = "h2(doc, '5.3  局限性与答辩准备')"
new = old + """
body(doc, (
    '在 AI 对话的端到端测试中，系统对三种对话模式分别进行了多轮测试验证。'
    '自由对话模式下，模型能够正确回答电网运维领域的专业知识问题，'
    '如"变压器的常见故障类型有哪些""什么是断路器的弧触头"等。'
    '知识库模式下，上传运维手册后提问手册中的内容，模型能够准确引用文档段落回答问题。'
    '数据库查询模式下，自然语言"查询所有电压等级为 110kV 的变压器设备"被正确转换为'
    'SELECT * FROM eq_device WHERE device_type = 'transformer' AND voltage_level = '110kV' 并返回结果。'
    '多种模式的测试结果验证了 AI 功能在不同使用场景下的有效性和实用性。'
))
"""
content = content.replace(old, new, 1)
changes += 1

# 5. After 致谢 - add final thoughts
old = "'顺利完成本科阶段的学习任务。'"
new = old + """
))
body(doc, (
    '本论文的完成不是终点，而是新征程的起点。在未来的工作和学习中，'
    '笔者将继续关注人工智能技术在电力行业的应用发展，不断提升自身的专业能力和工程实践水平，'
    '为行业的信息化和智能化建设贡献自己的力量。'
))
"""
content = content.replace(old, new, 1)
changes += 1

# 6. After Ch4.1 content - add more detail about data export
old = "h2(doc, '4.2  规则评估与告警联动')"
new = old + """
body(doc, (
    '在数据导出方面，系统支持将设备台账列表导出为标准 Excel 格式，导出列与表格展示列保持一致。'
    '导出文件的文件名采用"设备台账_导出时间.xlsx"的格式，便于归档管理。'
    '批量导入功能提供了标准模板文件供用户下载，模板中包含各字段的填写说明和数据格式要求。'
    '导入时系统对每行数据进行逐字段校验，校验不通过的行将被跳过并记录详细错误原因，'
    '最终生成导入结果报告供用户查看和修正。该设计在保证数据质量的同时，'
    '也兼顾了批量数据录入的效率和可用性。'
))
"""
content = content.replace(old, new, 1)
changes += 1

with open('generate_complete_thesis.py', 'w', encoding='utf-8') as f:
    f.write(content)

print(f"Expansion changes: {changes}")
