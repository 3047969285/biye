package com.example.dl645.core;

import com.example.dl645.constant.DL698Contant;
import com.example.dl645.core.parse.Crc16;
import lombok.Getter;
import lombok.Setter;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

/**
 * DL/T 698.45-2017 链路层帧（68H … 16H）
 * 长度域 L：bit0~bit13 为帧数据长度（不含起始符 68H、结束符 16H）；低字节在前。
 * 地址域：地址特征低 4 位编码为「服务器地址字节数−1」（1~16 字节）。
 * HCS：对「L+C+地址域」计算 FCS-16；FCS：对「L+C+地址域+HCS+链路用户数据」计算。
 */
public class DL698Frame {

    private byte frameStart = DL698Contant.FRAME_START;

    /**
     * 帧数据长度（不含 68H、16H），即 L 域的 bit0~bit13
     */
    @Getter
    @Setter
    private int lengthField;

    @Getter
    @Setter
    private byte controlField;

    @Getter
    @Setter
    private byte addressType;

    /**
     * 服务器地址逻辑地址（bit4~bit5）
     */
    @Getter
    @Setter
    private byte logicAddress;

    @Getter
    private byte[] serverAddress;

    @Getter
    @Setter
    private byte clientAddress;

    private byte[] hcs = new byte[2];
    private byte[] fcs = new byte[2];

    @Getter
    private byte[] apduData;

    private byte frameEnd = DL698Contant.FRAME_END;

    public DL698Frame() {
        this.serverAddress = new byte[0];
        this.clientAddress = 0x00;
        this.logicAddress = 0x00;
    }

    public DL698Frame(byte controlField, byte[] serverAddress, byte clientAddress, byte[] apduData) {
        this.controlField = controlField;
        this.serverAddress = serverAddress;
        this.clientAddress = clientAddress;
        setApduData(apduData);
    }

    public void setServerAddress(byte[] serverAddress) {
        if (serverAddress != null && serverAddress.length <= DL698Contant.SERVER_ADDRESS_MAX_LENGTH) {
            this.serverAddress = serverAddress;
            if (this.apduData != null) {
                this.lengthField = computeFramePayloadLength();
            }
        }
    }

    public void setApduData(byte[] apduData) {
        this.apduData = apduData;
        this.lengthField = computeFramePayloadLength();
    }

    /**
     * L = 2(L域) + 1(C) + (1+SA+1)(地址域) + 2(HCS) + APDU + 2(FCS)
     */
    private int computeFramePayloadLength() {
        int n = serverAddress != null ? serverAddress.length : 0;
        int apduLen = apduData != null ? apduData.length : 0;
        return 9 + n + apduLen;
    }

