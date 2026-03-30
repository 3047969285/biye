package com.ruoyi.system.service;

import com.ruoyi.system.domain.EqDeviceStatus;

public interface IEqDeviceRuleEvaluationService {

    void evaluateAfterStatusChange(EqDeviceStatus status);

    void evaluateLatestStatusForDevice(Long deviceId);
}
