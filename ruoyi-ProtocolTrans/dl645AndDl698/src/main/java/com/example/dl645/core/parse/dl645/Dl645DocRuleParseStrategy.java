package com.example.dl645.core.parse.dl645;

import com.example.dl645.core.parse.AbsParseStrategy;
import com.example.dl645.core.parse.Dl645StandardPayloads;
import com.example.dl645.core.parse.ParseResult;
import org.apache.commons.lang3.StringUtils;

import java.math.BigDecimal;

/**
 * 按 DL/T 645-2007 根据文档数据标识规则表执行解析
 */
public class Dl645DocRuleParseStrategy extends AbsParseStrategy {

    @Override
    public boolean supports(String di) {
        Dl645DocRuleRegistry.Rule r = Dl645DocRuleRegistry.get(di);
        return r != null;
    }

    @Override
    public ParseResult parse(byte[] data, String di) {
        Dl645DocRuleRegistry.Rule rule = Dl645DocRuleRegistry.get(di);
        if (rule == null) {
            return null;
        }
        String hex = payloadHex(data, di);
        if (StringUtils.isEmpty(hex)) {
            throw new IllegalArgumentException("DI " + di + " 数据域为空，无法按文档解析");
        }
        Object value = parseByFormat(rule, hex);
        return new ParseResult(di, "doc_rule", value, "");
    }

    private Object parseByFormat(Dl645DocRuleRegistry.Rule rule, String hex) {
        String format = rule.format;
        if (StringUtils.isEmpty(format)) {
            throw new IllegalArgumentException("DI " + rule.di + " 未定义format，无法按文档唯一规则解析");
        }
        String fmt = format.trim().toUpperCase();
        switch (fmt) {
            case "YYMMDDHHMMSS":
                return bcdTime(hex, 12);
            case "YYMMDDHHMM":
                return bcdTime(hex, 10);
            case "YYMMDDWW":
                return bcdTime(hex, 8);
            case "NN":
                return BigDecimal.valueOf(bcdBytePair(hex.substring(0, 2)));
            case "NNNNNN":
                return new BigDecimal(bcdDigits(hex, 6));
            case "NNNNNNNNNNNN":
                return bcdDigits(hex, 12);
            case "NNNNNNNNNNNNNNNNNNNN":
                return bcdDigits(hex, 20);
            case "X.XXX":
            case "XX.XX":
            case "XX.XXXX":
            case "XXX.X":
            case "XXX.XXX":
            case "XXXXXX.XX":
                if ("ENERGY_BCD".equalsIgnoreCase(rule.parseTypeGuess)) {
                    BigDecimal signed = convertSignedByFormat(hex, fmt);
                    if (signed != null) {
                        return signed;
                    }
                }
                return convertByFormat(hex, fmt);
            case "ASCII":
                String ascii = Dl645StandardPayloads.asciiIfPrintable(hexToBytes(hex));
                if (StringUtils.isEmpty(ascii) || ascii.indexOf('\uFFFD') >= 0) {
                    throw new IllegalArgumentException("DI " + rule.di + " ASCII格式数据不可打印: " + hex);
                }
                return ascii;
            default:
                throw new IllegalArgumentException("DI " + rule.di + " 存在未支持的文档format: " + fmt);
        }
    }

    private BigDecimal convertByFormat(String hex, String fmt) {
        int digits = 0;
        for (int i = 0; i < fmt.length(); i++) {
            char c = fmt.charAt(i);
            if (c == 'X' || c == 'N') {
                digits++;
            }
        }
        String num = bcdDigits(hex, digits);
        return convert(num, fmt.replace('N', 'X'));
    }

    private static String bcdDigits(String hex, int digits) {
        StringBuilder sb = new StringBuilder(digits);
        int bytes = digits / 2 + (digits % 2 == 0 ? 0 : 1);
        int neededHex = bytes * 2;
        if (hex.length() < neededHex) {
            throw new IllegalArgumentException("BCD长度不足, 需要" + neededHex + "位hex, 实际" + hex.length());
        }
        String h = hex.substring(0, neededHex);
        for (int i = 0; i + 1 < h.length() && sb.length() < digits; i += 2) {
            int v = bcdBytePair(h.substring(i, i + 2));
            if (v < 10) {
                sb.append('0');
            }
            sb.append(v);
        }
        if (sb.length() > digits) {
            return sb.substring(0, digits);
        }
        return sb.toString();
    }

    private BigDecimal convertSignedByFormat(String hex, String fmt) {
        int digits = 0;
        for (int i = 0; i < fmt.length(); i++) {
            char c = fmt.charAt(i);
            if (c == 'X' || c == 'N') {
                digits++;
            }
        }
        if (digits <= 0) {
            return null;
        }
        int bytes = digits / 2 + (digits % 2 == 0 ? 0 : 1);
        int neededHex = bytes * 2;
        if (hex.length() < neededHex) {
            return null;
        }
        String signedBcd = hex.substring(0, neededHex);
        return convertSignedBcdHex(signedBcd, fmt.replace('N', 'X'));
    }

    private static String bcdTime(String hex, int digits) {
        return bcdDigits(hex, digits);
    }

    private static byte[] hexToBytes(String hex) {
        int n = hex.length() / 2;
        byte[] out = new byte[n];
        for (int i = 0; i < n; i++) {
            out[i] = (byte) Integer.parseInt(hex.substring(i * 2, i * 2 + 2), 16);
        }
        return out;
    }
}
