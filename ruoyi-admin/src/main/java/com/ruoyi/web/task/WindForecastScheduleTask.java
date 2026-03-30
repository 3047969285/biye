package com.ruoyi.web.task;

import com.ruoyi.web.config.properties.WindForecastProperties;
import com.ruoyi.web.service.wind.WindForecastBridgeService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * 定时自动调用 Python 预测（默认每 3 分钟，上一次完成后间隔）
 */
@Component
@ConditionalOnProperty(prefix = "wind.forecast", name = "enabled", havingValue = "true", matchIfMissing = true)
public class WindForecastScheduleTask {

    private static final Logger log = LoggerFactory.getLogger(WindForecastScheduleTask.class);

    private final WindForecastProperties props;
    private final WindForecastBridgeService bridge;

    public WindForecastScheduleTask(WindForecastProperties props, WindForecastBridgeService bridge) {
        this.props = props;
        this.bridge = bridge;
    }

    @Scheduled(
        initialDelayString = "${wind.forecast.schedule-initial-delay-ms:45000}",
        fixedDelayString = "${wind.forecast.schedule-interval-ms:180000}"
    )
    public void autoPredict() {
        if (!props.isEnabled()) {
            return;
        }
        if (!bridge.isPythonReachable()) {
            log.debug("Python 预测服务不可达，跳过本次自动预测");
            return;
        }
        try {
            /*
             * 必须带 bind-device-id 调用按设备预测：runPredict() 无 deviceId 时不会读取 eq_wind_forecast_bind，
             * 只会用 yml 默认 Excel，却仍会把结果写入 lastPredictionByDevice(bindDeviceId)，
             * 导致前端选中该设备时曲线被定时任务用「旧默认文件」反复覆盖，与库中路径/上传文件不一致。
             */
            Long bindId = props.getBindDeviceId();
            var r =
                bindId != null && bindId > 0
                    ? bridge.runPredict(bindId, null, null, null, null)
                    : bridge.runPredict();
            if (Boolean.TRUE.equals(r.get("success"))) {
                log.debug(
                    "自动预测完成 deviceId={} predict_length={}",
                    bindId != null && bindId > 0 ? bindId : "global",
                    r.get("predict_length")
                );
            } else {
                log.warn("自动预测未成功: {}", r.get("message"));
            }
        } catch (Exception e) {
            log.warn("自动预测异常: {}", e.getMessage());
        }
    }
}
