-- =============================================
-- 完整的设备数据插入脚本 - 最终版
-- 严格按照数据库实际字段结构生成
-- 生成时间: 2026-01-12
-- =============================================

SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO';

-- 清理需要插入数据的表（只清理没有数据的表）
TRUNCATE TABLE eq_maintenance_record;
TRUNCATE TABLE eq_fault_record;
TRUNCATE TABLE eq_electrical_data;
TRUNCATE TABLE eq_mechanical_data;
TRUNCATE TABLE eq_operational_data;
TRUNCATE TABLE eq_technology_data;

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================
-- 1. 插入维护记录 (每设备3条 = 60条)
-- 字段：record_id, device_id, maintenance_type, maintenance_date, next_maintenance_date,
--       maintenance_cost, performed_by, description, parts_replaced (JSON), technician_notes, status, remark
-- =============================================
INSERT INTO eq_maintenance_record (device_id, maintenance_type, maintenance_date, next_maintenance_date,
                                   maintenance_cost, performed_by, description, parts_replaced, technician_notes,
                                   status, remark, create_by, create_time)
SELECT device_id,
       1                                                     as maintenance_type,
       DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 90) DAY)      as maintenance_date,
       DATE_ADD(NOW(), INTERVAL FLOOR(30 + RAND() * 60) DAY) as next_maintenance_date,
       ROUND(1000 + RAND() * 4000, 2)                        as maintenance_cost,
       '维护班组A'                                           as performed_by,
       '定期预防性维护检查'                                  as description,
       '["滤芯","密封圈"]'                                   as parts_replaced,
       '设备运行正常，无异常'                                 as technician_notes,
       1                                                     as status,
       '维护完成'                                            as remark,
       'admin'                                               as create_by,
       NOW()                                                 as create_time
FROM eq_device
         CROSS JOIN (SELECT 1 UNION SELECT 2 UNION SELECT 3) n;

SELECT CONCAT('✅ 维护记录表: ', COUNT(*), ' 条记录') AS ''
FROM eq_maintenance_record;

-- =============================================
-- 2. 插入故障记录 (每设备3条 = 60条)
-- 字段：fault_id, device_id, fault_code, fault_description, fault_level, detected_time, resolved_time,
--       resolution_notes, root_cause, repair_duration, repair_cost, parts_replaced (JSON), status, remark
-- =============================================
INSERT INTO eq_fault_record (device_id, fault_code, fault_description, fault_level, detected_time, resolved_time,
                             resolution_notes, root_cause, repair_duration, repair_cost, parts_replaced, status, remark,
                             create_by, create_time)
SELECT device_id,
       CONCAT('F', LPAD(FLOOR(1000 + RAND() * 9000), 4, '0')) as fault_code,
       CASE FLOOR(1 + RAND() * 5)
           WHEN 1 THEN '电压异常波动'
           WHEN 2 THEN '温度过高报警'
           WHEN 3 THEN '电流过载'
           WHEN 4 THEN '绝缘故障'
           ELSE '机械磨损'
           END                                                as fault_description,
       FLOOR(1 + RAND() * 4)                                 as fault_level,
       DATE_SUB(NOW(), INTERVAL FLOOR(30 + RAND() * 60) DAY)  as detected_time,
       DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 30) DAY)       as resolved_time,
       '故障已修复，设备恢复正常运行'                         as resolution_notes,
       CASE FLOOR(1 + RAND() * 3)
           WHEN 1 THEN '部件老化'
           WHEN 2 THEN '操作不当'
           ELSE '环境因素'
           END                                                as root_cause,
       FLOOR(30 + RAND() * 120)                              as repair_duration,
       ROUND(500 + RAND() * 3000, 2)                         as repair_cost,
       CASE WHEN RAND() < 0.5 THEN '["接触器"]' ELSE '["继电器","保险丝"]' END as parts_replaced,
       2                                                     as status,
       '故障已解决'                                          as remark,
       'admin'                                               as create_by,
       NOW()                                                 as create_time
