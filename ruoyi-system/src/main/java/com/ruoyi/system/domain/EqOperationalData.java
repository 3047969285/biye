package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 设备操作数据 eq_operational_data
 *
 * @author wcz
 * @date 2025-12-19
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = false)
public class EqOperationalData extends BaseEntity {
    
    private static final long serialVersionUID = 1L;
    
    private Long operationalId; //操作数据ID
    private Long deviceId;      //设备ID
    private Date timestamp;     //操作时间
    private Long operatorId;    //操作员ID
    private String operatorName; //操作员名称
    private Integer operatorSkillLevel;//操作员技能等级1-初级2-中级3-高级4-专家
    private Integer trainingCompletion; //培训完成度(%)
    private Integer operationType; //操作类型1-开机2-关机3-调试4-维护5故障处理
    private Integer operationDuration; //操作时长(秒)
    private String operationResult; //操作结果1-成功2-失败3-警告
    private String operationNotes;  //操作备注
    private Integer maintainanceType; //维护类型1-预防性2纠正性3-预测性4-紧急
    private Integer maintainanceDuration; //维护时长(秒)
    private BigDecimal maintainanceCost; //维护成本
    private String partsUsed; //使用的部件
    private BigDecimal operatorPerformanceScore; //操作员绩效评分
    private Integer safetyCompliance; //安全合规度
}
