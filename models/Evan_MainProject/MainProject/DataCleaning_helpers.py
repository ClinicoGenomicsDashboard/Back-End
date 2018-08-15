from DataCleaning_data_getters import get_clean_category_data, get_clean_db_data, get_clean_pdr_data
import pandas as pd
import re
import numpy as np
from collections import Counter
import pickle


def get_drug_category_map(load=True, load_path="DataCleaning_Files/drug_category_map.pickle",
                          save=False, save_path="DataCleaning_Files/drug_category_map.pickle"):
    '''

    :return: a dictionary mapping the name of a drug to the class it belongs do
    '''
    if load:
        try:
            return pickle.load(open(load_path, "rb"))
        except FileNotFoundError:
            raise ValueError('No data found in load path')
    print("Creating drug category map")
    drug_map = {}
    data = get_clean_category_data()
    for r, row in data.iterrows():
        cls = row["Class"]

        drug_list = [row["Drug"]]
        generics = row["generics"].replace("generic name: ", "")
        drug_list = drug_list + generics.split("/")
        for d in drug_list:
            d = re.sub(r'([^\s\w]|_)+', '', d).lower()
            drug_map[d] = cls
    if save:
        pickle.dump(drug_map, open(save_path, "wb"))
    return drug_map


def get_merged_data(load=True, load_path="DataCleaning_Files/merged_data.csv",
                    save=False, save_path="DataCleaning_Files/merged_data.csv"):
    '''
    Takes the cleaned drugbank and PDR data and merges them.
    Then uses the category data to place each drug in a category, and adds this as a column.
    Places **unmapped** for those that don't get mapped
    :return: A Pandas dataframe with 5 columns (index and Unnamed: 0 somehow got added) including the cateogry column
    '''
    if load:
        try:
            return pd.read_csv(load_path)
        except FileNotFoundError:
            raise ValueError('No data found in load path')
    print("Merging Data")
    db_data = get_clean_db_data()
    pdr_data = get_clean_pdr_data()
    merged = db_data.append(pdr_data).reset_index()  # Returns merge

    cat_map = get_drug_category_map()

    categories = []
    for r, row in merged.iterrows():
        drug = row["Drug"]
        if drug in cat_map.keys():
            categories.append(cat_map[drug])
        else:
            categories.append("**unmapped**")
    merged = merged.drop(columns=["CUI"])
    merged = merged.assign(Category=pd.Series(categories).values)
    if save:
        print("Saving")
        merged.to_csv(save_path, index=False)
    return merged


def categorical_one_hot_map(data=None, load=True, load_path="DataCleaning_Files/categorical_one_hot_map.pickle",
                            save=False, save_path="DataCleaning_Files/categorical_one_hot_map.pickle"):
    '''

    :return: a dictionary that maps each string category to a 343 size one- hot vector
    '''
    if load:
        try:
            return pickle.load(open(load_path, "rb"))
        except FileNotFoundError:
            raise ValueError('No data found in load path')
    print("Creating categorical one hot map")
    if not data:
        data = get_merged_data()
    categories = set(data["Category"])
    num_cats = len(categories)
    one_hot_map = {}
    cnt = 0
    for cat in categories:
        vector = np.zeros((1, num_cats))
        vector[0, cnt] = 1
        cnt += 1
        one_hot_map[cat] = vector
    if save:
        pickle.dump(one_hot_map, open(save_path, "wb"))
    return one_hot_map


def add_one_hot_column(data):
    '''

    :param data: the Pandas data frame with the string Category column in it
    :return: a Pandas data frame with a one- hot column
    '''
    assert isinstance(data, pd.DataFrame) and "Category" in data.columns
    print("Adding one hot column")
    one_hot_map = categorical_one_hot_map()
    one_hotted = []
    for r, row in data.iterrows():
        cat = row["Category"]
        one_hotted.append(one_hot_map[cat])
    data = data.assign(One_Hot=pd.Series(one_hotted).values)
    return data


def remove_single_occurrence_cats(data):
    '''

    :param data: the dataframe we want to remove categories with only one occurence from
    :return: the dataframe with any rows containing categories that ONLY occur once removed
    '''
    print("Removing single occurrence categories")
    counter = Counter(data["Category"])
    to_keep = [k for k in counter if counter[k] > 1]
    data = data[data["Category"].isin(to_keep)]
    return data


def remove_unmapped_cats(data):
    '''

    :param data: the dataframe we want to remove all rows whose category is **unmapped**
    :return: the same dataframe with all such rows removed
    '''
    print("Removing unmapped categories")
    data = data[data["Category"] != "**unmapped**"].reset_index()
    return data
