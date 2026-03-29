package com.ruoyi.web.controller.wind.dto;

import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
public class WindForecastRunRequest {
    private Long deviceId;
    private String modelPath;
    private String featureExcel;
    private String realExcel;
    /** 当前表格行（w30/w50/w70/whub/power），非空时直接用于预测 */
    private List<Map<String, Object>> rows;
}
