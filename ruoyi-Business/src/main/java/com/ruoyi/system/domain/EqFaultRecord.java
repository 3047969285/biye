package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 故障记录  eq_fault_record
 *
 * @author wangchangzhen
 * @date 2025-12-19
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = false)
public class EqFaultRecord extends BaseEntity {
    private Long faultId;      //故障记录ID
    private String deviceId;     //设备ID
    
    /** 设备编号（关联查询） */
    private String deviceNo;
    
    /** 设备名称（关联查询） */
    private String deviceName;
    
    private String faultCode;      //故障代码
    private String faultDescription; //故障描述
    private String faultLevel;     //故障等级 1-紧急 2-严重 3-一般 4- 轻微
    private Date detectedTime;     //故障发现时间
    private Date resolvedTime;     //故障解决时间
    private String resolutionNotes; //解决措施
    private String rootCause;     //根本原因
    private Integer repairDuration;    //修复时长（分钟）
    private BigDecimal repairCost; //修复成本
    private String partsReplaced; //替换部件(JSON格式)
    private Integer status;      //状态 1-待处理 2-已经解决 3-处理中
    private String remark; //备注
}
