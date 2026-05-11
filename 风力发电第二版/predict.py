"""
风电功率 GRU 实时预测服务
- POST /train   — 异步训练，模型 + 缩放器持久化到 model/
- POST /predict — 加载已有模型做推理（毫秒级）
- GET  /status  — 查询训练状态 / 模型指标

启动：python predict.py
"""

import os
import json
import joblib
import threading
import numpy as np
import pandas as pd
from datetime import datetime
from typing import Optional, Tuple

from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score

os.environ.setdefault("HDF5_USE_FILE_LOCKING", "FALSE")

try:
    import tensorflow as tf
    from tensorflow.keras.models import Sequential, load_model
    from tensorflow.keras.layers import GRU, Dense, Dropout
except ImportError:
    raise RuntimeError("请安装 TensorFlow：pip install tensorflow")

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

# ── 常量 ──────────────────────────────────────────────────────────────────
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_DIR = os.path.join(BASE_DIR, "model")

MODEL_H5 = os.path.join(MODEL_DIR, "gru_model.h5")
MODEL_FD_H5 = os.path.join(MODEL_DIR, "gru_FD.h5")  # train.py 导出的模型
SCALER_Y = os.path.join(MODEL_DIR, "scaler_y.pkl")
META_JSON = os.path.join(MODEL_DIR, "meta.json")
CACHE_NPZ = os.path.join(MODEL_DIR, "data_cache.npz")

WIND_SPEED_COLS_FD = ["30米处风速", "50米处风速", "70米处风速", "风机轮毂处风速"]
_EXCEL_DAY_ORIGIN = "1899-12-30"  # Excel 1900 日期系统基准

os.makedirs(MODEL_DIR, exist_ok=True)

# ── FastAPI ───────────────────────────────────────────────────────────────
app = FastAPI(title="风电功率 GRU 实时预测服务", version="2.0")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])

# ── 全局状态 ──────────────────────────────────────────────────────────────
_status: dict = {
    "model_exists": False,
    "is_training": False,
    "progress": 0,
    "message": "模型未训练",
    "trained_at": None,
    "rmse": None,
    "mae": None,
    "r2": None,
}

# ── Pydantic 模型 ─────────────────────────────────────────────────────────
class TrainRequest(BaseModel):
    excel_path: str
    time_step: int = 30
    test_size: float = 0.2
    epochs: int = 50
    batch_size: int = 64
    target_col: Optional[str] = None


class PredictRequest(BaseModel):
    predict_length: int = 192
    predict_start_index: int = Field(default=-1, description="负数=从整表最末尾取窗口")
    model_path: Optional[str] = None
    feature_excel: Optional[str] = None
    real_excel: Optional[str] = None
    time_step: Optional[int] = None
    test_size: Optional[float] = None
    forecast_extra_minutes: int = 120
    forecast_point_interval_minutes: int = 15
    beyond_data_points: int = 0


# ═══════════════════════════════════════════════════════════════════════════
# 工具函数
# ═══════════════════════════════════════════════════════════════════════════

def _abs_norm_path(p: Optional[str]) -> Optional[str]:
    if p is None or str(p).strip() == "":
        return p
    return os.path.normpath(os.path.abspath(os.path.expanduser(str(p))))


def _win_short_path(path: str) -> str:
    """Windows 下将含中文的路径转为 8.3 短路径，解决 h5py 无法打开的问题。"""
    if sys.platform != "win32":
        return path
    import ctypes
    path = _abs_norm_path(path) or path
    if not os.path.exists(path):
        return path
    try:
        buf = ctypes.create_unicode_buffer(32768)
        kernel32 = ctypes.windll.kernel32
        n = kernel32.GetShortPathNameW(path, buf, len(buf))
        if n and buf.value:
            return buf.value
    except Exception:
        pass
    return path


