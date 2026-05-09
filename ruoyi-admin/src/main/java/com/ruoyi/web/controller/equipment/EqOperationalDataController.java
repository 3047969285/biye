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
import com.ruoyi.system.domain.EqOperationalData;
import com.ruoyi.system.service.IEqOperationalDataService;

/**
 * 运行数据：分页、按设备、导出、CRUD。
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@RestController
@RequestMapping("/equipment/operationalData")
public class EqOperationalDataController extends BaseController
{
    @Autowired
    private IEqOperationalDataService eqOperationalDataService;

    /** startPage 后分页查询。 */
    @GetMapping("/list")
    public TableDataInfo list(EqOperationalData eqOperationalData)
    {
        startPage();
        List<EqOperationalData> list = eqOperationalDataService.selectEqOperationalDataList(eqOperationalData);
        return getDataTable(list);
    }

    /** 按 deviceId 不分页列表。 */
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") String deviceId)
    {
        List<EqOperationalData> list = eqOperationalDataService.selectEqOperationalDataListByDeviceId(deviceId);
        return success(list);
    }

    /** 条件全量导出 Excel。 */
    @Log(title = "操作数据", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqOperationalData eqOperationalData)
    {
        List<EqOperationalData> list = eqOperationalDataService.selectEqOperationalDataList(eqOperationalData);
        ExcelUtil<EqOperationalData> util = new ExcelUtil<EqOperationalData>(EqOperationalData.class);
        util.exportExcel(response, list, "操作数据数据");
    }

    /** 主键详情。 */
    @GetMapping(value = "/{operationalId}")
    public AjaxResult getInfo(@PathVariable("operationalId") Long operationalId)
    {
        return success(eqOperationalDataService.selectEqOperationalDataByOperationalId(operationalId));
    }

    /** 新增。 */
    @Log(title = "操作数据", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqOperationalData eqOperationalData)
    {
        return toAjax(eqOperationalDataService.insertEqOperationalData(eqOperationalData));
    }

    /** 更新。 */
    @Log(title = "操作数据", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqOperationalData eqOperationalData)
    {
        return toAjax(eqOperationalDataService.updateEqOperationalData(eqOperationalData));
    }

    /** 批量删主键。 */
    @Log(title = "操作数据", businessType = BusinessType.DELETE)
    @DeleteMapping("/{operationalIds}")
    public AjaxResult remove(@PathVariable Long[] operationalIds)
    {
        return toAjax(eqOperationalDataService.deleteEqOperationalDataByOperationalIds(operationalIds));
    }
}
