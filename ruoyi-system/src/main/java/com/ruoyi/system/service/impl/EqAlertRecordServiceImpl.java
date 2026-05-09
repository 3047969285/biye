package com.ruoyi.system.service.impl;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.EqAlertRecord;
import com.ruoyi.system.mapper.EqAlertRecordMapper;
import com.ruoyi.system.service.IEqAlertRecordService;

/**
 * 告警记录Service业务层处理
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Service
public class EqAlertRecordServiceImpl implements IEqAlertRecordService
{
    /** 与 sql/biye.sql 末尾 alert_type 回填逻辑一致：解析「规则[名称]」 */
    private static final Pattern RULE_NAME_FROM_MESSAGE = Pattern.compile("规则\\[([^\\]]+)\\]");

    @Autowired
    private EqAlertRecordMapper eqAlertRecordMapper;

    /**
     * 查询告警记录列表
     *
     * @param eqAlertRecord 告警记录
     * @return 告警记录集合
     */
    @Override
    public List<EqAlertRecord> selectEqAlertRecordList(EqAlertRecord eqAlertRecord)
    {
        List<EqAlertRecord> list = eqAlertRecordMapper.selectEqAlertRecordList(eqAlertRecord);
        fillAlertTypeIfBlank(list);
        return list;
    }

    /**
     * 根据告警记录ID查询告警记录
     *
     * @param alertId 告警记录ID
     * @return 告警记录
     */
    @Override
    public EqAlertRecord selectEqAlertRecordByAlertId(Long alertId)
    {
        EqAlertRecord row = eqAlertRecordMapper.selectEqAlertRecordByAlertId(alertId);
        fillAlertTypeIfBlank(row);
        return row;
    }

    /**
     * 根据设备ID查询告警记录列表
     *
     * @param deviceId 设备ID
     * @return 告警记录集合
     */
    @Override
    public List<EqAlertRecord> selectEqAlertRecordListByDeviceId(String deviceId)
    {
        List<EqAlertRecord> list = eqAlertRecordMapper.selectEqAlertRecordListByDeviceId(deviceId);
        fillAlertTypeIfBlank(list);
        return list;
    }

    private void fillAlertTypeIfBlank(List<EqAlertRecord> list)
    {
        if (list == null || list.isEmpty())
        {
            return;
        }
        for (EqAlertRecord row : list)
        {
            fillAlertTypeIfBlank(row);
        }
    }

    /** 库内为 Latin1 等错误编码时常见「????」或仅替换符，视为未填写并重新推断 */
    private static boolean isBlankOrGarbledAlertType(String alertType)
    {
        if (StringUtils.isEmpty(alertType))
        {
            return true;
        }
        String t = alertType.trim();
        return t.chars().allMatch(ch -> ch == '?' || ch == '\uFFFD');
    }

    private void fillAlertTypeIfBlank(EqAlertRecord row)
    {
        if (row == null || !isBlankOrGarbledAlertType(row.getAlertType()))
        {
            return;
        }
        row.setAlertType(null);
        String msg = row.getAlertMessage();
        if (StringUtils.isNotEmpty(msg))
        {
            Matcher m = RULE_NAME_FROM_MESSAGE.matcher(msg);
            if (m.find())
            {
                String name = m.group(1).trim();
                if (StringUtils.isNotEmpty(name))
                {
                    row.setAlertType(name);
                    return;
                }
            }
        }
        if (row.getRuleId() != null
            || (row.getRemark() != null && row.getRemark().contains("规则引擎")))
        {
            row.setAlertType("规则告警");
            return;
        }
        row.setAlertType("手工录入");
    }

    /**
     * 新增告警记录
     *
     * @param eqAlertRecord 告警记录
     * @return 结果
     */
    @Override
    public int insertEqAlertRecord(EqAlertRecord eqAlertRecord)
    {
        return eqAlertRecordMapper.insertEqAlertRecord(eqAlertRecord);
    }

    /**
     * 修改告警记录
     *
     * @param eqAlertRecord 告警记录
     * @return 结果
     */
    @Override
    public int updateEqAlertRecord(EqAlertRecord eqAlertRecord)
    {
        return eqAlertRecordMapper.updateEqAlertRecord(eqAlertRecord);
    }

    /**
     * 批量删除告警记录
     *
     * @param alertIds 需要删除的告警记录主键
     * @return 结果
     */
    @Override
    public int deleteEqAlertRecordByAlertIds(Long[] alertIds)
    {
        return eqAlertRecordMapper.deleteEqAlertRecordByAlertIds(alertIds);
    }

    /**
     * 删除告警记录信息
     *
     * @param alertId 告警记录主键
     * @return 结果
     */
    @Override
    public int deleteEqAlertRecordByAlertId(Long alertId)
    {
        return eqAlertRecordMapper.deleteEqAlertRecordByAlertId(alertId);
    }

    /**
     * 根据设备ID删除告警记录
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    @Override
    public int deleteEqAlertRecordByDeviceId(String deviceId)
    {
        return eqAlertRecordMapper.deleteEqAlertRecordByDeviceId(deviceId);
    }

    /**
     * 批量根据设备ID删除告警记录
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    @Override
    public int deleteEqAlertRecordByDeviceIds(String[] deviceIds)
    {
        return eqAlertRecordMapper.deleteEqAlertRecordByDeviceIds(deviceIds);
    }
}
