import os
from random import shuffle
from sys import argv, exit

"""
Gera um arquivo com 250 entradas das primeiras frases dos arquivos de biografia do DHBB. A geração é aleatória. O resultado é redirecionado ao stdout. 
"""

def words(s):
    '''
    retorna a quantidade de palavras em uma frase. Entende-se por palavra aqui uma string entre 2 espaços
    '''
    return len(s.split(' '))

def checar_biografia(s):
    '''
    Dado um texto do DHBB, retorna True se é a biografia de alguém e False caso contrário. 
    input: string, texto do DHBB
    output: True ou False
    '''
    s = s.replace("\n\n",'__TEMP__').replace("\n",' ').replace('__TEMP__',' ').split()
    if "«" in s[0]:
        return True
    return False

def count(s,char):
    i = 0
    for x in s:
        if x == char:
            i+=1
    return i




if __name__ == '__main__':
    
    try:
        dir_ = argv[1]
        if dir_[-1] != "/":
            dir_ += "/"
    except IndexError:
        print("Necessita do path do diretório raw como argumento. Exemplo: python3 gerar_frases.py path/to/raw")
        exit()
    files = [t for t in os.listdir(dir_) if 'raw' in t]
    sent = []
    shuffle(files)
    i = 0
    log = ''
    for file in files:
        text = open(dir_+file.replace('text','raw'),'r', encoding = 'utf-8').read()
        text_1 = text.replace("\n\n",'__TEMP__').replace('\n',' ')
        sent_text = text_1.split('__TEMP__')
        if checar_biografia(text):
            if count(sent_text[0][1:],'.') == 1:
                if words(sent_text[0][1:]) >= 15:
                    log += sent_text[0][1:] + '\n'
                    i+=1
        if i >= 250:
            log = log[:-1]
            break
    print(log)
