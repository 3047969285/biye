package com.ruoyi.common.constant;

/**
 * 设备侧阈值规则与运行状态常量（与表字段取值一致，避免魔法数散落）。
 * <p>
 * 答辩可说明：规则引擎条件类型、告警等级与运行状态映射集中管理，便于审计与扩展。
 */
public final class EquipmentRuleConstants {

    private EquipmentRuleConstants() {
    }

    /** 运行状态：正常 */
    public static final int RUNNING_NORMAL = 1;

    /** 运行状态：警告 */
    public static final int RUNNING_WARNING = 2;

    /** 运行状态：错误 */
    public static final int RUNNING_ERROR = 3;

    /** 运行状态：离线 */
    public static final int RUNNING_OFFLINE = 4;

    /** 规则：禁用 */
    public static final int RULE_DISABLED = 0;

    /** 规则：启用 */
    public static final int RULE_ENABLED = 1;

    /** 不需维护 */
    public static final int MAINTENANCE_NO = 0;

    /** 需维护 */
    public static final int MAINTENANCE_YES = 1;

    /** 条件类型：大于 */
    public static final int CONDITION_GREATER_THAN = 1;

    /** 条件类型：小于 */
    public static final int CONDITION_LESS_THAN = 2;

    /** 条件类型：等于 */
    public static final int CONDITION_EQUALS = 3;

    /** 条件类型：区间外 */
    public static final int CONDITION_OUT_OF_RANGE = 4;

    /** 告警等级：一般（映射为运行警告） */
    public static final int ALERT_LEVEL_NORMAL = 1;

    /** 告警等级：严重（映射为运行错误，并参与需维护判定） */
    public static final int ALERT_LEVEL_SERIOUS = 2;

    /** 告警等级：紧急（映射为运行错误，并参与需维护判定） */
    public static final int ALERT_LEVEL_CRITICAL = 3;

    /** 新告警记录：已触发待处理 */
    public static final int ALERT_RECORD_TRIGGERED = 1;
}
