import os
morpho = "/media/lucas/Lucas/work/MorphoBr/verbs/"



verbs = []

for x in [x for x in os.listdir(morpho) if '.dict' in x]:
    arq = open(morpho+x)
    for line in arq:
        verbs.append(line.split("\t")[0])
    arq.close()

verbs = set(verbs)
    
arq = open("naoexiste.morpho")
output = open("output.morpho",'w')

for line in arq:
    verb = line.split("\t")[3]
    if verb.lower() not in verbs:
        output.write(line)
        output.write("\n")
print('fim')
        
        
    
