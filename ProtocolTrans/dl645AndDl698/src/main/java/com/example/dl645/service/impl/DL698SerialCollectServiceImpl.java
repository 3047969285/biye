package com.example.dl645.service.impl;

import com.example.dl645.core.parse.dl698.DL698FrameParser;
import com.example.dl645.core.parse.dl698.DL698Handler;
import com.example.dl645.core.DL698Protocol;
import com.example.dl645.core.ResponseListener;
import com.example.dl645.entity.OadConfig;
import com.example.dl645.service.DL698SerialCollectService;
import com.example.dl645.service.support.Dl645CollectSupport;
import com.example.dl645.service.support.Dl698BinarySupport;
import com.example.dl645.service.support.Dl698OadConfigSupport;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.LinkedHashMap;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;

/**
 * DL698 串口采集实现
 *
 * @author wangchangzhen
 */
@Slf4j
@Service
public class DL698SerialCollectServiceImpl implements DL698SerialCollectService {
    // 默认超时时间
    private static final int DEFAULT_TIMEOUT_MS = 300;
    // 默认波特率
    private static final int DEFAULT_BAUD_RATE = 2400;
    // 查询重试次数
    private static final int QUERY_RETRY_TIMES = 2;
    // 命令间隔时间
    private static final int COMMAND_INTERVAL_MS = 120;
    // 默认客户端地址
    private static final int DEFAULT_CLIENT_ADDRESS = 0x10;
    //  meterAddress 正则
    private static final Pattern METER_ADDRESS_PATTERN = Pattern.compile("^[0-9a-fA-F]{12}$");

    @Override
    public Map<String, String> collectOadAndSave(String comPort,
                                                 String meterAddress,
                                                 int baudRate,
                                                 int timeoutMs,
                                                 Integer clientAddress,
                                                 Map<String, String> pointMap) {
        int finalBaudRate = baudRate <= 0 ? DEFAULT_BAUD_RATE : baudRate;
        int finalTimeout = (timeoutMs <= 0) ? DEFAULT_TIMEOUT_MS : timeoutMs;
        validateParam(comPort, meterAddress);
        String normalizedMeterAddress = meterAddress.trim().toUpperCase();
        int clientInt = clientAddress == null ? DEFAULT_CLIENT_ADDRESS : clientAddress;
        byte defaultClient = (byte) clientInt;
        byte[] serverBytes = DL698Handler.meterAddressHexToBytes(normalizedMeterAddress);

        Map<String, String> result = new LinkedHashMap<>();
        LinkedBlockingQueue<byte[]> responseQueue = new LinkedBlockingQueue<>(8);
        DL698Protocol protocol = new DL698Protocol();
        protocol.setResponseListener(new ResponseListener() {
            @Override
            public void onResponseReceived(byte[] response) {
                responseQueue.offer(response);
            }

            @Override
            public void onError(String errorMessage) {
                log.error("DL698 串口监听错误: {}", errorMessage);
            }

            @Override
            public void onPortOpened(String portName) {
                log.info("DL698 串口通道已打开: {}", portName);
            }

            @Override
            public void onPortClosed(String portName) {
                log.info("DL698 串口通道已关闭: {}", portName);
            }

            @Override
            public void onDataAvailable(byte[] data) {
            }
        });

        try {
            if (!protocol.connectSerial(comPort, finalBaudRate, finalTimeout)) {
                throw new RuntimeException("串口连接失败");
            }
            SessionParam sessionParam = establishSession(protocol, responseQueue, serverBytes, defaultClient, finalTimeout);
            Map<String, OadConfig> commonOadMap = Dl698OadConfigSupport.loadOadMap(pointMap);
            for (Map.Entry<String, OadConfig> entry : commonOadMap.entrySet()) {
                String pointCode = entry.getKey();
                OadConfig config = entry.getValue();
                byte[] frame = queryWithRetry(protocol, responseQueue, sessionParam.serverBytes, sessionParam.client, sessionParam.logicAddress, sessionParam.sc, config.getOad(), pointCode, finalTimeout);
                if (frame == null) {
                    log.error("串口查询失败: pointCode={}, di={}", pointCode, Dl645CollectSupport.bytesToHex(config.getOad()));
                    result.put(pointCode, "");
                    continue;
                }
                String decoded = decodeFrame(frame);
                result.put(pointCode, decoded);
                Dl698BinarySupport.sleepQuietly(COMMAND_INTERVAL_MS);
            }
        } catch (Exception e) {
            log.error("DL698 串口批量采集失败: {}", e.getMessage());
//            Map<String, OadConfig> commonOadMap = Dl698OadConfigSupport.loadOadMap(environment);
//            for (String key : commonOadMap.keySet()) {
//                result.putIfAbsent(key, "");
//            }
        } finally {
            protocol.disconnectSerial();
        }
        return result;
    }

