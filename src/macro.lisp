(in-package dithcord-tui)

(defmacro while (cond &body body)
  `(loop while ,cond
      do (progn ,@body)))

(defmacro defsetting (name &optional (default nil default-p))
  `(defmacro ,name ()
     ,(if default-p
          ``(ubiquitous:defaulted-value ,,default ',',name)
          ``(ubiquitous:value ',',name))))
