package com.ruoyi.web.controller.wind;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.EqWindForecastBind;
import com.ruoyi.system.service.IEqWindForecastBindService;
import com.ruoyi.system.service.ISysConfigService;
import com.ruoyi.web.config.properties.WindForecastProperties;
import com.ruoyi.web.controller.wind.dto.WindForecastBindPayload;
import com.ruoyi.web.controller.wind.dto.WindForecastRowsPayload;
import com.ruoyi.web.controller.wind.dto.WindForecastRunRequest;
import com.ruoyi.web.controller.wind.dto.WindForecastSummaryRequest;
import com.ruoyi.web.service.wind.WindForecastBridgeService;
import com.ruoyi.web.service.wind.WindForecastExcelFileService;
import com.ruoyi.web.service.wind.WindForecastPathResolver;
import com.ruoyi.web.service.wind.WindForecastSummaryService;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 风力发电预测：代理本地 Python FastAPI，供前端实时展示
 */
@RestController
@RequestMapping("/wind/forecast")
public class WindForecastController extends BaseController {

    private final WindForecastProperties props;
    private final WindForecastBridgeService bridge;
    private final IEqWindForecastBindService windForecastBindService;
    private final WindForecastSummaryService summaryService;
    private final ObjectMapper objectMapper;
    private final WindForecastExcelFileService excelFileService;
    private final ISysConfigService configService;

    public WindForecastController(WindForecastProperties props, WindForecastBridgeService bridge,
                                  IEqWindForecastBindService windForecastBindService,
                                  WindForecastSummaryService summaryService,
                                  ObjectMapper objectMapper,
                                  WindForecastExcelFileService excelFileService,
                                  ISysConfigService configService) {
        this.props = props;
        this.bridge = bridge;
        this.windForecastBindService = windForecastBindService;
        this.summaryService = summaryService;
        this.objectMapper = objectMapper;
        this.excelFileService = excelFileService;
        this.configService = configService;
    }

    /**
     * 合并：Python 服务状态 + 预测曲线 + 配置摘要。
     *
     * @param deviceId 可选；与 {@code live=true} 联用时，先对该设备（未传则用 bind-device-id）执行一次 Python 预测再返回，避免只读 Java 内存旧缓存。
     * @param live     为 true 且功能开启、Python 可达时，本次接口内同步调用预测，保证展示与当前磁盘 Excel 一致。
     */
    @PreAuthorize("@ss.hasPermi('power:forecast:list')")
    @GetMapping("/latest")
    public AjaxResult latest(
        @RequestParam(required = false) Long deviceId,
        @RequestParam(defaultValue = "false") boolean live) {
        if (live && props.isEnabled() && bridge.isPythonReachable()) {
            Long runId = deviceId != null && deviceId > 0 ? deviceId : props.getBindDeviceId();
            if (runId != null && runId > 0) {
                bridge.runPredict(runId, null, null, null, null);
            } else {
                bridge.runPredict();
            }
        }
        Map<String, Object> prediction = deviceId != null && deviceId > 0
            ? bridge.getLastPrediction(deviceId)
            : bridge.getLastPrediction();
        long at = deviceId != null && deviceId > 0
            ? bridge.getLastPredictionAtMillis(deviceId)
            : bridge.getLastPredictionAtMillis();
        Map<String, Object> out = new HashMap<>();
        out.put("enabled", props.isEnabled());
        out.put("pythonBaseUrl", props.baseUrl());
        out.put("reachable", bridge.isPythonReachable());
        out.put("pythonStatus", bridge.fetchPythonStatus());
        out.put("lastPredictionAt", at);
        out.put("prediction", prediction);
        out.put("lastError", bridge.getLastError());
        out.put("queryDeviceId", deviceId != null ? deviceId : 0L);
        Map<String, Object> cfg = new HashMap<>();
        cfg.put("modelPath", nullToEmpty(props.getModelPath()));
        cfg.put("featureExcel", nullToEmpty(props.getFeatureExcel()));
        cfg.put("realExcel", nullToEmpty(props.getRealExcel()));
        cfg.put("predictLength", props.getPredictLength());
        cfg.put("predictStartIndex", props.getPredictStartIndex());
        cfg.put("forecastPointIntervalMinutes", props.getForecastPointIntervalMinutes());
        cfg.put("forecastExtraMinutes", props.getForecastExtraMinutes());
        cfg.put("beyondDataPoints", props.getBeyondDataPoints());
        cfg.put("scheduleIntervalMs", props.getScheduleIntervalMs());
        cfg.put("scheduleInitialDelayMs", props.getScheduleInitialDelayMs());
        cfg.put("bindDeviceId", props.getBindDeviceId() != null ? props.getBindDeviceId() : 0L);
        cfg.put("clientPollIntervalSec", resolveClientPollIntervalSec());
        out.put("config", cfg);
        return success(out);
    }

