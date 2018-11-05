import matplotlib.pyplot as plt
from wordcloud import WordCloud

text = ""

for j in range(300) :
    f1 = open("C:/primes/data/final340numclusters/clust_" + str(j) + ".txt", 'r')
    
    texts = f1.readlines()
    for t in texts :
        text = text + " " + t

wordcloud = WordCloud().generate(text)
plt.axis("off")
plt.imshow(wordcloud, interpolation="bilinear")
plt.savefig("C:/primes/data/pptclouds/cloud_all.png", bbox_inches='tight')

f1.close()