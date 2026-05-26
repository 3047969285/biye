package com.example.dl645.core.parse;

/**
 * DL645 数据标识解析策略接口（DL/T 645-2007）
 *
 * @author wangchangzhen
 */
public interface ParseStrategy {

    /**
     * 是否支持该DI
     */
    boolean supports(String di);

    /**
     * 解析数据
     */
    ParseResult parse(byte[] data, String di);

}
