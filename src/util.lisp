(in-package dithcord-tui)

(dc:defsetting user-email ())
(dc:defsetting user-token ())

(defmacro while (cond &body body)
  `(loop while ,cond
      do (progn ,@body)))

(defun render-msg (msg)
  "Render a message in text-friendly format. Should be placed in the log frame's message renderer, and colorized."
  (let* ((words (split-sequence #\Space (lc:content msg)))
         (parts (mapf words (word)
                  (or (demention word) word)))
         (rendered-parts (mapf parts (part)
                           (etypecase part
                             (string part)
                             (lc:guild-channel (str-concat "#" (lc:name part)))
                             (lc:role (str-concat "@" (lc:name part)))
                             (lc:user (str-concat "@" (lc:nick-or-name part (lc:guild msg))))
                             (lc:emoji (str-concat ":" (lc:name part) ":"))))))
    (format nil "~{~A~^ ~}" rendered-parts)))
