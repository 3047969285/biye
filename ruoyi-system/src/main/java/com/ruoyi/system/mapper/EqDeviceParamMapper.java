package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqDeviceParam;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 设备参数 Mapper 接口
 *
 * @author ruoyi
 * @date 2026-01-07
 */
@Mapper
public interface EqDeviceParamMapper {

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
    EqDeviceParam selectEqDeviceParamByParamId(@Param("paramId") Long paramId);

    /**
     * 根据设备ID查询设备参数列表
     *
     * @param deviceId 设备ID
     * @return 设备参数集合
     */
    List<EqDeviceParam> selectEqDeviceParamListByDeviceId(@Param("deviceId") Long deviceId);

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
     * 删除设备参数
     *
     * @param paramId 设备参数主键
     * @return 结果
     */
    int deleteEqDeviceParamByParamId(@Param("paramId") Long paramId);

    /**
     * 批量删除设备参数
     *
     * @param paramIds 需要删除的数据主键集合
     * @return 结果
     */
    int deleteEqDeviceParamByParamIds(@Param("paramIds") Long[] paramIds);

    /**
     * 根据设备ID删除设备参数
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    int deleteEqDeviceParamByDeviceId(@Param("deviceId") Long deviceId);

    /**
     * 批量根据设备ID删除设备参数
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    int deleteEqDeviceParamByDeviceIds(@Param("deviceIds") Long[] deviceIds);
}
