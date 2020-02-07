
SRC=../../dhbb/text
vpath  %.text $(SRC)

.PHONY: all clean

%.raw : %.text
	awk -f extract.awk $< > $@

all : $(patsubst %.text, %.raw, $(notdir $(wildcard $(SRC)/*.text)))

clean:
	rm *.raw
