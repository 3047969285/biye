package com.thor.springai.service;

import com.alibaba.fastjson2.JSON;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.*;
import com.ruoyi.system.mapper.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * 智能运维表单生成服务
 * 
 * @author ruoyi
 */
@Service
public class MaintenanceFormService {
    
    private static final Logger logger = LoggerFactory.getLogger(MaintenanceFormService.class);
    
    @Autowired
    private EqDeviceStatusMapper deviceStatusMapper;
    
    @Autowired
    private EqFaultRecordMapper faultRecordMapper;
    
    @Autowired
    private EqAlertRecordMapper alertRecordMapper;
    
    @Autowired
    private EqDeviceMapper deviceMapper;
    
    @Autowired
    private AiMaintenanceFormMapper maintenanceFormMapper;
    
    /**
     * 查询需要维护的设备列表
     * 
     * @return 设备列表及问题描述
     */
    public AjaxResult getDevicesRequiringMaintenance() {
        try {
            // 查询状态不好的设备
            List<EqDeviceStatus> statusList = deviceStatusMapper.selectDevicesRequiringMaintenance();
            
            // 查询未解决的故障记录
            EqFaultRecord faultQuery = new EqFaultRecord();
            faultQuery.setStatus(1); // 1-待处理
            List<EqFaultRecord> faultList = faultRecordMapper.selectEqFaultRecordList(faultQuery);
            
            // 查询未解决的告警记录
            EqAlertRecord alertQuery = new EqAlertRecord();
            alertQuery.setStatus(1); // 1-已触发（未解决）
            List<EqAlertRecord> alertList = alertRecordMapper.selectEqAlertRecordList(alertQuery);
            
            // 合并设备信息
            Map<Long, Map<String, Object>> deviceMap = new HashMap<>();
            
            // 处理设备状态
            for (EqDeviceStatus status : statusList) {
                Long deviceId = status.getDeviceId();
                if (!deviceMap.containsKey(deviceId)) {
                    deviceMap.put(deviceId, new HashMap<>());
                }
                Map<String, Object> deviceInfo = deviceMap.get(deviceId);
                deviceInfo.put("deviceId", deviceId);
                deviceInfo.put("deviceNo", status.getDeviceNo());
                deviceInfo.put("deviceName", status.getDeviceName());
                deviceInfo.put("status", status.getStatus());
                deviceInfo.put("statusText", getStatusText(status.getStatus()));
                deviceInfo.put("maintenanceRequired", status.getMaintenanceRequired());
                deviceInfo.put("faultDescription", status.getFaultDescription());
                deviceInfo.put("faultCode", status.getFaultCode());
                deviceInfo.put("timestamp", status.getTimestamp());
                
                // 收集问题描述
                List<String> issues = new ArrayList<>();
                if (status.getStatus() != null && status.getStatus() != 1) {
                    issues.add("设备状态异常：" + getStatusText(status.getStatus()));
                }
                if (status.getFaultDescription() != null && !status.getFaultDescription().isEmpty()) {
                    issues.add("故障描述：" + status.getFaultDescription());
                }
                if (status.getMaintenanceRequired() != null && status.getMaintenanceRequired() == 1) {
                    issues.add("系统提示需要维护");
                }
                deviceInfo.put("issues", issues);
                deviceInfo.put("priority", calculatePriority(status));
            }
            
            // 处理故障记录
            for (EqFaultRecord fault : faultList) {
                Long deviceId = fault.getDeviceId();
                if (!deviceMap.containsKey(deviceId)) {
                    deviceMap.put(deviceId, new HashMap<>());
                    deviceMap.get(deviceId).put("deviceId", deviceId);
                    deviceMap.get(deviceId).put("deviceNo", fault.getDeviceNo());
                    deviceMap.get(deviceId).put("deviceName", fault.getDeviceName());
                    deviceMap.get(deviceId).put("issues", new ArrayList<>());
                }
                Map<String, Object> deviceInfo = deviceMap.get(deviceId);
                @SuppressWarnings("unchecked")
                List<String> issues = (List<String>) deviceInfo.get("issues");
                if (issues == null) {
                    issues = new ArrayList<>();
                    deviceInfo.put("issues", issues);
                }
                issues.add("故障记录：" + fault.getFaultDescription() + 
                          " (等级：" + getFaultLevelText(fault.getFaultLevel()) + ")");
                // 更新优先级
                String currentPriority = (String) deviceInfo.get("priority");
                String faultPriority = getPriorityFromFaultLevel(fault.getFaultLevel());
                if (comparePriority(faultPriority, currentPriority) > 0) {
                    deviceInfo.put("priority", faultPriority);
                }
            }
            
            // 处理告警记录
            for (EqAlertRecord alert : alertList) {
                Long deviceId = alert.getDeviceId();
                if (!deviceMap.containsKey(deviceId)) {
                    deviceMap.put(deviceId, new HashMap<>());
                    deviceMap.get(deviceId).put("deviceId", deviceId);
                    deviceMap.get(deviceId).put("deviceNo", alert.getDeviceNo());
                    deviceMap.get(deviceId).put("deviceName", alert.getDeviceName());
                    deviceMap.get(deviceId).put("issues", new ArrayList<>());
                }
                Map<String, Object> deviceInfo = deviceMap.get(deviceId);
                @SuppressWarnings("unchecked")
                List<String> issues = (List<String>) deviceInfo.get("issues");
                if (issues == null) {
                    issues = new ArrayList<>();
                    deviceInfo.put("issues", issues);
                }
                issues.add("告警信息：" + alert.getAlertMessage() + 
                          " (级别：" + getAlertLevelText(alert.getAlertLevel()) + ")");
            }
            
            // 转换为列表
            List<Map<String, Object>> deviceList = new ArrayList<>(deviceMap.values());
            
            // 按优先级排序
            deviceList.sort((a, b) -> {
                String priorityA = (String) a.get("priority");
                String priorityB = (String) b.get("priority");
                return comparePriority(priorityB, priorityA); // 降序
            });
            
            Map<String, Object> result = new HashMap<>();
            result.put("devices", deviceList);
            result.put("total", deviceList.size());
            
            return AjaxResult.success("查询成功", result);
        } catch (Exception e) {
            logger.error("查询需要维护的设备失败", e);
            return AjaxResult.error("查询失败：" + e.getMessage());
        }
    }
    
