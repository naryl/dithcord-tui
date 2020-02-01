(in-package dithcord-tui)

(defmacro while (cond &body body)
  `(loop while ,cond
      do (progn ,@body)))

(defmacro defsetting (name (&rest args) &optional (default nil default-p))
  `(defmacro ,name (,@args)
     ,(if default-p
          ``(ubiquitous:defaulted-value ,,default ',',name ,,@args)
          ``(ubiquitous:value ',',name ,,@args))))
