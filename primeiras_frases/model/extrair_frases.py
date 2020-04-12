from conllu import parse
from sys import argv,exit, stderr


"""
O script gera 3 arquivos: 
    1) frases_treino.conllu -> conjunto de frases revisadas para frases_treino em formato conllu
    2) frases_teste.sent -> conjunto de frases revisadas para teste, em formato sent
    3) frases_target.conllu -> conjunto das mesmas frases do frases_teste em formato conllu, revisadas manualmente
"""

data = open("../frases.conllu").read()
frases = parse(data)

com_status = [frase for frase in frases if 'status' in frase.metadata.keys()]

revisado = [frase for frase in com_status if frase.metadata['status'] == 'revisado']

len_treino = round(len(revisado)*0.65,0)
len_teste = len(revisado) - len_treino 

conllu = ''
i = 0
target = ''

for x in revisado:
    conllu+=x.serialize()
    conllu+='\n'
    i += 1
    if i >= len_treino:
        break

t = ''
while i < len(revisado):
    t+=revisado[i].metadata['text']
    target += revisado[i].serialize()
    target+='\n'
    t+= '\n'
    i+=1
t = t
conllu = conllu

with open('frases_treino.conllu','w') as arq:
    arq.write(conllu)

with open('frases_teste.sent','w') as arq:
        arq.write(t)
        
with open('frases_target.conllu','w') as arq:
    arq.write(target)
    arq.close()

    
