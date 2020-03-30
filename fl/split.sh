#!/bin/bash

IN=$1
TMP=$(basename $IN .raw).tmp
JSO=$(basename $IN .raw).json
OUT=$(basename $IN .raw).sent

awk 'NF {printf "%s " ,$0 ; next} {print ""}' $IN > $TMP
analyzer_client 8000 < $TMP > $JSO
./splitter $TMP $JSO $OUT
gsed -i 's/ \+/ /g' $OUT
rm $TMP $JSO