FROM eq_device
         CROSS JOIN (SELECT 1 UNION SELECT 2 UNION SELECT 3) n;

SELECT CONCAT('✅ 故障记录表: ', COUNT(*), ' 条记录') AS ''
FROM eq_fault_record;

-- =============================================
-- 3. 插入电气数据 (每设备3条 = 60条)
-- 字段：electrical_id, device_id, timestamp, voltage_l1, voltage_l2, voltage_l3, voltage_unbalance, frequency,
--       voltage_fluctuation, current_l1, current_l2, current_l3, current_unbalance, total_current, active_power,
--       reactive_power, apparent_power, power_factor, efficiency, harmonics_voltage (JSON), harmonics_current (JSON),
--       total_harmonic_distortion, voltage_thd, current_thd, electromagnetic_interference, grounding_resistance,
--       shielding_effectiveness, electrical_grade
-- =============================================
INSERT INTO eq_electrical_data (device_id, timestamp, voltage_l1, voltage_l2, voltage_l3, voltage_unbalance, frequency,
                                voltage_fluctuation, current_l1, current_l2, current_l3, current_unbalance,
                                total_current, active_power, reactive_power, apparent_power, power_factor, efficiency,
                                harmonics_voltage, harmonics_current, total_harmonic_distortion, voltage_thd,
                                current_thd, electromagnetic_interference, grounding_resistance,
                                shielding_effectiveness, electrical_grade, create_time)
SELECT device_id,
       DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 48) HOUR) as timestamp,
       ROUND(107 + RAND() * 7, 2)                        as voltage_l1,
       ROUND(107 + RAND() * 7, 2)                        as voltage_l2,
       ROUND(107 + RAND() * 7, 2)                        as voltage_l3,
       ROUND(RAND() * 2, 4)                              as voltage_unbalance,
       ROUND(49.8 + RAND() * 0.4, 2)                     as frequency,
       ROUND(RAND() * 3, 4)                              as voltage_fluctuation,
       ROUND(145 + RAND() * 45, 4)                       as current_l1,
       ROUND(145 + RAND() * 45, 4)                       as current_l2,
       ROUND(145 + RAND() * 45, 4)                       as current_l3,
       ROUND(RAND() * 3, 4)                              as current_unbalance,
       ROUND(450 + RAND() * 100, 4)                      as total_current,
       ROUND(14 + RAND() * 9, 4)                         as active_power,
       ROUND(2 + RAND() * 3, 4)                          as reactive_power,
       ROUND(17 + RAND() * 8, 4)                         as apparent_power,
       ROUND(0.83 + RAND() * 0.12, 4)                    as power_factor,
       ROUND(88 + RAND() * 10, 4)                        as efficiency,
       '{"V3": 2.5, "V5": 1.8, "V7": 1.2}'              as harmonics_voltage,
       '{"I3": 4.2, "I5": 3.1, "I7": 2.0}'              as harmonics_current,
       ROUND(2 + RAND() * 3, 4)                          as total_harmonic_distortion,
       ROUND(1 + RAND() * 2, 4)                          as voltage_thd,
       ROUND(2 + RAND() * 3, 4)                          as current_thd,
       ROUND(30 + RAND() * 20, 4)                        as electromagnetic_interference,
       ROUND(0.5 + RAND() * 2, 4)                        as grounding_resistance,
       ROUND(85 + RAND() * 10, 4)                        as shielding_effectiveness,
       FLOOR(1 + RAND() * 2)                             as electrical_grade,
       NOW()                                              as create_time
FROM eq_device
         CROSS JOIN (SELECT 1 UNION SELECT 2 UNION SELECT 3) n;

SELECT CONCAT('✅ 电气数据表: ', COUNT(*), ' 条记录') AS ''
FROM eq_electrical_data;