    /**
     * 通知需要维护的设备（定时任务调用，别名方法）
     * 这个方法是为了兼容定时任务配置中的方法名
     * 
     * @return 查询结果
     */
    public AjaxResult notifyDevicesRequiringMaintenance() {
        return getDevicesRequiringMaintenance();
    }
    
    /**
     * 为指定设备生成运维表单
     * 
     * @param deviceId 设备ID
     * @param saveToDb 是否保存到数据库
     * @return 生成的表单
     */
    public AjaxResult generateFormForDevice(Long deviceId, boolean saveToDb) {
        try {
            // 获取设备信息
            EqDevice device = deviceMapper.selectEqDeviceByDeviceId(deviceId);
            if (device == null) {
                return AjaxResult.error("设备不存在");
            }
            
            // 获取设备最新状态
            EqDeviceStatus statusQuery = new EqDeviceStatus();
            statusQuery.setDeviceId(deviceId);
            List<EqDeviceStatus> statusList = deviceStatusMapper.selectEqDeviceStatusList(statusQuery);
            EqDeviceStatus latestStatus = statusList.isEmpty() ? null : statusList.get(0);
            
            // 获取未解决的故障记录
            EqFaultRecord faultQuery = new EqFaultRecord();
            faultQuery.setDeviceId(deviceId);
            faultQuery.setStatus(1); // 待处理
            List<EqFaultRecord> faultList = faultRecordMapper.selectEqFaultRecordList(faultQuery);
            
            // 获取未解决的告警记录
            EqAlertRecord alertQuery = new EqAlertRecord();
            alertQuery.setDeviceId(deviceId);
            alertQuery.setStatus(1); // 已触发
            List<EqAlertRecord> alertList = alertRecordMapper.selectEqAlertRecordList(alertQuery);
            
            // 生成表单
            AiMaintenanceForm form = generateForm(device, latestStatus, faultList, alertList);
            
            if (saveToDb) {
                maintenanceFormMapper.insertAiMaintenanceForm(form);
                logger.info("运维表单已保存到数据库，表单ID: {}, 设备ID: {}", form.getFormId(), deviceId);
            }
            
            return AjaxResult.success("表单生成成功", form);
        } catch (Exception e) {
            logger.error("生成运维表单失败，设备ID: {}", deviceId, e);
            return AjaxResult.error("生成失败：" + e.getMessage());
        }
    }
    
