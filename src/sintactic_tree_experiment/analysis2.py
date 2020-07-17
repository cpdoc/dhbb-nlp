from conllu import parse
import os

morpho_dir = "/media/lucas/Lucas/work/MorphoBr/verbs/"

files = [x for x in os.listdir(morpho_dir) if '.dict' in x]
tam = len(files)

teste = open(morpho_dir+files[0],'r')

def get_verb(s):
    return s.split("\t")[0]

verbs = []
i = 0
for file in files:
    before = ''
    for s in open(morpho_dir+file,'r'):
        pal = get_verb(s)
        if pal == before:
            continue
        else:
            before = pal
            verbs.append(pal)
    i+=1
    print("{}% executado.".format(round(100*i/tam,2)),end='\r')

print("\n")

arquivo = open("head_not_in_morpho_real.verb").read().split("\n")

corrigidos = []

i = 0
ops = len(arquivo)
for x in arquivo:
    try: 
        if x.split("\t")[3].lower() not in verbs:
            corrigidos.append(x.split("\t"))
    except:
        print(x)
    

    i+=1
    print("{}%".format(round(100*i/ops)),end='\r')


corrigidos.sort(key=lambda x: int(x[-1]), reverse=True)

t = ''
for x in corrigidos:
    for p in x:
        t+=p+'\t'
    t+='\n'

with open('frases_verbo_morpho.verbs','w') as arq:
    arq.write(t)

