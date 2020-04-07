from conllu import parse
from sys import argv,exit

try:
    num = argv[1]
    mode = argv[2]
except:
    print("Modo de uso: python3 extrair_grases.py QTD_DE_FRASES MODO\n Onde MODO: 1, para gerar as QTD_DE_FRASES primeiras frases ou 2 para gerar TOTAL - QTD_DE_FRASES últimas frases." )
    exit()

data = open("../frases.conllu").read()
frases = parse(data)
com_status = [frase for frase in frases if 'status' in frase.metadata.keys()]

revisado = [frase for frase in com_status if frase.metadata['status'] == 'revisado']

t = ''
i = 0
if mode == '1':
    for x in revisado:
        t+=x.serialize()
        t+='\n'
        i += 1
        if i >= int(num):
            break
if mode == '2':
    i = 1
    while i < len(revisado) - int(num):
        t+=revisado[len(revisado)-i].metadata['text']
        i+=1
t = t[:-2]
print(t)

#with open('frases_revisadas.conllu','w') as arq:
    #for t in revisado:
        #arq.write(t.serialize())
        #arq.write("\n")
    #arq.close()
    
