package com.thor.springai.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.AiMaintenanceForm;
import com.ruoyi.system.mapper.AiMaintenanceFormMapper;
import com.thor.springai.service.MaintenanceFormService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

/**
 * 智能运维表单生成控制器
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/ai/maintenance-form")
public class MaintenanceFormController extends BaseController {
    
    private static final Logger logger = LoggerFactory.getLogger(MaintenanceFormController.class);
    
    @Autowired
    private MaintenanceFormService maintenanceFormService;
    
    @Autowired
    private AiMaintenanceFormMapper maintenanceFormMapper;
    
    /**
     * 查询需要维护的设备列表
     * 
     * @return 设备列表
     */
    @GetMapping("/devices")
    public AjaxResult getDevicesRequiringMaintenance(
        @RequestParam(value = "aiSummary", defaultValue = "true") boolean aiSummary) {
        logger.info("查询需要维护的设备列表 aiSummary={}", aiSummary);
        return maintenanceFormService.getDevicesRequiringMaintenance(aiSummary);
    }
    
    /**
     * 为指定设备生成运维表单
     * 
     * @param deviceId 设备ID
     * @param saveToDb 是否保存到数据库（默认false）
     * @return 生成的表单
     */
    @PostMapping("/generate")
    public AjaxResult generateForm(@RequestParam("deviceId") Long deviceId,
                                   @RequestParam(value = "saveToDb", defaultValue = "false") boolean saveToDb) {
        logger.info("为设备生成运维表单，设备ID: {}, 保存到数据库: {}", deviceId, saveToDb);
        return maintenanceFormService.generateFormForDevice(deviceId, saveToDb);
    }
    
    /**
     * 批量生成运维表单
     * 
     * @param deviceIdsStr 设备ID列表（逗号分隔的字符串）
     * @param saveToDb 是否保存到数据库（默认false）
     * @return 生成结果
     */
    @PostMapping("/batch-generate")
    public AjaxResult batchGenerateForms(@RequestParam("deviceIds") String deviceIdsStr,
                                        @RequestParam(value = "saveToDb", defaultValue = "false") boolean saveToDb) {
        // 将逗号分隔的字符串转换为Long列表
        List<Long> deviceIds = new ArrayList<>();
        if (deviceIdsStr != null && !deviceIdsStr.isEmpty()) {
            String[] ids = deviceIdsStr.split(",");
            for (String id : ids) {
                try {
                    deviceIds.add(Long.parseLong(id.trim()));
                } catch (NumberFormatException e) {
                    logger.warn("无效的设备ID: {}", id);
                }
            }
        }
        logger.info("批量生成运维表单，设备数量: {}, 保存到数据库: {}", deviceIds.size(), saveToDb);
        return maintenanceFormService.batchGenerateForms(deviceIds, saveToDb);
    }
    
    /**
     * 查询运维表单列表（历史记录）
     * 
     * @param form 查询条件
     * @return 表单列表
     */
    @GetMapping("/forms")
    public AjaxResult listForms(AiMaintenanceForm form) {
        try {
            logger.info("查询运维表单列表，条件: {}", form);
            startPage();
            List<AiMaintenanceForm> list = maintenanceFormMapper.selectAiMaintenanceFormList(form);
            return AjaxResult.success(getDataTable(list));
        } catch (Exception e) {
            logger.error("查询运维表单列表失败", e);
            return AjaxResult.error("查询失败: " + e.getMessage());
        }
    }
    
    /**
     * 根据ID获取运维表单详情
     * 
     * @param formId 表单ID
     * @return 表单详情
     */
    @GetMapping("/forms/{formId}")
    public AjaxResult getFormById(@PathVariable("formId") Long formId) {
        try {
            logger.info("查询运维表单详情，表单ID: {}", formId);
            AiMaintenanceForm form = maintenanceFormMapper.selectAiMaintenanceFormById(formId);
            if (form == null) {
                return AjaxResult.error("表单不存在");
            }
            return AjaxResult.success(form);
        } catch (Exception e) {
            logger.error("查询运维表单详情失败", e);
            return AjaxResult.error("查询失败: " + e.getMessage());
        }
    }
    
    /**
     * 更新运维表单
     * 
     * @param form 表单数据
     * @return 操作结果
     */
    @PutMapping("/forms")
    public AjaxResult updateForm(@RequestBody AiMaintenanceForm form) {
        try {
            logger.info("更新运维表单，表单ID: {}", form.getFormId());
            int result = maintenanceFormMapper.updateAiMaintenanceForm(form);
            if (result > 0) {
                return AjaxResult.success("更新成功");
            } else {
                return AjaxResult.error("更新失败");
            }
        } catch (Exception e) {
            logger.error("更新运维表单失败", e);
            return AjaxResult.error("更新失败: " + e.getMessage());
        }
    }
    
    /**
     * 删除运维表单
     * 
     * @param formId 表单ID
     * @return 操作结果
     */
    @DeleteMapping("/forms/{formId}")
    public AjaxResult deleteForm(@PathVariable("formId") Long formId) {
        try {
            logger.info("删除运维表单，表单ID: {}", formId);
            int result = maintenanceFormMapper.deleteAiMaintenanceFormById(formId);
            if (result > 0) {
                return AjaxResult.success("删除成功");
            } else {
                return AjaxResult.error("删除失败，表单不存在");
            }
        } catch (Exception e) {
            logger.error("删除运维表单失败", e);
            return AjaxResult.error("删除失败: " + e.getMessage());
        }
    }
    
    /**
     * 批量删除运维表单
     * 
     * @param formIds 表单ID数组
     * @return 操作结果
     */
    @DeleteMapping("/forms")
    public AjaxResult batchDeleteForms(@RequestBody Long[] formIds) {
        try {
            logger.info("批量删除运维表单，数量: {}", formIds.length);
            int result = maintenanceFormMapper.deleteAiMaintenanceFormByIds(formIds);
            if (result > 0) {
                return AjaxResult.success("删除成功，共删除 " + result + " 条记录");
            } else {
                return AjaxResult.error("删除失败");
            }
        } catch (Exception e) {
            logger.error("批量删除运维表单失败", e);
            return AjaxResult.error("删除失败: " + e.getMessage());
        }
    }
}
