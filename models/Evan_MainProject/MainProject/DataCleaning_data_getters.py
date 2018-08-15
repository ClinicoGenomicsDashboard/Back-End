import pandas as pd
import re


def get_clean_pdr_data(load=True, load_path="DataCleaning_Files/[CLEAN] pdr_data.csv",
                       save=True, save_path="DataCleaning_Files/[CLEAN] pdr_data.csv"):
    '''

    :return: a Pandas dataframe with columns CUI, DRUG, and Indication with blanks rows dropped
    and indications stripped, regexed, and lowered
    '''
    if load:
        try:
            return pd.read_csv(load_path)
        except FileNotFoundError:
            raise ValueError('No data found in load path')
    print("Cleaning pdr data")
    pdr_data = pd.read_csv(r"DataCleaning_Files/[RAW] pdr_data.csv", header=None).drop(
        columns=range(3, 35)).rename(columns={0: "CUI", 1: "Drug", 2: "Indication"})  # remove bad columns and rename
    pdr_data = pdr_data.drop([r for r in range(len(pdr_data))
                              if not isinstance(pdr_data.at[r, "Indication"], str)]).reset_index(drop=True)  # no blanks
    pdr_data = pdr_data.drop_duplicates()  # remove duplicate rows

    for index, row in pdr_data.iterrows():
        drug = re.sub(r'([^\s\w]|_)+', '', row.at["Drug"]).lower()  # Remove non alpha numerics and lowercase it
        indication = re.sub(r'([^\s\w]|_)+', '', row.at["Indication"]).lower()  # Keeps text of notes
        indication = re.sub('\s+', ' ', indication).strip()  # Strip all spaces larger than 1
        pdr_data.at[index, "Drug"] = drug
        pdr_data.at[index, "Indication"] = indication
    if save:
        pdr_data.to_csv(save_path, index=False)
    return pdr_data


def get_clean_db_data(load=True, load_path="DataCleaning_Files/[CLEAN] db_data.csv",
                      save=True, save_path="DataCleaning_Files/[CLEAN] db_data.csv"):
    '''

    :return: a Pandas dataframe with columns CUI, DRUG, and Indication with blanks rows dropped
    and indications stripped, regexed, and lowered
    '''
    if load:
        try:
            return pd.read_csv(load_path)
        except FileNotFoundError:
            raise ValueError('No data found in load path')
    print("Cleaning db data")
    db_data = pd.read_csv(r"DataCleaning_Files/[RAW] db_data.csv", header=None).rename(columns = {0: "CUI",1: "Drug", 2: "Indication"})

    db_data = db_data.drop([r for r in range(len(db_data))
                            if not isinstance(db_data.at[r, "Indication"], str)]).reset_index(drop=True)
    db_data = db_data.drop_duplicates()  # Remove duplicate rows

    for index, row in db_data.iterrows():
        drug = re.sub(r'([^\s\w]|_)+', '', row.at["Drug"]).lower()  # Remove non alphanumerics and lower
        indication = re.sub(r'([^\s\w]|_)+', '', row.at["Indication"]).lower()  # Remove non alphanumerics and lower
        indication = re.sub('\s+', ' ', indication).strip()  # Strip all spaces larger than 1
        db_data.at[index, "Drug"] = drug
        db_data.at[index, "Indication"] = indication
    if save:
        db_data.to_csv(save_path, index=False)
    return db_data


def get_clean_category_data(load=True, load_path="DataCleaning_Files/[CLEAN] drug_category.csv",
                            save=True, save_path="DataCleaning_Files/[CLEAN] drug_category.csv"):
    if load:
        try:
            return pd.read_csv(load_path)
        except FileNotFoundError:
            raise ValueError('No data found in load path')
    print("Cleaning category data")
    data = pd.read_csv(r"DataCleaning_Files/[RAW] drug_category.csv").rename(columns=
                                                   {'DrugClass_DrugClass_name': "Class",
                                                    'DrugClass_DrugClass_drugNames_name': "Drug",
                                                    "DrugClass_DrugClass_drugNames_generic": "generics"})
    data = data.dropna().reset_index()  # drop blank values
    if save:
        data.to_csv(save_path, index=False)
    return data

