//package com.example.dl645;
//
//import com.example.dl645.constant.DL645Constant;
//
//import com.example.dl645.core.DL645Protocol;
//import com.example.dl645.core.ResponseListener;
//import org.junit.jupiter.api.Test;
//
//import java.util.concurrent.atomic.AtomicBoolean;
//
//class Dl645ApplicationTests {
//    public static final byte[] COMBI_ACTIVE_TOTAL = {0x00, -0x01, 0x01, 0x02};
//    public static final String selectedPort = "COM7";
//    public static final String meterAddress = "000071447565";
//    public static final DL645Protocol protocol = new DL645Protocol();
//
//    @Test
//    void 正向有功电量() {
//        try {
//            protocol.setResponseListener(new ResponseListener() {
//                @Override
//                public void onResponseReceived(byte[] response) {
//                    System.out.println("完整响应: " + bytesToHex(response));
//                }
//
//                @Override
//                public void onError(String errorMessage) {
//                    System.out.println("错误: " + errorMessage);
//                }
//
//                @Override
//                public void onPortOpened(String portName) {
//                    System.out.println("端口打开: " + portName);
//                }
//
//                @Override
//                public void onPortClosed(String portName) {
//                    System.out.println("端口关闭: " + portName);
//                }
//
//                @Override
//                public void onDataAvailable(byte[] data) {
//                    System.out.println("原始数据: " + bytesToHex(data));
//                }
//            });
//            boolean connected = protocol.connect(selectedPort, 2400, meterAddress);
//            if (!connected) {
//                System.out.println("连接失败");
//                return;
//            }
//            System.out.println("连接成功！");
//            System.out.println("发送命令 - 电表地址: " + meterAddress + ", DI: " + bytesToHex(DL645Constant.DI.FORWARD_ACTIVE_TOTAL));
//            protocol.sendCommand(DL645Constant.DI.FORWARD_ACTIVE_TOTAL);
//            Thread.sleep(5000);
//        } catch (Exception e) {
//            e.printStackTrace();
//        } finally {
//            protocol.disconnect();
//        }
//    }
//
//    @Test
//    void 反向有功电量() {
//        try {
//            protocol.setResponseListener(new ResponseListener() {
//                @Override
//                public void onResponseReceived(byte[] response) {
//                    System.out.println("完整响应: " + bytesToHex(response));
//                }
//
//                @Override
//                public void onError(String errorMessage) {
//                    System.out.println("错误: " + errorMessage);
//                }
//
//                @Override
//                public void onPortOpened(String portName) {
//                    System.out.println("端口打开: " + portName);
//                }
//
//                @Override
//                public void onPortClosed(String portName) {
//                    System.out.println("端口关闭: " + portName);
//                }
//
//                @Override
//                public void onDataAvailable(byte[] data) {
//                    System.out.println("原始数据: " + bytesToHex(data));
//                }
//            });
//            boolean connected = protocol.connect(selectedPort, 2400, meterAddress);
//            if (!connected) {
//                System.out.println("连接失败");
//                return;
//            }
//            System.out.println("连接成功！");
//            protocol.sendCommand(DL645Constant.DI.REVERSE_ACTIVE_TOTAL);
//            Thread.sleep(5000);
//        } catch (Exception e) {
//            e.printStackTrace();
//        } finally {
//            protocol.disconnect();
//        }
//    }
//
//    @Test
//    void 总用电功率() {
//        try {
//            protocol.setResponseListener(new ResponseListener() {
//                @Override
//                public void onResponseReceived(byte[] response) {
//                    System.out.println("完整响应: " + bytesToHex(response));
//                }
//
//                @Override
//                public void onError(String errorMessage) {
//                    System.out.println("错误: " + errorMessage);
//                }
//
//                @Override
//                public void onPortOpened(String portName) {
//                    System.out.println("端口打开: " + portName);
//                }
//
//                @Override
//                public void onPortClosed(String portName) {
//                    System.out.println("端口关闭: " + portName);
//                }
//
//                @Override
//                public void onDataAvailable(byte[] data) {
//                    System.out.println("原始数据: " + bytesToHex(data));
//                }
//            });
//            boolean connected = protocol.connect(selectedPort, 2400, meterAddress);
//            if (!connected) {
//                System.out.println("连接失败");
//                return;
//            }
//            System.out.println("连接成功！");
//            protocol.sendCommand(DL645Constant.DI.ACTIVE_POWER_TOTAL);
//            Thread.sleep(5000);
//        } catch (Exception e) {
//            e.printStackTrace();
//        } finally {
//            protocol.disconnect();
//        }
//    }
//
//    @Test
//    void tcp645正向有功电量() {
//        AtomicBoolean hasResponse = new AtomicBoolean(false);
//        try {
//            DL645Protocol protocol = new DL645Protocol();
//            protocol.setResponseListener(new ResponseListener() {
//                @Override
//                public void onResponseReceived(byte[] response) {
//                    hasResponse.set(true);
//                    System.out.println("完整响应: " + bytesToHex(response));
//                }
//
//                @Override
//                public void onError(String errorMessage) {
//                    System.out.println("错误: " + errorMessage);
//                }
//
//                @Override
//                public void onPortOpened(String portName) {
//                    System.out.println("端口打开: " + portName);
//                }
//
//                @Override
//                public void onPortClosed(String portName) {
//                    System.out.println("端口关闭: " + portName);
//                }
//
//                @Override
//                public void onDataAvailable(byte[] data) {
//                    hasResponse.set(true);
//                    System.out.println("原始数据: " + bytesToHex(data));
//                }
//            });
//            String meterAddr = "000071447565";
//            boolean connected = protocol.connectTcp("192.168.1.12", 8802, 5000, meterAddr);
//            if (!connected) {
//                System.out.println("TCP 连接失败");
//                return;
//            }
//            System.out.println("TCP 连接成功！");
//            System.out.println("请求地址: " + meterAddr);
//            byte[][] diList = new byte[][]{
//                    // 常见：正向有功总
//                    {0x00, 0x00, 0x00, 0x00},
//                    // 你当前常量使用值
//                    {0x00, 0x01, 0x00, 0x00},
//                    // 常见：总有功功率
//                    {0x02, 0x03, 0x00, 0x00}
//            };
//            String[] diNames = new String[]{
//                    "正向有功总(00000000)",
//                    "正向有功总候选(00010000)",
//                    "总有功功率(02030000)"
//            };
//            for (int i = 0; i < diList.length; i++) {
//                hasResponse.set(false);
//                System.out.println("发送DI[" + diNames[i] + "]: " + bytesToHex(diList[i]));
//                protocol.sendCommandTcp(diList[i]);
//                Thread.sleep(3500);
//                if (!hasResponse.get()) {
//                    System.out.println("结果: DI[" + diNames[i] + "] 3.5秒内未收到回包");
//                }
//                Thread.sleep(300);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        } finally {
//            protocol.disconnectTcp();
//        }
//    }
//
//    /**
//     * TCP透传链路排查：
//     * 1) 先读表地址（最稳）
//     * 2) 再读正向总电能
//     * 3) 再读总有功功率
//     */
//    @Test
//    void tcp645透传链路排查() {
//        AtomicBoolean hasResponse = new AtomicBoolean(false);
//        try {
//            DL645Protocol protocol = new DL645Protocol();
//            protocol.setResponseListener(new ResponseListener() {
//                @Override
//                public void onResponseReceived(byte[] response) {
//                    hasResponse.set(true);
//                    System.out.println("完整响应: " + bytesToHex(response));
//                }
//
//                @Override
//                public void onError(String errorMessage) {
//                    System.out.println("错误: " + errorMessage);
//                }
//
//                @Override
//                public void onPortOpened(String portName) {
//                    System.out.println("端口打开: " + portName);
//                }
//
//                @Override
//                public void onPortClosed(String portName) {
//                    System.out.println("端口关闭: " + portName);
//                }
//
//                @Override
//                public void onDataAvailable(byte[] data) {
//                    hasResponse.set(true);
//                    System.out.println("原始数据: " + bytesToHex(data));
//                }
//            });
//
//            String meterAddr = "000071447565";
//            boolean connected = protocol.connectTcp("192.168.1.12", 8802, 2000, meterAddr);
//            if (!connected) {
//                System.out.println("TCP连接失败");
//                return;
//            }
//            System.out.println("TCP连接成功，开始链路排查");
//            System.out.println("请求地址: " + meterAddr);
//
//            byte[][] diList = new byte[][]{
//                    DL645Constant.DI.METER_ADDRESS,
//                    {0x00, 0x00, 0x00, 0x00},
//                    {0x02, 0x03, 0x00, 0x00}
//            };
//            String[] diNames = new String[]{
//                    "通信地址(04020000)",
//                    "正向有功总(00000000)",
//                    "总有功功率(02030000)"
//            };
//            for (int i = 0; i < diList.length; i++) {
//                hasResponse.set(false);
//                System.out.println("发送DI[" + diNames[i] + "]: " + bytesToHex(diList[i]));
//                protocol.sendCommandTcp(diList[i]);
//                Thread.sleep(2000);
//                if (!hasResponse.get()) {
//                    System.out.println("结果: DI[" + diNames[i] + "] 无回包（优先检查串口服务器波特率/校验位/485接线）");
//                } else {
//                    System.out.println("结果: DI[" + diNames[i] + "] 已收到回包");
//                }
//                Thread.sleep(300);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        } finally {
//            protocol.disconnectTcp();
//        }
//    }
//
//    /**
//     * TCP透传地址顺序探测：
//     * 1) 依次尝试原地址、按字节倒序地址
//     * 2) 每个地址下读取通信地址与正向有功总，判断是否有回包
//     */
//    @Test
//    void tcp645透传地址顺序探测() {
//        AtomicBoolean hasResponse = new AtomicBoolean(false);
//        String host = "192.168.1.12";
//        int port = 8802;
//        String meterAddr = "000071447565";
//        String reversedMeterAddr = reverseAddressByByte(meterAddr);
//        String[] addrCandidates = new String[]{meterAddr, reversedMeterAddr};
//        String[] addrNames = new String[]{"原地址", "倒序地址"};
//
//        byte[][] diList = new byte[][]{
//                DL645Constant.DI.METER_ADDRESS,
//                {0x00, 0x00, 0x00, 0x00}
//        };
//        String[] diNames = new String[]{
//                "通信地址(04020000)",
//                "正向有功总(00000000)"
//        };
//
//        DL645Protocol protocol = new DL645Protocol();
//        protocol.setResponseListener(new ResponseListener() {
//            @Override
//            public void onResponseReceived(byte[] response) {
//                hasResponse.set(true);
//                System.out.println("完整响应: " + bytesToHex(response));
//            }
//
//            @Override
//            public void onError(String errorMessage) {
//                System.out.println("错误: " + errorMessage);
//            }
//
//            @Override
//            public void onPortOpened(String portName) {
//                System.out.println("端口打开: " + portName);
//            }
//
//            @Override
//            public void onPortClosed(String portName) {
//                System.out.println("端口关闭: " + portName);
//            }
//
//            @Override
//            public void onDataAvailable(byte[] data) {
//                hasResponse.set(true);
//                System.out.println("原始数据: " + bytesToHex(data));
//            }
//        });
//
//        try {
//            for (int i = 0; i < addrCandidates.length; i++) {
//                String addr = addrCandidates[i];
//                System.out.println("\n==============================");
//                System.out.println("开始探测[" + addrNames[i] + "]: " + addr);
//
//                boolean connected = protocol.connectTcp(host, port, 2500, addr);
//                if (!connected) {
//                    System.out.println("TCP连接失败，跳过该地址候选");
//                    continue;
//                }
//
//                boolean addrSuccess = false;
//                for (int j = 0; j < diList.length; j++) {
//                    hasResponse.set(false);
//                    System.out.println("发送DI[" + diNames[j] + "]: " + bytesToHex(diList[j]));
//                    protocol.sendCommandTcp(diList[j]);
//                    Thread.sleep(2300);
//                    if (hasResponse.get()) {
//                        System.out.println("结果: DI[" + diNames[j] + "] 已收到回包");
//                        addrSuccess = true;
//                    } else {
//                        System.out.println("结果: DI[" + diNames[j] + "] 无回包");
//                    }
//                    Thread.sleep(250);
//                }
//
//                if (addrSuccess) {
//                    System.out.println("结论: 地址候选[" + addr + "]可通信，建议后续统一使用该地址格式。");
//                } else {
//                    System.out.println("结论: 地址候选[" + addr + "]仍无回包。");
//                }
//                protocol.disconnectTcp();
//                Thread.sleep(500);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        } finally {
//            protocol.disconnectTcp();
//        }
//    }
//
//    /**
//     * TCP透传广播读地址测试：
//     * 使用广播地址 AAAAAAAAAAAA 读取通信地址(04020000)。
//     * - 若有回包：说明物理链路基本通，重点排查单表地址配置；
//     * - 若无回包：更偏向485接线/串口参数/电表通讯口问题。
//     */
//    @Test
//    void tcp645透传广播读地址() {
//        AtomicBoolean hasResponse = new AtomicBoolean(false);
//        String host = "192.168.1.12";
//        int port = 8802;
//        String broadcastAddress = "AAAAAAAAAAAA";
//        byte[] di = DL645Constant.DI.METER_ADDRESS;
//
//        DL645Protocol protocol = new DL645Protocol();
//        protocol.setResponseListener(new ResponseListener() {
//            @Override
//            public void onResponseReceived(byte[] response) {
//                hasResponse.set(true);
//                System.out.println("完整响应: " + bytesToHex(response));
//            }
//
//            @Override
//            public void onError(String errorMessage) {
//                System.out.println("错误: " + errorMessage);
//            }
//
//            @Override
//            public void onPortOpened(String portName) {
//                System.out.println("端口打开: " + portName);
//            }
//
//            @Override
//            public void onPortClosed(String portName) {
//                System.out.println("端口关闭: " + portName);
//            }
//
//            @Override
//            public void onDataAvailable(byte[] data) {
//                hasResponse.set(true);
//                System.out.println("原始数据: " + bytesToHex(data));
//            }
//        });
//
//        try {
//            boolean connected = protocol.connectTcp(host, port, 3000, broadcastAddress);
//            if (!connected) {
//                System.out.println("TCP连接失败");
//                return;
//            }
//
//            System.out.println("TCP连接成功，开始广播读地址测试");
//            System.out.println("请求地址(广播): " + broadcastAddress);
//            System.out.println("发送DI[通信地址(04020000)]: " + bytesToHex(di));
//
//            hasResponse.set(false);
//            protocol.sendCommandTcp(di);
//            Thread.sleep(3000);
//
//            if (hasResponse.get()) {
//                System.out.println("结果: 广播读地址收到回包，链路可达，建议重点核对单表地址。");
//            } else {
//                System.out.println("结果: 广播读地址仍无回包，优先检查485接线/串口参数/电表通讯使能。");
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        } finally {
//            protocol.disconnectTcp();
//        }
//    }
//
//    @Test
//    void tcp645反向有功电量() {
//        try {
//            DL645Protocol protocol = new DL645Protocol();
//            boolean connected = protocol.connectTcp("192.168.1.12", 8802, 3000, "000000000000");
//            if (!connected) {
//                System.out.println("TCP连接失败");
//                return;
//            }
//            System.out.println("TCP连接成功！");
//            protocol.sendCommandTcp(DL645Constant.DI.REVERSE_ACTIVE_TOTAL);
//            Thread.sleep(5000);
//        } catch (Exception e) {
//            e.printStackTrace();
//        } finally {
//            protocol.disconnectTcp();
//        }
//    }
//
//    /**
//     * 华立电表串口链路探测（USB转485）
//     * 说明：
//     * 1) 优先尝试 2400（华立常见默认），再尝试 9600
//     * 2) 先读通信地址(04020000)验证链路，再读正向有功总电能
//     * 3) 地址依次尝试：配置地址、广播地址
//     */
//    @Test
//    void 华立串口链路探测() {
//        AtomicBoolean hasResponse = new AtomicBoolean(false);
//        int[] baudRates = new int[]{2400, 9600};
//        String[] addrCandidates = new String[]{meterAddress, "AAAAAAAAAAAA"};
//        String[] addrNames = new String[]{"配置地址", "广播地址"};
//        byte[][] diList = new byte[][]{
//                DL645Constant.DI.METER_ADDRESS,
//                DL645Constant.DI.FORWARD_ACTIVE_TOTAL
//        };
//        String[] diNames = new String[]{
//                "通信地址(04020000)",
//                "正向有功总电能(00010000)"
//        };
//
//        DL645Protocol localProtocol = new DL645Protocol();
//        localProtocol.setResponseListener(new ResponseListener() {
//            @Override
//            public void onResponseReceived(byte[] response) {
//                hasResponse.set(true);
//                System.out.println("完整响应: " + bytesToHex(response));
//            }
//
//            @Override
//            public void onError(String errorMessage) {
//                System.out.println("错误: " + errorMessage);
//            }
//
//            @Override
//            public void onPortOpened(String portName) {
//                System.out.println("端口打开: " + portName);
//            }
//
//            @Override
//            public void onPortClosed(String portName) {
//                System.out.println("端口关闭: " + portName);
//            }
//
//            @Override
//            public void onDataAvailable(byte[] data) {
//                hasResponse.set(true);
//                System.out.println("原始数据: " + bytesToHex(data));
//            }
//        });
//
//        try {
//            for (int baudRate : baudRates) {
//                for (int i = 0; i < addrCandidates.length; i++) {
//                    String addr = addrCandidates[i];
//                    System.out.println("\n==============================");
//                    System.out.println("开始探测: 波特率=" + baudRate + ", 地址类型=" + addrNames[i] + ", 地址=" + addr);
//
//                    boolean connected = localProtocol.connect(selectedPort, baudRate, addr);
//                    if (!connected) {
//                        System.out.println("串口连接失败，跳过该组合");
//                        continue;
//                    }
//                    boolean comboSuccess = false;
//                    for (int j = 0; j < diList.length; j++) {
//                        hasResponse.set(false);
//                        System.out.println("发送DI[" + diNames[j] + "]: " + bytesToHex(diList[j]));
//                        localProtocol.sendCommand(diList[j]);
//                        Thread.sleep(2600);
//                        if (hasResponse.get()) {
//                            comboSuccess = true;
//                            System.out.println("结果: DI[" + diNames[j] + "] 已收到回包");
//                        } else {
//                            System.out.println("结果: DI[" + diNames[j] + "] 未收到回包");
//                        }
//                        Thread.sleep(250);
//                    }
//                    if (comboSuccess) {
//                        System.out.println("结论: 当前组合可通信（波特率=" + baudRate + ", 地址=" + addr + "）");
//                    } else {
//                        System.out.println("结论: 当前组合无回包（建议尝试A/B对调或检查表端通讯参数）");
//                    }
//                    localProtocol.disconnect();
//                    Thread.sleep(500);
//                }
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        } finally {
//            localProtocol.disconnect();
//        }
//    }
//
//    private String bytesToHex(byte[] bytes) {
//        StringBuilder sb = new StringBuilder();
//        for (byte b : bytes) {
//            sb.append(String.format("%02X ", b));
//        }
//        return sb.toString();
//    }
//
//    private String reverseAddressByByte(String address) {
//        if (address == null || address.length() != 12) {
//            return address;
//        }
//        StringBuilder sb = new StringBuilder(12);
//        for (int i = address.length(); i > 0; i -= 2) {
//            sb.append(address, i - 2, i);
//        }
//        return sb.toString();
//    }
//}
//
