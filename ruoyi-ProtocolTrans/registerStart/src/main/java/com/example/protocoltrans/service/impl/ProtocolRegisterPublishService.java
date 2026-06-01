package com.example.protocoltrans.service.impl;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

/**
 * 日志映射和映射到寄存器（DL645 / DL698TCP和串口复用）
 *
 * @author wangchangzhen
 */
@Slf4j
@Service
public class ProtocolRegisterPublishService {
    @Autowired
    private DataCacheServiceImpl dataCacheService;

    /** DL645：日志与映射用语（TCP / 串口 集中配置） */
    public static final class Dl645LogProfile {
        public final String startLogFormat;
        public final String emptyWarnFormat;
        public final String bannerFormat;
        public final String bannerFooter;
        public final String failFormat;
        public final String successFormat;
        public final String errorFormat;

        private Dl645LogProfile(String startLogFormat, String emptyWarnFormat, String bannerFormat,
                                String bannerFooter, String failFormat, String successFormat, String errorFormat) {
            this.startLogFormat = startLogFormat;
            this.emptyWarnFormat = emptyWarnFormat;
            this.bannerFormat = bannerFormat;
            this.bannerFooter = bannerFooter;
            this.failFormat = failFormat;
            this.successFormat = successFormat;
            this.errorFormat = errorFormat;
        }

        static Dl645LogProfile tcp() {
            return new Dl645LogProfile(
                    "开始采集电表{} 数据 | IP: {} | 地址: {}",
                    "电表{} 采集数据为空",
                    "----- 电表{} DL645采集数据 -----",
                    "---------------------------------",
                    "电表{} 串口映射输入寄存器失败",
                    "电表{} 串口映射输入寄存器成功",
                    "电表{} 数据采集失败: {}");
        }

        static Dl645LogProfile serial() {
            return new Dl645LogProfile(
                    "开始采集电表{} 数据 | 串口: {} | 波特率: {} | 地址: {}",
                    "电表{} 串口采集数据为空",
                    "----- 电表{} 串口采集数据 -----",
                    "---------------------------------",
                    "电表{} 串口映射输入寄存器失败",
                    "电表{} 串口映射输入寄存器成功",
                    "电表{} 串口数据采集失败: {}");
        }
    }

    /** DL698：日志与映射用语 */
    public static final class Dl698LogProfile {
        public final String startLogFormat;
        public final String emptyWarnFormat;
        public final String bannerFormat;
        public final String bannerFooter;
        public final String failFormat;
        public final String successFormat;
        public final String errorFormat;

        private Dl698LogProfile(String startLogFormat, String emptyWarnFormat, String bannerFormat,
                                String bannerFooter, String failFormat, String successFormat, String errorFormat) {
            this.startLogFormat = startLogFormat;
            this.emptyWarnFormat = emptyWarnFormat;
            this.bannerFormat = bannerFormat;
            this.bannerFooter = bannerFooter;
            this.failFormat = failFormat;
            this.successFormat = successFormat;
            this.errorFormat = errorFormat;
        }

        static Dl698LogProfile tcp() {
            return new Dl698LogProfile(
                    "开始采集 DL698 电表{} 数据 | IP: {} | 地址: {}",
                    "DL698 电表{} 采集数据为空",
                    "----- DL698 电表{} TCP采集数据 -----",
                    "---------------------------------",
                    "DL698 电表{} TCP映射输入寄存器失败",
                    "DL698 电表{} TCP映射输入寄存器成功",
                    "DL698 电表{} 数据采集失败: {}");
        }

        static Dl698LogProfile serial() {
            return new Dl698LogProfile(
                    "开始采集 DL698 电表{} 数据 | 串口: {} | 波特率: {} | 地址: {}",
                    "DL698 电表{} 串口采集数据为空",
                    "----- DL698 电表{} 串口采集数据 -----",
                    "---------------------------------",
                    "DL698 电表{} 串口映射输入寄存器失败",
                    "DL698 电表{} 串口映射输入寄存器成功",
                    "DL698 电表{} 串口数据采集失败: {}");
        }
    }

    public static final class ModbusRtuLogProfile {
        public final String startLogFormat;
        public final String emptyWarnFormat;
        public final String bannerFormat;
        public final String bannerFooter;
        public final String failFormat;
        public final String successFormat;
        public final String errorFormat;

        private ModbusRtuLogProfile(String startLogFormat, String emptyWarnFormat, String bannerFormat,
                                    String bannerFooter, String failFormat, String successFormat, String errorFormat) {
            this.startLogFormat = startLogFormat;
            this.emptyWarnFormat = emptyWarnFormat;
            this.bannerFormat = bannerFormat;
            this.bannerFooter = bannerFooter;
            this.failFormat = failFormat;
            this.successFormat = successFormat;
            this.errorFormat = errorFormat;
        }

        static ModbusRtuLogProfile serial() {
            return new ModbusRtuLogProfile(
                    "开始采集 Modbus RTU 设备{} | 串口: {} | 波特率: {} | 从站: {}",
                    "Modbus RTU 设备{} 采集数据为空",
                    "----- Modbus RTU 设备{} 采集数据 -----",
                    "---------------------------------",
                    "Modbus RTU 设备{} 写入输入寄存器失败",
                    "Modbus RTU 设备{} 写入输入寄存器成功",
                    "Modbus RTU 设备{} 数据采集失败: {}");
        }
    }

    public static final Dl645LogProfile DL645_TCP = Dl645LogProfile.tcp();
    public static final Dl645LogProfile DL645_SERIAL = Dl645LogProfile.serial();
    public static final Dl698LogProfile DL698_TCP = Dl698LogProfile.tcp();
    public static final Dl698LogProfile DL698_SERIAL = Dl698LogProfile.serial();
    public static final ModbusRtuLogProfile MODBUS_RTU_SERIAL = ModbusRtuLogProfile.serial();

    public void publishDl645ToModbus(int meterIndex, Map<String, String> raw, Dl645LogProfile p) {
        log.info(p.bannerFormat, meterIndex + 1);
        raw.forEach((key, value) -> log.info("  {} = {}", key, value));
        log.info(p.bannerFooter);
        int result = dataCacheService.convertFromDL645(meterIndex, new HashMap<>(raw));
        if (result == 0) {
            log.error(p.failFormat, meterIndex + 1);
        } else {
            log.info(p.successFormat, meterIndex + 1);
        }
    }

    public void publishDl698ToModbus(int meterIndex, Map<String, String> raw, Dl698LogProfile p) {
        log.info(p.bannerFormat, meterIndex + 1);
        raw.forEach((key, value) -> log.info("  {} = {}", key, value));
        log.info(p.bannerFooter);
        int result = dataCacheService.convertFromDL698(meterIndex, new HashMap<>(raw));
        if (result == 0) {
            log.error(p.failFormat, meterIndex + 1);
        } else {
            log.info(p.successFormat, meterIndex + 1);
        }
    }


    public void publishModbusRtuToModbus(int meterIndex, short[] raw, ModbusRtuLogProfile modbusRtuSerial) {
        int result = dataCacheService.convertFromModbusRtu(meterIndex, raw);
        if (result == 0) {
            log.error(modbusRtuSerial.failFormat, meterIndex + 1);
        } else {
            log.info(modbusRtuSerial.successFormat, meterIndex + 1);
        }
    }
}
