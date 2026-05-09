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
import com.ruoyi.system.domain.EqEnvironmentData;
import com.ruoyi.system.service.IEqEnvironmentDataService;

/**
 * 环境数据：分页、按设备、导出、CRUD。
 *
 * @author wangchangzhen
 * @date 2026-01-08
 */
@RestController
@RequestMapping("/equipment/environmentData")
public class EqEnvironmentDataController extends BaseController
{
    @Autowired
    private IEqEnvironmentDataService eqEnvironmentDataService;

    /** startPage 后分页查询。 */
    @GetMapping("/list")
    public TableDataInfo list(EqEnvironmentData eqEnvironmentData)
    {
        startPage();
        List<EqEnvironmentData> list = eqEnvironmentDataService.selectEqEnvironmentDataList(eqEnvironmentData);
        return getDataTable(list);
    }

    /** 按 deviceId 不分页列表。 */
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") String deviceId)
    {
        List<EqEnvironmentData> list = eqEnvironmentDataService.selectEqEnvironmentDataListByDeviceId(deviceId);
        return success(list);
    }

    /** 条件全量导出 Excel。 */
    @Log(title = "环境数据", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqEnvironmentData eqEnvironmentData)
    {
        List<EqEnvironmentData> list = eqEnvironmentDataService.selectEqEnvironmentDataList(eqEnvironmentData);
        ExcelUtil<EqEnvironmentData> util = new ExcelUtil<EqEnvironmentData>(EqEnvironmentData.class);
        util.exportExcel(response, list, "环境数据数据");
    }

    /** 主键详情。 */
    @GetMapping(value = "/{envId}")
    public AjaxResult getInfo(@PathVariable("envId") Long envId)
    {
        return success(eqEnvironmentDataService.selectEqEnvironmentDataByEnvId(envId));
    }

    /** 新增。 */
    @Log(title = "环境数据", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqEnvironmentData eqEnvironmentData)
    {
        return toAjax(eqEnvironmentDataService.insertEqEnvironmentData(eqEnvironmentData));
    }

    /** 更新。 */
    @Log(title = "环境数据", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqEnvironmentData eqEnvironmentData)
    {
        return toAjax(eqEnvironmentDataService.updateEqEnvironmentData(eqEnvironmentData));
    }

    /** 批量删主键。 */
    @Log(title = "环境数据", businessType = BusinessType.DELETE)
    @DeleteMapping("/{envIds}")
    public AjaxResult remove(@PathVariable Long[] envIds)
    {
        return toAjax(eqEnvironmentDataService.deleteEqEnvironmentDataByEnvIds(envIds));
    }
}
