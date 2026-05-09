package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqWindForecastBind;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

/**
 * 风电预测绑定Mapper接口
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Mapper
public interface EqWindForecastBindMapper
{
    /**
     * 根据设备ID查询风电预测绑定
     *
     * @param deviceId 设备ID
     * @return 绑定记录
     */
    public EqWindForecastBind selectByDeviceId(@Param("deviceId") String deviceId);

    /**
     * 新增风电预测绑定
     *
     * @param row 绑定记录
     * @return 结果
     */
    public int insertEqWindForecastBind(EqWindForecastBind row);

    /**
     * 修改风电预测绑定
     *
     * @param row 绑定记录
     * @return 结果
     */
    public int updateEqWindForecastBind(EqWindForecastBind row);
}
