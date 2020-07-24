from conllu import parse

arq = parse(open("head_not_in_morpho_noaux.verbs").read())

arq = [[x,len(x)] for x in arq]

arq.sort(key = lambda x: x[1])

with open('head_not_in_morpho_noaux_order.verbs','w') as wr:
    for x in arq:
        wr.write(x[0].serialize())
print('done')
