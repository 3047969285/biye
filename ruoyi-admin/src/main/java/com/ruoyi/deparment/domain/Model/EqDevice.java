package com.ruoyi.deparment.domain.Model;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 设备信息  eq_device_param
 *
 * @author wcz
 * @date 2025-12-19
 */


@Data
@NoArgsConstructor
@AllArgsConstructor

public class EqDevice extends BaseEntity {
    private Long deviceId;  //设备ID
    private String deviceNo; //设备编号
    private String deviceName;  //设备名称
    private String deviceType;  //设备类型
    private String model;       //设备型号
    private String serialNumber;  //序列号
    private String manufacturer;  //制造商
    private String location;      //安装位置
    private String department;    //所属部门
    private Date   installDate;   //安装日期
    private Date   warrantyExpiration; //保修到期日期
    private Integer status;      //设备状态 1正常 2停用 3维护 4报废
    private BigDecimal assetValue; //资产价值
    private Integer lifespanYears; //使用寿命（年）
    private String  responsiblePerson; //责任人
    private String  remarks;           //备注
}
