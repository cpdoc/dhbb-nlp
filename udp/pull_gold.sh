#!/usr/bin/bash

sbcl --load add-file.lisp --eval '(in-package :working)' --eval '(write-from-revised (collect-revised #P"*.conllu"))' --non-interactive

