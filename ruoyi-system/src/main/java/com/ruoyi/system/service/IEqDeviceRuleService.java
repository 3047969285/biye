package com.ruoyi.system.service;
import java.util.List;
import com.ruoyi.system.domain.EqDeviceRule;
public interface IEqDeviceRuleService {
    List<EqDeviceRule> selectEqDeviceRuleList(EqDeviceRule eqDeviceRule);
    EqDeviceRule selectEqDeviceRuleByRuleId(Long ruleId);
    List<EqDeviceRule> selectEqDeviceRuleListByDeviceId(Long deviceId);
    int insertEqDeviceRule(EqDeviceRule eqDeviceRule);
    int updateEqDeviceRule(EqDeviceRule eqDeviceRule);
    int deleteEqDeviceRuleByRuleIds(Long[] ruleIds);
    int deleteEqDeviceRuleByRuleId(Long ruleId);
    int deleteEqDeviceRuleByDeviceId(Long deviceId);
    int deleteEqDeviceRuleByDeviceIds(Long[] deviceIds);
}
