#!/usr/bin/bash

SENT_PATH=../sents


for file in $SENT_PATH/*.sent; do
    cp $(basename $file .sent).sent $file
done
    
