package com.example.dl645.core;

import com.example.dl645.constant.DL645Constant;
import com.example.dl645.core.parse.dl645.DL645Handler;
import com.example.dl645.enums.SerialPortStatus;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Date;

import static com.example.dl645.constant.DL645Constant.FRAME_START;
/**
 * DL645 TCP处理类
 *
 * @author wangchangzhen
 */
public class DL645TcpPort {

    private Socket socket;
    private ServerSocket serverSocket;
    private ResponseListener listener;
    private final byte[] buffer = new byte[1024];
    private int bufferIndex = 0;
    private volatile boolean running = false;
    private Thread readThread;
    private Thread acceptThread;

    /**
     * 打开TCP连接
     */
    public boolean open(String host, int port, int timeout, ResponseListener listener) {
        close();
        this.listener = listener;
        try {
            socket = new Socket();
            socket.connect(new InetSocketAddress(host, port), timeout);
            running = true;
            startReadThread();
            if (listener != null) {
                listener.onPortOpened(host + ":" + port);
            }
            return true;
        } catch (IOException e) {
            if (listener != null) {
                listener.onError("打开TCP连接失败: " + e.getMessage());
            }
            return false;
        }
    }

    /**
     * 以服务端模式监听TCP连接
     */
    public boolean openServer(int port, ResponseListener listener) {
        close();
        this.listener = listener;
        try {
            serverSocket = new ServerSocket(port);
            running = true;
            if (listener != null) {
                listener.onPortOpened("0.0.0.0:" + port);
            }
            startAcceptThread();
            return true;
        } catch (IOException e) {
            if (listener != null) {
                listener.onError("启动TCP服务端失败: " + e);
            }
            return false;
        }
    }

    /**
     * 关闭TCP连接
     */
    public void close() {
        running = false;
        closeClientSocket();
        closeServerSocket();
    }

    /**
     * 发送数据
     */
    public boolean send(byte[] data) {
        if (socket == null || socket.isClosed() || !socket.isConnected()) {
            if (listener != null) {
                listener.onError("TCP连接未打开");
            }
            return false;
        }
        try {
            OutputStream outputStream = socket.getOutputStream();
            outputStream.write(data);
            outputStream.flush();
            return true;
        } catch (IOException e) {
            if (listener != null) {
                listener.onError("TCP发送数据失败: " + e.getMessage());
            }
            return false;
        }
    }

    /**
     * 发送读数据命令
     */
    public boolean sendReadCommand(String address, byte[] dataIdentifier) {
        byte[] request = DL645Handler.createReadRequest(address, dataIdentifier);
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
     * 获取TCP状态
     */
    public SerialPortStatus getPortStatus() {
        if (socket == null) {
            return SerialPortStatus.CLOSED;
        }
        try {
            return (socket.isConnected() && !socket.isClosed()) ? SerialPortStatus.OPEN : SerialPortStatus.CLOSED;
        } catch (Exception e) {
            return SerialPortStatus.ERROR;
        }
    }

    private void startReadThread() {
        readThread = new Thread(() -> {
            try {
                InputStream inputStream = socket.getInputStream();
                byte[] readBuffer = new byte[1024];
                while (running) {
                    int size = inputStream.read(readBuffer);
                    if (size <= 0) {
                        continue;
                    }
                    byte[] receivedData = new byte[size];
                    System.arraycopy(readBuffer, 0, receivedData, 0, size);
                    if (listener != null) {
                        listener.onDataAvailable(receivedData);
                    }
                    processReceivedData(receivedData);
                }
            } catch (IOException e) {
                if (running && listener != null) {
                    listener.onError("TCP接收数据失败: " + e.getMessage());
                }
            }
        }, "dl645-tcp-read-thread");
        readThread.setDaemon(true);
        readThread.start();
    }

    private void startAcceptThread() {
        acceptThread = new Thread(() -> {
            while (running) {
                try {
                    Socket acceptedSocket = serverSocket.accept();
                    closeClientSocket();
                    socket = acceptedSocket;
                    if (listener != null) {
                        listener.onPortOpened(socket.getRemoteSocketAddress().toString());
                    }
                    startReadThread();
                } catch (IOException e) {
                    if (running && listener != null) {
                        listener.onError("TCP服务端接收连接失败: " + e.getMessage());
                    }
                }
            }
        }, "dl645-tcp-accept-thread");
        acceptThread.setDaemon(true);
        acceptThread.start();
    }

    /**
     * 处理接收到的数据
     */
    private void processReceivedData(byte[] receivedData) {
        if (receivedData == null || receivedData.length == 0) {
            return;
        }

        // 先把新收到的数据追加到缓冲区，支持TCP分片场景
        for (byte b : receivedData) {
            if (bufferIndex >= buffer.length) {
                bufferIndex = 0;
            }
            buffer[bufferIndex++] = b;
        }

        while (true) {
            int start = -1;
            for (int i = 0; i <= bufferIndex - 12; i++) {
                if (buffer[i] == FRAME_START && buffer[i + 7] == FRAME_START) {
                    start = i;
                    break;
                }
            }
            if (start < 0) {
                if (bufferIndex > 0 && buffer[bufferIndex - 1] != FRAME_START) {
                    bufferIndex = 0;
                }
                return;
            }

            if (start > 0) {
                int remain = bufferIndex - start;
                System.arraycopy(buffer, start, buffer, 0, remain);
                bufferIndex = remain;
            }

            if (bufferIndex < 10) {
                return;
            }

            int dataLen = buffer[9] & 0xFF;
            int frameLen = 12 + dataLen;
            if (bufferIndex < frameLen) {
                return;
            }

            byte[] frameData = new byte[frameLen];
            System.arraycopy(buffer, 0, frameData, 0, frameLen);
            int remain = bufferIndex - frameLen;
            if (remain > 0) {
                System.arraycopy(buffer, frameLen, buffer, 0, remain);
            }
            bufferIndex = Math.max(remain, 0);

            if (isValidFrame(frameData) && listener != null) {
                listener.onResponseReceived(frameData);
            }
        }
    }

    /**
     * 验证帧有效性
     */
    private boolean isValidFrame(byte[] frameData) {
        if (frameData == null || frameData.length < 12) {
            return false;
        }
        if (frameData[0] != FRAME_START || frameData[7] != FRAME_START) {
            return false;
        }
        return frameData[frameData.length - 1] == DL645Constant.FRAME_END;
    }

    private void closeClientSocket() {
        if (socket != null) {
            try {
                socket.close();
                if (listener != null) {
                    listener.onPortClosed("tcp");
                }
            } catch (IOException e) {
                if (listener != null) {
                    listener.onError("关闭TCP连接失败: " + e.getMessage());
                }
            } finally {
                socket = null;
            }
        }
    }

    private void closeServerSocket() {
        if (serverSocket != null) {
            try {
                serverSocket.close();
                if (listener != null) {
                    listener.onPortClosed("tcp-server");
                }
            } catch (IOException e) {
                if (listener != null) {
                    listener.onError("关闭TCP服务端失败: " + e.getMessage());
                }
            } finally {
                serverSocket = null;
            }
        }
    }
}
