package com.ruoyi.web.controller.wind.dto;

import lombok.Data;

@Data
public class WindForecastBindPayload {
    private String deviceId;
    private String modelPath;
    private String featureExcel;
    private String realExcel;
}
