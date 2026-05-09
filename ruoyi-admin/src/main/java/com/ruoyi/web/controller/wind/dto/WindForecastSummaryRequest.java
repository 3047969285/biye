package com.ruoyi.web.controller.wind.dto;

import lombok.Data;

@Data
public class WindForecastSummaryRequest {
    /** 使用该设备缓存的最近一次预测；为空则用全局最后一次 */
    private String deviceId;
}
