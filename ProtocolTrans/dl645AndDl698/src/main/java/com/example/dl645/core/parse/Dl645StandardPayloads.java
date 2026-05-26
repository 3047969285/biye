package com.example.dl645.core.parse;

import org.apache.commons.lang3.StringUtils;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;

/**
 * DL645 数据域格式换算工具（DL/T 645-2007）
 *
 * @author wangchangzhen
 */
public final class Dl645StandardPayloads {

    private Dl645StandardPayloads() {
    }

    /** 与组合/分时电能量相同的 8 字节 BCD、末两位为小数位（单位 kWh/kvarh 等由策略标注）。*/
    public static BigDecimal eightByteBcdTwoDecimals(AbsParseStrategy s, String contiguousHex) {
        if (StringUtils.isEmpty(contiguousHex) || contiguousHex.length() < 16) {
            throw new IllegalArgumentException("电能量类负载长度不足: " + contiguousHex);
        }
        String head = contiguousHex.length() > 16 ? contiguousHex.substring(0, 16) : contiguousHex;
        return s.convert(head, "XXXXXXXX.XX");
    }

    /**
     * 冻结电能类（DI₅ 0x05）多数与电能量域长、格式一致。
     */
    public static BigDecimal freezeAggregateEnergy(AbsParseStrategy s, String contiguousHex) {
        return eightByteBcdTwoDecimals(s, contiguousHex);
    }

    /**
     * 谐波/间谐波含有率等：常见为2～4 字节 BCD，分辨力 0.01%。
     */
    public static BigDecimal harmonicPercentXXdotXX(AbsParseStrategy s, String contiguousHex) {
        if (contiguousHex.length() >= 8) {
            return s.convert(contiguousHex.substring(0, 8), "XXXX.XX");
        }
        if (contiguousHex.length() >= 4) {
            return s.convert(contiguousHex.substring(0, 4), "XX.XX");
        }
        if (contiguousHex.length() >= 2) {
            return s.convert(contiguousHex.substring(0, 2), "XX");
        }
        throw new IllegalArgumentException("谐波类负载过短: " + contiguousHex);
    }

    /**
     * 参变量中的日期/星期：4 字节 BCD，格式 YYMMDDWW。
     */
    public static String calendarDateYyMmDdWw(String eightHexChars) {
        if (eightHexChars.length() < 8) {
            return eightHexChars;
        }
        int yy = AbsParseStrategy.bcdBytePair(eightHexChars.substring(0, 2));
        int mm = AbsParseStrategy.bcdBytePair(eightHexChars.substring(2, 4));
        int dd = AbsParseStrategy.bcdBytePair(eightHexChars.substring(4, 6));
        int ww = AbsParseStrategy.bcdBytePair(eightHexChars.substring(6, 8));
        int year = 2000 + yy;
        return String.format("%04d-%02d-%02d wk%02d", year, mm, dd, ww);
    }

    /**
     * 可打印 ASCII 文本（资产管理编码、型号等）。
     */
    public static String asciiIfPrintable(byte[] payload) {
        if (payload == null || payload.length == 0) {
            return "";
        }
        Charset cs = StandardCharsets.ISO_8859_1;
        String t = new String(payload, cs);
        for (int i = 0; i < t.length(); i++) {
            char c = t.charAt(i);
            if (c < 0x20 || c > 0x7E) {
                return null;
            }
        }
        return t.trim();
    }

    /**
     * 无符号整数（保留/扩展区纯二进制整数）。
     */
    public static BigDecimal unsignedIntegerBigEndianHex(String hex) {
        return new BigDecimal(new BigInteger(hex, 16));
    }
}


