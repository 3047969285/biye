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
 *
 * @author thor
 */
@RestController
@RequestMapping("/springai/power")
public class PowerPredictController extends BaseController {

    @Autowired
    private PowerPredictService powerPredictService;

    /**
     * 启动模型训练
     *
     * @param request 训练参数
     * @return 训练启动结果
     */
    @PostMapping("/train")
    public AjaxResult train(@RequestBody PowerPredictDto.TrainRequest request) {
        return powerPredictService.train(request);
    }

    /**
     * 执行快速预测
     *
     * @param request 预测参数
     * @return 预测结果
     */
    @PostMapping("/predict")
    public AjaxResult predict(@RequestBody PowerPredictDto.QuickPredictRequest request) {
        return powerPredictService.quickPredict(request);
    }

    /**
     * 查询训练状态
     *
     * @return 状态结果
     */
    @GetMapping("/status")
    public AjaxResult status() {
        return powerPredictService.getStatus();
    }
}
