
(in-package dithcord-tui)

(v:define-pipe ()
  (v:level-filter :level :debug)
  (v:rotating-file-faucet :template "debug.log"))

(setf (v:repl-categories) nil)

(dithcord:define-bot dithcord-tui (tui)
  :selfbot t)

(defun connectedp ()
  (not (null dc:*client*)))

(defun start ()
  (ubiquitous:restore :dithcord-tui)
  (when (user-token)
    (setf (dc:token 'dithcord-tui) (user-token)))
  (setf (dc:selfbot 'dithcord-tui) (string/= (user-email) "Bot"))
  (run-ui)
  ;; It will do nothing if it wasn't started
  (dc:stop-bot)
  (uiop:quit))
