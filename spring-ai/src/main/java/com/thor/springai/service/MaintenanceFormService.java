package com.thor.springai.service;

import com.alibaba.fastjson2.JSON;
import com.ruoyi.common.constant.EquipmentRuleConstants;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.*;
import com.ruoyi.system.domain.dto.RuleTriggerResult;
import com.ruoyi.system.domain.vo.MaintenanceDevicePendingVo;
import com.ruoyi.system.mapper.*;
import com.ruoyi.system.service.IEqDeviceRuleTriggerService;
import com.ruoyi.framework.websocket.BaseWebSocketHandler;
import com.ruoyi.system.service.ISysUserMessageService;
import com.ruoyi.system.task.MaintenanceFormNotifyTask;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;

import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * 智能运维表单服务
 * Bean 名固定为 springAiMaintenanceFormService；Quartz 使用的 maintenanceFormService 见 ruoyi-quartz 门面类。
 *
 * @author thor
 */
@Service("springAiMaintenanceFormService")
public class MaintenanceFormService {
    
    private static final Logger logger = LoggerFactory.getLogger(MaintenanceFormService.class);

    private static final String ISSUE_AI_SYS = "你是电力运维助手。输入为 JSON 数组，每台设备一条上下文，字段含义："
        + "deviceId、deviceName、statusText（运行状态词）、priority（高/中/低）、needMaintenance（是否提示维护）、"
        + "statusFaultHint（状态表上的故障说明，可能为空）、faultCode（状态表故障码）、statusTime（状态更新时间）、"
        + "pendingFaults（待处理故障记录文案数组）、alerts（未恢复告警文案数组）。"
        + "请综合以上信息，用 1～2 句中文概括当前风险与处理关注点，不要堆砌字段名、不要复述长原文。"
        + "输出必须是 JSON 数组且仅含数组，元素形如 {\"deviceId\":\"设备UUID字符串\",\"summary\":\"概括\"}，deviceId 必须与输入完全一致，不要 Markdown、不要代码围栏、不要其它说明。";

    private static final DateTimeFormatter STATUS_TIME_FMT =
        DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm").withZone(ZoneId.systemDefault());
    
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

    @Autowired(required = false)
    private ISysUserMessageService sysUserMessageService;

    @Autowired(required = false)
    private MaintenanceFormNotifyTask maintenanceFormNotifyTask;

    @Autowired(required = false)
    private ChatClient chatClient;

    @Autowired(required = false)
    private BaseWebSocketHandler baseWebSocketHandler;

    @Autowired(required = false)
    private IEqDeviceRuleTriggerService eqDeviceRuleTriggerService;

    /**
     * 解析设备ID字符串
     *
     * @param deviceIdsStr 设备ID字符串（逗号分隔）
     * @return 设备ID列表
     */
    public List<String> parseDeviceIds(String deviceIdsStr) {
        List<String> deviceIds = new ArrayList<>();
        if (deviceIdsStr == null || deviceIdsStr.trim().isEmpty()) {
            return deviceIds;
        }
        String[] ids = deviceIdsStr.split(",");
        for (String id : ids) {
            if (id == null || id.trim().isEmpty()) {
                continue;
            }
            deviceIds.add(id.trim());
        }
        return deviceIds;
    }

    /**
     * 查询运维表单列表
     *
     * @param form 查询条件
     * @return 表单列表
     */
    public List<AiMaintenanceForm> selectFormList(AiMaintenanceForm form) {
        return maintenanceFormMapper.selectAiMaintenanceFormList(form);
    }

    /**
     * 查询运维表单详情
     *
     * @param formId 表单ID
     * @return 查询结果
     */
    public AjaxResult getFormById(Long formId) {
        try {
            AiMaintenanceForm form = maintenanceFormMapper.selectAiMaintenanceFormById(formId);
            if (form == null) {
                return AjaxResult.error("表单不存在");
            }
            return AjaxResult.success(form);
        } catch (Exception e) {
            logger.error("查询运维表单详情失败，表单ID: {}", formId, e);
            return AjaxResult.error("查询失败: " + e.getMessage());
        }
    }

    /**
     * 更新运维表单
     *
     * @param form 表单信息
     * @return 更新结果
     */
    public AjaxResult updateForm(AiMaintenanceForm form) {
        try {
            int result = maintenanceFormMapper.updateAiMaintenanceForm(form);
            if (result > 0) {
                return AjaxResult.success("更新成功");
            }
            return AjaxResult.error("更新失败");
        } catch (Exception e) {
            logger.error("更新运维表单失败，表单ID: {}", form == null ? null : form.getFormId(), e);
            return AjaxResult.error("更新失败: " + e.getMessage());
        }
    }

