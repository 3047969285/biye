package com.ruoyi.system.domain.vo;

import java.io.Serializable;

/**
 * 待维护设备快照，用于站内消息与左侧列表条数一致
 */
public class MaintenanceDevicePendingVo implements Serializable {

    private static final long serialVersionUID = 1L;

    private final String deviceId;
    private final String deviceName;
    private final String priority;

    public MaintenanceDevicePendingVo(String deviceId, String deviceName, String priority) {
        this.deviceId = deviceId;
        this.deviceName = deviceName != null ? deviceName : "设备";
        this.priority = priority != null ? priority : "—";
    }

    public String getDeviceId() {
        return deviceId;
    }

    public String getDeviceName() {
        return deviceName;
    }

    public String getPriority() {
        return priority;
    }
}
