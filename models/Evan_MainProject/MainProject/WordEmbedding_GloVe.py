import pickle
import numpy as np
from WordEmbedding_helper import get_corpus, vector_concatenate, get_word2index, get_test_train_corpi
from sklearn.feature_extraction.text import CountVectorizer
from glove import Glove

glove_train_corpus = get_corpus("Embedding_Files/macro_indication_corpus.txt")
word2index = get_word2index(glove_train_corpus)


def get_co_occurrence_dic(corp_or_file):
    if isinstance(corp_or_file, str):  # this is a loaded file
        co_dict = pickle.load(open(corp_or_file, "rb"))
        return co_dict
    elif isinstance(corp_or_file, list):  # we need to create the dic
        count_model = CountVectorizer(ngram_range=(1, 1))
        X = count_model.fit_transform(glove_train_corpus)
        Xc = (X.T*X)  # gives the co-occurence based on how many times they appear in the same document together
        nz_rows, nz_cols = Xc.nonzero()
        co_dict = {r: {} for r in nz_rows}

        print("Beginning creation of Co- dict. This may take a while [minutes hopefully]")
        for r, c in zip(nz_rows, nz_cols):  # takes a while, but a reasonable while
            print(r / float(len(nz_rows)))
            co_dict[r][c] = Xc[(r, c)]
        print("Finished creation of Co- Dict")

        return co_dict
    else:
        raise ValueError("Invalid input: must be a corpus or a filename")


def get_glove_model(co_occurrence_dic, epochs=25):
    assert isinstance(co_occurrence_dic, dict)

    model = Glove(co_occurrence_dic)
    for epoch in range(epochs):  # train the model
        err = model.train()
        print("epoch %d, error %.3f" % (epoch, err), flush=True)
    model
    return model.W


def glove_vectorize_corpus(model, corpus_to_vectorize):
    # REMEMBER THE WORD2INDEX IS DEFINED ABOVE!!!!

    vector_size = model[0].shape[0]
    vectors = []
    for line in corpus_to_vectorize:
        line_vecs = []
        for word in line.split():
            if word in word2index.keys():  # why are not all words in the word2index? (Answer: It removes common words)
                index = word2index[word]
                vector = model[index].reshape((1, vector_size))
                line_vecs.append(vector)
        vectors.append(vector_concatenate(line_vecs))
    return np.concatenate(vectors)


if __name__ == "__main__":
    corpus = get_corpus("Embedding_Files/macro_indication_corpus.txt")
    co_dic = get_co_occurrence_dic(corpus)
    model = get_glove_model(co_dic)

    train = get_corpus("Embedding_Files/macro_train_corpus.txt")
    test = get_corpus("Embedding_Files/macro_test_corpus.txt")

    train_vectorized = glove_vectorize_corpus(model, train)
    test_vectorized = glove_vectorize_corpus(model, test)
    np.save("Embedding_Files/Macro_glove_vectorized_train_set.npy", train_vectorized)
    np.save("Embedding_Files/Macro_glove_vectorized_testset.npy", test_vectorized)

