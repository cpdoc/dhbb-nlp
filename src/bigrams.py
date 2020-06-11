
# Este codigo esta incompleto. Eu gostaria de tentar continuara
# acompanhar este artigo mas em algum momento parece que a API das
# bibliotecas mencionadas pode ter mudado. Ignorei pre-proc que nao
# fazem sentido, em particular stemming. Não esta claro como carregar
# todos os arquivos do DHBB para então treionar mo modelo de
# bigram. Também nao esta claro como obter trigrams etc. Obviamente
# modelos de n-gram como forma de obter MWE não são muito
# efetivos. Mas poderia ser um bom exercicio treinar um modelo de
# embeddings.
#
# https://blog.dominodatalab.com/deep-learning-illustrated-building-natural-language-processing-models/

import nltk
from nltk import word_tokenize, sent_tokenize 
from nltk.corpus import stopwords
from gensim.models.word2vec import Text8Corpus

import os
import string

import gensim
from gensim.models.phrases import Phraser, Phrases

sent_tokenizer = nltk.data.load('tokenizers/punkt/portuguese.pickle')
pathi = "/Users/ar/work/cpdoc/dhbb-nlp/raw/"

for fn in os.listdir(pathi):
    if fn.endswith(".raw"):
        print(">> processing %s" % fn)
        fin = pathi + fn
        raw = Text8Corpus(fin)
        # sentences = sent_tokenizer.tokenize(raw)
        phrases = Phrases(raw)
        bigram = Phraser(phrases)
        for f in bigram.phrasegrams: print(f)
            
# words = [w.lower() for w in tokens]
# vocab = sorted(set(words))

# text = nltk.Text(tokens)
# myc  = text.collocations()

