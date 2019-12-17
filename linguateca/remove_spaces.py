import os
try:
    os.mkdir("treated_raw")
except:
    print("Pasta treated_raw já existe, pulando etapa...")
try:
    os.mkdir("PLNbase")
except:
    print("Pasta PLNbase já existe, pulando etapa...")
    
i = 0
for x in os.listdir("raw"):
    file = open("raw/"+x,'r').read()
    file = file.replace("\n\n", '<!!>')
    file = file.replace("\n",' ')
    file = file.replace("<!!>", '\n')
    arq = open("treated_raw/"+x,'w')
    arq.write(file)
    i+=1
    print("{}% loaded...".format(round(100*i/len(os.listdir("raw")),2)),end='\r')
    
    
print("Done.")
