package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqDevice;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 设备信息 Mapper 接口
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Mapper
public interface EqDeviceMapper {

    /**
     * 查询设备信息列表
     *
     * @param eqDevice 设备信息
     * @return 设备信息集合
     */
    List<EqDevice> selectEqDeviceList(EqDevice eqDevice);

    /**
     * 查询设备信息
     *
     * @param deviceId 设备ID
     * @return 设备信息
     */
    EqDevice selectEqDeviceByDeviceId(@Param("deviceId") String deviceId);

    /**
     * 根据设备编号查询设备
     *
     * @param deviceNo 设备编号
     * @return 设备信息
     */
    EqDevice selectEqDeviceByDeviceNo(@Param("deviceNo") String deviceNo);

    /**
     * 新增设备信息
     *
     * @param eqDevice 设备信息
     * @return 结果
     */
    int insertEqDevice(EqDevice eqDevice);

    /**
     * 修改设备信息
     *
     * @param eqDevice 设备信息
     * @return 结果
     */
    int updateEqDevice(EqDevice eqDevice);

    /**
     * 更新设备状态
     *
     * @param deviceId 设备ID
     * @param status 状态 (1-正常, 2-停用, 3-维护, 4-报废)
     * @return 结果
     */
    int updateEqDeviceStatus(@Param("deviceId") String deviceId, @Param("status") Integer status);

    /**
     * 批量更新设备状态
     *
     * @param deviceIds 设备ID数组
     * @param status 状态
     * @return 结果
     */
    int updateEqDeviceStatusBatch(@Param("deviceIds") String[] deviceIds, @Param("status") Integer status);

    /**
     * 删除设备信息
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    int deleteEqDeviceByDeviceId(@Param("deviceId") String deviceId);

    /**
     * 批量删除设备信息
     *
     * @param deviceIds 需要删除的设备ID
     * @return 结果
     */
    int deleteEqDeviceByDeviceIds(@Param("deviceIds") String[] deviceIds);

    /**
     * 统计设备数量按状态分组
     *
     * @return 统计结果
     */
    List<Map<String, Object>> countByStatus();

    /**
     * 统计设备数量按类型分组
     *
     * @return 统计结果
     */
    List<Map<String, Object>> countByType();
}
