#!/usr/bin/python3

from conllu import parse
from sys import argv,exit


options = [argv[1],argv[2]]
gold = argv[-1]
target = argv[-2]

gold = parse(open(gold).read())
target = parse(open(target).read())

if len(gold) != len(target):
    print("Different number of sentences!")
    exit()


def pos_evaluate(gold,target):
    tot,corr,feats,lemma,all = 0,0,0,0,0
    for sent1,sent2 in zip(gold,target):
        if sent1.metadata['text'] != sent2.metadata['text']:
            print("Conllu files must have sentences in the same order!")
            exit()
        for x,y in zip(sent1,sent2):
            if x['head'] == None:
                continue
            if x['upos'] == y['upos']:
                corr+=1
            if x['feats'] == y['feats']:
                feats+=1
            if x['lemma'] == y['lemma']:
                lemma+=1
            if  x['upos'] == y['upos'] and x['feats'] == y['feats'] and x['lemma'] == y['lemma']:
                all += 1
                
            else:
                #print("FOUND DIFFERENCE: TOKEN {}. UPOS GOLD: {} UPOS TARGET {}".format(x['form'],x['upos'],y['upos']))
                pass
            tot+=1
    t = "Matching score POS: {}% \t Matching score FEATS: {}% \t Matching score LEMMA: {} \t Matching score ALL: {}%".format(round(100*corr/tot,2),round(100*feats/tot,2),round(100*lemma/tot,2),round(100*all/tot,2))
    return t
    

def parse_evaluate(gold,target):
    uas,las,tot = 0,0,0
    for sent1,sent2 in zip(gold,target):
        if sent1.metadata['text'] != sent2.metadata['text']:
            print("Conllu files must have sentences in the same order!")
        for x,y in zip(sent1,sent2):
            if x['head'] == None:
                continue
            if x['head'] == y['head']:
                uas += 1
                if x['deprel'] == y['deprel']:
                    las += 1
            tot+=1
    t= "UAS score: {}% \tLAS score: {}%".format(round(100*uas/tot,2),round(100*las/tot,2))
    return t
    
if __name__ == "__main__":
    if 'pos' in options:
        print(pos_evaluate(gold,target))
    if 'parse' in options:
        print(parse_evaluate(gold,target))
    
