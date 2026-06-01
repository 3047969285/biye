//package com.example.modbus;
//
//import com.example.modbus.config.ConnectionConfig;
//import com.example.modbus.exception.ModbusClientException;
//import com.example.modbus.service.ModbusClient;
//import com.example.modbus.service.factory.ModbusClientFactory;
//import org.junit.jupiter.api.AfterEach;
//import org.junit.jupiter.api.BeforeEach;
//import org.junit.jupiter.api.Test;
//
//import java.util.Arrays;
//import java.util.Map;
//
//class ModbusApplicationTests {
//    private final String ip = System.getProperty("modbus.test.host", "127.0.0.1");
//    private final int port = Integer.getInteger("modbus.test.port", 502);
//
//    private ModbusClient modbusClient;
//
//    @BeforeEach
//    void modbusClientSetUp() {
//        modbusClient = newTestModbusClient();
//    }
//
//    @AfterEach
//    void modbusClientTearDown() {
//        if (modbusClient != null) {
//            try {
//                modbusClient.shutdown();
//            } catch (Exception e) {
//                System.err.println("关闭Modbus客户端时出现异常: " + e.getMessage());
//            } finally {
//                modbusClient = null;
//            }
//        }
//
//        try {
//            Thread.sleep(100);
//        } catch (InterruptedException e) {
//            Thread.currentThread().interrupt();
//        }
//    }
//
//    /** 使用标准 Modbus TCP*/
//    private static ModbusClient newTestModbusClient() {
//        ConnectionConfig config = new ConnectionConfig();
//        config.setTimeout(3000);
//        config.setRetries(3);
//        config.setMaxConnections(10);
//        config.setIdleTimeout(300000);
//        config.setEncapsulated(false);
//        return ModbusClientFactory.createClient(config);
//    }
//
//    @Test
//    void contextLoads() {
//        boolean connected = modbusClient.checkConnection("localhost", port);
//        System.out.println("连接状态: " + connected);
//
//        Map<String, Object> status = modbusClient.getPoolStatus();
//        System.out.println("连接池状态: " + status);
//    }
//
////   ============================== 读操作===========================
//
//    /**
//     * 读取线圈状态（功能码 0x01）
//     *
//     * @throws ModbusClientException
//     */
//    @Test
//    void testReadCoils() throws ModbusClientException {
//        boolean[] coils = modbusClient.readCoils(ip, port, 1, 0, 10);
//        System.out.println("线圈状态: " + Arrays.toString(coils));
//    }
//
//    /**
//     * 读取离散输入（功能码 0x02）
//     *
//     * @throws ModbusClientException
//     */
//    @Test
//    void testReadDiscreteInputs() throws ModbusClientException {
//        boolean[] discreteInputs = modbusClient.readDiscreteInputs(ip, port, 1, 0, 10);
//        System.out.println("离散数据: " + Arrays.toString(discreteInputs));
//    }
//
//    /**
//     * 03 (0x03)读取保持寄存器	Word	读
//     *
//     * @throws ModbusClientException
//     */
//    @Test
//    void testReadHoldingRegisters() throws ModbusClientException {
//        short[] inputRegisters = modbusClient.readInputRegisters(ip, port, 1, 0, 20);
//        System.out.println("读取输入寄存器映射数据: " + Arrays.toString(inputRegisters));
//    }
//
//    /**
//     * 读取输入寄存器（功能码 0x04）
//     *
//     * @throws ModbusClientException
//     */
//    @Test
//    void testReadInputRegisters() throws ModbusClientException {
//        short[] inputRegisters = modbusClient.readInputRegisters(ip, port, 1, 400, 20);
//        System.out.println("读取输入寄存器数据: " + Arrays.toString(inputRegisters));
//    }
//
//    //   ============================== 写操作===========================
//
//    /**
//     * 写入单个线圈（功能码 0x05）
//     *
//     * @throws ModbusClientException
//     */
//    @Test
//    void testwriteCoil() throws ModbusClientException {
//        modbusClient.writeCoil(ip, port, 1, 0, true);
//    }
//
//    /**
//     * 批量写入线圈（功能码 0x0F）
//     *
//     * @throws ModbusClientException
//     */
//    @Test
//    void testwriteCoils() throws ModbusClientException {
//        modbusClient.writeCoils(ip, port, 1, 0, new boolean[]{true, true});
//    }
//
//    /**
//     * 写入单个寄存器（功能码 0x06）
//     *
//     * @throws ModbusClientException
//     */
//    @Test
//    void testwriteRegister() throws ModbusClientException {
//        modbusClient.writeRegister(ip, port, 1, 0, 111);
//    }
//
//    /**
//     * 批量写入线圈（功能码 0x0F）
//     *
//     * @throws ModbusClientException
//     */
//    @Test
//    void testwriteRegisters() throws ModbusClientException {
//        modbusClient.writeRegisters(ip, port, 1, 0, new short[]{1, 2, 3});
//    }
//}
