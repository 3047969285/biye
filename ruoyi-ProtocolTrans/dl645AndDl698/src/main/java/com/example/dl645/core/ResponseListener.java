package com.example.dl645.core;

/**
 * 响应监听器接口，用于打印响应数据
 *
 * @author wangchangzhen
 */
public interface ResponseListener {
    /**
     * 收到响应时回调
     *
     * @param response 完整的响应数据帧（不包含帧头、帧尾、校验和等协议层数据）
     */
    void onResponseReceived(byte[] response);

    /**
     * 当发生错误时回调
     *
     * @param errorMessage 错误描述信息，包含错误类型和可能的错误码
     */
    void onError(String errorMessage);

    /**
     * 当串口成功打开时回调
     *
     * @param portName 串口名称
     */
    void onPortOpened(String portName);

    /**
     * 当串口成功关闭时回调
     *
     * @param portName 串口名称
     */
    void onPortClosed(String portName);

    /**
     * 当有原始数据到达串口时回调
     * 注意：此方法接收的是原始字节流，包含协议层的所有数据
     * 适用于调试、监控或自定义协议处理
     *
     * @param data 从串口接收到的原始字节数据
     *             可能是完整帧、部分帧或多个帧的组合
     */
    void onDataAvailable(byte[] data);

    /**
     * 当数据发送到串口时回调
     *
     * @param data    发送的原始字节数据
     * @param success 是否发送成功
     */
    default void onDataSent(byte[] data, boolean success) {
    }
}
