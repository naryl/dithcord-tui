#!/bin/sh
sbcl --eval '(ql:quickload "swank")' \
	--eval '(swank:create-server :dont-close t)' \
	--eval '(ql:quickload "dithcord-tui")' \
	--eval '(dithcord-tui:start)' \
	--no-linedit
