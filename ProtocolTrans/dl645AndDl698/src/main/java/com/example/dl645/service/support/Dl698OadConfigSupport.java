package com.example.dl645.service.support;

import com.example.dl645.entity.OadConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.properties.bind.Bindable;
import org.springframework.boot.context.properties.bind.Binder;
import org.springframework.core.env.Environment;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 从配置加载 DL698 OAD 点位映射（TCP/串口共用）
 *
 * @author wangchangzhen
 */
@Slf4j
public final class Dl698OadConfigSupport {

    private Dl698OadConfigSupport() {
    }

    public static Map<String, OadConfig> loadOadMap(Map<String, String> allOadConfigs) {
        Map<String, OadConfig> map = new LinkedHashMap<>();
        if (allOadConfigs == null || allOadConfigs.isEmpty()) {
            throw new RuntimeException("未配置DL698 OAD点位配置");
        }
        allOadConfigs.forEach((pointCode, oadHex) -> {
            try {
                byte[] oadBytes = Dl698BinarySupport.hexStringToByteArray(oadHex);
                map.put(pointCode, new OadConfig(pointCode, oadBytes));
                log.debug("加载OAD点位: {} -> {}", pointCode, oadHex);
            } catch (Exception e) {
                log.error("解析OAD配置失败: pointCode={}, oadHex={}, 错误: {}",
                        pointCode, oadHex, e.getMessage());
            }
        });
        log.info("成功加载{}个DL698 OAD点位配置", map.size());
        return Collections.unmodifiableMap(map);
    }
}
