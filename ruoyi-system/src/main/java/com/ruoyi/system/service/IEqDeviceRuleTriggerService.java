package com.ruoyi.system.service;

import com.ruoyi.system.domain.EqDeviceStatus;
import com.ruoyi.system.domain.dto.RuleTriggerResult;

public interface IEqDeviceRuleTriggerService {

    RuleTriggerResult fireRulesForSnapshot(EqDeviceStatus data);
}
