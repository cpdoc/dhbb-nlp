#!/bin/bash

for f in ../raw/*.raw; do
    TMP=$(basename $f .raw).tmp
    JSO=$(basename $f .raw).json
    OUT=$(basename $f .raw).sent
    echo Processing $f
    awk 'NF {printf "%s " ,$0 ; next} {print ""}' $f > $TMP
    analyzer_client 8000 < $TMP > $JSO
    ./splitter $TMP $JSO $OUT
    rm $TMP $JSO
    gsed -i 's/ \+/ /g' $OUT
done
