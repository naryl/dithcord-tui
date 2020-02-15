#!/bin/sh
rm debug.log

LISP=sbcl
#LISP=ecl

$LISP \
	--eval '(ql:quickload "dithcord-tui")' \
	--eval '(dithcord-tui:start)'
