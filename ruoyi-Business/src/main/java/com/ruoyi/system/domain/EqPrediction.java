package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 设备预测结果 eq_prediction（与库字段一致）
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = false)
public class EqPrediction extends BaseEntity {

    private Long predictionId;
    private String deviceId;

    /** 关联 eq_device */
    private String deviceNo;
    private String deviceName;

    private Date predictionTime;
    private Integer predictedStatus;
    private BigDecimal predictionConfidence;
    private Integer riskLevel;
    private Date expectedFailureTime;
    private String recommendedAction;
    private BigDecimal preventiveCost;
    private Integer actionTaken;
    private Date actionTakenDate;
    /** 对应库列 notes */
    private String notes;
}
