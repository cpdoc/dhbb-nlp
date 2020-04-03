#!/usr/bin/bash

diff -qs ../fl ../opennlp/ | awk '$2 ~ /[0-9].sent/ && $6 == "identical" {print $2} ' | sed 's/..\/fl\///g' > files.tmp

while read file; do
    mv ../fl/$file ./;
    rm ../opennlp/$file
done < files.tmp

rm files.tmp
