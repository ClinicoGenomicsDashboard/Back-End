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


km = AffinityPropagation(verbose=True).fit(X)

f2 = open('./centerclusters/centers.txt', 'a')
centers = km.cluster_centers_
terms = vectorizer.get_feature_names()
for i in range(centers.shape[0]):
        f2.write("Cluster %d:" % i)
        for ind in centers[i, :10]:
                f2.write(' %s' % terms[ind[0]])
        f2.write("\n")

