package com.ruoyi.web.meter.modbus;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;

/**
 * Modbus TCP 帧解析单元测试（不依赖应用启动与数据库）。
 */
class ModbusTcpSupportTest {

    /**
     * 构造一帧 FC03 读响应：从站 1，寄存器 [0x0001, 0x0002]（4 字节数据）。
     */
    private static byte[] fc03ResponseTwoRegs() {
        // MBAP: trans=0, proto=0, length=7 (unit1 + PDU6)
        return new byte[] {
            0x00, 0x01, 0x00, 0x00, 0x00, 0x07,
            0x01,
            0x03, 0x04,
            0x00, 0x01, 0x00, 0x02
        };
    }

    /**
     * FC03 读请求：从站 1，起始地址 0，数量 2。
     */
    private static byte[] fc03ReadRequest() {
        // length = 1 + 5 = 6
        return new byte[] {
            0x00, 0x02, 0x00, 0x00, 0x00, 0x06,
            0x01,
            0x03, 0x00, 0x00, 0x00, 0x02
        };
    }

    @Test
    void parseReadRegistersResponse_ok() {
        byte[] frame = fc03ResponseTwoRegs();
        int[] regs = ModbusTcpSupport.parseReadRegistersResponse(frame);
        assertNotNull(regs);
        assertArrayEquals(new int[] { 1, 2 }, regs);
        assertEquals(1, ModbusTcpSupport.parseUnitId(frame));
        assertEquals(0x03, ModbusTcpSupport.parseFunctionCode(frame));
    }

    @Test
    void parseReadRegistersResponse_truncated_returnsNull() {
        byte[] bad = new byte[] { 0x00, 0x01, 0x00, 0x00, 0x00, 0x07, 0x01, 0x03 };
        assertNull(ModbusTcpSupport.parseReadRegistersResponse(bad));
    }

    @Test
    void parseReadRequestStartAddress_and_isReadRequest() {
        byte[] req = fc03ReadRequest();
        assertTrue(ModbusTcpSupport.isReadRequest(req));
        assertEquals(0, ModbusTcpSupport.parseReadRequestStartAddress(req));
    }

    @Test
    void isReadRequest_responseFrame_false() {
        assertFalse(ModbusTcpSupport.isReadRequest(fc03ResponseTwoRegs()));
    }

    @Test
    void readMbapLength_matchesFrame() {
        byte[] frame = fc03ResponseTwoRegs();
        assertEquals(7, ModbusTcpSupport.readMbapLength(frame, 0));
        assertEquals(13, ModbusTcpSupport.frameTotalLength(frame, 0));
    }
}
