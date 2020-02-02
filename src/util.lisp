(in-package dithcord-tui)

(dc:defsetting user-email ())
(dc:defsetting user-token ())

(defmacro while (cond &body body)
  `(loop while ,cond
      do (progn ,@body)))

