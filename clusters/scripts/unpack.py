import re
for x in range(300) :
	with open ("./willclusters/clust_" + str(x) + ".csv") as f :
		content = f.readline()
		newlines = [m.start() for m in re.finditer('Xx_NEWLINE_xX', content)]
		f1 = open("./unpackedclusters/clust_" + str(x) + ".csv", 'w+')
		last = 0
		for c in range(len(content)):
			tmpinc = True
			include = True
			for i in range(c-14, c-1) :
				if i in newlines :
					tmpinc = False
			if not tmpinc and (last == 0 or last >= 13) :
				last = 0
				include = False
			elif tmpinc :
				last = last + 1
			if include :
				f1.write(content[c])
			else :
				f1.write("\n")
