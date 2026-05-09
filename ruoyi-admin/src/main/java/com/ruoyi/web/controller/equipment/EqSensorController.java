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
import com.ruoyi.system.domain.EqSensor;
import com.ruoyi.system.service.IEqSensorService;

/**
 * 传感器：分页列表、按设备拉全量、导出、按主键 CRUD。
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@RestController
@RequestMapping("/equipment/sensor")
public class EqSensorController extends BaseController
{
    @Autowired
    private IEqSensorService eqSensorService;

    /** startPage 后按条件分页查库，封装表格数据。 */
    @GetMapping("/list")
    public TableDataInfo list(EqSensor eqSensor)
    {
        startPage();
        List<EqSensor> list = eqSensorService.selectEqSensorList(eqSensor);
        return getDataTable(list);
    }

    /** 给定 deviceId，不分页返回该设备下全部传感器。 */
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") String deviceId)
    {
        List<EqSensor> list = eqSensorService.selectEqSensorListByDeviceId(deviceId);
        return success(list);
    }

    /** 按当前筛选条件查全量结果集，写出 Excel（不分页）。 */
    @Log(title = "传感器", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqSensor eqSensor)
    {
        List<EqSensor> list = eqSensorService.selectEqSensorList(eqSensor);
        ExcelUtil<EqSensor> util = new ExcelUtil<EqSensor>(EqSensor.class);
        util.exportExcel(response, list, "传感器数据");
    }

    /** 按 sensorId 查一条。 */
    @GetMapping(value = "/{sensorId}")
    public AjaxResult getInfo(@PathVariable("sensorId") Long sensorId)
    {
        return success(eqSensorService.selectEqSensorBySensorId(sensorId));
    }

    /** 请求体入库新增。 */
    @Log(title = "传感器", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqSensor eqSensor)
    {
        return toAjax(eqSensorService.insertEqSensor(eqSensor));
    }

    /** 请求体按主键更新。 */
    @Log(title = "传感器", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqSensor eqSensor)
    {
        return toAjax(eqSensorService.updateEqSensor(eqSensor));
    }

    /** 路径中的多个主键批量删除。 */
    @Log(title = "传感器", businessType = BusinessType.DELETE)
    @DeleteMapping("/{sensorIds}")
    public AjaxResult remove(@PathVariable Long[] sensorIds)
    {
        return toAjax(eqSensorService.deleteEqSensorBySensorIds(sensorIds));
    }
}
