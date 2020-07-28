#!/usr/bin/bash

sbcl --load add-file.lisp --eval '(in-package :working)' --eval '(to-udp #P"./frases_rev.tmp" #P"./")' --non-interactive
