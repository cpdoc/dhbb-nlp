#!/usr/bin/bash

sh gen_dataset.sh
sh word2vec.sh
mv model_enhanced.bin model_enhanced.prev

udpipe --train --tokenizer --tagger --parser="transition_system=swap;transition_oracle=static_lazy" model_enhanced.bin --heldout=data_dev.conllu datas_train.conllu

SENT_PATH=../sents

udpipe_server 8888 model_enhanced.bin model_enhanced.bin model_enhanced.bin "" --daemon 

for file in $SENT_PATH/*.sent; do
    mv $file > tmp;
    curl -F data=@tmp -F model=model_enhanced.bin -F tokenizer="presegmented" -F tagger= -F parser= http://localhost:8888/process | PYTHONIOENCODING=utf-8 python -c "import sys,json; sys.stdout.write(json.load(sys.stdin)['result'])" > $(basename $file .sent).conllu;
    rm tmp
done


