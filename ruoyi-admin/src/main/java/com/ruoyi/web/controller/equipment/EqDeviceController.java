package com.ruoyi.web.controller.equipment;

import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.EqDevice;
import com.ruoyi.system.service.IEqDeviceService;

/**
 * 设备主数据：分页与导出、CRUD、状态变更、统计与看板汇总、编号唯一校验。
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@RestController
@RequestMapping("/equipment/device")
public class EqDeviceController extends BaseController
{
    @Autowired
    private IEqDeviceService eqDeviceService;

    /** startPage 后分页查询。 */
    @PreAuthorize("@ss.hasPermi('equipment:device:list')")
    @GetMapping("/list")
    public TableDataInfo list(EqDevice eqDevice)
    {
        startPage();
        List<EqDevice> list = eqDeviceService.selectEqDeviceList(eqDevice);
        return getDataTable(list);
    }

    /** 条件全量导出 Excel（不走分页）。 */
    @PreAuthorize("@ss.hasPermi('equipment:device:export')")
    @Log(title = "设备信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqDevice eqDevice)
    {
        List<EqDevice> list = eqDeviceService.selectEqDeviceList(eqDevice);
        ExcelUtil<EqDevice> util = new ExcelUtil<EqDevice>(EqDevice.class);
        util.exportExcel(response, list, "设备信息数据");
    }

    /** 按 deviceId 查一条。 */
    @PreAuthorize("@ss.hasPermi('equipment:device:query')")
    @GetMapping(value = "/{deviceId}")
    public AjaxResult getInfo(@PathVariable("deviceId") String deviceId)
    {
        return success(eqDeviceService.selectEqDeviceByDeviceId(deviceId));
    }

    /** 先校验 deviceNo 未被占用，再插入。 */
    @PreAuthorize("@ss.hasPermi('equipment:device:add')")
    @Log(title = "设备信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqDevice eqDevice)
    {
        if (!eqDeviceService.checkDeviceNoUnique(eqDevice.getDeviceNo()))
        {
            return error("新增设备失败，设备编号 '" + eqDevice.getDeviceNo() + "' 已存在");
        }
        return toAjax(eqDeviceService.insertEqDevice(eqDevice));
    }

    /** 按主键更新设备字段。 */
    @PreAuthorize("@ss.hasPermi('equipment:device:edit')")
    @Log(title = "设备信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqDevice eqDevice)
    {
        return toAjax(eqDeviceService.updateEqDevice(eqDevice));
    }

    /** 路径传入多台 deviceId，批量删；关联表清理在 Service 事务里做。 */
    @PreAuthorize("@ss.hasPermi('equipment:device:remove')")
    @Log(title = "设备信息", businessType = BusinessType.DELETE)
    @DeleteMapping("/{deviceIds}")
    public AjaxResult remove(@PathVariable String[] deviceIds)
    {
        return toAjax(eqDeviceService.deleteEqDeviceByDeviceIds(deviceIds));
    }

    /**
     * 单台改 status。
     * @param status 1正常 2停用 3维护 4报废
     */
    @PreAuthorize("@ss.hasPermi('equipment:device:edit')")
    @Log(title = "设备状态变更", businessType = BusinessType.UPDATE)
    @PutMapping("/status/{deviceId}/{status}")
    public AjaxResult updateStatus(
            @PathVariable("deviceId") String deviceId,
            @PathVariable("status") Integer status)
    {
        return eqDeviceService.updateDeviceStatus(deviceId, status);
    }

    /** 多台设备改为同一 status，语义同上单台接口。 */
    @PreAuthorize("@ss.hasPermi('equipment:device:edit')")
    @Log(title = "批量更新设备状态", businessType = BusinessType.UPDATE)
    @PutMapping("/status/batch")
    public AjaxResult updateStatusBatch(
            @RequestParam(name = "deviceIds") String[] deviceIds,
            @RequestParam(name = "status") Integer status)
    {
        return eqDeviceService.updateDeviceStatusBatch(deviceIds, status);
    }

    /** 库内聚合：按状态、按类型计数等。 */
    @PreAuthorize("@ss.hasPermi('equipment:device:list')")
    @GetMapping("/statistics")
    public AjaxResult getStatistics()
    {
        Map<String, Object> stats = eqDeviceService.getDeviceStatistics();
        return success(stats);
    }

    /** 每台设备在各业务表上的行数汇总（SQL 计数），供大屏展示。 */
    @GetMapping("/dashboard/data")
    public AjaxResult getDashboardData()
    {
        Map<String, Object> data = eqDeviceService.getDeviceDashboardData();
        return success(data);
    }

    /** true 表示 deviceNo 可用（库中不存在）。 */
    @GetMapping("/checkDeviceNoUnique/{deviceNo}")
    public AjaxResult checkDeviceNoUnique(@PathVariable("deviceNo") String deviceNo)
    {
        boolean unique = eqDeviceService.checkDeviceNoUnique(deviceNo);
        return success(unique);
    }
}
