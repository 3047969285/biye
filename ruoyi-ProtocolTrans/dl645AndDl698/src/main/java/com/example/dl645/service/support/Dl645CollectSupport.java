package com.example.dl645.service.support;

import com.example.dl645.core.DL645Frame;
import com.example.dl645.core.parse.dl645.DL645Handler;
import com.example.dl645.core.parse.ParseResult;
import com.example.dl645.untils.ByteUntil;
import lombok.extern.slf4j.Slf4j;

/**
 * DL645 批量采集中共用的帧解析、DI 比对与十六进制工具
 *
 * @author wangchangzhen
 */
@Slf4j
public final class Dl645CollectSupport {

    private Dl645CollectSupport() {
    }

    public static byte[] hexStringToByteArray(String s) {
        if (s == null || s.isEmpty()) {
            return new byte[0];
        }
        int len = s.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
                    + Character.digit(s.charAt(i + 1), 16));
        }
        return data;
    }

    public static String bytesToHex(byte[] bytes) {
        if (bytes == null) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02X", b));
        }
        return sb.toString();
    }

    /**
     * 将读回应帧解析为点位字符串（与 {@link DL645Handler#parseResponse(byte[], byte[])} 一致）
     */
    public static String decodePointValue(byte[] frameBytes, byte[] di) {
        DL645Frame frame = DL645Frame.parse(frameBytes);
        if (frame == null || frame.getData() == null) {
            log.error("DL645帧解析失败，pointDi={}", bytesToHex(di));
            return "";
        }
        try {
            Object parsed = DL645Handler.parseResponse(frame.getData(), di);
            if (parsed == null) {
                return "";
            }
            if (parsed instanceof ParseResult) {
                Object value = ((ParseResult) parsed).getValue();
                return value == null ? "" : String.valueOf(value);
            }
            return String.valueOf(parsed);
        } catch (Exception e) {
            log.error("DL645点位解析失败 pointDi={} raw={} err={}",
                    bytesToHex(di), ByteUntil.bytesToHex(frame.getData()), e.getMessage());
            return "";
        }
    }

    /**
     * 判断响应数据域前 4 字节（减 33H 后）是否与请求 DI 一致（含字节序兼容）
     */
    public static boolean frameMatchesExpectedDi(byte[] frameBytes, byte[] expectedDi) {
        DL645Frame frame = DL645Frame.parse(frameBytes);
        if (frame == null || frame.getData() == null || frame.getData().length < 4) {
            return false;
        }
        byte[] rawDi = new byte[4];
        System.arraycopy(frame.getData(), 0, rawDi, 0, 4);
        byte[] decodedDi = new byte[4];
        for (int i = 0; i < 4; i++) {
            decodedDi[i] = (byte) ((rawDi[i] & 0xFF) - 0x33);
        }
        if (sameDiExact(decodedDi, expectedDi)) {
            return true;
        }
        byte[] reversedExpectedDi = new byte[4];
        for (int i = 0; i < 4; i++) {
            reversedExpectedDi[i] = expectedDi[3 - i];
        }
        return sameDiExact(decodedDi, reversedExpectedDi);
    }

    private static boolean sameDiExact(byte[] actual, byte[] expected) {
        for (int i = 0; i < 4; i++) {
            if (actual[i] != expected[i]) {
                return false;
            }
        }
        return true;
    }

    public static void sleepQuietly(long millis) {
        try {
            Thread.sleep(millis);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}
