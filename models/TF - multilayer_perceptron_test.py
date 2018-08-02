from sklearn.model_selection import train_test_split
import tensorflow as tf
import numpy as np
import pandas as pd
from sklearn.datasets import load_digits

mnist = load_digits()
save = True
save_directory = "/Users/EvanVogelbaum/RSI/Alterovitz Lab/CBOW saves/"


def make_one_hot(target):
    '''
    :param target: the (r,) consisting of the targets for each row of data for mnist
    :return: an (r,10) array wtih one hot encoded vectors for targets
    '''
    num_rows = target.shape[0]
    r = np.zeros((num_rows, 10))
    for row, value in enumerate(target):
        r[row, value] = 1
    return r


learning_rate = 0.0001

training_epochs = 20000
X = pd.DataFrame(mnist['data'])  # mnist input data
Y = pd.DataFrame(make_one_hot(mnist['target']))  # mnist output data (one - hotted)

train_x, test_x, train_y, test_y = train_test_split(X, Y, test_size=0.1)

assert len(X) == len(Y)  # must have the same number of rows

num_input_nodes = X.shape[1]
num_output_nodes = Y.shape[1]
hidden_layers = [num_input_nodes, 10, 10, num_output_nodes]

holder_X = tf.placeholder("float64", [None, num_input_nodes])
holder_Y = tf.placeholder("float64", [None, num_output_nodes])

weights = {"l" + str(i + 1): tf.Variable(
    tf.random_uniform((hidden_layers[i], hidden_layers[i + 1]), minval=0, maxval=1, dtype=np.float64))
           for i in range(len(hidden_layers) - 1)}

biases = {"l" + str(i): tf.Variable(tf.random_uniform((1, hidden_layers[i]), minval=0, maxval=1, dtype=np.float64))
          for i in range(1, len(hidden_layers))}


# NOTE: we need the same keys for each dictionary.
# Thus, the keys for the weights correspond to the ending layer (0 indexed)


def multilayer_perceptron(data):
    for key in weights.keys():
        data = tf.add(tf.matmul(data, weights[key]), biases[key])
        data = tf.nn.relu(data)
    return data


logits = multilayer_perceptron(holder_X)

loss_operation = tf.reduce_mean(
    tf.nn.softmax_cross_entropy_with_logits_v2(logits=logits, labels=train_y))  # Can change loss opp

optimizer = tf.train.AdamOptimizer(learning_rate=learning_rate)  # Can change optimizer

train_op = optimizer.minimize(loss_operation)

init = tf.global_variables_initializer()
saver = tf.train.Saver()

with tf.Session() as sess:
    sess.run(init)
    # saver.restore(sess, save_directory)

    for epoch in range(training_epochs):
        _, c = sess.run([train_op, loss_operation], feed_dict={holder_X: train_x, holder_Y: train_y})
        avg_cost = c / len(train_x)
        if epoch % 100 == 0:
            print("Epoch:", '%04d' % epoch, "cost={:.9f}".format(avg_cost))
    saver.save(sess, save_directory)
    print("Model Saved")

    pred = tf.nn.softmax(logits)  # Apply softmax to logits
    correct_prediction = tf.equal(tf.argmax(pred, 1), tf.argmax(test_y, 1))
    accuracy = tf.reduce_mean(tf.cast(correct_prediction, "float64"))
    print("Accuracy:", accuracy.eval({holder_X: test_x, holder_Y: test_y}))
