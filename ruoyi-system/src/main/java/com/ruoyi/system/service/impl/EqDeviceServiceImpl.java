package com.ruoyi.system.service.impl;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.EqDevice;
import com.ruoyi.system.mapper.*;
import com.ruoyi.system.service.IEqDeviceService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class EqDeviceServiceImpl implements IEqDeviceService {

    private static final Logger logger = LoggerFactory.getLogger(EqDeviceServiceImpl.class);

    @Autowired
    private EqDeviceMapper eqDeviceMapper;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private EqDeviceStatusMapper eqDeviceStatusMapper;
    @Autowired
    private EqDeviceParamMapper eqDeviceParamMapper;
    @Autowired
    private EqMaintenanceRecordMapper eqMaintenanceRecordMapper;
    @Autowired
    private EqAlertRecordMapper eqAlertRecordMapper;
    @Autowired
    private EqEnvironmentDataMapper eqEnvironmentDataMapper;
    @Autowired
    private EqEconomicDataMapper eqEconomicDataMapper;
    @Autowired
    private EqElectricalDataMapper eqElectricalDataMapper;
    @Autowired
    private EqTechnologyDataMapper eqTechnologyDataMapper;
    @Autowired
    private EqSensorMapper eqSensorMapper;
    @Autowired
    private EqDeviceStatMapper eqDeviceStatMapper;
    @Autowired
    private EqOperationalDataMapper eqOperationalDataMapper;
    @Autowired
    private EqMechanicalDataMapper eqMechanicalDataMapper;
    @Autowired
    private EqFaultRecordMapper eqFaultRecordMapper;
    @Autowired
    private EqClimateDataMapper eqClimateDataMapper;
    @Autowired
    private EqDeviceRuleMapper eqDeviceRuleMapper;

    @Override
    public List<EqDevice> selectEqDeviceList(EqDevice eqDevice) {
        return eqDeviceMapper.selectEqDeviceList(eqDevice);
    }

    @Override
    public EqDevice selectEqDeviceByDeviceId(Long deviceId) {
        return eqDeviceMapper.selectEqDeviceByDeviceId(deviceId);
    }

    @Override
    public EqDevice selectEqDeviceByDeviceNo(String deviceNo) {
        return eqDeviceMapper.selectEqDeviceByDeviceNo(deviceNo);
    }

    @Override
    @Transactional
    public int insertEqDevice(EqDevice eqDevice) {
        eqDevice.setCreateTime(DateUtils.getNowDate());
        eqDevice.setCreateBy(SecurityUtils.getUsername());

        if (eqDevice.getStatus() == null) {
            eqDevice.setStatus(1);
        }

        int result = eqDeviceMapper.insertEqDevice(eqDevice);
        logger.info("新增设备：{}, ID: {}", eqDevice.getDeviceName(), eqDevice.getDeviceId());
        return result;
    }

    @Override
    @Transactional
    public int updateEqDevice(EqDevice eqDevice) {
        eqDevice.setUpdateTime(DateUtils.getNowDate());
        eqDevice.setUpdateBy(SecurityUtils.getUsername());

        int result = eqDeviceMapper.updateEqDevice(eqDevice);
        logger.info("更新设备：{}, ID: {}", eqDevice.getDeviceName(), eqDevice.getDeviceId());
        return result;
    }

    @Override
    @Transactional
    public AjaxResult updateDeviceStatus(Long deviceId, Integer status) {
        if (status == null || status < 1 || status > 4) {
            return AjaxResult.error("状态值无效，必须在 1-4 之间");
        }

        EqDevice device = eqDeviceMapper.selectEqDeviceByDeviceId(deviceId);
        if (device == null) {
            return AjaxResult.error("设备不存在");
        }

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

    @Override
    @Transactional
    public AjaxResult updateDeviceStatusBatch(Long[] deviceIds, Integer status) {
        if (deviceIds == null || deviceIds.length == 0) {
            return AjaxResult.error("请选择要更新的设备");
        }

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

    @Override
    @Transactional
    public int deleteEqDeviceByDeviceIds(Long[] deviceIds) {
        eqDeviceStatusMapper.deleteEqDeviceStatusByDeviceIds(deviceIds);
        eqDeviceParamMapper.deleteEqDeviceParamByDeviceIds(deviceIds);
        eqMaintenanceRecordMapper.deleteEqMaintenanceRecordByDeviceIds(deviceIds);
        eqAlertRecordMapper.deleteEqAlertRecordByDeviceIds(deviceIds);
        eqEnvironmentDataMapper.deleteEqEnvironmentDataByDeviceIds(deviceIds);
        eqEconomicDataMapper.deleteEqEconomicDataByDeviceIds(deviceIds);
        eqElectricalDataMapper.deleteEqElectricalDataByDeviceIds(deviceIds);
        eqTechnologyDataMapper.deleteEqTechnologyDataByDeviceIds(deviceIds);
        eqSensorMapper.deleteEqSensorByDeviceIds(deviceIds);
        eqDeviceStatMapper.deleteEqDeviceStatByDeviceIds(deviceIds);
        eqOperationalDataMapper.deleteEqOperationalDataByDeviceIds(deviceIds);
        eqMechanicalDataMapper.deleteEqMechanicalDataByDeviceIds(deviceIds);
        eqFaultRecordMapper.deleteEqFaultRecordByDeviceIds(deviceIds);
        eqClimateDataMapper.deleteEqClimateDataByDeviceIds(deviceIds);
        eqDeviceRuleMapper.deleteEqDeviceRuleByDeviceIds(deviceIds);

        int result = eqDeviceMapper.deleteEqDeviceByDeviceIds(deviceIds);
        logger.info("批量删除 {} 个设备及其所有关联数据", result);
        return result;
    }

    @Override
    @Transactional
    public int deleteEqDeviceByDeviceId(Long deviceId) {
        EqDevice device = eqDeviceMapper.selectEqDeviceByDeviceId(deviceId);
        if (device == null) {
            return 0;
        }

        eqDeviceStatusMapper.deleteEqDeviceStatusByDeviceId(deviceId);
        eqDeviceParamMapper.deleteEqDeviceParamByDeviceId(deviceId);
        eqMaintenanceRecordMapper.deleteEqMaintenanceRecordByDeviceId(deviceId);
        eqAlertRecordMapper.deleteEqAlertRecordByDeviceId(deviceId);
        eqEnvironmentDataMapper.deleteEqEnvironmentDataByDeviceId(deviceId);
        eqEconomicDataMapper.deleteEqEconomicDataByDeviceId(deviceId);
        eqElectricalDataMapper.deleteEqElectricalDataByDeviceId(deviceId);
        eqTechnologyDataMapper.deleteEqTechnologyDataByDeviceId(deviceId);
        eqSensorMapper.deleteEqSensorByDeviceId(deviceId);
        eqDeviceStatMapper.deleteEqDeviceStatByDeviceId(deviceId);
        eqOperationalDataMapper.deleteEqOperationalDataByDeviceId(deviceId);
        eqMechanicalDataMapper.deleteEqMechanicalDataByDeviceId(deviceId);
        eqFaultRecordMapper.deleteEqFaultRecordByDeviceId(deviceId);
        eqClimateDataMapper.deleteEqClimateDataByDeviceId(deviceId);
        eqDeviceRuleMapper.deleteEqDeviceRuleByDeviceId(deviceId);

        int result = eqDeviceMapper.deleteEqDeviceByDeviceId(deviceId);
        if (result > 0) {
            logger.info("删除设备：{}, ID: {}，已级联删除所有关联数据", device.getDeviceName(), deviceId);
        }
        return result;
    }

    @Override
    public Map<String, Object> getDeviceStatistics() {
        Map<String, Object> stats = new HashMap<>();

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

        List<Map<String, Object>> typeStats = eqDeviceMapper.countByType();
        stats.put("byType", typeStats);

        return stats;
    }

    @Override
    public boolean checkDeviceNoUnique(String deviceNo) {
        EqDevice device = eqDeviceMapper.selectEqDeviceByDeviceNo(deviceNo);
        return device == null;
    }

    @Override
    public Map<String, Object> getDeviceDashboardData() {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> deviceDataList = new ArrayList<>();

        try {
            List<EqDevice> devices = eqDeviceMapper.selectEqDeviceList(new EqDevice());
            devices.sort((a, b) -> {
                Long id1 = a.getDeviceId();
                Long id2 = b.getDeviceId();
                if (id1 == null) return 1;
                if (id2 == null) return -1;
                return id1.compareTo(id2);
            });

            String[] tables = {
                "eq_device_status", "eq_device_param", "eq_device_stat",
                "eq_maintenance_record", "eq_alert_record", "eq_environment_data",
                "eq_economic_data", "eq_electrical_data", "eq_technology_data",
                "eq_mechanical_data", "eq_operational_data", "eq_sensor",
                "eq_climate_data", "eq_fault_record", "eq_device_rule"
            };

            for (EqDevice device : devices) {
                Map<String, Object> deviceData = new HashMap<>();
                deviceData.put("deviceId", device.getDeviceId());
                deviceData.put("deviceNo", device.getDeviceNo());
                deviceData.put("deviceName", device.getDeviceName());
                deviceData.put("deviceType", device.getDeviceType());
                deviceData.put("location", device.getLocation());
                deviceData.put("status", device.getStatus());
                deviceData.put("statusName", getStatusName(device.getStatus()));

                Map<String, Integer> tableCounts = new HashMap<>();
                int totalCount = 0;

                for (String table : tables) {
                    try {
                        Integer count = jdbcTemplate.queryForObject(
                            "SELECT COUNT(*) FROM " + table + " WHERE device_id = ?",
                            Integer.class, device.getDeviceId());
                        if (count != null) {
                            tableCounts.put(table, count);
                            totalCount += count;
                        }
                    } catch (Exception e) {
                        logger.debug("查询表 {} 失败: {}", table, e.getMessage());
                        tableCounts.put(table, 0);
                    }
                }

                deviceData.put("tableCounts", tableCounts);
                deviceData.put("totalCount", totalCount);
                deviceDataList.add(deviceData);
            }

            result.put("devices", deviceDataList);
            result.put("total", deviceDataList.size());
            result.put("tables", tables);

        } catch (Exception e) {
            logger.error("获取设备仪表板数据失败: ", e);
            result.put("error", e.getMessage());
        }

        return result;
    }

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
