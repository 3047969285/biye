package com.ruoyi.deparment.domain.Model;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.sql.Clob;
import java.util.Date;
/**
 * 维护记录  eq_maintenance_record
 *
 * @author wcz
 * @date 2025-12-19
 */

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EqMaintenanceRecord extends BaseEntity {
    private long recordId; //记录ID
    private long deviceId; //设备ID
    private Integer maintenanceType; //维护类型 1-预防性 2-纠正性 3-预测性
    private Date maintenanceTime; //维护时间
    private Date nextMaintenanceTime; //下次维护时间
    private BigDecimal maintenanceCost; //维护成本
    private String performedBy; //执行人员
    private Clob description;  //维护描述
    private String partsReplaced; //替换部件
    private Clob technicianNotes; //技术员备注
    private Integer status; //状态 1-已完成 2-安排中 3-进行中 4已取消
    private Clob remark; //备注
}
