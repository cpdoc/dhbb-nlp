#!/usr/bin/env bash
SOURCE="${BASH_SOURCE[0]}"
abcl --batch --load $(dirname $SOURCE)/sent-segment.abcl --eval '(main)' --eval '(quit)'
