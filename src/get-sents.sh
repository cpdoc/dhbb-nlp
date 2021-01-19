#!/bin/bash

path="`dirname \"$0\"`"
if [ ${#path} -gt 1 ]; then
    pushd ${path:2}
fi
mkdir -p "../sents/temp"

tmp=$(wc -l ../sents/*.offset | sort -n | head | awk '{print $2}')

for file in $tmp; do
    number=$(echo "$file" | tr -dc '0-9' )
    if [ -f "../sents/$number.diff" ]
    then
	echo "Diff found for $number"
	python3 sent-segment.py -m model_punkt.pickle ../raw ../sents/temp -i $number.raw
	if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	    sed -i s/$/' '/ ../sents/temp/$number-nk.offset
	elif [[ "$OSTYPE" == "darwin"* ]]; then
	    gsed -i s/$/' '/ ../sents/temp/$number-nk.offset
	else
	    echo "Erro: Sistema não suportado."
	fi
	./sent-convert ../sents/temp/$number-nk.offset ../raw/$number.raw > ../sents/temp/$number.sent
	rm ../sents/temp/$number-nk.offset
    else
	./sent-convert ../sents/$number.offset ../raw/$number.raw > ../sents/temp/$number.sent
    fi
done