-- =============================================
-- 4. 插入机械数据 (每设备3条 = 60条)
-- 字段：mechanical_id, device_id, timestamp, load_weight, load_ratio, stress_level, fatigue_cycles,
--       overload_times, vibration_amplitude, vibration_velocity, vibration_acceleration, vibration_spectrum (JSON),
--       vibration_direction, corrosion_rate, corrosion_depth, surface_condition, coating_thickness,
--       material_temperature, thermal_expansion, material_hardness, mechanical_grade
-- =============================================
INSERT INTO eq_mechanical_data (device_id, timestamp, load_weight, load_ratio, stress_level, fatigue_cycles,
                                overload_times, vibration_amplitude, vibration_velocity, vibration_acceleration,
                                vibration_spectrum, vibration_direction, corrosion_rate, corrosion_depth,
                                surface_condition, coating_thickness, material_temperature, thermal_expansion,
                                material_hardness, mechanical_grade, create_time)
SELECT device_id,
       DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 48) HOUR)  as timestamp,
       ROUND(4000 + RAND() * 16000, 2)                    as load_weight,
       ROUND(55 + RAND() * 35, 4)                         as load_ratio,
       ROUND(45 + RAND() * 105, 4)                        as stress_level,
       FLOOR(8000 + RAND() * 52000)                       as fatigue_cycles,
       FLOOR(RAND() * 11)                                 as overload_times,
       ROUND(RAND() * 6, 6)                               as vibration_amplitude,
       ROUND(4 + RAND() * 16, 6)                          as vibration_velocity,
       ROUND(0.5 + RAND() * 5, 6)                         as vibration_acceleration,
       '{"freq_10": 0.5, "freq_20": 1.2, "freq_50": 2.8}' as vibration_spectrum,
       CASE WHEN RAND() < 0.5 THEN '水平' ELSE '垂直' END as vibration_direction,
       ROUND(RAND() * 0.6, 6)                             as corrosion_rate,
       ROUND(RAND() * 2.5, 4)                             as corrosion_depth,
       FLOOR(1 + RAND() * 4)                              as surface_condition,
       ROUND(45 + RAND() * 155, 4)                        as coating_thickness,
       ROUND(18 + RAND() * 82, 2)                         as material_temperature,
       ROUND(RAND() * 2.5, 6)                             as thermal_expansion,
       ROUND(145 + RAND() * 105, 4)                      as material_hardness,
       FLOOR(1 + RAND() * 3)                              as mechanical_grade,
       NOW()                                              as create_time
FROM eq_device
         CROSS JOIN (SELECT 1 UNION SELECT 2 UNION SELECT 3) n;

SELECT CONCAT('✅ 机械数据表: ', COUNT(*), ' 条记录') AS ''
FROM eq_mechanical_data;

-- =============================================
-- 5. 插入操作数据 (每设备3条 = 60条)
-- 字段：operational_id, device_id, timestamp, operator_id, operator_name, operator_skill_level,
--       training_completion, operation_type, operation_duration, operation_result (tinyint), operation_notes,
--       maintenance_type, maintenance_duration, maintenance_cost, parts_used (JSON), operator_performance_score,
--       safety_compliance
-- =============================================
INSERT INTO eq_operational_data (device_id, timestamp, operator_id, operator_name, operator_skill_level,
                                 training_completion, operation_type, operation_duration, operation_result,
                                 operation_notes, maintenance_type, maintenance_duration, maintenance_cost,
                                 parts_used, operator_performance_score, safety_compliance, create_time)
SELECT device_id,
       DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 72) HOUR) as timestamp,
       FLOOR(1001 + RAND() * 100)                        as operator_id,
       CONCAT('操作员', FLOOR(1 + RAND() * 30))          as operator_name,
       FLOOR(2 + RAND() * 3)                             as operator_skill_level,
       FLOOR(70 + RAND() * 30)                           as training_completion,
       FLOOR(1 + RAND() * 5)                             as operation_type,
       FLOOR(25 + RAND() * 125)                          as operation_duration,
       CASE
           WHEN RAND() < 0.82 THEN 1
           WHEN RAND() < 0.96 THEN 2
           ELSE 3
           END                                           as operation_result,
       CASE
           WHEN RAND() < 0.5 THEN '操作顺利完成'
           WHEN RAND() < 0.8 THEN '操作正常，无异常'
           ELSE '操作完成，有轻微警告'
           END                                           as operation_notes,
       FLOOR(1 + RAND() * 4)                             as maintenance_type,
       FLOOR(15 + RAND() * 60)                           as maintenance_duration,
       ROUND(200 + RAND() * 800, 2)                      as maintenance_cost,
       CASE WHEN RAND() < 0.5 THEN '["滤芯"]' ELSE '["密封圈","润滑油"]' END as parts_used,
       ROUND(75 + RAND() * 20, 4)                        as operator_performance_score,
       FLOOR(1 + RAND() * 4)                             as safety_compliance,
       NOW()                                             as create_time
