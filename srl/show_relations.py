#! /usr/bin/python3
from conllu import parse
from sys import argv,exit

def find_by_id(sentence,id):
    if id == 'none':
        return id
    for x in sentence:
        if (x['id']) == int(id):
            return x['form'] 

file = open("99.srl").read()

parsed = parse(file)
file = file.split("\n")
t = ''
sent_id = 0
for line in file:
    if "# sent_id" in line:
        if sent_id > 7:
            sent_id = int(line[-2:]) - 1
        else:
            sent_id = int(line[-1]) - 1

        sentenca = parsed[sent_id]
    if "# text =" in line:
        t+=line+"\n\n"
    if "VERB" in line:
        m = line.split("\t")[-1].split(":")
        t+="Verbo: {}, ".format(m[0])
        for y in m[1:]:
            y = y.split("=")
            #print(y)
            #print(line)
            t+= "{} = {}, ".format(y[0],find_by_id(sentenca,(y[1])))
        t = t[:-2]
        t += '\n'
    if line == '':
        if int(argv[1]) == sent_id + 1:
            print(t[:-1])
            exit()
        else:
            t = ''
        
        
    

    

