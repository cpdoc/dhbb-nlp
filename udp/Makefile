
SRC=../raw
URL=http://lindat.mff.cuni.cz/services/udpipe/api/process
MODEL=portuguese-bosque-ud-2.12-230717
CMD=PYTHONIOENCODING=utf-8 python -c "import sys,json; sys.stdout.write(json.load(sys.stdin)['result'])"

.PHONY: all clean

%.conllu : $(SRC)/%.raw
	curl -F data=@$< -F model=$(MODEL) -F tokenizer= -F tagger= -F parser= $(URL) | $(CMD) > $@

all : $(patsubst %.raw, %.conllu, $(notdir $(wildcard $(SRC)/*.raw)))

clean:
	rm *.conllu
