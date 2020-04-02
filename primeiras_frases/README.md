### Geração de frases para serem corrigidas

Para gerar o modelo com 250 frases contendo o primeiro parágrafo de verbetes de biografia do DHBB, rode o script **gerar_frases.py**:



```
python3 gerar_frases.py /path/to/raw
```


Para fazer análises de frases sem necessitar criar um arquivo, rode o script udpipe.sh da seguinte forma:

```
./udpipe.sh "Frase para análise" 
```

Para treinar o UDPipe com o Bosque, obtenha o [UDPipe](http://ufal.mff.cuni.cz/udpipe) e a versão mais atual do [Bosque](https://github.com/UniversalDependencies/UD_Portuguese-Bosque).

Rode então o seguinte comando:


```
udpipe --train arquivo_output arquivo_de_treino
```





