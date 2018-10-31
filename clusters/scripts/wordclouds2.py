import matplotlib.pyplot as plt
from wordcloud import WordCloud

for j in [5, 10, 54, 56, 65, 91, 143, 232, 243] :
    f1 = open("C:/Users/Neil Malur/Downloads/platelets-20181031T164756Z-001/platelets/platelet-clust_" + str(j) + ".txt", 'r')
    
    texts = f1.readlines()
    text = ""
    for t in texts :
        text = text + " " + t
    wordcloud = WordCloud().generate(text)
    plt.axis("off")
    plt.imshow(wordcloud, interpolation="bilinear")
    plt.savefig("C:/primes/data/megaclouds/cloud_" + str(j) + ".pdf", bbox_inches='tight')
    
f1 = open("C:/Users/Neil Malur/Downloads/platelets-20181031T164756Z-001/platelets/platelet-clust_all.txt", 'r')

texts = f1.readlines()
text = ""
for t in texts :
    text = text + " " + t
wordcloud = WordCloud().generate(text)
plt.axis("off")
plt.imshow(wordcloud, interpolation="bilinear")
plt.savefig("C:/primes/data/megaclouds/cloud_all.pdf", bbox_inches='tight')