
from collections import defaultdict
import os

import requests
import json
import csv

import spacy
import pt_core_news_sm

nlp = spacy.load("pt_core_news_sm")
nlp = pt_core_news_sm.load()


def def_value(): 
    return 0

def procfile(fn, db):
    with open(fn) as i:
        sents = i.readlines()
        for s in sents:
            doc = nlp(s)
            for entity in doc.ents:
                db[(entity.text, entity.label_)] += 1
    return db


def get(v, n):
    base = "https://www.wikidata.org/w/api.php"
    url = f"{base}?action=wbsearchentities&format=json&language=pt&type=item&continue=0&search={v}"
    res, r = [], requests.get(url)
    r = r.json()
    if "search" in r:
        for i in r["search"][0:n]:
            res.append(i)
    return res


def main1():
    entities = defaultdict(def_value)
    result = {}

    with open('tematicos.txt') as l:
        files = [int(s.split('|')[0]) for s in l.readlines()]
        for fn in files:
            procfile(f'../raw/{fn}.raw', entities)
    
    with open("entidades.csv", "w", newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL)

        for k in entities.keys():
            res = get(k[0],3)
            result[k] = dict(freq = entities[k], wd = res)
            for n,a in enumerate(res):
                writer.writerow([k[0],k[1],entities[k],
                                 n,a.get('id',''), a.get('url',''), a.get('description',''),a.get('label','')])

    with open("entidades.json", "w") as outfile:
        json.dump(result, outfile)


def main2():
    result = {}

    with open('tematicos.txt') as l:
        titles = [s.split('|')[1].strip() for s in l.readlines()]

    with open("title-entidades.csv", "w", newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL)

        for k in titles:
            print('processing', k)
            res = get(k,3)
            result[k] = res
            for n,a in enumerate(res):
                writer.writerow([k,n,a.get('id',''), a.get('url',''), a.get('description',''),a.get('label','')])
    
    with open("title-entidades.json", "w") as outfile:
        json.dump(result, outfile)
        
main2()

