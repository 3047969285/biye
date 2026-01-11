package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqDeviceRule;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface EqDeviceRuleMapper {
    List<EqDeviceRule> selectEqDeviceRuleList(EqDeviceRule eqDeviceRule);
    EqDeviceRule selectEqDeviceRuleByRuleId(@Param("ruleId") Long ruleId);
    List<EqDeviceRule> selectEqDeviceRuleListByDeviceId(@Param("deviceId") Long deviceId);
    int insertEqDeviceRule(EqDeviceRule eqDeviceRule);
    int updateEqDeviceRule(EqDeviceRule eqDeviceRule);
    int deleteEqDeviceRuleByRuleId(@Param("ruleId") Long ruleId);
    int deleteEqDeviceRuleByRuleIds(@Param("ruleIds") Long[] ruleIds);
    int deleteEqDeviceRuleByDeviceId(@Param("deviceId") Long deviceId);
    int deleteEqDeviceRuleByDeviceIds(@Param("deviceIds") Long[] deviceIds);
}
