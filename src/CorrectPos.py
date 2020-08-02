#!/usr/bin/python3
from conllu import parse
import os
from collections import OrderedDict
from sys import argv

class TokenError(Exception):
    pass   

ext = 'bosque'


morpho = '/media/lucas/Lucas/work/MorphoBr/'

def get_features(s):
    s = s.replace("\n",'')
    s = s.split("+")
    if s[1] == 'V':
        lemma = s[0]
        upos = 'VERB'
        if len(s) == 3:
            if s[2] == 'INF':
                verbform = 'Fin'
            elif s[2] == 'GRD':
                verbform = 'Ger'
            dic = OrderedDict([('VerbForm', verbform)])
            return lemma,upos,dic
        if s[2] == 'INF':
            verbform = 'Fin'
            mood = 'Ind'
            return lemma,upos,dic                     
        elif s[2] == 'PTPASS':
            verbform = 'Part'
            if s[3] == 'M':
                gender = 'Masc'
            elif s[3] == 'F':
                gender = 'Fem'
            if s[4] == 'PL':
                number = 'Plur'
            elif s[4] == 'SG':
                number = 'Sing'
            dic = OrderedDict([('Gender',gender),('Number',number),('VerbForm',verbform)])
            return lemma,upos,dic
        elif s[2] == 'SBJP':
            verbform = 'Fin'
            mood = 'Sub'
            person = str(s[3])
            if s[4] == 'PL':
                number = 'Plur'
            elif s[4] == 'SG':
                number = 'Sing'
            dic = OrderedDict([('Mood',mood),('Number',number),('Person',person),('Tense','Imp'),('VerbForm',verbform)])
            return lemma,upos,dic
        elif s[2] == 'SBJR':
            verbform = 'Fin'
            mood = 'Sub'
            person = str(s[3])
            if s[4] == 'PL':
                number = 'Plur'
            elif s[4] == 'SG':
                number = 'Sing'
            dic = OrderedDict([('Mood',mood),('Number',number),('Person',person),('Tense','Pres'),('VerbForm',verbform)])
            return lemma,upos,dic            
        elif s[2] == 'GRD':
            verbform ='Ger'
        elif s[2] == 'SBJF':
            verbform = 'Fin'
            mood = 'Sub'
            person = str(s[3])
            if s[4] == 'PL':
                number = 'Plur'
            elif s[4] == 'SG':
                number = 'Sing'
            dic = OrderedDict([('Mood',mood),('Number',number),('Person',person),('Tense ','Fut'),('VerbForm',verbform)])
            return lemma,upos,dic         
        elif s[2] == 'PRF':
            verbform = 'Fin'
            mood = 'Ind'
            person = str(s[3])
            if s[4] == 'PL':
                number = 'Plur'
            elif s[4] == 'SG':
                number = 'Sing'
            dic = OrderedDict([('Mood',mood),('Number',number),('Person',person),('Tense ','Past'),('VerbForm',verbform)])
            return lemma,upos,dic     
        elif s[2] == 'PRS':
            verbform = 'Fin'
            mood = 'Ind'
            person = str(s[3])
            if s[4] == 'PL':
                number = 'Plur'
            elif s[4] == 'SG':
                number = 'Sing'
            dic = OrderedDict([('Mood',mood),('Number',number),('Person',person),('Tense','Pres'),('VerbForm',verbform)])
            return lemma,upos,dic       
        elif s[2] == 'PQP':
            verbform = 'Fin'
            mood = 'Ind'
            person = str(s[3])
            if s[4] == 'PL':
                number = 'Plur'
            elif s[4] == 'SG':
                number = 'Sing'
            dic = OrderedDict([('Mood',mood),('Number',number),('Person',person),('Tense','Pqp'),('VerbForm',verbform)])
            return lemma,upos,dic    
        elif s[2] == 'FUT':
            verbform = 'Fin'
            mood = 'Ind'
            person = str(s[3])
            if s[4] == 'PL':
                number = 'Plur'
            elif s[4] == 'SG':
                number = 'Sing'
            dic = OrderedDict([('Mood',mood),('Number',number),('Person',person),('Tense','Fut'),('VerbForm',verbform)])
            return lemma,upos,dic    
        elif s[2] == 'COND':
            verbform = 'Fin'
            mood = 'Cnd'
            person = str(s[3])
            if s[4] == 'PL':
                number = 'Plur'
            elif s[4] == 'SG':
                number = 'Sing'
            dic = OrderedDict([('Mood',mood),('Number',number),('Person',person),('VerbForm',verbform)])
            return lemma,upos,dic    
        elif s[2] == 'IMPF':
            verbform = 'Fin'
            mood = 'Ind'
            person = str(s[3])
            if s[4] == 'PL':
                number = 'Plur'
            elif s[4] == 'SG':
                number = 'Sing'
            dic = OrderedDict([('Mood',mood),('Number',number),('Person',person),('Tense','Imp'),('VerbForm',verbform)])
            return lemma,upos,dic     
        elif s[2] == 'IMP':
            verbform = 'Fin'
            mood = 'Sub'
            person = str(s[3])
            if s[4] == 'PL':
                number = 'Plur'
            elif s[4] == 'SG':
                number = 'Sing'
            dic = OrderedDict([('Mood',mood),('Number',number),('Person',person),('Tense','Pres'),('VerbForm',verbform)])
            return lemma,upos,dic             
        
    if len(s) == 5 and s[1] != 'V':
        del s[2]
    lemma = s[0]
    if s[1] == 'N':
        upos = 'NOUN'
    elif s[1] == 'A':
        upos = 'ADJ'
    elif s[1] == 'ADV':
        return s[0],s[1], None
    else:
        print (s[1])
        print (s)
        raise TokenError()
    if s[2] == 'M':
        gender = 'Masc'
    elif s[2] == 'F':
        gender = 'Fem'
    else:
        print(s[3])
    if s[3] == 'PL':
        num = 'Plur'
    elif s[3] == 'SG':
        num = 'Sing'
    else:
        print(s[3])
        raise TokenError
    dic = OrderedDict([('Gender',gender),('Number',num)])
    return lemma,upos,dic
    
        