def load_model_h5(path: str):
    """加载 .h5 模型，兼容不同 TF/Keras 版本的参数。"""
    p = _win_short_path(_abs_norm_path(path) or path)
    for kwargs in [{"compile": False}, {}, {"compile": False, "safe_mode": False}]:
        try:
            return load_model(p, **kwargs)
        except (TypeError, Exception):
            continue
    return load_model(p)


def _coerce_time_series(s: pd.Series) -> pd.Series:
    """将 Excel 序列号或字符串统一转为 datetime。"""
    if pd.api.types.is_numeric_dtype(s):
        mx = pd.to_numeric(s, errors="coerce").max()
        if mx is not None and not pd.isna(mx) and float(mx) > 20000:
            return pd.to_datetime(s, unit="D", origin=_EXCEL_DAY_ORIGIN, errors="coerce")
    return pd.to_datetime(s, errors="coerce")


def _load_excel(path: str, target_col: Optional[str]):
    df = pd.read_excel(path).dropna()
    num_cols = df.select_dtypes(include=[np.number]).columns.tolist()
    if not num_cols:
        raise ValueError("Excel 中没有数值列")
    y_col = target_col if (target_col and target_col in num_cols) else num_cols[-1]
    x_cols = [c for c in num_cols if c != y_col] or [y_col]
    return df[x_cols].values, df[[y_col]].values


def _make_sequences(X: np.ndarray, y: np.ndarray, time_step: int):
    xs, ys = [], []
    for i in range(len(X) - time_step):
        xs.append(X[i: i + time_step])
        ys.append(y[i + time_step])
    return np.array(xs), np.array(ys)


def _trim_to_common_timestamps(
    df_feat: pd.DataFrame, df_real: pd.DataFrame
) -> Tuple[pd.DataFrame, pd.DataFrame]:
    """按首列时间（统一到分钟）取交集，去掉只在一侧存在的行。"""
    if df_feat.shape[1] < 1 or df_real.shape[1] < 1:
        return df_feat, df_real

    cf, cr = df_feat.columns[0], df_real.columns[0]
    tf = _coerce_time_series(df_feat[cf])
    tr = _coerce_time_series(df_real[cr])
    if int(tf.notna().sum()) < 10 or int(tr.notna().sum()) < 10:
        return df_feat, df_real

    kf = tf.dt.floor("1min")
    kr = tr.dt.floor("1min")

    nf = df_feat.assign(__k=kf).dropna(subset=["__k"])
    nr = df_real.assign(__k=kr).dropna(subset=["__k"])

    common = set(nf["__k"].unique()) & set(nr["__k"].unique())
    if len(common) < 10:
        return df_feat, df_real

    nf = nf[nf["__k"].isin(common)].drop_duplicates("__k", keep="last")
    nr = nr[nr["__k"].isin(common)].drop_duplicates("__k", keep="last")
    nf = nf.sort_values("__k", kind="mergesort").drop(columns=["__k"]).reset_index(drop=True)
    nr = nr.sort_values("__k", kind="mergesort").drop(columns=["__k"]).reset_index(drop=True)
    return nf, nr


def _model_input_feature_dim(model) -> int:
    sh = getattr(model, "input_shape", None) or getattr(model.layers[0], "input_shape", None)
    if sh is None or len(sh) < 3 or sh[2] is None:
        raise ValueError("无法从模型读取 input_shape，需要形状 (None, time_step, n_features)")
    return int(sh[2])


