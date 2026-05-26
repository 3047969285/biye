## ProtocolTrans 概览

`ProtocolTrans` 是一个多模块 Maven 项目，用来把电表侧 `DL/T645` / `DL/T698` 数据采集后，统一映射到 `Modbus TCP` 输入寄存器对外提供。

### 1. 模块说明

- `dl645`：DL645 / DL698 协议通信、帧解析、点位解析策略
- `modbus`：Modbus TCP 从站、`InputRegisters` 模型、简单客户端测试
- `registerStart`：Spring Boot 启动入口、定时采集任务、协议数据 -> Modbus 寄存器映射

### 2. 整体流程

1. 启动 `ProtocolTransApplication`（模块 `registerStart`）。
2. `DataCollectionTask` 根据 `meter.collection.cron` 定时遍历电表列表。
3. 按设备配置选择协议与通道：
   - `type=tcp, protocol=dl645` → `DL645TcpProcessService` + `DL645TcpCollectServiceImpl`
   - `type=serial, protocol=dl645` → `DL645SerialProcessService` + `DL645SerialCollectServiceImpl`
   - `type=tcp, protocol=dl698` → `DL698TcpProcessService` + `DL698*CollectServiceImpl`
4. 采集服务按 `protocol.dl645.di` / `protocol.dl698.oad` 中配置的**所有点位**轮询发送读命令，并通过解析策略得到数值。
5. `DataCacheServiceImpl` 按 `protocol.register-types` 配置的顺序与类型，把点位值写入 `InputRegisters`（共享数组，长度 10000）。
6. `modbus` 模块中的 `ModbusTcpSlaveLifecycle` 暴露 `slaveId=1` 的从站，外部主站通过功能码 `0x04` 读取输入寄存器。

### 3. 关键配置（`registerStart/src/main/resources/application.yml`）

**Modbus 从站**

- `modbus.tcp.port`：默认 `502`
- `modbus.tcp.enabled`：是否启用从站

**电表采集列表**

```yaml
meter:
  collection:
    cron: "0/30 * * * * ?"  # 采集周期
    devices:
      - name: "电表1 (TCP-DL645)"
        type: tcp            # tcp / serial
        protocol: dl645      # dl645 / dl698
        index: 0             # 电表序号，从0开始
        ip: "127.0.0.1"
        port: 9988
        address: "000000000001"
        timeout: 5000
      - name: "电表2 (串口-DL645)"
        type: serial
        protocol: dl645
        index: 1
        comPort: COM15
        address: "000071447565"
        timeout: 5000
        baudRate: 2400
```

**协议点位与数据类型（完全由配置驱动）**

```yaml
protocol:
  # 原始点位标识 (DI)
  dl645:
    di:
      "50001": "00000000"
      "50002": "00010000"
      "50003": "00020000"
      "50004": "02030000"   # 例如总无功功率
      "50005": "00000100"   # 例如组合有功费率1

  # 原始点位标识 (OAD)
  dl698:
    oad:
      "50001": "00000201"
      "50002": "00100201"
      "50003": "00100202"

  # Modbus 寄存器映射：点位编码 -> 数据类型 + 顺序
  register-types:
    "50001": "float32"
    "50002": "uint32"
    "50003": "uint32"
    "50004": "float32"
    "50005": "float32"
```

- **采集哪些点位** 由 `dl645.di` / `dl698.oad` 决定，点位数量完全动态。
- **写入哪些寄存器、按什么类型、顺序如何** 由 `register-types` 决定：
  - 支持类型：`float32 / uint32 / int32 / uint16 / int16 / float64(double64) / uint64(double64_unsigned) / int64`，以及若干别名（如 `float`、`dword`、`word` 等）。

### 4. 寄存器布局与地址分配

- 统一使用 `InputRegisters`（长度 10000）作为共享缓冲区。
- 每个电表占用固定 200 个寄存器：
  - `baseAddress = meterIndex * 200`
  - 第一个电表：偏移 `0-199`
  - 第二个电表：偏移 `200-399`
  - 以此类推
- 在同一电表内部，`DataCacheServiceImpl` 按 `register-types` 的顺序依次写入：
  - `float32 / uint32 / int32` 占用 2 个寄存器
  - `uint16 / int16` 占用 1 个寄存器
  - `float64 / uint64 / int64` 占用 4 个寄存器

日志示例（单表）：

- `DL645 电表1 数据更新完成 | 映射点位数: 5 | 占用寄存器数: 10`

表示该表配置了 5 个点位，实际使用了 10 个寄存器空间。

### 5. 数值解析与负数支持（DL645）

- 电能量类 DI（`00xxxxxx`）由 `EnergyParseStrategy` 解析：
  - 按 `XXXXXXXX.XX` 规则转换（小数两位）
  - 支持**带符号 BCD**（最高位 bit7 为符号位），可以正确解析负电能
- 瞬时量类 DI（`02xxxxxx`）由 `MeasurementParseStrategy` 解析：
  - 电压、电流、功率等按协议定义的因子（BCD/二进制）换算
- 任何解析失败不会影响整个批次：
  - 日志会打印：`DL645点位解析失败 pointDi=... raw=...`
  - 对应点位写入 0（或空），其余点位照常生效

### 6. 快速联调步骤

1. **启动服务**
   - 运行 `registerStart` 模块的 `ProtocolTransApplication`。
   - 确认日志中有：
     - `Modbus TCP 从站开始监听端口 502`
     - `开始定时数据采集任务，共 N 个电表`
2. **观察采集日志**
   - 找到类似：
     - `开始采集电表1 数据 ...`
     - `DL645 电表1 数据更新完成 | 映射点位数: ...`
   - 如果某点位解析异常，会有 `DL645点位解析失败 pointDi=...` 提示，可据此调整 `di` 或解析策略。
3. **用 Modbus 客户端验证**
   - 连接参数：
     - `host = 127.0.0.1`
     - `port = 502`
     - `slaveId = 1`
   - 功能码：`0x04`（读输入寄存器）
   - 对某表：
     - `start = meterIndex * 200`
     - `length` 取够用的长度（如 20）
   - 对返回的寄存器数组，按 `register-types` 和数据类型反解，即可拿到对应的测量值。

> 总结：  
> - **新增点位**：只需在 `protocol.dl645.di` / `protocol.dl698.oad` 中增加编码，并在 `register-types` 中配置类型与顺序，无需改 Java 代码。  
> - **新增数据类型**：原则上只需扩展 `DataCacheServiceImpl.writeByType` 中的分支逻辑。  
> - **解析异常**：看日志中的 `DL645点位解析失败` / `float数值转换失败`，定位到具体 DI 或点位编码，再按需要调整配置或解析策略。 

