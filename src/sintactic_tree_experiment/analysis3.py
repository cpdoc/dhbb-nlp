from conllu import parse

def get_file(s):
    return s.split("\t")
linhas = len(open("head_not_in_morpho_noaux.dhbb","r").read().split("\n"))
i=0
dados = open("head_not_in_morpho_noaux.dhbb","r")
arq = open("head_not_in_morpho_noaux.verbs","w")
for line in dados:
    if '.conllu' not in line:
        continue
    lista = get_file(line)
    stop = False
    conllu = parse(open("/media/lucas/Lucas/work/dhbb-nlp/udp/"+lista[0],'r').read())
    sent = conllu[(int(lista[1])-1)]
    for token in sent:
        if token['upos'] == 'AUX':
            stop = True
            break
    if stop == True:
        continue
    else:
        sent.metadata['file']=lista[0]
        arq.write(sent.serialize())
    i+=1
    print("{}%...".format(round(100*i/(linhas),2)),end='\r')
print("done")
