package com.example.dl645.constant;
/**
 * DL698协议常量
 *
 * @Date 2026/04/08 10:23
 * @Author wangchangzhen
 */
public class DL698Contant {
    // 帧起始符
    public static final byte FRAME_START = 0x68;
    // 帧结束符
    public static final byte FRAME_END = 0x16;
    /**
     * 长度域大小
     */
    public static final int LENGTH_FIELD_SIZE = 2;
    /**
     * 控制域大小
     */
    public static final int CONTROL_CODE_SIZE = 1;
    // DIR PRM:发送类型
    public static class sendType {
        // 客户端对Server上报的响应
        public static final byte CLIENT_TO_SERVER_RESPONSE = 0x00;
        // 客户端发起的请求
        public static final byte CLIENT_TO_REQUEST = 0x01;
        // 服务器发起的请求
        public static final byte SERVER_TO_REQUEST = 0x10;
        // 服务端对客户端请求的响应
        public static final byte SERVER_TO_CLIENT_RESPONSE = 0x11;
    }
    //分帧标志：0-完整APDU，1-片段APDU
    public static class frameFlag {
        public static final byte COMPLETE_APDU = 0x00;
        public static final byte FRAGMENT_APDU = 0x20;
    }
    // 扰码标志：0-不需加33H处理，1-需加33H处理
    public static class sc {
        public static final byte NOT_NEED_PROCESS = 0x00;
        public static final byte NEED_PROCESS = 0x08;
    }
    // 功能码：1-链路管理，3-用户数据
    public static class functionCode {
        public static final byte LINK_MANAGEMENT = 0x01;
        public static final byte USER_DATA = 0x03;
    }
    /**
     * 地址域
     */
    public static class addressType {
        // 单地址
        public static final byte SINGLE_ADDRESS = 0x00;
        // 通配符地址
        public static final byte WILDCARD_ADDRESS = 0x01;
        // 组地址
        public static final byte GROUP_ADDRESS = 0x02;
        // 广播地址
        public static final byte BROADCAST_ADDRESS = 0x03;
    }
    // 服务器地址最大字节长度
    public static final int SERVER_ADDRESS_MAX_LENGTH = 16;
    // 客户端地址最大字节长度(取值范围0-255)
    public static final int CLIENT_ADDRESS_MAX_LENGTH = 1;

    public static class apduData {
        // 帧类型：0-正常帧，1-分帧
        public static final byte FRAME_TYPE_NORMAL = 0x00;
        public static final byte FRAME_TYPE_FRAGMENT = 0x01;

        // 分帧标志位掩码
        public static final byte FRAGMENT_FLAG_MASK = (byte) 0x80;

        // 服务类型
        public static class serviceType {
            // 连接请求
            public static final byte CONNECT_REQUEST = 0x01;
            // 连接响应
            public static final byte CONNECT_RESPONSE = 0x02;
            // 断开连接请求
            public static final byte DISCONNECT_REQUEST = 0x03;
            // 断开连接响应
            public static final byte DISCONNECT_RESPONSE = 0x04;
            // 心跳
            public static final byte HEARTBEAT = 0x05;
            // 读取数据
            public static final byte READ_DATA = 0x11;
            // 读取数据响应
            public static final byte READ_DATA_RESPONSE = 0x12;
            // 写入数据
            public static final byte WRITE_DATA = 0x13;
            // 写入数据响应
            public static final byte WRITE_DATA_RESPONSE = 0x14;
        }

        // 错误码
        public static class errorCode {
            public static final byte SUCCESS = 0x00;
            public static final byte UNKNOW_DATA = 0x01;
            public static final byte READ_DENIED = 0x02;
            public static final byte WRITE_DENIED = 0x03;
            public static final byte TIMEOUT = 0x04;
        }

        // OAD (对象属性描述符) 长度
        public static final int OAD_LENGTH = 4;

        // 数据标识 DI 长度
        public static final int DI_LENGTH = 2;
    }
}
