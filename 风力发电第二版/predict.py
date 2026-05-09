"""
风电功率 GRU 实时预测服务
- POST /train   → 异步训练，模型+缩放器持久化到 model/ 目录
- POST /predict → 加载已存模型做快速推理（毫秒级，无需重训）
- GET  /status  → 查询训练状态 / 模型指标

依赖安装：
  pip install -r requirements.txt
  （勿 pip install ctypes：为标准库，PyPI 无此包）

启动：python predict.py（或由 Spring Boot wind.forecast.auto-start-python 自动拉起）
"""

import os
import sys
import json

# 减轻 HDF5 文件锁在部分环境下的异常；须在尽可能靠前设置（已导入 TF 时亦有一定帮助）
os.environ.setdefault("HDF5_USE_FILE_LOCKING", "FALSE")
import joblib
import threading
import numpy as np
import pandas as pd
from datetime import datetime
from typing import Optional, Tuple

from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score

try:
    import tensorflow as tf
    from tensorflow.keras.models import Sequential, load_model
    from tensorflow.keras.layers import GRU, Dense, Dropout
except ImportError:
    raise RuntimeError("请安装 TensorFlow：pip install tensorflow")

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

# Excel 1900 日期系统：首列若存成 45658.01 这类序列号，先还原为 datetime
_EXCEL_DAY_ORIGIN = "1899-12-30"


def _coerce_time_series(s: pd.Series) -> pd.Series:
    if pd.api.types.is_numeric_dtype(s):
        mx = pd.to_numeric(s, errors="coerce").max()
        if mx is not None and not pd.isna(mx) and float(mx) > 20000:
            return pd.to_datetime(s, unit="D", origin=_EXCEL_DAY_ORIGIN, errors="coerce")
    return pd.to_datetime(s, errors="coerce")


def _abs_norm_path(p: Optional[str]) -> Optional[str]:
    """统一绝对路径 + 系统分隔符，避免混合斜杠。"""
    if p is None or str(p).strip() == "":
        return p
    return os.path.normpath(os.path.abspath(os.path.expanduser(str(p))))


def _win_short_path(path: str) -> str:
    """
    Windows 下 h5py 打开含中文/Unicode 路径时常报 Unable to open file / errno=-1。
    GetShortPathNameW 得到 8.3 短路径（纯 ASCII）后再交给 Keras/h5py。
    （ctypes 为标准库，仅在本函数内导入，勿 pip install ctypes）
    """
    if sys.platform != "win32":
        return path
    import ctypes

    path = _abs_norm_path(path) or path
    if not os.path.exists(path):
        return path
    try:
        buf = ctypes.create_unicode_buffer(32768)
        kernel32 = ctypes.windll.kernel32  # type: ignore[attr-defined]
        n = kernel32.GetShortPathNameW(path, buf, len(buf))
        if n and buf.value:
            return buf.value
    except Exception:
        pass
    return path


def load_model_h5(path: str):
    """加载 .h5；Windows 上对路径做短路径处理。"""
    p = _abs_norm_path(path) or path
    lp = _win_short_path(p)
    try:
        return load_model(lp, compile=False)
    except TypeError:
        # 旧版 TF/Keras 无 compile 参数
        return load_model(lp)
    except Exception:
        try:
            return load_model(lp, compile=False, safe_mode=False)
        except TypeError:
            return load_model(lp)


