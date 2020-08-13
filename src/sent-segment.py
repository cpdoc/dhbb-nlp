#Arg1 = Mode: 1 -> file, 2 -> directory
#Arg2 = Log (booleano 0/1)
#Arg3 = model_trained_file ( model_punkt.pickle )

#Para modo 1:
#Arg4 = file_in
#Arg5 = file_out

#Para modo 2:
#Arg4 = path_raw ( ../raw/ )
#Arg5 = path_out ( ../sents/ )


import nltk.tokenize.punkt
import sys, pickle, os, time


if(int(sys.argv[2])): t0=time.time()
if(int(sys.argv[2])): print("Carregando modelo")
arq=open(sys.argv[3],"rb")
model=pickle.load(arq)
if(int(sys.argv[2])): print("Modelo carregado em: {:.3} s".format(time.time()-t0))

if(sys.argv[1]=='1'):
	text = open(sys.argv[4], 'r').read()
	sents = model.span_tokenize(text)
	with open(sys.argv[5],'w') as out_file:
		for element in sents:
			out_file.write(str(element[0]) + " " + str(element[1])+"\n")


if(sys.argv[1]=='2'):
	if(int(sys.argv[2])): print("Processando raw")
	for file in os.listdir(sys.argv[4]):
		if file.endswith(".raw"):
			text = open(os.path.join(sys.argv[4],file), 'r').read()
			sents = model.span_tokenize(text)
			with open(os.path.join(sys.argv[5],file.replace(".raw","-nk.sent")), "w") as out_file:
				for element in sents:
					out_file.write(str(element[0]) + " " + str(element[1])+"\n")

if(int(sys.argv[2])): print("Tempo total: {:.3} s".format(time.time()-t0))