print("Getting morphobr words...")

noun = []

for dic in [x for x in os.listdir(morpho+"nouns") if '.dict' in x]:
    tmp = open(morpho+'nouns/'+dic)
    pre = [line.split("\t") for line in tmp]
    noun += pre
print("Nouns done...")

verbs = []

for dic in [x for x in os.listdir(morpho+"verbs") if '.dict' in x]:
    tmp = open(morpho+'verbs/'+dic)
    pre = [line.split("\t") for line in tmp]
    verbs += pre
print("Verbs done...")

adj = []

for dic in [x for x in os.listdir(morpho+"adjectives") if '.dict' in x]:
    tmp = open(morpho+'adjectives/'+dic)
    pre = [line.split("\t") for line in tmp]
    adj += pre
print("Adjectives done...")

adv = []

for dic in [x for x in os.listdir(morpho+"adverbs") if '.dict' in x]:
    tmp = open(morpho+'adverbs/'+dic)
    pre = [line.split("\t") for line in tmp]
    adv += pre
print("Adverbs done...")

final = noun + adj + adv + verbs


treated =open("treated_"+ext,'w')  
gold = []

teste = parse(open(argv[1]).read())
corr = 0
for sent in teste:
    for token in sent:
        flag = False
        if token['upos'] == 'VERB':
            if token['form'].lower() in [x[0] for x in verbs]:
                continue
            else:
                flag = True
        elif token['upos'] == 'NOUN':
            if token['form'].lower() in [x[0] for x in noun]:
                continue
            elif token['form'].lower() in [x[0] for x in verbs]:
                print("POTENTIAL VERB TAGGED AS {}!!!!! TOKEN: {}".format(token['upos'],token['form']))
                flag = True
            else:
                flag = True
        elif token['upos'] == 'ADJ':       
            if token['form'].lower() in [x[0] for x in adj]:
                continue
            elif token['form'].lower() in [x[0] for x in verbs]:
                print("POTENTIAL VERB TAGGED AS {}!!!!! TOKEN: {}".format(token['upos'],token['form']))        
                flag = True
            else:
                flag = True
        elif token['upos'] == 'ADV':        
            if token['form'].lower() in [x[0] for x in adv]:
                continue
            elif token['form'].lower() in [x[0] for x in verbs]:
                print("POTENTIAL VERB TAGGED AS {}!!!!! TOKEN: {}".format(token['upos'],token['form']))
                flag = True
            else:
                flag = True
        if flag == True:
            print("Found token {} marked as {} that maybe incorrectly tagged. Finding if MorphoBr can fix it...".format(token['form'],token['upos']))
            if token['form'].lower() in [x[0] for x  in adj] and token['form'].lower() in [x[0] for x in noun]:
                print("MorphoBr can't help. {} can be both noun and adjective. Sorry!".format(token['form']))
                continue
            if token['form'].lower() in [x[0] for x  in verbs] and token['form'].lower() in [x[0] for x in adj]:
                print("MorphoBr can't help. {} can be both verb and adjective. Sorry!".format(token['form']))
                continue
            if token['form'].lower() in [x[0] for x  in verbs] and token['form'].lower() in [x[0] for x in noun]:
                print("MorphoBr can't help. {} can be both verb and noun. Sorry!".format(token['form']))                
                continue
            flag = False
            for line in final:
                if line[0] == token['form'].lower():
                    lemma,upos,dic = get_features(line[1])
                    print("MorphoBr can help! This token should be tagged as {}. Helping...".format(upos))        
                    print("Corrected! Token {} was {} now it is {} with features: {}` ".format(token['form'],token['upos'],upos, dic))
                    corr+=1
                    token['lemma'] = lemma
                    token['upos'] = upos
                    token['feats'] = dic
                    sent.metadata['treated'] = 'true'
                    flag = True
                    break
            if not flag:
                print("MorphoBr can't help because this token is not in its repository.")
    treated.write(sent.serialize())
    
 

