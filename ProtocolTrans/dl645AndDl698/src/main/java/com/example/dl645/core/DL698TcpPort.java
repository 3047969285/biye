package com.example.dl645.core;

import com.example.dl645.constant.DL698Contant;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.util.Arrays;

/**
 * DL698 TCP 通道
 */
public class DL698TcpPort {

    private Socket socket;
    private ResponseListener listener;
    private final byte[] buffer = new byte[4096];
    private int bufferLen = 0;
    private volatile boolean running = false;
    private Thread readThread;

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
        } catch (SocketTimeoutException e) {
            String errMsg = String.format("连接超时 [%s:%d] timeout=%dms", host, port, timeout);
            System.err.println("错误: " + errMsg);
            if (listener != null) {
                listener.onError(errMsg);
            }
            return false;
        } catch (IOException e) {
            String errMsg = "打开TCP连接失败: " + e.getMessage();
            System.err.println("错误: " + errMsg);
            e.printStackTrace();
            if (listener != null) {
                listener.onError(errMsg);
            }
            return false;
        }
    }

    public void close() {
        running = false;
        bufferLen = 0;
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

    public boolean send(byte[] data) {
        if (socket == null || socket.isClosed() || !socket.isConnected()) {
            if (listener != null) {
                listener.onError("TCP连接未打开");
            }
            return false;
        }
        try {
            OutputStream os = socket.getOutputStream();
            os.write(data);
            os.flush();
            return true;
        } catch (IOException e) {
            if (listener != null) {
                listener.onError("TCP发送数据失败: " + e.getMessage());
            }
            return false;
        }
    }

    private void startReadThread() {
        readThread = new Thread(() -> {
            try {
                InputStream is = socket.getInputStream();
                byte[] readBuf = new byte[2048];
                while (running) {
                    int n = is.read(readBuf);
                    if (n <= 0) {
                        continue;
                    }
                    byte[] chunk = Arrays.copyOf(readBuf, n);
                    if (listener != null) {
                        listener.onDataAvailable(chunk);
                    }
                    appendAndExtract(chunk);
                }
            } catch (IOException e) {
                if (running && listener != null) {
                    listener.onError("TCP接收数据失败: " + e.getMessage());
                }
            }
        }, "dl698-tcp-read-thread");
        readThread.setDaemon(true);
        readThread.start();
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
     *有效帧前可有 4 个 FEH 前导
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
}
