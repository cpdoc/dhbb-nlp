#!/bin/bash

MODEL=/Users/ar/work/apache-opennlp-1.5.3/models/pt-sent.bin
ONLP=/Users/ar/work/apache-opennlp-1.9.0/bin/opennlp

for f in ../raw/*.raw; do
    TMP=$(basename $f .raw).tmp
    S1=$(basename $f .raw).sent1
    S2=$(basename $f .raw).sent
    echo Processing $f [$TMP, $S1, $S2]
    awk 'NF {printf "%s " ,$0 ; next} {print ""}' $f > $TMP
    $ONLP SentenceDetector $MODEL < $TMP > $S1
    awk '$0 ~ /^$/ {next} {print}' $S1 > $S2
    rm $TMP $S1
done

