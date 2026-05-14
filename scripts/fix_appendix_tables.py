# -*- coding: utf-8 -*-
"""Convert Appendix A database tables to three-line tables."""
with open('generate_complete_thesis.py', 'r', encoding='utf-8') as f:
    content = f.read()

# A.1 eq_device
old = """h2(doc, 'A.1  设备台账表（eq_device）')
body(doc, (
    '设备台账表存储电网设备的基础信息，字段定义包括：device_id（BIGINT，主键）、'
    'device_name（VARCHAR(100)）、device_type（VARCHAR(50)）、specification（VARCHAR(100)）、'
    'location（VARCHAR(200)）、commission_date（DATE）、manufacturer（VARCHAR(100)）、'
    'device_status（VARCHAR(20)）、create_time（DATETIME）、update_time（DATETIME）。'
))"""

new = """h2(doc, 'A.1  设备台账表（eq_device）')
body(doc, '设备台账表存储电网设备的基础信息，其字段定义如下表所示。')
make_three_line_table(doc,
    ['字段名', '类型', '约束', '说明'],
    [
        ['device_id', 'BIGINT', 'PRIMARY KEY', '设备编号'],
        ['device_name', 'VARCHAR(100)', 'NOT NULL', '设备名称'],
        ['device_type', 'VARCHAR(50)', 'INDEX', '设备类型'],
        ['specification', 'VARCHAR(100)', '', '规格型号'],
        ['location', 'VARCHAR(200)', '', '安装位置'],
        ['commission_date', 'DATE', '', '投运日期'],
        ['manufacturer', 'VARCHAR(100)', '', '制造商'],
        ['device_status', 'VARCHAR(20)', "DEFAULT 'normal'", '设备状态'],
        ['create_time', 'DATETIME', 'NOT NULL', '创建时间'],
        ['update_time', 'DATETIME', '', '更新时间'],
    ],
    label='表A.1 eq_device（设备台账表）结构',
)"""

content = content.replace(old, new, 1)
print("  A.1 done")

# A.2 eq_device_status
old = """h2(doc, 'A.2  设备状态表（eq_device_status）')
body(doc, (
    '设备状态表存储设备运行状态数据，字段定义包括：status_id（BIGINT，主键）、'
    'device_id（BIGINT，外键关联 eq_device）、temperature（DECIMAL(10,2)）、'
    'voltage（DECIMAL(10,2)）、current（DECIMAL(10,2)）、power_factor（DECIMAL(5,4)）、'
    'status_desc（VARCHAR(500)）、record_time（DATETIME）。'
))"""

new = """h2(doc, 'A.2  设备状态表（eq_device_status）')
body(doc, '设备状态表存储设备运行状态数据，其字段定义如下表所示。')
make_three_line_table(doc,
    ['字段名', '类型', '约束', '说明'],
    [
        ['status_id', 'BIGINT', 'PRIMARY KEY', '状态编号'],
        ['device_id', 'BIGINT', 'FOREIGN KEY', '关联设备编号'],
        ['temperature', 'DECIMAL(10,2)', '', '温度（℃）'],
        ['voltage', 'DECIMAL(10,2)', '', '电压（kV）'],
        ['current', 'DECIMAL(10,2)', '', '电流（A）'],
        ['power_factor', 'DECIMAL(5,4)', '', '功率因数'],
        ['status_desc', 'VARCHAR(500)', '', '状态描述'],
        ['record_time', 'DATETIME', 'NOT NULL', '记录时间'],
    ],
    label='表A.2 eq_device_status（设备状态表）结构',
)"""

content = content.replace(old, new, 1)
print("  A.2 done")

# A.3 eq_alert
old = """h2(doc, 'A.3  告警记录表（eq_alert）')
body(doc, (
    '告警记录表存储系统触发的告警事件，字段定义包括：alert_id（BIGINT，主键）、'
    'device_id（BIGINT）、alert_type（VARCHAR(50)）、alert_level（VARCHAR(20)）、'
    'alert_content（TEXT）、trigger_time（DATETIME）、confirm_status（VARCHAR(20)）、'
    'handler（VARCHAR(50)）、handle_time（DATETIME）、handle_result（VARCHAR(500)）。'
))"""

new = """h2(doc, 'A.3  告警记录表（eq_alert）')
body(doc, '告警记录表存储系统触发的告警事件，其字段定义如下表所示。')
make_three_line_table(doc,
    ['字段名', '类型', '约束', '说明'],
    [
        ['alert_id', 'BIGINT', 'PRIMARY KEY', '告警编号'],
        ['device_id', 'BIGINT', 'INDEX', '关联设备编号'],
        ['alert_type', 'VARCHAR(50)', 'NOT NULL', '告警类型'],
        ['alert_level', 'VARCHAR(20)', 'NOT NULL', '告警级别'],
        ['alert_content', 'TEXT', '', '告警内容'],
        ['trigger_time', 'DATETIME', 'NOT NULL', '触发时间'],
        ['confirm_status', 'VARCHAR(20)', "DEFAULT 'pending'", '确认状态'],
        ['handler', 'VARCHAR(50)', '', '处理人'],
        ['handle_time', 'DATETIME', '', '处理时间'],
        ['handle_result', 'VARCHAR(500)', '', '处理结果'],
    ],
    label='表A.3 eq_alert（告警记录表）结构',
)"""

