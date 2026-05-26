package com.example.dl645.core.parse.dl645;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 由 DL/T 645-2007 按照文档制作静态数据标识解析策略规则表。
 */
final class Dl645DocRuleCatalog {
    private static final Map<String, Dl645DocRuleRegistry.Rule> RULES = build();

    private Dl645DocRuleCatalog() {
    }

    static Dl645DocRuleRegistry.Rule get(String di) {
        return RULES.get(di);
    }

    static int size() {
        return RULES.size();
    }

    private static Map<String, Dl645DocRuleRegistry.Rule> build() {
        Map<String, Dl645DocRuleRegistry.Rule> map = new LinkedHashMap<>();
        // 00000000 含义: 组合有功总电能
        map.put("00000000", new Dl645DocRuleRegistry.Rule("00000000", "ENERGY_BCD", "XXXXXX.XX"));
        // 00000101 含义: 组合有功费率1电能
        map.put("00000101", new Dl645DocRuleRegistry.Rule("00000101", "ENERGY_BCD", "XXXXXX.XX"));
        // 00010000 含义: 正向有功总电能
        map.put("00010000", new Dl645DocRuleRegistry.Rule("00010000", "ENERGY_BCD", "XXXXXX.XX"));
        // 00020000 含义: 反向有功总电能
        map.put("00020000", new Dl645DocRuleRegistry.Rule("00020000", "ENERGY_BCD", "XXXXXX.XX"));
        // 000B0000 含义: 数据项名称
        map.put("000B0000", new Dl645DocRuleRegistry.Rule("000B0000", "ENERGY_BCD", "XXXXXX.XX"));
        // 000B0001 含义: DI3 DI2 DI1 DI0 读写
        map.put("000B0001", new Dl645DocRuleRegistry.Rule("000B0001", "ENERGY_BCD", "XXXXXX.XX"));
        // 00900100 含义: (上 12 结算日)C 相铜损有功电能补偿量
        map.put("00900100", new Dl645DocRuleRegistry.Rule("00900100", "ENERGY_BCD", "XXXXXX.XX"));
        // 00900200 含义: （当前）剩余电量
        map.put("00900200", new Dl645DocRuleRegistry.Rule("00900200", "ENERGY_BCD", "XXXXXX.XX"));
        // 01010000 含义: 正向有功最大需量（项目补充
        map.put("01010000", new Dl645DocRuleRegistry.Rule("01010000", "PARAMETER", "XX.XXXX"));
        // 02020100 含义: A相电流（项目补充
        map.put("02020100", new Dl645DocRuleRegistry.Rule("02020100", "MEASUREMENT", "XXX.XXX"));
        // 02030000 含义: 瞬时有功功率（项目补充
        map.put("02030000", new Dl645DocRuleRegistry.Rule("02030000", "MEASUREMENT", "XX.XXXX"));
        // 020A0101 含义: C 相电流波形失真度（多值/块数据，暂不启用）
        // map.put("020A0101", new Dl645DocRuleRegistry.Rule("020A0101", "MEASUREMENT", ""));
        // 020A0201 含义: A 相电压 21 次谐波含量（多值/块数据，暂不启用）
        // map.put("020A0201", new Dl645DocRuleRegistry.Rule("020A0201", "MEASUREMENT", ""));
        // 020A0301 含义: B 相电压 21 次谐波含量（多值/块数据，暂不启用）
        // map.put("020A0301", new Dl645DocRuleRegistry.Rule("020A0301", "MEASUREMENT", ""));
        // 020B0101 含义: C 相电压 21 次谐波含量（多值/块数据，暂不启用）
        // map.put("020B0101", new Dl645DocRuleRegistry.Rule("020B0101", "MEASUREMENT", ""));
        // 020B0201 含义: A 相电流 21 次谐波含量
        map.put("020B0201", new Dl645DocRuleRegistry.Rule("020B0201", "MEASUREMENT", "XX.XX"));
        // 020B0301 含义: B 相电流 21 次谐波含量（多值/块数据，暂不启用）
        // map.put("020B0301", new Dl645DocRuleRegistry.Rule("020B0301", "MEASUREMENT", ""));
        // 02800001 含义: C 相电流 21 次谐波含量（多值/块数据，暂不启用）
        // map.put("02800001", new Dl645DocRuleRegistry.Rule("02800001", "MEASUREMENT", ""));
        // 03010000 含义: 功能（多值/块数据，暂不启用）
        // map.put("03010000", new Dl645DocRuleRegistry.Rule("03010000", "EVENT_RECORD", ""));
        // 03010101 含义: B相失压总次数，总累计时间
        map.put("03010101", new Dl645DocRuleRegistry.Rule("03010101", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03010102 含义: DI3 DI2 DI1 DI0（多值/块数据，暂不启用）
        // map.put("03010102", new Dl645DocRuleRegistry.Rule("03010102", "EVENT_RECORD", ""));
        // 03010201 含义: …（多值/块数据，暂不启用）
        // map.put("03010201", new Dl645DocRuleRegistry.Rule("03010201", "EVENT_RECORD", ""));
        // 03010301 含义: …（多值/块数据，暂不启用）
        // map.put("03010301", new Dl645DocRuleRegistry.Rule("03010301", "EVENT_RECORD", ""));
        // 03020000 含义: …（多值/块数据，暂不启用）
        // map.put("03020000", new Dl645DocRuleRegistry.Rule("03020000", "EVENT_RECORD", ""));
        // 03020101 含义: B相欠压总次数，总累计时间（多值/块数据，暂不启用）
        // map.put("03020101", new Dl645DocRuleRegistry.Rule("03020101", "EVENT_RECORD", ""));
        // 03020201 含义: …（多值/块数据，暂不启用）
        // map.put("03020201", new Dl645DocRuleRegistry.Rule("03020201", "EVENT_RECORD", ""));
        // 03020301 含义: …（多值/块数据，暂不启用）
        // map.put("03020301", new Dl645DocRuleRegistry.Rule("03020301", "EVENT_RECORD", ""));
        // 03030000 含义: …（多值/块数据，暂不启用）
        // map.put("03030000", new Dl645DocRuleRegistry.Rule("03030000", "EVENT_RECORD", ""));
        // 03030101 含义: B相过压总次数，总累计时间（多值/块数据，暂不启用）
        // map.put("03030101", new Dl645DocRuleRegistry.Rule("03030101", "EVENT_RECORD", ""));
        // 03030201 含义: …（多值/块数据，暂不启用）
        // map.put("03030201", new Dl645DocRuleRegistry.Rule("03030201", "EVENT_RECORD", ""));
        // 03030301 含义: …（多值/块数据，暂不启用）
        // map.put("03030301", new Dl645DocRuleRegistry.Rule("03030301", "EVENT_RECORD", ""));
        // 03040000 含义: …（多值/块数据，暂不启用）
        // map.put("03040000", new Dl645DocRuleRegistry.Rule("03040000", "EVENT_RECORD", ""));
        // 03040101 含义: 读写（多值/块数据，暂不启用）
        // map.put("03040101", new Dl645DocRuleRegistry.Rule("03040101", "EVENT_RECORD", ""));
        // 03040201 含义: …（多值/块数据，暂不启用）
        // map.put("03040201", new Dl645DocRuleRegistry.Rule("03040201", "EVENT_RECORD", ""));
        // 03040301 含义: …（多值/块数据，暂不启用）
        // map.put("03040301", new Dl645DocRuleRegistry.Rule("03040301", "EVENT_RECORD", ""));
        // 03050000 含义: …（多值/块数据，暂不启用）
        // map.put("03050000", new Dl645DocRuleRegistry.Rule("03050000", "EVENT_RECORD", ""));
        // 03050001 含义: （上10次）C相断相记录 (同失压)（多值/块数据，暂不启用）
        // map.put("03050001", new Dl645DocRuleRegistry.Rule("03050001", "EVENT_RECORD", ""));
        // 03060000 含义: （上10次）全失压发生时刻，电流值，结束（多值/块数据，暂不启用）
        // map.put("03060000", new Dl645DocRuleRegistry.Rule("03060000", "EVENT_RECORD", ""));
        // 03060001 含义: 时刻（多值/块数据，暂不启用）
        // map.put("03060001", new Dl645DocRuleRegistry.Rule("03060001", "EVENT_RECORD", ""));
        // 03070000 含义: （上10次）辅助电源失电发生时刻，结束时
        map.put("03070000", new Dl645DocRuleRegistry.Rule("03070000", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03070001 含义: 刻
        map.put("03070001", new Dl645DocRuleRegistry.Rule("03070001", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03070002 含义: 电压逆相序期间 C 相组合无功 1 电能增量（多值/块数据，暂不启用）
        // map.put("03070002", new Dl645DocRuleRegistry.Rule("03070002", "EVENT_RECORD", ""));
        // 03080000 含义: …（多值/块数据，暂不启用）
        // map.put("03080000", new Dl645DocRuleRegistry.Rule("03080000", "EVENT_RECORD", ""));
        // 03080001 含义: （上10次）电压逆相序记录 (同上)（多值/块数据，暂不启用）
        // map.put("03080001", new Dl645DocRuleRegistry.Rule("03080001", "EVENT_RECORD", ""));
        // 03090000 含义: …
        map.put("03090000", new Dl645DocRuleRegistry.Rule("03090000", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03090001 含义: （上10次） 电流逆相序记录 (同电压逆相序)
        map.put("03090001", new Dl645DocRuleRegistry.Rule("03090001", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03090002 含义: 电压不平衡期间 C 相组合无功 1 电能增量（多值/块数据，暂不启用）
        // map.put("03090002", new Dl645DocRuleRegistry.Rule("03090002", "EVENT_RECORD", ""));
        // 030A0000 含义: …（多值/块数据，暂不启用）
        // map.put("030A0000", new Dl645DocRuleRegistry.Rule("030A0000", "EVENT_RECORD", ""));
        // 030A0001 含义: （上10次）电压不平衡记录 (同上)（多值/块数据，暂不启用）
        // map.put("030A0001", new Dl645DocRuleRegistry.Rule("030A0001", "EVENT_RECORD", ""));
        // 030B0000 含义: …（多值/块数据，暂不启用）
        // map.put("030B0000", new Dl645DocRuleRegistry.Rule("030B0000", "EVENT_RECORD", ""));
        // 030B0101 含义: B 相失流总次数，总累计时间
        map.put("030B0101", new Dl645DocRuleRegistry.Rule("030B0101", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 030B0102 含义: 失流时刻C相无功功率（多值/块数据，暂不启用）
        // map.put("030B0102", new Dl645DocRuleRegistry.Rule("030B0102", "EVENT_RECORD", ""));
        // 030B0201 含义: …（多值/块数据，暂不启用）
        // map.put("030B0201", new Dl645DocRuleRegistry.Rule("030B0201", "EVENT_RECORD", ""));
        // 030B0301 含义: …（多值/块数据，暂不启用）
        // map.put("030B0301", new Dl645DocRuleRegistry.Rule("030B0301", "EVENT_RECORD", ""));
        // 030C0000 含义: …（多值/块数据，暂不启用）
        // map.put("030C0000", new Dl645DocRuleRegistry.Rule("030C0000", "EVENT_RECORD", ""));
        // 030C0101 含义: B 相过流总次数，总累计时间（多值/块数据，暂不启用）
        // map.put("030C0101", new Dl645DocRuleRegistry.Rule("030C0101", "EVENT_RECORD", ""));
        // 030C0201 含义: …（多值/块数据，暂不启用）
        // map.put("030C0201", new Dl645DocRuleRegistry.Rule("030C0201", "EVENT_RECORD", ""));
        // 030C0301 含义: …（多值/块数据，暂不启用）
        // map.put("030C0301", new Dl645DocRuleRegistry.Rule("030C0301", "EVENT_RECORD", ""));
        // 030D0000 含义: …（多值/块数据，暂不启用）
        // map.put("030D0000", new Dl645DocRuleRegistry.Rule("030D0000", "EVENT_RECORD", ""));
        // 030D0101 含义: B 相断流总次数，总累计时间（多值/块数据，暂不启用）
        // map.put("030D0101", new Dl645DocRuleRegistry.Rule("030D0101", "EVENT_RECORD", ""));
        // 030D0201 含义: …（多值/块数据，暂不启用）
        // map.put("030D0201", new Dl645DocRuleRegistry.Rule("030D0201", "EVENT_RECORD", ""));
        // 030D0301 含义: 读写（多值/块数据，暂不启用）
        // map.put("030D0301", new Dl645DocRuleRegistry.Rule("030D0301", "EVENT_RECORD", ""));
        // 030E0000 含义: …（多值/块数据，暂不启用）
        // map.put("030E0000", new Dl645DocRuleRegistry.Rule("030E0000", "EVENT_RECORD", ""));
        // 030E0101 含义: B 相潮流反向总次数，总累计时间
        map.put("030E0101", new Dl645DocRuleRegistry.Rule("030E0101", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 030E0102 含义: 潮流反向期间 C 相组合无功 1 电能增量（多值/块数据，暂不启用）
        // map.put("030E0102", new Dl645DocRuleRegistry.Rule("030E0102", "EVENT_RECORD", ""));
        // 030E0201 含义: …（多值/块数据，暂不启用）
        // map.put("030E0201", new Dl645DocRuleRegistry.Rule("030E0201", "EVENT_RECORD", ""));
        // 030E0301 含义: …（多值/块数据，暂不启用）
        // map.put("030E0301", new Dl645DocRuleRegistry.Rule("030E0301", "EVENT_RECORD", ""));
        // 030F0000 含义: …（多值/块数据，暂不启用）
        // map.put("030F0000", new Dl645DocRuleRegistry.Rule("030F0000", "EVENT_RECORD", ""));
        // 030F0101 含义: 读写（多值/块数据，暂不启用）
        // map.put("030F0101", new Dl645DocRuleRegistry.Rule("030F0101", "EVENT_RECORD", ""));
        // 030F0201 含义: …（多值/块数据，暂不启用）
        // map.put("030F0201", new Dl645DocRuleRegistry.Rule("030F0201", "EVENT_RECORD", ""));
        // 030F0301 含义: …（多值/块数据，暂不启用）
        // map.put("030F0301", new Dl645DocRuleRegistry.Rule("030F0301", "EVENT_RECORD", ""));
        // 03100000 含义: …
        map.put("03100000", new Dl645DocRuleRegistry.Rule("03100000", "EVENT_RECORD", "XXX.X"));
        // 03100001 含义: 最低电压（多值/块数据，暂不启用）
        // map.put("03100001", new Dl645DocRuleRegistry.Rule("03100001", "EVENT_RECORD", ""));
        // 03100100 含义: …
        map.put("03100100", new Dl645DocRuleRegistry.Rule("03100100", "EVENT_RECORD", "XXX.X"));
        // 03100101 含义: A 相最低电压（多值/块数据，暂不启用）
        // map.put("03100101", new Dl645DocRuleRegistry.Rule("03100101", "EVENT_RECORD", ""));
        // 03100200 含义: …（多值/块数据，暂不启用）
        // map.put("03100200", new Dl645DocRuleRegistry.Rule("03100200", "EVENT_RECORD", ""));
        // 03100300 含义: （上12月）B 相电压合格率统计数据(同（多值/块数据，暂不启用）
        // map.put("03100300", new Dl645DocRuleRegistry.Rule("03100300", "EVENT_RECORD", ""));
        // 03110000 含义: （上12月）C 相电压合格率统计数据(同（多值/块数据，暂不启用）
        // map.put("03110000", new Dl645DocRuleRegistry.Rule("03110000", "EVENT_RECORD", ""));
        // 03110001 含义: A相 )（多值/块数据，暂不启用）
        // map.put("03110001", new Dl645DocRuleRegistry.Rule("03110001", "EVENT_RECORD", ""));
        // 03120000 含义: …（多值/块数据，暂不启用）
        // map.put("03120000", new Dl645DocRuleRegistry.Rule("03120000", "EVENT_RECORD", ""));
        // 03120101 含义: 第三象限无功需量超限总次数
        map.put("03120101", new Dl645DocRuleRegistry.Rule("03120101", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03120102 含义: 结束时刻（多值/块数据，暂不启用）
        // map.put("03120102", new Dl645DocRuleRegistry.Rule("03120102", "EVENT_RECORD", ""));
        // 03120201 含义: …（多值/块数据，暂不启用）
        // map.put("03120201", new Dl645DocRuleRegistry.Rule("03120201", "EVENT_RECORD", ""));
        // 03120301 含义: …（多值/块数据，暂不启用）
        // map.put("03120301", new Dl645DocRuleRegistry.Rule("03120301", "EVENT_RECORD", ""));
        // 03120401 含义: (上10次) 第一象限无功需量超限记录（同正（多值/块数据，暂不启用）
        // map.put("03120401", new Dl645DocRuleRegistry.Rule("03120401", "EVENT_RECORD", ""));
        // 03120501 含义: (上10次) 第二象限无功需量超限记录（同正（多值/块数据，暂不启用）
        // map.put("03120501", new Dl645DocRuleRegistry.Rule("03120501", "EVENT_RECORD", ""));
        // 03120601 含义: (上10次) 第三象限无功需量超限记录（同正（多值/块数据，暂不启用）
        // map.put("03120601", new Dl645DocRuleRegistry.Rule("03120601", "EVENT_RECORD", ""));
        // 03300000 含义: (上10次) 第四象限无功需量超限记录（同正
        map.put("03300000", new Dl645DocRuleRegistry.Rule("03300000", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300001 含义: 向）
        map.put("03300001", new Dl645DocRuleRegistry.Rule("03300001", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300002 含义: 编程的前 10 个数据标识码(不足补（多值/块数据，暂不启用）
        // map.put("03300002", new Dl645DocRuleRegistry.Rule("03300002", "EVENT_RECORD", ""));
        // 03300100 含义: …
        map.put("03300100", new Dl645DocRuleRegistry.Rule("03300100", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300101 含义: (上10次)编程记录(同上)
        map.put("03300101", new Dl645DocRuleRegistry.Rule("03300101", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300102 含义: 电量清零前C相第三象限无功电能（多值/块数据，暂不启用）
        // map.put("03300102", new Dl645DocRuleRegistry.Rule("03300102", "EVENT_RECORD", ""));
        // 03300200 含义: …
        map.put("03300200", new Dl645DocRuleRegistry.Rule("03300200", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300201 含义: (上10次)电量清零记录
        map.put("03300201", new Dl645DocRuleRegistry.Rule("03300201", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300202 含义: 需量清零前C相第四象限无功最大需量及发（多值/块数据，暂不启用）
        // map.put("03300202", new Dl645DocRuleRegistry.Rule("03300202", "EVENT_RECORD", ""));
        // 03300300 含义: …
        map.put("03300300", new Dl645DocRuleRegistry.Rule("03300300", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300301 含义: (上10次)需量清零记录
        map.put("03300301", new Dl645DocRuleRegistry.Rule("03300301", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300302 含义: 操作者代码（多值/块数据，暂不启用）
        // map.put("03300302", new Dl645DocRuleRegistry.Rule("03300302", "EVENT_RECORD", ""));
        // 03300400 含义: …（多值/块数据，暂不启用）
        // map.put("03300400", new Dl645DocRuleRegistry.Rule("03300400", "EVENT_RECORD", ""));
        // 03300401 含义: (上10次)事件清零记录(同上)
        map.put("03300401", new Dl645DocRuleRegistry.Rule("03300401", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300402 含义: 校时前时间（多值/块数据，暂不启用）
        // map.put("03300402", new Dl645DocRuleRegistry.Rule("03300402", "EVENT_RECORD", ""));
        // 03300500 含义: …
        map.put("03300500", new Dl645DocRuleRegistry.Rule("03300500", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300501 含义: (上10次)校时记录 (同上)
        map.put("03300501", new Dl645DocRuleRegistry.Rule("03300501", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300502 含义: …（多值/块数据，暂不启用）
        // map.put("03300502", new Dl645DocRuleRegistry.Rule("03300502", "EVENT_RECORD", ""));
        // 03300600 含义: …
        map.put("03300600", new Dl645DocRuleRegistry.Rule("03300600", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300601 含义: (上10次)时段表编程记录(同上)
        map.put("03300601", new Dl645DocRuleRegistry.Rule("03300601", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300602 含义: …（多值/块数据，暂不启用）
        // map.put("03300602", new Dl645DocRuleRegistry.Rule("03300602", "EVENT_RECORD", ""));
        // 03300700 含义: …
        map.put("03300700", new Dl645DocRuleRegistry.Rule("03300700", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300701 含义: (上10次)时区表编程记录(同上)
        map.put("03300701", new Dl645DocRuleRegistry.Rule("03300701", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300702 含义: 操作者代码（多值/块数据，暂不启用）
        // map.put("03300702", new Dl645DocRuleRegistry.Rule("03300702", "EVENT_RECORD", ""));
        // 03300800 含义: …
        map.put("03300800", new Dl645DocRuleRegistry.Rule("03300800", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300801 含义: (上10次)周休日编程记录(同上)
        map.put("03300801", new Dl645DocRuleRegistry.Rule("03300801", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300802 含义: 读写
        map.put("03300802", new Dl645DocRuleRegistry.Rule("03300802", "EVENT_RECORD", "NN"));
        // 03300900 含义: …
        map.put("03300900", new Dl645DocRuleRegistry.Rule("03300900", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300901 含义: (上10次)节假日编程记录 (同上)
        map.put("03300901", new Dl645DocRuleRegistry.Rule("03300901", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300902 含义: 操作者代码（多值/块数据，暂不启用）
        // map.put("03300902", new Dl645DocRuleRegistry.Rule("03300902", "EVENT_RECORD", ""));
        // 03300A00 含义: …（多值/块数据，暂不启用）
        // map.put("03300A00", new Dl645DocRuleRegistry.Rule("03300A00", "EVENT_RECORD", ""));
        // 03300A01 含义: (上10次)有功组合方式编程记录 (同上)（多值/块数据，暂不启用）
        // map.put("03300A01", new Dl645DocRuleRegistry.Rule("03300A01", "EVENT_RECORD", ""));
        // 03300B00 含义: (上10次)无功组合方式 1 编程记录 (同有（多值/块数据，暂不启用）
        // map.put("03300B00", new Dl645DocRuleRegistry.Rule("03300B00", "EVENT_RECORD", ""));
        // 03300B01 含义: 功)（多值/块数据，暂不启用）
        // map.put("03300B01", new Dl645DocRuleRegistry.Rule("03300B01", "EVENT_RECORD", ""));
        // 03300C00 含义: …
        map.put("03300C00", new Dl645DocRuleRegistry.Rule("03300C00", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300C01 含义: (上10次)无功组合方式 2 编程记录(同有功)
        map.put("03300C01", new Dl645DocRuleRegistry.Rule("03300C01", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300C02 含义: 结算日编程前每月第 2 结算日数据（多值/块数据，暂不启用）
        // map.put("03300C02", new Dl645DocRuleRegistry.Rule("03300C02", "EVENT_RECORD", ""));
        // 03300D00 含义: …
        map.put("03300D00", new Dl645DocRuleRegistry.Rule("03300D00", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300D01 含义: (上10次)结算日编程记录(同上)
        map.put("03300D01", new Dl645DocRuleRegistry.Rule("03300D01", "EVENT_RECORD", "YYMMDDhhmmss"));
        // 03300D02 含义: 开表盖后第三象限无功总电能（多值/块数据，暂不启用）
        // map.put("03300D02", new Dl645DocRuleRegistry.Rule("03300D02", "EVENT_RECORD", ""));
        // 03300E00 含义: …（多值/块数据，暂不启用）
        // map.put("03300E00", new Dl645DocRuleRegistry.Rule("03300E00", "EVENT_RECORD", ""));
        // 03300E01 含义: (上10次)开表盖记录(同上)（多值/块数据，暂不启用）
        // map.put("03300E01", new Dl645DocRuleRegistry.Rule("03300E01", "EVENT_RECORD", ""));
        // 04000101 含义: 功能（多值/块数据，暂不启用）
        // map.put("04000101", new Dl645DocRuleRegistry.Rule("04000101", "PARAMETER", ""));
        // 04000106 含义: 数据项名称（多值/块数据，暂不启用）
        // map.put("04000106", new Dl645DocRuleRegistry.Rule("04000106", "PARAMETER", ""));
        // 04000108 含义: DI
        map.put("04000108", new Dl645DocRuleRegistry.Rule("04000108", "PARAMETER", "YYMMDDhhmm"));
        // 04000201 含义: 两套日时段表切换时间
        map.put("04000201", new Dl645DocRuleRegistry.Rule("04000201", "PARAMETER", "NN"));
        // 04000301 含义: 谐波分析次数
        map.put("04000301", new Dl645DocRuleRegistry.Rule("04000301", "PARAMETER", "NN"));
        // 04000306 含义: YYMMDDhhmm 5 * 两套费率电价切换时
        map.put("04000306", new Dl645DocRuleRegistry.Rule("04000306", "PARAMETER", "YYMMDDhhmm"));
        // 04000401 含义: 数据项名称（多值/块数据，暂不启用）
        // map.put("04000401", new Dl645DocRuleRegistry.Rule("04000401", "PARAMETER", ""));
        // 04000402 含义: 表号（项目补充
        map.put("04000402", new Dl645DocRuleRegistry.Rule("04000402", "PARAMETER", "NNNNNNNNNNNN"));
        // 04000409 含义: 电能表有功常数（项目补充
        map.put("04000409", new Dl645DocRuleRegistry.Rule("04000409", "PARAMETER", "NNNNNN"));
        // 0400040E 含义: 电流互感器变比
        map.put("0400040E", new Dl645DocRuleRegistry.Rule("0400040E", "PARAMETER", "NNNNNNNNNNNN"));
        // 04000501 含义: 协议版本号（ASCII码）
        map.put("04000501", new Dl645DocRuleRegistry.Rule("04000501", "PARAMETER", "ASCII"));
        // 04000601 含义: 电表运行状态字 7（多值/块数据，暂不启用）
        // map.put("04000601", new Dl645DocRuleRegistry.Rule("04000601", "PARAMETER", ""));
        // 04000701 含义: 无功组合方式1特征字（多值/块数据，暂不启用）
        // map.put("04000701", new Dl645DocRuleRegistry.Rule("04000701", "PARAMETER", ""));
        // 04000801 含义: 公共假日数 n≤254
        map.put("04000801", new Dl645DocRuleRegistry.Rule("04000801", "PARAMETER", "NN"));
        // 04000901 含义: 周休日状态字（多值/块数据，暂不启用）
        // map.put("04000901", new Dl645DocRuleRegistry.Rule("04000901", "PARAMETER", ""));
        // 04000A01 含义: 整点冻结数据模式字（多值/块数据，暂不启用）
        // map.put("04000A01", new Dl645DocRuleRegistry.Rule("04000A01", "PARAMETER", ""));
        // 04000B01 含义: 周休日特征字（多值/块数据，暂不启用）
        // map.put("04000B01", new Dl645DocRuleRegistry.Rule("04000B01", "PARAMETER", ""));
        // 04000C01 含义: 每月第 2 结算日（多值/块数据，暂不启用）
        // map.put("04000C01", new Dl645DocRuleRegistry.Rule("04000C01", "PARAMETER", ""));
        // 04000D01 含义: …（多值/块数据，暂不启用）
        // map.put("04000D01", new Dl645DocRuleRegistry.Rule("04000D01", "PARAMETER", ""));
        // 04000E01 含义: C 相电阻系数（多值/块数据，暂不启用）
        // map.put("04000E01", new Dl645DocRuleRegistry.Rule("04000E01", "PARAMETER", ""));
        // 04000F01 含义: 电压上限值（多值/块数据，暂不启用）
        // map.put("04000F01", new Dl645DocRuleRegistry.Rule("04000F01", "PARAMETER", ""));
        // 04001001 含义: 电压互感器变比
        map.put("04001001", new Dl645DocRuleRegistry.Rule("04001001", "PARAMETER", "NNNNNNNNNNNN"));
        // 04001004 含义: 每月第 2 结算日
        map.put("04001004", new Dl645DocRuleRegistry.Rule("04001004", "PARAMETER", "NNNNNN"));
        // 04001101 含义: 囤积金额限值
        map.put("04001101", new Dl645DocRuleRegistry.Rule("04001101", "PARAMETER", "NN"));
        // 04001201 含义: 合闸金额允许限值
        map.put("04001201", new Dl645DocRuleRegistry.Rule("04001201", "PARAMETER", "NN"));
        // 04001301 含义: DI3 DI2 DI1 DI0 读写
        map.put("04001301", new Dl645DocRuleRegistry.Rule("04001301", "PARAMETER", "NN"));
        // 04001401 含义: 03 hhmm 2 时分 * * 日冻结时间
        map.put("04001401", new Dl645DocRuleRegistry.Rule("04001401", "PARAMETER", "NN"));
        // 04010000 含义: 囤积金额限值
        map.put("04010000", new Dl645DocRuleRegistry.Rule("04010000", "PARAMETER", "NN"));
        // 04010001 含义: 第 14 时区起始日期及日时
        map.put("04010001", new Dl645DocRuleRegistry.Rule("04010001", "PARAMETER", "NN"));
        // 04010002 含义: 第 14 时段起始时间及费率（多值/块数据，暂不启用）
        // map.put("04010002", new Dl645DocRuleRegistry.Rule("04010002", "PARAMETER", ""));
        // 04020000 含义: …
        map.put("04020000", new Dl645DocRuleRegistry.Rule("04020000", "PARAMETER", "NN"));
        // 04020001 含义: 第 14 时区起始日期及日时
        map.put("04020001", new Dl645DocRuleRegistry.Rule("04020001", "PARAMETER", "NN"));
        // 04020002 含义: 数据项名称（多值/块数据，暂不启用）
        // map.put("04020002", new Dl645DocRuleRegistry.Rule("04020002", "PARAMETER", ""));
        // 04030001 含义: …（多值/块数据，暂不启用）
        // map.put("04030001", new Dl645DocRuleRegistry.Rule("04030001", "PARAMETER", ""));
        // 04040101 含义: …（多值/块数据，暂不启用）
        // map.put("04040101", new Dl645DocRuleRegistry.Rule("04040101", "PARAMETER", ""));
        // 04040201 含义: …（多值/块数据，暂不启用）
        // map.put("04040201", new Dl645DocRuleRegistry.Rule("04040201", "PARAMETER", ""));
        // 04050101 含义: 报警金额 1 限值（多值/块数据，暂不启用）
        // map.put("04050101", new Dl645DocRuleRegistry.Rule("04050101", "PARAMETER", ""));
        // 04050201 含义: …
        map.put("04050201", new Dl645DocRuleRegistry.Rule("04050201", "PARAMETER", "NN"));
        // 04060001 含义: 第 254 公共假日日期及日时（多值/块数据，暂不启用）
        // map.put("04060001", new Dl645DocRuleRegistry.Rule("04060001", "PARAMETER", ""));
        // 04060101 含义: …（多值/块数据，暂不启用）
        // map.put("04060101", new Dl645DocRuleRegistry.Rule("04060101", "PARAMETER", ""));
        // 04060201 含义: …（多值/块数据，暂不启用）
        // map.put("04060201", new Dl645DocRuleRegistry.Rule("04060201", "PARAMETER", ""));
        // 04060301 含义: …（多值/块数据，暂不启用）
        // map.put("04060301", new Dl645DocRuleRegistry.Rule("04060301", "PARAMETER", ""));
        // 04090101 含义: …（多值/块数据，暂不启用）
        // map.put("04090101", new Dl645DocRuleRegistry.Rule("04090101", "PARAMETER", ""));
        // 04090201 含义: 失压事件电流触发下限
        map.put("04090201", new Dl645DocRuleRegistry.Rule("04090201", "PARAMETER", "NN"));
        // 04090301 含义: 欠压事件电压触发上限
        map.put("04090301", new Dl645DocRuleRegistry.Rule("04090301", "PARAMETER", "NN"));
        // 04090401 含义: 过压事件电压触发下限（多值/块数据，暂不启用）
        // map.put("04090401", new Dl645DocRuleRegistry.Rule("04090401", "PARAMETER", ""));
        // 04090501 含义: 断相事件电流触发上限
        map.put("04090501", new Dl645DocRuleRegistry.Rule("04090501", "PARAMETER", "NN"));
        // 04090601 含义: 电压不平衡率限值
        map.put("04090601", new Dl645DocRuleRegistry.Rule("04090601", "PARAMETER", "NN"));
        // 04090701 含义: 电流不平衡率限值（多值/块数据，暂不启用）
        // map.put("04090701", new Dl645DocRuleRegistry.Rule("04090701", "PARAMETER", ""));
        // 04090801 含义: 失流事件电流触发下限
        map.put("04090801", new Dl645DocRuleRegistry.Rule("04090801", "PARAMETER", "NN"));
        // 04090901 含义: 过流事件电流触发下限（多值/块数据，暂不启用）
        // map.put("04090901", new Dl645DocRuleRegistry.Rule("04090901", "PARAMETER", ""));
        // 04090A01 含义: 断流事件电流触发上限
        map.put("04090A01", new Dl645DocRuleRegistry.Rule("04090A01", "PARAMETER", "NN"));
        // 04090B01 含义: 潮流反向事件有功功率触发下限
        map.put("04090B01", new Dl645DocRuleRegistry.Rule("04090B01", "PARAMETER", "NN"));
        // 04090C01 含义: 数据项名称
        map.put("04090C01", new Dl645DocRuleRegistry.Rule("04090C01", "PARAMETER", "NN"));
        // 04090D01 含义: 电压考核上限（多值/块数据，暂不启用）
        // map.put("04090D01", new Dl645DocRuleRegistry.Rule("04090D01", "PARAMETER", ""));
        // 04090E01 含义: 无功需量超限事件需量触发下限
        map.put("04090E01", new Dl645DocRuleRegistry.Rule("04090E01", "PARAMETER", "NN"));
        // 04090F01 含义: 总功率因数超下限阀值
        map.put("04090F01", new Dl645DocRuleRegistry.Rule("04090F01", "PARAMETER", "NN"));
        // 04800001 含义: 电流严重不平衡限值（多值/块数据，暂不启用）
        // map.put("04800001", new Dl645DocRuleRegistry.Rule("04800001", "PARAMETER", ""));
        // 05000001 含义: 功能（多值/块数据，暂不启用）
        // map.put("05000001", new Dl645DocRuleRegistry.Rule("05000001", "FREEZE", ""));
        // 0500000C 含义: （上13次）定时冻结数据块（多值/块数据，暂不启用）
        // map.put("0500000C", new Dl645DocRuleRegistry.Rule("0500000C", "FREEZE", ""));
        // 05000101 含义: …（多值/块数据，暂不启用）
        // map.put("05000101", new Dl645DocRuleRegistry.Rule("05000101", "FREEZE", ""));
        // 0500010C 含义: …
        map.put("0500010C", new Dl645DocRuleRegistry.Rule("0500010C", "FREEZE", "XXXXXX.XX"));
        // 05000201 含义: …（多值/块数据，暂不启用）
        // map.put("05000201", new Dl645DocRuleRegistry.Rule("05000201", "FREEZE", ""));
        // 0500020C 含义: …（多值/块数据，暂不启用）
        // map.put("0500020C", new Dl645DocRuleRegistry.Rule("0500020C", "FREEZE", ""));
        // 05000301 含义: 数据项名称（多值/块数据，暂不启用）
        // map.put("05000301", new Dl645DocRuleRegistry.Rule("05000301", "FREEZE", ""));
        // 0500030C 含义: …（多值/块数据，暂不启用）
        // map.put("0500030C", new Dl645DocRuleRegistry.Rule("0500030C", "FREEZE", ""));
        // 05000401 含义: …（多值/块数据，暂不启用）
        // map.put("05000401", new Dl645DocRuleRegistry.Rule("05000401", "FREEZE", ""));
        // 0500040C 含义: …
        map.put("0500040C", new Dl645DocRuleRegistry.Rule("0500040C", "FREEZE", "XXXXXX.XX"));
        // 05000501 含义: …（多值/块数据，暂不启用）
        // map.put("05000501", new Dl645DocRuleRegistry.Rule("05000501", "FREEZE", ""));
        // 0500050C 含义: …（多值/块数据，暂不启用）
        // map.put("0500050C", new Dl645DocRuleRegistry.Rule("0500050C", "FREEZE", ""));
        // 05000601 含义: …（多值/块数据，暂不启用）
        // map.put("05000601", new Dl645DocRuleRegistry.Rule("05000601", "FREEZE", ""));
        // 0500060C 含义: …（多值/块数据，暂不启用）
        // map.put("0500060C", new Dl645DocRuleRegistry.Rule("0500060C", "FREEZE", ""));
        // 05000701 含义: …（多值/块数据，暂不启用）
        // map.put("05000701", new Dl645DocRuleRegistry.Rule("05000701", "FREEZE", ""));
        // 0500070C 含义: …
        map.put("0500070C", new Dl645DocRuleRegistry.Rule("0500070C", "FREEZE", "XXXXXX.XX"));
        // 05000801 含义: …（多值/块数据，暂不启用）
        // map.put("05000801", new Dl645DocRuleRegistry.Rule("05000801", "FREEZE", ""));
        // 0500080C 含义: …（多值/块数据，暂不启用）
        // map.put("0500080C", new Dl645DocRuleRegistry.Rule("0500080C", "FREEZE", ""));
        // 05000901 含义: …（多值/块数据，暂不启用）
        // map.put("05000901", new Dl645DocRuleRegistry.Rule("05000901", "FREEZE", ""));
        // 0500090C 含义: …（多值/块数据，暂不启用）
        // map.put("0500090C", new Dl645DocRuleRegistry.Rule("0500090C", "FREEZE", ""));
        // 05000A01 含义: …
        map.put("05000A01", new Dl645DocRuleRegistry.Rule("05000A01", "FREEZE", "XX.XXXX"));
        // 05000A0C 含义: …
        map.put("05000A0C", new Dl645DocRuleRegistry.Rule("05000A0C", "FREEZE", "XX.XXXX"));
        // 05001001 含义: …（多值/块数据，暂不启用）
        // map.put("05001001", new Dl645DocRuleRegistry.Rule("05001001", "FREEZE", ""));
        // 0500100C 含义: …（多值/块数据，暂不启用）
        // map.put("0500100C", new Dl645DocRuleRegistry.Rule("0500100C", "FREEZE", ""));
        // 05010001 含义: …
        map.put("05010001", new Dl645DocRuleRegistry.Rule("05010001", "FREEZE", "YYMMDDhhmm"));
        // 05010002 含义: C 相无功功率
        map.put("05010002", new Dl645DocRuleRegistry.Rule("05010002", "FREEZE", "YYMMDDhhmm"));
        // 05010003 含义: C 相无功功率
        map.put("05010003", new Dl645DocRuleRegistry.Rule("05010003", "FREEZE", "YYMMDDhhmm"));
        // 05010101 含义: （上60次）定时冻结数据块
        map.put("05010101", new Dl645DocRuleRegistry.Rule("05010101", "FREEZE", "YYMMDDhhmm"));
        // 05010102 含义: * （上1次）瞬时冻结数据块
        map.put("05010102", new Dl645DocRuleRegistry.Rule("05010102", "FREEZE", "YYMMDDhhmm"));
        // 05010103 含义: * （上2次）瞬时冻结数据块
        map.put("05010103", new Dl645DocRuleRegistry.Rule("05010103", "FREEZE", "YYMMDDhhmm"));
        // 05010201 含义: …
        map.put("05010201", new Dl645DocRuleRegistry.Rule("05010201", "FREEZE", "XXXXXX.XX"));
        // 05010202 含义: …
        map.put("05010202", new Dl645DocRuleRegistry.Rule("05010202", "FREEZE", "XXXXXX.XX"));
        // 05010203 含义: …
        map.put("05010203", new Dl645DocRuleRegistry.Rule("05010203", "FREEZE", "XXXXXX.XX"));
        // 05010301 含义: …
        map.put("05010301", new Dl645DocRuleRegistry.Rule("05010301", "FREEZE", "XXXXXX.XX"));
        // 05010302 含义: …
        map.put("05010302", new Dl645DocRuleRegistry.Rule("05010302", "FREEZE", "XXXXXX.XX"));
        // 05010303 含义: …
        map.put("05010303", new Dl645DocRuleRegistry.Rule("05010303", "FREEZE", "XXXXXX.XX"));
        // 05010401 含义: …
        map.put("05010401", new Dl645DocRuleRegistry.Rule("05010401", "FREEZE", "XXXXXX.XX"));
        // 05010402 含义: …
        map.put("05010402", new Dl645DocRuleRegistry.Rule("05010402", "FREEZE", "XXXXXX.XX"));
        // 05010403 含义: …
        map.put("05010403", new Dl645DocRuleRegistry.Rule("05010403", "FREEZE", "XXXXXX.XX"));
        // 05010501 含义: …
        map.put("05010501", new Dl645DocRuleRegistry.Rule("05010501", "FREEZE", "XXXXXX.XX"));
        // 05010502 含义: …
        map.put("05010502", new Dl645DocRuleRegistry.Rule("05010502", "FREEZE", "XXXXXX.XX"));
        // 05010503 含义: …
        map.put("05010503", new Dl645DocRuleRegistry.Rule("05010503", "FREEZE", "XXXXXX.XX"));
        // 05010601 含义: …
        map.put("05010601", new Dl645DocRuleRegistry.Rule("05010601", "FREEZE", "XXXXXX.XX"));
        // 05010602 含义: …
        map.put("05010602", new Dl645DocRuleRegistry.Rule("05010602", "FREEZE", "XXXXXX.XX"));
        // 05010603 含义: …
        map.put("05010603", new Dl645DocRuleRegistry.Rule("05010603", "FREEZE", "XXXXXX.XX"));
        // 05010701 含义: …
        map.put("05010701", new Dl645DocRuleRegistry.Rule("05010701", "FREEZE", "XXXXXX.XX"));
        // 05010702 含义: …
        map.put("05010702", new Dl645DocRuleRegistry.Rule("05010702", "FREEZE", "XXXXXX.XX"));
        // 05010703 含义: …
        map.put("05010703", new Dl645DocRuleRegistry.Rule("05010703", "FREEZE", "XXXXXX.XX"));
        // 05010801 含义: …
        map.put("05010801", new Dl645DocRuleRegistry.Rule("05010801", "FREEZE", "XXXXXX.XX"));
        // 05010802 含义: …
        map.put("05010802", new Dl645DocRuleRegistry.Rule("05010802", "FREEZE", "XXXXXX.XX"));
        // 05010803 含义: …
        map.put("05010803", new Dl645DocRuleRegistry.Rule("05010803", "FREEZE", "XXXXXX.XX"));
        // 05010901 含义: DI3 DI2 DI1 DI0 读写
        map.put("05010901", new Dl645DocRuleRegistry.Rule("05010901", "FREEZE", "XX.XXXX"));
        // 05010902 含义: …
        map.put("05010902", new Dl645DocRuleRegistry.Rule("05010902", "FREEZE", "XX.XXXX"));
        // 05010903 含义: …
        map.put("05010903", new Dl645DocRuleRegistry.Rule("05010903", "FREEZE", "XX.XXXX"));
        // 05010A01 含义: …
        map.put("05010A01", new Dl645DocRuleRegistry.Rule("05010A01", "FREEZE", "XX.XXXX"));
        // 05010A02 含义: …
        map.put("05010A02", new Dl645DocRuleRegistry.Rule("05010A02", "FREEZE", "XX.XXXX"));
        // 05010A03 含义: …
        map.put("05010A03", new Dl645DocRuleRegistry.Rule("05010A03", "FREEZE", "XX.XXXX"));
        // 05011001 含义: …
        map.put("05011001", new Dl645DocRuleRegistry.Rule("05011001", "FREEZE", "XX.XXXX"));
        // 05011002 含义: …
        map.put("05011002", new Dl645DocRuleRegistry.Rule("05011002", "FREEZE", "XX.XXXX"));
        // 05011003 含义: 数据项名称
        map.put("05011003", new Dl645DocRuleRegistry.Rule("05011003", "FREEZE", "XX.XXXX"));
        // 05020001 含义: C 相无功功率
        map.put("05020001", new Dl645DocRuleRegistry.Rule("05020001", "FREEZE", "YYMMDDhhmm"));
        // 05020002 含义: C 相无功功率
        map.put("05020002", new Dl645DocRuleRegistry.Rule("05020002", "FREEZE", "YYMMDDhhmm"));
        // 05020101 含义: * （上3次）瞬时冻结数据块
        map.put("05020101", new Dl645DocRuleRegistry.Rule("05020101", "FREEZE", "YYMMDDhhmm"));
        // 05020102 含义: * （上1次） 两套时区表切换数据块
        map.put("05020102", new Dl645DocRuleRegistry.Rule("05020102", "FREEZE", "YYMMDDhhmm"));
        // 05020201 含义: …
        map.put("05020201", new Dl645DocRuleRegistry.Rule("05020201", "FREEZE", "XXXXXX.XX"));
        // 05020202 含义: …
        map.put("05020202", new Dl645DocRuleRegistry.Rule("05020202", "FREEZE", "XXXXXX.XX"));
        // 05020301 含义: …
        map.put("05020301", new Dl645DocRuleRegistry.Rule("05020301", "FREEZE", "XXXXXX.XX"));
        // 05020302 含义: …
        map.put("05020302", new Dl645DocRuleRegistry.Rule("05020302", "FREEZE", "XXXXXX.XX"));
        // 05020401 含义: …
        map.put("05020401", new Dl645DocRuleRegistry.Rule("05020401", "FREEZE", "XXXXXX.XX"));
        // 05020402 含义: …
        map.put("05020402", new Dl645DocRuleRegistry.Rule("05020402", "FREEZE", "XXXXXX.XX"));
        // 05020501 含义: …
        map.put("05020501", new Dl645DocRuleRegistry.Rule("05020501", "FREEZE", "XXXXXX.XX"));
        // 05020502 含义: …
        map.put("05020502", new Dl645DocRuleRegistry.Rule("05020502", "FREEZE", "XXXXXX.XX"));
        // 05020601 含义: …
        map.put("05020601", new Dl645DocRuleRegistry.Rule("05020601", "FREEZE", "XXXXXX.XX"));
        // 05020602 含义: …
        map.put("05020602", new Dl645DocRuleRegistry.Rule("05020602", "FREEZE", "XXXXXX.XX"));
        // 05020701 含义: …
        map.put("05020701", new Dl645DocRuleRegistry.Rule("05020701", "FREEZE", "XXXXXX.XX"));
        // 05020702 含义: …
        map.put("05020702", new Dl645DocRuleRegistry.Rule("05020702", "FREEZE", "XXXXXX.XX"));
        // 05020801 含义: …
        map.put("05020801", new Dl645DocRuleRegistry.Rule("05020801", "FREEZE", "XXXXXX.XX"));
        // 05020802 含义: …
        map.put("05020802", new Dl645DocRuleRegistry.Rule("05020802", "FREEZE", "XXXXXX.XX"));
        // 05020901 含义: …
        map.put("05020901", new Dl645DocRuleRegistry.Rule("05020901", "FREEZE", "XX.XXXX"));
        // 05020902 含义: …
        map.put("05020902", new Dl645DocRuleRegistry.Rule("05020902", "FREEZE", "XX.XXXX"));
        // 05020A01 含义: …
        map.put("05020A01", new Dl645DocRuleRegistry.Rule("05020A01", "FREEZE", "XX.XXXX"));
        // 05020A02 含义: …
        map.put("05020A02", new Dl645DocRuleRegistry.Rule("05020A02", "FREEZE", "XX.XXXX"));
        // 05021001 含义: …
        map.put("05021001", new Dl645DocRuleRegistry.Rule("05021001", "FREEZE", "XX.XXXX"));
        // 05021002 含义: …
        map.put("05021002", new Dl645DocRuleRegistry.Rule("05021002", "FREEZE", "XX.XXXX"));
        // 05030001 含义: C 相无功功率
        map.put("05030001", new Dl645DocRuleRegistry.Rule("05030001", "FREEZE", "YYMMDDhhmm"));
        // 05030002 含义: C 相无功功率
        map.put("05030002", new Dl645DocRuleRegistry.Rule("05030002", "FREEZE", "YYMMDDhhmm"));
        // 05030101 含义: * （上2次） 两套时区表切换数据块
        map.put("05030101", new Dl645DocRuleRegistry.Rule("05030101", "FREEZE", "YYMMDDhhmm"));
        // 05030102 含义: * （上1次） 两套日时段表切换数据块
        map.put("05030102", new Dl645DocRuleRegistry.Rule("05030102", "FREEZE", "YYMMDDhhmm"));
        // 05030201 含义: …
        map.put("05030201", new Dl645DocRuleRegistry.Rule("05030201", "FREEZE", "XXXXXX.XX"));
        // 05030202 含义: …
        map.put("05030202", new Dl645DocRuleRegistry.Rule("05030202", "FREEZE", "XXXXXX.XX"));
        // 05030301 含义: …
        map.put("05030301", new Dl645DocRuleRegistry.Rule("05030301", "FREEZE", "XXXXXX.XX"));
        // 05030302 含义: …
        map.put("05030302", new Dl645DocRuleRegistry.Rule("05030302", "FREEZE", "XXXXXX.XX"));
        // 05030401 含义: …
        map.put("05030401", new Dl645DocRuleRegistry.Rule("05030401", "FREEZE", "XXXXXX.XX"));
        // 05030402 含义: …
        map.put("05030402", new Dl645DocRuleRegistry.Rule("05030402", "FREEZE", "XXXXXX.XX"));
        // 05030501 含义: …
        map.put("05030501", new Dl645DocRuleRegistry.Rule("05030501", "FREEZE", "XXXXXX.XX"));
        // 05030502 含义: …
        map.put("05030502", new Dl645DocRuleRegistry.Rule("05030502", "FREEZE", "XXXXXX.XX"));
        // 05030601 含义: …
        map.put("05030601", new Dl645DocRuleRegistry.Rule("05030601", "FREEZE", "XXXXXX.XX"));
        // 05030602 含义: …
        map.put("05030602", new Dl645DocRuleRegistry.Rule("05030602", "FREEZE", "XXXXXX.XX"));
        // 05030701 含义: …
        map.put("05030701", new Dl645DocRuleRegistry.Rule("05030701", "FREEZE", "XXXXXX.XX"));
        // 05030702 含义: …
        map.put("05030702", new Dl645DocRuleRegistry.Rule("05030702", "FREEZE", "XXXXXX.XX"));
        // 05030801 含义: …
        map.put("05030801", new Dl645DocRuleRegistry.Rule("05030801", "FREEZE", "XXXXXX.XX"));
        // 05030802 含义: …
        map.put("05030802", new Dl645DocRuleRegistry.Rule("05030802", "FREEZE", "XXXXXX.XX"));
        // 05030901 含义: …
        map.put("05030901", new Dl645DocRuleRegistry.Rule("05030901", "FREEZE", "XX.XXXX"));
        // 05030902 含义: …
        map.put("05030902", new Dl645DocRuleRegistry.Rule("05030902", "FREEZE", "XX.XXXX"));
        // 05030A01 含义: …
        map.put("05030A01", new Dl645DocRuleRegistry.Rule("05030A01", "FREEZE", "XX.XXXX"));
        // 05030A02 含义: …
        map.put("05030A02", new Dl645DocRuleRegistry.Rule("05030A02", "FREEZE", "XX.XXXX"));
        // 05031001 含义: …
        map.put("05031001", new Dl645DocRuleRegistry.Rule("05031001", "FREEZE", "XX.XXXX"));
        // 05031002 含义: …
        map.put("05031002", new Dl645DocRuleRegistry.Rule("05031002", "FREEZE", "XX.XXXX"));
        // 05040001 含义: C 相无功功率
        map.put("05040001", new Dl645DocRuleRegistry.Rule("05040001", "FREEZE", "YYMMDDhhmm"));
        // 050400FE 含义: * （上 1 次）整点冻结数据块
        map.put("050400FE", new Dl645DocRuleRegistry.Rule("050400FE", "FREEZE", "YYMMDDhhmm"));
        // 05040101 含义: * （上2次） 两套日时段表切换数据块
        map.put("05040101", new Dl645DocRuleRegistry.Rule("05040101", "FREEZE", "YYMMDDhhmm"));
        // 050401FE 含义: 05 … … … … … … …
        map.put("050401FE", new Dl645DocRuleRegistry.Rule("050401FE", "FREEZE", "YYMMDDhhmm"));
        // 05040201 含义: YYMMDDhhmm 5 年月日时分 * （上 1 次）整点冻结时间
        map.put("05040201", new Dl645DocRuleRegistry.Rule("05040201", "FREEZE", "YYMMDDhhmm"));
        // 050402FE 含义: YYMMDDhhmm 5 年月日时分 * （上 254 次）整点冻结时间
        map.put("050402FE", new Dl645DocRuleRegistry.Rule("050402FE", "FREEZE", "YYMMDDhhmm"));
        // 05050001 含义: XXXXXX.XX 4 kWh * （上 254 次）整点冻结反向有功总电能
        map.put("05050001", new Dl645DocRuleRegistry.Rule("05050001", "FREEZE", "XXXXXX.XX"));
        // 05050002 含义: C 相无功功率
        map.put("05050002", new Dl645DocRuleRegistry.Rule("05050002", "FREEZE", "YYMMDDhhmm"));
        // 05050101 含义: …
        map.put("05050101", new Dl645DocRuleRegistry.Rule("05050101", "FREEZE", "XXXXXX.XX"));
        // 05050102 含义: * （上 1 次）两套费率电价切换数据块
        map.put("05050102", new Dl645DocRuleRegistry.Rule("05050102", "FREEZE", "YYMMDDhhmm"));
        // 05050201 含义: …
        map.put("05050201", new Dl645DocRuleRegistry.Rule("05050201", "FREEZE", "XXXXXX.XX"));
        // 05050202 含义: …
        map.put("05050202", new Dl645DocRuleRegistry.Rule("05050202", "FREEZE", "XXXXXX.XX"));
        // 05050301 含义: …
        map.put("05050301", new Dl645DocRuleRegistry.Rule("05050301", "FREEZE", "XXXXXX.XX"));
        // 05050302 含义: …
        map.put("05050302", new Dl645DocRuleRegistry.Rule("05050302", "FREEZE", "XXXXXX.XX"));
        // 05050401 含义: …
        map.put("05050401", new Dl645DocRuleRegistry.Rule("05050401", "FREEZE", "XXXXXX.XX"));
        // 05050402 含义: …
        map.put("05050402", new Dl645DocRuleRegistry.Rule("05050402", "FREEZE", "XXXXXX.XX"));
        // 05050501 含义: …
        map.put("05050501", new Dl645DocRuleRegistry.Rule("05050501", "FREEZE", "XXXXXX.XX"));
        // 05050502 含义: …
        map.put("05050502", new Dl645DocRuleRegistry.Rule("05050502", "FREEZE", "XXXXXX.XX"));
        // 05050601 含义: …
        map.put("05050601", new Dl645DocRuleRegistry.Rule("05050601", "FREEZE", "XXXXXX.XX"));
        // 05050602 含义: …
        map.put("05050602", new Dl645DocRuleRegistry.Rule("05050602", "FREEZE", "XXXXXX.XX"));
        // 05050701 含义: …
        map.put("05050701", new Dl645DocRuleRegistry.Rule("05050701", "FREEZE", "XXXXXX.XX"));
        // 05050702 含义: …
        map.put("05050702", new Dl645DocRuleRegistry.Rule("05050702", "FREEZE", "XXXXXX.XX"));
        // 05050801 含义: …
        map.put("05050801", new Dl645DocRuleRegistry.Rule("05050801", "FREEZE", "XXXXXX.XX"));
        // 05050802 含义: DI3 DI2 DI1 DI0 读写
        map.put("05050802", new Dl645DocRuleRegistry.Rule("05050802", "FREEZE", "XXXXXX.XX"));
        // 05050901 含义: …
        map.put("05050901", new Dl645DocRuleRegistry.Rule("05050901", "FREEZE", "XX.XXXX"));
        // 05050902 含义: …
        map.put("05050902", new Dl645DocRuleRegistry.Rule("05050902", "FREEZE", "XX.XXXX"));
        // 05050A01 含义: …
        map.put("05050A01", new Dl645DocRuleRegistry.Rule("05050A01", "FREEZE", "XX.XXXX"));
        // 05050A02 含义: …
        map.put("05050A02", new Dl645DocRuleRegistry.Rule("05050A02", "FREEZE", "XX.XXXX"));
        // 05051001 含义: …
        map.put("05051001", new Dl645DocRuleRegistry.Rule("05051001", "FREEZE", "XX.XXXX"));
        // 05051002 含义: …
        map.put("05051002", new Dl645DocRuleRegistry.Rule("05051002", "FREEZE", "XX.XXXX"));
        // 05060001 含义: C 相无功功率
        map.put("05060001", new Dl645DocRuleRegistry.Rule("05060001", "FREEZE", "YYMMDDhhmm"));
        // 0506003E 含义: * （上 1 次）日冻结数据块
        map.put("0506003E", new Dl645DocRuleRegistry.Rule("0506003E", "FREEZE", "YYMMDDhhmm"));
        // 05060101 含义: * （上 2 次）两套费率电价切换数据块
        map.put("05060101", new Dl645DocRuleRegistry.Rule("05060101", "FREEZE", "YYMMDDhhmm"));
        // 0506013E 含义: 数据项名称
        map.put("0506013E", new Dl645DocRuleRegistry.Rule("0506013E", "FREEZE", "XXXXXX.XX"));
        // 05060201 含义: …
        map.put("05060201", new Dl645DocRuleRegistry.Rule("05060201", "FREEZE", "XXXXXX.XX"));
        // 0506023E 含义: …
        map.put("0506023E", new Dl645DocRuleRegistry.Rule("0506023E", "FREEZE", "XXXXXX.XX"));
        // 05060301 含义: …
        map.put("05060301", new Dl645DocRuleRegistry.Rule("05060301", "FREEZE", "XXXXXX.XX"));
        // 0506033E 含义: …
        map.put("0506033E", new Dl645DocRuleRegistry.Rule("0506033E", "FREEZE", "XXXXXX.XX"));
        // 05060401 含义: …
        map.put("05060401", new Dl645DocRuleRegistry.Rule("05060401", "FREEZE", "XXXXXX.XX"));
        // 0506043E 含义: …
        map.put("0506043E", new Dl645DocRuleRegistry.Rule("0506043E", "FREEZE", "XXXXXX.XX"));
        // 05060501 含义: …
        map.put("05060501", new Dl645DocRuleRegistry.Rule("05060501", "FREEZE", "XXXXXX.XX"));
        // 0506053E 含义: …
        map.put("0506053E", new Dl645DocRuleRegistry.Rule("0506053E", "FREEZE", "XXXXXX.XX"));
        // 05060601 含义: …
        map.put("05060601", new Dl645DocRuleRegistry.Rule("05060601", "FREEZE", "XXXXXX.XX"));
        // 0506063E 含义: …
        map.put("0506063E", new Dl645DocRuleRegistry.Rule("0506063E", "FREEZE", "XXXXXX.XX"));
        // 05060701 含义: …
        map.put("05060701", new Dl645DocRuleRegistry.Rule("05060701", "FREEZE", "XXXXXX.XX"));
        // 0506073E 含义: …
        map.put("0506073E", new Dl645DocRuleRegistry.Rule("0506073E", "FREEZE", "XXXXXX.XX"));
        // 05060801 含义: …
        map.put("05060801", new Dl645DocRuleRegistry.Rule("05060801", "FREEZE", "XXXXXX.XX"));
        // 0506083E 含义: …
        map.put("0506083E", new Dl645DocRuleRegistry.Rule("0506083E", "FREEZE", "XXXXXX.XX"));
        // 05060901 含义: …
        map.put("05060901", new Dl645DocRuleRegistry.Rule("05060901", "FREEZE", "XX.XXXX"));
        // 0506093E 含义: …
        map.put("0506093E", new Dl645DocRuleRegistry.Rule("0506093E", "FREEZE", "XX.XXXX"));
        // 05060A01 含义: …
        map.put("05060A01", new Dl645DocRuleRegistry.Rule("05060A01", "FREEZE", "XX.XXXX"));
        // 05060A3E 含义: …
        map.put("05060A3E", new Dl645DocRuleRegistry.Rule("05060A3E", "FREEZE", "XX.XXXX"));
        // 05061001 含义: …
        map.put("05061001", new Dl645DocRuleRegistry.Rule("05061001", "FREEZE", "XX.XXXX"));
        // 0506103E 含义: …
        map.put("0506103E", new Dl645DocRuleRegistry.Rule("0506103E", "FREEZE", "XX.XXXX"));
        // 05070001 含义: C 相无功功率
        map.put("05070001", new Dl645DocRuleRegistry.Rule("05070001", "FREEZE", "YYMMDDhhmm"));
        // 05070002 含义: C 相无功功率
        map.put("05070002", new Dl645DocRuleRegistry.Rule("05070002", "FREEZE", "YYMMDDhhmm"));
        // 05070101 含义: * （上 62 次）日冻结数据块
        map.put("05070101", new Dl645DocRuleRegistry.Rule("05070101", "FREEZE", "YYMMDDhhmm"));
        // 05070102 含义: * （上 1 次）两套阶梯切换数据块
        map.put("05070102", new Dl645DocRuleRegistry.Rule("05070102", "FREEZE", "YYMMDDhhmm"));
        // 05070201 含义: …
        map.put("05070201", new Dl645DocRuleRegistry.Rule("05070201", "FREEZE", "XXXXXX.XX"));
        // 05070202 含义: …
        map.put("05070202", new Dl645DocRuleRegistry.Rule("05070202", "FREEZE", "XXXXXX.XX"));
        // 05070301 含义: …
        map.put("05070301", new Dl645DocRuleRegistry.Rule("05070301", "FREEZE", "XXXXXX.XX"));
        // 05070302 含义: …
        map.put("05070302", new Dl645DocRuleRegistry.Rule("05070302", "FREEZE", "XXXXXX.XX"));
        // 05070401 含义: …
        map.put("05070401", new Dl645DocRuleRegistry.Rule("05070401", "FREEZE", "XXXXXX.XX"));
        // 05070402 含义: DI3 DI2 DI1 DI0 读写
        map.put("05070402", new Dl645DocRuleRegistry.Rule("05070402", "FREEZE", "XXXXXX.XX"));
        // 05070501 含义: …
        map.put("05070501", new Dl645DocRuleRegistry.Rule("05070501", "FREEZE", "XXXXXX.XX"));
        // 05070502 含义: …
        map.put("05070502", new Dl645DocRuleRegistry.Rule("05070502", "FREEZE", "XXXXXX.XX"));
        // 05070601 含义: …
        map.put("05070601", new Dl645DocRuleRegistry.Rule("05070601", "FREEZE", "XXXXXX.XX"));
        // 05070602 含义: …
        map.put("05070602", new Dl645DocRuleRegistry.Rule("05070602", "FREEZE", "XXXXXX.XX"));
        // 05070701 含义: …
        map.put("05070701", new Dl645DocRuleRegistry.Rule("05070701", "FREEZE", "XXXXXX.XX"));
        // 05070702 含义: …
        map.put("05070702", new Dl645DocRuleRegistry.Rule("05070702", "FREEZE", "XXXXXX.XX"));
        // 05070801 含义: …
        map.put("05070801", new Dl645DocRuleRegistry.Rule("05070801", "FREEZE", "XXXXXX.XX"));
        // 05070802 含义: …
        map.put("05070802", new Dl645DocRuleRegistry.Rule("05070802", "FREEZE", "XXXXXX.XX"));
        // 05070901 含义: …
        map.put("05070901", new Dl645DocRuleRegistry.Rule("05070901", "FREEZE", "XX.XXXX"));
        // 05070902 含义: …
        map.put("05070902", new Dl645DocRuleRegistry.Rule("05070902", "FREEZE", "XX.XXXX"));
        // 05070A01 含义: …
        map.put("05070A01", new Dl645DocRuleRegistry.Rule("05070A01", "FREEZE", "XX.XXXX"));
        // 05070A02 含义: …
        map.put("05070A02", new Dl645DocRuleRegistry.Rule("05070A02", "FREEZE", "XX.XXXX"));
        // 05071001 含义: …
        map.put("05071001", new Dl645DocRuleRegistry.Rule("05071001", "FREEZE", "XX.XXXX"));
        // 05071002 含义: …
        map.put("05071002", new Dl645DocRuleRegistry.Rule("05071002", "FREEZE", "XX.XXXX"));
        // 06000000 含义: 最早记录块
        map.put("06000000", new Dl645DocRuleRegistry.Rule("06000000", "LOAD_RECORD", "NN"));
        // 06010000 含义: 给定时间记录块（多值/块数据，暂不启用）
        // map.put("06010000", new Dl645DocRuleRegistry.Rule("06010000", "LOAD_RECORD", ""));
        // 06060000 含义: ………… … … … … …（多值/块数据，暂不启用）
        // map.put("06060000", new Dl645DocRuleRegistry.Rule("06060000", "LOAD_RECORD", ""));
        return Collections.unmodifiableMap(map);
    }
}
