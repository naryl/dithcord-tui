
(in-package dithcord-tui)

(lispcord:set-log-level :error)
(setf (v:repl-level) :error)

(dithcord:define-bot dithcord-tui (tui)
  :selfbot t)

