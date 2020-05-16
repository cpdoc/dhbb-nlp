#!/usr/bin/bash


#precisa instalar word2vec pip3 install cython word2vec 

BOSQUE_PATH=/media/lucas/Lucas/work/UD_Portuguese-Bosque

#transforma o dado de treino para o formato aceito pelo modelo word2vec
udpipe --output=horizontal model_enhanced.bin $BOSQUE_PATH/pt_bosque-ud-train.conllu > word2vec.train

#treina o modelo word2vec
word2vec -train word2vec.train -output word2vec.model -cbow 0 -size 50 -window 10 -negative 5 -hs 0 -sample 1e-1 -threads 12 -binary 0 -iter 15 -min-count 2 

echo ""

rm word2vec.train
