
(in-package dithcord-tui)

(defvar *commands* (make-hash-table))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defmacro define-command (name (&rest args) &body body)
    `(setf (gethash ,name *commands*)
           (lambda ,args ,@body t))))

(defun handle-tui-command (command)
  (let* ((tokens (split-sequence:split-sequence #\Space (subseq command 1)))
         (key (intern (string-upcase (first tokens)) :keyword)))
    (alexandria:when-let ((func (gethash key *commands*)))
      (apply func (rest tokens)))))

(define-command :lc ()
  (let ((channels (dc:channels *guild* 'lc:text-channel)))
    (cl-tui:append-line 'chat "Channels:")
    (dc:mapf channels (c)
      (cl-tui:append-line 'chat "~A: ~A" (lc:id c) (lc:name c)))))

(define-command :lg ()
  (cl-tui:append-line 'chat "Guilds:")
  (dc:mapf (dc:guilds) (g)
    (cl-tui:append-line 'chat "~A: ~A" (lc:id g) (lc:name g))))

(define-command :c (id)
  (let ((id (parse-integer id :junk-allowed t)))
    (setf *channel* (lc::getcache-id id :channel))))

(define-command :g (id)
  (let ((id (parse-integer id :junk-allowed t)))
    (setf *guild* (lc::getcache-id id :guild))
    (setf *channel* (elt (dc:channels *guild*) 0))))
