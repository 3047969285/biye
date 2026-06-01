package com.example.dl645.constant;

/**
 * @Author wangchangzhen
 * @Date 2025 12 24 08 53
 * @description
 **/
public class DL645Constant {

    // 帧起始符
    public static final byte FRAME_START = 0x68;

    // 帧结束符
    public static final byte FRAME_END = 0x16;

    /**
     * 地址字节长度
     */
    public static final int ADDRESS_LENGTH = 6;
    /**
     * 地址字节长度 16进制 字符串
     */
    public static final int ADDRESS_LENGTH_HEX = 12;

    // 控制码
    public static class ControlCode {
        // 读数据
        public static final byte READ_DATA = 0x11;
        // 读后续数据
        public static final byte READ_FOLLOW_DATA = 0x12;
        // 读通信地址
        public static final byte READ_ADDRESS = 0x13;
        // 写数据
        public static final byte WRITE_DATA = 0x14;
        // 写通信地址
        public static final byte WRITE_ADDRESS = 0x15;
        // 广播校时
        public static final byte BROADCAST_TIME = 0x08;
        // 冻结命令
        public static final byte FREEZE_COMMAND = 0x16;
        // 更改通信速率
        public static final byte CHANGE_BAUDRATE = 0x17;
        // 修改密码
        public static final byte MODIFY_PASSWORD = 0x18;
        // 最大需量清零
        public static final byte CLEAR_MAX_DEMAND = 0x19;
        // 电表清零
        public static final byte CLEAR_METER = 0x1A;
        // 事件清零
        public static final byte CLEAR_EVENT = 0x1B;
    }

    // 常用 DI 常量
    public static class DI {
        // 正向有功电能（用电 - 从电网取电）
        public static final byte[] FORWARD_ACTIVE_TOTAL = {0x00, 0x01, 0x00, 0x00};  // 当前正向有功总电能（0x00010000）
        public static final byte[] FORWARD_ACTIVE_RATE_1 = {0x00, 0x01, 0x01, 0x00}; // 当前正向有功费率1电能（0x00010100）
        public static final byte[] FORWARD_ACTIVE_RATE_2 = {0x00, 0x01, 0x02, 0x00}; // 当前正向有功费率2电能（0x00010200）
        public static final byte[] FORWARD_ACTIVE_RATE_3 = {0x00, 0x01, 0x03, 0x00}; // 当前正向有功费率3电能（0x00010300）
        public static final byte[] FORWARD_ACTIVE_RATE_4 = {0x00, 0x01, 0x04, 0x00}; // 当前正向有功费率4电能（0x00010400）
        public static final byte[] FORWARD_ACTIVE_RATE_5 = {0x00, 0x01, 0x05, 0x00}; // 当前正向有功费率5电能（0x00010500）
        public static final byte[] FORWARD_ACTIVE_RATE_6 = {0x00, 0x01, 0x06, 0x00}; // 当前正向有功费率6电能（0x00010600）
        public static final byte[] FORWARD_ACTIVE_RATE_7 = {0x00, 0x01, 0x07, 0x00}; // 当前正向有功费率7电能（0x00010700）
        public static final byte[] FORWARD_ACTIVE_RATE_8 = {0x00, 0x01, 0x08, 0x00}; // 当前正向有功费率8电能（0x00010800）
        public static final byte[] FORWARD_ACTIVE_RATE_9 = {0x00, 0x01, 0x09, 0x00}; // 当前正向有功费率9电能（0x00010900）
        public static final byte[] FORWARD_ACTIVE_RATE_10 = {0x00, 0x01, 0x0A, 0x00}; // 当前正向有功费率10电能（0x00010A00）

        // 反向有功电能（发电 - 向电网送电）
        public static final byte[] REVERSE_ACTIVE_TOTAL = {0x00, 0x02, 0x00, 0x00};  // 当前反向有功总电能（0x00020000）
        public static final byte[] REVERSE_ACTIVE_RATE_1 = {0x00, 0x02, 0x01, 0x00}; // 当前反向有功费率1电能（0x00020100）
        public static final byte[] REVERSE_ACTIVE_RATE_2 = {0x00, 0x02, 0x02, 0x00}; // 当前反向有功费率2电能（0x00020200）
        public static final byte[] REVERSE_ACTIVE_RATE_3 = {0x00, 0x02, 0x03, 0x00}; // 当前反向有功费率3电能（0x00020300）
        public static final byte[] REVERSE_ACTIVE_RATE_4 = {0x00, 0x02, 0x04, 0x00}; // 当前反向有功费率4电能（0x00020400）
        public static final byte[] REVERSE_ACTIVE_RATE_5 = {0x00, 0x02, 0x05, 0x00}; // 当前反向有功费率5电能（0x00020500）
        public static final byte[] REVERSE_ACTIVE_RATE_6 = {0x00, 0x02, 0x06, 0x00}; // 当前反向有功费率6电能（0x00020600）
        public static final byte[] REVERSE_ACTIVE_RATE_7 = {0x00, 0x02, 0x07, 0x00}; // 当前反向有功费率7电能（0x00020700）
        public static final byte[] REVERSE_ACTIVE_RATE_8 = {0x00, 0x02, 0x08, 0x00}; // 当前反向有功费率8电能（0x00020800）
        public static final byte[] REVERSE_ACTIVE_RATE_9 = {0x00, 0x02, 0x09, 0x00}; // 当前反向有功费率9电能（0x00020900）
        public static final byte[] REVERSE_ACTIVE_RATE_10 = {0x00, 0x02, 0x0A, 0x00}; // 当前反向有功费率10电能（0x00020A00）