    private byte[] queryWithRetry(DL698Protocol protocol,
                                  LinkedBlockingQueue<byte[]> responseQueue,
                                  byte[] serverBytes,
                                  byte client,
                                  byte logicAddress,
                                  boolean sc,
                                  byte[] oad,
                                  String pointCode,
                                  int timeoutMs) throws InterruptedException {
        for (int i = 0; i <= QUERY_RETRY_TIMES; i++) {
            responseQueue.clear();
            protocol.sendReadSerial(serverBytes, client, oad, logicAddress, sc);
            byte[] frame = responseQueue.poll(timeoutMs, TimeUnit.MILLISECONDS);
            if (frame != null && isExpectedReadResponse(frame, oad)) {
                return frame;
            }
            if (i < QUERY_RETRY_TIMES) {
                log.error("DL698 串口点位{} 第{}次超时，准备重试", pointCode, i + 1);
                Dl698BinarySupport.sleepQuietly(COMMAND_INTERVAL_MS);
            }
        }
        return null;
    }

    private SessionParam establishSession(DL698Protocol protocol,
                                          LinkedBlockingQueue<byte[]> responseQueue,
                                          byte[] serverBytes,
                                          byte defaultClient,
                                          int timeoutMs) throws InterruptedException {
        List<SessionParam> candidates = buildSessionCandidates(serverBytes, defaultClient);
        for (SessionParam candidate : candidates) {
            if (!ensureLink(protocol, responseQueue, candidate.serverBytes, candidate.client, candidate.logicAddress, candidate.sc, timeoutMs)) {
                continue;
            }
            if (!ensureConnect(protocol, responseQueue, candidate.serverBytes, candidate.client, candidate.logicAddress, candidate.sc, timeoutMs)) {
                continue;
            }
            log.info("DL698 串口握手成功，client={}, logic={}, sc={}, server={}",
                    candidate.client & 0xFF, candidate.logicAddress, candidate.sc, Dl698BinarySupport.bytesToHex(candidate.serverBytes));
            return candidate;
        }
        throw new RuntimeException("链路/应用连接失败（已尝试多组地址参数）");
    }

    private List<SessionParam> buildSessionCandidates(byte[] serverBytes, byte defaultClient) {
        List<SessionParam> list = new ArrayList<>();
        byte[] reversed = Dl698BinarySupport.reverseBytes(serverBytes);
        byte[] clients = new byte[]{defaultClient, 0x10, 0x01};
        byte[] logicList = new byte[]{0x00, 0x01, 0x02, 0x03};
        boolean[] scList = new boolean[]{false, true};
        for (byte c : clients) {
            for (byte logic : logicList) {
                for (boolean sc : scList) {
                    addCandidate(list, serverBytes, c, logic, sc);
                    addCandidate(list, reversed, c, logic, sc);
                }
            }
        }
        return list;
    }

