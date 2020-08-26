
clean:
	find . -name '*.sent' | xargs rm
	find . -name '*.diff' | xargs rm

all:
	../src/sent-segment.sh -m ../src/model_opennlp.bin -i ../raw -o ../sents
	python ../src/sent-segment.py -m ../src/model_punkt.pickle -v ../raw/ ../sents/
	./consolidate.sh

