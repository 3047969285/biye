package com.example.dl645.service;

import java.util.Map;

public interface DL698TcpCollectService {

    /**
     * 按点表批量读 OAD 并入库
     */
    Map<String, String> collectOadAndSave(String ip, Integer port, String meterAddress, Integer timeoutMs, Integer clientAddress, Map<String, String> oadMapping);
}
