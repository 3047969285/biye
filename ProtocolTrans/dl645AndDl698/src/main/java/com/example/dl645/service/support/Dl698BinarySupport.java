package com.example.dl645.service.support;

/**
 * DL698 采集实现共用的字节与休眠工具
 *
 * @author wangchangzhen
 */
public final class Dl698BinarySupport {

    private Dl698BinarySupport() {
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
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02X", b));
        }
        return sb.toString();
    }

    public static byte[] reverseBytes(byte[] bytes) {
        byte[] arr = new byte[bytes.length];
        for (int i = 0; i < bytes.length; i++) {
            arr[i] = bytes[bytes.length - 1 - i];
        }
        return arr;
    }

    public static boolean equalsBytes(byte[] a, byte[] b) {
        if (a == b) {
            return true;
        }
        if (a == null || b == null || a.length != b.length) {
            return false;
        }
        for (int i = 0; i < a.length; i++) {
            if (a[i] != b[i]) {
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
