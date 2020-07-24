from conllu import parse
import os
from sys import exit


morpho = "/media/lucas/Lucas/work/MorphoBr/"

noun = open(morpho+'nouns.dict').read().split("\n")

noun = [x.split('\t') for x in noun]

noun = [x[0] for x in noun]

noun = set(noun)

adj = open(morpho+'adjectives.dict').read().split("\n")

adj = [x.split('\t') for x in adj]

adj = [x[0] for x in adj]

adj = set(adj)


adv = open(morpho+'adverbs.dict').read().split("\n")

adv = [x.split('\t') for x in adv]

adv = [x[0] for x in adv]

adv = set(adv)

tem = []
ntem = []
fora = []

arq = open("head_not_in_morpho.verbmin").read().split("\n")

arq = [x.split("\t") for x in arq]

i = 0
ap = len(arq)

for x in arq:
    try:
        if x[3].lower() in noun:
            if x[3].lower() in adv:
                ntem.append([x,'adv','noun'])
            elif x[3].lower() in adj:
                ntem.append([x,'adj','noun'])
            else:
                tem.append([x,'noun'])
        elif x[3].lower() in adj:
            if x[3].lower() in adv:
                ntem.append([x,'adj','adv'])
            else:
                tem.append([x,'adj'])
        elif x[3].lower() in adv:
            tem.append([x,'adv'])
        else:
            fora.append(x)
    except:
        pass
    i+=1
    print("{}%".format(round(100*i/ap,2)),end='\r')
    
    
with open("funciona.morpho",'w') as funciona:
    escrever = ''
    for t in tem:
        for h in t[0]:
            escrever+="{}\t".format(h)
        escrever+=t[1]+"\n"
    funciona.write(escrever)
    
print("Terminou 1")

with open("naofunciona.morpho",'w') as naofunciona:
    escrever = ''
    for t in ntem:
        for h in t[0]:
            escrever+="{}\t".format(h)

        escrever+=t[1]+"\t"
        escrever+=t[2]+"\n"
    naofunciona.write(escrever)
print("Terminou 2")

with open("naoexiste.morpho",'w') as nexiste:
    escrever = ''
    for x in fora:
        for t in x:
            escrever+="{}\t".format(t)
        escrever+="\n"
    nexiste.write(escrever)
print("FIM")
    
            
print("TOTAL: {}\nFUNCIONA: {}\nNÃO FUNCIONA: {}".format(len(tem+ntem), len(tem),len(ntem)))
                
