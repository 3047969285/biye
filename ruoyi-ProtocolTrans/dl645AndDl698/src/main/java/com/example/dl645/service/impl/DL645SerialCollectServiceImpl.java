package com.example.dl645.service.impl;

import com.example.dl645.core.DL645Protocol;
import com.example.dl645.core.ResponseListener;
import com.example.dl645.entity.DiConfig;
import com.example.dl645.service.DL645SerialCollectService;
import com.example.dl645.service.support.Dl645CollectSupport;
import com.example.dl645.untils.ByteUntil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;

/**
 * DL645 串口采集电表数据
 *
 * @author wangchangzhen
 */
@Slf4j
@Service
public class DL645SerialCollectServiceImpl implements DL645SerialCollectService {

    private static final int DEFAULT_TIMEOUT_MS = 300;
    private static final int QUERY_RETRY_TIMES = 2;
    private static final int COMMAND_INTERVAL_MS = 120;

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
        log.info("成功加载{}个DL645 DI点位配置", map.size());
        return Collections.unmodifiableMap(map);
    }

    @Override
    public Map<String, String> collectCommonDiAndSave(String comPort, String meterAddress, int baudRate, int timeoutMs, Map<String, String> pointMapping) {
        if (comPort == null || comPort.trim().isEmpty()) {
            throw new IllegalArgumentException("串口端口不能为空");
        }
        if (meterAddress == null || !meterAddress.trim().matches("^[0-9a-fA-F]{12}$")) {
            throw new IllegalArgumentException("电表地址格式错误（需12位十六进制）");
        }
        if (baudRate <= 0) {
            throw new IllegalArgumentException("波特率非法");
        }

        String normalizedAddress = meterAddress.trim().toUpperCase();
        int finalTimeout = timeoutMs > 0 ? timeoutMs : DEFAULT_TIMEOUT_MS;

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
                log.error("串口监听错误: {}", errorMessage);
            }

            @Override
            public void onPortOpened(String portName) {
                log.info("串口已打开: {}", portName);
            }

            @Override
            public void onPortClosed(String portName) {
                log.info("串口已关闭: {}", portName);
            }

            @Override
            public void onDataAvailable(byte[] data) {
                log.debug("串口原始接收: {}", ByteUntil.bytesToHex(data));
            }
        });

        try {
            if (!protocol.connect(comPort, baudRate, normalizedAddress)) {
                throw new RuntimeException("串口连接失败: " + comPort);
            }

            Map<String, DiConfig> commonDiMap = getCommonDiMap(pointMapping);
            for (Map.Entry<String, DiConfig> entry : commonDiMap.entrySet()) {
                String pointCode = entry.getKey();
                DiConfig config = entry.getValue();
                byte[] frame = queryWithRetry(protocol, responseQueue, config.getDi(), pointCode, finalTimeout);
                if (frame == null) {
                    log.error("串口查询失败: pointCode={}, di={}", pointCode, Dl645CollectSupport.bytesToHex(config.getDi()));
                    result.put(pointCode, "");
                    continue;
                }
                String decoded = Dl645CollectSupport.decodePointValue(frame, config.getDi());
                result.put(pointCode, decoded);
                Dl645CollectSupport.sleepQuietly(COMMAND_INTERVAL_MS);
            }
        } catch (Exception e) {
            log.error("串口采集失败: {}", e.getMessage());
//            Map<String, DiConfig> commonDiMap = getCommonDiMap();
//            for (String key : commonDiMap.keySet()) {
//                result.putIfAbsent(key, "");
//            }
        } finally {
            protocol.disconnect();
        }
        return result;
    }

    private byte[] queryWithRetry(DL645Protocol protocol,
                                  LinkedBlockingQueue<byte[]> responseQueue,
                                  byte[] di,
                                  String pointCode,
                                  int timeoutMs) throws InterruptedException {
        responseQueue.clear();
        log.debug("发送DL645串口查询 pointCode={} di={}", pointCode, Dl645CollectSupport.bytesToHex(di));
        protocol.sendCommand(di);

        long startTime = System.currentTimeMillis();
        byte[] frame = responseQueue.poll(timeoutMs, TimeUnit.MILLISECONDS);
        long elapsed = System.currentTimeMillis() - startTime;

        if (frame != null && Dl645CollectSupport.frameMatchesExpectedDi(frame, di)) {
            log.debug("点位{} 成功获取响应,耗时={}ms", pointCode, elapsed);
            return frame;
        }

        if (frame != null) {
            log.error("点位{} 收到非目标DI响应[{}] | 耗时={}ms",
                    pointCode, Dl645CollectSupport.bytesToHex(frame), elapsed);
        } else {
            log.error("点位{} [等待{}ms/实际{}ms]",
                    pointCode, timeoutMs, elapsed);
        }
        log.error("点位{} 采集失败", pointCode);
        return null;
    }
}
