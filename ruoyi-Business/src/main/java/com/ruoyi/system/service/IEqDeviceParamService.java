package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.EqDeviceParam;

/**
 * 设备参数Service接口
 * 
 * @author wangchangzhen
 * @date 2026-01-07
 */
public interface IEqDeviceParamService 
{
    /**
     * 查询设备参数列表
     * 
     * @param eqDeviceParam 设备参数
     * @return 设备参数集合
     */
    public List<EqDeviceParam> selectEqDeviceParamList(EqDeviceParam eqDeviceParam);

    /**
     * 根据参数ID查询设备参数
     * 
     * @param paramId 参数ID
     * @return 设备参数
     */
    public EqDeviceParam selectEqDeviceParamByParamId(Long paramId);

    /**
     * 根据设备ID查询设备参数列表
     * 
     * @param deviceId 设备ID
     * @return 设备参数集合
     */
    public List<EqDeviceParam> selectEqDeviceParamListByDeviceId(String deviceId);

    /**
     * 新增设备参数
     * 
     * @param eqDeviceParam 设备参数
     * @return 结果
     */
    public int insertEqDeviceParam(EqDeviceParam eqDeviceParam);

    /**
     * 修改设备参数
     * 
     * @param eqDeviceParam 设备参数
     * @return 结果
     */
    public int updateEqDeviceParam(EqDeviceParam eqDeviceParam);

    /**
     * 批量删除设备参数
     * 
     * @param paramIds 需要删除的设备参数主键集合
     * @return 结果
     */
    public int deleteEqDeviceParamByParamIds(Long[] paramIds);

    /**
     * 删除设备参数信息
     * 
     * @param paramId 设备参数主键
     * @return 结果
     */
    public int deleteEqDeviceParamByParamId(Long paramId);

    /**
     * 根据设备ID删除设备参数
     * 
     * @param deviceId 设备ID
     * @return 结果
     */
    public int deleteEqDeviceParamByDeviceId(String deviceId);

    /**
     * 批量根据设备ID删除设备参数
     * 
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    public int deleteEqDeviceParamByDeviceIds(String[] deviceIds);
}