# ─── 路径 ──────────────────────────────────────────────────────────────────
BASE_DIR  = os.path.dirname(os.path.abspath(__file__))
MODEL_DIR = os.path.join(BASE_DIR, "model")
MODEL_H5  = os.path.join(MODEL_DIR, "gru_model.h5")
# train.py 单独保存的模型（Spring 默认 model-path 指向此文件）
MODEL_FD_H5 = os.path.join(MODEL_DIR, "gru_FD.h5")
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
            message="模型已就绪（本服务 /train 训练缓存）",
            trained_at=m.get("trained_at"),
            rmse=m.get("rmse"),
            mae=m.get("mae"),
            r2=m.get("r2"),
        )
        return
    # 仅有 train.py 导出的 gru_FD.h5 时，/status 仍应提示可预测，避免误显「模型未训练」
    if os.path.exists(MODEL_FD_H5):
        _status.update(
            model_exists=True,
            is_training=False,
            progress=100,
            message="已检测到 gru_FD.h5（由 train.py 训练，Spring 默认走此模型）",
            trained_at=None,
            rmse=None,
            mae=None,
            r2=None,
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


# 与 train.py 中 gru_FD.h5 训练数据一致：4 个高度风速 + 功率，共 5 维逐步输入
WIND_SPEED_COLS_FD = ["30米处风速", "50米处风速", "70米处风速", "风机轮毂处风速"]


class PredictRequest(BaseModel):
    predict_length: int = 192
    # ≥0：从「整表序列」内该下标起算；<0（推荐 -1）：对齐到整表序列最末尾（不再按 test_size 截成测试段）
    predict_start_index: int = Field(default=-1, description="预测起点；负数表示使用整表时间序列最末尾")
    # ── 使用已有模型时填写以下字段（不需要重新训练）──────────────────────────
    model_path:    Optional[str] = None   # 已有 .h5 模型路径
    feature_excel: Optional[str] = None  # 特征数据 Excel（FD001.xlsx）
    real_excel:    Optional[str] = None  # 真实功率 Excel（FD001_real.xlsx）
    time_step:     Optional[int] = None  # 建序列的时间步（默认 30）
    test_size:     Optional[float] = None  # 仅无 model_path、走缓存 npz 模式时有效；指定 Excel+模型时推理取整表末尾，忽略此项
    # 在「可对比」预测点之后，再输出若干点仅预测值（无实测），点数 = ceil(分钟/间隔)
    forecast_extra_minutes:           int = 120
    forecast_point_interval_minutes:  int = 15
    # 超出 Excel 末行之后，再自回归多预测若干点（无实测）；风速特征沿用最后一行
    beyond_data_points:               int = 0


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


def _trim_to_common_timestamps(df_feat: pd.DataFrame, df_real: pd.DataFrame) -> Tuple[pd.DataFrame, pd.DataFrame]:
    """
    只保留两表首列时间在「统一到分钟」后的交集；同分钟多行保留最后一行；按时间升序。
    去掉只出现在一侧的尾部/头部行，避免行数不一致时按行号对齐错行、或合并后仍携带无效末尾。
    """
    if df_feat.shape[1] < 1 or df_real.shape[1] < 1:
        return df_feat, df_real
    cf, cr = df_feat.columns[0], df_real.columns[0]
    tf = _coerce_time_series(df_feat[cf])
    tr = _coerce_time_series(df_real[cr])
    if int(tf.notna().sum()) < 10 or int(tr.notna().sum()) < 10:
        return df_feat, df_real
    kf = tf.dt.floor("1min")
    kr = tr.dt.floor("1min")
    nf = df_feat.assign(__k=kf)
    nr = df_real.assign(__k=kr)
    nf = nf.dropna(subset=["__k"])
    nr = nr.dropna(subset=["__k"])
    common = set(nf["__k"].unique()) & set(nr["__k"].unique())
    if len(common) < 10:
        return df_feat, df_real
    nf = nf[nf["__k"].isin(common)].drop_duplicates("__k", keep="last")
    nr = nr[nr["__k"].isin(common)].drop_duplicates("__k", keep="last")
    nf = nf.sort_values("__k", kind="mergesort").drop(columns=["__k"]).reset_index(drop=True)
    nr = nr.sort_values("__k", kind="mergesort").drop(columns=["__k"]).reset_index(drop=True)
    return nf, nr


def _model_input_feature_dim(model) -> int:
    """从已加载 Keras 模型解析每个时间步的特征维数 (batch, time_step, features) 中的 features。"""
    sh = getattr(model, "input_shape", None)
    if sh is None or len(sh) < 3 or sh[2] is None:
        try:
            sh = model.layers[0].input_shape
        except Exception:
            sh = None
    if sh is None or len(sh) < 3 or sh[2] is None:
        raise ValueError("无法从模型读取 input_shape，需要形状 (None, time_step, n_features)")
    return int(sh[2])


def _try_merge_fd001_by_time(df_feat: pd.DataFrame, df_real: pd.DataFrame) -> Optional[Tuple[np.ndarray, np.ndarray, str, np.ndarray]]:
    """
    用两表首列时间做 inner merge，避免「只加长实测表、特征表行数不变」时新行被按行号截断；
    首列支持混用 2019-12-31 21:00:00 与 2019/12/31 23:00 等格式（统一到分钟）。
    """
    try:
        if df_feat.shape[1] < 1 or df_real.shape[1] < 2:
            return None
        if not all(c in df_feat.columns for c in WIND_SPEED_COLS_FD):
            return None
        f = df_feat.copy()
        r = df_real.copy()
        f["__t"] = _coerce_time_series(f.iloc[:, 0])
        r["__t"] = _coerce_time_series(r.iloc[:, 0])
        f["__t"] = f["__t"].dt.floor("1min")
        r["__t"] = r["__t"].dt.floor("1min")
        f = f.dropna(subset=["__t"]).drop_duplicates("__t", keep="last")
        r = r.dropna(subset=["__t"]).drop_duplicates("__t", keep="last")
        pnm = r.columns[1]
        sub_r = r[[pnm, "__t"]].rename(columns={pnm: "__pwr"})
        sub_f = f[WIND_SPEED_COLS_FD + ["__t"]]
        m = pd.merge(sub_f, sub_r, on="__t", how="inner")
        if len(m) < 10:
            return None
        # 合并行数太少则退回按行对齐（避免误合并）
        if len(m) < int(0.4 * min(len(df_feat), len(df_real))):
            return None
        winds = m[WIND_SPEED_COLS_FD].apply(pd.to_numeric, errors="coerce").to_numpy(dtype=np.float64)
        pwr = pd.to_numeric(m["__pwr"], errors="coerce").to_numpy(dtype=np.float64).reshape(-1, 1)
        X_raw = np.hstack([winds, pwr])
        y_raw = pwr.copy()
        ok = ~(np.isnan(X_raw).any(axis=1) | np.isnan(y_raw).ravel())
        t_wall = m["__t"].to_numpy()
        X_raw, y_raw = X_raw[ok], y_raw[ok]
        t_wall = t_wall[ok]
        if len(X_raw) < 10:
            return None
        note = (
            f"已按首列时间对齐：合并后有效 {len(X_raw)} 行（特征表 {len(df_feat)} 行、实测表 {len(df_real)} 行）。"
        )
        return X_raw, y_raw, note, t_wall
    except Exception:
        return None


def _build_xy_for_existing_model(
    df_feat: pd.DataFrame, df_real: pd.DataFrame, n_feat: int
) -> Tuple[np.ndarray, np.ndarray, str, Optional[np.ndarray]]:
    """
    构造与模型输入维数一致的 X_raw、y_raw，以及给人看的对齐说明 align_note。
    - n_feat==5 且特征表含 train.py 同款风速列：优先按首列时间合并；否则按行号取 min 行。
    - 否则：取特征表中前 n_feat 个数值列；y 取真实表第一个数值列（仅按行号）。
    """
    align_note = ""
    if n_feat == 5 and all(c in df_feat.columns for c in WIND_SPEED_COLS_FD):
        merged = _try_merge_fd001_by_time(df_feat, df_real)
        if merged is not None:
            X_raw, y_raw, align_note, t_wall = merged
            return X_raw, y_raw, align_note, t_wall

        winds = df_feat[WIND_SPEED_COLS_FD].apply(pd.to_numeric, errors="coerce").to_numpy(dtype=np.float64)
        if df_real.shape[1] >= 2:
            pwr = pd.to_numeric(df_real.iloc[:, 1], errors="coerce").to_numpy(dtype=np.float64).reshape(-1, 1)
        else:
            rn = df_real.select_dtypes(include=[np.number]).columns.tolist()
            if not rn:
                raise ValueError("真实功率 Excel 没有数值列")
            pwr = pd.to_numeric(df_real[rn[0]], errors="coerce").to_numpy(dtype=np.float64).reshape(-1, 1)
        n = min(len(winds), len(pwr))
        if len(df_feat) != len(df_real) or n < max(len(winds), len(pwr)):
            align_note = (
                f"按行号对齐取了前 {n} 行（特征 {len(df_feat)} 行、实测 {len(df_real)} 行）。"
                "若只改了实测表，请在特征表增加同一时刻的风速行，或统一首列时间格式以便自动按时间合并。"
            )
        winds, pwr = winds[:n], pwr[:n]
        t_pre = _coerce_time_series(df_feat.iloc[:n, 0]).to_numpy()
        X_raw = np.hstack([winds, pwr])
        y_raw = pwr.copy()
        ok = ~(np.isnan(X_raw).any(axis=1) | np.isnan(y_raw).ravel())
        X_raw, y_raw = X_raw[ok], y_raw[ok]
        t_wall = t_pre[ok]
        if len(X_raw) < 10:
            raise ValueError("对齐风速与功率并去除缺失后有效行过少，请检查 FD001.xlsx / FD001_real.xlsx")
        return X_raw, y_raw, align_note, t_wall

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
    if len(df_feat) != len(df_real):
        align_note = f"按行号对齐前 {n} 行（特征 {len(df_feat)} 行、实测 {len(df_real)} 行）。"
    X_raw, y_raw = X_raw[:n], y_raw[:n]
    t_pre = _coerce_time_series(df_feat.iloc[:n, 0]).to_numpy()
    ok = ~(np.isnan(X_raw).any(axis=1) | np.isnan(y_raw).ravel())
    X_raw, y_raw = X_raw[ok], y_raw[ok]
    t_wall = t_pre[ok]
    return X_raw, y_raw, align_note, t_wall


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

    预测窗口：在「对齐后的整表」上构造滑窗序列后，始终从**序列最末尾**截取
   （predict_start_index<0），不再先用 test_size 丢掉前面 80% 数据。
    """
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
    trim_note = ""
    trimmed = len(df_feat) != n_fb or len(df_real) != n_rb
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

    # ── 归一化（重新 fit，与训练时一致）──
    sx = MinMaxScaler()
    sy = MinMaxScaler()
    X_sc = sx.fit_transform(X_raw)
    y_sc = sy.fit_transform(y_raw)

    X_seq, y_seq = _make_sequences(X_sc, y_sc, ts)
    # 推理：用整条对齐序列，窗口只从**最末尾**取（不按 train/test 比例截断）
    X_pool = X_seq
    y_pool = sy.inverse_transform(y_seq)

    interval_m = max(1, int(req.forecast_point_interval_minutes or 15))
    extra_pts_req = max(0, int(np.ceil(max(0, req.forecast_extra_minutes or 0) / interval_m)))

    main_len = min(req.predict_length, len(X_pool))
    if req.predict_start_index < 0:
        need = min(main_len + extra_pts_req, len(X_pool))
        start = max(0, len(X_pool) - need)
    else:
        start = max(0, min(req.predict_start_index, max(0, len(X_pool) - main_len)))
    avail = len(X_pool) - start
    main_eff = min(main_len, avail)
    extra_eff = min(extra_pts_req, max(0, avail - main_eff))
    total_len = main_eff + extra_eff

    X_sl = X_pool[start: start + total_len]
    y_sl_full = y_pool[start: start + total_len]

    y_pred_sc = model.predict(X_sl, verbose=0)
    y_pred = sy.inverse_transform(y_pred_sc)

    pred_list = []
    real_list = []
    for i in range(total_len):
        pred_list.append(round(float(y_pred[i][0]), 4))
        # Excel/对齐序列在末尾仍有实测时一并返回，避免前端绿线提前结束（原先用 None 模拟「延长预测无实测」）
        real_list.append(round(float(y_sl_full[i][0]), 4))

    y_cmp = y_sl_full
    pred_cmp = y_pred
    rmse = float(np.sqrt(mean_squared_error(y_cmp, pred_cmp)))
    mae = float(mean_absolute_error(y_cmp, pred_cmp))
    r2 = float(r2_score(y_cmp, pred_cmp))

    seg_start = None
    seg_end = None
    point_times = []
    if wall_t is not None and len(wall_t) == len(X_raw):
        # 序列下标 start+i 对应目标时刻所在 X_raw 行：start + i + ts（与 _make_sequences 一致）
        i0 = start + ts
        i1 = start + total_len - 1 + ts
        if 0 <= i0 < len(wall_t) and 0 <= i1 < len(wall_t):
            try:
                seg_start = str(pd.Timestamp(wall_t[i0]).isoformat(timespec="seconds"))
                seg_end = str(pd.Timestamp(wall_t[i1]).isoformat(timespec="seconds"))
            except Exception:
                pass
        for i in range(total_len):
            idx = start + i + ts
            if 0 <= idx < len(wall_t):
                try:
                    point_times.append(str(pd.Timestamp(wall_t[idx]).isoformat(timespec="seconds")))
                except Exception:
                    point_times.append(None)
            else:
                point_times.append(None)
    else:
        point_times = [None] * total_len

    beyond = max(0, min(int(getattr(req, "beyond_data_points", 0) or 0), 200))
    main_points = total_len
    if beyond > 0 and total_len > 0:
        seq = np.asarray(X_sl[-1], dtype=np.float64).copy()
        nf = int(seq.shape[1])
        if nf >= 2:
            winds_sc = np.asarray(X_sc[-1, : nf - 1], dtype=np.float64).ravel()
            last_ts = None
            if point_times and point_times[-1]:
                try:
                    last_ts = pd.Timestamp(point_times[-1])
                except Exception:
                    last_ts = None
            if last_ts is None and wall_t is not None and len(wall_t) > 0:
                try:
                    last_ts = pd.Timestamp(wall_t[-1])
                except Exception:
                    last_ts = None
            if last_ts is None:
                last_ts = pd.Timestamp.now()
            for j in range(beyond):
                pred_sc = model.predict(seq.reshape(1, ts, nf), verbose=0)
                pv = np.asarray(pred_sc, dtype=np.float64).reshape(-1)
                p_u = float(sy.inverse_transform(pv.reshape(-1, 1))[0, 0])
                pred_list.append(round(p_u, 4))
                real_list.append(None)
                new_row = np.concatenate([winds_sc, pv[:1]])
                seq = np.vstack([seq[1:], new_row.reshape(1, -1)])
                t2 = last_ts + pd.Timedelta(minutes=interval_m * (j + 1))
                point_times.append(str(t2.isoformat(timespec="seconds")))

    total_out = len(pred_list)
    fut_n = total_out - main_points
    if fut_n > 0 and point_times:
        seg_end = point_times[-1]

    out = {
        "success":            True,
        "message":            "预测成功（已有模型）",
        "rmse":               rmse,
        "mae":                mae,
        "r2":                 r2,
        "predicted_power":    pred_list,
        "real_power":         real_list,
        "predict_length":     total_out,
        "compare_length":     main_points,
        "future_points":      fut_n,
        "forecast_extra_minutes": int(fut_n * interval_m),
        "segment_time_start": seg_start,
        "segment_time_end":   seg_end,
        # 与每个预测点一一对应的墙钟时间（ISO），供前端横轴/tooltip 展示
        "point_times":        point_times,
        # 便于前端/排查：与 Excel 是否最新、是否被裁剪一致
        "excel_meta": {
            "feature_rows_read":   n_fb,
            "real_rows_read":      n_rb,
            "rows_after_time_trim": {"feature": len(df_feat), "real": len(df_real)},
            "aligned_xy_rows":     len(X_raw),
            "time_trim_applied":   trimmed,
        },
    }
    notes = [s for s in (trim_note, align_note) if s]
    if notes:
        out["align_note"] = "；".join(notes)
    return out


@app.post("/predict")
async def predict_endpoint(request: Request):
    """
    快速推理端点。两种模式：
    1. 指定 model_path + feature_excel + real_excel → 使用已有模型直接预测
    2. 不指定路径 → 使用服务自身训练并缓存的模型

    允许空 body：少数 HTTP 客户端未附带 JSON 时，按默认 PredictRequest 处理。
    """
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
    """predict_endpoint 的实际推理逻辑。"""
    # ── 模式 1：使用已有模型 ──────────────────────────────────────────────
    if req.model_path:
        mp = _abs_norm_path(req.model_path)
        if mp and not os.path.exists(mp):
            return {"success": False, "message": f"模型文件不存在：{mp}"}
        if not req.feature_excel or not os.path.exists(req.feature_excel):
            return {"success": False, "message": "请提供有效的特征数据 Excel 路径"}
        if not req.real_excel or not os.path.exists(req.real_excel):
            return {"success": False, "message": "请提供有效的真实功率 Excel 路径"}
        try:
            req2 = req.model_copy(update={"model_path": mp or req.model_path})
            return _predict_with_existing_model(req2)
        except Exception as e:
            return {"success": False, "message": f"预测失败：{e}"}

    # ── 模式 2：使用服务缓存模型 ─────────────────────────────────────────
    if not os.path.exists(MODEL_H5):
        return {"success": False, "message": "模型不存在，请先训练或指定 model_path"}
    if _status["is_training"]:
        return {"success": False, "message": "模型训练中，请稍后预测"}
    try:
        sy    = joblib.load(SCALER_Y)
        model = load_model_h5(MODEL_H5)
        data  = np.load(CACHE_NPZ)

        X_seq      = data["X_seq"]
        y_true_all = data["y_true_all"]
        split      = int(data["split"][0])

        X_test  = X_seq[split:]
        y_test  = y_true_all[split:]
        length  = min(req.predict_length, len(X_test))
        if req.predict_start_index < 0:
            start = max(0, len(X_test) - length)
        else:
            start = max(0, min(req.predict_start_index, len(X_test) - length))

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