        // 组合有功电能
        public static final byte[] COMBI_ACTIVE_TOTAL = {0x00, 0x00, 0x00, 0x00};   // 当前组合有功总电能（0x00000000）
        public static final byte[] COMBI_ACTIVE_RATE_1 = {0x00, 0x00, 0x01, 0x00};  // 当前组合有功费率1电能（0x00000100）
        public static final byte[] COMBI_ACTIVE_RATE_2 = {0x00, 0x00, 0x02, 0x00};  // 当前组合有功费率2电能（0x00000200）
        public static final byte[] COMBI_ACTIVE_RATE_3 = {0x00, 0x00, 0x03, 0x00};  // 当前组合有功费率3电能（0x00000300）
        public static final byte[] COMBI_ACTIVE_RATE_4 = {0x00, 0x00, 0x04, 0x00};  // 当前组合有功费率4电能（0x00000400）
        public static final byte[] COMBI_ACTIVE_RATE_5 = {0x00, 0x00, 0x05, 0x00};  // 当前组合有功费率5电能（0x00000500）
        public static final byte[] COMBI_ACTIVE_RATE_6 = {0x00, 0x00, 0x06, 0x00};  // 当前组合有功费率6电能（0x00000600）
        public static final byte[] COMBI_ACTIVE_RATE_7 = {0x00, 0x00, 0x07, 0x00};  // 当前组合有功费率7电能（0x00000700）
        public static final byte[] COMBI_ACTIVE_RATE_8 = {0x00, 0x00, 0x08, 0x00};  // 当前组合有功费率8电能（0x00000800）
        public static final byte[] COMBI_ACTIVE_RATE_9 = {0x00, 0x00, 0x09, 0x00};  // 当前组合有功费率9电能（0x00000900）
        public static final byte[] COMBI_ACTIVE_RATE_10 = {0x00, 0x00, 0x0A, 0x00}; // 当前组合有功费率10电能（0x00000A00）

        // 四象限无功电能
        public static final byte[] REACTIVE_Q1_TOTAL = {0x00, 0x03, 0x00, 0x00};  // 第 I 象限无功总电能
        public static final byte[] REACTIVE_Q2_TOTAL = {0x00, 0x04, 0x00, 0x00};  // 第 II 象限无功总电能
        public static final byte[] REACTIVE_Q3_TOTAL = {0x00, 0x05, 0x00, 0x00};  // 第 III 象限无功总电能
        public static final byte[] REACTIVE_Q4_TOTAL = {0x00, 0x06, 0x00, 0x00};  // 第 IV 象限无功总电能

        // 视在电能
        public static final byte[] APPARENT_ENERGY_TOTAL = {0x00, 0x09, 0x00, 0x00};  // 总视在电能
        public static final byte[] MAX_DEMAND_TOTAL = {0x00, 0x01, 0x03, 0x02};  // 最大需量
        public static final byte[] MAX_DEMAND_TIME = {0x00, 0x01, 0x04, 0x02};   // 最大需量发生时间

        // 电压
        public static final byte[] VOLTAGE_A = {0x02, 0x01, 0x01, 0x00};  // A 相电压
        public static final byte[] VOLTAGE_B = {0x02, 0x01, 0x02, 0x00};  // B 相电压
        public static final byte[] VOLTAGE_C = {0x02, 0x01, 0x03, 0x00};  // C 相电压

        // 电流
        public static final byte[] CURRENT_A = {0x02, 0x01, 0x05, 0x00};  // A 相电流
        public static final byte[] CURRENT_B = {0x02, 0x01, 0x06, 0x00};  // B 相电流
        public static final byte[] CURRENT_C = {0x02, 0x01, 0x07, 0x00};  // C 相电流

        // 有功功率
        public static final byte[] ACTIVE_POWER_TOTAL = {0x02, 0x03, 0x00, 0x00};  // 总有功功率
        public static final byte[] ACTIVE_POWER_A = {0x02, 0x03, 0x01, 0x00};      // A 相有功功率
        public static final byte[] ACTIVE_POWER_B = {0x02, 0x03, 0x02, 0x00};      // B 相有功功率
        public static final byte[] ACTIVE_POWER_C = {0x02, 0x03, 0x03, 0x00};      // C 相有功功率

        // 无功功率
        public static final byte[] REACTIVE_POWER_TOTAL = {0x02, 0x05, 0x00, 0x00};  // 总无功功率

        // 功率因数
        public static final byte[] POWER_FACTOR_TOTAL = {0x02, 0x07, 0x00, 0x00};  // 总功率因数
        public static final byte[] POWER_FACTOR_A = {0x02, 0x07, 0x01, 0x00};      // A 相功率因数
        public static final byte[] POWER_FACTOR_B = {0x02, 0x07, 0x02, 0x00};      // B 相功率因数
        public static final byte[] POWER_FACTOR_C = {0x02, 0x07, 0x03, 0x00};      // C 相功率因数

        // 频率
        public static final byte[] FREQUENCY = {0x02, 0x09, 0x00, 0x00};  // 电网频率

        public static final byte[] DATE_TIME = {0x04, 0x00, 0x00, 0x00};      // 日期和时间
        public static final byte[] PROGRAM_VERSION = {0x04, 0x01, 0x00, 0x00};  // 程序版本号
        public static final byte[] METER_ADDRESS = {0x04, 0x02, 0x00, 0x00};    // 电表地址
        public static final byte[] BAUD_RATE = {0x04, 0x03, 0x00, 0x00};        // 通信速率

        public static final byte[] LAST_EVENT_TIME = {0x05, 0x01, 0x00, 0x00};  // 最近一次事件发生时间
        public static final byte[] EVENT_COUNTER = {0x05, 0x02, 0x00, 0x00};    // 事件计数器
    }
}


