package com.example.modbus.config;

import com.example.modbus.exception.ModbusClientException;
import com.serotonin.modbus4j.ModbusFactory;
import com.serotonin.modbus4j.ModbusMaster;
import com.serotonin.modbus4j.exception.ModbusInitException;
import com.serotonin.modbus4j.ip.IpParameters;
import com.serotonin.modbus4j.serial.SerialPortWrapper;
import lombok.extern.slf4j.Slf4j;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * @Author bo
 * @Date 2025 12 23 10 31
 * @description Modbus连接池管理器 使用享元模式管理连接
 **/
@Slf4j
public class ModbusConnectionPool {
    /**
     * Modbus工厂实例，用于创建ModbusMaster连接对象
     */
    private static final ModbusFactory MODBUS_FACTORY = new ModbusFactory();

    /**
     * Modbus连接缓存池
     * Key: 连接标识符（如 "tcp:192.168.1.100:502" 或 "serial:COM1:9600:8:1:0"）
     * Value: ModbusMaster连接实例
     */
    private final Map<String, ModbusMaster> connections = new ConcurrentHashMap<>();
    /**
     * 连接引用计数器
     * Key: 连接标识符
     * Value: 当前使用该连接的引用数（线程安全计数器）
     * 用于实现连接复用：当引用数为0时，连接可被关闭
     */
    private final Map<String, AtomicInteger> refCounts = new ConcurrentHashMap<>();
    /**
     * 连接最后使用时间记录
     * Key: 连接标识符
     * Value: 最后一次使用的时间戳（System.currentTimeMillis()）
     * 用于空闲连接检测和清理
     */
    private final Map<String, Long> lastUsedTime = new ConcurrentHashMap<>();

    /**
     * 连接配置参数
     * 包含：超时时间、重试次数、最大连接数、空闲超时时间等
     */
    private final ConnectionConfig config;

    /**
     * 定时任务调度器
     */
    private final ScheduledExecutorService cleanupScheduler;

    public ModbusConnectionPool(ConnectionConfig config) {
        this.config = config;
        this.cleanupScheduler = Executors.newSingleThreadScheduledExecutor(
                r -> new Thread(r, "modbus-connection-cleaner")
        );

        startCleanupTask();
    }

    /**
     * 获取TCP连接
     */
    public ModbusMaster getConnection(String host, int port) throws ModbusClientException {
        String key = getTcpConnectionKey(host, port);

        AtomicInteger refCount = refCounts.computeIfAbsent(key, k -> new AtomicInteger(0));
        refCount.incrementAndGet();
        lastUsedTime.put(key, System.currentTimeMillis());

        try {
            return connections.computeIfAbsent(key, k -> createNewTcpConnection(host, port));
        } catch (RuntimeException e) {
            if (refCount.decrementAndGet() <= 0) {
                refCounts.remove(key);
                lastUsedTime.remove(key);
            }
            throw new ModbusClientException("创建Modbus TCP连接失败: " + e.getMessage(), e);
        }
    }

    /**
     * 获取串口连接
     */
    public ModbusMaster getSerialConnection(String serialPort, int baudRate, int dataBits,
                                            int stopBits, int parity) throws ModbusClientException {
        String key = getSerialConnectionKey(serialPort, baudRate, dataBits, stopBits, parity);

        AtomicInteger refCount = refCounts.computeIfAbsent(key, k -> new AtomicInteger(0));
        refCount.incrementAndGet();
        lastUsedTime.put(key, System.currentTimeMillis());

        try {
            return connections.computeIfAbsent(key, k -> createNewSerialConnection(
                    serialPort, baudRate, dataBits, stopBits, parity));
        } catch (RuntimeException e) {
            if (refCount.decrementAndGet() <= 0) {
                refCounts.remove(key);
                lastUsedTime.remove(key);
            }
            throw new ModbusClientException("创建Modbus RTU连接失败: " + e.getMessage(), e);
        }
    }

    /**
     * 释放TCP连接引用
     */
    public void releaseConnection(String host, int port) {
        String key = getTcpConnectionKey(host, port);
        releaseConnectionByKey(key);
    }

    /**
     * 释放串口连接引用
     */
    public void releaseSerialConnection(String serialPort, int baudRate, int dataBits,
                                        int stopBits, int parity) {
        String key = getSerialConnectionKey(serialPort, baudRate, dataBits, stopBits, parity);
        releaseConnectionByKey(key);
    }

    private void releaseConnectionByKey(String key) {
        AtomicInteger refCount = refCounts.get(key);

        if (refCount != null && refCount.decrementAndGet() <= 0) {
            refCounts.remove(key);
            lastUsedTime.remove(key);
        }
    }

    /**
     * 创建新的TCP连接
     */
    private ModbusMaster createNewTcpConnection(String host, int port) {
        try {
            if (host == null || host.trim().isEmpty()) {
                throw new IllegalArgumentException("Modbus主机地址不能为空");
            }
            if (port <= 0 || port > 65535) {
                throw new IllegalArgumentException("Modbus端口非法: " + port);
            }
            IpParameters params = new IpParameters();
            params.setHost(host);
            params.setPort(port);

            ModbusMaster master = MODBUS_FACTORY.createTcpMaster(params, config.isEncapsulated());
            master.setTimeout(config.getTimeout());
            master.setRetries(config.getRetries());
            master.init();

            log.debug("创建Modbus TCP连接: {}:{}", host, port);
            return master;

        } catch (ModbusInitException e) {
            throw new RuntimeException("初始化Modbus TCP连接失败", e);
        }
    }

