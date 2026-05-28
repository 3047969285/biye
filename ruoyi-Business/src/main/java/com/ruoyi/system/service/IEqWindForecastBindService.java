package com.ruoyi.system.service;

import com.ruoyi.system.domain.EqWindForecastBind;

/**
 * 风电预测绑定Service接口
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
public interface IEqWindForecastBindService
{
    /**
     * 根据设备ID查询风电预测绑定配置
     *
     * @param deviceId 设备ID
     * @return 绑定配置，不存在时返回null
     */
    public EqWindForecastBind selectByDeviceId(String deviceId);

    /**
     * 合并保存风电预测绑定（按设备ID upsert，非空字段覆盖已有值）
     *
     * @param patch 待合并的绑定数据
     */
    public void mergeSave(EqWindForecastBind patch);
}