    /**
     * 批量生成运维表单
     * 
     * @param deviceIds 设备ID列表
     * @param saveToDb 是否保存到数据库
     * @return 生成结果
     */
    public AjaxResult batchGenerateForms(List<Long> deviceIds, boolean saveToDb) {
        List<Map<String, Object>> results = new ArrayList<>();
        int successCount = 0;
        int failCount = 0;
        
        for (Long deviceId : deviceIds) {
            try {
                AjaxResult result = generateFormForDevice(deviceId, saveToDb);
                Integer code = (Integer) result.get(AjaxResult.CODE_TAG);
                if (code != null && code == 200) {
                    successCount++;
                    Map<String, Object> item = new HashMap<>();
                    item.put("deviceId", deviceId);
                    item.put("success", true);
                    item.put("form", result.get(AjaxResult.DATA_TAG));
                    results.add(item);
                } else {
                    failCount++;
                    Map<String, Object> item = new HashMap<>();
                    item.put("deviceId", deviceId);
                    item.put("success", false);
                    item.put("error", result.get(AjaxResult.MSG_TAG));
                    results.add(item);
                }
            } catch (Exception e) {
                failCount++;
                Map<String, Object> item = new HashMap<>();
                item.put("deviceId", deviceId);
                item.put("success", false);
                item.put("error", e.getMessage());
                results.add(item);
            }
        }
        
        Map<String, Object> summary = new HashMap<>();
        summary.put("total", deviceIds.size());
        summary.put("success", successCount);
        summary.put("fail", failCount);
        summary.put("results", results);
        
        return AjaxResult.success("批量生成完成", summary);
    }
    
    /**
     * 生成运维表单
     */
    private AiMaintenanceForm generateForm(EqDevice device, EqDeviceStatus status, 
                                          List<EqFaultRecord> faultList, 
                                          List<EqAlertRecord> alertList) {
        AiMaintenanceForm form = new AiMaintenanceForm();
        form.setDeviceId(device.getDeviceId());
        form.setDeviceName(device.getDeviceName());
        form.setFormStatus("draft");
        form.setCreatedBy("AI系统");
        form.setCreatedTime(new Date());
        
        // 构建故障描述
        StringBuilder faultDesc = new StringBuilder();
        if (status != null && status.getFaultDescription() != null) {
            faultDesc.append(status.getFaultDescription());
        }
        for (EqFaultRecord fault : faultList) {
            if (faultDesc.length() > 0) faultDesc.append("；");
            faultDesc.append("故障：").append(fault.getFaultDescription());
            if (fault.getFaultCode() != null) {
                faultDesc.append(" (代码：").append(fault.getFaultCode()).append(")");
            }
        }
        for (EqAlertRecord alert : alertList) {
            if (faultDesc.length() > 0) faultDesc.append("；");
            faultDesc.append("告警：").append(alert.getAlertMessage());
        }
        if (faultDesc.length() == 0) {
            faultDesc.append("设备状态异常，需要维护检查");
        }
        form.setFaultDescription(faultDesc.toString());
        
        // 确定维护类型
        String maintenanceType = determineMaintenanceType(status, faultList, alertList);
        form.setMaintenanceType(maintenanceType);
        
        // 确定优先级
        String priority = determinePriority(status, faultList, alertList);
        form.setPriorityLevel(priority);
        
        // 估算耗时
        Integer estimatedTime = estimateTime(status, faultList, alertList);
        form.setEstimatedTime(estimatedTime);
        
        // 所需工具
        List<String> tools = determineRequiredTools(device, status, faultList);
        form.setRequiredTools(JSON.toJSONString(tools));
        
        // 安全注意事项
        String safety = generateSafetyPrecautions(device, status);
        form.setSafetyPrecautions(safety);
        
        // 操作步骤
        List<Map<String, String>> steps = generateSteps(device, status, faultList);
        form.setStepByStepGuide(JSON.toJSONString(steps));
        
        // 预期结果
        String expectedOutcome = generateExpectedOutcome(device, status);
        form.setExpectedOutcome(expectedOutcome);
        
        return form;
    }
    
