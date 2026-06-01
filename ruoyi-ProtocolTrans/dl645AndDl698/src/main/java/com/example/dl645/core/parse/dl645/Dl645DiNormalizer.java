package com.example.dl645.core.parse.dl645;

/**
 * DL645 数据标识规范化（DL/T 645-2007）
 *
 * @author wangchangzhen
 */
public final class Dl645DiNormalizer {

    private Dl645DiNormalizer() {
    }

    /**
     * 去除空格、冒号等分隔符并转为大写，统一判断。
     */
    public static String normalize(String di) {
        if (di == null) {
            return "";
        }
        return di.replace(" ", "").replace(":", "").trim().toUpperCase();
    }
}

