from DataCleaning_main import get_full_data


def write_corpus(columns):
    '''

    :param columns: The columns from the full data over which we want to write a corpus.
     Will write in order given with spaces in between columns and a newline after every row
    :return: none
    '''
    file_name = "_".join(columns)+"_"+"corpus.txt"
    writer = open(file_name, "w")
    data = get_full_data()
    for r, row in data.iterrows():
        writer.write(" ".join([row[c] for c in columns])+"\n")
    writer.close()

