package com.ruoyi.system.service;

import com.ruoyi.system.domain.EqDeviceParam;
import java.util.List;

/**
 * 设备参数 Service接口
 *
 * @author ruoyi
 * @date 2026-01-07
 */
public interface IEqDeviceParamService {

    /**
     * 查询设备参数列表
     *
     * @param eqDeviceParam 设备参数
     * @return 设备参数集合
     */
    List<EqDeviceParam> selectEqDeviceParamList(EqDeviceParam eqDeviceParam);

    /**
     * 查询设备参数
     *
     * @param paramId 设备参数主键
     * @return 设备参数
     */
    EqDeviceParam selectEqDeviceParamByParamId(Long paramId);

    /**
     * 根据设备ID查询设备参数列表
     *
     * @param deviceId 设备ID
     * @return 设备参数集合
     */
    List<EqDeviceParam> selectEqDeviceParamListByDeviceId(Long deviceId);

    /**
     * 新增设备参数
     *
     * @param eqDeviceParam 设备参数
     * @return 结果
     */
    int insertEqDeviceParam(EqDeviceParam eqDeviceParam);

    /**
     * 修改设备参数
     *
     * @param eqDeviceParam 设备参数
     * @return 结果
     */
    int updateEqDeviceParam(EqDeviceParam eqDeviceParam);

    /**
     * 批量删除设备参数
     *
     * @param paramIds 需要删除的设备参数主键集合
     * @return 结果
     */
    int deleteEqDeviceParamByParamIds(Long[] paramIds);

    /**
     * 删除设备参数信息
     *
     * @param paramId 设备参数主键
     * @return 结果
     */
    int deleteEqDeviceParamByParamId(Long paramId);
}