    @PreAuthorize("@ss.hasPermi('power:forecast:list')")
    @GetMapping("/status")
    public AjaxResult pythonStatus() {
        return success(bridge.fetchPythonStatus());
    }

    /** 调度/默认：全局配置预测，统计写入 bind-device-id（若配置） */
    @PreAuthorize("@ss.hasPermi('power:forecast:list')")
    @PostMapping("/run")
    public AjaxResult runNow() {
        return success(bridge.runPredict());
    }

    /** 指定设备（及可选路径覆盖）预测 */
    @PreAuthorize("@ss.hasPermi('power:forecast:list')")
    @PostMapping("/run/device")
    public AjaxResult runForDevice(@RequestBody(required = false) WindForecastRunRequest req) {
        if (req == null) {
            req = new WindForecastRunRequest();
        }
        Long deviceId = req.getDeviceId();
        if (deviceId == null || deviceId <= 0) {
            return error("请选择有效的设备 deviceId");
        }
        String model = emptyToNull(req.getModelPath());
        String feat = emptyToNull(req.getFeatureExcel());
        String real = emptyToNull(req.getRealExcel());
        return success(bridge.runPredict(deviceId, model, feat, real, req.getRows()));
    }

    @PreAuthorize("@ss.hasPermi('power:forecast:list')")
    @GetMapping("/bind/{deviceId}")
    public AjaxResult getBind(@PathVariable Long deviceId) {
        if (deviceId == null || deviceId <= 0) {
            return error("设备 ID 无效");
        }
        EqWindForecastBind row = windForecastBindService.selectByDeviceId(deviceId);
        return success(row != null ? row : new EqWindForecastBind());
    }

    /** 读取设备在页面维护的风速+功率序列 */
    @PreAuthorize("@ss.hasPermi('power:forecast:list')")
    @GetMapping("/rows/{deviceId}")
    public AjaxResult getRows(@PathVariable Long deviceId) {
        if (deviceId == null || deviceId <= 0) {
            return error("设备 ID 无效");
        }
        EqWindForecastBind row = windForecastBindService.selectByDeviceId(deviceId);
        String json = row != null ? row.getInlineDataJson() : null;
        if (StringUtils.isEmpty(json)) {
            return success(Collections.singletonMap("rows", Collections.emptyList()));
        }
        try {
            List<Map<String, Object>> list = objectMapper.readValue(json.trim(), new TypeReference<List<Map<String, Object>>>() {});
            if (list == null) {
                list = Collections.emptyList();
            }
            return success(Collections.singletonMap("rows", list));
        } catch (Exception e) {
            return error("解析已存数据失败：" + e.getMessage());
        }
    }

    /** 保存页面编辑的风速+功率序列（按设备预测时优先生成临时 Excel） */
    @PreAuthorize("@ss.hasPermi('power:forecast:list')")
    @PostMapping("/rows")
    public AjaxResult saveRows(@RequestBody WindForecastRowsPayload body) {
        if (body == null || body.getDeviceId() == null || body.getDeviceId() <= 0) {
            return error("请选择有效的设备 deviceId");
        }
        try {
            List<Map<String, Object>> rows = body.getRows() != null ? body.getRows() : Collections.emptyList();
            String json = objectMapper.writeValueAsString(rows);
            EqWindForecastBind patch = new EqWindForecastBind();
            patch.setDeviceId(body.getDeviceId());
            patch.setInlineDataJson(json);
            windForecastBindService.mergeSave(patch);
            return success();
        } catch (Exception e) {
            return error("保存失败：" + e.getMessage());
        }
    }

