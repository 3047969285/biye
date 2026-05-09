package com.ruoyi.system.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

import java.util.Date;

/**
 * AI运维操作表单对象 ai_maintenance_form
 * 
 * @author wangchangzhen
 */
public class AiMaintenanceForm extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 表单ID */
    private Long formId;

    /** 设备ID */
    private String deviceId;

    /** 设备名称 */
    private String deviceName;

    /** 故障描述 */
    private String faultDescription;

    /** 维护类型 */
    private String maintenanceType;

    /** 优先级 */
    private String priorityLevel;

    /** 预计耗时（分钟） */
    private Integer estimatedTime;

    /** 所需工具（JSON格式） */
    private String requiredTools;

    /** 安全注意事项 */
    private String safetyPrecautions;

    /** 操作步骤（JSON格式） */
    private String stepByStepGuide;

    /** 预期结果 */
    private String expectedOutcome;

    /** 表单状态 */
    private String formStatus;

    /** 创建者 */
    private String createdBy;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createdTime;

    /** 更新者 */
    private String updatedBy;

    /** 更新时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updatedTime;

    // Getters and Setters
    public Long getFormId() { return formId; }
    public void setFormId(Long formId) { this.formId = formId; }

    public String getDeviceId() { return deviceId; }
    public void setDeviceId(String deviceId) { this.deviceId = deviceId; }

    public String getDeviceName() { return deviceName; }
    public void setDeviceName(String deviceName) { this.deviceName = deviceName; }

    public String getFaultDescription() { return faultDescription; }
    public void setFaultDescription(String faultDescription) { this.faultDescription = faultDescription; }

    public String getMaintenanceType() { return maintenanceType; }
    public void setMaintenanceType(String maintenanceType) { this.maintenanceType = maintenanceType; }

    public String getPriorityLevel() { return priorityLevel; }
    public void setPriorityLevel(String priorityLevel) { this.priorityLevel = priorityLevel; }

    public Integer getEstimatedTime() { return estimatedTime; }
    public void setEstimatedTime(Integer estimatedTime) { this.estimatedTime = estimatedTime; }

    public String getRequiredTools() { return requiredTools; }
    public void setRequiredTools(String requiredTools) { this.requiredTools = requiredTools; }

    public String getSafetyPrecautions() { return safetyPrecautions; }
    public void setSafetyPrecautions(String safetyPrecautions) { this.safetyPrecautions = safetyPrecautions; }

    public String getStepByStepGuide() { return stepByStepGuide; }
    public void setStepByStepGuide(String stepByStepGuide) { this.stepByStepGuide = stepByStepGuide; }

    public String getExpectedOutcome() { return expectedOutcome; }
    public void setExpectedOutcome(String expectedOutcome) { this.expectedOutcome = expectedOutcome; }

    public String getFormStatus() { return formStatus; }
    public void setFormStatus(String formStatus) { this.formStatus = formStatus; }

    public String getCreatedBy() { return createdBy; }
    public void setCreatedBy(String createdBy) { this.createdBy = createdBy; }

    public Date getCreatedTime() { return createdTime; }
    public void setCreatedTime(Date createdTime) { this.createdTime = createdTime; }

    public String getUpdatedBy() { return updatedBy; }
    public void setUpdatedBy(String updatedBy) { this.updatedBy = updatedBy; }

    public Date getUpdatedTime() { return updatedTime; }
    public void setUpdatedTime(Date updatedTime) { this.updatedTime = updatedTime; }
}
