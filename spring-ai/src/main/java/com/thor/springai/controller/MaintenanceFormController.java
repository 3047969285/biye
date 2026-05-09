package com.thor.springai.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.AiMaintenanceForm;
import com.thor.springai.service.MaintenanceFormService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/springai/maintenance-form")
public class MaintenanceFormController extends BaseController {
    
    private static final Logger logger = LoggerFactory.getLogger(MaintenanceFormController.class);
    
    @Autowired
    private MaintenanceFormService maintenanceFormService;
    
    @GetMapping("/devices")
    public AjaxResult getDevicesRequiringMaintenance(
        @RequestParam(value = "aiSummary", defaultValue = "true") boolean aiSummary) {
        logger.info("查询需要维护的设备列表 aiSummary={}", aiSummary);
        return maintenanceFormService.getDevicesRequiringMaintenance(aiSummary);
    }
    
    @PostMapping("/generate")
    public AjaxResult generateForm(@RequestParam("deviceId") String deviceId,
                                   @RequestParam(value = "saveToDb", defaultValue = "false") boolean saveToDb) {
        logger.info("为设备生成运维表单，设备ID: {}, 保存到数据库: {}", deviceId, saveToDb);
        return maintenanceFormService.generateFormForDevice(deviceId, saveToDb);
    }
    
    @PostMapping("/batch-generate")
    public AjaxResult batchGenerateForms(@RequestParam("deviceIds") String deviceIdsStr,
                                        @RequestParam(value = "saveToDb", defaultValue = "false") boolean saveToDb) {
        List<String> deviceIds = maintenanceFormService.parseDeviceIds(deviceIdsStr);
        logger.info("批量生成运维表单，设备数量: {}, 保存到数据库: {}", deviceIds.size(), saveToDb);
        return maintenanceFormService.batchGenerateForms(deviceIds, saveToDb);
    }
    
    @GetMapping("/forms")
    public AjaxResult listForms(AiMaintenanceForm form) {
        logger.info("查询运维表单列表，条件: {}", form);
        startPage();
        List<AiMaintenanceForm> list = maintenanceFormService.selectFormList(form);
        return AjaxResult.success(getDataTable(list));
    }
    
    @GetMapping("/forms/{formId}")
    public AjaxResult getFormById(@PathVariable("formId") Long formId) {
        logger.info("查询运维表单详情，表单ID: {}", formId);
        return maintenanceFormService.getFormById(formId);
    }
    
    @PutMapping("/forms")
    public AjaxResult updateForm(@RequestBody AiMaintenanceForm form) {
        logger.info("更新运维表单，表单ID: {}", form.getFormId());
        return maintenanceFormService.updateForm(form);
    }
    
    @DeleteMapping("/forms/{formId}")
    public AjaxResult deleteForm(@PathVariable("formId") Long formId) {
        logger.info("删除运维表单，表单ID: {}", formId);
        return maintenanceFormService.deleteForm(formId);
    }
    
    @DeleteMapping("/forms")
    public AjaxResult batchDeleteForms(@RequestBody Long[] formIds) {
        logger.info("批量删除运维表单，数量: {}", formIds == null ? 0 : formIds.length);
        return maintenanceFormService.batchDeleteForms(formIds);
    }
}
