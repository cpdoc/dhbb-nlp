from conllu import parse

gold = parse(open('gold.conllu').read())
wrong = parse(open('wrong.conllu').read())
parsed = parse(open('parsed.conllu').read())

total = 0
correto = 0

for s1,s2 in zip(gold,wrong):
    correto_in = 0
    total_in = 0
    for t1,t2 in zip(s1,s2):
        if t1['head'] == t2['head']:
            if t1['deprel'] == t2['deprel']:
                correto+=1
                correto_in+=1
        total+=1
        total_in+=1
    print("Sentence {}: {}".format(gold.index(s1),correto_in/total_in))

print(correto/total)
