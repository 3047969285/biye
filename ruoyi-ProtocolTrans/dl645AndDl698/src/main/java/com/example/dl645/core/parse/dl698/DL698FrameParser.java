package com.example.dl645.core.parse.dl698;

import com.example.dl645.constant.DL698Contant;
import com.example.dl645.core.DL698Frame;

/**
 * 从原始链路帧提取 APDU；优先 {@link DL698Frame#parse}，失败时再按长度域宽松截取（不校验 CRC，便于抓包分析）。
 */
public final class DL698FrameParser {

    private DL698FrameParser() {
    }

    public static byte[] extractApdu(byte[] frameData) {
        DL698Frame f = DL698Frame.parse(frameData);
        if (f != null && f.getApduData() != null) {
            return f.getApduData();
        }
        return extractApduLenient(frameData);
    }

    private static byte[] extractApduLenient(byte[] frameData) {
        if (frameData == null || frameData.length < 12) {
            return null;
        }
        if (frameData[0] != DL698Contant.FRAME_START) {
            return null;
        }
        int L = (frameData[1] & 0xFF) | ((frameData[2] & 0x3F) << 8);
        if (frameData.length < 2 + L || frameData[1 + L] != DL698Contant.FRAME_END) {
            return null;
        }
        int offset = 3;
        offset++;
        int addrTypeAndLen = frameData[offset] & 0xFF;
        int encLen = addrTypeAndLen & 0x0F;
        int serverAddrLen = encLen + 1;
        offset++;
        offset += serverAddrLen;
        offset++;
        offset += 2;
        int apduLen = L - 9 - serverAddrLen;
        if (apduLen <= 0 || offset + apduLen + 2 > frameData.length) {
            return null;
        }
        byte[] apdu = new byte[apduLen];
        System.arraycopy(frameData, offset, apdu, 0, apduLen);
        return apdu;
    }
}
