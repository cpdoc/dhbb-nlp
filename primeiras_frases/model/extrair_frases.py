from conllu import parse
from sys import argv,exit, stderr


"""
O script gera:
        1) No stdin: os primeiros 65% de frases analisadas em formato conllu do arquivo frases.conllu
        2) No stderr: as últimas 35% de frases (formato sent) contidas no arquivo frases.conllu
        3) Salva um arquivo chamado frases_target.conllu onde contém as 35% últimas análisadas em formato conllu contida no arquivo frases.conllu
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

print(conllu)
print(t,file=stderr)

with open('frases_target.conllu','w') as arq:
    arq.write(target)
    arq.close()

    
