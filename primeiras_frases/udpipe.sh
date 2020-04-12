#!/bin/bash

echo $1 > tmp
udpipe --tokenize --tokenizer="presegmented" --tag --parse $2 tmp 
rm tmp
