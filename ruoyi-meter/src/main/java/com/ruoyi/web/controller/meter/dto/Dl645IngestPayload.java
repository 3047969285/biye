package com.ruoyi.web.controller.meter.dto;

/**
 * DL645 采集入参
 */
public class Dl645IngestPayload {

    private String frameHex;
    private String readTime;
    private String source;

    public String getFrameHex() {
        return frameHex;
    }

    public void setFrameHex(String frameHex) {
        this.frameHex = frameHex;
    }

    public String getReadTime() {
        return readTime;
    }

    public void setReadTime(String readTime) {
        this.readTime = readTime;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }
}
