Para extrair as frases revisadas do conjunto de frases em revisão, execute

´´´
python3 extrair_frases.py > frases_revisadas.conllu
´´´

Baixe o conjunto de treino do [UD-Bosque](https://github.com/UniversalDependencies/UD_Portuguese-Bosque/):

´´´
wget https://github.com/UniversalDependencies/UD_Portuguese-Bosque/raw/master/pt_bosque-ud-train.conllu
´´´

Una os dois arquivos

´´´
cat pt_bosque-ud-train.conllu frases_revisadas.conllu > train_data.conllu
´´´

Use o novo conjunto de dados para treinar um novo modelo do UDpipe
