
SRC=../raw
vpath  %.raw $(SRC)

.PHONY: all clean

%.sent : %.raw
	./split.sh $<

all : $(patsubst %.raw, %.sent, $(notdir $(wildcard $(SRC)/*.raw)))

clean:
	rm *.sent
