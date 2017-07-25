
for f in ../raw/*.raw; do
    BASE=$(basename $f .raw)
    cat ../raw/$BASE.raw | /opt/palavras/por.pl --role > $BASE.tmp ;
    awk -f clean.awk $BASE.tmp > $BASE.tmp1;
    awk -f broken-tags.awk $BASE.tmp1 > $BASE.tmp2;
    mv $BASE.tmp2 $BASE.role;
    rm $BASE.tmp*;
    # cat $BASE.role | /opt/palavras/bin/visldep2malt.pl --lang pt | /opt/palavras/bin/extra2sem > $BASE.malt ;
done

# Two files (*.role equivalent) manually edited:
# 2432.conllu 6	XXX	_	[]	<cjt>|<*>|<heur>|§PAT	N|M|S	4	@<ACC	_	_
# 5802.conllu 150	XXX	_	[]	<prop>|<*>|<heur>|<np-close>|§ATR	N|M|S	147	@N<PRED	_	_

# newlex_pt edited to remove arrebol, still wrong, should be PROP:
# 2877.conllu 10	Arrebol	arrebol	_	<*>|<newlex>|<DE:Abendröte>	_	0	_	_	_
