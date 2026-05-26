package com.example.dl645.core.parse;

/**
 * CRC算法：用于帧头校验的（HCS）和帧校验（FCS）
 */
public final class Crc16 {

    private static final int PPP_INIT = 0xffff;
    private static final int PPP_GOOD = 0xf0b8;
    private static final int[] FCSTAB = buildTable();

    private Crc16() {
    }

    private static int[] buildTable() {
        final int p = 0x8408;
        int[] tab = new int[256];
        for (int b = 0; b < 256; b++) {
            int v = b;
            for (int i = 0; i < 8; i++) {
                v = (v & 1) != 0 ? (v >>> 1) ^ p : (v >>> 1);
            }
            tab[b] = v & 0xffff;
        }
        return tab;
    }

    /**
     * 计算 FCS（已对结果取反），低字节在前写入链路层
     */
    public static int computeFcs(byte[] data, int offset, int len) {
        int fcs = PPP_INIT;
        for (int i = 0; i < len; i++) {
            fcs = (fcs >>> 8) ^ FCSTAB[(fcs ^ data[offset + i]) & 0xff];
        }
        return fcs ^ 0xffff;
    }

    public static void writeLe(int crc, byte[] out, int off) {
        out[off] = (byte) (crc & 0xff);
        out[off + 1] = (byte) ((crc >>> 8) & 0xff);
    }

    /**
     * 校验 FCS：对不含 68H、16H、FCS 本身的全部字节计算后应得到 PPP_GOOD
     */
    public static boolean verifyFcs(byte[] data, int offset, int lenIncludingFcs2) {
        if (lenIncludingFcs2 < 2) {
            return false;
        }
        int fcs = PPP_INIT;
        for (int i = 0; i < lenIncludingFcs2; i++) {
            fcs = (fcs >>> 8) ^ FCSTAB[(fcs ^ data[offset + i]) & 0xff];
        }
        return fcs == PPP_GOOD;
    }
}
