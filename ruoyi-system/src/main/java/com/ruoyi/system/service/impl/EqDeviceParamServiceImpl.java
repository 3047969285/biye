package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqDeviceParamMapper;
import com.ruoyi.system.domain.EqDeviceParam;
import com.ruoyi.system.service.IEqDeviceParamService;

/**
 * 设备参数Service业务层处理
 * 
 * @author ruoyi
 * @date 2026-01-07
 */
@Service
public class EqDeviceParamServiceImpl implements IEqDeviceParamService 
{
    @Autowired
    private EqDeviceParamMapper eqDeviceParamMapper;

    /**
     * 查询设备参数列表
     * 
     * @param eqDeviceParam 设备参数
     * @return 设备参数
     */
    @Override
    public List<EqDeviceParam> selectEqDeviceParamList(EqDeviceParam eqDeviceParam)
    {
        return eqDeviceParamMapper.selectEqDeviceParamList(eqDeviceParam);
    }

    /**
     * 根据参数ID查询设备参数
     * 
     * @param paramId 参数ID
     * @return 设备参数
     */
    @Override
    public EqDeviceParam selectEqDeviceParamByParamId(Long paramId)
    {
        return eqDeviceParamMapper.selectEqDeviceParamByParamId(paramId);
    }

    /**
     * 根据设备ID查询设备参数列表
     * 
     * @param deviceId 设备ID
     * @return 设备参数集合
     */
    @Override
    public List<EqDeviceParam> selectEqDeviceParamListByDeviceId(Long deviceId)
    {
        return eqDeviceParamMapper.selectEqDeviceParamListByDeviceId(deviceId);
    }

    /**
     * 新增设备参数
     * 
     * @param eqDeviceParam 设备参数
     * @return 结果
     */
    @Override
    public int insertEqDeviceParam(EqDeviceParam eqDeviceParam)
    {
        return eqDeviceParamMapper.insertEqDeviceParam(eqDeviceParam);
    }

    /**
     * 修改设备参数
     * 
     * @param eqDeviceParam 设备参数
     * @return 结果
     */
    @Override
    public int updateEqDeviceParam(EqDeviceParam eqDeviceParam)
    {
        return eqDeviceParamMapper.updateEqDeviceParam(eqDeviceParam);
    }

    /**
     * 批量删除设备参数
     * 
     * @param paramIds 需要删除的设备参数主键
     * @return 结果
     */
    @Override
    public int deleteEqDeviceParamByParamIds(Long[] paramIds)
    {
        return eqDeviceParamMapper.deleteEqDeviceParamByParamIds(paramIds);
    }

    /**
     * 删除设备参数信息
     * 
     * @param paramId 设备参数主键
     * @return 结果
     */
    @Override
    public int deleteEqDeviceParamByParamId(Long paramId)
    {
        return eqDeviceParamMapper.deleteEqDeviceParamByParamId(paramId);
    }

    /**
     * 根据设备ID删除设备参数
     * 
     * @param deviceId 设备ID
     * @return 结果
     */
    @Override
    public int deleteEqDeviceParamByDeviceId(Long deviceId)
    {
        return eqDeviceParamMapper.deleteEqDeviceParamByDeviceId(deviceId);
    }

    /**
     * 批量根据设备ID删除设备参数
     * 
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    @Override
    public int deleteEqDeviceParamByDeviceIds(Long[] deviceIds)
    {
        return eqDeviceParamMapper.deleteEqDeviceParamByDeviceIds(deviceIds);
    }
}
