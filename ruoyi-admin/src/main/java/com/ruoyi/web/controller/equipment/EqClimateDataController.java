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
import com.ruoyi.system.domain.EqClimateData;
import com.ruoyi.system.service.IEqClimateDataService;

/**
 * 气候数据：分页、按设备、导出、CRUD。
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@RestController
@RequestMapping("/equipment/climateData")
public class EqClimateDataController extends BaseController
{
    @Autowired
    private IEqClimateDataService eqClimateDataService;

    /** startPage 后分页查询。 */
    @GetMapping("/list")
    public TableDataInfo list(EqClimateData eqClimateData)
    {
        startPage();
        List<EqClimateData> list = eqClimateDataService.selectEqClimateDataList(eqClimateData);
        return getDataTable(list);
    }

    /** 按 deviceId 不分页列表。 */
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") String deviceId)
    {
        List<EqClimateData> list = eqClimateDataService.selectEqClimateDataListByDeviceId(deviceId);
        return success(list);
    }

    /** 条件全量导出 Excel。 */
    @Log(title = "气候数据", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqClimateData eqClimateData)
    {
        List<EqClimateData> list = eqClimateDataService.selectEqClimateDataList(eqClimateData);
        ExcelUtil<EqClimateData> util = new ExcelUtil<EqClimateData>(EqClimateData.class);
        util.exportExcel(response, list, "气候数据数据");
    }

    /** 主键详情。 */
    @GetMapping(value = "/{climateId}")
    public AjaxResult getInfo(@PathVariable("climateId") Long climateId)
    {
        return success(eqClimateDataService.selectEqClimateDataByClimateId(climateId));
    }

    /** 新增。 */
    @Log(title = "气候数据", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqClimateData eqClimateData)
    {
        return toAjax(eqClimateDataService.insertEqClimateData(eqClimateData));
    }

    /** 更新。 */
    @Log(title = "气候数据", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqClimateData eqClimateData)
    {
        return toAjax(eqClimateDataService.updateEqClimateData(eqClimateData));
    }

    /** 批量删主键。 */
    @Log(title = "气候数据", businessType = BusinessType.DELETE)
    @DeleteMapping("/{climateIds}")
    public AjaxResult remove(@PathVariable Long[] climateIds)
    {
        return toAjax(eqClimateDataService.deleteEqClimateDataByClimateIds(climateIds));
    }
}
