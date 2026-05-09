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
import com.ruoyi.system.domain.EqTechnologyData;
import com.ruoyi.system.service.IEqTechnologyDataService;

/**
 * 技术数据：分页、按设备、导出、CRUD。
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@RestController
@RequestMapping("/equipment/technologyData")
public class EqTechnologyDataController extends BaseController
{
    @Autowired
    private IEqTechnologyDataService eqTechnologyDataService;

    /** startPage 后分页查询。 */
    @GetMapping("/list")
    public TableDataInfo list(EqTechnologyData eqTechnologyData)
    {
        startPage();
        List<EqTechnologyData> list = eqTechnologyDataService.selectEqTechnologyDataList(eqTechnologyData);
        return getDataTable(list);
    }

    /** 按 deviceId 不分页列表。 */
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") String deviceId)
    {
        List<EqTechnologyData> list = eqTechnologyDataService.selectEqTechnologyDataListByDeviceId(deviceId);
        return success(list);
    }

    /** 条件全量导出 Excel。 */
    @Log(title = "技术数据", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqTechnologyData eqTechnologyData)
    {
        List<EqTechnologyData> list = eqTechnologyDataService.selectEqTechnologyDataList(eqTechnologyData);
        ExcelUtil<EqTechnologyData> util = new ExcelUtil<EqTechnologyData>(EqTechnologyData.class);
        util.exportExcel(response, list, "技术数据数据");
    }

    /** 主键详情。 */
    @GetMapping(value = "/{techId}")
    public AjaxResult getInfo(@PathVariable("techId") Long techId)
    {
        return success(eqTechnologyDataService.selectEqTechnologyDataByTechId(techId));
    }

    /** 新增。 */
    @Log(title = "技术数据", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqTechnologyData eqTechnologyData)
    {
        return toAjax(eqTechnologyDataService.insertEqTechnologyData(eqTechnologyData));
    }

    /** 更新。 */
    @Log(title = "技术数据", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqTechnologyData eqTechnologyData)
    {
        return toAjax(eqTechnologyDataService.updateEqTechnologyData(eqTechnologyData));
    }

    /** 批量删主键。 */
    @Log(title = "技术数据", businessType = BusinessType.DELETE)
    @DeleteMapping("/{techIds}")
    public AjaxResult remove(@PathVariable Long[] techIds)
    {
        return toAjax(eqTechnologyDataService.deleteEqTechnologyDataByTechIds(techIds));
    }
}
