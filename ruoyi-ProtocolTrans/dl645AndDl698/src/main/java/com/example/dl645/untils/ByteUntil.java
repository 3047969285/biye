package com.example.dl645.untils;

/**
 * @Author wangchangzhen
 * @Date 2025 12 24 20 47
 * @description
 **/
public class ByteUntil {
    /**
     * 字节数组转十六进制字符串
     */
    public static String bytesToHex(byte[] bytes) {
        if (bytes == null) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02X ", b));
        }
        return sb.toString().trim();
    }

    /**
     * 将字节数组反转（低字节在前 ↔ 高字节在后）
     */
    public static byte[] reverseBytes(byte[] bytes) {
        if (bytes == null || bytes.length == 0) {
            return bytes;
        }
        byte[] reversed = new byte[bytes.length];
        for (int i = 0; i < bytes.length; i++) {
            reversed[i] = bytes[bytes.length - 1 - i];
        }
        return reversed;
    }

    /**
     * BCD转小数
     *
     * @param numStr   数字字符串，如 "001100"
     * @param format   格式字符串，如 "XXXX.XX"
     * @return         转换后的结果
     */
    public static String bcdToDecimal(String numStr, String format) {
        if (numStr == null || numStr.isEmpty()) {
            return "";
        }
        int dotIndex = format.indexOf('.');
        if (dotIndex == -1) {
            return numStr;
        }
        int intLen = dotIndex;
        int decLen = format.length() - dotIndex - 1;
        int totalLen = intLen + decLen;

        StringBuilder padded = new StringBuilder();
        for (int i = 0; i < totalLen - numStr.length(); i++) {
            padded.append('0');
        }
        padded.append(numStr);
        String paddedStr = padded.toString();

        return paddedStr.substring(0, intLen) + "." +
                paddedStr.substring(intLen, intLen + decLen);
    }
}
