package com.example.protocoltrans.service;

import java.util.Map;

/**
 * 数据缓存服务
 */
public interface DataCacheService {

    /**
     * 获取保持寄存器数组
     * @return 寄存器数组
     */
    short[] getRegisterArray();
}
