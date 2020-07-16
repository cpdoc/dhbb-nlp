import nltk.tokenize.punkt
import sys, pickle

arq=open("model_trained.pickle","rb")
model=pickle.load(arq)
text = sys.stdin.read()
sents = model.sentences_from_text(text)
for element in sents:
    pos=text.find(element)
    print(str(pos)+" "+str(pos+len(element)))
