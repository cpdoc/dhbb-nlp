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

# Recuperando as frases gold

Caso queira recuperar as frases "gold" do repositório, basta rodar

``` sh pull_gold.sh ```

# Inserindo frases gold

Caso queira **inserir** frases gold no repositório, coloque-as em um arquivo chamado **frases_rev.tmp**, onde no **o primeiro metadato de cada sentença deve ser da forma:**

``` file = x.conllu ```

indicando o arquivo de origem da frase. Isso é para evitar o código ler todo o repositório para devolver as frases. 

# Batches

Como os golds são gerados por motivos específicos, é inserido um outro metadado chamado *batch*, que consta as levas de gold que criamos. Atuelmente temos as batches:

1. Batch 1: Correção das primeiras frases de alguns verbetes, contendo informação sobre naturalidade, nascimento e família de políticos.
1. Batch 2: Correção de frases onde corrigimos inicialmente o POS tagging, com a finalidade de tentar melhorar o output do parser.
