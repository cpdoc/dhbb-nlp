#! /usr/bin/python3

import sys
sys.path.append('/home/fcbr/repos/freeling-3.1/APIs/python')
sys.path.append('/home/fcbr/freeling-3.1/APIs/python')
sys.path.append('/home/fchalub/repos/freeling-3.1/APIs/python')
import freeling

## Modify this line to be your FreeLing installation directory
FREELINGDIR = "/usr/local";
#FREELINGDIR = "/home/fchalub/bin/freeling";
DATA = FREELINGDIR+"/share/freeling/";
LANG="pt";

freeling.util_init_locale("default");

# create language analyzer
la=freeling.lang_ident(DATA+"common/lang_ident/ident.dat");

# create options set for maco analyzer. Default values are Ok, except for data files.
op= freeling.maco_options("es");
op.set_active_modules(False,True,True,True,True,True,True,True,True,True);
op.set_data_files("",DATA+LANG+"/locucions.dat", DATA+LANG+"/quantities.dat", 
                  DATA+LANG+"/afixos.dat", DATA+LANG+"/probabilitats.dat", 
                  DATA+LANG+"/dicc.src", DATA+LANG+"/np.dat",  
                  DATA+"common/punct.dat");

# create analyzers
tk=freeling.tokenizer(DATA+LANG+"/tokenizer.dat");
sp=freeling.splitter(DATA+LANG+"/splitter.dat");
mf=freeling.maco(op);

tg=freeling.hmm_tagger(DATA+LANG+"/tagger.dat",True,2);
sen=freeling.senses(DATA+LANG+"/senses.dat");
num = freeling.numbers("pt", ",", ".")
dates = freeling.dates("pt")


# parser= freeling.chart_parser(DATA+LANG+"/chunker/grammar-chunk.dat");
# dep=freeling.dep_txala(DATA+LANG+"/dep/dependences.dat", parser.get_start_symbol());

f = open(sys.argv[1],'r')
o = open(sys.argv[1]+'.out', 'w')

lin=f.readline();
# print ("Text language is: "+la.identify_language(lin,["es","ca","en","it"])+"\n");

while (lin) :
    l = tk.tokenize(lin)
    ls = sp.split(l,False)
    ls = num.analyze(ls)
    ls = dates.analyze(ls)
    ls = mf.analyze(ls)
    ls = tg.analyze(ls)
    ls = sen.analyze(ls)
    # ls = parser.analyze(ls);
    # ls = dep.analyze(ls);

    for s in ls :
       
       ws = s.get_words();
       
       sentence = " ".join([w.get_form() for w in ws])

       o.write("\n")
       o.write("# %s\n" % sentence)
       
       for w in ws :
           o.write("%s\t%s\t%s\t%s\t%s\n" % (w.get_form(),w.found_in_dict(),w.get_lemma(),w.get_tag(),w.get_senses_string()));


       # tr = s.get_parse_tree();
       # printTree(tr.begin(), 0);
       # dp = s.get_dep_tree();
       # printDepTree(dp.begin(), 0)

    lin=f.readline();
    
