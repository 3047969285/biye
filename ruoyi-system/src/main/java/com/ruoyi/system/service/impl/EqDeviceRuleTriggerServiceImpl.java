package com.ruoyi.system.service.impl;

import com.ruoyi.common.constant.EquipmentRuleConstants;
import com.ruoyi.system.domain.EqAlertRecord;
import com.ruoyi.system.domain.EqDeviceRule;
import com.ruoyi.system.domain.EqDeviceStatus;
import com.ruoyi.system.domain.dto.RuleTriggerResult;
import com.ruoyi.system.mapper.EqAlertRecordMapper;
import com.ruoyi.system.mapper.EqDeviceRuleMapper;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.service.IEqDeviceRuleTriggerService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 设备规则触发Service业务层处理
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Service
public class EqDeviceRuleTriggerServiceImpl implements IEqDeviceRuleTriggerService {

    /** 日志记录器 */
    private static final Logger log = LoggerFactory.getLogger(EqDeviceRuleTriggerServiceImpl.class);

    /** 等值比较容差（用于浮点阈值比较） */
    private static final BigDecimal EPS = new BigDecimal("0.0001");

    /** 区间解析正则：支持 "a-b" 或 "a,b" 形式 */
    private static final Pattern RANGE_IN_UNIT = Pattern.compile(
        "^\\s*(-?\\d+(?:\\.\\d+)?)\\s*[-,]\\s*(-?\\d+(?:\\.\\d+)?)\\s*$");

    /** 规则参数中文名与状态字段键名映射 */
    private static final Map<String, String> PARAM_ALIASES = new HashMap<>();

    /** 初始化规则参数别名 */
    static {
        PARAM_ALIASES.put("温度", "temperature");
        PARAM_ALIASES.put("湿度", "humidity");
        PARAM_ALIASES.put("压力", "pressure");
        PARAM_ALIASES.put("振动", "vibration");
        PARAM_ALIASES.put("电流", "current");
        PARAM_ALIASES.put("电压", "voltage");
        PARAM_ALIASES.put("功率", "power");
        PARAM_ALIASES.put("转速", "rpm");
        PARAM_ALIASES.put("流量", "flowRate");
        PARAM_ALIASES.put("液位", "liquidLevel");
        PARAM_ALIASES.put("运行状态", "status");
        PARAM_ALIASES.put("是否需要维护", "maintenanceRequired");
        PARAM_ALIASES.put("故障次数", "faultCount");
        PARAM_ALIASES.put("报警次数", "alarmCount");
    }

    /** 设备规则数据访问层 */
    @Autowired
    private EqDeviceRuleMapper eqDeviceRuleMapper;

    /** 告警记录数据访问层 */
    @Autowired
    private EqAlertRecordMapper eqAlertRecordMapper;

    /**
     * 根据设备状态快照匹配规则，计算目标运行状态并产生告警等副作用
     *
     * @param data 设备状态快照
     * @return 规则触发汇总结果
     */
    @Override
    public RuleTriggerResult fireRulesForSnapshot(EqDeviceStatus data) {
        RuleTriggerResult result = new RuleTriggerResult();
        if (data == null || data.getDeviceId() == null) {
            result.setBaselineRunningStatus(EquipmentRuleConstants.RUNNING_NORMAL);
            result.setTargetRunningStatus(EquipmentRuleConstants.RUNNING_NORMAL);
            return result;
        }

        List<EqDeviceRule> rules = eqDeviceRuleMapper.selectEqDeviceRuleListByDeviceId(data.getDeviceId());
        if (rules == null || rules.isEmpty()) {
            int baseline = defaultRunningStatus(data.getStatus());
            result.setBaselineRunningStatus(baseline);
            result.setTargetRunningStatus(baseline);
            result.setRulesEvaluated(0);
            return result;
        }

        boolean needMaintenance = false;
        int baselineRunning = defaultRunningStatus(data.getStatus());
        int targetRunning = baselineRunning;
        int evaluated = 0;
        int hit = 0;
        int alertsInserted = 0;

        for (EqDeviceRule rule : rules) {
            if (isRuleDisabled(rule) || isRuleConfigIncomplete(rule)) {
                continue;
            }
            evaluated++;

            BigDecimal actual = resolveParameterValue(data, rule.getParameterName());
            if (actual == null) {
                log.debug("规则跳过（测点值为空）deviceId={} ruleId={} parameter={}",
                    data.getDeviceId(), rule.getRuleId(), rule.getParameterName());
                continue;
            }
            if (!matches(rule, actual)) {
                continue;
            }
            hit++;

            int fromRule = mapAlertLevelToRunningStatus(rule.getAlertLevel());
            targetRunning = Math.max(targetRunning, fromRule);

            boolean duplicateOpen = rule.getRuleId() != null
                && eqAlertRecordMapper.countUnresolvedByDeviceAndRule(data.getDeviceId(), rule.getRuleId()) > 0;
            if (duplicateOpen) {
                log.debug("规则已命中但存在未处理同规则告警，不重复入库 deviceId={} ruleId={}",
                    data.getDeviceId(), rule.getRuleId());
            } else {
                if (insertAlert(data, rule, actual)) {
                    alertsInserted++;
                }
            }

            if (rule.getAlertLevel() != null
                && rule.getAlertLevel() >= EquipmentRuleConstants.ALERT_LEVEL_SERIOUS) {
                needMaintenance = true;
            }
        }

        result.setBaselineRunningStatus(baselineRunning);
        result.setTargetRunningStatus(targetRunning);
        result.setNeedMaintenance(needMaintenance);
        result.setRulesEvaluated(evaluated);
        result.setRulesHit(hit);
        result.setAlertsInserted(alertsInserted);
        return result;
    }

