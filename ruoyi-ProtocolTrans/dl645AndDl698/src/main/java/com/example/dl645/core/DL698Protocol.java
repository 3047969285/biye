package com.example.dl645.core;

import com.example.dl645.core.parse.dl698.DL698Handler;
import lombok.extern.slf4j.Slf4j;

/**
 * DL698协议（串口和TCP）- 基于jSerialComm
 */
@Slf4j
public class DL698Protocol {

    private final DL698TcpPort tcpPort = new DL698TcpPort();
    private final DL698SerialPort serialPort = new DL698SerialPort();
    private ResponseListener customListener;

    public void setResponseListener(ResponseListener listener) {
        this.customListener = listener;
    }

    // ==================== TCP 相关 ====================

    public boolean connectTcp(String host, int port, int timeout) {
        ResponseListener listener = customListener != null ? customListener : buildDefaultListener("TCP");
        return tcpPort.open(host, port, timeout, listener);
    }

    public void disconnectTcp() {
        tcpPort.close();
    }

    public void sendReadTcp(byte[] serverAddress, byte clientAddress, byte[] oad4) {
        byte[] frame = DL698Handler.buildReadRequest(serverAddress, clientAddress, oad4);
        tcpPort.send(frame);
    }

    public void sendReadTcp(byte[] serverAddress, byte clientAddress, byte[] oad4, byte logicAddress, boolean sc) {
        byte[] frame = DL698Handler.buildReadRequest(serverAddress, clientAddress, oad4, 0x01, logicAddress, sc);
        tcpPort.send(frame);
    }

    public void sendLinkTcp(byte[] serverAddress, byte clientAddress) {
        byte[] frame = DL698Handler.buildLinkRequest(serverAddress, clientAddress);
        tcpPort.send(frame);
    }

    public void sendLinkTcp(byte[] serverAddress, byte clientAddress, byte logicAddress, boolean sc) {
        byte[] frame = DL698Handler.buildLinkRequest(serverAddress, clientAddress, logicAddress, sc);
        tcpPort.send(frame);
    }

    public void sendConnectTcp(byte[] serverAddress, byte clientAddress) {
        byte[] frame = DL698Handler.buildConnectRequest(serverAddress, clientAddress);
        tcpPort.send(frame);
    }

    public void sendConnectTcp(byte[] serverAddress, byte clientAddress, byte logicAddress, boolean sc) {
        byte[] frame = DL698Handler.buildConnectRequest(serverAddress, clientAddress, logicAddress, sc);
        tcpPort.send(frame);
    }

    // ==================== 串口相关 ====================

    public boolean connectSerial(String portName, int baudRate, int timeout) {
        ResponseListener listener = customListener != null ? customListener : buildDefaultListener("串口");
        return serialPort.open(portName, baudRate, listener);
    }

    public void disconnectSerial() {
        serialPort.close();
    }

    public void sendReadSerial(byte[] serverAddress, byte clientAddress, byte[] oad4) {
        byte[] frame = DL698Handler.buildReadRequest(serverAddress, clientAddress, oad4);
        serialPort.send(frame);
    }

    public void sendReadSerial(byte[] serverAddress, byte clientAddress, byte[] oad4, byte logicAddress, boolean sc) {
        byte[] frame = DL698Handler.buildReadRequest(serverAddress, clientAddress, oad4, 0x01, logicAddress, sc);
        serialPort.send(frame);
    }

    public void sendLinkSerial(byte[] serverAddress, byte clientAddress) {
        byte[] frame = DL698Handler.buildLinkRequest(serverAddress, clientAddress);
        serialPort.send(frame);
    }

    public void sendLinkSerial(byte[] serverAddress, byte clientAddress, byte logicAddress, boolean sc) {
        byte[] frame = DL698Handler.buildLinkRequest(serverAddress, clientAddress, logicAddress, sc);
        serialPort.send(frame);
    }

    public void sendConnectSerial(byte[] serverAddress, byte clientAddress) {
        byte[] frame = DL698Handler.buildConnectRequest(serverAddress, clientAddress);
        serialPort.send(frame);
    }

    public void sendConnectSerial(byte[] serverAddress, byte clientAddress, byte logicAddress, boolean sc) {
        byte[] frame = DL698Handler.buildConnectRequest(serverAddress, clientAddress, logicAddress, sc);
        serialPort.send(frame);
    }

    // ==================== 辅助方法 ====================

    private ResponseListener buildDefaultListener(final String channel) {
        return new ResponseListener() {
            @Override
            public void onResponseReceived(byte[] response) {
                log.info("DL698 {} 收到响应", channel);
            }

            @Override
            public void onError(String errorMessage) {
                log.info("DL698 {} 错误: {}", channel, errorMessage);
            }

            @Override
            public void onPortOpened(String portName) {
                log.info("DL698 {} 已打开: {}", channel, portName);
            }

            @Override
            public void onPortClosed(String portName) {
                log.info("DL698 {} 已关闭: {}", channel, portName);
            }

            @Override
            public void onDataAvailable(byte[] data) {
            }
        };
    }
}