    private byte[] buildAddressFieldBytes() {
        int n = serverAddress != null ? serverAddress.length : 0;
        if (n < 1 || n > 16) {
            throw new IllegalStateException("服务器地址长度须为1~16字节");
        }
        int encLen = n - 1;
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        try {
            baos.write(((addressType & 0x03) << 6) | ((logicAddress & 0x03) << 4) | (encLen & 0x0F));
            baos.write(serverAddress);
            baos.write(clientAddress);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        return baos.toByteArray();
    }

    private void writeLengthLe(ByteArrayOutputStream baos, int L) throws IOException {
        if (L < 0 || L > 0x3FFF) {
            throw new IllegalStateException("帧数据长度超出14位范围");
        }
        baos.write(L & 0xFF);
        baos.write((L >>> 8) & 0x3F);
    }

    /**
     * 构建完整帧
     */
    public byte[] build() {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        try {
            byte[] addrField = buildAddressFieldBytes();
            int L = lengthField;
            baos.write(frameStart);
            writeLengthLe(baos, L);
            baos.write(controlField);
            baos.write(addrField);

            byte[] hcsInput = new byte[2 + 1 + addrField.length];
            hcsInput[0] = (byte) (L & 0xFF);
            hcsInput[1] = (byte) ((L >>> 8) & 0x3F);
            hcsInput[2] = controlField;
            System.arraycopy(addrField, 0, hcsInput, 3, addrField.length);
            int hcsVal = Crc16.computeFcs(hcsInput, 0, hcsInput.length);
            this.hcs = new byte[2];
            Crc16.writeLe(hcsVal, this.hcs, 0);
            baos.write(this.hcs);

            if (apduData != null && apduData.length > 0) {
                baos.write(apduData);
            }

            byte[] pre = baos.toByteArray();
            int fcsInputLen = pre.length - 1;
            int fcsVal = Crc16.computeFcs(pre, 1, fcsInputLen);
            this.fcs = new byte[2];
            Crc16.writeLe(fcsVal, this.fcs, 0);
            baos.write(this.fcs);
            baos.write(frameEnd);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        return baos.toByteArray();
    }

    public static DL698Frame parse(byte[] frameData) {
        if (frameData == null || frameData.length < 12) {
            return null;
        }
        if (frameData[0] != DL698Contant.FRAME_START) {
            return null;
        }
        int L = (frameData[1] & 0xFF) | ((frameData[2] & 0x3F) << 8);
        int totalExpect = 2 + L;
        if (frameData.length < totalExpect || frameData[totalExpect - 1] != DL698Contant.FRAME_END) {
            return null;
        }

        DL698Frame frame = new DL698Frame();
        frame.lengthField = L;
        int offset = 3;
        frame.controlField = frameData[offset++];

        int addrTypeAndLen = frameData[offset] & 0xFF;
        frame.addressType = (byte) ((addrTypeAndLen >> 6) & 0x03);
        frame.logicAddress = (byte) ((addrTypeAndLen >> 4) & 0x03);
        int encLen = addrTypeAndLen & 0x0F;
        int serverAddrLen = encLen + 1;
        offset++;

        frame.serverAddress = new byte[serverAddrLen];
        System.arraycopy(frameData, offset, frame.serverAddress, 0, serverAddrLen);
        offset += serverAddrLen;

        frame.clientAddress = frameData[offset++];

        frame.hcs = new byte[2];
        frame.hcs[0] = frameData[offset];
        frame.hcs[1] = frameData[offset + 1];
        offset += 2;

        byte[] hcsInput = new byte[2 + 1 + 1 + serverAddrLen + 1];
        hcsInput[0] = (byte) (L & 0xFF);
        hcsInput[1] = (byte) ((L >>> 8) & 0x3F);
        hcsInput[2] = frame.controlField;
        hcsInput[3] = (byte) addrTypeAndLen;
        System.arraycopy(frame.serverAddress, 0, hcsInput, 4, serverAddrLen);
        hcsInput[4 + serverAddrLen] = frame.clientAddress;
        int hcsCalc = Crc16.computeFcs(hcsInput, 0, hcsInput.length);
        byte[] hcsExpected = new byte[2];
        Crc16.writeLe(hcsCalc, hcsExpected, 0);
        if (hcsExpected[0] != frame.hcs[0] || hcsExpected[1] != frame.hcs[1]) {
            return null;
        }

        int apduLen = L - 9 - serverAddrLen;
        if (apduLen < 0 || offset + apduLen + 2 > frameData.length) {
            return null;
        }
        if (apduLen > 0) {
            frame.apduData = new byte[apduLen];
            System.arraycopy(frameData, offset, frame.apduData, 0, apduLen);
            offset += apduLen;
        }

        frame.fcs = new byte[2];
        frame.fcs[0] = frameData[offset];
        frame.fcs[1] = frameData[offset + 1];

        if (!Crc16.verifyFcs(frameData, 1, L)) {
            return null;
        }

        return frame;
    }

    public byte getDIR() {
        return (byte) ((controlField >> 7) & 0x01);
    }

    public byte getPRM() {
        return (byte) ((controlField >> 6) & 0x01);
    }

    public byte getFrameFlag() {
        return (byte) ((controlField >> 5) & 0x01);
    }

    public byte getSC() {
        return (byte) ((controlField >> 3) & 0x01);
    }

    public byte getFunctionCode() {
        return (byte) (controlField & 0x07);
    }
}
