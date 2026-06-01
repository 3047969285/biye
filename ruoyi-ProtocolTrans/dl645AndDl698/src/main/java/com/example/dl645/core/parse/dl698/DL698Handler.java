package com.example.dl645.core.parse.dl698;

import com.example.dl645.constant.DL698Contant;
import com.example.dl645.core.DL698Frame;

import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * DL/T 698.45-2017 应用层：GET-Request / GET-Response 组帧与读值解析
 */
public final class DL698Handler {

    private DL698Handler() {
    }

    /**
     * 组读请求链路帧：Client-APDU = 05H [1]GetRequestNormal + PIID + OAD + 无时间标签(00H)
     */
    public static byte[] buildReadRequest(byte[] serverAddress, byte clientAddress, byte[] oad4) {
        return buildReadRequest(serverAddress, clientAddress, oad4, 0x01);
    }

    /**
     * 组建 CONNECT-Request（H.2 示例）：
     * 02 PIID 00 10 ProtocolConformance(8) FunctionConformance(16)
     * 04 00 04 00 01 04 00 00 00 00 64 00 00
     */
    public static byte[] buildConnectRequest(byte[] serverAddress, byte clientAddress) {
        return buildConnectRequest(serverAddress, clientAddress, (byte) 0x00, false);
    }

    public static byte[] buildConnectRequest(byte[] serverAddress, byte clientAddress, byte logicAddress, boolean sc) {
        byte[] apdu = buildConnectRequestApdu(0x00);
        DL698Frame frame = new DL698Frame();
        frame.setControlField(buildClientRequestUserDataControl(sc));
        frame.setAddressType(DL698Contant.addressType.SINGLE_ADDRESS);
        frame.setLogicAddress(logicAddress);
        frame.setServerAddress(serverAddress);
        frame.setClientAddress(clientAddress);
        frame.setApduData(apdu);
        return frame.build();
    }

    /**
     * 组建 LINK-Request 登录帧
     */
    public static byte[] buildLinkRequest(byte[] serverAddress, byte clientAddress) {
        return buildLinkRequest(serverAddress, clientAddress, (byte) 0x00, false);
    }

    public static byte[] buildLinkRequest(byte[] serverAddress, byte clientAddress, byte logicAddress, boolean sc) {
        byte[] apdu = buildLinkRequestApdu(0x00, 0x00, 0x00B4);
        DL698Frame frame = new DL698Frame();
        // 附录 H.1 示例控制域为 0x81
        frame.setControlField((byte) ((byte) 0x81 | (sc ? 0x08 : 0x00)));
        frame.setAddressType(DL698Contant.addressType.SINGLE_ADDRESS);
        frame.setLogicAddress(logicAddress);
        frame.setServerAddress(serverAddress);
        frame.setClientAddress(clientAddress);
        frame.setApduData(apdu);
        return frame.build();
    }

    public static byte[] buildReadRequest(byte[] serverAddress, byte clientAddress, byte[] oad4, int piid) {
        return buildReadRequest(serverAddress, clientAddress, oad4, piid, (byte) 0x00, false);
    }

    public static byte[] buildReadRequest(byte[] serverAddress, byte clientAddress, byte[] oad4, int piid, byte logicAddress, boolean sc) {
        if (oad4 == null || oad4.length != DL698Contant.apduData.OAD_LENGTH) {
            throw new IllegalArgumentException("OAD必须为4字节");
        }
        if (serverAddress == null || serverAddress.length < 1) {
            throw new IllegalArgumentException("服务器地址不能为空");
        }
        byte[] apdu = buildGetRequestNormalApdu(oad4, piid);
        DL698Frame frame = new DL698Frame();
        frame.setControlField(buildClientRequestUserDataControl(sc));
        frame.setAddressType(DL698Contant.addressType.SINGLE_ADDRESS);
        frame.setLogicAddress(logicAddress);
        frame.setServerAddress(serverAddress);
        frame.setClientAddress(clientAddress);
        frame.setApduData(apdu);
        return frame.build();
    }

    public static byte[] buildConnectRequestApdu(int piid) {
        ByteArrayOutputStream out = new ByteArrayOutputStream(48);
        out.write(0x02); // CONNECT-Request
        out.write(piid & 0xFF);
        out.write(0x00);
        out.write(0x10);
        for (int j = 0; j < 8; j++) {
            out.write(0xFF);
        }
        for (int j = 0; j < 16; j++) {
            out.write(0xFF);
        }
        out.write(0x04);
        out.write(0x00);
        out.write(0x04);
        out.write(0x00);
        out.write(0x01);
        out.write(0x04);
        out.write(0x00);
        out.write(0x00);
        out.write(0x00);
        out.write(0x00);
        out.write(0x64);
        out.write(0x00);
        out.write(0x00);
        return out.toByteArray();
    }