def _try_merge_by_time(
    df_feat: pd.DataFrame, df_real: pd.DataFrame
) -> Optional[Tuple[np.ndarray, np.ndarray, str, np.ndarray]]:
    """按首列时间 inner merge 风速与功率，返回 (X_raw, y_raw, note, wall_t)。"""
    if df_feat.shape[1] < 1 or df_real.shape[1] < 2:
        return None
    if not all(c in df_feat.columns for c in WIND_SPEED_COLS_FD):
        return None

    f = df_feat.copy()
    r = df_real.copy()
    f["__t"] = _coerce_time_series(f.iloc[:, 0]).dt.floor("1min")
    r["__t"] = _coerce_time_series(r.iloc[:, 0]).dt.floor("1min")
    f = f.dropna(subset=["__t"]).drop_duplicates("__t", keep="last")
    r = r.dropna(subset=["__t"]).drop_duplicates("__t", keep="last")

    pwr_col = r.columns[1]
    sub_f = f[WIND_SPEED_COLS_FD + ["__t"]]
    sub_r = r[[pwr_col, "__t"]].rename(columns={pwr_col: "__pwr"})
    m = pd.merge(sub_f, sub_r, on="__t", how="inner")
    if len(m) < 10:
        return None
    if len(m) < int(0.4 * min(len(df_feat), len(df_real))):
        return None

    winds = m[WIND_SPEED_COLS_FD].apply(pd.to_numeric, errors="coerce").to_numpy(dtype=np.float64)
    pwr = pd.to_numeric(m["__pwr"], errors="coerce").to_numpy(dtype=np.float64).reshape(-1, 1)
    X_raw = np.hstack([winds, pwr])
    y_raw = pwr.copy()
    ok = ~(np.isnan(X_raw).any(axis=1) | np.isnan(y_raw).ravel())
    wall_t = m["__t"].to_numpy()
    X_raw, y_raw, wall_t = X_raw[ok], y_raw[ok], wall_t[ok]
    if len(X_raw) < 10:
        return None
    note = f"已按首列时间对齐：合并后有效 {len(X_raw)} 行（特征表 {len(df_feat)} 行、实测表 {len(df_real)} 行）。"
    return X_raw, y_raw, note, wall_t


def _build_xy_for_existing_model(
    df_feat: pd.DataFrame, df_real: pd.DataFrame, n_feat: int
) -> Tuple[np.ndarray, np.ndarray, str, Optional[np.ndarray]]:
    """构造与模型输入维数一致的 (X_raw, y_raw, align_note, wall_t)。"""
    # 5 维模式（4 风速 + 1 功率）：优先按时间合并
    if n_feat == 5 and all(c in df_feat.columns for c in WIND_SPEED_COLS_FD):
        merged = _try_merge_by_time(df_feat, df_real)
        if merged is not None:
            return merged

        winds = df_feat[WIND_SPEED_COLS_FD].apply(pd.to_numeric, errors="coerce").to_numpy(dtype=np.float64)
        if df_real.shape[1] >= 2:
            pwr = pd.to_numeric(df_real.iloc[:, 1], errors="coerce").to_numpy(dtype=np.float64).reshape(-1, 1)
        else:
            rn = df_real.select_dtypes(include=[np.number]).columns.tolist()
            if not rn:
                raise ValueError("真实功率 Excel 没有数值列")
            pwr = pd.to_numeric(df_real[rn[0]], errors="coerce").to_numpy(dtype=np.float64).reshape(-1, 1)

        n = min(len(winds), len(pwr))
        align_note = ""
        if len(df_feat) != len(df_real) or n < max(len(winds), len(pwr)):
            align_note = (
                f"按行号对齐取了前 {n} 行（特征 {len(df_feat)} 行、实测 {len(df_real)} 行）。"
                "若只改了实测表，请在特征表增加同一时刻的风速行，或统一首列时间格式以便自动按时间合并。"
            )
        winds, pwr = winds[:n], pwr[:n]
        wall_t = _coerce_time_series(df_feat.iloc[:n, 0]).to_numpy()
        X_raw = np.hstack([winds, pwr])
        y_raw = pwr.copy()
        ok = ~(np.isnan(X_raw).any(axis=1) | np.isnan(y_raw).ravel())
        X_raw, y_raw, wall_t = X_raw[ok], y_raw[ok], wall_t[ok]
        if len(X_raw) < 10:
            raise ValueError("对齐风速与功率并去除缺失后有效行过少，请检查 FD001.xlsx / FD001_real.xlsx")
        return X_raw, y_raw, align_note, wall_t

    # 通用模式：取前 n_feat 个数值列
    feat_num = df_feat.select_dtypes(include=[np.number]).columns.tolist()
    if len(feat_num) < n_feat:
        raise ValueError(
            f"模型需要 {n_feat} 维特征，特征 Excel 仅有 {len(feat_num)} 个数值列。"
            f"使用 gru_FD.h5 时请保证含列：{', '.join(WIND_SPEED_COLS_FD)}"
        )
    if len(feat_num) > n_feat:
        feat_num = feat_num[:n_feat]

    X_raw = df_feat[feat_num].apply(pd.to_numeric, errors="coerce").to_numpy(dtype=np.float64)
    real_num = df_real.select_dtypes(include=[np.number]).columns.tolist()
    if not real_num:
        raise ValueError("真实功率 Excel 没有数值列")
    y_raw = df_real[[real_num[0]]].apply(pd.to_numeric, errors="coerce").to_numpy(dtype=np.float64)

    n = min(len(X_raw), len(y_raw))
    align_note = ""
    if len(df_feat) != len(df_real):
        align_note = f"按行号对齐前 {n} 行（特征 {len(df_feat)} 行、实测 {len(df_real)} 行）。"
    X_raw, y_raw = X_raw[:n], y_raw[:n]
    wall_t = _coerce_time_series(df_feat.iloc[:n, 0]).to_numpy()
    ok = ~(np.isnan(X_raw).any(axis=1) | np.isnan(y_raw).ravel())
    X_raw, y_raw, wall_t = X_raw[ok], y_raw[ok], wall_t[ok]
    return X_raw, y_raw, align_note, wall_t


