# -*- coding: utf-8 -*-
"""Final expansion to reach ~40k chars - add remaining content."""

with open('generate_complete_thesis.py', 'r', encoding='utf-8') as f:
    content = f.read()

changes = 0

# ===== Ch1 expansion: tech overview =====
old = "h2(doc, '1.4  主要工作与论文结构')"
new = old + """
body(doc, (
    'Spring AI 是 Spring 生态系统中的新兴项目，旨在为 Java 开发者提供与 AI 服务进行交互的统一编程模型。'
    '该框架抽象了与各类大语言模型的通信细节，提供了 ChatClient、EmbeddingClient、VectorStore '
    '和 Prompt Template 等核心抽象。通过 Spring AI，开发者可以用声明式的方式调用不同 AI 提供商的服务，'
    '实现对话生成、文本嵌入、文档检索等功能。框架的设计使得业务代码与 AI 服务之间保持松耦合，'
    '便于后续切换底层模型提供商或扩展新的 AI 能力。'
))
body(doc, (
    'RAG（检索增强生成）是一种将信息检索与文本生成相结合的技术范式。'
    '传统的语言模型在生成文本时仅依赖其预训练阶段习得的参数化知识，难以获取最新的或领域特定的信息。'
    'RAG 通过在生成过程中引入外部知识检索步骤，允许模型在回答问题时参考检索到的相关文档片段，'
    '从而显著提升生成内容的准确性和可信度。GRU（门控循环单元）是循环神经网络的一种变体，'
    '与 LSTM 网络相比，GRU 将遗忘门和输入门合并为更新门，参数量更少，训练速度更快，'
    '在风电功率预测等时序预测任务中具有良好的性能与效率平衡。'
))
"""
content = content.replace(old, new, 1)
changes += 1

# ===== Ch3.2 add after business flow =====
old = "h2(doc, '3.2  数据库、业务流程与部署配置')"
new = old + """
body(doc, (
    '系统的代码组织结构采用 Maven 多模块架构，各模块之间的依赖关系清晰。'
    'ruoyi-admin 依赖 ruoyi-framework 和 spring-ai，ruoyi-framework 依赖 ruoyi-system，'
    'ruoyi-system 依赖 ruoyi-common，形成自底向上的依赖链。'
    'spring-ai 模块独立封装 AI 相关功能，与核心业务模块解耦。'
    '在部署架构方面，系统支持单体部署和分布式部署两种模式。'
    '开发与演示阶段后端、前端和数据库可部署在同一台服务器上。'
    '生产环境中前端静态资源可部署至 nginx 反向代理服务器。'
))
"""
content = content.replace(old, new, 1)
changes += 1

# ===== Add content between table and its intro =====
# Add after 3.1 tech table
old = "caption='表3.1 系统技术栈选型',"
new = old + """
body(doc, (
    '系统的技术选型综合考虑了开发效率、运行性能、社区生态和团队技术储备等因素。'
    '后端主框架选用 Spring Boot 3.2.x 与 Java 21，充分利用虚拟线程等新特性。'
    'Spring AI 作为 AI 集成框架，提供 ChatClient、VectorStore 等抽象，屏蔽了不同大模型 API 的差异。'
    '数据持久层选用 MyBatis 配合 PageHelper 分页插件，支持手写 SQL 与动态 SQL 组装。'
    '前端选用 Vue 2 与 Element UI，可以充分利用 RuoYi-Vue 现有的代码生成模板和权限指令基础设施。'
))
"""
content = content.replace(old, new, 1)
changes += 1

# ===== Add to Ch4 detail about SSE =====
# Find the 4.5 section and add SSE detail
old = "h2(doc, '4.5  消息推送、权限与工程化实现')"
new = old + """
body(doc, (
    '对于 AI 对话等需要流式数据传输的场景，前端使用 EventSource 接口建立与后端的长连接。'
    'EventSource 基于 HTTP 协议，相较于 WebSocket 具有更简单的 API 和更好的浏览器兼容性。'
    '系统在组件创建时初始化 EventSource 连接，在组件销毁时主动关闭连接释放资源，'
    '防止内存泄漏。流式数据的渲染采用增量追加策略，每次接收到数据片段后追加到消息气泡的内容中，'
    '实现逐字输出的视觉效果。'
))
"""
content = content.replace(old, new, 1)
changes += 1

# ===== Add to Ch4 about UI details =====
old = "h2(doc, '4.3  对话、RAG 与自然语言查库')"
new = old + """
body(doc, (
    '在用户体验方面，对话页面采用类似即时通讯的界面布局，流式响应时使用 EventSource 接口'
    '接收服务端推送的逐字内容，前端实时追加到消息气泡中，提供流畅的对话体验。'
    'NL2SQL 功能在前端页面设计了查询示例引导区域，为用户提供典型的查询问题范例，'
    '帮助用户快速了解功能的使用方式。查询结果以结构化表格形式呈现，'
    '并附带自然语言生成的查询统计摘要，便于用户理解查询结果的含义。'
))
"""
content = content.replace(old, new, 1)
changes += 1

# ===== Add Ch4.5 UI interaction detail =====
old = "h2(doc, '4.5  消息推送、权限与工程化实现')"
# This has already been replaced above, so use a different insertion point
# Find the second occurrence by inserting after a specific paragraph
old_ui = "实现逐字输出的视觉效果。'"
new_ui = old_ui + """
))
body(doc, (
    '在 UI 布局方面，系统采用 Element UI 的 Container 布局组件构建页面骨架，'
    '侧边栏展示系统菜单，顶部栏显示用户信息和通知入口，主内容区通过路由视图动态渲染。'
    '表格页面统一使用 el-table 组件，通过 el-table-column 定义列配置，利用插槽实现自定义内容渲染。'
    '表单页面使用 el-form 配合 el-form-item 和校验规则实现数据录入的实时验证。'
    '页面加载状态使用骨架屏或加载动画进行过渡，避免页面空白等待。'
    '表单页面实现了输入校验的即时反馈，对于设备删除等敏感操作使用弹窗二次确认机制。'
))
"""
content = content.replace(old_ui, new_ui, 1)
changes += 1

# ===== Add Ch2.2 more detail =====
old = "h2(doc, '2.2  非功能与安全需求')"
new = old + """
body(doc, (
    '各功能模块之间的协作关系可以概括为一个基础中心加四条业务主线。'
    '设备数据管理是系统的基础中心，为其他所有模块提供设备主数据支撑。'
    '状态监测与告警是安全主线，确保设备异常能够被及时发现。'
    '知识问答与数据查询是效率主线，降低运维人员的信息获取成本。'
    '工单管理和功率预测是业务主线，分别覆盖运维流程管理和新能源调度辅助决策。'
    '消息通知是沟通主线，确保重要信息能够及时触达相关人员。'
    '这种模块化设计使得各功能既可独立运行又可协同工作。'
))
"""
content = content.replace(old, new, 1)
changes += 1

with open('generate_complete_thesis.py', 'w', encoding='utf-8') as f:
    f.write(content)

print(f"Total: {changes} expansion changes")