    /**
     * LINK-Request APDU：01 PIID 请求类型 心跳周期 date_time
     */
    public static byte[] buildLinkRequestApdu(int piid, int requestType, int heartbeatSec) {
        ByteArrayOutputStream out = new ByteArrayOutputStream(16);
        out.write(0x01);
        out.write(piid & 0xFF);
        out.write(requestType & 0xFF);
        out.write((heartbeatSec >> 8) & 0xFF);
        out.write(heartbeatSec & 0xFF);

        LocalDateTime now = LocalDateTime.now();
        out.write((now.getYear() >> 8) & 0xFF);
        out.write(now.getYear() & 0xFF);
        out.write(now.getMonthValue() & 0xFF);
        out.write(now.getDayOfMonth() & 0xFF);
        out.write(now.getDayOfWeek().getValue() & 0xFF);
        out.write(now.getHour() & 0xFF);
        out.write(now.getMinute() & 0xFF);
        out.write(now.getSecond() & 0xFF);
        int ms = now.getNano() / 1_000_000;
        out.write((ms >> 8) & 0xFF);
        out.write(ms & 0xFF);
        return out.toByteArray();
    }

    public static boolean isLinkResponseSuccess(byte[] apdu) {
        if (apdu == null || apdu.length < 3) {
            return false;
        }
        if ((apdu[0] & 0xFF) != 0x81) {
            return false;
        }
        return (apdu[2] & 0xFF) == 0x80;
    }

    public static boolean isConnectResponseSuccess(byte[] apdu) {
        if (apdu == null || apdu.length < 2) {
            return false;
        }
        if ((apdu[0] & 0xFF) != 0x82) {
            return false;
        }
        // 连接响应对象(允许建立应用连接)通常位于末尾 4 字节前
        // 00(连接响应对象) 00(认证附加信息) 00(FollowReport) 00(时间标签)
        int idx = apdu.length - 4;
        return idx >= 0 && (apdu[idx] & 0xFF) == 0x00;
    }

    /**
     * 客户机发起、用户数据、完整 APDU、无扰码：DIR=0 PRM=1 分帧=0 SC=0 FC=3
     */
    public static byte buildClientRequestUserDataControl() {
        return buildClientRequestUserDataControl(false);
    }

    public static byte buildClientRequestUserDataControl(boolean sc) {
        return (byte) (0x43 | (sc ? 0x08 : 0x00));
    }

    /**
     * GetRequestNormal：05 01 PIID OAD×4 00（无时间标签）
     */
    public static byte[] buildGetRequestNormalApdu(byte[] oad4, int piid) {
        byte[] apdu = new byte[8];
        apdu[0] = 0x05;
        apdu[1] = 0x01;
        apdu[2] = (byte) (piid & 0xFF);
        System.arraycopy(oad4, 0, apdu, 3, 4);
        apdu[7] = 0x00;
        return apdu;
    }

    public static byte[] meterAddressHexToBytes(String hex12) {
        if (hex12 == null || hex12.length() != 12) {
            throw new IllegalArgumentException("电表地址必须为12位16进制字符串");
        }
        byte[] addr = new byte[6];
        for (int i = 0; i < 6; i++) {
            int high = Character.digit(hex12.charAt(2 * i), 16);
            int low = Character.digit(hex12.charAt(2 * i + 1), 16);
            if (high < 0 || low < 0) {
                throw new IllegalArgumentException("电表地址含非法字符");
            }
            addr[i] = (byte) ((high << 4) | low);
        }
        return addr;
    }

    /**
     * 解析 GetResponseNormal 中 Data 的数值展示（电能量类按 XXXXXX.XX BCD；数值型按标度转换）
     */
    public static String parseReadApduToValue(byte[] apdu) {
        if (apdu == null || apdu.length < 8) {
            return "";
        }
        if ((apdu[0] & 0xFF) != 0x85) {
            return "";
        }
        if ((apdu[1] & 0xFF) != 0x01) {
            return "";
        }
        int o = 3 + 4;
        if (o >= apdu.length) {
            return "";
        }
        int getResultChoice = apdu[o] & 0xFF;
        o++;
        if (getResultChoice == 0x00) {
            return "";
        }
        if (getResultChoice == 0x01) {
            ParseTail tail = parseAxdrData(apdu, o);
            return tail == null ? "" : tail.text;
        }
        return "";
    }

