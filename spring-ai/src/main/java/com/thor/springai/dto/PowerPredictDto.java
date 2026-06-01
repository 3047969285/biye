package com.thor.springai.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.io.Serial;
import java.io.Serializable;
import java.util.List;

/**
 * 与 Python 风电预测服务对接的请求/响应 DTO。
 * Python 服务返回 snake_case，使用 @JsonProperty 完成映射。
 *
 * @author wangchangzhen
 */
public class PowerPredictDto {

    /** 训练请求（发给 Python /train） */
    public static class TrainRequest implements Serializable {
        @Serial
        private static final long serialVersionUID = 1L;

        @JsonProperty("excel_path")
        private String excelPath;
        @JsonProperty("time_step")
        private Integer timeStep = 30;
        @JsonProperty("test_size")
        private Double testSize = 0.2;
        private Integer epochs = 50;
        @JsonProperty("batch_size")
        private Integer batchSize = 64;
        @JsonProperty("target_col")
        private String targetCol;

        public String getExcelPath() { return excelPath; }
        public void setExcelPath(String excelPath) { this.excelPath = excelPath; }
        public Integer getTimeStep() { return timeStep; }
        public void setTimeStep(Integer timeStep) { this.timeStep = timeStep; }
        public Double getTestSize() { return testSize; }
        public void setTestSize(Double testSize) { this.testSize = testSize; }
        public Integer getEpochs() { return epochs; }
        public void setEpochs(Integer epochs) { this.epochs = epochs; }
        public Integer getBatchSize() { return batchSize; }
        public void setBatchSize(Integer batchSize) { this.batchSize = batchSize; }
        public String getTargetCol() { return targetCol; }
        public void setTargetCol(String targetCol) { this.targetCol = targetCol; }
    }

    /** 训练响应（Python /train 返回，异步启动） */
    public static class TrainResponse implements Serializable {
        @Serial
        private static final long serialVersionUID = 1L;

        private Boolean success;
        private String message;

        public Boolean getSuccess() { return success; }
        public void setSuccess(Boolean success) { this.success = success; }
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
    }

    /** 快速预测请求（模型已训练，仅做推理，发给 Python /predict） */
    public static class QuickPredictRequest implements Serializable {
        @Serial
        private static final long serialVersionUID = 1L;

        @JsonProperty("predict_length")
        private Integer predictLength = 96;
        @JsonProperty("predict_start_index")
        private Integer predictStartIndex = 0;
        /** 可选：使用已有 .h5 模型文件绝对路径（填写后无需先训练） */
        @JsonProperty("model_path")
        private String modelPath;
        /** 可选：特征数据 Excel 绝对路径（配合 modelPath 使用） */
        @JsonProperty("feature_excel")
        private String featureExcel;
        /** 可选：真实功率 Excel 绝对路径（配合 modelPath 使用） */
        @JsonProperty("real_excel")
        private String realExcel;
        /** 可选：时间步长，默认 30 */
        @JsonProperty("time_step")
        private Integer timeStep;
        /** 可选：测试集比例，默认 0.2 */
        @JsonProperty("test_size")
        private Double testSize;

        public Integer getPredictLength() { return predictLength; }
        public void setPredictLength(Integer predictLength) { this.predictLength = predictLength; }
        public Integer getPredictStartIndex() { return predictStartIndex; }
        public void setPredictStartIndex(Integer predictStartIndex) { this.predictStartIndex = predictStartIndex; }
        public String getModelPath() { return modelPath; }
        public void setModelPath(String modelPath) { this.modelPath = modelPath; }
        public String getFeatureExcel() { return featureExcel; }
        public void setFeatureExcel(String featureExcel) { this.featureExcel = featureExcel; }
        public String getRealExcel() { return realExcel; }
        public void setRealExcel(String realExcel) { this.realExcel = realExcel; }
        public Integer getTimeStep() { return timeStep; }
        public void setTimeStep(Integer timeStep) { this.timeStep = timeStep; }
        public Double getTestSize() { return testSize; }
        public void setTestSize(Double testSize) { this.testSize = testSize; }
    }

    /** 预测结果（Python /predict 返回） */
    public static class PredictResponse implements Serializable {
        @Serial
        private static final long serialVersionUID = 1L;

        private Boolean success;
        private String message;
        private Double rmse;
        private Double mae;
        private Double r2;
        @JsonProperty("predicted_power")
        private List<Double> predictedPower;
        @JsonProperty("real_power")
        private List<Double> realPower;
        @JsonProperty("predict_length")
        private Integer predictLength;

        public Boolean getSuccess() { return success; }
        public void setSuccess(Boolean success) { this.success = success; }
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
        public Double getRmse() { return rmse; }
        public void setRmse(Double rmse) { this.rmse = rmse; }
        public Double getMae() { return mae; }
        public void setMae(Double mae) { this.mae = mae; }
        public Double getR2() { return r2; }
        public void setR2(Double r2) { this.r2 = r2; }
        public List<Double> getPredictedPower() { return predictedPower; }
        public void setPredictedPower(List<Double> predictedPower) { this.predictedPower = predictedPower; }
        public List<Double> getRealPower() { return realPower; }
        public void setRealPower(List<Double> realPower) { this.realPower = realPower; }
        public Integer getPredictLength() { return predictLength; }
        public void setPredictLength(Integer predictLength) { this.predictLength = predictLength; }
    }

    /** 模型状态（Python /status 返回） */
    public static class StatusResponse implements Serializable {
        @Serial
        private static final long serialVersionUID = 1L;

        @JsonProperty("model_exists")
        private Boolean modelExists;
        @JsonProperty("is_training")
        private Boolean isTraining;
        private Integer progress;
        private String message;
        @JsonProperty("trained_at")
        private String trainedAt;
        private Double rmse;
        private Double mae;
        private Double r2;

        public Boolean getModelExists() { return modelExists; }
        public void setModelExists(Boolean modelExists) { this.modelExists = modelExists; }
        public Boolean getIsTraining() { return isTraining; }
        public void setIsTraining(Boolean isTraining) { this.isTraining = isTraining; }
        public Integer getProgress() { return progress; }
        public void setProgress(Integer progress) { this.progress = progress; }
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
        public String getTrainedAt() { return trainedAt; }
        public void setTrainedAt(String trainedAt) { this.trainedAt = trainedAt; }
        public Double getRmse() { return rmse; }
        public void setRmse(Double rmse) { this.rmse = rmse; }
        public Double getMae() { return mae; }
        public void setMae(Double mae) { this.mae = mae; }
        public Double getR2() { return r2; }
        public void setR2(Double r2) { this.r2 = r2; }
    }

    // ── 向下兼容别名 ──────────────────────────────────────────────────────────
    /** @deprecated 使用 TrainRequest 替代 */
    @Deprecated
    public static class Request extends TrainRequest {
        @Serial
        private static final long serialVersionUID = 1L;
    }

    /** @deprecated 使用 PredictResponse 替代 */
    @Deprecated
    public static class Response extends PredictResponse {
        @Serial
        private static final long serialVersionUID = 1L;
    }
}
