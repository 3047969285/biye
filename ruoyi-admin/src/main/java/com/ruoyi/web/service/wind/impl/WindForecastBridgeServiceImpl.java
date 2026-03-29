package com.ruoyi.web.service.wind.impl;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ruoyi.system.domain.EqDeviceStat;
import com.ruoyi.system.domain.EqWindForecastBind;
import com.ruoyi.system.service.IEqDeviceStatService;
import com.ruoyi.system.service.IEqWindForecastBindService;
import com.ruoyi.web.config.properties.WindForecastProperties;
import com.ruoyi.web.service.wind.WindForecastBridgeService;
import com.ruoyi.web.service.wind.WindForecastInlineExcelWriter;
import com.ruoyi.web.service.wind.WindForecastPathResolver;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.LocalDate;
import java.time.ZoneId;
import java.nio.file.Path;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicReference;

@Service
public class WindForecastBridgeServiceImpl implements WindForecastBridgeService {

    private static final Logger log = LoggerFactory.getLogger(WindForecastBridgeServiceImpl.class);

    private final WindForecastProperties props;
    private final ObjectMapper objectMapper;
    private final HttpClient httpClient;
    private final IEqDeviceStatService eqDeviceStatService;
    private final IEqWindForecastBindService windForecastBindService;

    private final AtomicReference<Map<String, Object>> lastPrediction = new AtomicReference<>();
    private final AtomicReference<Long> lastPredictionAt = new AtomicReference<>(0L);
    private final AtomicReference<String> lastError = new AtomicReference<>();

    private final ConcurrentHashMap<Long, Map<String, Object>> lastPredictionByDevice = new ConcurrentHashMap<>();
    private final ConcurrentHashMap<Long, Long> lastPredictionAtByDevice = new ConcurrentHashMap<>();

