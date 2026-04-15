package com.ruoyi.quartz.thrift.thrift;

import lombok.extern.slf4j.Slf4j;
import org.apache.thrift.protocol.TBinaryProtocol;
import org.apache.thrift.protocol.TProtocol;
import org.apache.thrift.transport.TSocket;
import org.apache.thrift.transport.TTransport;
import org.apache.thrift.transport.TTransportException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

/**
 * Thrift 客户端服务
 */
@Slf4j
@Service
public class ThriftClient {

    @Value("${thrift.server.host}")
    private String thriftHost;

    @Value("${thrift.server.port}")
    private int thriftPort;

    /**
     * webToServer 方法
     */
    public String webToServer(String value) {
        try {
            ThriftService.Client client = getClient();
            return client.WebToServer(value);
        } catch (Exception e) {
            log.error(e.toString());
            return "Thrift连接异常: " + e.getMessage();
        }
    }

    /**
     * serverToWeb 方法
     */
    public String serverToWeb(String value) {
        try {
            ThriftService.Client client = getClient();
            log.info("serverToWeb: " + value);
            return client.ServerToWeb(value);
        } catch (Exception e) {
            log.error(e.toString());
            return "Thrift连接异常: " + e.getMessage();
        }
    }

    /**
     * 与服务端建立连接
     */
    private ThriftService.Client getClient() throws TTransportException {
        TTransport transport = new TSocket(thriftHost, thriftPort);
        transport.open();
        TProtocol protocol = new TBinaryProtocol(transport);
        return new ThriftService.Client(protocol);
    }

}


