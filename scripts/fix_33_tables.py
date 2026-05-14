# -*- coding: utf-8 -*-
"""Convert section 3.3 database tables to three-line tables."""
with open('generate_complete_thesis.py', 'r', encoding='utf-8') as f:
    content = f.read()

# 1. eq_device
old1 = """    '设备台账表（eq_device）是系统的核心主表，用于存储电网设备的基础信息。'
    '主要字段包括：设备编号（device_id，主键）、设备名称（device_name）、设备类型（device_type）、'
    '规格型号（specification）、安装位置（location）、投运日期（commission_date）、'
    '制造商（manufacturer）、设备状态（device_status）、创建时间（create_time）、更新时间（update_time）等。'
    '该表是设备管理、告警管理和工单管理等多项功能的数据基础。'
))"""

new1 = """    '设备台账表（eq_device）是系统的核心主表，用于存储电网设备的基础信息。'
    '该表是设备管理、告警管理和工单管理等多项功能的数据基础。'
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
    caption='表3.3 eq_device（设备台账表）结构',
)"""

content = content.replace(old1, new1, 1)
print("  eq_device table - done")

# 2. eq_device_status
old2 = """    '设备状态表（eq_device_status）用于存储设备运行状态数据，与设备台账表通过 device_id 外键关联。'
    '主要字段包括：状态编号（status_id，主键）、设备编号（device_id）、温度（temperature）、'
    '电压（voltage）、电流（current）、功率因数（power_factor）、状态描述（status_desc）、'
    '记录时间（record_time）等。该表为告警评估提供数据源，每次状态写入后将触发规则评估流程。'
))"""

new2 = """    '设备状态表（eq_device_status）用于存储设备运行状态数据，与设备台账表通过 device_id 外键关联。'
    '该表为告警评估提供数据源，每次状态写入后将触发规则评估流程。'
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
    caption='表3.4 eq_device_status（设备状态表）结构',
)"""

content = content.replace(old2, new2, 1)
print("  eq_device_status table - done")

# 3. eq_alert
old3 = """    '告警记录表（eq_alert）记录系统触发的告警事件。主要字段包括：告警编号（alert_id，主键）、'
    '设备编号（device_id）、告警类型（alert_type）、告警级别（alert_level）、告警内容（alert_content）、'
    '触发时间（trigger_time）、确认状态（confirm_status）、处理人（handler）、处理时间（handle_time）、'
    '处理结果（handle_result）等。告警记录是运维人员了解设备异常状态的主要信息来源。'
))"""

new3 = """    '告警记录表（eq_alert）记录系统触发的告警事件，是运维人员了解设备异常状态的主要信息来源。'
))
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
    caption='表3.5 eq_alert（告警记录表）结构',
)"""

content = content.replace(old3, new3, 1)
print("  eq_alert table - done")

# 4. ai_maintenance_form
old4 = """    '运维工单表（ai_maintenance_form）存储运维工单的流转信息。主要字段包括：工单编号（form_id，主键）、'
    '设备编号（device_id）、工单标题（title）、工单内容（content）、AI 摘要（ai_summary）、'
    '工单状态（status）、创建人（create_by）、创建时间（create_time）、处理人（handler）、'
    '完成时间（finish_time）等。工单状态包括待处理、处理中和已关闭等多个阶段。'
))"""

new4 = """    '运维工单表（ai_maintenance_form）存储运维工单的流转信息，记录工单生命周期中各环节的操作数据。'
))
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
    caption='表3.6 ai_maintenance_form（运维工单表）结构',
)"""

content = content.replace(old4, new4, 1)
print("  ai_maintenance_form table - done")

# 5. ai_chat_record
old5 = """    'AI 对话记录表（ai_chat_record）用于存储用户与 AI 助手的对话历史。'
    '主要字段包括：记录编号（id，主键）、会话编号（session_id）、用户问题（question）、'
    'AI 回答（answer）、对话模式（mode，如 free、rag、db 等）、创建时间（create_time）等。'
    '对话历史支持用户回顾之前的问答内容，也用于模型微调场景的数据积累。'
))"""

new5 = """    'AI 对话记录表（ai_chat_record）用于存储用户与 AI 助手的对话历史，支持用户回顾之前的问答内容。'
))
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
    caption='表3.7 ai_chat_record（AI对话记录表）结构',
)"""

content = content.replace(old5, new5, 1)
print("  ai_chat_record table - done")

# 6. eq_prediction
old6 = """    '风电功率预测表（eq_prediction）存储功率预测的详细结果。主要字段包括：预测编号（id，主键）、'
    '设备编号（device_id）、预测时间点（prediction_time）、实际功率（actual_power）、'
    '预测功率（predicted_power）、预测步长（step）、创建时间（create_time）等。'
    '该表与设备统计表（eq_device_stat）配合使用，前者存储细粒度预测值，后者存储聚合统计指标。'
))"""

new6 = """    '风电功率预测表（eq_prediction）存储功率预测的详细结果，与设备统计表（eq_device_stat）配合使用。'
))
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
    caption='表3.8 eq_prediction（风电功率预测表）结构',
)"""

content = content.replace(old6, new6, 1)
print("  eq_prediction table - done")

with open('generate_complete_thesis.py', 'w', encoding='utf-8') as f:
    f.write(content)
print("\nAll 6 database tables in section 3.3 converted to three-line tables!")
