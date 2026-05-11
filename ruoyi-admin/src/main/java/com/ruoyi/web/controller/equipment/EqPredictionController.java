package com.ruoyi.web.controller.equipment;

import java.util.List;

import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.EqPrediction;
import com.ruoyi.system.service.IEqPredictionService;

@RestController
@RequestMapping("/equipment/prediction")
public class EqPredictionController extends BaseController {

    @Autowired
    private IEqPredictionService eqPredictionService;

    @GetMapping("/list")
    public TableDataInfo list(EqPrediction query) {
        startPage();
        List<EqPrediction> list = eqPredictionService.selectEqPredictionList(query);
        return getDataTable(list);
    }

    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") String deviceId) {
        List<EqPrediction> list = eqPredictionService.selectEqPredictionListByDeviceId(deviceId);
        return success(list);
    }

    @Log(title = "预测结果", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqPrediction query) {
        List<EqPrediction> list = eqPredictionService.selectEqPredictionList(query);
        ExcelUtil<EqPrediction> util = new ExcelUtil<>(EqPrediction.class);
        util.exportExcel(response, list, "预测结果");
    }

    @GetMapping(value = "/{predictionId}")
    public AjaxResult getInfo(@PathVariable("predictionId") Long predictionId) {
        return success(eqPredictionService.selectEqPredictionByPredictionId(predictionId));
    }

    @Log(title = "预测结果", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqPrediction row) {
        return toAjax(eqPredictionService.insertEqPrediction(row));
    }

    @Log(title = "预测结果", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqPrediction row) {
        return toAjax(eqPredictionService.updateEqPrediction(row));
    }

    @Log(title = "预测结果", businessType = BusinessType.DELETE)
    @DeleteMapping("/{predictionIds}")
    public AjaxResult remove(@PathVariable Long[] predictionIds) {
        return toAjax(eqPredictionService.deleteEqPredictionByPredictionIds(predictionIds));
    }
}
