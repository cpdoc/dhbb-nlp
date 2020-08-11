
# recebe como argumento o número do arquivo (apenas número) e
# transforma o conjunto numero-??.sent em um arquivo numero.sent e,
# caso haja divergência, um numero.diff

import sys

def to_list(f):
    out=[]
    for line in f:
        b,e = str(line).split()
        out.append(tuple([int(b),int(e)]))
    return out

def intersection(lst1, lst2, lst3): 
    lst4 = [value for value in lst1 if (value in lst2 and value in lst3)] 
    return list(tuple(i) for i in lst4)

def diference(f,i):
    final_list = []
    for line in f:
        if not(line in i):
            final_list.append(line)
    return final_list

def lst_write(lst,f):
     for element in lst:
        f.write(str(element[0]) + " " + str(element[1])+"\n")



number=str(sys.argv[1])

# 1. lista arquivos NNN-*.sent
# 2. obtem os arquivos e seus sufixos: fl, nl, op...
# 3. no diff saida, usar os sufixos do passo anterior

fl=to_list(open(number+"-fl.sent","r").readlines())
nl=to_list(open(number+"-nl.sent","r").readlines())
op=to_list(open(number+"-op.sent","r").readlines())

i=intersection(fl,nl,op)

d1=diference(fl,i)
d2=diference(nl,i)
d3=diference(op,i)

with open(number+'.sent', 'w') as f:
    lst_write(i,f)

if (len(d1)+len(d2)+len(d3))> 0:
    with open(str(number)+'.diff', 'w') as f:
        f.write("#FL#\n")
        lst_write(d1,f)
        f.write("#NL#\n")
        lst_write(d2,f)
        f.write("#OP#\n")
        lst_write(d3,f)