def _forecast_beyond_data(
    model, sy, X_sl_last, X_sc_last, point_times, wall_t,
    beyond, ts, nf, interval_m,
):
    """自回归预测：在数据末尾之后，用最后一行风速特征持续预测未来点。
    直接在 point_times 中追加时间，返回 (pred_vals, None) 列表供外层拼接。
    """
    seq = np.asarray(X_sl_last, dtype=np.float64).copy()
    pred_vals = []

    if nf < 2:
        return pred_vals

    winds_sc = np.asarray(X_sc_last[:nf - 1], dtype=np.float64).ravel()

    last_ts = None
    for src in [point_times[-1] if point_times else None,
                wall_t[-1] if wall_t is not None and len(wall_t) > 0 else None]:
        if src:
            try:
                last_ts = pd.Timestamp(src)
                break
            except Exception:
                continue
    if last_ts is None:
        last_ts = pd.Timestamp.now()

    for j in range(beyond):
        pred_sc = model.predict(seq.reshape(1, ts, nf), verbose=0)
        pv = np.asarray(pred_sc, dtype=np.float64).ravel()
        p_val = float(sy.inverse_transform(pv[:1].reshape(-1, 1))[0, 0])

        new_row = np.concatenate([winds_sc, pv[:1]])
        seq = np.vstack([seq[1:], new_row.reshape(1, -1)])
        t_next = last_ts + pd.Timedelta(minutes=interval_m * (j + 1))

        point_times.append(str(t_next.isoformat(timespec="seconds")))
        pred_vals.append(round(p_val, 4))

    return pred_vals


def _build_point_times(wall_t, X_len, start, total_len, ts):
    """根据原始时刻数组构造每个预测点对应的 ISO 时间字符串。"""
    if wall_t is None or len(wall_t) != X_len:
        return [None] * total_len, None, None

    i0 = start + ts
    i1 = start + total_len - 1 + ts
    seg_start, seg_end = None, None
    if 0 <= i0 < len(wall_t) and 0 <= i1 < len(wall_t):
        try:
            seg_start = str(pd.Timestamp(wall_t[i0]).isoformat(timespec="seconds"))
            seg_end = str(pd.Timestamp(wall_t[i1]).isoformat(timespec="seconds"))
        except Exception:
            pass

    times = []
    for i in range(total_len):
        idx = start + i + ts
        if 0 <= idx < len(wall_t):
            try:
                times.append(str(pd.Timestamp(wall_t[idx]).isoformat(timespec="seconds")))
            except Exception:
                times.append(None)
        else:
            times.append(None)
    return times, seg_start, seg_end


