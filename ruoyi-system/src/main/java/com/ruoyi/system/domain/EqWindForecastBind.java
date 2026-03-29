package com.ruoyi.system.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.util.Date;

/**
 * 风力预测设备绑定数据路径 eq_wind_forecast_bind
 */
@Data
public class EqWindForecastBind {
    private Long deviceId;
    private String modelPath;
    private String featureExcelPath;
    private String realExcelPath;

    /** 页面编辑的风速+功率序列 JSON，预测时生成临时 Excel */
    private String inlineDataJson;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updateTime;
}
