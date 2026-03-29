package com.ruoyi.system.domain.dto;

/**
 * 设备规则触发一次扫描后的结果（不含写库），供评估服务合并更新运行状态
 */
public class RuleTriggerResult {

    /** 扫描前运行状态 1正常 2警告 3错误 4离线 */
    private int baselineRunningStatus;

    /** 按命中规则推导后的运行状态（取更严重者） */
    private int targetRunningStatus;

    /** 是否有高等级规则要求标记需维护 */
    private boolean needMaintenance;

    /** 参与比对的启用规则条数（不含跳过） */
    private int rulesEvaluated;

    /** 条件命中的规则条数 */
    private int rulesHit;

    /** 实际新插入的告警条数 */
    private int alertsInserted;

    public int getBaselineRunningStatus() {
        return baselineRunningStatus;
    }

    public void setBaselineRunningStatus(int baselineRunningStatus) {
        this.baselineRunningStatus = baselineRunningStatus;
    }

    public int getTargetRunningStatus() {
        return targetRunningStatus;
    }

    public void setTargetRunningStatus(int targetRunningStatus) {
        this.targetRunningStatus = targetRunningStatus;
    }

    public boolean isNeedMaintenance() {
        return needMaintenance;
    }

    public void setNeedMaintenance(boolean needMaintenance) {
        this.needMaintenance = needMaintenance;
    }

    public int getRulesEvaluated() {
        return rulesEvaluated;
    }

    public void setRulesEvaluated(int rulesEvaluated) {
        this.rulesEvaluated = rulesEvaluated;
    }

    public int getRulesHit() {
        return rulesHit;
    }

    public void setRulesHit(int rulesHit) {
        this.rulesHit = rulesHit;
    }

    public int getAlertsInserted() {
        return alertsInserted;
    }

    public void setAlertsInserted(int alertsInserted) {
        this.alertsInserted = alertsInserted;
    }
}
