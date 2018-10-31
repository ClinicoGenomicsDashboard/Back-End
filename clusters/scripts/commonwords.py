from nltk import PorterStemmer
for x in range(300) :
    fin = open("C:/primes/data/unpackedclusters/clust_" + str(x) + ".txt", 'r')
    fout = open("C:/primes/data/commonwords/words_" + str(x) + ".txt", 'w+')
    lines = fin.readlines()
    wordmap = {}
    stemtoword = {}
    letters = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','-']
    for line in lines :
        l = line.lower()
        word = ""
        for x in l :
            if x in letters :
                word = word + x
            elif (not (word == "")) and (not (word == " ")):
                stem = PorterStemmer().stem(word)
                stemtoword[stem] = word
                if stem in wordmap :
                    wordmap[stem] = wordmap[stem] + 1
                else :
                    wordmap[stem] = 1
                word = ""
        stem = PorterStemmer().stem(word)
        stemtoword[stem] = word
        if stem in wordmap :
            wordmap[stem] = wordmap[stem] + 1
        else :
            wordmap[stem] = 1
    for x in wordmap :
        fout.write(str(stemtoword[x]) + " " + str(wordmap[x]) + "\n")
    fin.close()
    fout.close()