from __future__ import print_function
from sklearn.decomposition import TruncatedSVD
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.feature_extraction.text import HashingVectorizer
from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.preprocessing import Normalizer
from sklearn import metrics

from sklearn.cluster import KMeans, MiniBatchKMeans

import logging
import sys
from time import time

import numpy as np
import pandas as pd

#data = pd.read_csv("cleansmplinds.csv", sep = ",", quoting = 1, quotechar = '"')
data = open("plateletbeforechangeto.csv").readlines()
dataset = []
data = np.array(data)
for x in data :
	dataset.append(x)

vectorizer = TfidfVectorizer(max_df=0.5, max_features=10000, min_df=2, stop_words='english', use_idf=True)
X = vectorizer.fit_transform(dataset)
print(X.shape)

Ks = range(1, len(dataset), 2)

km = [KMeans(n_clusters=i, random_state=1337, init='k-means++', max_iter=300, n_init=1,verbose=True) for i in Ks]
score = [km[i].fit(X).score(X) for i in range(len(km))]

f1 = open("./elbowplateletpre.txt", "a")
for x in range(len(score)) :
	f1.write(str(score[x]) + "\n")

