import sys, re

def to_tuples(f,cod):
    l=[]
    for line in f:
        a,b = line[:-1].split()
        l.append((int(a),int(b),cod))
    return l  

def simplify(U):
    for i in range(len(U)-1):
        for j in range(i+1,len(U)):
            if U[j][0]>U[i][0]: break
            if (U[i][0]==U[j][0] and U[i][1]==U[j][1]):
                U[i]=(U[i][0],U[i][1],U[i][2]+' '+U[j][2])
                U.pop(j)
    return U

U=[]
for tool in sys.argv[1:]:
    cod = re.search('-(.*).sent', tool)
    U = U + to_tuples(open(tool,'r').readlines(),cod.group(1))


U.sort(key=lambda tup: tup[0])

print(U)
print(simplify(U))