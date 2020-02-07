#!/bin/bash

ONLP=/Users/ar/work/apache-opennlp-1.9.0

T1=$(basename $1 .raw).tmp1
T2=$(basename $1 .raw).tmp2
R=$(basename $1 .raw).sent

awk 'NF {printf "%s " ,$0 ; next} {print ""}' $1 > $T1
$ONLP/bin/opennlp SentenceDetector $ONLP/models/pt-sent.bin < $T1 > $T2
awk '$0 ~ /^$/ {next} {print}' $T2 > $R
gsed -i ':a;N;$!ba;s/S\.\nPaulo/S\. Paulo/g' $R
gsed -E -i ':a;N;$!ba;s/([SsdD])r\.\n/\1r\. /g' $R
gsed -i 's/ \+/ /g' $R
rm $T1 $T2
