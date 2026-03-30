package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.EqDeviceStatus;

public interface IEqDeviceStatusService {

    public EqDeviceStatus selectEqDeviceStatusByStatusId(Long statusId);

    public List<EqDeviceStatus> selectEqDeviceStatusList(EqDeviceStatus eqDeviceStatus);

    public int insertEqDeviceStatus(EqDeviceStatus eqDeviceStatus);

    public int updateEqDeviceStatus(EqDeviceStatus eqDeviceStatus);

    public int deleteEqDeviceStatusByStatusIds(Long[] statusIds);

    public int deleteEqDeviceStatusByStatusId(Long statusId);

    public void reevaluateRulesByDeviceId(Long deviceId);
}
