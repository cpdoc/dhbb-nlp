from conllu import parse
import os

arq = open('frases.conllu').read()
arq = parse(arq)

udpipe_path = "/home/lucas/work/dhbb-nlp/udpipe/"

a = [x for x in os.listdir("/home/lucas/work/dhbb-nlp/udpipe/") if '.conllu' in x]
i = 0
frases = open("frases_2.conllu",'w')
for x in arq:
    for file in a:
        arquivo = open(udpipe_path+file).read().split('\n')[0:10]
        for t in arquivo:
            if x.metadata['text'] in t:
                x.metadata['file'] = file
                frases.write(x.serialize() + "\n")
    i+=1            
    print("{}% caregado.".format(round(100*i/len(arq),2)),end='\r')


        
