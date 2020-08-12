#Arg1 = model_trained_file ( model_punkt.pickle )
#Arg2 = path_raw ( ../raw/ )
#Arg3 = path_out ( ../sent/ )

import nltk.tokenize.punkt
import sys, pickle, os

arq=open(sys.argv[1],"rb")
model=pickle.load(arq)

for file in os.listdir(sys.argv[2]):
	if file.endswith(".raw"):
		text = open(os.path.join(sys.argv[2],file), 'r').read()
		sents = model.span_tokenize(text)
		with open(os.path.join(sys.argv[3],file.replace(".raw","-nk.sent")), "w") as out_file:
			for element in sents:
				out_file.write(str(element[0]) + " " + str(element[1])+"\n")