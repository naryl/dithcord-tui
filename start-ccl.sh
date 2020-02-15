#!/bin/sh
rm debug.log

ccl -e '(ql:quickload "dithcord-tui")' \
	-e '(dithcord-tui:start)'
