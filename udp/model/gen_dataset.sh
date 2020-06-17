#!/usr/bin/bash

BOSQUE_DIR="/media/lucas/Lucas/work/UD_Portuguese-Bosque"

sbcl --load add-file.lisp --eval '(in-package :working)' --eval '(write-from-revised (collect-revised #P"../*.conllu"))' --non-interactive

#sbcl --load add-file.lisp --eval '(in-package :working)' --eval '(to-udp #P"./frases_rev.tmp" #P"../")' --non-interactive

echo "Creating datasets...\n"

sbcl --load add-file.lisp --eval '(in-package :working)' --eval '(gen-dataset #P"./frases_rev.tmp")' --non-interactive

cat "$BOSQUE_DIR/pt_bosque-ud-train.conllu" gold_train.conllu > data_train.conllu

cat "$BOSQUE_DIR/pt_bosque-ud-test.conllu" gold_test.conllu > data_test.conllu

cat "$BOSQUE_DIR/pt_bosque-ud-dev.conllu" gold_dev.conllu > data_dev.conllu

echo "Datasets created...\nTrain set: data_train.conllu \nTest set: data_test.conllu \nDev set: data_dev.conllu\n"

rm gold_*
