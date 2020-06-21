
text = open('99.conllu').read().split('\n')

final = []

for x in text:
    if x != '':
        if x[0] in [str(n) for n in range(1,500)]:
            final.append(x+"\t_")
        else:
            final.append(x)

with open('99.srl','w') as arq :
    for x in final:
        arq.write(x)
        arq.write("\n")

print('done')

