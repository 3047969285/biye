package com.example.dl645.core.parse;

import org.apache.commons.lang3.StringUtils;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.Locale;

/**
 * DL645 数据域解析抽象策略（DL/T 645-2007）
 *
 * @author wangchangzhen
 */
public abstract class AbsParseStrategy implements ParseStrategy {

    /**
     * 去掉末尾 4 字节数据标识后将负载拼成连续十六进制串（仅适用于确信结构为「数据 + DI」且调用方无单独 DI 的场景）。
     *
     * @param data 原数据域（已减 33H）
     * @return 连续 hex，不含空格；不足 5 字节时无法剥 DI，返回 null
     */
    protected String dealDataByte(byte[] data) {
        if (data == null || data.length == 0) {
            return null;
        }
        if (data.length <= 4) {
            return null;
        }
        return bytesToContiguousHex(Arrays.copyOfRange(data, 0, data.length - 4));
    }

    /**
     * 根据请求使用的 DI 从数据域中剥离 4 字节标识，将剩余负载转为连续十六进制串（优先于 {@link #dealDataByte(byte[])}）。
     *
     * @param data  完整用户数据区（已减 33H）
     * @param diHex 8 位十六进制 DI
     */
    protected String payloadHex(byte[] data, String diHex) {
        byte[] payload = stripDataIdentifierFlexible(data, diHex);
        if (payload == null || payload.length == 0) {
            return null;
        }
        return bytesToContiguousHex(payload);
    }

    /**
     * 将字节数组转为连续大写十六进制串（无空格），便于 BCD / 二进制分支解析。
     */
    protected static String bytesToContiguousHex(byte[] payload) {
        if (payload == null || payload.length == 0) {
            return null;
        }
        StringBuilder sb = new StringBuilder(payload.length * 2);
        for (byte b : payload) {
            sb.append(String.format(Locale.ROOT, "%02X", b & 0xFF));
        }
        return sb.toString();
    }

    /**
     * 从数据域（已做 -33H）中去掉 4 字节数据标识，得到纯数据负载。
     * 读应答中数据域既可能是「数据 + DI(尾 4 字节)」，也可能是「DI(前 4 字节) + 数据」（多见于最大需量等）。
     *
     * @param data  完整用户数据区（已减 33）
     * @param diHex 8 位十六进制 DI，如 01010000
     */
    protected byte[] stripDataIdentifierFlexible(byte[] data, String diHex) {
        if (data == null || data.length < 4 || diHex == null || diHex.length() != 8) {
            return null;
        }
        byte[] diBytes = new byte[4];
        for (int i = 0; i < 4; i++) {
            diBytes[i] = (byte) Integer.parseInt(diHex.substring(i * 2, i * 2 + 2), 16);
        }
        if (leadingDiEquals(data, diBytes)) {
            return Arrays.copyOfRange(data, 4, data.length);
        }
        if (trailingDiEquals(data, diBytes)) {
            return Arrays.copyOfRange(data, 0, data.length - 4);
        }
        if (data.length > 4) {
            return Arrays.copyOfRange(data, 0, data.length - 4);
        }
        return null;
    }

    /**
     * 前 4 字节与 DI 一致（支持字节顺序与 hex 串正写一致或其逆序，以适配低字节先行）
     */
    private static boolean leadingDiEquals(byte[] data, byte[] diBytes) {
        return blockEquals(data, 0, diBytes, false) || blockEquals(data, 0, diBytes, true);
    }

    private static boolean trailingDiEquals(byte[] data, byte[] diBytes) {
        if (data.length < 4) {
            return false;
        }
        int off = data.length - 4;
        return blockEquals(data, off, diBytes, false) || blockEquals(data, off, diBytes, true);
    }

    private static boolean blockEquals(byte[] data, int offset, byte[] diBytes, boolean reverseDi) {
        for (int i = 0; i < 4; i++) {
            int diIdx = reverseDi ? (3 - i) : i;
            if ((data[offset + i] & 0xFF) != (diBytes[diIdx] & 0xFF)) {
                return false;
            }
        }
        return true;
    }

    /**
     * 单字节 BCD（两个十六进制字符）转 0～99
     */
    protected static int bcdBytePair(String hexPair) {
        int v = Integer.parseInt(hexPair, 16) & 0xFF;
        int hi = (v >>> 4) & 0x0F;
        int lo = v & 0x0F;
        if (hi > 9 || lo > 9) {
            throw new IllegalArgumentException("非BCD字节: " + hexPair);
        }
        return hi * 10 + lo;
    }

    /**
     * DL/T 645 电能量数据偶见的<strong>带符号 BCD</strong>：最高半字节为 8～F 时表示负号。
     */
    protected BigDecimal convertSignedBcdHex(String hexStr, String format) {
        if (StringUtils.isEmpty(hexStr)) {
            return BigDecimal.ZERO;
        }
        boolean negative = false;
        StringBuilder digits = new StringBuilder();
        for (int i = 0; i < hexStr.length(); i++) {
            char c = hexStr.charAt(i);
            int nibble = Character.digit(c, 16);
            if (nibble < 0) {
                throw new IllegalArgumentException("非法BCD字符: " + c);
            }
            if (i == 0 && nibble >= 8) {
                negative = true;
                nibble -= 8;
            }
            if (nibble > 9) {
                throw new IllegalArgumentException("非BCD数字: " + c);
            }
            digits.append(nibble);
        }
        BigDecimal value = convert(digits.toString(), format);
        return negative ? value.negate() : value;
    }

    /**
     * 将十六进制字符串转为二进制数值并除以因子
     *
     * @param hexStr 十六进制字符串 (如 "00001388")
     * @param factor 换算因子 (如 1000)
     */
    protected BigDecimal convertBinary(String hexStr, int factor) {
        if (hexStr == null || hexStr.isEmpty()) {
            return BigDecimal.ZERO;
        }
        long value = Long.parseLong(hexStr, 16);
        return BigDecimal.valueOf(value).divide(BigDecimal.valueOf(factor));
    }

    /**
     * 将数字字符串按照指定格式转为BigDecimal
     *
     * @param numStr 数字字符串，如 "001100"
     * @param format 格式字符串，如 "XXXX.XX"
     */
    protected BigDecimal convert(String numStr, String format) {
        int dotIndex = format.indexOf('.');

        if (dotIndex == -1) {
            return new BigDecimal(numStr);
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

        String result = paddedStr.substring(0, intLen) + "." +
                paddedStr.substring(intLen, intLen + decLen);
        return new BigDecimal(result);
    }
}
