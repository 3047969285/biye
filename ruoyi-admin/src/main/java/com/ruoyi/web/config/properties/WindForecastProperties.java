package com.ruoyi.web.config.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * 风力发电 Python 预测服务配置（FastAPI 默认端口 8989）
 */
@Component
@ConfigurationProperties(prefix = "wind.forecast")
public class WindForecastProperties {

    /** 是否启用发电预测集成 */
    private boolean enabled = true;

    /** 是否在 Spring 启动时尝试拉起 predict.py（uvicorn） */
    private boolean autoStartPython = true;

    /** Python 可执行文件，如 python、python3 或绝对路径 */
    private String pythonCommand = "python";

    /** 风力发电脚本目录（含 predict.py、FD001.xlsx、model/） */
    private String workDir;

    private String serviceHost = "127.0.0.1";

    private int servicePort = 8989;

    /** 已有 GRU 模型 .h5 */
    private String modelPath;

    private String featureExcel;

    private String realExcel;

    private int predictLength = 192;

    /** 负数（默认 -1）表示使用测试段末尾，即 Excel 时间序列上最新可预测窗口 */
    private int predictStartIndex = -1;

    private Integer timeStep = 30;

    private Double testSize = 0.2;

    /** 自动预测间隔（毫秒），上一次完成后延迟再执行 */
    private long scheduleIntervalMs = 30000L;

    /** 首次自动预测前等待（毫秒），给 Python 子进程启动时间 */
    private long scheduleInitialDelayMs = 15000L;

    /** HTTP 调用 Python 超时（秒），含 TensorFlow 推理 */
    private int httpTimeoutSeconds = 300;

    /**
     * 绑定设备 ID：预测成功后将当日平均预测功率写入 eq_device_stat（与设备管理中的风力机组对应）。
     * 未配置或 ≤0 时不写库。
     */
    private Long bindDeviceId;

    /**
     * 每个预测输出点对应的时间间隔（分钟），仅用于前端把「点数」换算成时长；须与 Excel 行时间分辨率一致（常见 15）。
     */
    private int forecastPointIntervalMinutes = 15;

    /** 在「可对比」预测段之后，再延长若干分钟仅输出预测值（无实测）；由 Python 换算为额外点数 */
    private int forecastExtraMinutes = 120;

    /**
     * 超出 Excel 末行后，再自回归多预测的点数（无实测）；Python 用最后一行风速 + 滚动预测功率。
     */
    private int beyondDataPoints = 36;

    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    public boolean isAutoStartPython() {
        return autoStartPython;
    }

    public void setAutoStartPython(boolean autoStartPython) {
        this.autoStartPython = autoStartPython;
    }

    public String getPythonCommand() {
        return pythonCommand;
    }

    public void setPythonCommand(String pythonCommand) {
        this.pythonCommand = pythonCommand;
    }

    public String getWorkDir() {
        return workDir;
    }

    public void setWorkDir(String workDir) {
        this.workDir = workDir;
    }

    public String getServiceHost() {
        return serviceHost;
    }

    public void setServiceHost(String serviceHost) {
        this.serviceHost = serviceHost;
    }

    public int getServicePort() {
        return servicePort;
    }

    public void setServicePort(int servicePort) {
        this.servicePort = servicePort;
    }

    public String getModelPath() {
        return modelPath;
    }

    public void setModelPath(String modelPath) {
        this.modelPath = modelPath;
    }

    public String getFeatureExcel() {
        return featureExcel;
    }

    public void setFeatureExcel(String featureExcel) {
        this.featureExcel = featureExcel;
    }

    public String getRealExcel() {
        return realExcel;
    }

    public void setRealExcel(String realExcel) {
        this.realExcel = realExcel;
    }

    public int getPredictLength() {
        return predictLength;
    }

    public void setPredictLength(int predictLength) {
        this.predictLength = predictLength;
    }

    public int getPredictStartIndex() {
        return predictStartIndex;
    }

    public void setPredictStartIndex(int predictStartIndex) {
        this.predictStartIndex = predictStartIndex;
    }

    public Integer getTimeStep() {
        return timeStep;
    }

    public void setTimeStep(Integer timeStep) {
        this.timeStep = timeStep;
    }

    public Double getTestSize() {
        return testSize;
    }

    public void setTestSize(Double testSize) {
        this.testSize = testSize;
    }

    public long getScheduleIntervalMs() {
        return scheduleIntervalMs;
    }

    public void setScheduleIntervalMs(long scheduleIntervalMs) {
        this.scheduleIntervalMs = scheduleIntervalMs;
    }

    public long getScheduleInitialDelayMs() {
        return scheduleInitialDelayMs;
    }

    public void setScheduleInitialDelayMs(long scheduleInitialDelayMs) {
        this.scheduleInitialDelayMs = scheduleInitialDelayMs;
    }

    public int getHttpTimeoutSeconds() {
        return httpTimeoutSeconds;
    }

    public void setHttpTimeoutSeconds(int httpTimeoutSeconds) {
        this.httpTimeoutSeconds = httpTimeoutSeconds;
    }

    public Long getBindDeviceId() {
        return bindDeviceId;
    }

    public void setBindDeviceId(Long bindDeviceId) {
        this.bindDeviceId = bindDeviceId;
    }

    public int getForecastPointIntervalMinutes() {
        return forecastPointIntervalMinutes;
    }

    public void setForecastPointIntervalMinutes(int forecastPointIntervalMinutes) {
        this.forecastPointIntervalMinutes = forecastPointIntervalMinutes;
    }

    public int getForecastExtraMinutes() {
        return forecastExtraMinutes;
    }

    public void setForecastExtraMinutes(int forecastExtraMinutes) {
        this.forecastExtraMinutes = forecastExtraMinutes;
    }

    public int getBeyondDataPoints() {
        return beyondDataPoints;
    }

    public void setBeyondDataPoints(int beyondDataPoints) {
        this.beyondDataPoints = beyondDataPoints;
    }

    public String baseUrl() {
        return "http://" + serviceHost + ":" + servicePort;
    }
}
