#!/bin/bash

echo $1 > tmp
udpipe --tokenize --tokenizer="presegmented" --tag --parse ../udp/model_enhanced.bin $2 tmp 
rm tmp
