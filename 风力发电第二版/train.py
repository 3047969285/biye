"""
风电功率 GRU 离线训练脚本。
读取 FD001.xlsx（风速特征）和 FD001_real.xlsx（真实功率），
训练 GRU 模型并导出 gru_FD.h5，供 predict.py 推理服务加载。

用法：python train.py
输出：model/gru_FD.h5
"""

import os
import numpy as np
import pandas as pd
import tensorflow as tf
from sklearn.preprocessing import MinMaxScaler
from tensorflow.keras.layers import GRU, Dense, Dropout, Input

# ── 常量 ──────────────────────────────────────────────────────────────────
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_DIR = os.path.join(BASE_DIR, "model")

# 风速特征列（与 predict.py WIND_SPEED_COLS_FD 保持一致）
WIND_COLS = ["30米处风速", "50米处风速", "70米处风速", "风机轮毂处风速"]

TIME_STEP = 30          # 滑窗步数（用过去 30 个时刻预测下一时刻）
INPUT_DIMS = 5          # 4 风速 + 1 功率 = 5 维特征
EPOCHS = 100
BATCH_SIZE = 64
LEARNING_RATE = 0.001
TEST_SAMPLES = 2976     # 测试集样本数（按序列长度切分）


def load_data():
    """加载特征表与实测表，按列名提取 [4 风速 + 功率] 矩阵。"""
    feat = pd.read_excel(os.path.join(BASE_DIR, "FD001.xlsx"))
    real = pd.read_excel(os.path.join(BASE_DIR, "FD001_real.xlsx"))

    winds = feat.loc[:, WIND_COLS]
    power = real.iloc[:, 1:]  # 首列为时间，取第二列起为功率

    # 拼接为 (N, 5) 矩阵
    data = winds.copy()
    data["power"] = power.values
    return data.values


def build_sequences(x_data, y_data, time_step):
    """滑动窗口构建监督样本。"""
    xs, ys = [], []
    for i in range(time_step, len(x_data)):
        xs.append(x_data[i - time_step:i])
        ys.append(y_data[i])
    return np.array(xs), np.array(ys)


def build_model(time_step, input_dims):
    """构建双层 GRU 回归模型。"""
    model = tf.keras.Sequential([
        Input(shape=(time_step, input_dims)),
        GRU(16, return_sequences=True),
        Dropout(0.2),
        GRU(8),
        Dense(1),
    ])
    model.compile(
        optimizer=tf.keras.optimizers.Adam(LEARNING_RATE),
        loss="mean_squared_error",
    )
    return model


def main():
    # 1. 加载数据
    data = load_data()
    total_rows = data.shape[0]
    train_size = total_rows - TEST_SAMPLES

    x_all = data[:, :]
    y_all = data[:, 4:]  # 第 5 列为功率

    # 2. 归一化
    sc_x = MinMaxScaler(feature_range=(0, 1))
    sc_y = MinMaxScaler(feature_range=(0, 1))
    x_all = sc_x.fit_transform(x_all)
    y_all = sc_y.fit_transform(y_all)

    # 3. 按固定样本数切分训练/测试集
    x_train_raw = x_all[:train_size]
    y_train_raw = y_all[:train_size]
    x_test_raw = x_all[train_size:]
    y_test_raw = y_all[train_size:]

    # 4. 构造序列
    x_train, y_train = build_sequences(x_train_raw, y_train_raw, TIME_STEP)
    x_test, y_test = build_sequences(x_test_raw, y_test_raw, TIME_STEP)

    # 统一 shuffle 训练集
    rng = np.random.RandomState(7)
    idx = rng.permutation(len(x_train))
    x_train, y_train = x_train[idx], y_train[idx]

    # 5. 构建并训练模型
    model = build_model(TIME_STEP, INPUT_DIMS)
    model.summary()

    model.fit(
        x_train, y_train,
        batch_size=BATCH_SIZE,
        epochs=EPOCHS,
        validation_data=(x_test, y_test),
        validation_freq=1,
    )

    # 6. 导出模型
    os.makedirs(MODEL_DIR, exist_ok=True)
    save_path = os.path.join(MODEL_DIR, "gru_FD.h5")
    model.save(save_path)
    print(f"模型已保存到 {save_path}")


if __name__ == "__main__":
    main()
