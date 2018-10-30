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

data = pd.read_csv("cleansmplinds.csv", sep = ",", quoting = 1, quotechar = '"')
dataset = []
data = np.array(data)
for x in data :
	count = 0
	placeholder = ""
	for y in x :
		if (count == 2) :
			placeholder = y + "";
		elif (count == 3) :
			if y == True :
				dataset.append(str(1) + " " + placeholder)
			else :
				dataset.append(str(0) + " " + placeholder)
		count=count+1

nb_clust = 100

vectorizer = TfidfVectorizer(max_df=0.5, max_features=10000, min_df=2, stop_words='english', use_idf=True)
X = vectorizer.fit_transform(dataset)
print(X.shape)

km = KMeans(n_clusters=nb_clust, init='k-means++', max_iter=100, n_init=1,verbose=False)
km.fit(X)

print("Top terms per cluster:")
order_centroids = km.cluster_centers_.argsort()[:, ::-1]
terms = vectorizer.get_feature_names()
for i in range(nb_clust):
    print("Cluster %d:" % i, end='')
    for ind in order_centroids[i, :10]:
        print(' %s' % terms[ind], end='')
print()

#use elbow method to determine number of clusters
