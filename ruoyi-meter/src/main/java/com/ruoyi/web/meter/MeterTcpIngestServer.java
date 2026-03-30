package com.ruoyi.web.meter;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PushbackInputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.Date;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.service.IMeterModbusDataService;
import com.ruoyi.web.config.properties.MeterModbusProperties;
import com.ruoyi.web.controller.meter.dto.MeterIngestPayload;
import com.ruoyi.web.meter.modbus.ModbusTcpSupport;

/**
 * 电表网口接收：NDJSON 或 Modbus TCP 帧（需与点表 slave/偏移 匹配后入库）
 */
@Component
@ConditionalOnProperty(prefix = "meter.modbus", name = "tcp-enabled", havingValue = "true")
public class MeterTcpIngestServer implements ApplicationRunner {

    private static final Logger log = LoggerFactory.getLogger(MeterTcpIngestServer.class);

    private final MeterModbusProperties props;
    private final IMeterModbusDataService meterModbusDataService;
    private final ObjectMapper objectMapper;
    private final ExecutorService pool = Executors.newCachedThreadPool(r -> {
        Thread t = new Thread(r, "meter-tcp-worker");
        t.setDaemon(true);
        return t;
    });

    public MeterTcpIngestServer(MeterModbusProperties props, IMeterModbusDataService meterModbusDataService,
        ObjectMapper objectMapper) {
        this.props = props;
        this.meterModbusDataService = meterModbusDataService;
        this.objectMapper = objectMapper;
    }

    private static final class TcpConnState {
        Integer start;
    }

    @Override
    public void run(ApplicationArguments args) {
        Thread t = new Thread(this::acceptLoop, "meter-modbus-tcp-accept");
        t.setDaemon(true);
        t.start();
        log.info("Meter Modbus TCP ingest listening on port {}", props.getTcpPort());
    }

    private void acceptLoop() {
        try (ServerSocket ss = new ServerSocket(props.getTcpPort())) {
            while (!Thread.currentThread().isInterrupted()) {
                Socket socket = ss.accept();
                pool.execute(() -> handleClient(socket));
            }
        } catch (Exception e) {
            log.error("Meter TCP server failed: {}", e.getMessage());
        }
    }

    private void handleClient(Socket socket) {
        try (socket) {
            InputStream raw = socket.getInputStream();
            if (StringUtils.isNotEmpty(props.getIngestApiKey())) {
                String first = MeterIngestParseUtil.readLineUtf8(raw);
                if (!first.startsWith("KEY:") || !props.getIngestApiKey().equals(first.substring(4).trim())) {
                    log.warn("Meter TCP rejected: bad KEY line");
                    return;
                }
            }
            PushbackInputStream pin = new PushbackInputStream(raw);
            int peek = pin.read();
            if (peek < 0) {
                return;
            }
            pin.unread(peek);
            if (peek == '{' || !props.isTcpBinary()) {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(pin, StandardCharsets.UTF_8))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        if (line.isBlank()) {
                            continue;
                        }
                        ingestJsonLine(line);
                    }
                }
            } else {
                binaryLoop(pin);
            }
        } catch (Exception e) {
            log.debug("Meter TCP client closed: {}", e.getMessage());
        }
    }

    private void ingestJsonLine(String line) throws Exception {
        MeterIngestPayload p = objectMapper.readValue(line, MeterIngestPayload.class);
        if (p.getRegisters() == null || p.getRegisters().isEmpty()) {
            return;
        }
        int[] regs = p.getRegisters().stream().mapToInt(Integer::intValue).toArray();
        int slave = p.getSlaveId() != null ? p.getSlaveId() : 1;
        int rt = p.getRegisterType() != null ? p.getRegisterType() : 0;
        int base = p.getBaseAddress() != null ? p.getBaseAddress() : 0;
        Date readTime = MeterIngestParseUtil.parseReadTime(p.getReadTime());
        meterModbusDataService.ingestRegisters(slave, rt, base, regs, readTime, "TCP_JSON");
    }

    private void binaryLoop(PushbackInputStream pin) throws Exception {
        TcpConnState state = new TcpConnState();
        ByteArrayOutputStream acc = new ByteArrayOutputStream();
        byte[] buf = new byte[8192];
        int n;
        while ((n = pin.read(buf)) > 0) {
            acc.write(buf, 0, n);
            processBinaryBuffer(acc, state);
        }
    }

    private void processBinaryBuffer(ByteArrayOutputStream acc, TcpConnState state) {
        byte[] data = acc.toByteArray();
        int off = 0;
        while (off + 6 <= data.length) {
            int mbLen = ModbusTcpSupport.readMbapLength(data, off);
            if (mbLen < 0) {
                break;
            }
            int total = 6 + mbLen;
            if (off + total > data.length) {
                break;
            }
            byte[] frame = Arrays.copyOfRange(data, off, off + total);
            handleBinaryFrame(frame, state);
            off += total;
        }
        acc.reset();
        if (off < data.length) {
            acc.write(data, off, data.length - off);
        }
    }

    private void handleBinaryFrame(byte[] frame, TcpConnState state) {
        if (ModbusTcpSupport.isReadRequest(frame)) {
            state.start = ModbusTcpSupport.parseReadRequestStartAddress(frame);
            return;
        }
        int[] regs = ModbusTcpSupport.parseReadRegistersResponse(frame);
        if (regs == null) {
            return;
        }
        int fc = ModbusTcpSupport.parseFunctionCode(frame);
        int regType = fc == 0x03 ? 0 : 1;
        int slave = ModbusTcpSupport.parseUnitId(frame);
        int base = state.start != null ? state.start : 0;
        meterModbusDataService.ingestRegisters(slave, regType, base, regs, new Date(), "TCP_MODBUS");
        state.start = null;
    }
}

