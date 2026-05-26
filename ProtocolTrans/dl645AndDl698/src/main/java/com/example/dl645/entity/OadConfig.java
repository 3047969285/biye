package com.example.dl645.entity;

/**
 * DL698 OAD 点表配置
 */
public class OadConfig {
    private final String name;
    private final byte[] oad;

    public OadConfig(String name, byte[] oad) {
        this.name = name;
        this.oad = oad;
    }

    public String getName() {
        return name;
    }

    public byte[] getOad() {
        return oad;
    }
}