content = content.replace(old, new, 1)
print("  A.3 done")

# A.4 ai_maintenance_form
old = """h2(doc, 'A.4  运维工单表（ai_maintenance_form）')
body(doc, (
    '运维工单表存储工单的流转信息，字段定义包括：form_id（BIGINT，主键）、'
    'device_id（BIGINT）、title（VARCHAR(200)）、content（TEXT）、'
    'ai_summary（VARCHAR(500)）、status（VARCHAR(20)）、create_by（VARCHAR(50)）、'
    'create_time（DATETIME）、handler（VARCHAR(50)）、finish_time（DATETIME）。'
))"""

new = """h2(doc, 'A.4  运维工单表（ai_maintenance_form）')
body(doc, '运维工单表存储工单的流转信息，其字段定义如下表所示。')
make_three_line_table(doc,
    ['字段名', '类型', '约束', '说明'],
    [
        ['form_id', 'BIGINT', 'PRIMARY KEY', '工单编号'],
        ['device_id', 'BIGINT', 'INDEX', '关联设备编号'],
        ['title', 'VARCHAR(200)', 'NOT NULL', '工单标题'],
        ['content', 'TEXT', '', '工单内容'],
        ['ai_summary', 'VARCHAR(500)', '', 'AI摘要'],
        ['status', 'VARCHAR(20)', "DEFAULT 'pending'", '工单状态'],
        ['create_by', 'VARCHAR(50)', 'NOT NULL', '创建人'],
        ['create_time', 'DATETIME', 'NOT NULL', '创建时间'],
        ['handler', 'VARCHAR(50)', '', '处理人'],
        ['finish_time', 'DATETIME', '', '完成时间'],
    ],
    label='表A.4 ai_maintenance_form（运维工单表）结构',
)"""

content = content.replace(old, new, 1)
print("  A.4 done")

# A.5 ai_chat_record
old = """h2(doc, 'A.5  AI 对话记录表（ai_chat_record）')
body(doc, (
    'AI 对话记录表存储用户与 AI 助手的对话历史，字段定义包括：'
    'id（BIGINT，主键）、session_id（VARCHAR(100)）、question（TEXT）、'
    'answer（TEXT）、mode（VARCHAR(20)）、create_time（DATETIME）。'
))"""

new = """h2(doc, 'A.5  AI 对话记录表（ai_chat_record）')
body(doc, 'AI 对话记录表存储用户与 AI 助手的对话历史，其字段定义如下表所示。')
make_three_line_table(doc,
    ['字段名', '类型', '约束', '说明'],
    [
        ['id', 'BIGINT', 'PRIMARY KEY', '记录编号'],
        ['session_id', 'VARCHAR(100)', 'INDEX', '会话编号'],
        ['question', 'TEXT', 'NOT NULL', '用户问题'],
        ['answer', 'TEXT', '', 'AI回答'],
        ['mode', 'VARCHAR(20)', "DEFAULT 'free'", '对话模式'],
        ['create_time', 'DATETIME', 'NOT NULL', '创建时间'],
    ],
    label='表A.5 ai_chat_record（AI对话记录表）结构',
)"""

content = content.replace(old, new, 1)
print("  A.5 done")

# A.6 eq_prediction
old = """h2(doc, 'A.6  风电功率预测表（eq_prediction）')
body(doc, (
    '风电功率预测表存储功率预测的详细结果，字段定义包括：'
    'id（BIGINT，主键）、device_id（BIGINT）、prediction_time（DATETIME）、'
    'actual_power（DECIMAL(10,2)）、predicted_power（DECIMAL(10,2)）、'
    'step（INT）、create_time（DATETIME）。'
))"""

new = """h2(doc, 'A.6  风电功率预测表（eq_prediction）')
body(doc, '风电功率预测表存储功率预测的详细结果，其字段定义如下表所示。')
make_three_line_table(doc,
    ['字段名', '类型', '约束', '说明'],
    [
        ['id', 'BIGINT', 'PRIMARY KEY', '预测编号'],
        ['device_id', 'BIGINT', 'INDEX', '关联设备编号'],
        ['prediction_time', 'DATETIME', 'NOT NULL', '预测时间'],
        ['actual_power', 'DECIMAL(10,2)', '', '实际功率（kW）'],
        ['predicted_power', 'DECIMAL(10,2)', 'NOT NULL', '预测功率（kW）'],
        ['step', 'INT', '', '预测步长'],
        ['create_time', 'DATETIME', 'NOT NULL', '创建时间'],
    ],
    label='表A.6 eq_prediction（风电功率预测表）结构',
)"""

content = content.replace(old, new, 1)
print("  A.6 done")

with open('generate_complete_thesis.py', 'w', encoding='utf-8') as f:
    f.write(content)
print("\nAll 6 Appendix A tables converted to three-line tables!")
