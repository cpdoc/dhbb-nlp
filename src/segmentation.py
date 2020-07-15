import nltk
import sys

text=""
for line in sys.stdin:
    if(line=="\n"):
        break
    text=text+" "+line.rstrip("\n")
text=text[1:]

sents=nltk.sent_tokenize(text)
for element in sents:
    pos=text.find(element)
    print(str(pos)+" "+str(pos+len(element)))