treated.close()

treated2 = parse(open('treated_'+ext,'r').read())
treated = []

for x in treated2:
    try:
        if x.metadata['treated'] == 'true':
            treated.append(x)
    except:
        continue
treated =open("treated_"+ext,'w')

for x in treated2:
    treated.write(x.serialize())


#with open("wrong_bosque.conllu",'w') as bosque:
    #for x in wrong:
        #bosque.write(x.serialize())
        
#with open("treated_bosque.conllu",'w') as bosque:
    #for x in treated:
        #bosque.write(x.serialize())

if "bosque" in ext:
    bosque = parse(open("/media/lucas/Lucas/work/UD_Portuguese-Bosque/pt_bosque-ud-test.conllu").read())
if "gsd" in ext:
    bosque = parse(open("/media/lucas/Lucas/work/UD_Portuguese-GSD/pt_gsd-ud-train.conllu").read())
treated = parse(open("treated_"+ext).read())

for x in treated:
    for y in bosque:
        if y.metadata['text'] == x.metadata['text']:
            gold.append(y)

with open("gold_"+ext,'w') as bosque:
    for x in gold:
        bosque.write(x.serialize())
        

b = parse(open("/media/lucas/Lucas/work/UD_Portuguese-Bosque/pt_bosque-ud-test.conllu").read())

sents = parse(open("treated_bosque.conllu").read())

gold = open("gold_bosque.conllu",'w')
for x in sents:
    try:
        if bef.metadata['text'] == x.metadata['text']:
            print(x.metadata['text'])
    except:
        pass
    for y in b:
        if x.metadata['text'] == y.metadata['text']:
            gold.write(y.serialize())


print("Done!")
print("Corrected {} tokens!".format(corr))
                
    

            
                
                
                        
                        
                    
                    


    
