package com.example.dl645.service.impl;

import com.example.dl645.core.DL645Protocol;
import com.example.dl645.core.ResponseListener;
import com.example.dl645.entity.DiConfig;
import com.example.dl645.service.DL645TcpCollectService;
import com.example.dl645.service.support.Dl645CollectSupport;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;

/**
 * DL645 TCP获取电表数据
 *
 * @author wangchangzhen
 */
@Slf4j
@Service
public class DL645TcpCollectServiceImpl implements DL645TcpCollectService {

    private static final int DEFAULT_TIMEOUT_MS = 300;
    private static final int QUERY_RETRY_TIMES = 2;
    private static final int COMMAND_INTERVAL_MS = 120;
    private static final Pattern METER_ADDRESS_PATTERN = Pattern.compile("^[0-9a-fA-F]{12}$");

    private Map<String, DiConfig> getCommonDiMap(Map<String, String> allDiConfigs) {
        Map<String, DiConfig> map = new LinkedHashMap<>();
        if (allDiConfigs == null || allDiConfigs.isEmpty()) {
            throw new RuntimeException("未配置DL645 DI点位配置");
        }
        allDiConfigs.forEach((pointCode, diHex) -> {
            try {
                byte[] diBytes = Dl645CollectSupport.hexStringToByteArray(diHex);
                map.put(pointCode, new DiConfig(pointCode, diBytes));
            } catch (Exception e) {
                log.error("解析DI配置失败: pointCode={}, diHex={}, 错误: {}",
                        pointCode, diHex, e.getMessage());
            }
        });
        if (map.size() != allDiConfigs.size()) {
            log.error("DL645 TCP DI 部分条目解析失败: 配置{}条, 成功{}条 | keys={}",
                    allDiConfigs.size(), map.size(), map.keySet());
        }
        log.info("成功加载{}个DL645 TCP DI点位配置", map.size());
        return Collections.unmodifiableMap(map);
    }

    @Override
    public Map<String, String> collectCommonDiAndSave(String ip, Integer port, String meterAddress, Integer timeoutMs, Map<String, String> pointMapping) {
        int finalPort = port == null ? 0 : port;
        int finalTimeout = (timeoutMs == null || timeoutMs <= 0) ? DEFAULT_TIMEOUT_MS : timeoutMs;
        validateParam(ip, finalPort, meterAddress);
        String normalizedMeterAddress = meterAddress.trim().toUpperCase();

        Map<String, String> result = new LinkedHashMap<>();
        LinkedBlockingQueue<byte[]> responseQueue = new LinkedBlockingQueue<>(8);
        DL645Protocol protocol = new DL645Protocol();
        protocol.setResponseListener(new ResponseListener() {
            @Override
            public void onResponseReceived(byte[] response) {
                responseQueue.offer(response);
            }

            @Override
            public void onError(String errorMessage) {
                log.error("TCP监听错误: {}", errorMessage);
            }

            @Override
            public void onPortOpened(String portName) {
                log.info("TCP通道已打开: {}", portName);
            }

            @Override
            public void onPortClosed(String portName) {
                log.info("TCP通道已关闭: {}", portName);
            }

            @Override
            public void onDataAvailable(byte[] data) {
            }
        });

        try {
            if (!protocol.connectTcp(ip, finalPort, finalTimeout, normalizedMeterAddress)) {
                throw new RuntimeException("TCP连接失败");
            }
            Map<String, DiConfig> commonDiMap = getCommonDiMap(pointMapping);
            for (Map.Entry<String, DiConfig> entry : commonDiMap.entrySet()) {
                String pointCode = entry.getKey();
                DiConfig config = entry.getValue();
                byte[] frame = queryWithRetry(protocol, responseQueue, config.getDi(), pointCode, finalTimeout);
                if (frame == null) {
                    log.error("TCP查询失败: pointCode={}, di={}", pointCode, Dl645CollectSupport.bytesToHex(config.getDi()));
                    result.put(pointCode, "");
                    continue;
                }
                String decoded = Dl645CollectSupport.decodePointValue(frame, config.getDi());
                result.put(pointCode, decoded);
                Dl645CollectSupport.sleepQuietly(COMMAND_INTERVAL_MS);
            }
        } catch (Exception e) {
            log.error("批量采集失败: {}", e.getMessage());
//            Map<String, DiConfig> commonDiMap = getCommonDiMap();
//            for (String key : commonDiMap.keySet()) {
//                result.putIfAbsent(key, "");
//            }
        } finally {
            protocol.disconnectTcp();
        }
        return result;
    }

    private byte[] queryWithRetry(DL645Protocol protocol,
                                LinkedBlockingQueue<byte[]> responseQueue,
                                byte[] di,
                                String pointCode,
                                int timeoutMs) throws InterruptedException {
        for (int i = 0; i <= QUERY_RETRY_TIMES; i++) {
            responseQueue.clear();
            protocol.sendCommandTcp(di);
            byte[] frame = responseQueue.poll(timeoutMs, TimeUnit.MILLISECONDS);
            if (frame != null && Dl645CollectSupport.frameMatchesExpectedDi(frame, di)) {
                return frame;
            }
            if (frame != null) {
                log.error("点位{} 收到非目标DI响应，继续重试", pointCode);
            } else if (i < QUERY_RETRY_TIMES) {
                log.error("点位{} 第{}次超时，准备重试", pointCode, i + 1);
            }
            if (i < QUERY_RETRY_TIMES) {
                Dl645CollectSupport.sleepQuietly(COMMAND_INTERVAL_MS);
            }
        }
        return null;
    }

    private void validateParam(String ip, int port, String meterAddress) {
        if (ip == null || ip.trim().isEmpty()) {
            throw new IllegalArgumentException("IP不能为空");
        }
        if (port <= 0 || port > 65535) {
            throw new IllegalArgumentException("端口非法");
        }
        if (meterAddress == null || !METER_ADDRESS_PATTERN.matcher(meterAddress.trim()).matches()) {
            throw new IllegalArgumentException("电表地址格式错误");
        }
    }
}
