#!/usr/bin/bash

BOSQUE_DIR="/media/lucas/Lucas/work/UD_Portuguese-Bosque"

sbcl --load add-file.lisp --eval '(in-package :working)' --eval '(write-from-revised (collect-revised #P"*.conllu"))' --non-interactive


echo "Creating datasets...\n"

sbcl --load add-file.lisp --eval '(in-package :working)' --eval '(gen-dataset #P"./frases_rev.tmp")' --non-interactive

cat "$BOSQUE_DIR/pt_bosque-ud-train.conllu" gold_train.conllu > data_train.conllu

cat "$BOSQUE_DIR/pt_bosque-ud-test.conllu" gold_test.conllu > data_test.conllu

cat "$BOSQUE_DIR/pt_bosque-ud-dev.conllu" gold_dev.conllu > data_dev.conllu

echo "Datasets created...\nTrain set: data_train.conllu \nTest set: data_test.conllu \nDev set: data_dev.conllu\n"

rm gold_*

echo "Treinando o modelo...\n"

cp model_enhanced.bin model_enhanced.prev

# https://github.com/ufal/udpipe/issues/128
udpipe --train --tokenizer --tagger --parser="transition_system=swap;transition_oracle=static_lazy" model_enhanced.bin --heldout=data_dev.conllu data_train.conllu

echo "Generating accuracy statistics...\n"

udpipe --accuracy --tokenize --tag --parse model_enhanced.bin data_test.conllu > acc_actual_model.tmp

udpipe --accuracy --tokenize --tag --parse model_enhanced.prev data_test.conllu > acc_prev_model.tmp

echo "Accuracy newest model:" > acc1.tmp

echo "Accuracy previous model:" > acc2.tmp

cat acc1.tmp acc_actual_model.tmp acc2 acc_prev_model.tmp > accuracy.txt

rm *.tmp frases_rev.tmp

