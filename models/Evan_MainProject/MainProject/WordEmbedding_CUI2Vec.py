import pandas as pd
import numpy as np
from WordEmbedding_helper import vector_concatenate, get_corpus

def clean_pre_trained_cui2vec():
    cui_data = pd.read_csv(r"../cui2vec_pretrained.csv")
    cleaned = pd.DataFrame(columns=["CUI", "Vector"])

    for r, row in cui_data.iterrows():
        print("Iteration %i, %.3f done" % (r+1, float((r+1))/len(cui_data)))
        CUI = row["Unnamed: 0"]
        vector = []
        for i in range(500):
            vector.append(row["V%i"%(i+1)])
        vector = np.array(vector).reshape((1, 500))
        cleaned = cleaned.append({"CUI": CUI, "Vector": vector}, ignore_index=True)


def add_to_master_map(dataframe):
    assert isinstance(dataframe, pd.DataFrame)
    master_map = pd.read_csv("../master_cui2vec_map.csv")
    cui2vec = pd.read_csv("../cui2vec.csv")
    CUIs = set(cui2vec["CUI"])

    for r, row in dataframe.iterrows():
        print("Iteration %i, %.5f done" % (r+1, float((r+1))/len(dataframe)))
        if row["CUI"] in CUIs:
            vector = cui2vec[cui2vec["CUI"] == row["CUI"]]["Vector"].iloc[0]
            vector = np.array(np.matrix(vector))
            master_map = master_map.append({"Word": row["Word"], "CUI": row["CUI"], "Vector": vector}, ignore_index=True)
    master_map = master_map.drop()
    master_map.to_csv("../master_cui2vec_map.csv")


def cui_vectorize_corpus(corpus):
    master_map = pd.read_csv("Embedding_Files/master_cui2vec_map.csv")
    words = set(master_map["Word"])
    vectorized = []
    for line in corpus:
        line_vector = []
        for word in line.split():
            if word in words:
                vector = master_map[master_map["Word"] == word]["Vector"].iloc[0]
                vector = np.array(np.matrix(vector))
                line_vector.append(vector)
        if len(line_vector) > 0:
            line_vector = vector_concatenate(line_vector)
        else:
            line_vector = np.zeros((1, 500))
        vectorized.append(line_vector)
    vectorized = np.concatenate(vectorized)
    return vectorized


if __name__ == "__main__":
    train_corpus, test_corpus = get_corpus("Embedding_Files/macro_train_corpus.txt"), \
                                get_corpus("Embedding_Files/macro_test_corpus.txt")
    print("Vectorizing Train data")
    train_vectorized = cui_vectorize_corpus(train_corpus)
    print("Vectorizing Test data")
    test_vectorized = cui_vectorize_corpus(test_corpus)
    np.save("Embedding_Files/cui2vec_train_set.npy", train_vectorized)
    np.save("Embedding_Files/cui2vec_test_set.npy", test_vectorized)
