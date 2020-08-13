import sys, re, argparse

parser = argparse.ArgumentParser()
parser.add_argument('files', metavar='f', nargs='+', help='files *-??.sent to generate .sent and, if necessary, .diff')
parser.add_argument('pathout', help='path to the output files')
args = parser.parse_args()

def to_tuples(f,cod):
    l=[]
    for line in f:
        a,b = line[:-1].split()
        l.append((int(a),int(b),cod))
    return l  

def simplify(U):
    try:
        for i in range(len(U)):
            j=i+1
            while j<len(U):
                if U[j][0]>U[i][0]: break
                if (U[i][0]==U[j][0] and U[i][1]==U[j][1]):
                    U[i]=(U[i][0],U[i][1],U[i][2]+' '+U[j][2])
                    U.pop(j)
                else:
                    j += 1
    except: pass
    return(U)

def universe_generator(*files):
    U=[]
    union=''
    for tool in files:
        cod = re.search('-(.*).sent', tool)
        U = U + to_tuples(open(tool,'r').readlines(),cod.group(1))
        union=(union+' '+cod.group(1)).lstrip()
    U.sort(key=lambda tup: tup[0])
    U = simplify(U)
    return(U,union)

def classify(U,union):
    shared, different = [], []
    for tuples in U:
        if tuples[2]==union: shared.append(tuples)
        else: different.append(tuples)
    return(shared,different)

def getnum(*files):
    return(files[0][:-8])

def record_shared(shared, path):
    with open(path,'w') as f:
        for tuples in shared:
            f.write(str(tuples[0])+' '+str(tuples[1])+'\n')


def record_different(different, path):
    with open(path,'w') as f:
        for tuples in different:
            f.write(str(tuples[0])+' '+str(tuples[1])+' '+tuples[2]+'\n')




if __name__ == '__main__':

    U , union = universe_generator(*args.files)
    shared, different = classify(U,union)
    num = getnum(*args.files)
    record_shared(shared, args.pathout+num+'.sent')
    if different: record_different(different, args.pathout+num+'.diff')