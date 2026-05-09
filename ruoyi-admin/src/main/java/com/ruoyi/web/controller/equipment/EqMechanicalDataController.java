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
import com.ruoyi.system.domain.EqMechanicalData;
import com.ruoyi.system.service.IEqMechanicalDataService;

/**
 * 机械数据：分页、按设备、导出、CRUD。
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@RestController
@RequestMapping("/equipment/mechanicalData")
public class EqMechanicalDataController extends BaseController
{
    @Autowired
    private IEqMechanicalDataService eqMechanicalDataService;

    /** startPage 后分页查询。 */
    @GetMapping("/list")
    public TableDataInfo list(EqMechanicalData eqMechanicalData)
    {
        startPage();
        List<EqMechanicalData> list = eqMechanicalDataService.selectEqMechanicalDataList(eqMechanicalData);
        return getDataTable(list);
    }

    /** 按 deviceId 不分页列表。 */
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") String deviceId)
    {
        List<EqMechanicalData> list = eqMechanicalDataService.selectEqMechanicalDataListByDeviceId(deviceId);
        return success(list);
    }

    /** 条件全量导出 Excel。 */
    @Log(title = "机械数据", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqMechanicalData eqMechanicalData)
    {
        List<EqMechanicalData> list = eqMechanicalDataService.selectEqMechanicalDataList(eqMechanicalData);
        ExcelUtil<EqMechanicalData> util = new ExcelUtil<EqMechanicalData>(EqMechanicalData.class);
        util.exportExcel(response, list, "机械数据数据");
    }

    /** 主键详情。 */
    @GetMapping(value = "/{mechanicalId}")
    public AjaxResult getInfo(@PathVariable("mechanicalId") Long mechanicalId)
    {
        return success(eqMechanicalDataService.selectEqMechanicalDataByMechanicalId(mechanicalId));
    }

    /** 新增。 */
    @Log(title = "机械数据", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqMechanicalData eqMechanicalData)
    {
        return toAjax(eqMechanicalDataService.insertEqMechanicalData(eqMechanicalData));
    }

    /** 更新。 */
    @Log(title = "机械数据", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqMechanicalData eqMechanicalData)
    {
        return toAjax(eqMechanicalDataService.updateEqMechanicalData(eqMechanicalData));
    }

    /** 批量删主键。 */
    @Log(title = "机械数据", businessType = BusinessType.DELETE)
    @DeleteMapping("/{mechanicalIds}")
    public AjaxResult remove(@PathVariable Long[] mechanicalIds)
    {
        return toAjax(eqMechanicalDataService.deleteEqMechanicalDataByMechanicalIds(mechanicalIds));
    }
}
