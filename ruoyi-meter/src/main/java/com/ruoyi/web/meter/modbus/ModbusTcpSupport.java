package com.ruoyi.web.meter.modbus;

import java.util.ArrayList;
import java.util.List;

/**
 * Modbus TCP 帧拆分与 FC03/FC04 响应解析（寄存器为大端 16 位）。
 */
public final class ModbusTcpSupport {

    private ModbusTcpSupport() {
    }

    public static int readMbapLength(byte[] frame, int offset) {
        if (frame == null || offset + 6 > frame.length) {
            return -1;
        }
        return ((frame[offset + 4] & 0xFF) << 8) | (frame[offset + 5] & 0xFF);
    }

    /** 单帧总长度 = 6 + MBAP.length 字段 */
    public static int frameTotalLength(byte[] frame, int offset) {
        int len = readMbapLength(frame, offset);
        if (len < 0) {
            return -1;
        }
        return 6 + len;
    }

    public static List<byte[]> drainFrames(byte[] buf, int len) {
        List<byte[]> out = new ArrayList<>();
        int i = 0;
        while (i + 6 <= len) {
            int flen = frameTotalLength(buf, i);
            if (flen < 0 || i + flen > len) {
                break;
            }
            byte[] one = new byte[flen];
            System.arraycopy(buf, i, one, 0, flen);
            out.add(one);
            i += flen;
        }
        return out;
    }

    /** 从 FC03/FC04 响应 PDU 解析寄存器数组；异常/非读响应返回 null */
    public static int[] parseReadRegistersResponse(byte[] frame) {
        if (frame == null || frame.length < 9) {
            return null;
        }
        int mbapLen = readMbapLength(frame, 0);
        if (6 + mbapLen != frame.length) {
            return null;
        }
        int pduStart = 7;
        int fc = frame[pduStart] & 0xFF;
        if ((fc & 0x80) != 0) {
            return null;
        }
        if (fc != 0x03 && fc != 0x04) {
            return null;
        }
        int bc = frame[pduStart + 1] & 0xFF;
        if (bc % 2 != 0 || pduStart + 2 + bc > frame.length) {
            return null;
        }
        int n = bc / 2;
        int[] regs = new int[n];
        for (int r = 0; r < n; r++) {
            int hi = frame[pduStart + 2 + r * 2] & 0xFF;
            int lo = frame[pduStart + 2 + r * 2 + 1] & 0xFF;
            regs[r] = (hi << 8) | lo;
        }
        return regs;
    }

    public static Integer parseReadRequestStartAddress(byte[] frame) {
        if (frame == null || frame.length < 12) {
            return null;
        }
        int mbapLen = readMbapLength(frame, 0);
        if (6 + mbapLen != frame.length) {
            return null;
        }
        int pduStart = 7;
        int fc = frame[pduStart] & 0xFF;
        if (fc != 0x03 && fc != 0x04) {
            return null;
        }
        int hi = frame[pduStart + 1] & 0xFF;
        int lo = frame[pduStart + 2] & 0xFF;
        return (hi << 8) | lo;
    }

    public static int parseFunctionCode(byte[] frame) {
        if (frame == null || frame.length < 8) {
            return -1;
        }
        return frame[7] & 0xFF;
    }

    public static int parseUnitId(byte[] frame) {
        if (frame == null || frame.length < 7) {
            return -1;
        }
        return frame[6] & 0xFF;
    }

    /** FC03/FC04 读请求（PDU 固定 5 字节） */
    public static boolean isReadRequest(byte[] frame) {
        int mb = readMbapLength(frame, 0);
        if (mb < 0 || frame.length < 12) {
            return false;
        }
        if (6 + mb != frame.length) {
            return false;
        }
        int pduLen = mb - 1;
        if (pduLen != 5) {
            return false;
        }
        int fc = frame[7] & 0xFF;
        return fc == 0x03 || fc == 0x04;
    }
}

