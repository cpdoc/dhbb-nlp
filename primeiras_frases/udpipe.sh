#!/bin/bash

echo $1 > tmp
./udpipe --tokenize --tag --parse model_bosque.bin tmp 
rm tmp
