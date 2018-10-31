import numpy as np
import matplotlib.pyplot as plt
from wordcloud import WordCloud

for j in range(169, 300) :
    f1 = open("C:/primes/data/final340numclusters/clust_" + str(j) + ".txt", 'r')
    
    texts = f1.readlines()
    text = ""
    for t in texts :
        text = text + " " + t
    x, y = np.ogrid[:1800, :1800]
    
    mask = abs((x - 900)) + abs((y - 900)) > 900 ** 2
    mask = 255 * mask.astype(int)
    
    
    wc = WordCloud(background_color="grey", repeat=True, mask=mask)
    wc.generate(text)
    
    plt.axis("off")
    plt.imshow(wc, interpolation="bilinear")
    plt.savefig("C:/primes/data/biggerclouds/cloud_" + str(j) + ".png", bbox_inches='tight')