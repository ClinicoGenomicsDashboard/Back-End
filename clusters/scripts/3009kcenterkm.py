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

data = open("clean3009kcenters.txt", 'r').readlines()
dataset = []
data = np.array(data)
for x in data :
        dataset.append(x[:len(x)-2])

vectorizer = TfidfVectorizer(max_df=0.5, max_features=10000, min_df=2, stop_words='english', use_idf=True)
X = vectorizer.fit_transform(dataset)
print(X.shape)

nb_clust = 60

km = KMeans(n_clusters=nb_clust, random_state=1337, init='k-means++', max_iter=300, n_init=1,verbose=True)
km.fit(X)

f2 = open('./center3009kclusters/centers.txt', 'a')
centers = km.cluster_centers_.argsort()[:, ::-1]
terms = vectorizer.get_feature_names()
for i in range(nb_clust):
        f2.write("Cluster %d:" % i)
        for ind in centers[i, :10]:
                f2.write(' %s' % terms[ind])
        f2.write("\n")

cluster_map = pd.DataFrame()

cluster_map['cluster'] = km.labels_

for x in range(nb_clust) :
        f1 = open('./center3009kclusters/clust_' + str(x) + '.txt', 'a')
        y = cluster_map[cluster_map.cluster == x]['cluster'].index
        for n in y :
                f1.write(data[n])
