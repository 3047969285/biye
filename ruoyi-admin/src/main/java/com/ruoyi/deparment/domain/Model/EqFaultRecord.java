package com.ruoyi.deparment.domain.Model;

import aj.org.objectweb.asm.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.sql.Clob;
import java.util.Date;
import java.util.List;
/**
 * 故障记录  eq_fault_record
 *
 * @author wcz
 * @date 2025-12-19
 */

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EqFaultRecord extends BaseEntity {
    private Long faultId;      //故障记录ID
    private Long deviceId;     //设备ID
    private String faultCode;      //故障代码
    private Clob faultDescription; //故障描述
    private String faultLevel;     //故障等级 1-紧急 2-严重 3-一般 4- 轻微
    private Date detectedTime;     //故障发现时间
    private Date resolvedTime;     //故障解决时间
    private Clob resolutionNotes; //解决措施
    private String rootCause;     //根本原因
    private int repairDuration;    //修复时长（分钟）
    private BigDecimal repairCost; //修复成本
    private String partsReplaced; //替换部件
    private Integer status;      //状态 1-待处理 2-已经解决 3-处理中
    private String remark; //备注

}