    /**
     * 解析基线运行状态
     *
     * @param status 状态值
     * @return 运行状态
     */
    private static int defaultRunningStatus(Integer status) {
        return status != null ? status : EquipmentRuleConstants.RUNNING_NORMAL;
    }

    /**
     * 判断规则是否禁用
     *
     * @param rule 设备规则
     * @return true表示禁用
     */
    private static boolean isRuleDisabled(EqDeviceRule rule) {
        return rule.getEnabled() != null && rule.getEnabled() == EquipmentRuleConstants.RULE_DISABLED;
    }

    /**
     * 判断规则配置是否完整
     *
     * @param rule 设备规则
     * @return true表示配置不完整
     */
    private static boolean isRuleConfigIncomplete(EqDeviceRule rule) {
        return rule.getConditionType() == null || rule.getThresholdValue() == null;
    }

    /**
     * 告警等级映射为运行状态
     *
     * @param alertLevel 告警等级
     * @return 运行状态
     */
    private static int mapAlertLevelToRunningStatus(Integer alertLevel) {
        if (alertLevel == null) {
            return EquipmentRuleConstants.RUNNING_WARNING;
        }
        switch (alertLevel) {
            case EquipmentRuleConstants.ALERT_LEVEL_NORMAL:
                return EquipmentRuleConstants.RUNNING_WARNING;
            case EquipmentRuleConstants.ALERT_LEVEL_SERIOUS:
            case EquipmentRuleConstants.ALERT_LEVEL_CRITICAL:
                return EquipmentRuleConstants.RUNNING_ERROR;
            default:
                return EquipmentRuleConstants.RUNNING_WARNING;
        }
    }

    /**
     * 写入告警记录
     *
     * @param status 设备状态快照
     * @param rule 命中规则
     * @param actual 参数实际值
     * @return true表示写入成功
     */
    private boolean insertAlert(EqDeviceStatus status, EqDeviceRule rule, BigDecimal actual) {
        EqAlertRecord rec = new EqAlertRecord();
        rec.setDeviceId(status.getDeviceId());
        rec.setRuleId(rule.getRuleId());
        rec.setAlertLevel(rule.getAlertLevel());
        rec.setAlertType(StringUtils.isNotEmpty(rule.getRuleName()) ? rule.getRuleName().trim() : "规则告警");
        rec.setTriggeredTime(new Date());
        rec.setStatus(EquipmentRuleConstants.ALERT_RECORD_TRIGGERED);
        String paramKey = normalizeParameterKey(rule.getParameterName());
        String unit = rule.getThresholdUnit() != null ? rule.getThresholdUnit() : "";
        rec.setAlertMessage(String.format(Locale.CHINA, "规则[%s]触发：参数[%s]当前值 %s %s，条件类型=%s，阈值 %s",
            rule.getRuleName(),
            paramKey,
            actual.stripTrailingZeros().toPlainString(),
            unit,
            describeCondition(rule),
            formatThreshold(rule)));
        rec.setRemark("规则引擎");
        try {
            eqAlertRecordMapper.insertEqAlertRecord(rec);
            return true;
        } catch (Exception e) {
            log.warn("写入告警失败 deviceId={} ruleId={}: {}", status.getDeviceId(), rule.getRuleId(), e.getMessage());
            return false;
        }
    }

    /**
     * 获取条件类型描述文本
     *
     * @param rule 设备规则
     * @return 条件描述
     */
    private static String describeCondition(EqDeviceRule rule) {
        Integer t = rule.getConditionType();
        if (t == null) {
            return "?";
        }
        switch (t) {
            case EquipmentRuleConstants.CONDITION_GREATER_THAN:
                return "大于";
            case EquipmentRuleConstants.CONDITION_LESS_THAN:
                return "小于";
            case EquipmentRuleConstants.CONDITION_EQUALS:
                return "等于";
            case EquipmentRuleConstants.CONDITION_OUT_OF_RANGE:
                return "区间外";
            default:
                return String.valueOf(t);
        }
    }

