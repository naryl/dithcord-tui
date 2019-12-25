
(in-package dithcord-cli)

(lispcord:set-log-level :error)
(setf (v:repl-level) :error)

(dithcord:define-bot dithcord-cli (cli)
  :selfbot t)

