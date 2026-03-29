package com.ruoyi.web.service.wind;

import com.ruoyi.common.utils.StringUtils;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * 根据最近一次 GRU 预测结果生成中文运维摘要（依赖 Spring AI，不可用时降级为规则摘要）。
 */
@Service
public class WindForecastSummaryService {

    private static final String SYS = "你是风电场发电分析助手。根据用户给出的预测指标与功率序列摘要，用 4～8 句中文说明："
        + "当前预测平均功率水平、与实测对比（若有：综合误差、平均偏差、拟合程度）、未来区段趋势、以及 2～3 条可执行的运维或调度建议。"
        + "不要使用 RMSE、MAE、R² 等英文缩写；用通俗说法：综合误差（kW，整体偏差，略偏大误差的点会拉得更高）、"
        + "平均偏差（kW，每个时刻预测偏了多少的平均）、拟合程度（0～1，越接近 1 说明预测越能跟上实测变化）。"
        + "不要使用 Markdown、不要使用 # 或星号列表符号。";

    private final ChatClient chatClient;

    public WindForecastSummaryService(@Autowired(required = false) ChatClient chatClient) {
        this.chatClient = chatClient;
    }

    public String summarize(Map<String, Object> prediction) {
        if (prediction == null || prediction.isEmpty()) {
            return "暂无预测数据，请先点击预测或等待自动预测完成。";
        }
        String ctx = buildContext(prediction);
        if (chatClient == null) {
            return ruleBasedSummary(prediction, ctx);
        }
        try {
            String reply = chatClient.prompt()
                .system(SYS)
                .user(ctx)
                .call()
                .content();
            if (reply != null) {
                reply = reply.trim();
            }
            if (StringUtils.isNotEmpty(reply)) {
                return reply;
            }
            return ruleBasedSummary(prediction, ctx);
        } catch (Exception e) {
            return ruleBasedSummary(prediction, ctx) + "（AI 服务异常，已使用本地摘要：" + e.getMessage() + "）";
        }
    }

    private static String buildContext(Map<String, Object> p) {
        StringBuilder sb = new StringBuilder();
        append(sb, "predict_length", p.get("predict_length"));
        append(sb, "compare_length", p.get("compare_length"));
        append(sb, "future_points", p.get("future_points"));
        append(sb, "综合误差", p.get("rmse"));
        append(sb, "平均偏差", p.get("mae"));
        append(sb, "拟合程度", p.get("r2"));
        Object pred = p.get("predicted_power");
        if (pred instanceof List<?> list && !list.isEmpty()) {
            double sum = 0;
            int n = list.size();
            double min = Double.MAX_VALUE;
            double max = Double.MIN_VALUE;
            for (Object o : list) {
                double v = toDouble(o);
                sum += v;
                min = Math.min(min, v);
                max = Math.max(max, v);
            }
            sb.append("预测点数=").append(n)
                .append("，平均功率≈").append(String.format("%.2f", sum / n))
                .append(" kW，最小≈").append(String.format("%.2f", min))
                .append(" kW，最大≈").append(String.format("%.2f", max)).append(" kW。\n");
        }
        return sb.toString();
    }

    private static void append(StringBuilder sb, String k, Object v) {
        if (v != null) {
            sb.append(k).append("=").append(v).append("；");
        }
    }

    private static double toDouble(Object o) {
        if (o instanceof Number) {
            return ((Number) o).doubleValue();
        }
        try {
            return Double.parseDouble(String.valueOf(o));
        } catch (Exception e) {
            return 0;
        }
    }

    private static String ruleBasedSummary(Map<String, Object> p, String ctx) {
        StringBuilder s = new StringBuilder();
        s.append("【本地摘要】");
        if (StringUtils.isNotEmpty(ctx)) {
            s.append(ctx.replace('\n', ' '));
        }
        Object rmse = p.get("rmse");
        if (rmse != null) {
            s.append(" 综合误差反映预测与实测的整体差距（越小越好），可结合现场风速仪状态评估模型是否需要重训或更新数据。");
        }
        s.append(" 建议持续关注低功率时段是否与检修计划重叠，并校验导入数据时间分辨率与机组状态。");
        String out = s.toString().trim();
        return StringUtils.isNotEmpty(out) ? out : "当前预测数据较少，请完成一次预测后再试；若已预测仍无内容，请检查通义千问 API 与模型配置。";
    }
}
