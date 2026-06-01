package com.example.protocoltrans.task;

import com.example.dl645.service.DL645SerialCollectService;
import com.example.dl645.service.DL645TcpCollectService;
import com.example.dl645.service.DL698SerialCollectService;
import com.example.dl645.service.DL698TcpCollectService;
import com.example.modbus.service.ModbusRtuCollectService;
import com.example.protocoltrans.config.MeterCollectionConfig;
import com.example.protocoltrans.service.impl.ProtocolRegisterPublishService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * 统一数据采集定时任务
 */
@Slf4j
@Component
@ConditionalOnProperty(prefix = "protocol-trans", name = "enabled", havingValue = "true")
public class DataCollectionTask {

    @Autowired
    private DL645TcpCollectService dl645TcpCollectService;

    @Autowired
    private DL645SerialCollectService dl645SerialCollectService;

    @Autowired
    private ModbusRtuCollectService modbusRtuCollectService;

    @Autowired
    private DL698TcpCollectService dl698TcpCollectService;

    @Autowired
    private DL698SerialCollectService dl698SerialCollectService;

    @Autowired
    private ProtocolRegisterPublishService registerPublish;

    @Autowired
    private MeterCollectionConfig meterConfig;

    /**
     * 定时采集电表数据
     */
    @Scheduled(cron = "${protocol-trans.collection.cron:0/30 * * * * ?}")
    public void collectMeterData() {
        List<MeterCollectionConfig.DeviceConfig> devices = meterConfig.getDevices() == null
            ? Collections.emptyList()
            : meterConfig.getDevices();
        log.debug("==========开始定时数据采集任务，共{}个电表==========", devices.size());
        if (devices.isEmpty()) {
            log.debug("未配置 protocol-trans.collection.devices，跳过本轮采集");
            return;
        }

        try {
            for (MeterCollectionConfig.DeviceConfig device : devices) {
                // 协议类型默认为 dl645
                String protocol = device.getProtocol() != null ? device.getProtocol().toLowerCase() : "dl645";

                if ("serial".equalsIgnoreCase(device.getType())) {
                    int meterIndex = device.getIndex();
                    if ("dl698".equals(protocol)) {
                        try {
                            log.info(ProtocolRegisterPublishService.DL698_SERIAL.startLogFormat,
                                    meterIndex + 1, device.getComPort(), device.getBaudRate(), device.getAddress());
                            Map<String, String> raw = dl698SerialCollectService.collectOadAndSave(device.getComPort(),
                                                                                                  device.getAddress(),
                                                                                                  device.getBaudRate(),
                                                                                                  device.getTimeout(),
                                                                                                  device.getClientAddress(),
                                                                                                  device.getOadMapping());
                            if (raw == null || raw.isEmpty()) {
                                log.error("{} 采集失败，请检查串口配置", device.getName());
                                continue;
                            }
                            registerPublish.publishDl698ToModbus(meterIndex, raw, ProtocolRegisterPublishService.DL698_SERIAL);
                        } catch (Exception e) {
                            log.error(ProtocolRegisterPublishService.DL698_SERIAL.errorFormat, meterIndex + 1, e.getMessage(), e);
                        }
                        log.debug("======={} 采集结束=======", device.getName());
                    } else if ("dl645".equals(protocol)) {
                        try {
                            log.info(ProtocolRegisterPublishService.DL645_SERIAL.startLogFormat,
                                    meterIndex + 1, device.getComPort(), device.getBaudRate(), device.getAddress());
                            Map<String, String> raw = dl645SerialCollectService.collectCommonDiAndSave(device.getComPort(),
                                                                                                       device.getAddress(),
                                                                                                       device.getBaudRate(),
                                                                                                       device.getTimeout(),
                                                                                                       device.getDiMapping());
                            if (raw == null || raw.isEmpty()) {
                                log.error("{} 采集失败，请检查串口配置", device.getName());
                                continue;
                            }
                            registerPublish.publishDl645ToModbus(meterIndex, raw, ProtocolRegisterPublishService.DL645_SERIAL);
                        } catch (Exception e) {
                            log.error(ProtocolRegisterPublishService.DL645_SERIAL.errorFormat, meterIndex + 1, e.getMessage(), e);
                        }
                        log.debug("======={} 采集结束=======", device.getName());
                    } else if ("modbus".equals(protocol)) {
                        try {
                            log.info(ProtocolRegisterPublishService.MODBUS_RTU_SERIAL.startLogFormat,
                                    meterIndex + 1, device.getComPort(), device.getBaudRate(), device.getAddress());
                            short[] raw = modbusRtuCollectService.collectCommonAddrAndSave(device.getComPort(),
                                                                                               device.getBaudRate(),
                                                                                               device.getAddress(),
                                                                                               device.getDataBits(),
                                                                                               device.getStopBits(),
                                                                                               device.getParity(),
                                                                                               device.getAddrMapping());
                            if (raw == null || raw.length == 0) {
                                log.error("{} 采集失败，请检查串口配置", device.getName());
                                continue;
                            }
                            registerPublish.publishModbusRtuToModbus(meterIndex, raw, ProtocolRegisterPublishService.MODBUS_RTU_SERIAL);
                        } catch (Exception e) {
                            log.error(ProtocolRegisterPublishService.MODBUS_RTU_SERIAL.errorFormat, meterIndex + 1, e.getMessage(), e);
                        }
                    } else {
                        log.error("{} 协议不支持，请检查串口配置", device.getName());
                    }
                } else if ("tcp".equalsIgnoreCase(device.getType())) {
                    int meterIndex = device.getIndex();
                    if ("dl698".equals(protocol)) {
                        try {
                            log.info(ProtocolRegisterPublishService.DL698_TCP.startLogFormat,
                                    meterIndex + 1, device.getIp(), device.getAddress());
                            Map<String, String> raw = dl698TcpCollectService.collectOadAndSave(
                                    device.getIp(),
                                    device.getPort(),
                                    device.getAddress(),
                                    device.getTimeout(),
                                    device.getClientAddress(),
                                    device.getOadMapping());
                            if (raw == null || raw.isEmpty()) {
                                log.error("{} 采集失败，请检查TCP配置", device.getName());
                                continue;
                            }
                            registerPublish.publishDl698ToModbus(meterIndex, raw, ProtocolRegisterPublishService.DL698_TCP);
                        } catch (Exception e) {
                            log.error(ProtocolRegisterPublishService.DL698_TCP.errorFormat, meterIndex + 1, e.getMessage(), e);
                        }
                        log.debug("======={} 采集结束=======", device.getName());
                    } else if ("dl645".equals(protocol)) {
                        try {
                            log.info(ProtocolRegisterPublishService.DL645_TCP.startLogFormat,
                                    meterIndex + 1, device.getIp(), device.getAddress());
                            Map<String, String> raw = dl645TcpCollectService.collectCommonDiAndSave(
                                    device.getIp(), device.getPort(), device.getAddress(), device.getTimeout(), device.getDiMapping());
                            if (raw == null || raw.isEmpty()) {
                                log.error("{} 采集失败，请检查TCP配置", device.getName());
                                continue;
                            }
                            registerPublish.publishDl645ToModbus(meterIndex, raw, ProtocolRegisterPublishService.DL645_TCP);
                        } catch (Exception e) {
                            log.error(ProtocolRegisterPublishService.DL645_TCP.errorFormat, meterIndex + 1, e.getMessage(), e);
                        }
                        log.debug("======={} 采集结束=======", device.getName());
                    } else {
                        log.error("{} 协议不支持，请检查TCP配置", device.getName());
                    }
                } else {
                    log.error("未知的连接类型: {} (电表: {})", device.getType(), device.getName());
                }
            }
        } catch (Exception e) {
            log.error("定时数据采集任务异常: {}", e.getMessage(), e);
        }
    }
}
