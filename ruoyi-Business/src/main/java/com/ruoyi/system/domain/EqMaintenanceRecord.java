package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 维护记录对象 eq_maintenance_record
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = false)
public class EqMaintenanceRecord extends BaseEntity {
    
    private static final long serialVersionUID = 1L;

    /** 记录ID */
    private Long recordId;

    /** 设备ID */
    private String deviceId;

    /** 设备编号（关联查询） */
    private String deviceNo;

    /** 设备名称（关联查询） */
    private String deviceName;

    /** 维护类型 (1-预防性, 2-纠正性, 3-预测性) */
    private Integer maintenanceType;

    /** 维护日期 */
    private Date maintenanceDate;

    /** 下次维护日期 */
    private Date nextMaintenanceDate;

    /** 维护成本 */
    private BigDecimal maintenanceCost;

    /** 执行人员 */
    private String performedBy;

    /** 维护描述 */
    private String description;

    /** 替换部件 (JSON格式字符串) */
    private String partsReplaced;

    /** 技术员备注 */
    private String technicianNotes;

    /** 状态 (1-已完成, 2-安排中, 3-进行中, 4-已取消) */
    private Integer status;

    /** 备注 */
    private String remark;
}
