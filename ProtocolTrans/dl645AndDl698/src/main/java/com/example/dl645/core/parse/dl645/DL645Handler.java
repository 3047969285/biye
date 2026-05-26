package com.example.dl645.core.parse.dl645;

import com.example.dl645.constant.DL645Constant;
import com.example.dl645.core.DL645Frame;
import com.example.dl645.untils.ByteUntil;

import java.util.Calendar;
import java.util.Date;

import static com.example.dl645.constant.DL645Constant.ADDRESS_LENGTH;
import static com.example.dl645.constant.DL645Constant.ADDRESS_LENGTH_HEX;

/**
 * DL645 帧与数据域处理（DL/T 645-2007）
 *
 * @author wangchangzhen
 */
public class DL645Handler {

    /**
     * 创建读数据请求帧
     *
     * @param address        电表地址（12位BCD字符串或6字节数组）
     * @param dataIdentifier 数据标识（DI）
     * @return 帧数据
     */
    public static byte[] createReadRequest(Object address, byte[] dataIdentifier) {
        byte[] addrBytes;

        if (address instanceof String) {
            String addrStr = (String) address;
            if (addrStr.length() == ADDRESS_LENGTH_HEX) {
                addrBytes = new byte[ADDRESS_LENGTH];
                for (int i = 0; i < ADDRESS_LENGTH; i++) {
                    int high = Character.digit(addrStr.charAt(2 * i), 16);
                    int low = Character.digit(addrStr.charAt(2 * i + 1), 16);
                    addrBytes[i] = (byte) ((high << 4) | low);
                }
            } else {
                throw new IllegalArgumentException("地址长度必须为12位");
            }
        } else if (address instanceof byte[]) {
            addrBytes = (byte[]) address;
        } else {
            throw new IllegalArgumentException("地址类型错误");
        }

        // 数据域：数据标识（DL/T 645-2007 中需 +33H）
        byte[] processedDataId = processData(dataIdentifier, true);

        DL645Frame frame = new DL645Frame(addrBytes, DL645Constant.ControlCode.READ_DATA, processedDataId);
        return frame.build();
    }

    /**
     * 创建广播校时帧
     *
     * @param date 校时时间
     * @return 帧数据
     */
    public static byte[] createBroadcastTime(Date date) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);

        // 数据格式：秒分时日星期月年（各加33H）
        byte[] timeData = new byte[7];
        // 秒
        timeData[0] = (byte) (cal.get(Calendar.SECOND) + 0x33);
        // 分
        timeData[1] = (byte) (cal.get(Calendar.MINUTE) + 0x33);
        // 时
        timeData[2] = (byte) (cal.get(Calendar.HOUR_OF_DAY) + 0x33);
        // 日
        timeData[3] = (byte) (cal.get(Calendar.DAY_OF_MONTH) + 0x33);
        // 星期：1-7，周日为1
        int weekDay = cal.get(Calendar.DAY_OF_WEEK);
        weekDay = weekDay == 1 ? 7 : weekDay - 1;
        timeData[4] = (byte) (weekDay + 0x33);
        // 月
        timeData[5] = (byte) (cal.get(Calendar.MONTH) + 1 + 0x33);
        // 年（取后两位）
        timeData[6] = (byte) ((cal.get(Calendar.YEAR) % 100) + 0x33);

        DL645Frame frame = new DL645Frame(new byte[ADDRESS_LENGTH], DL645Constant.ControlCode.BROADCAST_TIME, timeData);
        return frame.build();
    }

    /**
     * 处理数据（加33H或减33H）
     *
     * @param data     原始数据
     * @param isEncode true: 加33H, false: 减33H
     * @return 处理后的数据
     */
    private static byte[] processData(byte[] data, boolean isEncode) {
        byte[] bytes = ByteUntil.reverseBytes(data);
        byte[] result = new byte[bytes.length];
        for (int i = 0; i < bytes.length; i++) {
            if (isEncode) {
                result[i] = (byte) ((bytes[i] & 0xFF) + 0x33);
            } else {
                result[i] = (byte) ((bytes[i] & 0xFF) - 0x33);
            }
        }
        return result;
    }

    /**
     * 解析响应数据
     *
     * @param data 响应字节数组
     * @return 解析后的数据
     */
    public static Object parseResponse(byte[] data, byte[] dataIdentifier) {
        if (data == null || data.length == 0) {
            return null;
        }
        // 数据需要减33H
        byte[] processedData = processData(data, false);
        String di = Dl645DiNormalizer.normalize(ByteUntil.bytesToHex(dataIdentifier));
        return ParserFactory.getParser(di).parse(processedData, di);
    }

}

