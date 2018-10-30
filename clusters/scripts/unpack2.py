import string
for x in range(300) :
	f = open("./willclusters/clust_" + str(x) + ".txt", 'r')
	contents = f.readlines()
	for content in contents :
		f1 = open("./unpackedclusters/clust_" + str(x) + ".txt", 'w+')
		f1.write(content.replace("Xx_NEWLINE_xX", "\n"))
