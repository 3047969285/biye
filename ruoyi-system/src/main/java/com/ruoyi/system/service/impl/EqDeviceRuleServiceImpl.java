package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqDeviceRuleMapper;
import com.ruoyi.system.domain.EqDeviceRule;
import com.ruoyi.system.service.IEqDeviceRuleService;

/**
 * 设备规则Service业务层处理
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Service
public class EqDeviceRuleServiceImpl implements IEqDeviceRuleService
{
    @Autowired
    private EqDeviceRuleMapper eqDeviceRuleMapper;

    /**
     * 查询设备规则列表
     *
     * @param eqDeviceRule 设备规则
     * @return 设备规则集合
     */
    @Override
    public List<EqDeviceRule> selectEqDeviceRuleList(EqDeviceRule eqDeviceRule)
    {
        return eqDeviceRuleMapper.selectEqDeviceRuleList(eqDeviceRule);
    }

    /**
     * 根据规则ID查询设备规则
     *
     * @param ruleId 规则ID
     * @return 设备规则
     */
    @Override
    public EqDeviceRule selectEqDeviceRuleByRuleId(Long ruleId)
    {
        return eqDeviceRuleMapper.selectEqDeviceRuleByRuleId(ruleId);
    }

    /**
     * 根据设备ID查询设备规则列表
     *
     * @param deviceId 设备ID
     * @return 设备规则集合
     */
    @Override
    public List<EqDeviceRule> selectEqDeviceRuleListByDeviceId(String deviceId)
    {
        return eqDeviceRuleMapper.selectEqDeviceRuleListByDeviceId(deviceId);
    }

    /**
     * 新增设备规则
     *
     * @param eqDeviceRule 设备规则
     * @return 结果
     */
    @Override
    public int insertEqDeviceRule(EqDeviceRule eqDeviceRule)
    {
        return eqDeviceRuleMapper.insertEqDeviceRule(eqDeviceRule);
    }

    /**
     * 修改设备规则
     *
     * @param eqDeviceRule 设备规则
     * @return 结果
     */
    @Override
    public int updateEqDeviceRule(EqDeviceRule eqDeviceRule)
    {
        return eqDeviceRuleMapper.updateEqDeviceRule(eqDeviceRule);
    }

    /**
     * 批量删除设备规则
     *
     * @param ruleIds 需要删除的设备规则主键
     * @return 结果
     */
    @Override
    public int deleteEqDeviceRuleByRuleIds(Long[] ruleIds)
    {
        return eqDeviceRuleMapper.deleteEqDeviceRuleByRuleIds(ruleIds);
    }

    /**
     * 删除设备规则信息
     *
     * @param ruleId 设备规则主键
     * @return 结果
     */
    @Override
    public int deleteEqDeviceRuleByRuleId(Long ruleId)
    {
        return eqDeviceRuleMapper.deleteEqDeviceRuleByRuleId(ruleId);
    }

    /**
     * 根据设备ID删除设备规则
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    @Override
    public int deleteEqDeviceRuleByDeviceId(String deviceId)
    {
        return eqDeviceRuleMapper.deleteEqDeviceRuleByDeviceId(deviceId);
    }

    /**
     * 批量根据设备ID删除设备规则
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    @Override
    public int deleteEqDeviceRuleByDeviceIds(String[] deviceIds)
    {
        return eqDeviceRuleMapper.deleteEqDeviceRuleByDeviceIds(deviceIds);
    }
}
