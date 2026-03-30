package com.ruoyi.web.meter;

import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.time.Instant;

/**
 * 电表上报时间解析与 TCP 首行读取
 */
public final class MeterIngestParseUtil {

    private MeterIngestParseUtil() {
    }

    public static Date parseReadTime(String s) {
        if (s == null || s.isBlank()) {
            return new Date();
        }
        String t = s.trim();
        try {
            return Date.from(Instant.parse(t));
        } catch (Exception ignored) {
        }
        try {
            return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(t);
        } catch (ParseException e) {
            return new Date();
        }
    }

    public static String readLineUtf8(InputStream in) throws IOException {
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        while (true) {
            int b = in.read();
            if (b < 0) {
                break;
            }
            if (b == '\n') {
                break;
            }
            if (b != '\r') {
                bos.write(b);
            }
        }
        return bos.toString(StandardCharsets.UTF_8);
    }
}

