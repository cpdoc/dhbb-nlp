import sys, re, argparse, os, time

parser = argparse.ArgumentParser()
parser.add_argument("-i","--infile",help="single file processing mode. Only files with given start will be processed.",nargs = "?")
parser.add_argument("-v","--verbose",help="verbose mode, prints in the stdout.", action='store_true')
parser.add_argument('pathin', help='path to the input files')
parser.add_argument('pathout', help='path to the output files')
args = parser.parse_args()

def to_tuples(f,cod):
    l=[]
    for line in f:
        a,b = line[:-1].split()
        l.append((int(a),int(b),cod))
    return l  

def simplify(U):
    t=list(set([(e[0],e[1],'') for e in U]))
    t.sort()
    for i in range(len(t)):
        cor=[e for e in U if (e[0],e[1],'')==t[i]]
        ext=[elem[2] for elem in cor]
        ext.sort()
        t[i]=(t[i][0],t[i][1],' '.join(ext))
    return t

def universe_generator(*files):
    U=[]
    union=[]
    for tool in files:
        cod = re.search('-(.*).sent', tool)
        U = U + to_tuples(open(tool,'r').readlines(),cod.group(1))
        union.append(cod.group(1))
    U = simplify(U)
    union.sort()
    ext=' '.join(union)
    return(U,ext)

def classify(U,union):
    return([tuples for tuples in U if tuples[2]==union], [tuples for tuples in U if tuples[2]!=union])

def getnum(*files):
    return(files[0][:-8])

def find_files(path,name):
    return [path+filename for filename in os.listdir(path) if re.findall("^"+name+"-", filename)]


def record_shared(shared, path):
    with open(path,'w') as f:
        for tuples in shared:
            f.write(str(tuples[0])+' '+str(tuples[1])+'\n')

def record_different(different, path):
    with open(path,'w') as f:
        for tuples in different:
            f.write(str(tuples[0])+' '+str(tuples[1])+' '+tuples[2]+'\n')

def analysis(*files,pathout):
    U , union = universe_generator(*files)
    shared, different = classify(U,union)
    num = getnum(*files)
    record_shared(shared, pathout+num+'.sent')
    if different: record_different(different, pathout+num+'.diff')
    return

if __name__ == '__main__':

    
    if args.infile:
        t0=time.time()
        if args.verbose: print("Processando arquivos.")
        analysis(*find_files(args.pathin,args.infile),pathout=args.pathout)
        if args.verbose: print("Processamento finalizado em {:.3} s".format(time.time()-t0))

    else:
        t0=time.time()
        if args.verbose: print("Coletando arquivos.")
        l=[]
        for filename in os.listdir(args.pathin):
            if(re.search(r'-', filename)): l.append(filename[:-8])
        l = (list(set(l)))
        if args.verbose: print("Processando arquivos:")
        for element in l:
            if args.verbose: print("Processando {:.3}-??.sent".format(element))
            analysis(*find_files(args.pathin,element),pathout=args.pathout)
        if args.verbose: print("Finalizado em {:.3} s".format(time.time()-t0))