package com.ruoyi.system.service.impl;

import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.EqDeviceParam;
import com.ruoyi.system.mapper.EqDeviceParamMapper;
import com.ruoyi.system.service.IEqDeviceParamService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 设备参数 Service业务层处理
 *
 * @author ruoyi
 * @date 2026-01-07
 */
@Service
public class EqDeviceParamServiceImpl implements IEqDeviceParamService {

    @Autowired
    private EqDeviceParamMapper eqDeviceParamMapper;

    /**
     * 查询设备参数列表
     *
     * @param eqDeviceParam 设备参数
     * @return 设备参数
     */
    @Override
    public List<EqDeviceParam> selectEqDeviceParamList(EqDeviceParam eqDeviceParam) {
        return eqDeviceParamMapper.selectEqDeviceParamList(eqDeviceParam);
    }

    /**
     * 查询设备参数
     *
     * @param paramId 设备参数主键
     * @return 设备参数
     */
    @Override
    public EqDeviceParam selectEqDeviceParamByParamId(Long paramId) {
        return eqDeviceParamMapper.selectEqDeviceParamByParamId(paramId);
    }

    /**
     * 根据设备ID查询设备参数列表
     *
     * @param deviceId 设备ID
     * @return 设备参数集合
     */
    @Override
    public List<EqDeviceParam> selectEqDeviceParamListByDeviceId(Long deviceId) {
        return eqDeviceParamMapper.selectEqDeviceParamListByDeviceId(deviceId);
    }

    /**
     * 新增设备参数
     *
     * @param eqDeviceParam 设备参数
     * @return 结果
     */
    @Override
    public int insertEqDeviceParam(EqDeviceParam eqDeviceParam) {
        eqDeviceParam.setCreateTime(DateUtils.getNowDate());
        eqDeviceParam.setCreateBy(SecurityUtils.getUsername());
        if (eqDeviceParam.getLastUpdated() == null) {
            eqDeviceParam.setLastUpdated(DateUtils.getNowDate());
        }
        return eqDeviceParamMapper.insertEqDeviceParam(eqDeviceParam);
    }

    /**
     * 修改设备参数
     *
     * @param eqDeviceParam 设备参数
     * @return 结果
     */
    @Override
    public int updateEqDeviceParam(EqDeviceParam eqDeviceParam) {
        eqDeviceParam.setUpdateTime(DateUtils.getNowDate());
        eqDeviceParam.setUpdateBy(SecurityUtils.getUsername());
        eqDeviceParam.setLastUpdated(DateUtils.getNowDate());
        return eqDeviceParamMapper.updateEqDeviceParam(eqDeviceParam);
    }

    /**
     * 批量删除设备参数
     *
     * @param paramIds 需要删除的设备参数主键
     * @return 结果
     */
    @Override
    public int deleteEqDeviceParamByParamIds(Long[] paramIds) {
        return eqDeviceParamMapper.deleteEqDeviceParamByParamIds(paramIds);
    }

    /**
     * 删除设备参数信息
     *
     * @param paramId 设备参数主键
     * @return 结果
     */
    @Override
    public int deleteEqDeviceParamByParamId(Long paramId) {
        return eqDeviceParamMapper.deleteEqDeviceParamByParamId(paramId);
    }
}