    /**
     * 删除运维表单
     *
     * @param formId 表单ID
     * @return 删除结果
     */
    public AjaxResult deleteForm(Long formId) {
        try {
            int result = maintenanceFormMapper.deleteAiMaintenanceFormById(formId);
            if (result > 0) {
                return AjaxResult.success("删除成功");
            }
            return AjaxResult.error("删除失败，表单不存在");
        } catch (Exception e) {
            logger.error("删除运维表单失败，表单ID: {}", formId, e);
            return AjaxResult.error("删除失败: " + e.getMessage());
        }
    }

    /**
     * 批量删除运维表单
     *
     * @param formIds 表单ID数组
     * @return 删除结果
     */
    public AjaxResult batchDeleteForms(Long[] formIds) {
        try {
            if (formIds == null || formIds.length == 0) {
                return AjaxResult.error("请选择要删除的表单");
            }
            int result = maintenanceFormMapper.deleteAiMaintenanceFormByIds(formIds);
            if (result > 0) {
                return AjaxResult.success("删除成功，共删除 " + result + " 条记录");
            }
            return AjaxResult.error("删除失败");
        } catch (Exception e) {
            logger.error("批量删除运维表单失败", e);
            return AjaxResult.error("删除失败: " + e.getMessage());
        }
    }
    
    /**
     * 查询需要维护的设备
     *
     * @param useAiIssueSummary 是否启用AI问题摘要
     * @return 设备列表
     */
    public AjaxResult getDevicesRequiringMaintenance(boolean useAiIssueSummary) {
        return buildDevicesRequiringMaintenance(useAiIssueSummary);
    }

