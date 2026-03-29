package com.ruoyi.system.service;

import com.ruoyi.system.domain.EqWindForecastBind;

public interface IEqWindForecastBindService {

    EqWindForecastBind selectByDeviceId(Long deviceId);

    /**
     * 合并保存：仅覆盖请求中非空的字段，其余保留库中旧值。
     */
    void mergeSave(EqWindForecastBind patch);
}
