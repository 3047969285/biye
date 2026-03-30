package com.ruoyi.web.controller.meter;

import java.util.Date;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.framework.web.service.PermissionService;
import com.ruoyi.system.service.IMeterModbusDataService;
import com.ruoyi.web.config.properties.MeterModbusProperties;
import com.ruoyi.web.controller.meter.dto.MeterIngestPayload;
import com.ruoyi.web.meter.MeterIngestParseUtil;

/**
 * HTTP 上报寄存器块并入库（与 TCP 网口逻辑一致）
 */
@RestController
@RequestMapping("/meter/data")
public class MeterDataIngestController extends BaseController {

    private final MeterModbusProperties props;
    private final IMeterModbusDataService meterModbusDataService;
    private final PermissionService permissionService;

    public MeterDataIngestController(MeterModbusProperties props, IMeterModbusDataService meterModbusDataService,
        PermissionService permissionService) {
        this.props = props;
        this.meterModbusDataService = meterModbusDataService;
        this.permissionService = permissionService;
    }

    @PostMapping("/ingest")
    public AjaxResult ingest(
        @RequestHeader(value = "X-Meter-Api-Key", required = false) String apiKey,
        @RequestBody MeterIngestPayload body) {
        if (!allowIngest(apiKey)) {
            return error("无权限访问数据上报接口");
        }
        if (body.getRegisters() == null || body.getRegisters().isEmpty()) {
            return error("registers 不能为空");
        }
        int[] regs = body.getRegisters().stream().mapToInt(Integer::intValue).toArray();
        int slave = body.getSlaveId() != null ? body.getSlaveId() : 1;
        int rt = body.getRegisterType() != null ? body.getRegisterType() : 0;
        int base = body.getBaseAddress() != null ? body.getBaseAddress() : 0;
        Date readTime = MeterIngestParseUtil.parseReadTime(body.getReadTime());
        int n = meterModbusDataService.ingestRegisters(slave, rt, base, regs, readTime, "HTTP");
        return success("写入 " + n + " 条采样");
    }

    private boolean allowIngest(String apiKey) {
        if (StringUtils.isNotEmpty(props.getIngestApiKey())) {
            return props.getIngestApiKey().equals(apiKey);
        }
        try {
            return permissionService.hasPermi("meter:data:ingest");
        } catch (Exception e) {
            return false;
        }
    }
}