    /**
     * 判断是否为目标 OAD 的 GET-ResponseNormal（85 01）
     */
    public static boolean isGetResponseForOad(byte[] apdu, byte[] oad4) {
        if (apdu == null || oad4 == null || oad4.length != 4) {
            return false;
        }
        if (apdu.length < 7) {
            return false;
        }
        if ((apdu[0] & 0xFF) != 0x85 || (apdu[1] & 0xFF) != 0x01) {
            return false;
        }
        for (int i = 0; i < 4; i++) {
            if (apdu[3 + i] != oad4[i]) {
                return false;
            }
        }
        return true;
    }

    private static final class ParseTail {
        final String text;
        final int nextOffset;

        ParseTail(String text, int nextOffset) {
            this.text = text;
            this.nextOffset = nextOffset;
        }
    }

    private static ParseTail parseAxdrData(byte[] apdu, int off) {
        if (off >= apdu.length) {
            return null;
        }
        int type = apdu[off] & 0xFF;
        switch (type) {
            case 0x09:
                if (off + 2 > apdu.length) {
                    return null;
                }
                int slen = apdu[off + 1] & 0xFF;
                if (off + 2 + slen > apdu.length) {
                    return null;
                }
                // DL698 自动根据 BCD 长度判断小数位（通常最后两位为小数）
                String bcd = bcdToEnergyDecimal(apdu, off + 2, slen);
                return new ParseTail(bcd, off + 2 + slen);
            case 0x05:
                if (off + 5 > apdu.length) {
                    return null;
                }
                long d = readBe32(apdu, off + 1);
                return new ParseTail(Long.toString(d), off + 5);
            case 0x12:
                if (off + 3 > apdu.length) {
                    return null;
                }
                int u = ((apdu[off + 1] & 0xFF) << 8) | (apdu[off + 2] & 0xFF);
                BigDecimal bd = BigDecimal.valueOf(u, 1);
                return new ParseTail(bd.stripTrailingZeros().toPlainString(), off + 3);
            case 0x01:
                if (off + 2 > apdu.length) {
                    return null;
                }
                int n = apdu[off + 1] & 0xFF;
                int p = off + 2;
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < n; i++) {
                    ParseTail el = parseAxdrData(apdu, p);
                    if (el == null) {
                        return null;
                    }
                    if (i > 0) {
                        sb.append(',');
                    }
                    sb.append(el.text);
                    p = el.nextOffset;
                }
                return new ParseTail(sb.toString(), p);
            default:
                return new ParseTail("", apdu.length);
        }
    }

    private static long readBe32(byte[] b, int off) {
        return ((long) (b[off] & 0xFF) << 24)
                | ((b[off + 1] & 0xFF) << 16)
                | ((b[off + 2] & 0xFF) << 8)
                | (b[off + 3] & 0xFF);
    }

    private static String bcdToEnergyDecimal(byte[] data, int off, int len) {
        if (len <= 0 || off + len > data.length) {
            return "";
        }
        StringBuilder digits = new StringBuilder();
        for (int i = 0; i < len; i++) {
            int v = data[off + i] & 0xFF;
            digits.append((v >> 4) & 0x0F);
            digits.append(v & 0x0F);
        }
        String numStr = digits.toString();
        if (numStr.isEmpty()) {
            return "";
        }
        String format = "XXXXXXXX.XX"; // 默认电能量格式：8字节BCD / 100
        int dot = format.indexOf('.');
        int intLen = dot;
        int decLen = format.length() - dot - 1;
        int totalLen = intLen + decLen;
        StringBuilder padded = new StringBuilder();
        for (int i = 0; i < totalLen - numStr.length(); i++) {
            padded.append('0');
        }
        padded.append(numStr);
        String paddedStr = padded.toString();
        if (paddedStr.length() < totalLen) {
            return numStr;
        }
        String s = paddedStr.substring(0, intLen) + "." + paddedStr.substring(intLen, intLen + decLen);
        try {
            return new BigDecimal(s).stripTrailingZeros().toPlainString();
        } catch (Exception e) {
            return s;
        }
    }
}
