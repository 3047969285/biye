package com.example.dl645.core;

import com.alibaba.fastjson2.JSONObject;
import com.example.dl645.core.parse.dl645.DL645Handler;
import com.example.dl645.untils.ByteUntil;
import lombok.extern.slf4j.Slf4j;

import java.util.*;

/**
 * DL645协议处理类（包含串口和网口） - 基于jSerialComm
 * @author wangchangzhen
 */
@Slf4j
public class DL645Protocol {
    private DL645SerialPort serialPort;
    private DL645TcpPort tcpPort;
    private String meterAddress;
    private ResponseListener customListener;

    public DL645Protocol() {
        this.serialPort = new DL645SerialPort();
        this.tcpPort = new DL645TcpPort();
    }
    /**
     * 设置自定义监听器
     * @param listener 自定义监听器
     */
    public void setResponseListener(ResponseListener listener) {
        this.customListener = listener;
    }

    /**
     * 扫描并连接电表
     */
    public boolean connect(String portName, int baudRate, String address) {
        this.meterAddress = address;
        ResponseListener listener = customListener != null ? customListener : buildListener("串口");
        return serialPort.open(portName, baudRate, listener);
    }

    /**
     * 通过TCP连接电表
     */
    public boolean connectTcp(String host, int port, int timeout, String address) {
        this.meterAddress = address;
        ResponseListener listener = customListener != null ? customListener : buildListener("TCP");
        return tcpPort.open(host, port, timeout, listener);
    }

    /**
     * 以TCP服务端模式接收连接（用于被动接收网口数据）
     */
    public boolean startTcpServer(int port, String address) {
        this.meterAddress = address;
        ResponseListener listener = customListener != null ? customListener : buildListener("TCP-Server");
        return tcpPort.openServer(port, listener);
    }

    /**
     * 断开连接
     */
    public void disconnect() {
        serialPort.close();
    }

    /**
     * 断开TCP连接
     */
    public void disconnectTcp() {
        tcpPort.close();
    }


    /**
     * 读取电压
     */
    public void sendCommand(byte[] dataIdentifier) {
        serialPort.sendReadCommand(meterAddress, dataIdentifier);
    }

    /**
     * TCP通道读取电压
     */
    public void sendCommandTcp(byte[] dataIdentifier) {
        tcpPort.sendReadCommand(meterAddress, dataIdentifier);
    }

    /**
     * 广播校时
     */
    public void broadcastTime() {
        boolean success = serialPort.sendBroadcastTime(new Date());
        if (success) {
            log.info("已发送广播校时命令");
        }
    }

    /**
     * TCP通道广播校时
     */
    public void broadcastTimeTcp() {
        boolean success = tcpPort.sendBroadcastTime(new Date());
        if (success) {
            log.info("已通过TCP发送广播校时命令");
        }
    }

    private ResponseListener buildListener(final String channel) {
        return new ResponseListener() {
            @Override
            public void onResponseReceived(byte[] response) {
                handleMeterResponse(response);
            }

            @Override
            public void onError(String errorMessage) {
                log.info("{}错误: {}", channel, errorMessage);
            }

            @Override
            public void onPortOpened(String portName) {
                log.info("{}已打开: {}", channel, portName);
            }

            @Override
            public void onPortClosed(String portName) {
                log.info("{}已关闭: {}", channel, portName);
            }

            @Override
            public void onDataAvailable(byte[] data) {
                log.info("{}原始数据: {}", channel, ByteUntil.bytesToHex(data));
            }
    
            @Override
            public void onDataSent(byte[] data, boolean success) {
                log.info("{}发送数据: {}, 成功: {}", channel, ByteUntil.bytesToHex(data), success);
            }
        };
    }

    /**
     * 处理电表响应
     */
    private void handleMeterResponse(byte[] response) {
        try {
            // 解析帧
            DL645Frame frame = DL645Frame.parse(response);
            if (frame == null) {
                log.info("帧解析失败");
                return;
            }
            // 获取数据标识
            byte[] dataId = extractDataIdentifier(frame.getData());
            if (dataId == null) {
                return;
            }
            // 根据数据标识解析数据
            Object parsedData = DL645Handler.parseResponse(frame.getData(), dataId);
            if (parsedData != null) {
                //todo:收到数据后
                log.info("收到数据{}", JSONObject.toJSONString(parsedData));
            }
        } catch (Exception e) {
            e.printStackTrace();
            log.error("处理响应异常: " + e.getMessage());
        }
    }

    /**
     * 从数据域提取数据标识
     */
    private byte[] extractDataIdentifier(byte[] data) {
        if (data == null || data.length < 4) {
            return null;
        }
        // 数据标识在数据域的前4个字节（需要减33H）
        byte[] rawDataId = new byte[4];
        System.arraycopy(data, 0, rawDataId, 0, 4);
        // 减33H
        byte[] dataId = new byte[4];
        for (int i = 0; i < 4; i++) {
            dataId[i] = (byte) ((rawDataId[i] & 0xFF) - 0x33);
        }
        return dataId;
    }


    /**
     * 获取可用串口列表
     */
    public static String[] getAvailablePorts() {
        return DL645SerialPort.getAvailablePorts();
    }
}
