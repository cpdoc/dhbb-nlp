import os

morpho = "/media/lucas/Lucas/work/MorphoBr/"

verbs = []

for x in [x for x in os.listdir(morpho+"verbs") if '.dict' in x]:
    data = open(morpho+'verbs/'+x).read().split("\n")
    data = [x.split('\t') for x in data]
    data = [x[0] for x in data]
    verbs += data

verbs = set(verbs)

files = open("head_not_in_morpho.verb").read().split('\n')

files = [x.split("\t") for x in files]


gravar = open("palavras_verbo_erradas.verb",'w')
ips = len(files)
i = 0
for x in files:
    try:
        if x[3].lower() not in verbs:
            t = ''
            for a in x:
                t += "{}\t".format(a)
            t+='\n'
            gravar.write(t)
    except:
        print(x)
    i+=1
    print("{}%".format(round(100*i/ips,2)),end='\r')
    
        
    
    
