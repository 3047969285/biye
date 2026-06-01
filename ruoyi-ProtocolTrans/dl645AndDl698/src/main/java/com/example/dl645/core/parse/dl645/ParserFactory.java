package com.example.dl645.core.parse.dl645;

import com.example.dl645.core.parse.ParseStrategy;
import java.util.ArrayList;
import java.util.List;

/**
 * DL645 数据标识解析策略注册工厂
 *
 * @author wangchangzhen
 */
public class ParserFactory {
    private static final List<ParseStrategy> strategies = new ArrayList<>();

    static {
        strategies.add(new Dl645DocRuleParseStrategy());
    }

    /**
     * 获取解析策略
     */
    public static ParseStrategy getParser(String di) {
        String key = Dl645DiNormalizer.normalize(di);
        for (ParseStrategy strategy : strategies) {
            if (strategy.supports(key)) {
                return strategy;
            }
        }
        throw new IllegalArgumentException("DI 格式非法或不支持: " + key);
    }

}

