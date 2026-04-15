package com.thor.springai.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.thor.springai.dto.PowerPredictDto;
import com.thor.springai.service.PowerPredictService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 风电功率预测控制器（实时推理版）
 *
 * <ul>
 *   <li>POST /springai/power/train   — 异步训练模型</li>
 *   <li>POST /springai/power/predict — 快速推理（已训练后毫秒响应）</li>
 *   <li>GET  /springai/power/status  — 查询训练状态/进度</li>
 * </ul>
 */
@RestController
@RequestMapping("/springai/power")
public class PowerPredictController extends BaseController {

    @Autowired
    private PowerPredictService powerPredictService;

    /** 异步启动训练，立即返回；前端通过 /status 轮询进度 */
    @PostMapping("/train")
    public AjaxResult train(@RequestBody PowerPredictDto.TrainRequest request) {
        return powerPredictService.train(request);
    }

    /** 快速预测：模型已持久化，推理毫秒级响应 */
    @PostMapping("/predict")
    public AjaxResult predict(@RequestBody PowerPredictDto.QuickPredictRequest request) {
        return powerPredictService.quickPredict(request);
    }

    /** 查询模型状态 / 训练进度 */
    @GetMapping("/status")
    public AjaxResult status() {
        return powerPredictService.getStatus();
    }
}
