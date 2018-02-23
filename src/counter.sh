
# Code used for the LREC 2018 article

# cd ~/work/cpdoc/dhbb-nlp/udp

grep "text =" *.conllu > tmp.sents
grep "text =" {1..35}.conllu > tmp35.sents

time grep -f ../../dhbb/dic/pessoa-individuo.txt -o tmp35.sents > out35.people
time grep -f ../../dhbb/dic/organizacao.txt -o tmp35.sents > out35.orgs

time ls {1..35}.conllu | xargs ~/work/hs-conllu/countlex ~/work/cpdoc/dhbb-nlp/bin/tokenizations ~/work/cpdoc/dhbb/dic/organizacao.txt > out35.hs.orgs 2> out35.hs.orgs.error
time ls {1..35}.conllu | xargs ~/work/hs-conllu/countlex ~/work/cpdoc/dhbb-nlp/bin/tokenizations ~/work/cpdoc/dhbb/dic/pessoa-individuo.txt > out35.hs.people 2> out35.hs.people.error

time grep -f ../../dhbb/dic/pessoa-individuo.txt -o tmp.sents > out.people
time grep -f ../../dhbb/dic/organizacao.txt -o tmp.sents > out.orgs

time ls *.conllu | xargs ~/work/hs-conllu/countlex ~/work/cpdoc/dhbb-nlp/bin/tokenizations ~/work/cpdoc/dhbb/dic/organizacao.txt > out.hs.orgs 2> out.hs.orgs.error
time ls *.conllu | xargs ~/work/hs-conllu/countlex ~/work/cpdoc/dhbb-nlp/bin/tokenizations ~/work/cpdoc/dhbb/dic/pessoa-individuo.txt > out.hs.people 2> out.hs.people.error

# awk '$4 ~ /PROPN/ && $8 !~ /flat|compound/ {print FILENAME,$1,$2,$8}' *.conllu | wc -
# awk '$4 ~ /PROPN/ && $8 !~ /flat|compound/ {print FILENAME,$1,$2,$8}' {1..35}.conllu | wc -l


