package com.example.dl645.core;

import com.example.dl645.constant.DL645Constant;
import com.example.dl645.core.parse.dl645.DL645Handler;
import com.example.dl645.enums.SerialPortStatus;
import com.fazecast.jSerialComm.SerialPort;
import lombok.extern.slf4j.Slf4j;

import java.util.Date;

import static com.example.dl645.constant.DL645Constant.FRAME_START;

/**
 * DL645串口处理类
 *
 * @author wangchangzhen
 */
@Slf4j
public class DL645SerialPort {
    private SerialPort serialPort;
    private ResponseListener listener;
    private byte[] buffer = new byte[1024];
    private int bufferIndex = 0;
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
            serialPort = SerialPort.getCommPort(portName);

            if (serialPort == null) {
                if (listener != null) {
                    listener.onError("找不到串口: " + portName);
                }
                return false;
            }

            // 打开串口
            if (!serialPort.openPort()) {
                if (listener != null) {
                    listener.onError("打开串口失败: " + portName);
                }
                return false;
            }

            // 配置串口参数
            serialPort.setComPortParameters(baudRate, 8, 1, SerialPort.EVEN_PARITY);
            serialPort.setComPortTimeouts(SerialPort.TIMEOUT_READ_BLOCKING, 100, 0);

            running = true;
            readThread = new Thread(this::pollReceive, "DL645-Poll-" + portName);
            readThread.setDaemon(true);
            readThread.start();

            if (listener != null) {
                listener.onPortOpened(portName);
            }

