from gensim.models import Word2Vec
from WordEmbedding_helper import *
import numpy as np

vector_size = 300


def get_cbow_model(corpus):
    '''

    :return: a CBOW trained model of the pdr and drugbank data with size vector_size
    '''
    assert isinstance(corpus, list)
    print("Training CBOW")
    corpus = [line.split() for line in corpus]
    model = Word2Vec(corpus, sg=0, min_count=1, size=vector_size)  # min count = 1 so that we get every drug, may wanna change for indicaiton
    return model.wv


def get_skip_gram_model(corpus):
    '''

    :return: a SG trained model of the pdr and drugbank data with size vector_size
    '''
    assert isinstance(corpus, list)
    print("Training Skip-Gram")
    corpus = [line.split() for line in corpus]
    model = Word2Vec(corpus, sg=1, min_count=1, size=vector_size)  # min count = 1 so that we get every drug
    return model.wv


def get_vectorized_data(model, corpus):
    '''

    :param corpus: a list of strings
    :param model: Word2vec.wv model
    :param sg: a boolean value explaining whether to use the skip-gram model
    :return: an rxn np.array, the vectorized rows of the series.
    '''
    assert isinstance(corpus, list)
    vectors = []
    for row in corpus:
        row = row.split()
        vector_list = []
        for word in row:
            vector_list.append(model[word].reshape((1, model.vector_size)))
        vector = vector_concatenate(vector_list)
        vectors.append(vector)
    return np.concatenate(vectors)


# Not used
def __vectorize_and_save(list_of_dataframes, list_of_names):
    '''

    :param list_of_dataframes: a list of dataframes to be vectorized and saved. MUST HAVE AN INDICATION COLUMN
    :param list_of_names: a list of names to identify the saved dataframes
    :return: None
    '''
    for index, df in enumerate(list_of_dataframes):
        np.save(list_of_names[index]+"_INPUT_"+"CBOW", get_vectorized_data(0, df["Indication"]))
        np.save(list_of_names[index]+"_INPUT_"+"SG", get_vectorized_data(1, df["Indication"]))
        one_hot = [item for i, item in df["One_Hot"].iteritems()]
        one_hot = np.concatenate(one_hot)
        np.save(list_of_names[index]+"_OUTPUT_ONE_HOT", one_hot)


if __name__ == "__main__":
    # Get training corpus
    corpus = get_corpus(
        "/Users/EvanVogelbaum/RSI/Alterovitz Lab/MainProject/Embedding_Files/macro_indication_corpus.txt")
    cbow = get_cbow_model(corpus)
    sg = get_skip_gram_model(corpus)

    train_corpus = get_corpus("/Users/EvanVogelbaum/RSI/Alterovitz Lab/MainProject/Embedding_Files/macro_train_corpus.txt")
    test_corpus = get_corpus("/Users/EvanVogelbaum/RSI/Alterovitz Lab/MainProject/Embedding_Files/macro_test_corpus.txt")
    # get vectorizations
    cbow_train_vectorized = get_vectorized_data(cbow, train_corpus)
    cbow_test_vectorized = get_vectorized_data(cbow, test_corpus)

    sg_train_vectorized = get_vectorized_data(sg, train_corpus)
    sg_test_vectorized = get_vectorized_data(sg, test_corpus)

    # save the vectorizations
    np.save("Embedding_Files/Macro_Indication_corpus_CBOW_train.npy", cbow_train_vectorized)
    np.save("Embedding_Files/Macro_Indication_corpus_CBOW_test.npy", cbow_test_vectorized)

    np.save("Embedding_Files/Macro_Indication_corpus_SG_train.npy", sg_train_vectorized)
    np.save("Embedding_Files/Macro_Indication_corpus_SG_test.npy", sg_test_vectorized)



    '''
    # code for regular embedding
    corpus = get_corpus("Embedding_Files/Indication_corpus.txt")
    train_corpus, test_corpus = get_test_train_corpi(parameters=["Indication"])

    cbow = get_cbow_model(corpus)
    sg = get_skip_gram_model(corpus)

    np.save("Embedding_Files/Indication_Corpus_CBOW_train.npy", get_vectorized_data(cbow, train_corpus))
    np.save("Embedding_Files/Indication_Corpus_sg_train.npy", get_vectorized_data(sg, train_corpus))

    np.save("Embedding_Files/Indication_Corpus_CBOW_test.npy", get_vectorized_data(cbow, test_corpus))
    np.save("Embedding_Files/Indication_Corpus_SG_test.npy", get_vectorized_data(cbow, test_corpus))
'''

