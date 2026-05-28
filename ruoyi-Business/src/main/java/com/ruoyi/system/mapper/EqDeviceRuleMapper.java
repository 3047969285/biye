package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqDeviceRule;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 设备规则Mapper接口
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Mapper
public interface EqDeviceRuleMapper
{
    /**
     * 查询设备规则列表
     *
     * @param eqDeviceRule 设备规则
     * @return 设备规则集合
     */
    public List<EqDeviceRule> selectEqDeviceRuleList(EqDeviceRule eqDeviceRule);

    /**
     * 根据规则ID查询设备规则
     *
     * @param ruleId 规则ID
     * @return 设备规则
     */
    public EqDeviceRule selectEqDeviceRuleByRuleId(@Param("ruleId") Long ruleId);

    /**
     * 根据设备ID查询设备规则列表
     *
     * @param deviceId 设备ID
     * @return 设备规则集合
     */
    public List<EqDeviceRule> selectEqDeviceRuleListByDeviceId(@Param("deviceId") String deviceId);

    /**
     * 新增设备规则
     *
     * @param eqDeviceRule 设备规则
     * @return 结果
     */
    public int insertEqDeviceRule(EqDeviceRule eqDeviceRule);

    /**
     * 修改设备规则
     *
     * @param eqDeviceRule 设备规则
     * @return 结果
     */
    public int updateEqDeviceRule(EqDeviceRule eqDeviceRule);

    /**
     * 删除设备规则信息
     *
     * @param ruleId 设备规则主键
     * @return 结果
     */
    public int deleteEqDeviceRuleByRuleId(@Param("ruleId") Long ruleId);

    /**
     * 批量删除设备规则
     *
     * @param ruleIds 需要删除的设备规则主键集合
     * @return 结果
     */
    public int deleteEqDeviceRuleByRuleIds(@Param("ruleIds") Long[] ruleIds);

    /**
     * 根据设备ID删除设备规则
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    public int deleteEqDeviceRuleByDeviceId(@Param("deviceId") String deviceId);

    /**
     * 批量根据设备ID删除设备规则
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    public int deleteEqDeviceRuleByDeviceIds(@Param("deviceIds") String[] deviceIds);
}
