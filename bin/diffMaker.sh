#!/bin/bash
for file in ${1}/*.conllu;
do
    f=$(basename $file)
    ./apposDhbb ${1}/${f} ${2}/${f} >> ${3}
done