    /**
     * 确定维护类型
     */
    private String determineMaintenanceType(EqDeviceStatus status, 
                                          List<EqFaultRecord> faultList, 
                                          List<EqAlertRecord> alertList) {
        // 如果有故障记录，优先判断为纠正性维护
        if (faultList != null && !faultList.isEmpty()) {
            for (EqFaultRecord fault : faultList) {
                if ("1".equals(fault.getFaultLevel())) { // 紧急
                    return "紧急";
                }
            }
            return "纠正性";
        }
        
        // 如果有告警，可能是预测性维护
        if (alertList != null && !alertList.isEmpty()) {
            return "预测性";
        }
        
        // 如果状态是警告，可能是预防性维护
        if (status != null && status.getStatus() != null && status.getStatus() == 2) {
            return "预防性";
        }
        
        // 如果需要维护标志，可能是预防性
        if (status != null && status.getMaintenanceRequired() != null && status.getMaintenanceRequired() == 1) {
            return "预防性";
        }
        
        return "预防性"; // 默认
    }
    
    /**
     * 确定优先级
     */
    private String determinePriority(EqDeviceStatus status, 
                                     List<EqFaultRecord> faultList, 
                                     List<EqAlertRecord> alertList) {
        // 检查故障等级
        if (faultList != null && !faultList.isEmpty()) {
            for (EqFaultRecord fault : faultList) {
                String level = fault.getFaultLevel();
                if ("1".equals(level)) return "高"; // 紧急
                if ("2".equals(level)) return "高"; // 严重
            }
        }
        
        // 检查设备状态
        if (status != null && status.getStatus() != null) {
            if (status.getStatus() == 3) return "高"; // 错误
            if (status.getStatus() == 4) return "高"; // 离线
            if (status.getStatus() == 2) return "中"; // 警告
        }
        
        // 检查告警级别
        if (alertList != null && !alertList.isEmpty()) {
            for (EqAlertRecord alert : alertList) {
                if (alert.getAlertLevel() != null && alert.getAlertLevel() <= 2) {
                    return "高";
                }
            }
        }
        
        return "中"; // 默认
    }
    
    /**
     * 估算耗时（分钟）
     */
    private Integer estimateTime(EqDeviceStatus status, 
                                 List<EqFaultRecord> faultList, 
                                 List<EqAlertRecord> alertList) {
        int baseTime = 30; // 基础30分钟
        
        if (faultList != null && !faultList.isEmpty()) {
            for (EqFaultRecord fault : faultList) {
                if (fault.getRepairDuration() != null) {
                    baseTime = Math.max(baseTime, fault.getRepairDuration());
                }
            }
        }
        
        if (status != null && status.getStatus() != null) {
            if (status.getStatus() == 3) baseTime += 60; // 错误状态增加60分钟
            if (status.getStatus() == 4) baseTime += 120; // 离线状态增加120分钟
        }
        
        return baseTime;
    }
    
    /**
     * 确定所需工具
     */
    private List<String> determineRequiredTools(EqDevice device, 
                                                EqDeviceStatus status, 
                                                List<EqFaultRecord> faultList) {
        List<String> tools = new ArrayList<>();
        tools.add("万用表");
        tools.add("螺丝刀套装");
        tools.add("绝缘手套");
        tools.add("安全帽");
        
        if (device != null && device.getDeviceType() != null) {
            if (device.getDeviceType().contains("电气") || device.getDeviceType().contains("电力")) {
                tools.add("钳形电流表");
                tools.add("接地电阻测试仪");
            }
            if (device.getDeviceType().contains("机械")) {
                tools.add("扳手套装");
                tools.add("润滑油");
            }
        }
        
        if (status != null && status.getStatus() != null && status.getStatus() == 3) {
            tools.add("故障诊断仪");
        }
        
        return tools;
    }
    
    /**
     * 生成安全注意事项
     */
    private String generateSafetyPrecautions(EqDevice device, EqDeviceStatus status) {
        StringBuilder safety = new StringBuilder();
        safety.append("1. 操作前必须切断电源，确保设备完全断电；\n");
        safety.append("2. 佩戴个人防护用品（安全帽、绝缘手套、防护眼镜）；\n");
        safety.append("3. 使用绝缘工具，避免直接接触带电部件；\n");
        safety.append("4. 操作时应有专人监护，确保安全；\n");
        safety.append("5. 操作完成后检查设备接地是否良好；\n");
        safety.append("6. 如遇异常情况立即停止操作，上报处理。");
        
        if (status != null && status.getStatus() != null && status.getStatus() == 3) {
            safety.append("\n7. 注意：设备处于错误状态，可能存在安全隐患，需格外小心。");
        }
        
        return safety.toString();
    }
    
