package com.ruoyi.web.meter.dl645;

import java.util.Arrays;

/**
 * DL/T645-2007 响应帧解析（简化版）
 */
public final class Dl645FrameParser {

    private Dl645FrameParser() {
    }

    public static Dl645ParsedValue parse(String frameHex) {
        byte[] frame = parseHex(frameHex);
        if (frame.length < 12) {
            throw new IllegalArgumentException("帧长度不足");
        }
        if ((frame[0] & 0xFF) != 0x68 || (frame[7] & 0xFF) != 0x68 || (frame[frame.length - 1] & 0xFF) != 0x16) {
            throw new IllegalArgumentException("不是标准 645 响应帧");
        }
        int len = frame[9] & 0xFF;
        if (10 + len + 2 > frame.length) {
            throw new IllegalArgumentException("数据区长度非法");
        }
        byte[] addr = Arrays.copyOfRange(frame, 1, 7);
        String meterAddress = toHex(reverse(addr));

        byte[] encData = Arrays.copyOfRange(frame, 10, 10 + len);
        byte[] data = new byte[encData.length];
        for (int i = 0; i < encData.length; i++) {
            data[i] = (byte) ((encData[i] - 0x33) & 0xFF);
        }
        if (data.length < 4) {
            throw new IllegalArgumentException("数据区无 DI");
        }
        byte[] diLe = Arrays.copyOfRange(data, 0, 4);
        String di = toHex(reverse(diLe));
        byte[] valueBytes = Arrays.copyOfRange(data, 4, data.length);
        String valueBcdLe = toHex(valueBytes);
        return new Dl645ParsedValue(meterAddress, di, valueBytes, valueBcdLe);
    }

    public static double bcdLittleEndianToDouble(byte[] valueBytes, int decimals) {
        if (valueBytes == null || valueBytes.length == 0) {
            return 0D;
        }
        StringBuilder sb = new StringBuilder();
        for (int i = valueBytes.length - 1; i >= 0; i--) {
            int b = valueBytes[i] & 0xFF;
            sb.append((b >> 4) & 0x0F).append(b & 0x0F);
        }
        long raw = Long.parseLong(sb.toString());
        double div = Math.pow(10, Math.max(0, decimals));
        return raw / div;
    }

    private static byte[] parseHex(String hex) {
        if (hex == null) {
            throw new IllegalArgumentException("frameHex 为空");
        }
        String s = hex.replace(" ", "").replace("\r", "").replace("\n", "").trim();
        if ((s.length() & 1) != 0) {
            throw new IllegalArgumentException("hex 字符串长度必须为偶数");
        }
        byte[] out = new byte[s.length() / 2];
        for (int i = 0; i < out.length; i++) {
            int hi = Character.digit(s.charAt(i * 2), 16);
            int lo = Character.digit(s.charAt(i * 2 + 1), 16);
            if (hi < 0 || lo < 0) {
                throw new IllegalArgumentException("包含非法 hex 字符");
            }
            out[i] = (byte) ((hi << 4) + lo);
        }
        return out;
    }

    private static byte[] reverse(byte[] src) {
        byte[] out = new byte[src.length];
        for (int i = 0; i < src.length; i++) {
            out[i] = src[src.length - 1 - i];
        }
        return out;
    }

    private static String toHex(byte[] src) {
        StringBuilder sb = new StringBuilder(src.length * 2);
        for (byte b : src) {
            sb.append(String.format("%02X", b));
        }
        return sb.toString();
    }

    public record Dl645ParsedValue(String meterAddress, String diCode, byte[] valueBytes, String valueHexLe) {
    }
}