# ═══════════════════════════════════════════════════════════════════════════
# 训练
# ═══════════════════════════════════════════════════════════════════════════

def _restore_meta():
    """启动时从持久化文件恢复模型状态。"""
    if os.path.exists(META_JSON) and os.path.exists(MODEL_H5):
        with open(META_JSON, encoding="utf-8") as f:
            m = json.load(f)
        _status.update(
            model_exists=True, is_training=False, progress=100,
            message="模型已就绪（本服务 /train 训练缓存）",
            trained_at=m.get("trained_at"),
            rmse=m.get("rmse"), mae=m.get("mae"), r2=m.get("r2"),
        )
        return
    if os.path.exists(MODEL_FD_H5):
        _status.update(
            model_exists=True, is_training=False, progress=100,
            message="已检测到 gru_FD.h5（由 train.py 训练，Spring 默认走此模型）",
            trained_at=None, rmse=None, mae=None, r2=None,
        )


_restore_meta()


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
        split = int(len(X_seq) * (1 - req.test_size))
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
                _status.update(progress=p, message=f"训练中 {epoch + 1}/{req.epochs} 轮，loss={logs.get('loss', 0):.4f}")

        model.fit(
            X_tr, y_tr, epochs=req.epochs, batch_size=req.batch_size,
            validation_split=0.1, callbacks=[_ProgressCB()], verbose=0,
        )

        _status.update(progress=92, message="计算评估指标…")
        y_pred_sc = model.predict(X_te, verbose=0)
        y_pred = sy.inverse_transform(y_pred_sc)
        y_true_te = sy.inverse_transform(y_te)
        y_true_all = sy.inverse_transform(y_seq)

        rmse = float(np.sqrt(mean_squared_error(y_true_te, y_pred)))
        mae = float(mean_absolute_error(y_true_te, y_pred))
        r2 = float(r2_score(y_true_te, y_pred))

        model.save(MODEL_H5)
        joblib.dump(sy, SCALER_Y)
        np.savez_compressed(CACHE_NPZ, X_seq=X_seq, y_true_all=y_true_all, split=np.array([split]))

        now = datetime.now().isoformat(timespec="seconds")
        with open(META_JSON, "w", encoding="utf-8") as f:
            json.dump(dict(
                time_step=req.time_step, test_size=req.test_size,
                epochs=req.epochs, batch_size=req.batch_size,
                input_dims=int(X_tr.shape[2]), trained_at=now,
                train_size=split, test_size_actual=len(X_te),
                rmse=rmse, mae=mae, r2=r2,
                excel_path=req.excel_path, total_samples=len(X_seq),
            ), f, ensure_ascii=False, indent=2)

        _status.update(
            model_exists=True, is_training=False, progress=100,
            message="训练完成", trained_at=now, rmse=rmse, mae=mae, r2=r2,
        )
    except Exception as e:
        _status.update(is_training=False, progress=0, message=f"训练失败：{e}")


# ═══════════════════════════════════════════════════════════════════════════
# API 端点
# ═══════════════════════════════════════════════════════════════════════════

@app.post("/train")
def train_endpoint(req: TrainRequest):
    if _status["is_training"]:
        return {"success": False, "message": "正在训练中，请稍后"}
    threading.Thread(target=_do_train, args=(req,), daemon=True).start()
    return {"success": True, "message": "训练任务已启动，请轮询 /status 获取进度"}


@app.get("/status")
def status_endpoint():
    return dict(_status)


@app.post("/predict")
async def predict_endpoint(request: Request):
    raw = await request.body()
    if not raw or not raw.strip():
        req = PredictRequest()
    else:
        try:
            req = PredictRequest.model_validate_json(raw.decode("utf-8"))
        except Exception as e:
            return {"success": False, "message": f"请求体 JSON 无效：{e}"}
    return _predict_dispatch(req)


