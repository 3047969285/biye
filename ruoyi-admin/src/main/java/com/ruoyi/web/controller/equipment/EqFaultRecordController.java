package com.ruoyi.web.controller.equipment;
import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.EqFaultRecord;
import com.ruoyi.system.service.IEqFaultRecordService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;
@RestController
@RequestMapping("/equipment/faultRecord")
public class EqFaultRecordController extends BaseController {
    @Autowired
    private IEqFaultRecordService eqFaultRecordService;
    @GetMapping("/list")
    public TableDataInfo list(EqFaultRecord eqFaultRecord) {
        startPage();
        List<EqFaultRecord> list = eqFaultRecordService.selectEqFaultRecordList(eqFaultRecord);
        return getDataTable(list);
    }
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") Long deviceId) {
        List<EqFaultRecord> list = eqFaultRecordService.selectEqFaultRecordListByDeviceId(deviceId);
        return success(list);
    }
    @Log(title = "故障记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqFaultRecord eqFaultRecord) {
        List<EqFaultRecord> list = eqFaultRecordService.selectEqFaultRecordList(eqFaultRecord);
        ExcelUtil<EqFaultRecord> util = new ExcelUtil<EqFaultRecord>(EqFaultRecord.class);
        util.exportExcel(response, list, "故障记录数据");
    }
    @GetMapping(value = "/{faultId}")
    public AjaxResult getInfo(@PathVariable("faultId") Long faultId) {
        return success(eqFaultRecordService.selectEqFaultRecordByFaultId(faultId));
    }
    @Log(title = "故障记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqFaultRecord eqFaultRecord) {
        return toAjax(eqFaultRecordService.insertEqFaultRecord(eqFaultRecord));
    }
    @Log(title = "故障记录", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqFaultRecord eqFaultRecord) {
        return toAjax(eqFaultRecordService.updateEqFaultRecord(eqFaultRecord));
    }
    @Log(title = "故障记录", businessType = BusinessType.DELETE)
    @DeleteMapping("/{faultIds}")
    public AjaxResult remove(@PathVariable Long[] faultIds) {
        return toAjax(eqFaultRecordService.deleteEqFaultRecordByFaultIds(faultIds));
    }
}
