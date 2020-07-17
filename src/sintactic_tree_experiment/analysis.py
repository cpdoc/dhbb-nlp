from conllu import parse
import os

morpho_dir = "/media/lucas/Lucas/work/MorphoBr/verbs/"

files = [x for x in os.listdir(morpho_dir) if '.dict' in x]
tam = len(files)

teste = open(morpho_dir+files[0],'r')

verbs1 = []

def get_verb1(s):
    return s.split("\t")[0]

i = 0
for file in files:
    before = ''
    for s in open(morpho_dir+file,'r'):
        pal = get_verb1(s)
        if pal == before:
            continue
        else:
            before = pal
            verbs1.append(pal)

def get_verb(s):
    return s.split("\t")[1].split("+")[0]

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

verbs = list(set(verbs))

len(verbs)

udp = [x for x in os.listdir("/media/lucas/Lucas/work/dhbb-nlp/udp/") if '.conllu' in x]

lemas_verbais = {}


i = 0
s = ''
tam = len(udp)
for x in udp:
    try:
        conllu = parse(open("/media/lucas/Lucas/work/dhbb-nlp/udp/"+x,'r').read())
    except:
        print("Erro lendo arquivo: {}".format(x))
    for sent in conllu:
        for token in sent:
            parar = False
            if token['head'] == 0:
                if token['upos'] != 'VERB':
                    break
                if token['form'].lower() in verbs1:
                    break
                if token['lemma'].lower() not in verbs and token['lemma'].lower() != 'freqüentar':
                    for token2 in sent:
                        if token2['upos'] == 'AUX':
                            parar = True
                    if parar == True:
                        break
                    if x in lemas_verbais.keys():
                        lemas_verbais[x].append({'id_sent':conllu.index(sent) +1,'lemma':token['lemma'],'token':token['form'],'pos':token['upos'],'id':token['id'],'tamanho':len(sent)})
                    else:
                       
                        lemas_verbais[x] = [{'id_sent':conllu.index(sent) +1,'lemma':token['lemma'],'token':token['form'],'pos':token['upos'], 'id':token['id'],'tamanho':len(sent)}]
                break
    i+=1
    print("{}% executado.".format(round(100*i/tam)),end='\r')
    
print("\n")
s+="ARQUIVO\tSENT_ID\tLEMMA\tTOKEN\tPOS\tID\tTAMANHO\n"
for dic in lemas_verbais.keys():
    for esp in lemas_verbais[dic]:
        s+="{}\t{}\t{}\t{}\t{}\t{}\t{}\n".format(dic,esp['id_sent'],esp['lemma'],esp['token'],esp['pos'],esp['id'],esp['tamanho'])
    s+='\n'
    
        
output = open("head_not_in_morpho_noaux.dhbb",'w')       
output.write(s)
output.close()
print("Fim")




                    
                
