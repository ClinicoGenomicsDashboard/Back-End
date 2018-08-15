from tensorflow import keras
import tensorflow as tf
import numpy as np
from sklearn.model_selection import train_test_split


train_x, train_y, test_x, test_y = np.load("Embedding_Files/cui2vec_train_set.npy"), \
                                   np.load("Macro_train_output_one_hot.npy"), \
                                   np.load("Embedding_Files/cui2vec_test_set.npy"), \
                                   np.load("Macro_test_output_one_hot.npy")

model = keras.Sequential()
num_input_cols = train_x.shape[1]
for i in range(3):
    model.add(keras.layers.Dense(100, activation="sigmoid"))
model.add(keras.layers.Dense(test_y.shape[1], activation="softmax"))

model.compile(optimizer=tf.train.AdamOptimizer(0.0001),
              loss='categorical_crossentropy',
              metrics=['accuracy'])

model.fit(train_x, train_y)

print(model.predict(test_x))

print(model.evaluate(test_x, test_y), model.metrics_names)