    private AjaxResult buildDevicesRequiringMaintenance(boolean useAiIssueSummary) {
        try {
            List<EqDeviceStatus> statusList = loadRuleBasedLatestStatuses();
            
            EqFaultRecord faultQuery = new EqFaultRecord();
            faultQuery.setStatus(1);
            List<EqFaultRecord> faultList = faultRecordMapper.selectEqFaultRecordList(faultQuery);
            
            EqAlertRecord alertQuery = new EqAlertRecord();
            alertQuery.setStatus(1);
            List<EqAlertRecord> alertList = alertRecordMapper.selectEqAlertRecordList(alertQuery);
            
            Map<String, Map<String, Object>> deviceMap = new HashMap<>();
            
            for (EqDeviceStatus status : statusList) {
                String deviceId = status.getDeviceId();
                if (deviceId == null || deviceId.isBlank()) {
                    continue;
                }
                RuleTriggerResult ruleResult = evaluateRuleSnapshot(status);
                int runningStatus = resolveRunningStatusFromRule(ruleResult);
                if (!deviceMap.containsKey(deviceId)) {
                    deviceMap.put(deviceId, new HashMap<>());
                }
                Map<String, Object> deviceInfo = deviceMap.get(deviceId);
                deviceInfo.put("deviceId", deviceId);
                deviceInfo.put("deviceNo", status.getDeviceNo());
                deviceInfo.put("deviceName", status.getDeviceName());
                deviceInfo.put("status", runningStatus);
                deviceInfo.put("statusText", getStatusText(runningStatus));
                deviceInfo.put("maintenanceRequired", isMaintenanceRequiredByRule(ruleResult)
                    ? EquipmentRuleConstants.MAINTENANCE_YES : EquipmentRuleConstants.MAINTENANCE_NO);
                deviceInfo.put("faultDescription", status.getFaultDescription());
                deviceInfo.put("faultCode", status.getFaultCode());
                deviceInfo.put("timestamp", status.getTimestamp());
                
                deviceInfo.put("issues", new ArrayList<>());
                deviceInfo.put("pendingFaults", new ArrayList<String>());
                deviceInfo.put("priority", calculatePriority(ruleResult, Collections.emptyList()));
            }
            
            for (EqFaultRecord fault : faultList) {
                String deviceId = fault.getDeviceId();
                if (deviceId == null || deviceId.isBlank()) {
                    continue;
                }
                if (!deviceMap.containsKey(deviceId)) {
                    continue;
                }
                Map<String, Object> deviceInfo = deviceMap.get(deviceId);
                @SuppressWarnings("unchecked")
                List<String> issues = (List<String>) deviceInfo.get("issues");
                if (issues == null) {
                    issues = new ArrayList<>();
                    deviceInfo.put("issues", issues);
                }
                @SuppressWarnings("unchecked")
                List<String> pendingFaults = (List<String>) deviceInfo.get("pendingFaults");
                if (pendingFaults == null) {
                    pendingFaults = new ArrayList<>();
                    deviceInfo.put("pendingFaults", pendingFaults);
                }
                String fdesc = fault.getFaultDescription();
                if (fdesc != null && !fdesc.trim().isEmpty()) {
                    String lv = faultLevelLabel(fault.getFaultLevel());
                    pendingFaults.add(lv == null ? fdesc.trim() : fdesc.trim() + "（" + lv + "）");
                }
            }
            
            for (EqAlertRecord alert : alertList) {
                String deviceId = alert.getDeviceId();
                if (deviceId == null || deviceId.isBlank()) {
                    continue;
                }
                if (!isRuleAlert(alert)) {
                    continue;
                }
                if (!deviceMap.containsKey(deviceId)) {
                    deviceMap.put(deviceId, new HashMap<>());
                    Map<String, Object> ni = deviceMap.get(deviceId);
                    ni.put("deviceId", deviceId);
                    ni.put("deviceNo", alert.getDeviceNo());
                    ni.put("deviceName", alert.getDeviceName());
                    ni.put("issues", new ArrayList<>());
                    ni.put("pendingFaults", new ArrayList<String>());
                    int statusFromAlert = runningStatusFromAlertLevel(alert.getAlertLevel());
                    ni.put("status", statusFromAlert);
                    ni.put("statusText", getStatusText(statusFromAlert));
                    ni.put("maintenanceRequired", isMaintenanceRequiredByAlert(alert.getAlertLevel())
                        ? EquipmentRuleConstants.MAINTENANCE_YES : EquipmentRuleConstants.MAINTENANCE_NO);
                    ni.put("priority", getPriorityFromAlertLevel(alert.getAlertLevel()));
                }
                Map<String, Object> deviceInfo = deviceMap.get(deviceId);
                @SuppressWarnings("unchecked")
                List<String> issues = (List<String>) deviceInfo.get("issues");
                if (issues == null) {
                    issues = new ArrayList<>();
                    deviceInfo.put("issues", issues);
                }
                deviceInfo.computeIfAbsent("pendingFaults", k -> new ArrayList<String>());
                String amsg = alert.getAlertMessage();
                if (amsg != null && !amsg.trim().isEmpty()) {
                    issues.add(amsg.trim());
                }
                String ap = getPriorityFromAlertLevel(alert.getAlertLevel());
                String cur = (String) deviceInfo.get("priority");
                if (comparePriority(ap, cur != null ? cur : "中") > 0) {
                    deviceInfo.put("priority", ap);
                }
                Integer currentStatus = (Integer) deviceInfo.get("status");
                int statusFromAlert = runningStatusFromAlertLevel(alert.getAlertLevel());
                if (currentStatus == null || statusFromAlert > currentStatus) {
                    deviceInfo.put("status", statusFromAlert);
                    deviceInfo.put("statusText", getStatusText(statusFromAlert));
                }
                if (isMaintenanceRequiredByAlert(alert.getAlertLevel())) {
                    deviceInfo.put("maintenanceRequired", EquipmentRuleConstants.MAINTENANCE_YES);
                }
            }
            
            List<Map<String, Object>> deviceList = new ArrayList<>(deviceMap.values());
            
            deviceList.sort((a, b) -> {
                String priorityA = (String) a.get("priority");
                String priorityB = (String) b.get("priority");
                return comparePriority(priorityB, priorityA);
            });

            fillIssueAiSummaries(deviceList, useAiIssueSummary);
            
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
     * 供 Quartz「检查报警」调用：先聚合查询需维护/告警设备（供前端等使用），再扫描 draft/pending 运维表单并推送站内消息。
     * 与 {@link MaintenanceFormNotifyTask#scanPendingFormsAndNotify()} 共用同一套发消息逻辑；若仅想发消息也可单独配置该 Task。
     *
     * @return 聚合结果
     */
    public AjaxResult notifyDevicesRequiringMaintenance() {
        AjaxResult result = buildDevicesRequiringMaintenance(false);
        if (!result.isSuccess()) {
            logger.warn("[检查报警] 聚合设备数据失败，已跳过站内消息同步（避免误清空待维护消息）。msg={}", result.get(AjaxResult.MSG_TAG));
        } else if (sysUserMessageService != null) {
            try {
                List<MaintenanceDevicePendingVo> pending = parseMaintenanceDevicePendingList(result);
                sysUserMessageService.syncMaintenanceDevicePendingMessages(pending);
                logger.info("[检查报警] 已同步待维护设备站内消息，设备数={}", pending.size());
                broadcastMaintenanceNoticeIfNeeded(pending.size());
            } catch (Exception e) {
                logger.warn("[检查报警] 同步待维护设备站内消息失败: {}", e.getMessage(), e);
            }
        }
        if (maintenanceFormNotifyTask != null) {
            try {
                maintenanceFormNotifyTask.scanPendingFormsAndNotify();
            } catch (Exception e) {
                logger.warn("[检查报警] 扫描运维表单站内消息失败: {}", e.getMessage(), e);
            }
        } else {
            logger.debug("MaintenanceFormNotifyTask 未注入，跳过运维表单草稿扫描");
        }
        return result;
    }

    /** 与前端 main.js WebSocket 约定字段一致：type=maintenance_notice */
    private void broadcastMaintenanceNoticeIfNeeded(int deviceCount) {
        if (baseWebSocketHandler == null || deviceCount <= 0) {
            return;
        }
        try {
            JSONObject payload = new JSONObject();
            payload.put("type", "maintenance_notice");
            payload.put("title", "智能运维提醒");
            payload.put("message", String.format("当前有 %d 台设备待维护或存在告警，请及时查看消息中心。", deviceCount));
            payload.put("count", deviceCount);
            baseWebSocketHandler.broadcast(payload.toJSONString());
        } catch (Exception e) {
            logger.debug("检查报警 WebSocket 广播跳过: {}", e.getMessage());
        }
    }

    @SuppressWarnings("unchecked")
    private List<MaintenanceDevicePendingVo> parseMaintenanceDevicePendingList(AjaxResult result) {
        if (result == null) {
            return Collections.emptyList();
        }
        Object data = result.get(AjaxResult.DATA_TAG);
        if (!(data instanceof Map)) {
            return Collections.emptyList();
        }
        Map<String, Object> map = (Map<String, Object>) data;
        Object devices = map.get("devices");
        if (!(devices instanceof List)) {
            return Collections.emptyList();
        }
        List<MaintenanceDevicePendingVo> out = new ArrayList<>();
        for (Object o : (List<?>) devices) {
            if (!(o instanceof Map)) {
                continue;
            }
            Map<String, Object> m = (Map<String, Object>) o;
            Object id = m.get("deviceId");
            if (id == null) {
                continue;
            }
            String deviceId = String.valueOf(id).trim();
            if (deviceId.isEmpty()) {
                continue;
            }
            String name = m.get("deviceName") != null ? String.valueOf(m.get("deviceName")) : "设备";
            String pri = m.get("priority") != null ? String.valueOf(m.get("priority")) : "—";
            out.add(new MaintenanceDevicePendingVo(deviceId, name, pri));
        }
        return out;
    }
    
    /**
     * 为单台设备生成运维表单
     *
     * @param deviceId 设备ID
     * @param saveToDb 是否保存到数据库
     * @return 生成结果
     */
    public AjaxResult generateFormForDevice(String deviceId, boolean saveToDb) {
        try {
            EqDevice device = deviceMapper.selectEqDeviceByDeviceId(deviceId);
            if (device == null) {
                return AjaxResult.error("设备不存在");
            }
            
            EqDeviceStatus latestStatus = deviceStatusMapper.selectLatestByDeviceId(deviceId);
            
            EqFaultRecord faultQuery = new EqFaultRecord();
            faultQuery.setDeviceId(deviceId);
            faultQuery.setStatus(1);
            List<EqFaultRecord> faultList = faultRecordMapper.selectEqFaultRecordList(faultQuery);
            
            EqAlertRecord alertQuery = new EqAlertRecord();
            alertQuery.setDeviceId(deviceId);
            alertQuery.setStatus(1);
            List<EqAlertRecord> alertList = alertRecordMapper.selectEqAlertRecordList(alertQuery);
            
            RuleTriggerResult ruleResult = evaluateRuleSnapshot(latestStatus);
            AiMaintenanceForm form = generateForm(device, latestStatus, ruleResult, faultList, alertList);
            
            if (saveToDb) {
                maintenanceFormMapper.insertAiMaintenanceForm(form);
                logger.info("运维表单已保存到数据库，表单ID: {}, 设备ID: {}", form.getFormId(), deviceId);
                if (sysUserMessageService != null) {
                    sysUserMessageService.notifyMaintenanceFormPending(form);
                }
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
    public AjaxResult batchGenerateForms(List<String> deviceIds, boolean saveToDb) {
        List<Map<String, Object>> results = new ArrayList<>();
        int successCount = 0;
        int failCount = 0;
        
        for (String deviceId : deviceIds) {
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
    
    private AiMaintenanceForm generateForm(EqDevice device, EqDeviceStatus status,
                                          RuleTriggerResult ruleResult,
                                          List<EqFaultRecord> faultList, 
                                          List<EqAlertRecord> alertList) {
        List<EqAlertRecord> ruleAlerts = filterRuleAlerts(alertList);
        AiMaintenanceForm form = new AiMaintenanceForm();
        form.setDeviceId(device.getDeviceId());
        form.setDeviceName(device.getDeviceName());
        form.setFormStatus("draft");
        form.setCreatedBy("AI系统");
        form.setCreatedTime(new Date());
        
        String compactFacts = buildCompactFaultFacts(status, faultList, alertList);
        form.setFaultDescription(summarizeFaultDescriptionAi(compactFacts));
        
        String maintenanceType = determineMaintenanceType(ruleResult, ruleAlerts);
        form.setMaintenanceType(maintenanceType);
        
        String priority = determinePriority(ruleResult, ruleAlerts);
        form.setPriorityLevel(priority);
        
        Integer estimatedTime = estimateTime(ruleResult, ruleAlerts);
        form.setEstimatedTime(estimatedTime);
        
        List<String> tools = determineRequiredTools(device, status, faultList);
        form.setRequiredTools(JSON.toJSONString(tools));
        
        String safety = generateSafetyPrecautions(device, status);
        form.setSafetyPrecautions(safety);
        
        List<Map<String, String>> steps = generateSteps(device, status, faultList);
        form.setStepByStepGuide(JSON.toJSONString(steps));
        
        String expectedOutcome = generateExpectedOutcome(device, status);
        form.setExpectedOutcome(expectedOutcome);
        
        return form;
    }

    /** 去掉状态表里拼接的「关联数据概览」及之后内容，避免把条数统计喂给模型或展示。 */
    private static String stripDataOverviewBlock(String s) {
        if (s == null) {
            return "";
        }
        int idx = s.indexOf("【关联数据概览】");
        if (idx < 0) {
            idx = s.indexOf("关联数据概览");
        }
        if (idx >= 0) {
            return s.substring(0, idx).trim();
        }
        return s.trim();
    }

    /**
     * 生成运维单故障描述的事实输入：优先待处理故障与未恢复告警；若无则使用已剥离概览块的状态说明。
     */
    private String buildCompactFaultFacts(EqDeviceStatus status, List<EqFaultRecord> faultList,
        List<EqAlertRecord> alertList) {
        List<String> facts = new ArrayList<>();
        if (faultList != null) {
            for (EqFaultRecord fault : faultList) {
                if (fault.getFaultDescription() != null && !fault.getFaultDescription().isBlank()) {
                    String line = fault.getFaultDescription().trim();
                    if (fault.getFaultCode() != null && !fault.getFaultCode().isBlank()) {
                        line = line + " 故障码 " + fault.getFaultCode();
                    }
                    facts.add(line);
                }
            }
        }
        if (alertList != null) {
            for (EqAlertRecord alert : alertList) {
                if (alert.getAlertMessage() != null && !alert.getAlertMessage().isBlank()) {
                    facts.add(alert.getAlertMessage().trim());
                }
            }
        }
        if (facts.isEmpty() && status != null && status.getFaultDescription() != null) {
            String st = stripDataOverviewBlock(status.getFaultDescription());
            if (st != null && !st.isBlank()) {
                facts.add(st);
            }
        }
        if (facts.isEmpty()) {
            return "需维护检查";
        }
        return String.join("；", facts);
    }

    private String summarizeFaultDescriptionAi(String compactFacts) {
        if (compactFacts == null || compactFacts.isBlank()) {
            return "需维护检查";
        }
        if (chatClient == null) {
            return shortenProfessional(compactFacts, 500);
        }
        try {
            String reply = chatClient.prompt()
                .system("你是电力运维技术专家。根据下列与设备相关的异常要点，用中文写一段故障描述（可作运维单字段）。\n"
                    + "要求：\n"
                    + "1）3～6 句，可适度换行，每句简明；\n"
                    + "2）仅描述现象、影响与处置关注点；\n"
                    + "3）禁止使用【】、星号、Markdown、括号列举统计；\n"
                    + "4）不要写「几条数据」「有数据」等与条数统计相关的表述；\n"
                    + "5）不要使用过多分号或特殊符号，语句专业、通顺。")
                .user(compactFacts)
                .call()
                .content();
            if (reply != null) {
                String t = reply.trim();
                if (t.startsWith("```")) {
                    int nl = t.indexOf('\n');
                    if (nl > 0) {
                        t = t.substring(nl + 1);
                    }
                    if (t.endsWith("```")) {
                        t = t.substring(0, t.length() - 3).trim();
                    }
                }
                if (!t.isBlank()) {
                    return t;
                }
            }
        } catch (Exception e) {
            logger.warn("summarizeFaultDescriptionAi failed: {}", e.getMessage());
        }
        return shortenProfessional(compactFacts, 500);
    }

    private static String shortenProfessional(String s, int maxLen) {
        if (s == null) {
            return "";
        }
        String t = s.replaceAll("\\s+", " ").trim();
        if (t.length() <= maxLen) {
            return t;
        }
        return t.substring(0, Math.max(0, maxLen - 1)) + "…";
    }
    
    private String determineMaintenanceType(RuleTriggerResult ruleResult, List<EqAlertRecord> ruleAlerts) {
        if (ruleAlerts != null && !ruleAlerts.isEmpty()) {
            Integer maxLevel = null;
            for (EqAlertRecord alert : ruleAlerts) {
                if (alert.getAlertLevel() == null) {
                    continue;
                }
                if (maxLevel == null || alert.getAlertLevel() > maxLevel) {
                    maxLevel = alert.getAlertLevel();
                }
            }
            if (maxLevel != null && maxLevel >= EquipmentRuleConstants.ALERT_LEVEL_CRITICAL) {
                return "紧急";
            }
            if (maxLevel != null && maxLevel >= EquipmentRuleConstants.ALERT_LEVEL_SERIOUS) {
                return "纠正性";
            }
            return "预测性";
        }
        if (ruleResult != null && ruleResult.getRulesHit() > 0) {
            return "预测性";
        }
        if (isMaintenanceRequiredByRule(ruleResult)) {
            return "预防性";
        }
        return "预防性";
    }
    
    private String determinePriority(RuleTriggerResult ruleResult, List<EqAlertRecord> ruleAlerts) {
        return calculatePriority(ruleResult, ruleAlerts);
    }
    
    private Integer estimateTime(RuleTriggerResult ruleResult, List<EqAlertRecord> ruleAlerts) {
        int baseTime = 30;
        int runningStatus = resolveRunningStatusFromRule(ruleResult);
        if (runningStatus == EquipmentRuleConstants.RUNNING_WARNING) {
            baseTime += 30;
        } else if (runningStatus == EquipmentRuleConstants.RUNNING_ERROR) {
            baseTime += 90;
        } else if (runningStatus == EquipmentRuleConstants.RUNNING_OFFLINE) {
            baseTime += 120;
        }
        if (isMaintenanceRequiredByRule(ruleResult)) {
            baseTime += 30;
        }
        if (ruleAlerts != null && !ruleAlerts.isEmpty()) {
            for (EqAlertRecord alert : ruleAlerts) {
                Integer level = alert.getAlertLevel();
                if (level == null) {
                    continue;
                }
                if (level >= EquipmentRuleConstants.ALERT_LEVEL_CRITICAL) {
                    baseTime += 120;
                    continue;
                }
                if (level >= EquipmentRuleConstants.ALERT_LEVEL_SERIOUS) {
                    baseTime += 60;
                }
            }
        }
        return Math.min(baseTime, 480);
    }
    
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
    
    private String generateExpectedOutcome(EqDevice device, EqDeviceStatus status) {
        StringBuilder outcome = new StringBuilder();
        outcome.append("1. 设备故障得到解决，恢复正常运行状态；\n");
        outcome.append("2. 设备各项参数指标恢复正常范围；\n");
        outcome.append("3. 设备安全性能符合要求；\n");
        outcome.append("4. 维护记录完整，可追溯。");
        return outcome.toString();
    }
    
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
    
    private String calculatePriority(RuleTriggerResult ruleResult, List<EqAlertRecord> ruleAlerts) {
        String priority = "低";
        int runningStatus = resolveRunningStatusFromRule(ruleResult);
        if (runningStatus == EquipmentRuleConstants.RUNNING_ERROR
            || runningStatus == EquipmentRuleConstants.RUNNING_OFFLINE) {
            priority = "高";
        } else if (runningStatus == EquipmentRuleConstants.RUNNING_WARNING) {
            priority = "中";
        }
        if (isMaintenanceRequiredByRule(ruleResult)) {
            priority = "高";
        }
        if (ruleAlerts != null && !ruleAlerts.isEmpty()) {
            for (EqAlertRecord alert : ruleAlerts) {
                String fromAlert = getPriorityFromAlertLevel(alert.getAlertLevel());
                if (comparePriority(fromAlert, priority) > 0) {
                    priority = fromAlert;
                }
            }
        }
        return priority;
    }

    private static String getPriorityFromAlertLevel(Integer level) {
        if (level == null) {
            return "中";
        }
        if (level >= EquipmentRuleConstants.ALERT_LEVEL_SERIOUS) {
            return "高";
        }
        if (level >= EquipmentRuleConstants.ALERT_LEVEL_NORMAL) {
            return "中";
        }
        return "低";
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

    private List<EqDeviceStatus> loadRuleBasedLatestStatuses() {
        List<EqDeviceStatus> statusList = new ArrayList<>();
        List<EqDevice> devices = deviceMapper.selectEqDeviceList(new EqDevice());
        if (devices == null || devices.isEmpty()) {
            return statusList;
        }
        for (EqDevice device : devices) {
            if (device == null || device.getDeviceId() == null || device.getDeviceId().isBlank()) {
                continue;
            }
            EqDeviceStatus latest = deviceStatusMapper.selectLatestByDeviceId(device.getDeviceId());
            RuleTriggerResult ruleResult = evaluateRuleSnapshot(latest);
            if (!shouldIncludeByRule(ruleResult)) {
                continue;
            }
            statusList.add(latest);
        }
        return statusList;
    }

    private boolean shouldIncludeByRule(RuleTriggerResult ruleResult) {
        if (ruleResult == null || !hasConfiguredRules(ruleResult)) {
            return false;
        }
        return ruleResult.getRulesHit() > 0 || isMaintenanceRequiredByRule(ruleResult);
    }

    private RuleTriggerResult evaluateRuleSnapshot(EqDeviceStatus status) {
        if (status == null || eqDeviceRuleTriggerService == null) {
            return null;
        }
        try {
            return eqDeviceRuleTriggerService.fireRulesForSnapshot(status);
        } catch (Exception e) {
            logger.debug("规则引擎计算失败，返回空结果: {}", e.getMessage());
            return null;
        }
    }

    private int resolveRunningStatusFromRule(RuleTriggerResult ruleResult) {
        if (ruleResult == null || !hasConfiguredRules(ruleResult) || ruleResult.getRulesHit() <= 0) {
            return EquipmentRuleConstants.RUNNING_NORMAL;
        }
        int target = ruleResult.getTargetRunningStatus();
        if (target <= 0) {
            return EquipmentRuleConstants.RUNNING_WARNING;
        }
        if (target >= EquipmentRuleConstants.RUNNING_ERROR) {
            return EquipmentRuleConstants.RUNNING_ERROR;
        }
        return EquipmentRuleConstants.RUNNING_WARNING;
    }

    private static boolean hasConfiguredRules(RuleTriggerResult ruleResult) {
        return ruleResult != null && ruleResult.getRulesEvaluated() > 0;
    }

    private static boolean isMaintenanceRequiredByRule(RuleTriggerResult ruleResult) {
        return ruleResult != null && ruleResult.isNeedMaintenance();
    }

    private static int runningStatusFromAlertLevel(Integer alertLevel) {
        if (alertLevel == null) {
            return EquipmentRuleConstants.RUNNING_WARNING;
        }
        if (alertLevel >= EquipmentRuleConstants.ALERT_LEVEL_SERIOUS) {
            return EquipmentRuleConstants.RUNNING_ERROR;
        }
        return EquipmentRuleConstants.RUNNING_WARNING;
    }

    private static boolean isMaintenanceRequiredByAlert(Integer alertLevel) {
        return alertLevel != null && alertLevel >= EquipmentRuleConstants.ALERT_LEVEL_SERIOUS;
    }

    private static boolean isRuleAlert(EqAlertRecord alert) {
        if (alert == null) {
            return false;
        }
        if (alert.getRuleId() != null) {
            return true;
        }
        String remark = alert.getRemark();
        return remark != null && remark.contains("规则引擎");
    }

    private static List<EqAlertRecord> filterRuleAlerts(List<EqAlertRecord> alertList) {
        List<EqAlertRecord> out = new ArrayList<>();
        if (alertList == null || alertList.isEmpty()) {
            return out;
        }
        for (EqAlertRecord alert : alertList) {
            if (isRuleAlert(alert)) {
                out.add(alert);
            }
        }
        return out;
    }

    private void fillIssueAiSummaries(List<Map<String, Object>> deviceList, boolean useAiIssueSummary) {
        List<Map<String, Object>> need = new ArrayList<>();
        for (Map<String, Object> d : deviceList) {
            if (deviceNeedsCombinedSummary(d)) {
                need.add(d);
            } else {
                d.put("issueAiSummary", "");
            }
        }
        if (need.isEmpty()) {
            return;
        }
        if (!useAiIssueSummary || chatClient == null) {
            for (Map<String, Object> d : need) {
                d.put("issueAiSummary", ruleBasedCombinedSummary(d));
            }
            return;
        }
        try {
            String payload = buildDeviceContextPayloadForAi(need);
            String reply = chatClient.prompt()
                .system(ISSUE_AI_SYS)
                .user(payload)
                .call()
                .content();
            Map<String, String> byId = parseIssueAiBatchReply(reply);
            for (Map<String, Object> d : need) {
                Object rawDid = d.get("deviceId");
                String idStr = rawDid == null ? "" : String.valueOf(rawDid).trim();
                String sum = byId.get(idStr);
                if (sum == null || sum.isBlank()) {
                    sum = ruleBasedCombinedSummary(d);
                }
                d.put("issueAiSummary", sum.trim());
            }
        } catch (Exception e) {
            logger.warn("设备上下文批量 AI 摘要失败，已改用本地综合压缩", e);
            for (Map<String, Object> d : need) {
                d.put("issueAiSummary", ruleBasedCombinedSummary(d));
            }
        }
    }

    private static boolean deviceNeedsCombinedSummary(Map<String, Object> d) {
        @SuppressWarnings("unchecked")
        List<String> issues = (List<String>) d.get("issues");
        if (issues != null && !issues.isEmpty()) {
            return true;
        }
        @SuppressWarnings("unchecked")
        List<String> pfs = (List<String>) d.get("pendingFaults");
        if (pfs != null && !pfs.isEmpty()) {
            return true;
        }
        Integer st = (Integer) d.get("status");
        if (st != null && st != 1) {
            return true;
        }
        Integer m = (Integer) d.get("maintenanceRequired");
        if (m != null && m == 1) {
            return true;
        }
        String fd = (String) d.get("faultDescription");
        return fd != null && !fd.isBlank();
    }

    private static String ruleBasedCombinedSummary(Map<String, Object> d) {
        List<String> parts = new ArrayList<>();
        Integer st = (Integer) d.get("status");
        if (st != null && st != 1) {
            String stt = (String) d.get("statusText");
            parts.add("状态" + (stt != null ? stt : "异常"));
        }
        Integer mr = (Integer) d.get("maintenanceRequired");
        if (mr != null && mr == 1) {
            parts.add("需维护");
        }
        String sfd = (String) d.get("faultDescription");
        if (sfd != null && !sfd.isBlank()) {
            parts.add(sfd.trim());
        }
        String code = (String) d.get("faultCode");
        if (code != null && !code.isBlank()) {
            parts.add("故障码" + code);
        }
        @SuppressWarnings("unchecked")
        List<String> pfs = (List<String>) d.get("pendingFaults");
        if (pfs != null) {
            for (String s : pfs) {
                if (s != null && !s.isBlank()) {
                    parts.add(s.trim());
                }
            }
        }
        @SuppressWarnings("unchecked")
        List<String> issues = (List<String>) d.get("issues");
        if (issues != null) {
            for (String s : issues) {
                if (s != null && !s.isBlank()) {
                    parts.add(s.trim());
                }
            }
        }
        if (parts.isEmpty()) {
            return "";
        }
        String j = String.join("；", parts);
        if (j.length() <= 120) {
            return j;
        }
        return j.substring(0, 117) + "…";
    }

    private static String faultLevelLabel(String level) {
        if (level == null) {
            return null;
        }
        switch (level) {
            case "1":
                return "紧急";
            case "2":
                return "严重";
            case "3":
                return "一般";
            case "4":
                return "轻微";
            default:
                return null;
        }
    }

    private static String formatStatusTime(Object ts) {
        if (!(ts instanceof Date)) {
            return null;
        }
        return STATUS_TIME_FMT.format(((Date) ts).toInstant());
    }

    private static String trimForAi(String s, int max) {
        if (s == null) {
            return "";
        }
        String t = s.trim();
        if (t.length() <= max) {
            return t;
        }
        return t.substring(0, max) + "…";
    }

    private static List<String> trimStringListForAi(List<String> list, int eachMax) {
        List<String> out = new ArrayList<>();
        if (list == null) {
            return out;
        }
        for (String s : list) {
            if (s == null) {
                continue;
            }
            String t = trimForAi(s, eachMax);
            if (!t.isEmpty()) {
                out.add(t);
            }
        }
        return out;
    }

    private static String buildDeviceContextPayloadForAi(List<Map<String, Object>> need) {
        List<Map<String, Object>> payload = new ArrayList<>();
        for (Map<String, Object> d : need) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("deviceId", d.get("deviceId"));
            item.put("deviceName", d.get("deviceName"));
            item.put("statusText", d.get("statusText"));
            item.put("priority", d.get("priority"));
            Integer mr = (Integer) d.get("maintenanceRequired");
            item.put("needMaintenance", mr != null && mr == 1);
            String hint = (String) d.get("faultDescription");
            item.put("statusFaultHint", hint != null ? trimForAi(hint, 500) : "");
            String fc = (String) d.get("faultCode");
            item.put("faultCode", fc != null ? trimForAi(fc, 80) : "");
            item.put("statusTime", formatStatusTime(d.get("timestamp")));
            @SuppressWarnings("unchecked")
            List<String> pfs = (List<String>) d.get("pendingFaults");
            item.put("pendingFaults", trimStringListForAi(pfs, 400));
            @SuppressWarnings("unchecked")
            List<String> issues = (List<String>) d.get("issues");
            item.put("alerts", trimStringListForAi(issues, 400));
            payload.add(item);
        }
        return JSON.toJSONString(payload);
    }

    private static Map<String, String> parseIssueAiBatchReply(String reply) {
        Map<String, String> out = new HashMap<>();
        if (reply == null) {
            return out;
        }
        String s = reply.trim();
        if (s.startsWith("```")) {
            int nl = s.indexOf('\n');
            if (nl > 0) {
                s = s.substring(nl + 1);
            }
            int fence = s.lastIndexOf("```");
            if (fence > 0) {
                s = s.substring(0, fence).trim();
            }
        }
        int lb = s.indexOf('[');
        int rb = s.lastIndexOf(']');
        if (lb < 0 || rb <= lb) {
            return out;
        }
        s = s.substring(lb, rb + 1);
        JSONArray arr = JSON.parseArray(s);
        for (int i = 0; i < arr.size(); i++) {
            JSONObject o = arr.getJSONObject(i);
            if (o == null) {
                continue;
            }
            Object rawId = o.get("deviceId");
            String id = rawId == null ? null : String.valueOf(rawId).trim();
            String summary = o.getString("summary");
            if (id != null && !id.isEmpty() && summary != null && !summary.isBlank()) {
                out.put(id, summary.trim());
            }
        }
        return out;
    }
}
