
SRC=../../dhbb/text

.PHONY: all clean

%.raw : $(SRC)/%.text
	gawk -f extract.awk $< > $@

all : $(patsubst %.text, %.raw, $(notdir $(wildcard $(SRC)/*.text)))

clean:
	rm *.raw
