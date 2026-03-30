package com.ruoyi.system.service;

import com.ruoyi.system.domain.EqWindForecastBind;

public interface IEqWindForecastBindService {

    EqWindForecastBind selectByDeviceId(Long deviceId);

    void mergeSave(EqWindForecastBind patch);
}
