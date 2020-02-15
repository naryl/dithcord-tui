
NAME = dithcord-tui

build: $(NAME).ecl

deps:
	sbcl --eval "(ql:quickload :qlot)" \
		--eval "(qlot:install :$(NAME))" \
		--eval "(uiop:quit)"

deps-update:
	sbcl --eval "(ql:quickload :qlot)" \
		--eval "(qlot:update :$(NAME))" \
		--eval "(uiop:quit)"

$(NAME).sbcl:
	sbcl --no-userinit --load build.lisp

$(NAME).ecl:
	ecl --no-userinit --load build.lisp

$(NAME).ccl:
	ccl -n -l build.lisp

clean:
	-rm dithcord-tui

mrproper: clean
	-rm -rf .qlot
