# Relatório

Comecei explorando o arquivo de modelo treinado do NLTK. Para isso, em um terminal python, eu segui os passos:

Importações necessárias:
`import nltk.tokenize.punkt, pickle`

Leitura do arquivo do modelo: `arq=open("model_punkt.pickle","rb")`

Carregamento do modelo: `model=pickle.load(arq)`

Uma vez carregado, o modelo treinado pode ser inspecionado por seus diversos parâmetros, acessíveis por `model._params`. Dentre esses parâmetros, um dos mais relevantes para a quebra de sentenças são as abreviações aprendidas.

Carragado esse modelo, realizar a quebra de sentenças se resume a executar `model.sentences_from_text()` 

Inspecionando a lista de abreviações, notei que boa parte dos itens aprendidos não correspondiam a coisas que eu identificava como abreviações (não cheguei a quantificar precisamente).

Busquei depois no corpus processado pelo NLTK por sentenças que se iniciavam por letra minúscula na tentativa de localizar erros por ausencia de abreviações no aprendizado do modelo. O total encontrado foi de 449 casos, listados no arquivo "lista_normal".

Destas, encontrei várias ocasiões onde, por exemplo, o método quebrou a sentença em um S.A. no meio de uma frase erroneamente. Por meio do método `model._params.abbrev_types.add()`, acrescentei a abreviação mencionada para verificar qual seria a alteração no corpus. Como resultado, a nova quantidade de casos resultantes da pesquisa em questão foi de 267, listados em "lista_alterado".

A hipótese levantada em questão foi de que o aprendizado do NLTK não foi tão eficiente quanto o destrinchamento manual dos parâmetros como é feito no NLTK. Outra hipótese é de que, substituindo o modelo de aprendizado por uma inserção manual dos mesmos paretros, a classificação de ambas ferramentas sejam intimamente semelhantes.