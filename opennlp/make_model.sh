#!/bin/bash

ONLP=$1

wget https://github.com/UniversalDependencies/UD_Portuguese-Bosque/raw/master/pt_bosque-ud-train.conllu

$ONLP/bin/opennlp SentenceDetectorConverter conllu -sentencesPerSample 10 -data pt_bosque-ud-train.conllu > bosque_train.sent

cat bosque_train.sent amostras_dhbb.sent > arquivo_treino.sent

$ONLP/bin/opennlp SentenceDetectorTrainer -lang portuguese -model bosque_model.opennlp -data arquivo_treino.sent -encoding utf-8 -params param.txt

rm arquivo_treino.sent bosque_train.sent pt_bosque-ud-train.conllu 