    /**
     * 生成操作步骤
     */
    private List<Map<String, String>> generateSteps(EqDevice device, 
                                                    EqDeviceStatus status, 
                                                    List<EqFaultRecord> faultList) {
        List<Map<String, String>> steps = new ArrayList<>();
        
        Map<String, String> step1 = new HashMap<>();
        step1.put("step", "1");
        step1.put("title", "准备工作");
        step1.put("description", "检查工具是否齐全，确认安全措施已到位，切断设备电源");
        steps.add(step1);
        
        Map<String, String> step2 = new HashMap<>();
        step2.put("step", "2");
        step2.put("title", "设备检查");
        step2.put("description", "检查设备外观，查看是否有明显损坏或异常现象");
        steps.add(step2);
        
        if (status != null && status.getFaultCode() != null) {
            Map<String, String> step3 = new HashMap<>();
            step3.put("step", "3");
            step3.put("title", "故障诊断");
            step3.put("description", "根据故障代码 " + status.getFaultCode() + " 进行故障诊断，检查相关部件");
            steps.add(step3);
        }
        
        if (faultList != null && !faultList.isEmpty()) {
            for (int i = 0; i < faultList.size(); i++) {
                EqFaultRecord fault = faultList.get(i);
                Map<String, String> step = new HashMap<>();
                step.put("step", String.valueOf(steps.size() + 1));
                step.put("title", "处理故障：" + fault.getFaultDescription());
                step.put("description", "按照故障处理流程，检查并修复 " + fault.getFaultDescription());
                if (fault.getRootCause() != null) {
                    step.put("description", step.get("description") + "，根本原因：" + fault.getRootCause());
                }
                steps.add(step);
            }
        }
        
        Map<String, String> finalStep = new HashMap<>();
        finalStep.put("step", String.valueOf(steps.size() + 1));
        finalStep.put("title", "测试验证");
        finalStep.put("description", "恢复设备供电，进行功能测试，确认设备运行正常");
        steps.add(finalStep);
        
        Map<String, String> lastStep = new HashMap<>();
        lastStep.put("step", String.valueOf(steps.size() + 1));
        lastStep.put("title", "清理收尾");
        lastStep.put("description", "清理工作现场，整理工具，填写维护记录");
        steps.add(lastStep);
        
        return steps;
    }
    
    /**
     * 生成预期结果
     */
    private String generateExpectedOutcome(EqDevice device, EqDeviceStatus status) {
        StringBuilder outcome = new StringBuilder();
        outcome.append("1. 设备故障得到解决，恢复正常运行状态；\n");
        outcome.append("2. 设备各项参数指标恢复正常范围；\n");
        outcome.append("3. 设备安全性能符合要求；\n");
        outcome.append("4. 维护记录完整，可追溯。");
        return outcome.toString();
    }
    
    // 辅助方法
    private String getStatusText(Integer status) {
        if (status == null) return "未知";
        switch (status) {
            case 1: return "正常";
            case 2: return "警告";
            case 3: return "错误";
            case 4: return "离线";
            default: return "未知";
        }
    }
    
    private String getFaultLevelText(String level) {
        if (level == null) return "未知";
        switch (level) {
            case "1": return "紧急";
            case "2": return "严重";
            case "3": return "一般";
            case "4": return "轻微";
            default: return "未知";
        }
    }
    
    private String getAlertLevelText(Integer level) {
        if (level == null) return "未知";
        if (level <= 1) return "紧急";
        if (level <= 2) return "严重";
        if (level <= 3) return "一般";
        return "轻微";
    }
    
    private String calculatePriority(EqDeviceStatus status) {
        if (status == null) return "中";
        if (status.getStatus() != null) {
            if (status.getStatus() == 3 || status.getStatus() == 4) return "高";
            if (status.getStatus() == 2) return "中";
        }
        return "中";
    }
    
    private String getPriorityFromFaultLevel(String level) {
        if (level == null) return "中";
        switch (level) {
            case "1": return "高";
            case "2": return "高";
            case "3": return "中";
            case "4": return "低";
            default: return "中";
        }
    }
    
    private int comparePriority(String priority1, String priority2) {
        Map<String, Integer> priorityMap = new HashMap<>();
        priorityMap.put("高", 3);
        priorityMap.put("中", 2);
        priorityMap.put("低", 1);
        
        int p1 = priorityMap.getOrDefault(priority1, 2);
        int p2 = priorityMap.getOrDefault(priority2, 2);
        return Integer.compare(p1, p2);
    }
}
