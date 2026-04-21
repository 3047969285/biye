package com.ruoyi.web.meter.dl645;

import com.ruoyi.common.utils.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;
import org.yaml.snakeyaml.Yaml;

import jakarta.annotation.PostConstruct;
import java.io.InputStream;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@Component
public class Dl645DiConfigService {

    private static final Logger log = LoggerFactory.getLogger(Dl645DiConfigService.class);

    private final Map<String, Dl645DiItem> byDi = new HashMap<>();

    @PostConstruct
    public void init() {
        try {
            ClassPathResource res = new ClassPathResource("meter/protocol-di.yml");
            InputStream in = res.getInputStream();
            Map<String, Object> root = new Yaml().load(in);
            byDi.clear();
            Map<String, Object> protocol = asMap(root == null ? null : root.get("protocol"));
            Map<String, Object> dl645 = asMap(protocol.get("dl645"));
            Map<String, Object> diMap = asMap(dl645.get("di"));
            for (Map.Entry<String, Object> e : diMap.entrySet()) {
                String pointCode = e.getKey();
                Object raw = e.getValue();
                if (StringUtils.isEmpty(pointCode) || raw == null) {
                    continue;
                }
                Dl645DiItem item = new Dl645DiItem();
                item.setPointCode(pointCode.trim());
                if (raw instanceof String) {
                    // 简写：50001: "00010000"
                    item.setDi(normDi(String.valueOf(raw)));
                    item.setPointName(pointCode.trim());
                    item.setScale(1D);
                    item.setDecimals(2);
                } else {
                    Map<String, Object> cfg = asMap(raw);
                    item.setDi(normDi(String.valueOf(cfg.get("di"))));
                    String pointName = cfg.get("pointName") == null ? null : String.valueOf(cfg.get("pointName"));
                    String unit = cfg.get("unit") == null ? null : String.valueOf(cfg.get("unit"));
                    Integer decimals = toInt(cfg.get("decimals"), 2);
                    Double scale = toDouble(cfg.get("scale"), 1D);
                    item.setPointName(StringUtils.isEmpty(pointName) ? pointCode.trim() : pointName);
                    item.setUnit(unit);
                    item.setDecimals(decimals);
                    item.setScale(scale);
                }
                if (StringUtils.isEmpty(item.getDi())) {
                    continue;
                }
                byDi.put(item.getDi(), item);
            }
            log.info("DL645 DI 映射加载完成，数量={}", byDi.size());
        } catch (Exception e) {
            log.error("加载 DL645 DI 映射失败", e);
            byDi.clear();
        }
    }

    public Dl645DiItem getByDi(String di) {
        return byDi.get(normDi(di));
    }

    public Map<String, Dl645DiItem> snapshot() {
        return Collections.unmodifiableMap(byDi);
    }

    private String normDi(String di) {
        return di == null ? "" : di.trim().toUpperCase();
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> asMap(Object obj) {
        if (obj instanceof Map) {
            return (Map<String, Object>) obj;
        }
        return Collections.emptyMap();
    }

    private Integer toInt(Object obj, int defaultValue) {
        if (obj == null) {
            return defaultValue;
        }
        if (obj instanceof Number) {
            return ((Number) obj).intValue();
        }
        try {
            return Integer.parseInt(String.valueOf(obj).trim());
        } catch (Exception ignored) {
            return defaultValue;
        }
    }

    private Double toDouble(Object obj, double defaultValue) {
        if (obj == null) {
            return defaultValue;
        }
        if (obj instanceof Number) {
            return ((Number) obj).doubleValue();
        }
        try {
            return Double.parseDouble(String.valueOf(obj).trim());
        } catch (Exception ignored) {
            return defaultValue;
        }
    }
}
