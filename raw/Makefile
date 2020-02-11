
SRC=../../dhbb/text

.PHONY: all clean

%.raw : $(SRC)/%.text
	awk -f extract.awk $< > $@

all : $(patsubst %.text, %.raw, $(notdir $(wildcard $(SRC)/*.text)))

clean:
	rm *.raw
