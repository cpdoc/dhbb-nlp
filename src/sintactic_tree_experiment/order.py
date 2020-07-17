from conllu import parse

files = parse(open('head_not_in_morpho_noaux.verbs').read())

new = [[x,len(x)] for x in files]

new.sort(key = lambda x: x[1])

files = [x[0] for x in new]

arq = open('frases_verbo_errado.conllu','w')

for sent in files:
    arq.write(sent.serialize())
    
