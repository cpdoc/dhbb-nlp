import nltk.tokenize.punkt
import sys, pickle, os, time, argparse
import glob

# construcao argumentos programa

parser = argparse.ArgumentParser()
parser.add_argument("-m","--model",help="file with the model to be loaded.")

parser.add_argument("indir",help="directory where the raw files are located.")

parser.add_argument("outdir", help="directory to save the outputs.")

parser.add_argument("-i","--infile",help="single file processing mode. Only this file will be processed.",
                    nargs = "?")

parser.add_argument("-v","--verbose",help="verbose mode, prints in the stdout.",
                    action='store_true')


# variaveis globais

args = parser.parse_args()
model = None
t0 = time.time()

if args.verbose:
        print("Carregando modelo %s" % args.model)
if args.model:
        arq = open(args.model,"rb")
        model = pickle.load(arq)
else:
        arq=open("model_punkt.pickle","rb")

if args.verbose:
        print("Modelo carregado em: {:.3}s".format(time.time()-t0))

if args.infile:
        fin = os.path.join(args.indir, args.infile)
        text  = open(fin, 'r').read()
        sents = model.span_tokenize(text)
        fnout = os.path.join(args.outdir,
                             args.infile.replace(".raw","-nk.sent"))
        with open(fnout,'w') as out_file:
                for element in sents:
                        out_file.write(str(element[0]) + " " + str(element[1])+"\n")
        if args.verbose: print("processed %s => %s" % (fin, fnout))

else:
        for fn in glob.glob(os.path.join(args.indir,"*.raw")):
                text = open(fn, 'r').read()
                sents = model.span_tokenize(text)
                fnout = os.path.join(args.outdir, os.path.basename(fn).replace(".raw","-nk.sent"))
                with open(os.path.join(args.outdir,fnout), "w") as out:
                        for element in sents:
                                out.write(str(element[0]) + " " + str(element[1])+"\n")
                if args.verbose: print("processed %s => %s" % (fn,fnout))

if args.verbose:
        print("Tempo total: {:.3}s".format(time.time()-t0))
