#!/usr/bin/bash

SENT_PATH=../sents



sbcl --load add-file.lisp --eval '(in-package :working)' --eval '(write-from-revised (collect-revised #P"*.conllu"))' --non-interactive

echo "Sentenças revisadas foram coletadas...\n"
echo "Aplicando o parser Udpipe no diretório sents...\n"


udpipe_server 8000 model_enhanced.bin model_enhanced.bin model_enhanced.bin "" --daemon 

for file in $SENT_PATH/*.sent; do
    cp $file tmp;
    curl -F data=@tmp -F model=model_enhanced.bin -F tokenizer="presegmented" -F tagger= -F parser= http://localhost:8000/process | PYTHONIOENCODING=utf-8 python -c "import sys,json; sys.stdout.write(json.load(sys.stdin)['result'])" > ../$(basename $file .sent).conllu;
    rm tmp
done


echo "Retornando sentenças revisadas para seus respectivos lugares...\n"

sbcl --load add-file.lisp --eval '(in-package :working)' --eval '(to-udp #P"./frases_rev.tmp" #P"../")' --non-interactive

echo "Pronto.\n"

rm frases_rev.tmp
