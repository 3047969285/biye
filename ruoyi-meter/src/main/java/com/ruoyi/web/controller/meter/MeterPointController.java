package com.ruoyi.web.controller.meter;

import java.util.List;
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
import com.ruoyi.system.domain.MeterPoint;
import com.ruoyi.system.service.IMeterPointService;

/**
 * 电表 Modbus 点表维护
 */
@RestController
@RequestMapping("/meter/point")
public class MeterPointController extends BaseController {

    private final IMeterPointService meterPointService;

    public MeterPointController(IMeterPointService meterPointService) {
        this.meterPointService = meterPointService;
    }

    @PreAuthorize("@ss.hasPermi('meter:point:list')")
    @GetMapping("/list")
    public TableDataInfo list(MeterPoint query) {
        startPage();
        List<MeterPoint> list = meterPointService.selectList(query);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('meter:point:query')")
    @GetMapping("/{pointId}")
    public AjaxResult getInfo(@PathVariable Long pointId) {
        return success(meterPointService.selectById(pointId));
    }

    @PreAuthorize("@ss.hasPermi('meter:point:add')")
    @Log(title = "电表点表", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody MeterPoint row) {
        row.setCreateBy(getUsername());
        return toAjax(meterPointService.insert(row));
    }

    @PreAuthorize("@ss.hasPermi('meter:point:edit')")
    @Log(title = "电表点表", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody MeterPoint row) {
        row.setUpdateBy(getUsername());
        return toAjax(meterPointService.update(row));
    }

    @PreAuthorize("@ss.hasPermi('meter:point:remove')")
    @Log(title = "电表点表", businessType = BusinessType.DELETE)
    @DeleteMapping("/{pointIds}")
    public AjaxResult remove(@PathVariable Long[] pointIds) {
        return toAjax(meterPointService.deleteByIds(pointIds));
    }

    /**
     * 批量导入点表（JSON 数组）
     */
    @PreAuthorize("@ss.hasPermi('meter:point:import')")
    @Log(title = "电表点表导入", businessType = BusinessType.IMPORT)
    @PostMapping("/importData")
    public AjaxResult importData(@RequestBody List<MeterPoint> list,
        @RequestParam(defaultValue = "false") boolean updateSupport) {
        if (list == null || list.isEmpty()) {
            return error("导入数据为空");
        }
        String msg = meterPointService.importPoints(list, updateSupport, getUsername());
        return success(msg);
    }
}

