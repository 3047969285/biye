package com.example.modbus.tcp;

import com.example.modbus.model.InputRegisters;
import com.serotonin.modbus4j.ModbusSlaveSet;
import com.serotonin.modbus4j.exception.ModbusInitException;
import com.serotonin.modbus4j.ip.tcp.TcpSlave;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import java.util.concurrent.*;

/**
 * Modbus TCP从站生命周期管理 - 基于InputRegisters
 */
@Slf4j
@Component
@ConditionalOnProperty(prefix = "protocol-trans", name = "enabled", havingValue = "true")
public class ModbusTcpSlaveLifecycle {

    @Autowired
    @Qualifier("modbusInputRegisters")
    private InputRegisters inputRegisters;

    private final boolean enabled;
    private final int port;
    private final boolean encapsulated;

    private volatile ModbusSlaveSet slave;
    private volatile ExecutorService slaveExecutor;

    public ModbusTcpSlaveLifecycle(
            @Value("${protocol-trans.modbus.tcp.enabled:true}") boolean enabled,
            @Value("${protocol-trans.modbus.tcp.port:502}") int port,
            @Value("${protocol-trans.modbus.tcp.encapsulated:false}") boolean encapsulated) {
        this.enabled = enabled;
        this.port = port;
        this.encapsulated = encapsulated;
    }

    @PostConstruct
    public void start() {
        if (!enabled) {
            log.info("Modbus TCP 从站未启用");
            return;
        }
        
        slave = new TcpSlave(port, encapsulated);
        
        // 注册单个从站，使用InputRegisters作为数据源
        slave.addProcessImage(new RegisterBankProcessImage(1, inputRegisters));
        log.info("注册 Modbus 从站 slaveId=1 (基于InputRegisters)");
        
        ThreadFactory threadFactory = runnable -> {
            Thread thread = new Thread(runnable, "modbus-tcp-slave");
            thread.setDaemon(true);
            return thread;
        };

        // 创建线程池,因为slave内部会管理多主站连接，不必设置多个线程数
        slaveExecutor = new ThreadPoolExecutor(
                1, 1,
                0L, TimeUnit.MILLISECONDS,
                new LinkedBlockingQueue<>(1),
                threadFactory,
                new ThreadPoolExecutor.AbortPolicy()
        );
        slaveExecutor.submit(() -> {
            try {
                log.info("Modbus TCP 从站开始监听端口 {} | 寄存器区: 10000个输入寄存器", port);
                slave.start();
            } catch (ModbusInitException e) {
                log.error("Modbus TCP 从站启动失败: {}", e.getMessage(), e);
            }
        });
    }

    @PreDestroy
    public void stop() {
        if (slave != null) {
            try {
                slave.stop();
                log.info("Modbus TCP 从站已停止");
            } catch (Exception e) {
                log.error("停止 Modbus TCP 从站时异常", e);
            }
        }
        if (slaveExecutor != null) {
            slaveExecutor.shutdownNow();
        }
    }
}
