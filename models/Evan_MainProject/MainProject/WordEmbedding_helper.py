import pandas as pd
import numpy as np
from DataCleaning_main import *
from sklearn.feature_extraction.text import CountVectorizer


def get_corpus(filepath, corpus_elements=None):
    if ".txt" in filepath:  # this is a saved corpus
        corpus = open(filepath, "r").readlines()
        return corpus
    elif ".csv" in filepath:  # this is a dataframe to be converted to a corpus
        data = pd.read_csv(filepath)
        if not corpus_elements:
            raise ValueError("No Corpus elements given")
        else:
            corpus = [" ".join(row[column] for column in corpus_elements) for r, row in data.iterrows()]
            return corpus
    else:
        raise ValueError("Filename not given")


def vector_concatenate(list_of_vectors):
    '''

    :param list_of_vectors: a list of vectors to be concantenated into one vector
    :return: the vectors concatenated using *some* function.
    '''
    assert isinstance(list_of_vectors, list)
    assert len(list_of_vectors) > 0
    assert list_of_vectors[0].shape[0] == 1

    num_cols = list_of_vectors[0].shape[1]

    #Hadamard
    final_vector = np.ones((1, num_cols))
    for v in list_of_vectors:
        final_vector = np.multiply(final_vector, v)
    '''
    # Average
    final_vector = np.zeros((1, num_cols))
    for v in list_of_vectors:
        final_vector += v
    
    final_vector = final_vector/len(list_of_vectors)
    '''
    return final_vector


def get_word2index(corpus):
    count_model = CountVectorizer(ngram_range=(1, 1))
    count_model.fit_transform(corpus)  # X comes in later in case we make our own dict from this corpus
    word2index = count_model.vocabulary_
    return word2index


def get_test_train_corpi(parameters):
    train_corpus = get_corpus("DataCleaning_Files/train_data.csv", corpus_elements=parameters)
    test_corpus = get_corpus("DataCleaning_Files/test_data.csv", corpus_elements=parameters)
    return train_corpus, test_corpus



