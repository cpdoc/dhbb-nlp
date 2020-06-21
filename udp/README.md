# Introdução

Esse diretório contém os verbetes do DHBB já segmentados e analisados pelo UDPipe, que se encontram na pasta ```dhpp-nlp/sents```. 

Algumas frases dos arquivos **.conllu** foram revisadas manualmente, sendo consideradas *gold standard*. ```

# Análises com a ajuda do [MorphoBr](https://github.com/LFG-PTBR/MorphoBr)

Os verbos (tanto os tokens quanto os lemas) produzidos pela análise do UDPipe foram comparados com os verbos contidos no MorphoBr. 
Fizemos uma lista com os verbos gerados pelo UDpipe que não se encontram no MorphoBr, sendo possíveis erros do parser.
Para gerar as listas de verbos e suas estatísticas, faça

``` sh not_in_morpho.sh ```

Lembrando de atualizar a variável **MORPHO_DIR** em seu diretório local.

# Atualizando o repositório a partir do diretório RAW

Na pasta opennlp, re-segmente o diretório RAW utilizando o Makefile e re-coloque os arquivos que consideramos com segmentação correta utilizando o arquivo 

```to_sents.sh```

Rode neste diretório o arquivo

```update_udp.sh```



# Pipeline de treino

O modelo usado pelo UDPipe é treinado com:
1. Os dados do [UD-Bosque](https://github.com/UniversalDependencies/UD_Portuguese-Bosque).
1. As frases *gold standard* que existem neste diretório.

Para treinar o modelo, rode

``` sh train_model.sh ```


Lembrando que para rodar o modelo, é necessário o data_set de treino e dev. 

O parser treinado pelo UDPipe é configurado com o sistema de transição *swap* que permite a criação de árvores sintáticas não projetivas. 


