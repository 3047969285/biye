"""
风电功率 GRU 实时预测服务
- POST /train   → 异步训练，模型+缩放器持久化到 model/ 目录
- POST /predict → 加载已存模型做快速推理（毫秒级，无需重训）
- GET  /status  → 查询训练状态 / 模型指标

依赖安装：
  pip install fastapi uvicorn tensorflow scikit-learn pandas openpyxl joblib

启动：python predict_server.py
"""

import os
import json
import joblib
import threading
import numpy as np
import pandas as pd
from datetime import datetime
from typing import Optional

from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score

try:
    import tensorflow as tf
    from tensorflow.keras.models import Sequential, load_model
    from tensorflow.keras.layers import GRU, Dense, Dropout
except ImportError:
    raise RuntimeError("请安装 TensorFlow：pip install tensorflow")

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

# ─── 路径 ──────────────────────────────────────────────────────────────────
BASE_DIR  = os.path.dirname(os.path.abspath(__file__))
MODEL_DIR = os.path.join(BASE_DIR, "model")
MODEL_H5  = os.path.join(MODEL_DIR, "gru_model.h5")
SCALER_Y  = os.path.join(MODEL_DIR, "scaler_y.pkl")
META_JSON = os.path.join(MODEL_DIR, "meta.json")
CACHE_NPZ = os.path.join(MODEL_DIR, "data_cache.npz")
os.makedirs(MODEL_DIR, exist_ok=True)

# ─── FastAPI App ───────────────────────────────────────────────────────────
app = FastAPI(title="风电功率 GRU 实时预测服务", version="2.0")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# ─── 全局训练状态（线程安全依赖 GIL）─────────────────────────────────────
_status: dict = {
    "model_exists": False,
    "is_training":  False,
    "progress":     0,
    "message":      "模型未训练",
    "trained_at":   None,
    "rmse":         None,
    "mae":          None,
    "r2":           None,
}


def _restore_meta():
    """服务启动时从持久化文件恢复状态，无需重新训练。"""
    if os.path.exists(META_JSON) and os.path.exists(MODEL_H5):
        with open(META_JSON, encoding="utf-8") as f:
            m = json.load(f)
        _status.update(
            model_exists=True,
            is_training=False,
            progress=100,
            message="模型已就绪",
            trained_at=m.get("trained_at"),
            rmse=m.get("rmse"),
            mae=m.get("mae"),
            r2=m.get("r2"),
        )


_restore_meta()


# ─── Pydantic 请求模型 ─────────────────────────────────────────────────────
class TrainRequest(BaseModel):
    excel_path:  str
    time_step:   int   = 30
    test_size:   float = 0.2
    epochs:      int   = 50
    batch_size:  int   = 64
    target_col:  Optional[str] = None   # None → 自动使用最后一列数值列


class PredictRequest(BaseModel):
    predict_length:      int = 96
    predict_start_index: int = 0
    # ── 使用已有模型时填写以下字段（不需要重新训练）──────────────────────────
    model_path:    Optional[str] = None   # 已有 .h5 模型路径
    feature_excel: Optional[str] = None  # 特征数据 Excel（FD001.xlsx）
    real_excel:    Optional[str] = None  # 真实功率 Excel（FD001_real.xlsx）
    time_step:     Optional[int] = None  # 建序列的时间步（默认 30）
    test_size:     Optional[float] = None  # 测试集比例（默认 0.2）


# ─── 工具函数 ──────────────────────────────────────────────────────────────
def _load_excel(path: str, target_col: Optional[str]):
    """读取 Excel，返回特征矩阵 X 和目标列 y（均为 numpy 数组）。"""
    df = pd.read_excel(path).dropna()
    num_cols = df.select_dtypes(include=[np.number]).columns.tolist()
    if not num_cols:
        raise ValueError("Excel 中没有数值列")
    y_col  = target_col if (target_col and target_col in num_cols) else num_cols[-1]
    x_cols = [c for c in num_cols if c != y_col] or [y_col]
    return df[x_cols].values, df[[y_col]].values


def _make_sequences(X: np.ndarray, y: np.ndarray, time_step: int):
    """将时间序列切成监督学习样本。"""
    xs, ys = [], []
    for i in range(len(X) - time_step):
        xs.append(X[i: i + time_step])
        ys.append(y[i + time_step])
    return np.array(xs), np.array(ys)


