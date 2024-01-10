
import csv
import sys
import random
from urllib.parse import urlencode

import sqlite3
from wikimapper import WikiMapper

# title = "Cícero_de_Vasconcelos"
# mapper = WikiMapper("data/index_ptwiki-latest.db")
# wikidata_id = mapper.title_to_id(title)
# print(title, wikidata_id) 

# pending: para cada tipo temático/biográfico, selecionar 25 com
# wikidata e 25 sem wikidata. construir google docs com 4 abas, a
# partir qid produzir links https://www.wikidata.org/wiki/Q10299222
#
# Para casos sem qid, podemos criar URL
# https://www.google.com/search?q=CONSELHO+NACIONAL+DE+MINAS+E+METALURGIA&ie=UTF-8&oe=UTF-8

conn = sqlite3.connect('data/index_ptwiki-latest.db')


def q(s):
    cursor = conn.cursor()
    query = "SELECT wikidata_id FROM mapping WHERE wikipedia_title LIKE ?"
    res = cursor.execute(query, (f"{s}",))
    return list(set([a[0] for a in res]))
    
def read_tsv(file_path):
    data = []
    with open(file_path, 'r', newline='', encoding='utf-8') as tsvfile:
        reader = csv.reader(tsvfile, delimiter='\t')
        for row in reader:
            data.append(row)
    return data


def sample(regs, filename):
    print("log",filename, len(regs))
    assert len(regs) > 25
    rs = random.sample(regs, 25)
    out = []

    for r in rs:
        encoded_title = urlencode({"q": r[1]})
        url_full = "https://www.google.com/search?{}".format(encoded_title)
        fst = True

        if len(r[4]) == 0:
            line = [r[0], r[1], url_full, r[2], r[3], "-"]
            out.append(line)
        else:
            for q in r[4]:
                if fst:
                    line = [r[0], r[1], url_full, r[2], r[3], f"https://www.wikidata.org/wiki/{q}"]
                    fst = False
                else:
                    line = ["-" , "-" , "-"     , "-" , "-" , f"https://www.wikidata.org/wiki/{q}"]
                out.append(line)
        
    with open(filename, 'w', newline='') as csvfile:
        csv_writer = csv.writer(csvfile)
        csv_writer.writerows(out)
        
    

data = read_tsv('dhbb-full.tsv')
stops = 'de do da dos e o a das na nos em'.split(' ')

regs = []
for d in data:

    title = d[1]
    if d[2] == 'biográfico':
        tmp = title.split(',')
        tmp = tmp[::-1]
        tmp = [w.strip().lower().split(' ') for w in tmp]
        tmp = [item.strip() for sublist in tmp for item in sublist] # flat
        tmp = [w for w in tmp if w not in stops and not w.startswith('(')]
        tmp = "%".join(tmp)
    else:
        tmp = title.split(' ')
        tmp = [w.strip().lower() for w in tmp]
        tmp = [w for w in tmp if w not in stops and not w.startswith('(')]
        tmp = "%".join(tmp)

    qids = q(tmp)
    r = (d[0], d[1], d[2], tmp, qids)
    print("processing", r)            
    regs.append(r)


sample([r for r in regs if r[2] == 'biográfico' and len(r[4]) > 0], "bq.csv")
sample([r for r in regs if r[2] == 'biográfico' and len(r[4]) == 0], "bnq.csv")
sample([r for r in regs if r[2] == 'temático' and len(r[4]) == 0], "tnq.csv")
sample([r for r in regs if r[2] == 'temático' and len(r[4]) > 0], "tq.csv")

