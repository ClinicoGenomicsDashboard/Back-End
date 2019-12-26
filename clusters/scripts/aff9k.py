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

data = pd.read_csv("cleanctrpinds.csv", sep = ",", quoting = 1, quotechar = '"')
dataset = []
data = np.array(data)
for x in data :
	count = 0
	placeholder = ""
	for y in x :
		if (count == 1) :
			placeholder = y + "";
		elif (count == 2) :
			if y == True :
				dataset.append(str(1) + " " + placeholder)
			else :
				dataset.append(str(0) + " " + placeholder)
		count=count+1

nb_clust = 5000

vectorizer = TfidfVectorizer(max_df=0.5, max_features=10000, min_df=2, stop_words='english', use_idf=True)
X = vectorizer.fit_transform(dataset)
print(X.shape)

km = AffinityPropagation(verbose=True).fit(X)

f2 = open('./clust9kaff/centers.txt', 'a')
centers = km.cluster_centers_
terms = vectorizer.get_feature_names()
for i in range(centers.shape[0]):
        f2.write("Cluster %d:" % i)
        for ind in centers[i]:
                indi = [list(line.nonzero()[1]) for line in ind]
                for k in indi[0] :
                        f2.write(' %s' % terms[k])
        f2.write("\n")

cluster_map = pd.DataFrame()

cluster_map['cluster'] = km.labels_

for x in range(centers.shape[0]) :
        f1 = open('./clust9kaff/clust_' + str(x) + '.txt', 'a')
        y = cluster_map[cluster_map.cluster == x]['cluster'].index
        for n in y :
                f1.write(data[n])

