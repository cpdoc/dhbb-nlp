#!/usr/bin/python3

import sys
import random

def search_file(blocks, search):
    result = []
    for block in blocks:
        lines = block.strip().split('\n')
        phrase = lines[0]
        words = [w.strip() for w in lines[1:]]
        wfs = [wf.split('\t')[0].strip().casefold() for wf in words]
        if search.casefold() in wfs:
            result.append((phrase, words, w))
    return random.choice(result)

def read_words(filename):
    with open(filename, 'r') as f:
        return [l.strip() for l in f.readlines()]

with open(sys.argv[2],'r') as f:
    blocks = f.read().split('\n\n')
    for w in read_words(sys.argv[1]):
        s = search_file(blocks, w)
        print()
        print("%s {%s}\n" % (s[0],s[2]))
        for w in s[1]:
            print(w)
    
# ./select-random-phrases.py selected-words.txt all+phrases.out
