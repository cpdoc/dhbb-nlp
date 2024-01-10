import csv
import sys

import sqlite3
from wikimapper import WikiMapper


conn = sqlite3.connect('data/index_ptwiki-latest.db')


def q(s):
    cursor = conn.cursor()
    query = "SELECT wikidata_id FROM mapping WHERE wikipedia_title LIKE ?"
    res = cursor.execute(query, (f"{s}",))
    return list(set([a[0] for a in res]))
    
def read_tsv_file(file_path):
    data = []
    with open(file_path, 'r', newline='', encoding='utf-8') as tsvfile:
        reader = csv.reader(tsvfile, delimiter='\t')
        for row in reader:
            data.append(row)
    return data

data = read_tsv_file('dhbb-full.tsv')
stops = 'de do da dos e o a das na nos em'

for d in data:
    try:
        title = d[1]
        if d[2] == 'biográfico':
            tmp = title.split(',')
            tmp = tmp[::-1]
            tmp = [w.strip().lower().split(' ') for w in tmp]
            res = []
            for p in tmp:
                p1 = [w for w in p if w not in stops.split(' ')]
                res.append('%'.join(p1))
            tmp = "%".join(res)
        else:
            tmp = title.split(' ')
            tmp = [w.strip().lower() for w in tmp]
            tmp = [w for w in tmp if w not in stops.split(' ')]
            tmp = [w for w in tmp if not w.startswith('(')]
            tmp = "%".join(tmp)
    except TypeError as e:
        print(e, d, tmp)
        sys.exit(1)
    print(f"{d[0]}\t[{d[1]}]\t[{tmp}]\t{q(tmp)}\t{d[2]}")
    
    
# title = "Cícero_de_Vasconcelos"
# mapper = WikiMapper("data/index_ptwiki-latest.db")
# wikidata_id = mapper.title_to_id(title)
# print(title, wikidata_id) 