    /**
     * 格式化阈值展示文本
     *
     * @param rule 设备规则
     * @return 阈值文本
     */
    private static String formatThreshold(EqDeviceRule rule) {
        if (rule.getConditionType() != null && rule.getConditionType() == EquipmentRuleConstants.CONDITION_OUT_OF_RANGE) {
            BigDecimal[] range = parseRangeBounds(rule);
            if (range != null) {
                return "[" + range[0].stripTrailingZeros().toPlainString() + ", "
                    + range[1].stripTrailingZeros().toPlainString() + "]";
            }
        }
        return rule.getThresholdValue() != null
            ? rule.getThresholdValue().stripTrailingZeros().toPlainString() : "";
    }

    /**
     * 判断规则是否命中
     *
     * @param rule 设备规则
     * @param value 实际值
     * @return true表示命中
     */
    private boolean matches(EqDeviceRule rule, BigDecimal value) {
        Integer ct = rule.getConditionType();
        BigDecimal th = rule.getThresholdValue();
        if (ct == null || th == null) {
            return false;
        }
        switch (ct) {
            case EquipmentRuleConstants.CONDITION_GREATER_THAN:
                return value.compareTo(th) > 0;
            case EquipmentRuleConstants.CONDITION_LESS_THAN:
                return value.compareTo(th) < 0;
            case EquipmentRuleConstants.CONDITION_EQUALS:
                return value.subtract(th).abs().compareTo(EPS) <= 0;
            case EquipmentRuleConstants.CONDITION_OUT_OF_RANGE:
                BigDecimal[] range = parseRangeBounds(rule);
                if (range == null) {
                    BigDecimal min = BigDecimal.ZERO;
                    BigDecimal max = th;
                    return value.compareTo(min) < 0 || value.compareTo(max) > 0;
                }
                return value.compareTo(range[0]) < 0 || value.compareTo(range[1]) > 0;
            default:
                return false;
        }
    }

    /**
     * 解析区间阈值上下界
     *
     * @param rule 设备规则
     * @return 区间数组，解析失败返回null
     */
    private static BigDecimal[] parseRangeBounds(EqDeviceRule rule) {
        String u = rule.getThresholdUnit();
        if (u != null) {
            Matcher m = RANGE_IN_UNIT.matcher(u.trim());
            if (m.matches()) {
                return new BigDecimal[] { new BigDecimal(m.group(1)), new BigDecimal(m.group(2)) };
            }
        }
        return null;
    }

    /**
     * 规范化规则参数名
     *
     * @param parameterName 原始参数名
     * @return 标准参数键
     */
    private static String normalizeParameterKey(String parameterName) {
        if (parameterName == null) {
            return "";
        }
        String t = parameterName.trim();
        return PARAM_ALIASES.getOrDefault(t, t);
    }

    /**
     * 根据参数名提取状态快照中的实际值
     *
     * @param s 设备状态快照
     * @param parameterName 规则参数名
     * @return 参数实际值
     */
    private BigDecimal resolveParameterValue(EqDeviceStatus s, String parameterName) {
        String key = normalizeParameterKey(parameterName);
        switch (key) {
            case "temperature":
                return s.getTemperature();
            case "humidity":
                return s.getHumidity();
            case "pressure":
                return s.getPressure();
            case "vibration":
                return s.getVibration();
            case "current":
                return s.getCurrent();
            case "voltage":
                return s.getVoltage();
            case "power":
                return s.getPower();
            case "rpm":
                return s.getRpm();
            case "flowRate":
                return s.getFlowRate();
            case "liquidLevel":
                return s.getLiquidLevel();
            case "status":
                return s.getStatus() != null ? BigDecimal.valueOf(s.getStatus()) : null;
            case "maintenanceRequired":
                return s.getMaintenanceRequired() != null ? BigDecimal.valueOf(s.getMaintenanceRequired()) : null;
            case "faultCount":
                return s.getFaultCount() != null ? BigDecimal.valueOf(s.getFaultCount()) : null;
            case "alarmCount":
                return s.getAlarmCount() != null ? BigDecimal.valueOf(s.getAlarmCount()) : null;
            case "efficiency":
                return s.getEfficiency();
            case "loadFactor":
                return s.getLoadFactor();
            case "ambientTemp":
                return s.getAmbientTemp();
            case "ambientHumidity":
                return s.getAmbientHumidity();
            case "noiseLevel":
                return s.getNoiseLevel();
            case "airQuality":
                return s.getAirQuality();
            case "runtimeHours":
                return s.getRuntimeHours();
            default:
                log.debug("未识别的规则参数名: {}", parameterName);
                return null;
        }
    }
}
