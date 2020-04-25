SENT_PATH=../sents

udpipe_server 8888 model_enhanced.bin model_enhanced.bin model_enhanced.bin "" --daemon 

for file in $SENT_PATH/*.sent; do 
    curl -F data=@$file -F model=model_enhanced.bin -F tokenizer="presegmented" -F tagger= -F parser= http://localhost:8888/process | PYTHONIOENCODING=utf-8 python -c "import sys,json; sys.stdout.write(json.load(sys.stdin)['result'])" > $(basename $file .sent).conllu;
done
