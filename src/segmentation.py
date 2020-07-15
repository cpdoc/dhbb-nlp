import nltk, sys

text = sys.stdin.read()
sents=nltk.sent_tokenize(text)
for element in sents:
    pos=text.find(element)
    print(str(pos)+" "+str(pos+len(element)))
