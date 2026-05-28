package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqOperationalDataMapper;
import com.ruoyi.system.domain.EqOperationalData;
import com.ruoyi.system.service.IEqOperationalDataService;

/**
 * 运行数据Service业务层处理
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Service
public class EqOperationalDataServiceImpl implements IEqOperationalDataService
{
    @Autowired
    private EqOperationalDataMapper eqOperationalDataMapper;

    /**
     * 查询运行数据列表
     *
     * @param eqOperationalData 运行数据
     * @return 运行数据集合
     */
    @Override
    public List<EqOperationalData> selectEqOperationalDataList(EqOperationalData eqOperationalData)
    {
        return eqOperationalDataMapper.selectEqOperationalDataList(eqOperationalData);
    }

    /**
     * 根据运行数据ID查询运行数据
     *
     * @param operationalId 运行数据ID
     * @return 运行数据
     */
    @Override
    public EqOperationalData selectEqOperationalDataByOperationalId(Long operationalId)
    {
        return eqOperationalDataMapper.selectEqOperationalDataByOperationalId(operationalId);
    }

    /**
     * 根据设备ID查询运行数据列表
     *
     * @param deviceId 设备ID
     * @return 运行数据集合
     */
    @Override
    public List<EqOperationalData> selectEqOperationalDataListByDeviceId(String deviceId)
    {
        return eqOperationalDataMapper.selectEqOperationalDataListByDeviceId(deviceId);
    }

    /**
     * 新增运行数据
     *
     * @param eqOperationalData 运行数据
     * @return 结果
     */
    @Override
    public int insertEqOperationalData(EqOperationalData eqOperationalData)
    {
        return eqOperationalDataMapper.insertEqOperationalData(eqOperationalData);
    }

    /**
     * 修改运行数据
     *
     * @param eqOperationalData 运行数据
     * @return 结果
     */
    @Override
    public int updateEqOperationalData(EqOperationalData eqOperationalData)
    {
        return eqOperationalDataMapper.updateEqOperationalData(eqOperationalData);
    }

    /**
     * 批量删除运行数据
     *
     * @param operationalIds 需要删除的运行数据主键
     * @return 结果
     */
    @Override
    public int deleteEqOperationalDataByOperationalIds(Long[] operationalIds)
    {
        return eqOperationalDataMapper.deleteEqOperationalDataByOperationalIds(operationalIds);
    }

    /**
     * 删除运行数据信息
     *
     * @param operationalId 运行数据主键
     * @return 结果
     */
    @Override
    public int deleteEqOperationalDataByOperationalId(Long operationalId)
    {
        return eqOperationalDataMapper.deleteEqOperationalDataByOperationalId(operationalId);
    }

    /**
     * 根据设备ID删除运行数据
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    @Override
    public int deleteEqOperationalDataByDeviceId(String deviceId)
    {
        return eqOperationalDataMapper.deleteEqOperationalDataByDeviceId(deviceId);
    }

    /**
     * 批量根据设备ID删除运行数据
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    @Override
    public int deleteEqOperationalDataByDeviceIds(String[] deviceIds)
    {
        return eqOperationalDataMapper.deleteEqOperationalDataByDeviceIds(deviceIds);
    }
}
