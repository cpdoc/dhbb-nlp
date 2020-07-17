#!/bin/bash

diferenca(){
	fl="$1-fl.sent"
	op="$1-op.sent"
	nl="$1-nl.sent"
	d=$(diff3 $fl $op $nl)
	if [ -z "$d" ]
	then
		qtd=$((qtd+$(wc -l < "$op")))
	else
		tam=$(wc -l < "$fl")
		t1=$(wc -l < "$op")
		t2=$(wc -l < "$nl")
		if [ "$t1" -gt "$tam" ];
		then
			tam=$t2
		fi
		if [ "$t2" -gt "$tam" ];
		then 
			tam=$t3
		fi
		qtd=$((qtd+tam))
		echo "#$1#" >> diff.txt
		echo "$d" >> diff.txt
	fi
}

qtd=0
[ -e diff.txt ] && rm diff.txt
for f in *-op.sent; do
	file=$(echo "$f" | tr -d "-" | tr -d "op.sent")
	diferenca $file
done
echo "Total máximo de sentenças: $qtd" >> diff.txt
