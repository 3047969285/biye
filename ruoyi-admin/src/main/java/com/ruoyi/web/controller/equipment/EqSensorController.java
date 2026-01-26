package com.ruoyi.web.controller.equipment;
import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.EqSensor;
import com.ruoyi.system.service.IEqSensorService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;
@RestController
@RequestMapping("/equipment/sensor")
public class EqSensorController extends BaseController {
    @Autowired
    private IEqSensorService eqSensorService;
    @GetMapping("/list")
    public TableDataInfo list(EqSensor eqSensor) {
        startPage();
        List<EqSensor> list = eqSensorService.selectEqSensorList(eqSensor);
        return getDataTable(list);
    }
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") Long deviceId) {
        List<EqSensor> list = eqSensorService.selectEqSensorListByDeviceId(deviceId);
        return success(list);
    }
    @Log(title = "传感器", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqSensor eqSensor) {
        List<EqSensor> list = eqSensorService.selectEqSensorList(eqSensor);
        ExcelUtil<EqSensor> util = new ExcelUtil<EqSensor>(EqSensor.class);
        util.exportExcel(response, list, "传感器数据");
    }
    @GetMapping(value = "/{sensorId}")
    public AjaxResult getInfo(@PathVariable("sensorId") Long sensorId) {
        return success(eqSensorService.selectEqSensorBySensorId(sensorId));
    }
    @Log(title = "传感器", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqSensor eqSensor) {
        return toAjax(eqSensorService.insertEqSensor(eqSensor));
    }
    @Log(title = "传感器", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqSensor eqSensor) {
        return toAjax(eqSensorService.updateEqSensor(eqSensor));
    }
    @Log(title = "传感器", businessType = BusinessType.DELETE)
    @DeleteMapping("/{sensorIds}")
    public AjaxResult remove(@PathVariable Long[] sensorIds) {
        return toAjax(eqSensorService.deleteEqSensorBySensorIds(sensorIds));
    }
}
