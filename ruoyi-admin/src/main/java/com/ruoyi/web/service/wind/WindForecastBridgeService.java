package com.ruoyi.web.service.wind;

import java.util.List;
import java.util.Map;

/**
 * 调用本地 Python FastAPI（predict.py）做风电功率预测
 */
public interface WindForecastBridgeService {

    String REMARK_WIND_FORECAST = "WIND_FORECAST";

    /** Python GET /status */
    Map<String, Object> fetchPythonStatus();

    /** Python POST /predict，使用配置文件中的模型与 Excel；统计写入 wind.forecast.bind-device-id */
    Map<String, Object> runPredict();

    /**
     * 按设备（及可选路径覆盖）预测；成功后将当日平均预测功率写入该 deviceId 的 eq_device_stat，remark={@link #REMARK_WIND_FORECAST}。
     */
    Map<String, Object> runPredict(String deviceId, String modelPath, String featureExcel, String realExcel);

    /**
     * 同上；若 {@code requestRows} 非空则优先生成临时 Excel（与页面表格一致），无需调用 /rows 存库。
     */
    Map<String, Object> runPredict(String deviceId, String modelPath, String featureExcel, String realExcel,
                                   List<Map<String, Object>> requestRows);

    /** 上次成功预测（未指定设备时为全局/调度使用的最后一次） */
    Map<String, Object> getLastPrediction();

    /** 指定设备的上次成功预测，无则空 Map */
    Map<String, Object> getLastPrediction(String deviceId);

    long getLastPredictionAtMillis();

    long getLastPredictionAtMillis(String deviceId);

    String getLastError();

    boolean isPythonReachable();

    /** 组装 /latest 完整响应（状态 + 预测 + 配置），供 Controller 直接返回 */
    Map<String, Object> buildLatestResponse(String deviceId, boolean live);
}
