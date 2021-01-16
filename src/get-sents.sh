#!/bin/bash

tmp=$(wc -l path../sents/*.offset | sort -n | head | awk '{print $2}')

for file in $tmp; do
	number=$(echo "$file" | cut -d "/" -f 3 | cut -d "." -f 1)
	if [ -f "../sents/$number.diff" ]
	then
		echo "Diff found for $number"
		python3 sent-segment.py -m model_punkt.pickle ../raw ../sents/temp -i $number.raw
		if [[ "$OSTYPE" == "linux-gnu"* ]]; then
			sed -i s/$/' '/ ../sents/temp/$number-nk.offset
		elif [[ "$OSTYPE" == "darwin"* ]]; then
			gsed -i s/$/' '/ ../sents/temp/$number-nk.offset
		else
			echo "Erro: Sistema não suportado"
		fi
		./sent-convert ../sents/temp/$number-nk.offset ../sents/temp/$number.sent ../raw/$number.raw
		rm ../sents/temp/$number-nk.offset
	else
		./sent-convert ../sents/$number.offset ../sents/temp/$number.sent ../raw/$number.raw
	fi

done
