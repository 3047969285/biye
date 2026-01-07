package com.ruoyi.system.service.impl;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.EqDevice;
import com.ruoyi.system.mapper.EqDeviceMapper;
import com.ruoyi.system.service.IEqDeviceService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 设备信息 Service业务层处理
 *
 * @author ruoyi
 * @date 2026-01-07
 */
@Service
public class EqDeviceServiceImpl implements IEqDeviceService {

    private static final Logger logger = LoggerFactory.getLogger(EqDeviceServiceImpl.class);

    @Autowired
    private EqDeviceMapper eqDeviceMapper;

    /**
     * 查询设备信息列表
     *
     * @param eqDevice 设备信息
     * @return 设备信息
     */
    @Override
    public List<EqDevice> selectEqDeviceList(EqDevice eqDevice) {
        return eqDeviceMapper.selectEqDeviceList(eqDevice);
    }

    /**
     * 查询设备信息
     *
     * @param deviceId 设备ID
     * @return 设备信息
     */
    @Override
    public EqDevice selectEqDeviceByDeviceId(Long deviceId) {
        return eqDeviceMapper.selectEqDeviceByDeviceId(deviceId);
    }

    /**
     * 根据设备编号查询设备
     *
     * @param deviceNo 设备编号
     * @return 设备信息
     */
    @Override
    public EqDevice selectEqDeviceByDeviceNo(String deviceNo) {
        return eqDeviceMapper.selectEqDeviceByDeviceNo(deviceNo);
    }

    /**
     * 新增设备信息
     *
     * @param eqDevice 设备信息
     * @return 结果
     */
    @Override
    @Transactional
    public int insertEqDevice(EqDevice eqDevice) {
        eqDevice.setCreateTime(DateUtils.getNowDate());
        eqDevice.setCreateBy(SecurityUtils.getUsername());
        
        // 默认状态为正常
        if (eqDevice.getStatus() == null) {
            eqDevice.setStatus(1);
        }
        
        int result = eqDeviceMapper.insertEqDevice(eqDevice);
        logger.info("新增设备：{}, ID: {}", eqDevice.getDeviceName(), eqDevice.getDeviceId());
        return result;
    }

    /**
     * 修改设备信息
     *
     * @param eqDevice 设备信息
     * @return 结果
     */
    @Override
    @Transactional
    public int updateEqDevice(EqDevice eqDevice) {
        eqDevice.setUpdateTime(DateUtils.getNowDate());
        eqDevice.setUpdateBy(SecurityUtils.getUsername());
        
        int result = eqDeviceMapper.updateEqDevice(eqDevice);
        logger.info("更新设备：{}, ID: {}", eqDevice.getDeviceName(), eqDevice.getDeviceId());
        return result;
    }

    /**
     * 更新设备状态（单个）
     *
     * @param deviceId 设备ID
     * @param status 状态 (1-正常, 2-停用, 3-维护, 4-报废)
     * @return 结果
     */
    @Override
    @Transactional
    public AjaxResult updateDeviceStatus(Long deviceId, Integer status) {
        // 验证状态值
        if (status == null || status < 1 || status > 4) {
            return AjaxResult.error("状态值无效，必须在 1-4 之间");
        }
        
        EqDevice device = eqDeviceMapper.selectEqDeviceByDeviceId(deviceId);
        if (device == null) {
            return AjaxResult.error("设备不存在");
        }
        
        // 记录状态变化
        Integer oldStatus = device.getStatus();
        int result = eqDeviceMapper.updateEqDeviceStatus(deviceId, status);
        
        if (result > 0) {
            String statusName = getStatusName(status);
            String oldStatusName = getStatusName(oldStatus);
            logger.info("设备 [{}] 状态已更新: {} -> {}", 
                device.getDeviceName(), oldStatusName, statusName);
            
            return AjaxResult.success("状态更新成功", Map.of(
                "deviceId", deviceId,
                "deviceName", device.getDeviceName(),
                "oldStatus", oldStatus,
                "newStatus", status,
                "statusName", statusName
            ));
        }
        
        return AjaxResult.error("状态更新失败");
    }

    /**
     * 批量更新设备状态
     *
     * @param deviceIds 设备ID数组
     * @param status 状态
     * @return 结果
     */
    @Override
    @Transactional
    public AjaxResult updateDeviceStatusBatch(Long[] deviceIds, Integer status) {
        if (deviceIds == null || deviceIds.length == 0) {
            return AjaxResult.error("请选择要更新的设备");
        }
        
        // 验证状态值
        if (status == null || status < 1 || status > 4) {
            return AjaxResult.error("状态值无效，必须在 1-4 之间");
        }
        
        int result = eqDeviceMapper.updateEqDeviceStatusBatch(deviceIds, status);
        
        if (result > 0) {
            String statusName = getStatusName(status);
            logger.info("批量更新 {} 个设备状态为: {}", result, statusName);
            return AjaxResult.success("已成功更新 " + result + " 个设备状态为：" + statusName, result);
        }
        
        return AjaxResult.error("批量状态更新失败");
    }

    /**
     * 批量删除设备信息
     *
     * @param deviceIds 需要删除的设备ID
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteEqDeviceByDeviceIds(Long[] deviceIds) {
        int result = eqDeviceMapper.deleteEqDeviceByDeviceIds(deviceIds);
        logger.info("批量删除 {} 个设备", result);
        return result;
    }

    /**
     * 删除设备信息
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteEqDeviceByDeviceId(Long deviceId) {
        EqDevice device = eqDeviceMapper.selectEqDeviceByDeviceId(deviceId);
        int result = eqDeviceMapper.deleteEqDeviceByDeviceId(deviceId);
        if (result > 0 && device != null) {
            logger.info("删除设备：{}, ID: {}", device.getDeviceName(), deviceId);
        }
        return result;
    }

    /**
     * 获取设备统计信息
     *
     * @return 统计结果
     */
    @Override
    public Map<String, Object> getDeviceStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        // 按状态统计
        List<Map<String, Object>> statusStats = eqDeviceMapper.countByStatus();
        Map<String, Object> statusMap = new HashMap<>();
        int total = 0;
        
        for (Map<String, Object> stat : statusStats) {
            Integer status = (Integer) stat.get("status");
            Long count = (Long) stat.get("count");
            statusMap.put(getStatusName(status), count);
            total += count.intValue();
        }
        
        stats.put("byStatus", statusMap);
        stats.put("total", total);
        
        // 按类型统计
        List<Map<String, Object>> typeStats = eqDeviceMapper.countByType();
        stats.put("byType", typeStats);
        
        return stats;
    }

    /**
     * 校验设备编号是否唯一
     *
     * @param deviceNo 设备编号
     * @return 结果
     */
    @Override
    public boolean checkDeviceNoUnique(String deviceNo) {
        EqDevice device = eqDeviceMapper.selectEqDeviceByDeviceNo(deviceNo);
        return device == null;
    }

    /**
     * 获取状态名称
     *
     * @param status 状态值
     * @return 状态名称
     */
    private String getStatusName(Integer status) {
        if (status == null) return "未知";
        switch (status) {
            case 1: return "正常";
            case 2: return "停用";
            case 3: return "维护中";
            case 4: return "已报废";
            default: return "未知";
        }
    }
}
