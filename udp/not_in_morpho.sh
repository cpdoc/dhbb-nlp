MORPHO_DIR=~/work/morpho-br/verbs

# gera um arquivo ordenado verbs.verb contendo todos os lemas de
# verbos que ocorrem nos arquivos .conllu
awk '$4 ~ /VERB/ {print $3}' *.conllu | sort | uniq -c | awk '{print $2,$1}' | sort > verbs.dhbb

# extrai os verbos do morphoBr no formato infinitivo e cria um arquivo
# morpho.verb com os verbos ordenados
awk '{split($2,a,/\+/); print a[1]}' $MORPHO_DIR/*.dict | sort | uniq > verbs.morpho

# cria um arquivo com os lemas que estão em verbs.verb e não estão no
# morpho.verb
comm -31 verbs.morpho verbs.dhbb > verbs.not_in_morpho

