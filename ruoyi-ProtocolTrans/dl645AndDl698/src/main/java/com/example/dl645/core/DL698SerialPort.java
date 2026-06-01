package com.example.dl645.core;

import com.example.dl645.constant.DL698Contant;
import com.fazecast.jSerialComm.SerialPort;
import lombok.extern.slf4j.Slf4j;

import java.util.Arrays;

/**
 * DL698 串口通道
 */
@Slf4j
public class DL698SerialPort {

    private SerialPort serialPort;
    private ResponseListener listener;
    private final byte[] buffer = new byte[4096];
    private int bufferLen = 0;
    private Thread readThread;
    private volatile boolean running = false;

    /**
     * 获取可用串口列表
     */
    public static String[] getAvailablePorts() {
        SerialPort[] ports = SerialPort.getCommPorts();
        String[] portNames = new String[ports.length];
        for (int i = 0; i < ports.length; i++) {
            portNames[i] = ports[i].getSystemPortName();
        }
        return portNames;
    }

    /**
     * 打开串口
     */
    public boolean open(String portName, int baudRate, ResponseListener listener) {
        this.listener = listener;

        try {
            SerialPort[] ports = SerialPort.getCommPorts();
            for (SerialPort port : ports) {
                if (port.getSystemPortName().equals(portName)) {
                    serialPort = port;
                    break;
                }
            }

            if (serialPort == null) {
                if (listener != null) {
                    listener.onError("找不到串口: " + portName);
                }
                return false;
            }

            if (!serialPort.openPort()) {
                if (listener != null) {
                    listener.onError("打开串口失败: " + portName);
                }
                return false;
            }

            serialPort.setComPortParameters(baudRate, 8, 1, SerialPort.EVEN_PARITY);
            serialPort.setComPortTimeouts(SerialPort.TIMEOUT_READ_BLOCKING, 100, 0);

            running = true;
            readThread = new Thread(this::pollReceive, "DL698-Poll-" + portName);
            readThread.setDaemon(true);
            readThread.start();

            if (listener != null) {
                listener.onPortOpened(portName);
            }

            return true;
        } catch (Exception e) {
            log.error("[串口{}] 打开异常: {}", portName, e.getMessage(), e);
            if (listener != null) {
                listener.onError("串口异常: " + e.getMessage());
            }
            return false;
        }
    }

    /**
     * 关闭串口
     */
    public void close() {
        running = false;
        bufferLen = 0;
        if (readThread != null) {
            readThread.interrupt();
        }
        if (serialPort != null && serialPort.isOpen()) {
            serialPort.closePort();
            if (listener != null) {
                listener.onPortClosed(serialPort.getSystemPortName());
            }
        }
    }

    /**
     * 发送数据
     */
    public boolean send(byte[] data) {
        if (serialPort == null || !serialPort.isOpen()) {
            if (listener != null) {
                listener.onError("串口未打开");
            }
            return false;
        }

        try {
            int bytesWritten = serialPort.writeBytes(data, data.length);
            boolean success = bytesWritten == data.length;
            if (listener != null) {
                listener.onDataSent(data, success);
            }
            return success;
        } catch (Exception e) {
            log.error("[串口{}] 发送失败: {}", serialPort.getSystemPortName(), e.getMessage());
            if (listener != null) {
                listener.onError("发送数据失败: " + e.getMessage());
            }
            return false;
        }
    }

    /**
     * 轮询接收数据
     */
    private void pollReceive() {
        while (running) {
            try {
                int bytesAvailable = serialPort.bytesAvailable();
                if (bytesAvailable > 0) {
                    byte[] receivedData = new byte[bytesAvailable];
                    int bytesRead = serialPort.readBytes(receivedData, bytesAvailable);

                    if (bytesRead > 0) {
                        byte[] data = receivedData;
                        if (bytesRead < bytesAvailable) {
                            data = new byte[bytesRead];
                            System.arraycopy(receivedData, 0, data, 0, bytesRead);
                        }

                        if (listener != null) {
                            listener.onDataAvailable(data);
                        }

                        log.debug("[串口{}] 收到{}字节: {}", 
                            serialPort.getSystemPortName(),
                            data.length, 
                            bytesToHex(data));

                        appendAndExtract(data);
                    }
                } else {
                    Thread.sleep(20);
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                break;
            } catch (Exception e) {
                if (listener != null) {
                    listener.onError("轮询异常: " + e.getMessage());
                }
                log.error("[串口{}] 轮询异常: {}", serialPort.getSystemPortName(), e.getMessage());
            }
        }
    }

    /**
     * 长度域 L：用户数据区长度（控制域至 FCS，含 FCS），帧格式 68 L L ... 16
     */
    private void appendAndExtract(byte[] data) {
        for (byte b : data) {
            if (bufferLen >= buffer.length) {
                bufferLen = 0;
            }
            buffer[bufferLen++] = b;
        }

        int guard = 0;
        while (bufferLen >= 4 && guard++ < 256) {
            trimLeadingFePrefix();
            int p = indexOfFrameStart(0);
            if (p < 0) {
                bufferLen = 0;
                return;
            }
            if (p > 0) {
                System.arraycopy(buffer, p, buffer, 0, bufferLen - p);
                bufferLen -= p;
            }
            if (bufferLen < 4) {
                return;
            }
            int L = (buffer[1] & 0xFF) | ((buffer[2] & 0x3F) << 8);
            int need = 2 + L;
            if (bufferLen < need) {
                return;
            }
            if ((buffer[need - 1] & 0xFF) != (DL698Contant.FRAME_END & 0xFF)) {
                System.arraycopy(buffer, 1, buffer, 0, bufferLen - 1);
                bufferLen--;
                continue;
            }
            byte[] frame = Arrays.copyOfRange(buffer, 0, need);
            System.arraycopy(buffer, need, buffer, 0, bufferLen - need);
            bufferLen -= need;
            if (listener != null) {
                listener.onResponseReceived(frame);
            }
        }
    }

    private int indexOfFrameStart(int from) {
        for (int i = from; i < bufferLen; i++) {
            if (buffer[i] == DL698Contant.FRAME_START) {
                return i;
            }
        }
        return -1;
    }

    /**
     * 有效帧前可有 4 个 FEH 前导
     */
    private void trimLeadingFePrefix() {
        int p = 0;
        while (p < bufferLen && (buffer[p] & 0xFF) == 0xFE) {
            p++;
        }
        if (p > 0) {
            System.arraycopy(buffer, p, buffer, 0, bufferLen - p);
            bufferLen -= p;
        }
    }

    /**
     * 字节数组转十六进制字符串
     */
    private String bytesToHex(byte[] bytes) {
        if (bytes == null || bytes.length == 0) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02X ", b));
        }
        return sb.toString().trim();
    }
}
