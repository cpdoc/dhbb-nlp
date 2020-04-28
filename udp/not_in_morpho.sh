MORPHO_DIR=~/work/morpho-br/verbs

# gera um arquivo ordenado verbs.verb contendo todos os lemas de
# verbos que ocorrem nos arquivos .conllu
awk '$4 ~ /VERB/ {print $3}' *.conllu | sort | uniq -c | awk '{print $2,$1}' | sort > verbs.dhbb
awk '$4 ~ /VERB/ {print tolower($2),$3}' *.conllu | sort | uniq -c | awk '{print $2,$3,$1}' | sort > tverbs.dhbb

# extrai os verbos do morphoBr no formato infinitivo e cria um arquivo
# morpho.verb com os verbos ordenados
awk '{split($2,a,/\+/); print a[1]}' $MORPHO_DIR/*.dict | sort | uniq > verbs.morpho
awk '{split($2,a,/\+/); print $1,a[1]}' $MORPHO_DIR/*.dict | sort | uniq -c | awk '{print $2,$3,$1}' | sort  > tverbs.morpho

# cria um arquivo com os lemas que estão em verbs.verb e não estão no
# morpho.verb
join -v 1 verbs.dhbb verbs.morpho > verb-lemmas-not-morpho.tsv

# now by form instead of lemma
join -v 1 tverbs.dhbb tverbs.morpho > verb-forms-not-morpho.tsv
rm verbs.dhbb tverbs.dhbb verbs.morpho tverbs.morpho
