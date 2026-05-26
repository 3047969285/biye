package com.example.dl645.core;

import com.example.dl645.constant.DL645Constant;
import lombok.Getter;
import lombok.Setter;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

import static com.example.dl645.constant.DL645Constant.ADDRESS_LENGTH;
import static com.example.dl645.constant.DL645Constant.ADDRESS_LENGTH_HEX;

/**
 * @Author bo
 * @Date 2025 12 24 08 59
 * @description 完整dl645帧
 **/
public class DL645Frame {
    /**
     * 帧起始符
     */
    private byte frameStart = DL645Constant.FRAME_START;

    /**
     * 电表地址 (6字节，BCD码，低位在前)
     */
    @Getter
    private byte[] address = new byte[ADDRESS_LENGTH];

    /**
     * 帧起始符重复
     */
    private byte frameStart2 = DL645Constant.FRAME_START;

    /**
     * 控制码
     */
    @Getter
    @Setter
    private byte controlCode;

    /**
     * 数据域长度
     */
    private byte dataLength;

    /**
     * 数据域
     */
    @Getter
    private byte[] data;

    /**
     * 校验码
     */
    private byte cs;

    /**
     * 帧结束符
     */
    private byte frameEnd = DL645Constant.FRAME_END;


    public DL645Frame() {
        // 默认地址为广播地址
        this.address = new byte[]{(byte) 0xAA, (byte) 0xAA, (byte) 0xAA, (byte) 0xAA, (byte) 0xAA, (byte) 0xAA};
    }

    public DL645Frame(byte[] address, byte controlCode, byte[] data) {
        setAddress(address);
        this.controlCode = controlCode;
        setData(data);
    }

    /**
     * 设置地址
     *
     * @param address 地址
     */
    public void setAddress(byte[] address) {
        if (address.length == ADDRESS_LENGTH) {
            this.address = address;
        } else if (address.length == ADDRESS_LENGTH_HEX) {
            // 如果是字符串形式的地址（如：123456789012）
            for (int i = 0; i < ADDRESS_LENGTH; i++) {
                int high = Character.digit((char) address[i * 2], 16);
                int low = Character.digit((char) address[i * 2 + 1], 16);
                this.address[i] = (byte) ((high << 4) | low);
            }
        }
    }

    /**
     * 获取反转的地址（DL645协议地址需要反转）
     * 低位在前
     *
     * @return
     */
    public byte[] getReversedAddress() {
        byte[] reversed = new byte[ADDRESS_LENGTH];
        for (int i = 0; i < ADDRESS_LENGTH; i++) {
            reversed[i] = address[5 - i];
        }
        return reversed;
    }

    /**
     * 设置数据
     *
     * @param data
     */
    public void setData(byte[] data) {
        this.data = data;
        this.dataLength = (byte) (data != null ? data.length : 0);
    }

    /**
     * 计算校验码
     *
     * @return
     */
    private byte calculateCS() {

        int sum = 0;
        sum += frameStart & 0xFF;
        // 地址域
        byte[] addressForFrame = getReversedAddress();
        for (byte b : addressForFrame) {
            sum += b & 0xFF;
        }
        // 第二个帧起始符
        sum += frameStart2 & 0xFF;

        // 控制码
        sum += controlCode & 0xFF;

        // 数据长度
        sum += dataLength & 0xFF;

        // 数据域
        if (data != null) {
            for (byte b : data) {
                sum += b & 0xFF;
            }
        }

        // 取低8位
        return (byte) (sum & 0xFF);
    }

    /**
     * 构建完整的帧数据
     *
     * @return
     */
    public byte[] build() {
        // 计算校验码
        this.cs = calculateCS();

        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        try {
            // 帧起始符
            baos.write(frameStart);
            // 地址（反转后）
            baos.write(getReversedAddress());
            // 帧起始符重复
            baos.write(frameStart2);
            // 控制码
            baos.write(controlCode);
            // 数据长度
            baos.write(dataLength);
            // 数据域
            if (data != null && data.length > 0) {
                baos.write(data);
            }
            // 校验码
            baos.write(cs);
            // 帧结束符
            baos.write(frameEnd);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return baos.toByteArray();
    }

    /**
     * 从字节数组解析帧
     *
     * @param frameData
     * @return
     */
    public static DL645Frame parse(byte[] frameData) {
        if (frameData == null || frameData.length < ADDRESS_LENGTH_HEX) {
            return null;
        }

        if (frameData[0] != DL645Constant.FRAME_START ||
                frameData[7] != DL645Constant.FRAME_START) {
            return null;
        }

        DL645Frame frame = new DL645Frame();

        // 解析地址（需要反转回来）
        byte[] reversedAddr = new byte[ADDRESS_LENGTH];
        System.arraycopy(frameData, 1, reversedAddr, 0, ADDRESS_LENGTH);
        byte[] addr = new byte[ADDRESS_LENGTH];
        for (int i = 0; i < ADDRESS_LENGTH; i++) {
            addr[i] = reversedAddr[5 - i];
        }
        frame.setAddress(addr);

        // 解析控制码
        frame.controlCode = frameData[8];

        // 解析数据长度
        int dataLen = frameData[9] & 0xFF;
        frame.dataLength = frameData[9];

        // 解析数据域
        if (dataLen > 0 && frameData.length >= 11 + dataLen) {
            byte[] data = new byte[dataLen];
            System.arraycopy(frameData, 10, data, 0, dataLen);
            frame.setData(data);
        }

        // 验证校验码
        byte expectedCS = frame.calculateCS();
        byte actualCS = frameData[10 + dataLen];
        if (expectedCS != actualCS) {
            return null;
        }

        return frame;
    }

}
