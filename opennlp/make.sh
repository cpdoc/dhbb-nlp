#!/bin/bash

echo getting files...
for f in ../raw/*.raw; do
    awk 'NF {printf "%s " ,$0 ; next} {print ""}' $f > $(basename $f .raw).tmp;
done

echo run java...
java -cp "/Users/ar/work/apache-opennlp-1.9.2/lib/*:." Detector .

echo post processing...
for f in *.sent; do
    R=$(basename $f .sent).tmp
    awk '$0 ~ /^$/ {next} {print}' $f > $R
    gsed -i ':a;N;$!ba;s/S\.\nPaulo/S\. Paulo/g' $R
    gsed -E -i ':a;N;$!ba;s/ ([SsdD]ra?)\.\n/ \1\. /g' $R
    gsed -E -i ':a;N;$!ba;s/ ([A-Z])\.\n([A-Z])/ \1\. \2/g' $R
    gsed -i 's/ \+/ /g' $R
    mv $R $f
done