def _predict_dispatch(req: PredictRequest):
    # 模式 1：使用已有模型文件 + Excel
    if req.model_path:
        mp = _abs_norm_path(req.model_path)
        if mp and not os.path.exists(mp):
            return {"success": False, "message": f"模型文件不存在：{mp}"}
        if not req.feature_excel or not os.path.exists(req.feature_excel):
            return {"success": False, "message": "请提供有效的特征数据 Excel 路径"}
        if not req.real_excel or not os.path.exists(req.real_excel):
            return {"success": False, "message": "请提供有效的真实功率 Excel 路径"}
        try:
            return _predict_with_existing_model(
                req.model_copy(update={"model_path": mp or req.model_path})
            )
        except Exception as e:
            return {"success": False, "message": f"预测失败：{e}"}

    # 模式 2：使用服务缓存模型
    if not os.path.exists(MODEL_H5):
        return {"success": False, "message": "模型不存在，请先训练或指定 model_path"}
    if _status["is_training"]:
        return {"success": False, "message": "模型训练中，请稍后预测"}

    try:
        sy = joblib.load(SCALER_Y)
        model = load_model_h5(MODEL_H5)
        data = np.load(CACHE_NPZ)

        X_seq = data["X_seq"]
        y_true_all = data["y_true_all"]
        split = int(data["split"][0])

        X_test = X_seq[split:]
        y_test = y_true_all[split:]
        length = min(req.predict_length, len(X_test))
        start = max(0, len(X_test) - length) if req.predict_start_index < 0 else \
                max(0, min(req.predict_start_index, len(X_test) - length))

        X_sl = X_test[start: start + length]
        y_sl = y_test[start: start + length]

        y_pred_sc = model.predict(X_sl, verbose=0)
        y_pred = sy.inverse_transform(y_pred_sc)

        return {
            "success": True, "message": "预测成功",
            "rmse": float(np.sqrt(mean_squared_error(y_sl, y_pred))),
            "mae": float(mean_absolute_error(y_sl, y_pred)),
            "r2": float(r2_score(y_sl, y_pred)),
            "predicted_power": [round(float(v[0]), 4) for v in y_pred],
            "real_power": [round(float(v[0]), 4) for v in y_sl],
            "predict_length": length,
        }
    except Exception as e:
        return {"success": False, "message": f"预测失败：{e}"}