FROM eq_device
         CROSS JOIN (SELECT 1 UNION SELECT 2 UNION SELECT 3) n;

SELECT CONCAT('✅ 操作数据表: ', COUNT(*), ' 条记录') AS ''
FROM eq_operational_data;

-- =============================================
-- 6. 插入技术数据 (每设备3条 = 60条)
-- 字段：tech_id, device_id, timestamp, technology_level, upgrade_status, standard_compliance (JSON),
--       certification_status, software_version, firmware_version, system_updates, digitalization_level,
--       connectivity_level, technology_maturity, obsolescence_risk
-- =============================================
INSERT INTO eq_technology_data (device_id, timestamp, technology_level, upgrade_status, standard_compliance,
                                certification_status, software_version, firmware_version, system_updates,
                                digitalization_level, connectivity_level, technology_maturity, obsolescence_risk,
                                create_time)
SELECT device_id,
       DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 90) DAY)                                     as timestamp,
       FLOOR(2 + RAND() * 3)                                                                as technology_level,
       FLOOR(1 + RAND() * 3)                                                                as upgrade_status,
       '{"GB/T 19001-2016": "符合", "IEC 61850": "符合", "IEEE 1547": "部分符合"}'          as standard_compliance,
       FLOOR(1 + RAND() * 3)                                                                as certification_status,
       CONCAT('V', FLOOR(1 + RAND() * 3), '.', FLOOR(RAND() * 10), '.', FLOOR(RAND() * 20)) as software_version,
       CONCAT('FW', FLOOR(1 + RAND() * 2), '.', FLOOR(RAND() * 5), '.', FLOOR(RAND() * 10))  as firmware_version,
       FLOOR(5 + RAND() * 20)                                                                as system_updates,
       FLOOR(2 + RAND() * 3)                                                                as digitalization_level,
       FLOOR(2 + RAND() * 3)                                                                as connectivity_level,
       FLOOR(2 + RAND() * 3)                                                                as technology_maturity,
       FLOOR(1 + RAND() * 4)                                                                as obsolescence_risk,
       NOW()                                                                                 as create_time
FROM eq_device
         CROSS JOIN (SELECT 1 UNION SELECT 2 UNION SELECT 3) n;

SELECT CONCAT('✅ 技术数据表: ', COUNT(*), ' 条记录') AS ''
FROM eq_technology_data;

-- =============================================
-- 完成提示
-- =============================================
SELECT '========================================' AS '';
SELECT '✅ 所有数据插入完成！' AS '';
SELECT '========================================' AS '';
SELECT CONCAT('维护记录: ', (SELECT COUNT(*) FROM eq_maintenance_record), ' 条') AS '';
SELECT CONCAT('故障记录: ', (SELECT COUNT(*) FROM eq_fault_record), ' 条') AS '';
SELECT CONCAT('电气数据: ', (SELECT COUNT(*) FROM eq_electrical_data), ' 条') AS '';
SELECT CONCAT('机械数据: ', (SELECT COUNT(*) FROM eq_mechanical_data), ' 条') AS '';
SELECT CONCAT('操作数据: ', (SELECT COUNT(*) FROM eq_operational_data), ' 条') AS '';
SELECT CONCAT('技术数据: ', (SELECT COUNT(*) FROM eq_technology_data), ' 条') AS '';
