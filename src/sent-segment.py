import nltk.tokenize.punkt
import sys, pickle

arq=open(sys.argv[1],"rb")
# arq=open("model_punkt.pickle","rb")
model=pickle.load(arq)
model._params.abbrev_types.add("S.A")
model._params.abbrev_types.add("s.a")
text = sys.stdin.read()

sents = model.span_tokenize(text)

for element in sents:
	print(str(element[0]) + " " + str(element[1]))
