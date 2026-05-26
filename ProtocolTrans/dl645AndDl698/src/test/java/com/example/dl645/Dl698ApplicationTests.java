//package com.example.dl645;
//
//import com.example.dl645.core.ResponseListener;
//import com.example.dl645.core.parse.dl698.DL698Handler;
//import com.example.dl645.core.DL698Protocol;
//import org.junit.jupiter.api.Test;
//
////@SpringBootTest
////@EnableAutoConfiguration(exclude = {DataSourceAutoConfiguration.class, MybatisAutoConfiguration.class})
//class Dl698ApplicationTests {
//    // DL/T 698 OAD 常量
//    public static class DL698OAD {
//        // 组合有功总电能
//        public static final byte[] COMBI_ACTIVE_TOTAL = {0x00, 0x00, 0x00, 0x00};
//        // 正向有功总电能
//        public static final byte[] FORWARD_ACTIVE_TOTAL = {0x00, 0x00, 0x01, 0x00};
//        // 反向有功总电能
//        public static final byte[] REVERSE_ACTIVE_TOTAL = {0x00, 0x00, 0x02, 0x00};
//    }
//
//    @Test
//    void tcp698正向有功电量() {
//        DL698Protocol protocol = new DL698Protocol();
//        try {
//            protocol.setResponseListener(new ResponseListener() {
//                @Override public void onResponseReceived(byte[] response) {
//                    System.out.println("完整响应: " + bytesToHex(response));
//                }
//                @Override public void onError(String errorMessage) {
//                    System.out.println("错误: " + errorMessage);
//                }
//                @Override public void onPortOpened(String portName) {
//                    System.out.println("连接已打开");
//                }
//                @Override public void onPortClosed(String portName) {
//                    System.out.println("连接已关闭");
//                }
//                @Override public void onDataAvailable(byte[] data) {
//                    System.out.println("原始数据: " + bytesToHex(data));
//                }
//            });
//
//            boolean connected = protocol.connectTcp("127.0.0.1", 8555, 8000);
//            if (!connected) {
//                System.out.println("TCP 连接失败");
//                return;
//            }
//
//            // 参数配置：终端地址、服务地址、OAD
//            byte[] serverAddr = DL698Handler.meterAddressHexToBytes("000000000001");
//            byte clientAddr = 0x01; // 客户端地址
//            byte[] oad = DL698OAD.FORWARD_ACTIVE_TOTAL;
//
//            // 1) 先 LINK（链路登录）
//            byte[] linkFrame = DL698Handler.buildLinkRequest(serverAddr, clientAddr);
//            System.out.println("发出 LINK 帧 HEX: " + bytesToHex(linkFrame));
//            protocol.sendLinkTcp(serverAddr, clientAddr);
//            Thread.sleep(1200);
//
//            // 2) 再 CONNECT（建立应用连接）
//            byte[] connectFrame = DL698Handler.buildConnectRequest(serverAddr, clientAddr);
//            System.out.println("发出 CONNECT 帧 HEX: " + bytesToHex(connectFrame));
//            protocol.sendConnectTcp(serverAddr, clientAddr);
//            Thread.sleep(1500);
//
//            // 3) 再 GET（读 OAD），带重试
//            byte[] getFrame = DL698Handler.buildReadRequest(serverAddr, clientAddr, oad);
//            System.out.println("发出 GET 帧 HEX: " + bytesToHex(getFrame));
//            for (int i = 0; i < 3; i++) {
//                protocol.sendReadTcp(serverAddr, clientAddr, oad);
//                Thread.sleep(2500);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        } finally {
//            protocol.disconnectTcp();
//        }
//    }
//
//    private String bytesToHex(byte[] bytes) {
//        StringBuilder sb = new StringBuilder();
//        for (byte b : bytes) sb.append(String.format("%02X ", b));
//        return sb.toString();
//    }
//}
