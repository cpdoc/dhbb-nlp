MORPHO_DIR=~/work/MorphoBr/verbs

#Gera um arquivo ordenado verbs.verb contendo todos os lemas de verbos que ocorrem nos arquivos .conllu
awk '$4 ~ /VERB/ {print tolower($3)}' *.conllu > verbs.verb
sort verbs.verb > verbs.temp
uniq verbs.temp > verbs.verb

#Extrai os verbos do morphoBr no formato infinitivo e cria um arquivo morpho.verb com os verbos ordenados
awk 'gsub("[+A-Z0-9]","",$2) {print $2}' $MORPHO_DIR/*.dict > morpho.verb
sort morpho.verb -o morpho.verb
uniq morpho.verb > morpho.temp
mv morpho.temp morpho.verb

#Cria um arquivo com os lemas que estão em verbs.verb e não estão no morpho.verb 
comm -31 morpho.verb verbs.verb > not_verbs.verb

#Cria um arquivo contendo a frequência dos verbos que não estão no morphoBr
grep -F -x -v -f morpho.verb verbs.temp > not_verbs.tmp
uniq -c not_verbs.tmp | sort -nr > not_verbs.count

rm verbs.temp not_verbs.tmp
