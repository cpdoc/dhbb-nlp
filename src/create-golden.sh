#!/bin/bash

path="`dirname \"$0\"`"
if [ ${#path} -gt 1 ]; then
	cd ${path:2}
fi

for file in ../sents/temp/*.sent; do
    number=$(echo "$file" | cut -d "/" -f 4 | cut -d "." -f 1)
    git rm ../sents/$number.*
    ./sent-convert -c ../sents/temp/$number.sent ../sents/$number.goffset
    rm ../sents/temp/$number.sent
    git add ../sents/$number.goffset
done
