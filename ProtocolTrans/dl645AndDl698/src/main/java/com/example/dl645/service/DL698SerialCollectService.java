package com.example.dl645.service;

import java.util.Map;

/**
 * DL698 串口采集服务
 */
public interface DL698SerialCollectService {

    /**
     * 按点表批量读 OAD 并返回结果
     */
    Map<String, String> collectOadAndSave(String comPort,
                                          String meterAddress,
                                          int baudRate,
                                          int timeoutMs,
                                          Integer clientAddress,
                                          Map<String, String> pointMap);
}
