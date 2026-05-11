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
import com.ruoyi.system.domain.EqDeviceStat;
import com.ruoyi.system.service.IEqDeviceStatService;

/**
 * 设备统计：分页、按设备、导出、CRUD。
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@RestController
@RequestMapping("/equipment/deviceStat")
public class EqDeviceStatController extends BaseController
{
    @Autowired
    private IEqDeviceStatService eqDeviceStatService;

    /** startPage 后分页查询；汇总模式不走分页。 */
    @GetMapping("/list")
    public TableDataInfo list(EqDeviceStat eqDeviceStat)
    {
        if (Boolean.TRUE.equals(eqDeviceStat.getComputedSummary()))
        {
            return getDataTable(eqDeviceStatService.selectListOrComputedSummary(eqDeviceStat));
        }
        startPage();
        return getDataTable(eqDeviceStatService.selectEqDeviceStatList(eqDeviceStat));
    }

    /** 按 deviceId 不分页列表。 */
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") String deviceId)
    {
        List<EqDeviceStat> list = eqDeviceStatService.selectEqDeviceStatListByDeviceId(deviceId);
        return success(list);
    }

    /** 条件全量导出 Excel。 */
    @Log(title = "设备统计", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqDeviceStat eqDeviceStat)
    {
        List<EqDeviceStat> list = eqDeviceStatService.selectListOrComputedSummary(eqDeviceStat);
        ExcelUtil<EqDeviceStat> util = new ExcelUtil<EqDeviceStat>(EqDeviceStat.class);
        util.exportExcel(response, list, "设备统计数据");
    }

    /** 主键详情。 */
    @GetMapping(value = "/{statId}")
    public AjaxResult getInfo(@PathVariable("statId") Long statId)
    {
        return success(eqDeviceStatService.selectEqDeviceStatByStatId(statId));
    }

    /** 新增。 */
    @Log(title = "设备统计", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqDeviceStat eqDeviceStat)
    {
        return toAjax(eqDeviceStatService.insertEqDeviceStat(eqDeviceStat));
    }

    /** 更新。 */
    @Log(title = "设备统计", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqDeviceStat eqDeviceStat)
    {
        return toAjax(eqDeviceStatService.updateEqDeviceStat(eqDeviceStat));
    }

    /** 批量删主键。 */
    @Log(title = "设备统计", businessType = BusinessType.DELETE)
    @DeleteMapping("/{statIds}")
    public AjaxResult remove(@PathVariable Long[] statIds)
    {
        return toAjax(eqDeviceStatService.deleteEqDeviceStatByStatIds(statIds));
    }
}
