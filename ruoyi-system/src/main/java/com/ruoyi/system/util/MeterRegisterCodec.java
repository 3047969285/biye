package com.ruoyi.system.util;

import java.math.BigDecimal;
import java.math.RoundingMode;
import com.ruoyi.system.domain.MeterPoint;

/**
 * 将 Modbus 寄存器数组解析为工程值（支持 UINT16/INT16/UINT32/INT32/FLOAT32）。
 */
public final class MeterRegisterCodec {

    private MeterRegisterCodec() {
    }

    public static int registerSpan(String dataType) {
        if (dataType == null) {
            return 1;
        }
        return switch (dataType.toUpperCase()) {
            case "UINT32", "INT32", "FLOAT32" -> 2;
            default -> 1;
        };
    }

    /**
     * @param regs      本次报文中的寄存器值（16 位无符号）
     * @param relIndex  本点在 regs 中的起始下标（= point.addrOffset - baseAddress）
     * @return [raw, scaled]；下标越界返回 null
     */
    public static double[] decodeToScaled(MeterPoint point, int[] regs, int relIndex) {
        if (regs == null || relIndex < 0) {
            return null;
        }
        String dt = point.getDataType() != null ? point.getDataType().toUpperCase() : "UINT16";
        int span = registerSpan(dt);
        if (relIndex + span > regs.length) {
            return null;
        }
        long rawBits;
        double eng;
        switch (dt) {
            case "UINT16" -> {
                int v = regs[relIndex] & 0xFFFF;
                rawBits = v;
                eng = v;
            }
            case "INT16" -> {
                short s = (short) (regs[relIndex] & 0xFFFF);
                rawBits = s & 0xFFFFL;
                eng = s;
            }
            case "UINT32" -> {
                long hi = regs[relIndex] & 0xFFFFL;
                long lo = regs[relIndex + 1] & 0xFFFFL;
                rawBits = (hi << 16) | lo;
                eng = rawBits & 0xFFFFFFFFL;
            }
            case "INT32" -> {
                int i = (regs[relIndex] & 0xFFFF) << 16 | (regs[relIndex + 1] & 0xFFFF);
                rawBits = i & 0xFFFFFFFFL;
                eng = i;
            }
            case "FLOAT32" -> {
                int hi = regs[relIndex] & 0xFFFF;
                int lo = regs[relIndex + 1] & 0xFFFF;
                boolean swap = "1".equals(point.getWordSwap());
                int bits = swap ? (lo << 16 | hi) : (hi << 16 | lo);
                rawBits = bits & 0xFFFFFFFFL;
                eng = Float.intBitsToFloat(bits);
            }
            default -> {
                int v = regs[relIndex] & 0xFFFF;
                rawBits = v;
                eng = v;
            }
        }
        BigDecimal scale = point.getScale() != null ? point.getScale() : BigDecimal.ONE;
        BigDecimal off = point.getValueOffset() != null ? point.getValueOffset() : BigDecimal.ZERO;
        BigDecimal scaled = BigDecimal.valueOf(eng).multiply(scale).add(off).setScale(8, RoundingMode.HALF_UP);
        return new double[] { rawBits, scaled.doubleValue() };
    }
}