# ─── 训练线程函数 ──────────────────────────────────────────────────────────
def _do_train(req: TrainRequest):
    global _status
    _status.update(is_training=True, progress=5, message="加载数据中…")
    try:
        raw_x, raw_y = _load_excel(req.excel_path, req.target_col)

        _status.update(progress=15, message="数据归一化…")
        sx = MinMaxScaler()
        sy = MinMaxScaler()
        X_sc = sx.fit_transform(raw_x)
        y_sc = sy.fit_transform(raw_y)

        X_seq, y_seq = _make_sequences(X_sc, y_sc, req.time_step)
        split      = int(len(X_seq) * (1 - req.test_size))
        X_tr, X_te = X_seq[:split], X_seq[split:]
        y_tr, y_te = y_seq[:split], y_seq[split:]

        _status.update(progress=25, message=f"建模（共 {req.epochs} 轮）…")
        model = Sequential([
            GRU(64, return_sequences=True, input_shape=(req.time_step, X_tr.shape[2])),
            Dropout(0.2),
            GRU(32),
            Dropout(0.2),
            Dense(1),
        ])
        model.compile(optimizer="adam", loss="mse")

        class _ProgressCB(tf.keras.callbacks.Callback):
            def on_epoch_end(self, epoch, logs=None):
                p = 25 + int((epoch + 1) / req.epochs * 65)
                _status.update(
                    progress=p,
                    message=f"训练中 {epoch + 1}/{req.epochs} 轮，loss={logs.get('loss', 0):.4f}"
                )

        model.fit(
            X_tr, y_tr,
            epochs=req.epochs,
            batch_size=req.batch_size,
            validation_split=0.1,
            callbacks=[_ProgressCB()],
            verbose=0,
        )

        _status.update(progress=92, message="计算评估指标…")
        y_pred_sc  = model.predict(X_te, verbose=0)
        y_pred     = sy.inverse_transform(y_pred_sc)
        y_true_te  = sy.inverse_transform(y_te)
        y_true_all = sy.inverse_transform(y_seq)

        rmse = float(np.sqrt(mean_squared_error(y_true_te, y_pred)))
        mae  = float(mean_absolute_error(y_true_te, y_pred))
        r2   = float(r2_score(y_true_te, y_pred))

        # ── 持久化模型和数据缓存 ──
        model.save(MODEL_H5)
        joblib.dump(sy, SCALER_Y)
        np.savez_compressed(
            CACHE_NPZ,
            X_seq=X_seq,
            y_true_all=y_true_all,
            split=np.array([split])
        )

        now  = datetime.now().isoformat(timespec="seconds")
        meta = dict(
            time_step=req.time_step, test_size=req.test_size,
            epochs=req.epochs, batch_size=req.batch_size,
            input_dims=int(X_tr.shape[2]), trained_at=now,
            train_size=split, test_size_actual=len(X_te),
            rmse=rmse, mae=mae, r2=r2,
            excel_path=req.excel_path, total_samples=len(X_seq),
        )
        with open(META_JSON, "w", encoding="utf-8") as f:
            json.dump(meta, f, ensure_ascii=False, indent=2)

        _status.update(
            model_exists=True, is_training=False, progress=100, message="训练完成",
            trained_at=now, rmse=rmse, mae=mae, r2=r2,
        )

    except Exception as e:
        _status.update(is_training=False, progress=0, message=f"训练失败：{e}")


# ─── API 端点 ─────────────────────────────────────────────────────────────
@app.post("/train")
def train_endpoint(req: TrainRequest):
    """异步启动训练任务，立即返回；通过 GET /status 轮询进度。"""
    if _status["is_training"]:
        return {"success": False, "message": "正在训练中，请稍后"}
    t = threading.Thread(target=_do_train, args=(req,), daemon=True)
    t.start()
    return {"success": True, "message": "训练任务已启动，请轮询 /status 获取进度"}