    /** 下载服务器上当前设备解析到的特征/真值 Excel（路径规则与按设备预测一致） */
    @PreAuthorize("@ss.hasPermi('power:forecast:list')")
    @GetMapping("/excel/{deviceId}")
    public void downloadExcel(@PathVariable Long deviceId, @RequestParam String kind,
                              HttpServletResponse response) throws IOException {
        if (deviceId == null || deviceId <= 0) {
            writeJsonError(response, HttpServletResponse.SC_BAD_REQUEST, "设备 ID 无效");
            return;
        }
        if (StringUtils.isEmpty(kind)) {
            writeJsonError(response, HttpServletResponse.SC_BAD_REQUEST, "请指定 kind=feature 或 real");
            return;
        }
        Path path = excelFileService.resolveExcelPath(deviceId, kind);
        if (path == null) {
            writeJsonError(response, HttpServletResponse.SC_NOT_FOUND, "未配置该 Excel 路径（请在设备绑定或 yml 中配置）");
            return;
        }
        if (!Files.isRegularFile(path)) {
            writeJsonError(response, HttpServletResponse.SC_NOT_FOUND, "服务器上文件不存在：" + path);
            return;
        }
        String fn = path.getFileName().toString();
        String encoded = URLEncoder.encode(fn, StandardCharsets.UTF_8).replace("+", "%20");
        response.setHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encoded + "\"");
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        Files.copy(path, response.getOutputStream());
        response.flushBuffer();
    }

    /** 上传并覆盖服务器上该设备解析到的特征/真值 Excel */
    @PreAuthorize("@ss.hasPermi('power:forecast:list')")
    @PostMapping("/excel/{deviceId}")
    public AjaxResult uploadExcel(@PathVariable Long deviceId, @RequestParam String kind,
                                  @RequestParam("file") MultipartFile file) {
        if (deviceId == null || deviceId <= 0) {
            return error("设备 ID 无效");
        }
        if (StringUtils.isEmpty(kind)) {
            return error("请指定 kind=feature 或 real");
        }
        if (file == null || file.isEmpty()) {
            return error("请选择要上传的文件");
        }
        Path path = excelFileService.resolveUploadTargetPath(deviceId, kind);
        if (path == null) {
            return error("未配置该 Excel 路径，无法确定保存位置（请检查 kind 是否为 feature/real）");
        }
        try {
            Path parent = path.getParent();
            if (parent != null) {
                Files.createDirectories(parent);
            }
            file.transferTo(path.toFile());
            EqWindForecastBind patch = new EqWindForecastBind();
            patch.setDeviceId(deviceId);
            String absSaved = path.toAbsolutePath().toString();
            if ("feature".equalsIgnoreCase(kind)) {
                patch.setFeatureExcelPath(absSaved);
            } else {
                patch.setRealExcelPath(absSaved);
            }
            patch.setInlineDataJson("");
            windForecastBindService.mergeSave(patch);
            Map<String, Object> data = new HashMap<>();
            data.put("savedPath", absSaved);
            data.put("kind", kind);
            return success(data);
        } catch (Exception e) {
            return error("写入失败：" + e.getMessage());
        }
    }

    @PreAuthorize("@ss.hasPermi('power:forecast:list')")
    @PostMapping("/bind")
    public AjaxResult saveBind(@RequestBody WindForecastBindPayload body) {
        if (body == null || body.getDeviceId() == null || body.getDeviceId() <= 0) {
            return error("请选择有效的设备 deviceId");
        }
        EqWindForecastBind patch = new EqWindForecastBind();
        patch.setDeviceId(body.getDeviceId());
        if (StringUtils.isNotEmpty(body.getModelPath())) {
            patch.setModelPath(WindForecastPathResolver.toAbsolutePath(body.getModelPath().trim()));
        }
        if (StringUtils.isNotEmpty(body.getFeatureExcel())) {
            patch.setFeatureExcelPath(WindForecastPathResolver.toAbsolutePath(body.getFeatureExcel().trim()));
        }
        if (StringUtils.isNotEmpty(body.getRealExcel())) {
            patch.setRealExcelPath(WindForecastPathResolver.toAbsolutePath(body.getRealExcel().trim()));
        }
        windForecastBindService.mergeSave(patch);
        return success(windForecastBindService.selectByDeviceId(body.getDeviceId()));
    }

    /** 根据最近一次预测 JSON 生成中文总结 */
    @PreAuthorize("@ss.hasPermi('power:forecast:list')")
    @PostMapping("/summary")
    public AjaxResult summary(@RequestBody(required = false) WindForecastSummaryRequest req) {
        Map<String, Object> p;
        if (req != null && req.getDeviceId() != null && req.getDeviceId() > 0) {
            p = bridge.getLastPrediction(req.getDeviceId());
        } else {
            p = bridge.getLastPrediction();
        }
        return success(summaryService.summarize(p));
    }

    /**
     * 与参数键 {@code client.poll.interval.seconds} 一致；缺省或未配置时按自动预测间隔（秒）推算，范围 30～3600。
     */
    private int resolveClientPollIntervalSec() {
        final int min = 30;
        final int max = 3600;
        String raw = configService.selectConfigByKey("client.poll.interval.seconds");
        int sec = parsePositiveInt(raw, -1);
        if (sec < min || sec > max) {
            long ms = props.getScheduleIntervalMs();
            sec = (int) Math.max(min, Math.min(max, ms / 1000L));
        }
        return sec;
    }

    private static int parsePositiveInt(String s, int dflt) {
        if (StringUtils.isEmpty(s)) {
            return dflt;
        }
        try {
            return Integer.parseInt(s.trim());
        } catch (NumberFormatException e) {
            return dflt;
        }
    }

    private static String nullToEmpty(String s) {
        return s == null ? "" : s;
    }

    private static String emptyToNull(String s) {
        return StringUtils.isEmpty(s) ? null : s.trim();
    }

    private void writeJsonError(HttpServletResponse response, int httpStatus, String msg) throws IOException {
        response.setStatus(httpStatus);
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        Map<String, Object> body = new HashMap<>();
        body.put("code", 500);
        body.put("msg", msg);
        response.getWriter().write(objectMapper.writeValueAsString(body));
    }
}
