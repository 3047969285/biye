package com.example.dl645.core.parse;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DL645 数据标识解析结果（DL/T 645-2007）
 *
 * @author wangchangzhen
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ParseResult {

    private String di;           // 数据标识
    private String dataType;     // 数据类型
    private Object value;        // 解析值
    private String unit;         // 单位
}
