from apyori import apriori
from sklearn.datasets import load_digits

data, target = load_digits()['data'], load_digits()['target']  # load mnist data

database = []
for index, row in enumerate(data):
    new_data = []
    for num, value in enumerate(row):
        if not value == 0: value = 1  # One - hot data (just to try it)
        new_data.append("Pixel: "+str(num)+" Value: "+str(value))
        # To Try:
        #new_data.append(("P"+str(num), value))
    new_data.append( str(target[index]))
    database.append(new_data)



a = apriori(database)

'''
By formatting the Releation record as a string I can format it to a sortable environment

'''

