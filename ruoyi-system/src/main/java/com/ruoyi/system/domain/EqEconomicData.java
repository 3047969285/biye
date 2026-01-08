package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 经济数据  eq_economic_data
 *
 * @author wcz
 * @date 2025-12-19
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = false)
public class EqEconomicData extends BaseEntity {
    
    private static final long serialVersionUID = 1L;
    
    private Long economicId; //经济数据ID
    private Long deviceId; //设备ID
    private Date timestamp; //记录时间
    private BigDecimal maintainanceCost; //维护成本
    private BigDecimal energyConsumption; //能耗
    private BigDecimal laborCost; //人工成本
    private BigDecimal partCost; //配件成本
    private BigDecimal downtimeCost; //停机损失
    private BigDecimal roi; //投资回报率
    private BigDecimal npv; //净现值
    private BigDecimal paybackPeriod; //投资回收期
    private BigDecimal annualBudget; //年度预算
    private BigDecimal actualSpending; //实际支出
    private BigDecimal budgetUtilization;//预算利用率
    private Integer regulatoryImpact; //法规符合率
    private Integer environmentalImpact; //环境影响评级 1-优秀 2良好 3一般 4较差
}
