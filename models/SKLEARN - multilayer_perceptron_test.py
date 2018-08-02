from sklearn.neural_network import MLPClassifier
from sklearn.model_selection import train_test_split
import numpy as np

X = np.random.randn(1000, 500)

Y = np.ones()

x_train, x_test, y_train, y_test = train_test_split(X,Y,test_size= 0.1)

classifier = MLPClassifier(activation="logistic", solver="lbfgs",hidden_layer_sizes=(100,100,100))

classifier.fit(x_train,y_train)

