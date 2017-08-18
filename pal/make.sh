#!/bin/bash

for f in ../raw/*.raw; do
    BASE=`basename $f .raw`; 
    cat ../raw/$BASE.raw | /opt/palavras/por.pl --role > $BASE.role.1 ;
    awk -f clean.awk $BASE.role.1 > $BASE.role.2;
    awk -f broken-tags.awk $BASE.role.2 > $BASE.role;
    cat ../raw/$BASE.raw | /opt/palavras/por.pl --udep > $BASE.conllu.1 ;
    awk -f clean.awk $BASE.conllu.1 > $BASE.conllu;    
    rm $BASE.role.? $BASE.conllu.?;
done

# cat $BASE.role | /opt/palavras/bin/visldep2malt.pl --lang pt | /opt/palavras/bin/extra2sem > $BASE.malt ;

# Two files (*.role equivalent) manually edited:
# 2432.conllu 6	XXX	_	[]	<cjt>|<*>|<heur>|§PAT	N|M|S	4	@<ACC	_	_
# 5802.conllu 150	XXX	_	[]	<prop>|<*>|<heur>|<np-close>|§ATR	N|M|S	147	@N<PRED	_	_

# newlex_pt edited to remove arrebol, still wrong, should be PROP:
# 2877.conllu 10	Arrebol	arrebol	_	<*>|<newlex>|<DE:Abendröte>	_	0	_	_	_
