package com.ruoyi.web.runner;

import com.ruoyi.web.config.properties.WindForecastProperties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.core.annotation.Order;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.stereotype.Component;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.nio.charset.Charset;

/**
 * 系统启动后拉起风力发电 predict.py（内置 uvicorn 8989）
 */
@Component
@Order(20)
@ConditionalOnProperty(prefix = "wind.forecast", name = "enabled", havingValue = "true", matchIfMissing = true)
public class WindForecastPythonRunner implements ApplicationRunner, DisposableBean {

    private static final Logger log = LoggerFactory.getLogger(WindForecastPythonRunner.class);

    private final WindForecastProperties props;

    private Process pythonProcess;

    public WindForecastPythonRunner(WindForecastProperties props) {
        this.props = props;
    }

    @Override
    public void run(ApplicationArguments args) {
        if (!props.isAutoStartPython()) {
            log.info("wind.forecast.auto-start-python=false，跳过启动 Python 进程，请手动运行: cd 风力发电第二版 && python predict.py");
            return;
        }
        File dir = new File(props.getWorkDir() == null ? "" : props.getWorkDir());
        if (!dir.isDirectory()) {
            log.warn("风力发电工作目录不存在: {}，请配置 wind.forecast.work-dir", dir.getAbsolutePath());
            return;
        }
        File script = new File(dir, "predict.py");
        if (!script.isFile()) {
            log.warn("未找到 predict.py: {}", script.getAbsolutePath());
            return;
        }
        if (isPortOpen(props.getServiceHost(), props.getServicePort())) {
            log.info("Python 预测服务已在端口 {} 监听，不再重复启动", props.getServicePort());
            return;
        }
        ProcessBuilder pb = new ProcessBuilder(props.getPythonCommand(), "predict.py");
        pb.directory(dir);
        pb.redirectErrorStream(true);
        try {
            pythonProcess = pb.start();
            Charset cs = Charset.defaultCharset();
            Thread t = new Thread(() -> drainLog(cs), "wind-forecast-python-out");
            t.setDaemon(true);
            t.start();
            boolean ok = waitForPort(props.getServiceHost(), props.getServicePort(), 90);
            if (ok) {
                log.info("风力发电 Python 预测服务已启动: {}", props.baseUrl());
            } else {
                log.warn("等待 Python 预测服务 {} 超时，请检查是否已安装依赖: pip install -r requirements.txt", props.baseUrl());
            }
        } catch (IOException e) {
            log.error("启动 Python 预测进程失败: {}", e.getMessage());
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }

    private void drainLog(Charset cs) {
        if (pythonProcess == null) {
            return;
        }
        try (BufferedReader br = new BufferedReader(new InputStreamReader(pythonProcess.getInputStream(), cs))) {
            String line;
            while ((line = br.readLine()) != null) {
                log.info("[wind-python] {}", line);
            }
        } catch (IOException ignored) {
            // process ended
        }
    }

    private static boolean isPortOpen(String host, int port) {
        try (Socket s = new Socket()) {
            s.connect(new InetSocketAddress(host, port), 800);
            return true;
        } catch (IOException e) {
            return false;
        }
    }

    private static boolean waitForPort(String host, int port, int maxSeconds) throws InterruptedException {
        for (int i = 0; i < maxSeconds; i++) {
            if (isPortOpen(host, port)) {
                return true;
            }
            Thread.sleep(1000L);
        }
        return false;
    }

    @Override
    public void destroy() {
        if (pythonProcess != null && pythonProcess.isAlive()) {
            log.info("正在关闭风力发电 Python 子进程…");
            pythonProcess.destroy();
            try {
                pythonProcess.waitFor(5, java.util.concurrent.TimeUnit.SECONDS);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            if (pythonProcess.isAlive()) {
                pythonProcess.destroyForcibly();
            }
        }
    }
}
