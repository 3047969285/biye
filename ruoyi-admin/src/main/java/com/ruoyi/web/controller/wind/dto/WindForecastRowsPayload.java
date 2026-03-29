package com.ruoyi.web.controller.wind.dto;

import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
public class WindForecastRowsPayload {
    private Long deviceId;
    /** 每行含 w30,w50,w70,whub,power（与 Python FD001 四风速 + 功率对齐） */
    private List<Map<String, Object>> rows;
}