    public WindForecastBridgeServiceImpl(WindForecastProperties props, ObjectMapper objectMapper,
                                         IEqDeviceStatService eqDeviceStatService,
                                         IEqWindForecastBindService windForecastBindService) {
        this.props = props;
        this.objectMapper = objectMapper;
        this.eqDeviceStatService = eqDeviceStatService;
        this.windForecastBindService = windForecastBindService;
        this.httpClient = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(10))
            .version(HttpClient.Version.HTTP_1_1)
            .build();
    }

    @Override
    public Map<String, Object> fetchPythonStatus() {
        if (!props.isEnabled()) {
            return Collections.singletonMap("message", "wind.forecast.enabled=false");
        }
        try {
            HttpRequest req = HttpRequest.newBuilder()
                .uri(URI.create(props.baseUrl() + "/status"))
                .GET()
                .timeout(Duration.ofSeconds(15))
                .build();
            HttpResponse<String> resp = httpClient.send(req, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
            if (resp.statusCode() != 200) {
                String body = resp.body();
                return Map.of("error", "HTTP " + resp.statusCode(), "body", body != null ? body : "");
            }
            return objectMapper.readValue(resp.body(), new TypeReference<Map<String, Object>>() {});
        } catch (Exception e) {
            String errMsg = safeExMessage(e);
            log.warn("无法连接 Python 预测服务 {} : {}", props.baseUrl(), errMsg);
            return Map.of("error", errMsg, "reachable", Boolean.FALSE);
        }
    }

    @Override
    public synchronized Map<String, Object> runPredict() {
        return runPredict(null, null, null, null, null);
    }

    @Override
    public Map<String, Object> runPredict(Long deviceId, String modelPath, String featureExcel, String realExcel) {
        return runPredict(deviceId, modelPath, featureExcel, realExcel, null);
    }

    @Override
    public synchronized Map<String, Object> runPredict(Long deviceId, String modelPath, String featureExcel, String realExcel,
                                                         List<Map<String, Object>> requestRows) {
        lastError.set(null);
        if (!props.isEnabled()) {
            Map<String, Object> m = new HashMap<>();
            m.put("success", false);
            m.put("message", "发电预测功能已关闭（wind.forecast.enabled=false）");
            return m;
        }

        EqWindForecastBind bindRow = null;
        if (deviceId != null && deviceId > 0) {
            bindRow = windForecastBindService.selectByDeviceId(deviceId);
        }

        String model = firstNonBlank(modelPath, bindRow != null ? bindRow.getModelPath() : null, props.getModelPath());

        String feat = null;
        String real = null;
        if (deviceId != null && deviceId > 0) {
            List<Map<String, Object>> materialize = null;
            if (requestRows != null && !requestRows.isEmpty()) {
                materialize = requestRows;
            } else if (bindRow != null && bindRow.getInlineDataJson() != null && !bindRow.getInlineDataJson().isBlank()) {
                try {
                    materialize = objectMapper.readValue(
                        bindRow.getInlineDataJson().trim(),
                        new TypeReference<List<Map<String, Object>>>() {});
                } catch (Exception ex) {
                    String em = safeExMessage(ex);
                    lastError.set(em);
                    return Map.of("success", false, "message", "解析已存页面数据失败：" + em);
                }
            }
            if (materialize != null && !materialize.isEmpty()) {
                try {
                    Path[] ps = WindForecastInlineExcelWriter.write(deviceId, materialize);
                    feat = ps[0].toString();
                    real = ps[1].toString();
                } catch (IllegalArgumentException ex) {
                    String msg = ex.getMessage() != null ? ex.getMessage() : "行数据无效";
                    lastError.set(msg);
                    return Map.of("success", false, "message", msg);
                } catch (Exception ex) {
                    String em = safeExMessage(ex);
                    log.warn("根据页面数据生成 Excel 失败 deviceId={}", deviceId, ex);
                    lastError.set(em);
                    return Map.of("success", false, "message", "生成预测用 Excel 失败：" + em);
                }
            }
        }
        if (feat == null) {
            feat = firstNonBlank(featureExcel, bindRow != null ? bindRow.getFeatureExcelPath() : null, props.getFeatureExcel());
        }
        if (real == null) {
            real = firstNonBlank(realExcel, bindRow != null ? bindRow.getRealExcelPath() : null, props.getRealExcel());
        }

        model = WindForecastPathResolver.toAbsolutePath(model);
        feat = WindForecastPathResolver.toAbsolutePath(feat);
        real = WindForecastPathResolver.toAbsolutePath(real);

        if (model == null || feat == null || real == null) {
            String msg = "请配置模型与两份 Excel：可在 application.yml 设置 wind.forecast.*，或在「设备绑定」中上传/填写路径后再预测";
            lastError.set(msg);
            return Map.of("success", false, "message", msg);
        }

        Long statDeviceId = deviceId != null && deviceId > 0 ? deviceId : props.getBindDeviceId();
        if (statDeviceId == null || statDeviceId <= 0) {
            statDeviceId = null;
        }

        Map<String, Object> body = new HashMap<>();
        body.put("predict_length", props.getPredictLength());
        body.put("predict_start_index", props.getPredictStartIndex());
        body.put("model_path", model);
        body.put("feature_excel", feat);
        body.put("real_excel", real);
        body.put("time_step", props.getTimeStep());
        body.put("test_size", props.getTestSize());
        body.put("forecast_extra_minutes", props.getForecastExtraMinutes());
        body.put("forecast_point_interval_minutes", props.getForecastPointIntervalMinutes());
        body.put("beyond_data_points", props.getBeyondDataPoints());

        try {
            String json = objectMapper.writeValueAsString(body);
            HttpRequest req = HttpRequest.newBuilder()
                .uri(URI.create(props.baseUrl() + "/predict"))
                .header("Content-Type", "application/json; charset=UTF-8")
                .header("Accept", "application/json")
                .POST(HttpRequest.BodyPublishers.ofByteArray(json.getBytes(StandardCharsets.UTF_8)))
                .timeout(Duration.ofSeconds(props.getHttpTimeoutSeconds()))
                .build();
            HttpResponse<String> resp = httpClient.send(req, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
            String responseBody = resp.body();
            Map<String, Object> parsed;
            try {
                parsed = objectMapper.readValue(responseBody, new TypeReference<Map<String, Object>>() {});
            } catch (Exception parseEx) {
                log.warn("Python /predict 返回非 JSON，status={} bodySnippet={}", resp.statusCode(),
                    responseBody != null && responseBody.length() > 200 ? responseBody.substring(0, 200) : responseBody);
                String msg = "Python 返回非 JSON（HTTP " + resp.statusCode() + "）";
                lastError.set(msg);
                return Map.of("success", false, "message", msg, "httpStatus", resp.statusCode());
            }
            int sc = resp.statusCode();
            if (sc < 200 || sc >= 300) {
                String msg = extractPythonErrorMessage(parsed, responseBody, sc);
                lastError.set(msg);
                Map<String, Object> err = new HashMap<>();
                err.put("success", false);
                err.put("message", msg);
                err.put("httpStatus", sc);
                return err;
            }
            if (Boolean.TRUE.equals(parsed.get("success"))) {
                parsed.put("run_device_id", statDeviceId);
                lastPrediction.set(parsed);
                lastPredictionAt.set(System.currentTimeMillis());
                if (statDeviceId != null) {
                    lastPredictionByDevice.put(statDeviceId, parsed);
                    lastPredictionAtByDevice.put(statDeviceId, System.currentTimeMillis());
                }
                syncWindStatToDevice(parsed, statDeviceId);
            } else {
                lastError.set(String.valueOf(parsed.getOrDefault("message", responseBody)));
            }
            return parsed;
        } catch (IOException | InterruptedException e) {
            log.error("预测请求失败", e);
            String em = safeExMessage(e);
            lastError.set(em);
            Thread.currentThread().interrupt();
            return Map.of("success", false, "message", em);
        }
    }

    /** {@link Map#of} 不允许 null 值；部分异常 {@link Throwable#getMessage()} 为 null。 */
    private static String safeExMessage(Throwable e) {
        if (e == null) {
            return "unknown";
        }
        String m = e.getMessage();
        if (m != null && !m.isBlank()) {
            return m;
        }
        return e.getClass().getSimpleName();
    }

    private static String firstNonBlank(String a, String b, String c) {
        if (a != null && !a.isBlank()) {
            return a.trim();
        }
        if (b != null && !b.isBlank()) {
            return b.trim();
        }
        if (c != null && !c.isBlank()) {
            return c.trim();
        }
        return null;
    }

    @Override
    public Map<String, Object> getLastPrediction() {
        Map<String, Object> p = lastPrediction.get();
        return p != null ? p : Collections.emptyMap();
    }

    @Override
    public Map<String, Object> getLastPrediction(Long deviceId) {
        if (deviceId == null || deviceId <= 0) {
            return getLastPrediction();
        }
        Map<String, Object> p = lastPredictionByDevice.get(deviceId);
        return p != null ? p : Collections.emptyMap();
    }

    @Override
    public long getLastPredictionAtMillis() {
        Long t = lastPredictionAt.get();
        return t != null ? t : 0L;
    }

    @Override
    public long getLastPredictionAtMillis(Long deviceId) {
        if (deviceId == null || deviceId <= 0) {
            return getLastPredictionAtMillis();
        }
        Long t = lastPredictionAtByDevice.get(deviceId);
        return t != null ? t : 0L;
    }

    @Override
    public String getLastError() {
        return lastError.get();
    }

    @Override
    public boolean isPythonReachable() {
        try {
            HttpRequest req = HttpRequest.newBuilder()
                .uri(URI.create(props.baseUrl() + "/status"))
                .GET()
                .timeout(Duration.ofSeconds(3))
                .build();
            HttpResponse<String> resp = httpClient.send(req, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
            return resp.statusCode() == 200;
        } catch (Exception e) {
            return false;
        }
    }

    private void syncWindStatToDevice(Map<String, Object> parsed, Long targetDeviceId) {
        if (targetDeviceId == null || targetDeviceId <= 0) {
            return;
        }
        Object rawSeries = parsed.get("predicted_power");
        if (!(rawSeries instanceof List<?>)) {
            return;
        }
        List<?> series = (List<?>) rawSeries;
        if (series.isEmpty()) {
            return;
        }
        int statCount = series.size();
        Object cmpObj = parsed.get("compare_length");
        if (cmpObj instanceof Number) {
            int c = ((Number) cmpObj).intValue();
            if (c > 0) {
                statCount = Math.min(c, series.size());
            }
        }
        double sum = 0d;
        for (int i = 0; i < statCount; i++) {
            Object o = series.get(i);
            if (o instanceof Number) {
                sum += ((Number) o).doubleValue();
            } else {
                try {
                    sum += Double.parseDouble(String.valueOf(o));
                } catch (NumberFormatException ignored) {
                    // skip
                }
            }
        }
        BigDecimal avgPower = BigDecimal.valueOf(sum / statCount).setScale(4, RoundingMode.HALF_UP);

        ZoneId zone = ZoneId.systemDefault();
        LocalDate today = LocalDate.now(zone);
        Date statDate = Date.from(today.atStartOfDay(zone).toInstant());

        EqDeviceStat query = new EqDeviceStat();
        query.setDeviceId(targetDeviceId);
        query.setStatDate(statDate);
        List<EqDeviceStat> existing = eqDeviceStatService.selectEqDeviceStatList(query);

        EqDeviceStat row = new EqDeviceStat();
        row.setDeviceId(targetDeviceId);
        row.setStatDate(statDate);
        row.setAveragePower(avgPower);
        row.setUptimePercentage(new BigDecimal("100.00"));
        row.setRemark(WindForecastBridgeService.REMARK_WIND_FORECAST);

        int intervalMin = Math.max(1, props.getForecastPointIntervalMinutes());
        double hours = (statCount * intervalMin) / 60.0;
        row.setTotalRuntimeHours(BigDecimal.valueOf(hours).setScale(2, RoundingMode.HALF_UP));

        try {
            if (existing != null && !existing.isEmpty()) {
                row.setStatId(existing.get(0).getStatId());
                eqDeviceStatService.updateEqDeviceStat(row);
            } else {
                eqDeviceStatService.insertEqDeviceStat(row);
            }
        } catch (Exception e) {
            log.warn("写入风力设备统计失败 deviceId={}: {}", targetDeviceId, e.getMessage());
        }
    }

    @SuppressWarnings("unchecked")
    private static String extractPythonErrorMessage(Map<String, Object> parsed, String rawBody, int httpStatus) {
        Object detail = parsed.get("detail");
        if (detail instanceof List<?> list && !list.isEmpty()) {
            Object first = list.get(0);
            if (first instanceof Map<?, ?> m) {
                Object msg = m.get("msg");
                Object loc = m.get("loc");
                if (msg != null) {
                    return loc != null ? (msg + " — " + loc) : String.valueOf(msg);
                }
            }
        }
        Object message = parsed.get("message");
        if (message != null) {
            return String.valueOf(message);
        }
        return "Python 请求失败 HTTP " + httpStatus + (rawBody != null && !rawBody.isEmpty() ? ": " + rawBody : "");
    }
}
