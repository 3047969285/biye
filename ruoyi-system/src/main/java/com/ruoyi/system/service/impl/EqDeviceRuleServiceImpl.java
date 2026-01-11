package com.ruoyi.system.service.impl;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqDeviceRuleMapper;
import com.ruoyi.system.domain.EqDeviceRule;
import com.ruoyi.system.service.IEqDeviceRuleService;
@Service
public class EqDeviceRuleServiceImpl implements IEqDeviceRuleService {
    @Autowired
    private EqDeviceRuleMapper eqDeviceRuleMapper;
    @Override
    public List<EqDeviceRule> selectEqDeviceRuleList(EqDeviceRule eqDeviceRule) {
        return eqDeviceRuleMapper.selectEqDeviceRuleList(eqDeviceRule);
    }
    @Override
    public EqDeviceRule selectEqDeviceRuleByRuleId(Long ruleId) {
        return eqDeviceRuleMapper.selectEqDeviceRuleByRuleId(ruleId);
    }
    @Override
    public List<EqDeviceRule> selectEqDeviceRuleListByDeviceId(Long deviceId) {
        return eqDeviceRuleMapper.selectEqDeviceRuleListByDeviceId(deviceId);
    }
    @Override
    public int insertEqDeviceRule(EqDeviceRule eqDeviceRule) {
        return eqDeviceRuleMapper.insertEqDeviceRule(eqDeviceRule);
    }
    @Override
    public int updateEqDeviceRule(EqDeviceRule eqDeviceRule) {
        return eqDeviceRuleMapper.updateEqDeviceRule(eqDeviceRule);
    }
    @Override
    public int deleteEqDeviceRuleByRuleIds(Long[] ruleIds) {
        return eqDeviceRuleMapper.deleteEqDeviceRuleByRuleIds(ruleIds);
    }
    @Override
    public int deleteEqDeviceRuleByRuleId(Long ruleId) {
        return eqDeviceRuleMapper.deleteEqDeviceRuleByRuleId(ruleId);
    }
    @Override
    public int deleteEqDeviceRuleByDeviceId(Long deviceId) {
        return eqDeviceRuleMapper.deleteEqDeviceRuleByDeviceId(deviceId);
    }
    @Override
    public int deleteEqDeviceRuleByDeviceIds(Long[] deviceIds) {
        return eqDeviceRuleMapper.deleteEqDeviceRuleByDeviceIds(deviceIds);
    }
}
