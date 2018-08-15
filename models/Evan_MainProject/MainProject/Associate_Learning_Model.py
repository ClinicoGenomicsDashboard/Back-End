from apyori import apriori
import pandas as pd

data = pd.read_csv("DataCleaning_Files/macro_cat_data.csv")  # get full data
categories = set(data["Macro_Category"])  # get category data
train, test = pd.read_csv("DataCleaning_Files/macro_train_set.csv"), \
              pd.read_csv("DataCleaning_Files/macro_train_set.csv")  # get train and test data

train_transactions = [row["Indication"].split() + [row["Macro_Category"]] for r, row in train.iterrows()]  # get transactions

print("Running Apriori")
results = list(apriori(train_transactions))  # get the results

print("Creating Rule map")
rule_map = {rule.items_base: (rule.items_add, rule.confidence, row.support) for row in results
            for rule in row.ordered_statistics
            if rule.items_add.issubset(categories)}  # get a map for rules -> categories

# Test the accuracy
print("Testing Accuracy")
num_right = 0.00
num_thrown = 0.00
for r, row in test.iterrows():
    indication = set(row["Indication"].split())
    possible_cats = []
    for rule in rule_map.keys():
        if rule.issubset(indication):
            cat, conf, sup = rule_map[rule]
            cat, = cat
            possible_cats.append((cat, conf, sup))

    possible_cats = sorted(possible_cats, key=lambda x: x[1], reverse=True)
    if not possible_cats:
        num_thrown += 1
        continue
    selected = possible_cats[0][0]
    if selected == row["Macro_Category"]:
        num_right += 1
print("Unrulable: %i is %.3f %% of the data" % (num_thrown, 100*num_thrown/len(test)))
print("Accuracy: %.3f" % (num_right/(len(test)-num_thrown)), "Unrulable: %i" % num_thrown)
