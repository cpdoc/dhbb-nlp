#!/usr/bin/bash

diff -qs ../fl ../opennlp/ | awk '$2 ~ /[0-9].sent/ && $6 == "identical" {print $2} ' | sed 's/..\/fl\///g' > identicos

while read file; do
    mv ../fl/$file ./;
    rm ../opennlp/$file
done < identicos

rm identicos
