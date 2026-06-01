package com.thor.springai.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.ruoyi.common.core.domain.AjaxResult;
import com.thor.springai.dto.PowerPredictDto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

/**
 * 调用 Python 风电功率预测服务（实时推理版）。
 *
 * <p>架构说明：
 * <ul>
 *   <li>/train   — 异步训练，模型持久化到磁盘，支持进度轮询</li>
 *   <li>/predict — 快速推理，毫秒级响应，无需重训练</li>
 *   <li>/status  — 查询训练进度 / 模型指标</li>
 * </ul>
 *
 * @author wangchangzhen
 */
@Service
public class PowerPredictService {

    private static final Logger log = LoggerFactory.getLogger(PowerPredictService.class);

    @Value("${python.wind-power.base-url:http://127.0.0.1:8000}")
    private String pythonBaseUrl;

    /** snake_case ↔ camelCase 双向映射 */
    private final RestTemplate restTemplate;

    public PowerPredictService() {
        ObjectMapper mapper = new ObjectMapper();
        mapper.setPropertyNamingStrategy(PropertyNamingStrategies.SNAKE_CASE);
        MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter(mapper);

        RestTemplate rt = new RestTemplate();
        rt.getMessageConverters().removeIf(c -> c instanceof MappingJackson2HttpMessageConverter);
        rt.getMessageConverters().add(0, converter);
        this.restTemplate = rt;
    }

    // ── 公共辅助 ──────────────────────────────────────────────────────────────
    private HttpHeaders jsonHeaders() {
        HttpHeaders h = new HttpHeaders();
        h.setContentType(MediaType.APPLICATION_JSON);
        return h;
    }

    /**
     * 启动模型训练
     *
     * @param request 训练参数
     * @return 训练启动结果
     */
    public AjaxResult train(PowerPredictDto.TrainRequest request) {
        try {
            String url = pythonBaseUrl + "/train";
            HttpEntity<PowerPredictDto.TrainRequest> entity =
                    new HttpEntity<>(request, jsonHeaders());
            ResponseEntity<PowerPredictDto.TrainResponse> resp =
                    restTemplate.exchange(url, HttpMethod.POST, entity, PowerPredictDto.TrainResponse.class);

            if (resp.getStatusCode().is2xxSuccessful() && resp.getBody() != null) {
                PowerPredictDto.TrainResponse body = resp.getBody();
                return body.getSuccess()
                        ? AjaxResult.success(body.getMessage())
                        : AjaxResult.error(body.getMessage());
            }
            return AjaxResult.error("调用训练接口失败，HTTP " + resp.getStatusCodeValue());
        } catch (Exception e) {
            log.error("调用 Python 训练服务异常", e);
            return AjaxResult.error("训练服务异常：" + e.getMessage());
        }
    }

    /**
     * 执行快速预测
     *
     * @param request 预测参数
     * @return 预测结果
     */
    public AjaxResult quickPredict(PowerPredictDto.QuickPredictRequest request) {
        try {
            String url = pythonBaseUrl + "/predict";
            HttpEntity<PowerPredictDto.QuickPredictRequest> entity =
                    new HttpEntity<>(request, jsonHeaders());
            ResponseEntity<PowerPredictDto.PredictResponse> resp =
                    restTemplate.exchange(url, HttpMethod.POST, entity, PowerPredictDto.PredictResponse.class);

            if (resp.getStatusCode().is2xxSuccessful() && resp.getBody() != null) {
                PowerPredictDto.PredictResponse body = resp.getBody();
                return Boolean.TRUE.equals(body.getSuccess())
                        ? AjaxResult.success("预测成功", body)
                        : AjaxResult.error(body.getMessage());
            }
            return AjaxResult.error("调用预测接口失败，HTTP " + resp.getStatusCodeValue());
        } catch (Exception e) {
            log.error("调用 Python 预测服务异常", e);
            return AjaxResult.error("预测服务异常：" + e.getMessage());
        }
    }

    /**
     * 查询模型状态
     *
     * @return 状态信息
     */
    public AjaxResult getStatus() {
        try {
            String url = pythonBaseUrl + "/status";
            ResponseEntity<PowerPredictDto.StatusResponse> resp =
                    restTemplate.exchange(url, HttpMethod.GET, null, PowerPredictDto.StatusResponse.class);

            if (resp.getStatusCode().is2xxSuccessful() && resp.getBody() != null) {
                return AjaxResult.success("查询成功", resp.getBody());
            }
            return AjaxResult.error("查询状态失败，HTTP " + resp.getStatusCodeValue());
        } catch (Exception e) {
            log.warn("查询 Python 状态服务异常（Python 服务可能未启动）：{}", e.getMessage());
            return AjaxResult.error("Python 服务不可达：" + e.getMessage());
        }
    }

}
