from conllu import parse
import json, os

'''
Compara as entidades geradas em dhbb-json com as análises sintáticas geradas pelo udp em dhbb-nlp e cria um log das entidades que não estão em uma subárvore na análise do udpipe.
A premissa é que tais entidades estão erroneamente classificadas nos conllu.
'''

###Funções para decidir se determinado MWT está corretamente analisado em um arquivo .conllu

def get_subtree_aux(tree,token, list_):
    for t in tree:
        if t == token:
            continue
        if t['head'] == token['id']:
            list_.append(t)
            get_subtree_aux(tree,t,list_)
            
def check_mwt(token):
    if type(token['id']) != int:
        return True
    return False
    
def get_subtree(tree,token):
    l = []
    get_subtree_aux(tree,token,l)
    l.append(token)
    return l

def get_subtokens(tree,token):
    subtree = get_subtree(tree,token)
    subtree.sort(key=lambda k: k['id'])
    tokens = [x['form'] for x in subtree]
    return tokens

def get_tree(verbete_path,token,position=False,get_first=True):
    #token = token.split()
    verbete = parse(open(verbete_path).read())
    sents = []
    for tree in verbete:
        if token in tree.metadata['text']:
            if position:
                if not get_first:
                    sents.append(tree.metadata['sent_id'])
                else:
                    return tree.metadata['sent_id']
            elif not get_first:
                sents.append(tree)
            else:
                return tree
    if not get_first:
        return sents
    return 0

def find_token(tree,token):
    palavras = token.split()
    num = len(palavras)
    tokens = [tree.index(x) for x in tree if x['form'] == palavras[0]]
    for x in tokens:
        i = 1
        stop = True
        resultado = []
        resultado.append(tree[x])
        if check_mwt(tree[x]):
            x = tree.index(find_by_id(tree,max((y for y in tree[x]['id'] if type(y) == int))))
        if type(tree[x]['id']) != int:
            pos = max((y for y in tree[x]['id'] if type(y) == int))
            init = min((y for y in tree[x]['id'] if type(y) == int))
        else:
            pos = tree[x]['id']
            init = pos
        while i < num:
            tree_int = tree[tree.index(find_by_id(tree,init))+1]
            if palavras[i] != tree_int['form']:
                stop = False
                break
            else:
                resultado.append(tree_int)
            
            if type(tree_int['id']) != int:
                pos = max((y for y in tree_int['id'] if type(y) == int))
                init = max((y for y in tree_int['id'] if type(y) == int)) 
                i-=1
            else:
                pos = tree_int['id'] 
                init = pos
            i+=1
        if stop == True:
            return resultado
    return resultado
            
            
            
            
    
    

def find_by_id(tree,id):
    for x in tree:
        if x['id'] == id:
            return x
    return False


def get_token_list(tree,token):
    lista = find_token(tree,token)
    result = []
    for x in lista:
        if check_mwt(x):
            for id_ in x['id']:
                if type(id_) == int:
                    result.append(find_by_id(tree,id_))
        else:
            result.append(x)    
    return result

def check_name_aux(tree,token):
    ne = get_token_list(tree,token)
    #tokens = get_token_list(tree,token)
    for x in ne:
        intersect = [x for x in get_subtree(tree,x) if x in ne]

        if len(intersect) == len(ne):
            return True
    #    if set(token.split()) <= set(get_subtokens(tree,x)):
    #        return True
    return False

def check_name(path_name,token):
    tree = get_tree(path_name,token)
    if type(tree) == int:
        return 'Not Found'
    return check_name_aux(tree,token)

### Funções para extrair nomes dos arquivos JSON

if __name__ == '__main__':
    path_json = '/media/lucas/Lucas/work/dhbb-json/JSON/'
    path_udp = '/media/lucas/Lucas/work/dhbb-nlp/udp/'
    files = [x.replace('.conllu','') for x in os.listdir('/media/lucas/Lucas/work/dhbb-nlp/udp') if '.conllu' in x]
    dic = {}
    file_ = open('entidades.log','w')
    cont1 = 0
    for arq in files:
        cont1+=1
        cont2=0
        data = json.load(open(path_json+arq+'.json'))
        ne = [x for x in data['entities'] if len(x['text'].split()) > 1]
        for js in ne:
            cont2+=1
            token = js['text'].replace('\n',' ')
            if token == '' or token == ' ':
                print("Encontrado token nulo: arquivo {}".format(arq+".json"))
            try:
                boo = check_name(path_udp+arq+'.conllu',token)
            except:
                print("Erro na execução: token {}, arquivo {}.".format(token,arq))
                file_.write('token="{}" file={}.conllu sent_id={} tipo={} status=ERROR_EXEC\n'.format(token,arq,numero,js['type']))
                continue
            if boo == False:
                numero = get_tree(path_udp+arq+'.conllu',token,position=True,get_first=True)
                #print('Token "{}" provavelmente mal analisado no arquivo {}, sentença número {}.\n'.format(token,arq,numero))
                file_.write('token="{}" file={}.conllu sent_id={} tipo={} status=OK\n'.format(token,arq,numero,js['type']))
                if js['type'] not in dic.keys():
                    dic['type'] = {'correto':0,'errado':1}
                else:
                    dic['type']['errado']+=1
            else:
                if js['type'] not in dic.keys():
                    dic['type'] = {'correto':1,'errado':0}
                else:
                    dic['type']['correto']+=1    
            print('Arquivo {}, numero {} de {}, {}% completo...'.format(arq,cont1,len(files), 100*round(cont2/len(ne),2)),end='\r')
    for x in dic.keys():
        print("Tipo: {}, Total: {}, Análises corretas: {}, Análises erradas: {}\n".format(x,dic[x]['correto']+dic[x]['errado'],dic[x]['correto'],dic[x]['errado']))
                
    
    
    
    
'''text= 'regional do Serviço'
tree = get_tree('udp/5584.conllu',text)
print(check_name_aux(tree,text))
#print(find_token(tree,'novembro de 1968'))
##print(check_name('../dhbb-json/JSON/teste.conllu','Aliança Renovadora Nacional'))
#print(tree)
'''
    
