from DataCleaning_helpers import *


def get_full_data(load=True, load_path="DataCleaning_Files/full_data.csv",
                  save=False, save_path="DataCleaning_Files/full_data.csv",
                  one_hot_column=True, remove_single_occ=True, remove_unmapped=False):
    '''
    :type remove_unmapped: bool
    :type load: bool
    :type save: bool
    :type save_path: str
    :type load_path: str
    :type one_hot_column: bool
    :type remove_single_occ: bool
    :return: returns all drugbank and optional other parameters added
    and with single occurences removed
    '''
    if load:
        try:
            return pd.read_csv(load_path)
        except FileNotFoundError:
            raise ValueError('No data found in load path')
    print("Creating full data")
    data = get_merged_data()
    if one_hot_column:
        data = add_one_hot_column(data)
    if remove_single_occ:
        data = remove_single_occurrence_cats(data)
    if remove_unmapped:
       data = remove_unmapped_cats(data)
    if save:
        data.to_csv(save_path, index=False)
    return data


def get_test_train_split(load=True, train_load_path="DataCleaning_Files/train_data.csv",
                         test_load_path="DataCleaning_Files/test_data.csv",
                         save=False, train_save_path="DataCleaning_Files/train_data.csv",
                         test_save_path="DataCleaning_Files/test_data.csv",
                         data=None):
    '''
    :type load: bool
    :type save: bool
    :type train_save_path: str
    :type test_save_path: str
    :type train_load_path: str
    :type test_load_path: str
    :type data: pd.Dataframe
    :return: train_data, test_data
    test_data consists of data where each data point has 1 unique category
    train_data contains the remainder
    '''
    if load:
        try:
            return pd.read_csv(train_load_path), pd.read_csv(test_load_path)
        except FileNotFoundError:
            raise ValueError('No data found in load path')
    if data is None:
        print("loading full data")
        data = get_full_data()
    assert isinstance(data, pd.DataFrame) and "Category" in data.columns
    cats_seen = set()
    test_rows = []
    for r, row in data.iterrows():
        if row["Category"] not in cats_seen:
            cats_seen.add(row["Category"])
            test_rows.append(r)
    test_set = data.iloc[test_rows]
    train_set = data.drop(test_rows)
    if save:
        train_set.to_csv(train_save_path, index=False)
        test_set.to_csv(test_save_path, index=False)
    return train_set, test_set





