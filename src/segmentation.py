
import nltk, re, pprint
from nltk import word_tokenize
import os

sent_tokenizer = nltk.data.load('tokenizers/punkt/portuguese.pickle')
pathi = "/Users/ar/work/cpdoc/dhbb-nlp/raw/"
patho = "/Users/ar/work/cpdoc/dhbb-nlp/nltk/"

for fn in os.listdir(pathi):
    if fn.endswith(".raw"):
        print(">> processing %s" % fn)
        fin = pathi + fn
        fou = patho + fn.replace(".raw",".sent")
        raw = open(fin).read()
        # tokens = word_tokenize(raw)
        sentences = sent_tokenizer.tokenize(raw)
        outf = open(fou, "w")
        for s in sentences:
            s = re.sub(r"\n"," ", s)
            s = re.sub(r"[ ]+", " ", s)
            outf.write(s.strip())
            outf.write("\n")
        outf.close()
            
# words = [w.lower() for w in tokens]
# vocab = sorted(set(words))

# text = nltk.Text(tokens)
# myc  = text.collocations()