    /**
     * 创建新的串口连接
     */
    private ModbusMaster createNewSerialConnection(String serialPort, int baudRate,
                                                   int dataBits, int stopBits, int parity) {
        try {
            if (serialPort == null || serialPort.trim().isEmpty()) {
                throw new IllegalArgumentException("串口号不能为空");
            }
            if (baudRate <= 0) {
                throw new IllegalArgumentException("波特率非法: " + baudRate);
            }

            SerialPortWrapper wrapper = createSerialPortWrapper(serialPort, baudRate,
                    dataBits, stopBits, parity);
            ModbusMaster master = MODBUS_FACTORY.createRtuMaster(wrapper);
            master.setTimeout(config.getTimeout());
            master.setRetries(config.getRetries());
            master.init();

            log.debug("创建Modbus RTU连接: {}, 波特率: {}", serialPort, baudRate);
            return master;

        } catch (ModbusInitException e) {
            throw new RuntimeException("初始化Modbus RTU连接失败", e);
        }
    }
    /**
     * 创建串口包装器
     */
    private SerialPortWrapper createSerialPortWrapper(String serialPort, int baudRate,
                                                      int dataBits, int stopBits, int parity) {
        return new SerialPortWrapper() {
            private com.fazecast.jSerialComm.SerialPort port;
            private java.io.InputStream inputStream;
            private java.io.OutputStream outputStream;

            @Override
            public void open() throws Exception {
                port = com.fazecast.jSerialComm.SerialPort.getCommPort(serialPort);
                port.setBaudRate(baudRate);
                port.setNumDataBits(dataBits);
                port.setNumStopBits(stopBits);
                port.setParity(parity);

                if (!port.openPort(config.getTimeout())) {
                    throw new RuntimeException("无法打开串口: " + serialPort);
                }

                inputStream = port.getInputStream();
                outputStream = port.getOutputStream();

                log.info("串口 {} 已打开", serialPort);
            }

            @Override
            public void close() throws Exception {
                if (port != null && port.isOpen()) {
                    port.closePort();
                    log.info("串口 {} 已关闭", serialPort);
                }
            }

            @Override
            public java.io.InputStream getInputStream() {
                return inputStream;
            }

            @Override
            public java.io.OutputStream getOutputStream() {
                return outputStream;
            }

            @Override
            public int getBaudRate() {
                return baudRate;
            }

            @Override
            public int getDataBits() {
                return dataBits;
            }

            @Override
            public int getStopBits() {
                return stopBits == 1 ? com.fazecast.jSerialComm.SerialPort.ONE_STOP_BIT :
                        stopBits == 2 ? com.fazecast.jSerialComm.SerialPort.TWO_STOP_BITS :
                                com.fazecast.jSerialComm.SerialPort.ONE_STOP_BIT;
            }

            @Override
            public int getParity() {
                switch (parity) {
                    case 1: return com.fazecast.jSerialComm.SerialPort.ODD_PARITY;
                    case 2: return com.fazecast.jSerialComm.SerialPort.EVEN_PARITY;
                    default: return com.fazecast.jSerialComm.SerialPort.NO_PARITY;
                }
            }

            @Override
            public int getFlowControlIn() {
                return com.fazecast.jSerialComm.SerialPort.FLOW_CONTROL_DISABLED;
            }

            @Override
            public int getFlowControlOut() {
                return com.fazecast.jSerialComm.SerialPort.FLOW_CONTROL_DISABLED;
            }
        };
    }


    /**
     * 启动清理任务
     */
    private void startCleanupTask() {
        cleanupScheduler.scheduleAtFixedRate(() -> {
            try {
                cleanupIdleConnections();
            } catch (Exception e) {
                log.error("清理连接异常", e);
            }
        }, 1, 1, TimeUnit.MINUTES);
    }

    /**
     * 清理空闲连接
     */
    private synchronized void cleanupIdleConnections() {
        long now = System.currentTimeMillis();

        connections.entrySet().removeIf(entry -> {
            String key = entry.getKey();
            Long lastUsed = lastUsedTime.get(key);

            if (lastUsed != null && (now - lastUsed) > config.getIdleTimeout()) {
                try {
                    ModbusMaster master = entry.getValue();
                    if (master.isInitialized()) {
                        master.destroy();
                    }
                    log.debug("清理空闲连接: {}", key);

                    refCounts.remove(key);
                    lastUsedTime.remove(key);
                    return true;

                } catch (Exception e) {
                    log.error("清理连接失败: {}", key, e);
                }
            }
            return false;
        });
    }

    /**
     * 关闭连接池
     */
    public void shutdown() {
        cleanupScheduler.shutdown();

        connections.forEach((key, master) -> {
            try {
                if (master.isInitialized()) {
                    master.destroy();
                }
                log.debug("关闭连接: {}", key);
            } catch (Exception e) {
                log.error("关闭连接失败: {}", key, e);
            }
        });

        connections.clear();
        refCounts.clear();
        lastUsedTime.clear();
    }

    /**
     * 获取连接池状态
     */
    public Map<String, Object> getPoolStatus() {
        Map<String, Object> status = new ConcurrentHashMap<>();
        status.put("activeConnections", connections.size());
        status.put("refCounts", new ConcurrentHashMap<>(refCounts));
        return status;
    }

    private String getTcpConnectionKey(String host, int port) {
        return "tcp:" + host + ":" + port;
    }

    private String getSerialConnectionKey(String serialPort, int baudRate,
                                          int dataBits, int stopBits, int parity) {
        return "serial:" + serialPort + ":" + baudRate + ":" + dataBits + ":" + stopBits + ":" + parity;
    }
}
