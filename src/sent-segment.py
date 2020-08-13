import nltk.tokenize.punkt
import sys, pickle, os, time, argparse

parser = argparse.ArgumentParser()
parser.add_argument("-m","--model",help="model trained file path")
parser.add_argument("indir",help="file or directory of raw to be processed")
parser.add_argument("outdir", help="file or directory of processed sents")
parser.add_argument("-i","--infile",help="unique file processing mode", type=bool, const=True, nargs='?')
parser.add_argument("-s","--status",help="show status on stdout during running", type=bool, const=True, nargs='?')
args = parser.parse_args()

t0=time.time()
if args.status:	print("Carregando modelo.")
if args.model: arq=open(args.model,"rb")
else: arq=open("model_punkt.pickle","rb")
model=pickle.load(arq)
if args.status: print("Modelo carregado em: {:.3} s".format(time.time()-t0))

if args.infile:
	text = open(args.indir, 'r').read()
	sents = model.span_tokenize(text)
	with open(args.outdir,'w') as out_file:
		for element in sents:
			out_file.write(str(element[0]) + " " + str(element[1])+"\n")
			
else:
	if args.status: print("Processando raw")
	for file in os.listdir(args.indir):
		if file.endswith(".raw"):
			text = open(os.path.join(args.indir,file), 'r').read()
			sents = model.span_tokenize(text)
			with open(os.path.join(args.outdir,file.replace(".raw","-nk.sent")), "w") as out_file:
				for element in sents:
					out_file.write(str(element[0]) + " " + str(element[1])+"\n")
	if args.status: print("Tempo total: {:.3} s".format(time.time()-t0))