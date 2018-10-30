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

data = pd.read_csv("cleanedsmplinds.csv", sep = ",", quoting = 1, quotechar = '"')
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

nb_clust = 300

vectorizer = TfidfVectorizer(max_df=0.5, max_features=10000, min_df=2, stop_words='english', use_idf=True)
X = vectorizer.fit_transform(dataset)
print(X.shape)

km = KMeans(n_clusters=nb_clust, init='k-means++', max_iter=100, random_state=1337, n_init=1,verbose=True)
km.fit(X)

data2 = pd.read_csv("cleansmplinds.csv", sep = ",", quoting = 1, quotechar = '"')
data2 = np.array(data2)

cluster_map = pd.DataFrame()

cluster_map['cluster'] = km.labels_

for x in range(nb_clust) :
	f1 = open('./willclusters/clust_' + str(x) + '.txt', 'a')
	y = cluster_map[cluster_map.cluster == x]['cluster'].index
	for n in y :
		f1.write(data2[n][2])
		f1.write("Xx_NEWLINE_xX")

f2 = open('./willclusters/centers.txt', 'a')
centers = km.cluster_centers_.argsort()[:, ::-1]
terms = vectorizer.get_feature_names()
for i in range(nb_clust):
	f2.write("Cluster %d:" % i)
	for ind in centers[i, :10]:
		f2.write(' %s' % terms[ind])
	f2.write("Xx_NEWLINE_xX")

