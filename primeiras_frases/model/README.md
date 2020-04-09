Para extrair as frases revisadas do conjunto de frases em revisão, execute

```
python3 extrair_frases.py > frases_treino.conllu 2> frases_teste.sent
```

Para resetar o índice sent_id do frases_target.conllu, execute

```
awk '{if ($0 ~ /sent_id/) {print "# sent_id = ",i=i+1} else {print $0}}' frases_target.conllu > frases_target.temp
mv frases_target.tmp frases_target.conllu
```

Baixe o conjunto de treino do [UD-Bosque](https://github.com/UniversalDependencies/UD_Portuguese-Bosque/):
```
wget https://github.com/UniversalDependencies/UD_Portuguese-Bosque/raw/master/pt_bosque-ud-train.conllu
```

Una os dois arquivos

```
cat pt_bosque-ud-train.conllu frases_revisadas.conllu > train_data.conllu
```

Use o novo conjunto de dados para treinar um novo modelo do UDpipe

```
udpipe --train model_enhanced.bin train_data.conllu
```

Para treinar o modelo usando apenas os dados do Bosque, execute

```
udpipe --train model_bosque.bin pt_bosque-ud-train.conllu
```

Para analisar o conjunto de teste com os modelos, digite

```
udpipe --tokenize --tag --parse nome_modelo.bin frases_target.sent
```



