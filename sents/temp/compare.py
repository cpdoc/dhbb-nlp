#Descerializa lista normal
with open("lista_normal.out", "r") as normal:
	lista=[]
	for line in normal:
		lista.append(line[:-1])
normal=[]
for i in range(0,len(lista),3):
	normal.append((int(lista[i][:-5]),int(lista[i+1])))

#Descerializa lista alterada
with open("lista_alterado.out", "r") as alterada:
	lista=[]
	for line in alterada:
		lista.append(line[:-1])
alterada=[]
for i in range(0,len(list),3):
	alterada.append((int(lista[i][:-5]),int(lista[i+1])))

#Encontra itens da alterada que não estavam na normal

lista=

