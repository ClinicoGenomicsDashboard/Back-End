import pandas as pd
from DataCleaning_main import get_full_data
import pickle
from WordEmbedding_helper import get_corpus
import numpy as np


def get_super_categories_dict(load=True, load_path="DataCleaning_Files/super_cat_dic.pickle",
                          save=False, save_path="DataCleaning_Files/super_cat_dic.pickle"):
    if load:
        try:
            return pickle.load(open(load_path, "rb"))
        except FileNotFoundError:
            raise ValueError('No data found in load path')
    print("Creating super category map")
    super_cat_map={}
    data = pd.read_csv("DataCleaning_Files/Supercategories.csv")
    for column in data.columns:
        for category in data[column]:
            if isinstance(category, float):
                break
            super_cat_map[category.lower()] = column
    if save:
        pickle.dump(super_cat_map, open(save_path, "wb"))
    return super_cat_map


def add_macro_cats(data):
    assert isinstance(data, pd.DataFrame)
    assert "Category" in data.columns

    super_cat_dic = get_super_categories_dict()
    super_cats = []
    for r, row in data.iterrows():
        try:
            super_cats.append(super_cat_dic[row["Category"].lower()])
        except KeyError:
            super_cats.append("**NO_MACRO_CAT**")
    data = data.assign(Macro_Category=pd.Series(super_cats).values)
    return data


if __name__ == "__main__":

    # Get data
    data = get_full_data()
    data = add_macro_cats(data)
    data = data[data["Macro_Category"] != "**NO_MACRO_CAT**"].reset_index(drop=True)

    data.to_csv("DataCleaning_Files/macro_cat_data.csv", index=False)
    macro_corpus = get_corpus("DataCleaning_Files/macro_cat_data.csv", ["Indication"])
    
    # Write total corpus
    writer = open("Embedding_Files/macro_indication_corpus.txt", "w")
    for line in macro_corpus:
        writer.write(line + "\n")

    writer.close()

    # get one hot dic
    cats = list(set(data["Macro_Category"]))
    one_hots_dic = {}
    for i, e in enumerate(cats):
        one_hot = np.zeros((1, len(cats)))
        one_hot[0, i] = 1
        one_hots_dic[e] = one_hot

    # Test train split
    cats_seen = set()
    test_rows = []
    for r, row in data.iterrows():
        if row["Macro_Category"] not in cats_seen:
            cats_seen.add(row["Macro_Category"])
            test_rows.append(r)
    test_set = data.iloc[test_rows]
    train_set = data.drop(test_rows)

    test_set.to_csv("DataCleaning_Files/macro_test_set.csv")
    train_set.to_csv("DataCleaning_Files/macro_train_set.csv")

    # make test and train corpi
    test_corpus = get_corpus("DataCleaning_Files/macro_test_set.csv", ["Indication"])
    train_corpus = get_corpus("DataCleaning_Files/macro_train_set.csv", ["Indication"])

    writer = open("Embedding_Files/macro_test_corpus.txt", "w")
    for line in test_corpus:
        writer.write(line + "\n")
    writer.close()

    writer = open("Embedding_Files/macro_train_corpus.txt", "w")
    for line in train_corpus:
        writer.write(line + "\n")
    writer.close()

    # make test and train one_hots

    test_one_hot = []
    for r, row in test_set.iterrows():
        test_one_hot.append(one_hots_dic[row["Macro_Category"]])
    train_one_hot = []
    for r, row in train_set.iterrows():
        train_one_hot.append(one_hots_dic[row["Macro_Category"]])

    test_one_hot = np.concatenate(test_one_hot)
    train_one_hot = np.concatenate(train_one_hot)

    np.save("Macro_test_output_one_hot.npy", test_one_hot)
    np.save("Macro_train_output_one_hot.npy", train_one_hot)









