
from collections import defaultdict
import os
import sys
import re

from functools import lru_cache

import requests
import json
import csv

import spacy
import pt_core_news_sm

nlp = spacy.load("pt_core_news_sm")
nlp = pt_core_news_sm.load()



def def_value(): 
    return []

def procfile(fn, fid, db):
    with open(fn) as i:
        sents = i.readlines()
        for s in sents:
            doc = nlp(s)
            for entity in doc.ents:
                db[(entity.text, entity.label_)].append(fid)
    return db


@lru_cache(maxsize=900)
def get(v, n):
    base = "https://www.wikidata.org/w/api.php"
    url = f"{base}?action=wbsearchentities&format=json&language=pt&type=item&continue=0&search={v}"
    res, r = [], requests.get(url)
    r = r.json()
    if "search" in r:
        for i in r["search"][0:n]:
            res.append(i)
    return res

@lru_cache(maxsize=900)
def get_country(q):
    base = "https://www.wikidata.org/w/api.php"
    url = f"{base}?action=wbgetentities&ids={q}&format=json"
    res, r = None, requests.get(url)
    r = r.json()
    r = r['entities'][q]['claims']
    p = r.get('P17', None) or r.get('P495',None) or r.get('P27',None)
    if p:
        try:
            res = p[0]['mainsnak']['datavalue']['value']['id']
        except:
            res = None
    return res
    

def main1(fin, fout):
    entities = defaultdict(def_value)
    result = {}

    with open(fin) as l:
        files = [int(s.split('|')[0]) for s in l.readlines()]
        for fn in files:
            print('processing', fn)
            procfile(f'../raw/{fn}.raw', fn, entities)
    
    with open(f"{fout}.csv", "w", newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL)

        for k in entities.keys():
            print('processing', k)
            res = get(k[0],3)
            result[f'{k[0]}_{k[1]}'] = dict(freq = entities[k], wd = res)
            for n,a in enumerate(res):
                writer.writerow([k[0],k[1],len(entities[k]), '|'.join([str(i) for i in entities[k]]),
                                 n, a.get('id',''), a.get('concepturi',''), a.get('description',''),a.get('label','')])

    with open(f"{fout}.json", "w") as outfile:
        json.dump(result, outfile)



def clean_title(t):
    return re.sub("\((\w|\.|\-| )+\)", "", t, re.UNICODE).strip()
    

def main2(fin, fout):
    result = {}

    with open(fin) as ts, open(f"{fout}.csv", "w", newline='') as csvfile:

        fields = ['title','filename','verbete','seq','qid','qurl','qlabel','qcountry','qdescr']
        writer = csv.DictWriter(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL,
                                fieldnames = fields)
        writer.writeheader()

        for e in ts.readlines():
            n, t = e.split('|')
            t = t.strip()
            tc = clean_title(t)
            
            print('processing', n, t)
            res = get(tc,3)
            result[n] = dict(wiki = res, title = t)
            if res:
                for k,a in enumerate(res):
                    qid = a.get('id','')
                    writer.writerow(dict(title = t,
                                         filename = n,
                                         verbete = f'https://github.com/cpdoc/dhbb/blob/master/text/{n}.text',
                                         seq = k,
                                         qid = qid,
                                         qurl = a.get('concepturi',''),
                                         qlabel = a.get('label',''),
                                         qcountry = get_country(qid),
                                         qdescr = a.get('description','')))
            else:
                writer.writerow(dict(title = t,
                                     filename = n,
                                     verbete = f'https://github.com/cpdoc/dhbb/blob/master/text/{n}.text'))
                    
    with open(f"{fout}.json", "w") as outfile:
        json.dump(result, outfile)


def main3(fin, fout):
    result = {}

    with open(fin) as ts, open(f'{fout}.csv', "w", newline='') as csvfile:

        fields = ['title','seq','qid','qurl','qlabel','qcountry','qdescr']
        writer = csv.DictWriter(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL,
                                fieldnames = fields)
        writer.writeheader()

        for t in ts.readlines():
            t = t.strip()
            
            print('processing', t)
            res = get(t,3)
            result[t] = dict(wiki = res)
            if res:
                for k,a in enumerate(res):
                    qid = a.get('id','')
                    writer.writerow(dict(title = t,
                                         seq = k,
                                         qid = qid,
                                         qurl = a.get('concepturi',''),
                                         qlabel = a.get('label',''),
                                         qcountry = get_country(qid),
                                         qdescr = a.get('description','')))
            else:
                writer.writerow(dict(title = t))
                    
    with open(f"{fout}.json", "w") as outfile:
        json.dump(result, outfile)

        
main1(sys.argv[1], sys.argv[2])