            return true;

        } catch (Exception e) {
            e.printStackTrace();
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
            e.printStackTrace();
            if (listener != null) {
                listener.onError("发送数据失败: " + e.getMessage());
            }
            return false;
        }
    }

    /**
     * 发送读数据命令
     */
    public boolean sendReadCommand(String address, byte[] dataIdentifier) {
        byte[] request = DL645Handler.createReadRequest(address, dataIdentifier);
        // 与 TCP 一致：DL/T645 主站前导 4 字节 FE，便于与要求唤醒/前导的从站或模拟器互通
        byte[] wakeupAndRequest = new byte[4 + request.length];
        wakeupAndRequest[0] = (byte) 0xFE;
        wakeupAndRequest[1] = (byte) 0xFE;
        wakeupAndRequest[2] = (byte) 0xFE;
        wakeupAndRequest[3] = (byte) 0xFE;
        System.arraycopy(request, 0, wakeupAndRequest, 4, request.length);
        return send(wakeupAndRequest);
    }

    /**
     * 发送广播校时命令
     */
    public boolean sendBroadcastTime(Date date) {
        byte[] timeFrame = DL645Handler.createBroadcastTime(date);
        return send(timeFrame);
    }

    /**
     * 后台轮询接收数据
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
                        
                        // 增强日志:记录原始数据接收情况
                        if (data.length > 0) {
                            log.debug("[串口{}] 收到{}字节原始数据: {}", 
                                serialPort.getSystemPortName(),
                                data.length, 
                                bytesToHex(data));
                        }
                        
                        processReceivedData(data);
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
     * 处理接收到的数据（累积缓冲区模式）
     */
    private void processReceivedData(byte[] receivedData) {
        // 将新数据追加到缓冲区
        for (byte b : receivedData) {
            buffer[bufferIndex++] = b;

            // 防止缓冲区溢出
            if (bufferIndex >= buffer.length) {
                log.warn("串口缓冲区溢出，重置缓冲区");
                bufferIndex = 0;
                return;
            }
        }

        // 尝试从缓冲区中提取完整帧
        while (bufferIndex > 0) {
            // 查找起始符 0x68
            int frameStart = -1;
            for (int i = 0; i < bufferIndex; i++) {
                if (buffer[i] == FRAME_START) {
                    frameStart = i;
                    break;
                }
            }

            // 没有找到起始符，清空缓冲区
            if (frameStart == -1) {
                bufferIndex = 0;
                return;
            }

            // 如果起始符不在位置0，移动数据
            if (frameStart > 0) {
                System.arraycopy(buffer, frameStart, buffer, 0, bufferIndex - frameStart);
                bufferIndex -= frameStart;
            }

            // 检查是否有足够的数据判断帧长度
            if (bufferIndex < 10) {
                return;  // 等待更多数据
            }

            // 检查第二个起始符（位置7）
            if (buffer[7] != FRAME_START) {
                // 不是有效的 DL645 帧，跳过这个字节
                System.arraycopy(buffer, 1, buffer, 0, bufferIndex - 1);
                bufferIndex--;
                continue;
            }

            // 获取数据域长度
            int dataLength = buffer[9] & 0xFF;
            int frameLength = 12 + dataLength;  // 总长度 = 固定头(12) + 数据域

            // 检查是否接收完整
            if (bufferIndex < frameLength) {
                return;  // 等待更多数据
            }

            // 检查结束符
            if (buffer[frameLength - 1] != DL645Constant.FRAME_END) {
                log.warn("帧结束符不正确，跳过");
                System.arraycopy(buffer, 1, buffer, 0, bufferIndex - 1);
                bufferIndex--;
                continue;
            }

            // 提取完整帧
            byte[] frameData = new byte[frameLength];
            System.arraycopy(buffer, 0, frameData, 0, frameLength);

            // 验证帧有效性
            if (isValidFrame(frameData)) {
                if (listener != null) {
                    listener.onResponseReceived(frameData);
                }
                log.debug("成功解析完整帧: {} 字节", frameLength);
            }

            // 移除已处理的帧数据
            System.arraycopy(buffer, frameLength, buffer, 0, bufferIndex - frameLength);
            bufferIndex -= frameLength;
        }
    }

    /**
     * 验证帧有效性
     */
    private boolean isValidFrame(byte[] frameData) {
        if (frameData == null || frameData.length < 12) {
            return false;
        }

        // 检查帧起始符
        if (frameData[0] != FRAME_START ||
                frameData[7] != FRAME_START) {
            return false;
        }

        // 检查帧结束符
        if (frameData[frameData.length - 1] != DL645Constant.FRAME_END) {
            return false;
        }

        return true;
    }

    /**
     * 获取串口状态
     */
    public SerialPortStatus getPortStatus() {
        if (serialPort == null) {
            return SerialPortStatus.CLOSED;
        }

        try {
            return serialPort.isOpen() ? SerialPortStatus.OPEN : SerialPortStatus.CLOSED;
        } catch (Exception e) {
            return SerialPortStatus.ERROR;
        }
    }

    /**
     * 去除前导FE，提取DL645帧
     */
    public static byte[] extractFrame(byte[] rawData) {
        if (rawData == null) {
            return null;
        }

        // 1. 去掉所有前导的FE
        int startIndex = 0;
        while (startIndex < rawData.length && rawData[startIndex] == (byte) 0xFE) {
            startIndex++;
        }

        if (startIndex >= rawData.length) {
            return null; // 全是FE
        }

        // 2. 从第一个非FE字节开始查找DL645帧
        for (int i = startIndex; i <= rawData.length - 12; i++) {
            // 找到第一个0x68
            if (rawData[i] == FRAME_START) {
                // 检查7个字节后是否还有0x68
                if (i + 7 < rawData.length && rawData[i + 7] == FRAME_START) {
                    // 获取数据长度
                    int dataLength = rawData[i + 9] & 0xFF;
                    int frameLength = 12 + dataLength;

                    // 检查长度和结束符
                    if (i + frameLength <= rawData.length &&
                            rawData[i + frameLength - 1] == 0x16) {

                        // 提取帧
                        byte[] frame = new byte[frameLength];
                        System.arraycopy(rawData, i, frame, 0, frameLength);
                        return frame;
                    }
                }
            }
        }

        return null;
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
