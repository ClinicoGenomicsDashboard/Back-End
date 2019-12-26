import string
f = open("./plateletall.csv", 'r')
contents = f.readlines()
for content in contents :
	f1 = open("./plateletall.csv", 'w+')
	f1.write(content.replace("Xx_NEWLINE_xX", "\n"))
