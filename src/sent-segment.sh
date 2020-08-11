#!/usr/bin/env bash
SOURCE="${BASH_SOURCE[0]}"
abcl --batch --load $(dirname $SOURCE)/sent-detector.lisp --eval '(main)' --eval '(quit)'
