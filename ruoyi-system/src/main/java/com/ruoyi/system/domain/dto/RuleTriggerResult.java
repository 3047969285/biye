package com.ruoyi.system.domain.dto;

public class RuleTriggerResult {

    private int baselineRunningStatus;
    private int targetRunningStatus;
    private boolean needMaintenance;
    private int rulesEvaluated;
    private int rulesHit;
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