def _predict_with_existing_model(req: PredictRequest) -> dict:
    """
    使用已有模型文件 + 两个 Excel 文件直接预测，无需缓存 scaler。
    - req.model_path    : .h5 模型路径
    - req.feature_excel : 特征 Excel（多列，所有数值列作为输入）
    - req.real_excel    : 真实功率 Excel（第一列数值作为目标）
    """
    ts        = req.time_step or 30
    test_frac = req.test_size or 0.2

    model = load_model(req.model_path)

    # ── 加载特征 ──
    df_feat = pd.read_excel(req.feature_excel).dropna()
    feat_num = df_feat.select_dtypes(include=[np.number]).columns.tolist()
    if not feat_num:
        return {"success": False, "message": "特征 Excel 没有数值列"}
    X_raw = df_feat[feat_num].values

    # ── 加载真实功率 ──
    df_real = pd.read_excel(req.real_excel).dropna()
    real_num = df_real.select_dtypes(include=[np.number]).columns.tolist()
    if not real_num:
        return {"success": False, "message": "真实功率 Excel 没有数值列"}
    y_raw = df_real[[real_num[0]]].values

    # 对齐长度
    n = min(len(X_raw), len(y_raw))
    X_raw, y_raw = X_raw[:n], y_raw[:n]

    # ── 归一化（重新 fit，与训练时一致）──
    sx = MinMaxScaler()
    sy = MinMaxScaler()
    X_sc = sx.fit_transform(X_raw)
    y_sc = sy.fit_transform(y_raw)

    X_seq, y_seq = _make_sequences(X_sc, y_sc, ts)
    split   = int(len(X_seq) * (1 - test_frac))
    X_test  = X_seq[split:]
    y_test  = sy.inverse_transform(y_seq[split:])

    length = min(req.predict_length, len(X_test))
    start  = max(0, min(req.predict_start_index, len(X_test) - length))
    X_sl   = X_test[start: start + length]
    y_sl   = y_test[start: start + length]

    y_pred_sc = model.predict(X_sl, verbose=0)
    y_pred    = sy.inverse_transform(y_pred_sc)

    rmse = float(np.sqrt(mean_squared_error(y_sl, y_pred)))
    mae  = float(mean_absolute_error(y_sl, y_pred))
    r2   = float(r2_score(y_sl, y_pred))

    return {
        "success":         True,
        "message":         "预测成功（已有模型）",
        "rmse":            rmse,
        "mae":             mae,
        "r2":              r2,
        "predicted_power": [round(float(v[0]), 4) for v in y_pred],
        "real_power":      [round(float(v[0]), 4) for v in y_sl],
        "predict_length":  length,
    }


@app.post("/predict")
def predict_endpoint(req: PredictRequest):
    """
    快速推理端点。两种模式：
    1. 指定 model_path + feature_excel + real_excel → 使用已有模型直接预测
    2. 不指定路径 → 使用服务自身训练并缓存的模型
    """
    # ── 模式 1：使用已有模型 ──────────────────────────────────────────────
    if req.model_path:
        if not os.path.exists(req.model_path):
            return {"success": False, "message": f"模型文件不存在：{req.model_path}"}
        if not req.feature_excel or not os.path.exists(req.feature_excel):
            return {"success": False, "message": "请提供有效的特征数据 Excel 路径"}
        if not req.real_excel or not os.path.exists(req.real_excel):
            return {"success": False, "message": "请提供有效的真实功率 Excel 路径"}
        try:
            return _predict_with_existing_model(req)
        except Exception as e:
            return {"success": False, "message": f"预测失败：{e}"}

    # ── 模式 2：使用服务缓存模型 ─────────────────────────────────────────
    if not os.path.exists(MODEL_H5):
        return {"success": False, "message": "模型不存在，请先训练或指定 model_path"}
    if _status["is_training"]:
        return {"success": False, "message": "模型训练中，请稍后预测"}
    try:
        sy    = joblib.load(SCALER_Y)
        model = load_model(MODEL_H5)
        data  = np.load(CACHE_NPZ)

        X_seq      = data["X_seq"]
        y_true_all = data["y_true_all"]
        split      = int(data["split"][0])

        X_test  = X_seq[split:]
        y_test  = y_true_all[split:]
        length  = min(req.predict_length, len(X_test))
        start   = max(0, min(req.predict_start_index, len(X_test) - length))

        X_sl = X_test[start: start + length]
        y_sl = y_test[start: start + length]

        y_pred_sc = model.predict(X_sl, verbose=0)
        y_pred    = sy.inverse_transform(y_pred_sc)

        rmse = float(np.sqrt(mean_squared_error(y_sl, y_pred)))
        mae  = float(mean_absolute_error(y_sl, y_pred))
        r2   = float(r2_score(y_sl, y_pred))

        return {
            "success":         True,
            "message":         "预测成功",
            "rmse":            rmse,
            "mae":             mae,
            "r2":              r2,
            "predicted_power": [round(float(v[0]), 4) for v in y_pred],
            "real_power":      [round(float(v[0]), 4) for v in y_sl],
            "predict_length":  length,
        }
    except Exception as e:
        return {"success": False, "message": f"预测失败：{e}"}


@app.get("/status")
def status_endpoint():
    """返回当前模型状态、训练进度（0-100）和评估指标。"""
    return dict(_status)


# ─── 启动 ─────────────────────────────────────────────────────────────────
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000, reload=False)
