package com.example.dl645.entity;

/**
 * DI配置实体
 */
public class DiConfig {
    private final String name;
    private final byte[] di;

    public DiConfig(String name, byte[] di) {
        this.name = name;
        this.di = di;
    }

    public String getName() {
        return name;
    }

    public byte[] getDi() {
        return di;
    }
}
