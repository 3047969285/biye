import os
import numpy as np
import pandas as pd
import tensorflow as tf
from sklearn.preprocessing import MinMaxScaler
from tensorflow.keras.layers import Dropout, Dense, GRU, Input

_BASE = os.path.dirname(os.path.abspath(__file__))


def load_data():
    data1 = pd.read_excel(os.path.join(_BASE, 'FD001.xlsx'))
    data2 = pd.read_excel(os.path.join(_BASE, 'FD001_real.xlsx'))
    data = data1.iloc[:, data1.columns.get_indexer(['30米处风速', '50米处风速', '70米处风速', '风机轮毂处风速'])]
    data['power'] = data2.iloc[:, 1:].values
    data = data.values

    data_30min = []
    data_60min = []

    for i in range(int(len(data)/2)):
        data_30min.append(data[i*2])
    for i in range(int(len(data)/4)):
        data_60min.append(data[i*4])
    data_15min, data_30min, data_60min = pd.DataFrame(data), pd.DataFrame(data_30min), pd.DataFrame(data_60min)
    return data_15min, data_30min, data_60min


data = load_data()[0]

x_train_set = data.iloc[0:data.values.shape[0] - 2976, :].values
x_test_set  = data.iloc[data.values.shape[0] - 2976:, :].values
y_train_set = data.iloc[0:data.values.shape[0] - 2976, 4:].values
y_test_set  = data.iloc[data.values.shape[0] - 2976:, 4:].values

# 归一化
sc = MinMaxScaler(feature_range=(0, 1))
x_train_set = sc.fit_transform(x_train_set)
x_test_set  = sc.fit_transform(x_test_set)
y_train_set = sc.fit_transform(y_train_set)
y_test_set  = sc.fit_transform(y_test_set)

time_step = 30
input_dims = 5

x_train, y_train = [], []
x_test,  y_test  = [], []

for i in range(time_step, len(x_train_set)):
    x_train.append(x_train_set[i - time_step:i])
    y_train.append(y_train_set[i])

# 打乱训练集
np.random.seed(7)
np.random.shuffle(x_train)
np.random.seed(7)
np.random.shuffle(y_train)
tf.random.set_seed(7)

x_train, y_train = np.array(x_train), np.array(y_train)
x_train = np.reshape(x_train, (x_train.shape[0], time_step, input_dims))

for i in range(time_step, len(x_test_set)):
    x_test.append(x_test_set[i - time_step:i])
    y_test.append(y_test_set[i])

x_test, y_test = np.array(x_test), np.array(y_test)
x_test = np.reshape(x_test, (x_test.shape[0], time_step, input_dims))

# 构建 GRU 模型
model = tf.keras.Sequential([
    Input(shape=(time_step, input_dims)),
    GRU(16, return_sequences=True),
    Dropout(0.2),
    GRU(8),
    Dense(1)
])

model.compile(optimizer=tf.keras.optimizers.Adam(0.001),
              loss='mean_squared_error')

history = model.fit(x_train, y_train,
                    batch_size=64,
                    epochs=100,
                    validation_data=(x_test, y_test),
                    validation_freq=1)

model.summary()

import os
os.makedirs('./model', exist_ok=True)
model.save('./model/gru_FD.h5')
print('模型已保存到 ./model/gru_FD.h5')