#Arg1 = model_trained_file ( model_punkt.pickle )
#Arg2 = path_raw ( ../raw/ )
#Arg3 = path_out ( ../sents/ )
#Arg4 = Log (booleano 0/1)

import nltk.tokenize.punkt
import sys, pickle, os, time

if(int(sys.argv[4])): t0=time.time()
if(int(sys.argv[4])): print("Carregando modelo")
arq=open(sys.argv[1],"rb")
model=pickle.load(arq)
if(int(sys.argv[4])): print("Modelo carregado em: {:.3} s".format(time.time()-t0))

if(int(sys.argv[4])): print("Processando raw")
for file in os.listdir(sys.argv[2]):
	if file.endswith(".raw"):
		text = open(os.path.join(sys.argv[2],file), 'r').read()
		sents = model.span_tokenize(text)
		with open(os.path.join(sys.argv[3],file.replace(".raw","-nk.sent")), "w") as out_file:
			for element in sents:
				out_file.write(str(element[0]) + " " + str(element[1])+"\n")

if(int(sys.argv[4])): print("Tempo total: {:.3} s".format(time.time()-t0))