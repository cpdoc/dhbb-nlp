#!/bin/bash

ONLP=/Users/ar/work/apache-opennlp-1.9.0

for f in ../raw/*.raw; do
    TMP=$(basename $f .raw).tmp
    S1=$(basename $f .raw).sent1
    S2=$(basename $f .raw).sent
    echo Processing $f [$TMP, $S1, $S2]
    awk 'NF {printf "%s " ,$0 ; next} {print ""}' $f > $TMP
    $ONLP/bin/opennlp SentenceDetector $ONLP/models/pt-sent.bin < $TMP > $S1
    awk '$0 ~ /^$/ {next} {print}' $S1 > $S2
    rm $TMP $S1
done