def _predict_with_existing_model(req: PredictRequest) -> dict:
    ts = req.time_step or 30

    model = load_model_h5(req.model_path)
    try:
        n_feat = _model_input_feature_dim(model)
    except ValueError as e:
        return {"success": False, "message": str(e)}

    df_feat = pd.read_excel(req.feature_excel)
    df_real = pd.read_excel(req.real_excel)
    n_fb, n_rb = len(df_feat), len(df_real)

    df_feat, df_real = _trim_to_common_timestamps(df_feat, df_real)
    trimmed = len(df_feat) != n_fb or len(df_real) != n_rb
    trim_note = ""
    if trimmed:
        trim_note = (
            f"已按首列时间交集去除不匹配行：特征 {n_fb}→{len(df_feat)} 行，"
            f"实测 {n_rb}→{len(df_real)} 行（仅保留两表共有的时刻）。"
        )

    try:
        X_raw, y_raw, align_note, wall_t = _build_xy_for_existing_model(df_feat, df_real, n_feat)
    except ValueError as e:
        return {"success": False, "message": str(e)}

    if len(X_raw) <= ts:
        return {"success": False, "message": f"有效样本行数 {len(X_raw)} 不大于时间步 {ts}，无法构造序列"}

    # 归一化
    sx, sy = MinMaxScaler(), MinMaxScaler()
    X_sc = sx.fit_transform(X_raw)
    y_sc = sy.fit_transform(y_raw)

    X_seq, y_seq = _make_sequences(X_sc, y_sc, ts)
    y_pool = sy.inverse_transform(y_seq)

    # 计算预测窗口
    interval_m = max(1, int(req.forecast_point_interval_minutes or 15))
    extra_pts_req = max(0, int(np.ceil(max(0, req.forecast_extra_minutes or 0) / interval_m)))

    main_len = min(req.predict_length, len(X_seq))
    if req.predict_start_index < 0:
        need = min(main_len + extra_pts_req, len(X_seq))
        start = max(0, len(X_seq) - need)
    else:
        start = max(0, min(req.predict_start_index, max(0, len(X_seq) - main_len)))

    avail = len(X_seq) - start
    main_eff = min(main_len, avail)
    extra_eff = min(extra_pts_req, max(0, avail - main_eff))
    total_len = main_eff + extra_eff

    X_sl = X_seq[start: start + total_len]
    y_sl_full = y_pool[start: start + total_len]

    # 推理
    y_pred = sy.inverse_transform(model.predict(X_sl, verbose=0))

    # 构造结果列表
    pred_list = [round(float(y_pred[i][0]), 4) for i in range(total_len)]
    real_list = [round(float(y_sl_full[i][0]), 4) for i in range(total_len)]

    rmse = float(np.sqrt(mean_squared_error(y_sl_full, y_pred)))
    mae = float(mean_absolute_error(y_sl_full, y_pred))
    r2 = float(r2_score(y_sl_full, y_pred))

    # 时间轴
    times, seg_start, seg_end = _build_point_times(wall_t, len(X_raw), start, total_len, ts)

    # 自回归延长预测（超出数据范围的部分）
    beyond = max(0, min(int(getattr(req, "beyond_data_points", 0) or 0), 200))
    main_points = total_len
    if beyond > 0 and total_len > 0:
        extra_vals = _forecast_beyond_data(
            model, sy, X_sl[-1], X_sc[-1], times, wall_t,
            beyond, ts, int(X_sl.shape[2]), interval_m,
        )
        pred_list.extend(extra_vals)
        real_list.extend([None] * len(extra_vals))

    total_out = len(pred_list)
    fut_n = total_out - main_points
    if fut_n > 0 and times:
        seg_end = times[-1]

    out = {
        "success": True,
        "message": "预测成功（已有模型）",
        "rmse": rmse, "mae": mae, "r2": r2,
        "predicted_power": pred_list,
        "real_power": real_list,
        "predict_length": total_out,
        "compare_length": main_points,
        "future_points": fut_n,
        "forecast_extra_minutes": int(fut_n * interval_m),
        "segment_time_start": seg_start,
        "segment_time_end": seg_end,
        "point_times": times,
        "excel_meta": {
            "feature_rows_read": n_fb,
            "real_rows_read": n_rb,
            "rows_after_time_trim": {"feature": len(df_feat), "real": len(df_real)},
            "aligned_xy_rows": len(X_raw),
            "time_trim_applied": trimmed,
        },
    }
    notes = [s for s in (trim_note, align_note) if s]
    if notes:
        out["align_note"] = "；".join(notes)
    return out


# ═══════════════════════════════════════════════════════════════════════════
if __name__ == "__main__":
    import sys
    try:
        import uvicorn
    except ImportError:
        print("=" * 60, file=sys.stderr)
        print("缺少依赖（例如 uvicorn）。请在「风力发电第二版」目录执行：", file=sys.stderr)
        print("  python -m pip install -r requirements.txt", file=sys.stderr)
        print("若已安装但仍报错，多半是 Java 调用的 python 与命令行不是同一个解释器。", file=sys.stderr)
        print("请在 application.yml 设置 wind.forecast.python-command 为虚拟环境的 python.exe 全路径。", file=sys.stderr)
        print("=" * 60, file=sys.stderr)
        raise SystemExit(1)
    uvicorn.run(app, host="0.0.0.0", port=8989, reload=False)
