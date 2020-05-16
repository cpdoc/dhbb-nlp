#!/usr/bin/bash

udpipe --train --tokenizer --tagger --parser="transition_system=swap;transition_oracle=static_lazy" model_enhanced.bin --heldout=data_dev.conllu data_train.conllu

echo "Generating accuracy statistics...\n"

udpipe --accuracy --tokenize --tag --parse model_enhanced.bin data_test.conllu > acc_actual_model.tmp

udpipe --accuracy --tokenize --tag --parse model_enhanced.prev data_test.conllu > acc_prev_model.tmp

echo "Accuracy newest model:" > acc1.tmp

echo "Accuracy previous model:" > acc2.tmp

cat acc1.tmp acc_actual_model.tmp acc2 acc_prev_model.tmp > accuracy.txt

rm *.tmp
