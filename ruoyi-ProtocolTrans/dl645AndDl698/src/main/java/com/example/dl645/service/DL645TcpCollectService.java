package com.example.dl645.service;

import java.util.Map;

public interface DL645TcpCollectService {

    /**
     * 批量采集常用点位
     * @param ip              IP
     * @param port            端口
     * @param meterAddress    电表地址
     * @param timeoutMs       超时时间
     *
     * @return 点位编码-点位值
     */
    Map<String, String> collectCommonDiAndSave(String ip, Integer port, String meterAddress, Integer timeoutMs, Map<String, String> diMapping);
}

