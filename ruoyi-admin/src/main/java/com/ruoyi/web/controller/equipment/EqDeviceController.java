package com.ruoyi.web.controller.equipment;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.EqDevice;
import com.ruoyi.system.service.IEqDeviceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * 设备信息 Controller
 *
 * @author ruoyi
 * @date 2026-01-07
 */
@RestController
@RequestMapping("/equipment/device")
public class EqDeviceController extends BaseController {

    @Autowired
    private IEqDeviceService eqDeviceService;

    /**
     * 查询设备信息列表
     */
    @PreAuthorize("@ss.hasPermi('equipment:device:list')")
    @GetMapping("/list")
    public TableDataInfo list(EqDevice eqDevice) {
        startPage();
        List<EqDevice> list = eqDeviceService.selectEqDeviceList(eqDevice);
        return getDataTable(list);
    }

    /**
     * 导出设备信息列表
     */
    @PreAuthorize("@ss.hasPermi('equipment:device:export')")
    @Log(title = "设备信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqDevice eqDevice) {
        List<EqDevice> list = eqDeviceService.selectEqDeviceList(eqDevice);
        ExcelUtil<EqDevice> util = new ExcelUtil<EqDevice>(EqDevice.class);
        util.exportExcel(response, list, "设备信息数据");
    }

    /**
     * 获取设备信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('equipment:device:query')")
    @GetMapping(value = "/{deviceId}")
    public AjaxResult getInfo(@PathVariable("deviceId") Long deviceId) {
        return success(eqDeviceService.selectEqDeviceByDeviceId(deviceId));
    }

    /**
     * 新增设备信息
     */
    @PreAuthorize("@ss.hasPermi('equipment:device:add')")
    @Log(title = "设备信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqDevice eqDevice) {
        // 校验设备编号唯一性
        if (!eqDeviceService.checkDeviceNoUnique(eqDevice.getDeviceNo())) {
            return error("新增设备失败，设备编号 '" + eqDevice.getDeviceNo() + "' 已存在");
        }
        return toAjax(eqDeviceService.insertEqDevice(eqDevice));
    }

    /**
     * 修改设备信息
     */
    @PreAuthorize("@ss.hasPermi('equipment:device:edit')")
    @Log(title = "设备信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqDevice eqDevice) {
        return toAjax(eqDeviceService.updateEqDevice(eqDevice));
    }

    /**
     * 删除设备信息
     */
    @PreAuthorize("@ss.hasPermi('equipment:device:remove')")
    @Log(title = "设备信息", businessType = BusinessType.DELETE)
    @DeleteMapping("/{deviceIds}")
    public AjaxResult remove(@PathVariable Long[] deviceIds) {
        return toAjax(eqDeviceService.deleteEqDeviceByDeviceIds(deviceIds));
    }

    /**
     * 更新设备状态（单个）
     *
     * @param deviceId 设备ID
     * @param status 状态 (1-正常, 2-停用, 3-维护, 4-报废)
     */
    @PreAuthorize("@ss.hasPermi('equipment:device:edit')")
    @Log(title = "设备状态变更", businessType = BusinessType.UPDATE)
    @PutMapping("/status/{deviceId}/{status}")
    public AjaxResult updateStatus(
            @PathVariable("deviceId") Long deviceId,
            @PathVariable("status") Integer status) {
        return eqDeviceService.updateDeviceStatus(deviceId, status);
    }

    /**
     * 批量更新设备状态
     *
     * @param deviceIds 设备ID数组
     * @param status 状态
     */
    @PreAuthorize("@ss.hasPermi('equipment:device:edit')")
    @Log(title = "批量更新设备状态", businessType = BusinessType.UPDATE)
    @PutMapping("/status/batch")
    public AjaxResult updateStatusBatch(
            @RequestParam(name = "deviceIds") Long[] deviceIds,
            @RequestParam(name = "status") Integer status) {
        return eqDeviceService.updateDeviceStatusBatch(deviceIds, status);
    }

    /**
     * 获取设备统计信息
     */
    @PreAuthorize("@ss.hasPermi('equipment:device:list')")
    @GetMapping("/statistics")
    public AjaxResult getStatistics() {
        Map<String, Object> stats = eqDeviceService.getDeviceStatistics();
        return success(stats);
    }

    /**
     * 获取所有设备的汇总数据（用于首页仪表板）
     */
    @GetMapping("/dashboard/data")
    public AjaxResult getDashboardData() {
        Map<String, Object> data = eqDeviceService.getDeviceDashboardData();
        return success(data);
    }

    /**
     * 校验设备编号是否唯一
     */
    @GetMapping("/checkDeviceNoUnique/{deviceNo}")
    public AjaxResult checkDeviceNoUnique(@PathVariable("deviceNo") String deviceNo) {
        boolean unique = eqDeviceService.checkDeviceNoUnique(deviceNo);
        return success(unique);
    }
}
