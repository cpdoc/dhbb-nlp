
# see https://pages.github.ibm.com/nlp/documentation/library-izumo/

import pyizumo
import sys

nlp = pyizumo.load('pt')

text = sys.stdin.read()
doc = nlp(text)

def uid(tk):
    if tk == None:
        return 0
    else:
        return tk.index + 1

# for paragraph in doc.paragraphs:
#     for sentence in paragraph:
#         print("{} {}".format(sentence.begin,sentence.end))

for paragraph in doc.paragraphs:
    for sentence in paragraph:
        print("text = {}".format(sentence))
        print("sent_id = {}".format(sentence.index+1))
        for token in sentence:
            print('\t'.join([
                str(e) for e in [uid(token), token, token.lemma, token.pos, "_", "_",
                                 uid(token.parent), token.relation, "_", "_"]]))
        print("\n")
            
        
