package com.example.dl645.service;

import java.util.Map;

public interface DL645SerialCollectService {

    /**
     * 批量采集常用点位（自定义超时）
     * @param comPort            端口号
     * @param meterAddress    电表地址
     * @param baudRate        波特率
     * @param timeoutMs        超时时间（毫秒）
     *
     * @return 点位编码-点位值
     */
    Map<String, String> collectCommonDiAndSave(String comPort, String meterAddress, int baudRate, int timeoutMs, Map<String, String> pointMapping);
}