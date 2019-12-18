#!/bin/bash

for f in ../raw/*.raw; do
    TMP=$(basename $f .raw).tmp
    S1=$(basename $f .raw).sent
    echo Processing $f [$TMP, $S1]
    awk 'NF {printf "%s " ,$0 ; next} {print ""}' $f > $TMP
    perl segment.pl < $TMP > $S1
    rm $TMP
done
