from DataCleaning_main import get_merged_data
import numpy as np

data = get_merged_data()
s = set(data["Drug"])
num_drugs = len(s)


def get_one_hot_dict():
    cnt = 0
    one_hot_dict = {}
    for drug in s:
        hot = np.zeros(num_drugs)
        hot[cnt] = 1
        cnt += 1
        one_hot_dict[drug] = hot
    return one_hot_dict


def get_one_hot_labels():
    one_hot_dict = get_one_hot_dict()
    lst = [one_hot_dict[drug] for drug in data["Drug"]]
    labels = np.stack(lst, axis=0)
    return labels


print(get_one_hot_labels().shape)