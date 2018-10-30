from __future__ import print_function
from sklearn.decomposition import TruncatedSVD
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.feature_extraction.text import HashingVectorizer
from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.preprocessing import Normalizer
from sklearn import metrics

from sklearn.cluster import KMeans, MiniBatchKMeans, AffinityPropagation

import logging
import sys
from time import time

import numpy as np
import pandas as pd

data = pd.read_csv("cleancenters.txt", sep = ",", quoting = 1, quotechar = '"')
dataset = []
data = np.array(data)
for x in data :
	string = ""
	for y in x :
		string = y
	dataset.append(string)

vectorizer = TfidfVectorizer(max_df=0.5, max_features=10000, min_df=2, stop_words='english', use_idf=True)
X = vectorizer.fit_transform(dataset)
print(X.shape)

Ks = range(1, 300, 10)

km = [KMeans(n_clusters=i, init='k-means++', max_iter=300, n_init=1,verbose=True) for i in Ks]
score = [km[i].fit(X).score(X) for i in range(len(km))]

f1 = open("./elbowcentersv2.txt", "a")
for x in range(len(score)) :
	f1.write(str(Ks[x]) + "\t" + str(score[x]) + "\n")

