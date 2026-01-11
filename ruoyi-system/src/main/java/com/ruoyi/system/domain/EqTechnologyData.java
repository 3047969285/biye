package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 设备技术数据 eq_technology_data
 *
 * @author wcz
 * @date 2025-12-19
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = false)
public class EqTechnologyData extends BaseEntity {
    private Long techId; //技术数据ID
    private Long deviceId; //设备ID
    
    /** 设备编号（关联查询） */
    private String deviceNo;
    
    /** 设备名称（关联查询） */
    private String deviceName;
    
    private Date timestamp; //更新时间
    private Integer technologyLevel; //技术等级 1-落后 2-一般 3-先进 4-领先
    private Integer upgradeStatus; //升级状态
    private String standardCompliance; //标准符合情况(JSON格式)
    private Integer certificationStatus; //认证状态 1-有效 2-过期 3-待审核
    private String softwareVersion; //软件版本
    private String firmwareVersion; //固件版本
    private Integer systemUpdates; //系统更新次数
    private Integer digitalizationLevel; //数字化等级 1-低 2-中 3-高 4-超高
    private Integer connectivityLevel; //连接水平1-无连接2-基础连接3-智能连接4-全连接
    private Integer technologyMaturity; //技术成熟度1-试验2-试用3-推广4-成熟
    private Integer obsolescenceRisk; //淘汰风险1-低2-中3-高4-极高
}