    private void addCandidate(List<SessionParam> list, byte[] server, byte client, byte logicAddress, boolean sc) {
        for (SessionParam s : list) {
            if (s.client == client && s.logicAddress == logicAddress && s.sc == sc && Dl698BinarySupport.equalsBytes(s.serverBytes, server)) {
                return;
            }
        }
        list.add(new SessionParam(server, client, logicAddress, sc));
    }

    private static final class SessionParam {
        private final byte[] serverBytes;
        private final byte client;
        private final byte logicAddress;
        private final boolean sc;

        private SessionParam(byte[] serverBytes, byte client, byte logicAddress, boolean sc) {
            this.serverBytes = serverBytes;
            this.client = client;
            this.logicAddress = logicAddress;
            this.sc = sc;
        }
    }

    private boolean ensureLink(DL698Protocol protocol,
                               LinkedBlockingQueue<byte[]> responseQueue,
                               byte[] serverBytes,
                               byte client,
                               byte logicAddress,
                               boolean sc,
                               int timeoutMs) throws InterruptedException {
        for (int i = 0; i <= QUERY_RETRY_TIMES; i++) {
            responseQueue.clear();
            protocol.sendLinkSerial(serverBytes, client, logicAddress, sc);
            byte[] frame = pollUntil(responseQueue, timeoutMs);
            if (frame != null) {
                byte[] apdu = DL698FrameParser.extractApdu(frame);
                if (DL698Handler.isLinkResponseSuccess(apdu)) {
                    return true;
                }
            }
            if (i < QUERY_RETRY_TIMES) {
                log.error("DL698 串口 LINK 第{}次失败，准备重试", i + 1);
                Dl698BinarySupport.sleepQuietly(COMMAND_INTERVAL_MS);
            }
        }
        return false;
    }

    private boolean ensureConnect(DL698Protocol protocol,
                                  LinkedBlockingQueue<byte[]> responseQueue,
                                  byte[] serverBytes,
                                  byte client,
                                  byte logicAddress,
                                  boolean sc,
                                  int timeoutMs) throws InterruptedException {
        for (int i = 0; i <= QUERY_RETRY_TIMES; i++) {
            responseQueue.clear();
            protocol.sendConnectSerial(serverBytes, client, logicAddress, sc);
            byte[] frame = pollUntil(responseQueue, timeoutMs);
            if (frame != null) {
                byte[] apdu = DL698FrameParser.extractApdu(frame);
                if (DL698Handler.isConnectResponseSuccess(apdu)) {
                    return true;
                }
            }
            if (i < QUERY_RETRY_TIMES) {
                log.error("DL698 串口 CONNECT 第{}次失败，准备重试", i + 1);
                Dl698BinarySupport.sleepQuietly(COMMAND_INTERVAL_MS);
            }
        }
        return false;
    }

    private String decodeFrame(byte[] frameBytes) {
        byte[] apdu = DL698FrameParser.extractApdu(frameBytes);
        return DL698Handler.parseReadApduToValue(apdu);
    }

    private boolean isExpectedReadResponse(byte[] frameBytes, byte[] oad4) {
        byte[] apdu = DL698FrameParser.extractApdu(frameBytes);
        return DL698Handler.isGetResponseForOad(apdu, oad4);
    }

    private byte[] pollUntil(LinkedBlockingQueue<byte[]> responseQueue, int timeoutMs) throws InterruptedException {
        long deadline = System.currentTimeMillis() + timeoutMs;
        while (System.currentTimeMillis() < deadline) {
            long remain = deadline - System.currentTimeMillis();
            byte[] frame = responseQueue.poll(Math.max(remain, 1), TimeUnit.MILLISECONDS);
            if (frame != null) {
                return frame;
            }
        }
        return null;
    }

    private void validateParam(String comPort, String meterAddress) {
        if (comPort == null || comPort.trim().isEmpty()) {
            throw new IllegalArgumentException("串口不能为空");
        }
        if (meterAddress == null || !METER_ADDRESS_PATTERN.matcher(meterAddress.trim()).matches()) {
            throw new IllegalArgumentException("电表地址格式错误");
        }
    }
}
