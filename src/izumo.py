import pyizumo

nlp = pyizumo.load('en')
text = "The world's fifth Disney park will soon open to the public here."
doc = nlp(text)

def uid(tk):
    if tk == None:
        return 0
    else:
        return tk.index + 1

for paragraph in doc.paragraphs:
    print("\n")
    for sentence in paragraph:
        for token in sentence:
            print('\t'.join([
                str(e) for e in [uid(token), token, token.lemma, token.pos, "_", "_",
                                 uid(token.parent), token.relation, "_", "_"]]))
