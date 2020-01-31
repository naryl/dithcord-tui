
(in-package dithcord-tui)

(defvar *commands* (make-hash-table :test 'equal))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defmacro define-command (name (&rest args) &body body)
    `(setf (gethash ,(symbol-name name) *commands*)
           (lambda ,args ,@body t))))

(defun handle-tui-command (command)
  (let* ((tokens (split-sequence:split-sequence #\Space (subseq command 1)))
         (key (string-upcase (first tokens))))
    (alexandria:when-let ((func (gethash key *commands*)))
      (apply func (rest tokens)))))

(define-command lc ()
  (let ((channels (dc:channels (current-guild) :type 'lc:text-channel)))
    (cl-tui:append-line 'chat "Channels:")
    (dc:mapf channels (c)
      (cl-tui:append-line 'chat "~A: ~A" (lc:id c) (lc:name c)))))

(define-command lg ()
  (cl-tui:append-line 'chat "Guilds:")
  (dc:mapf (dc:guilds) (g)
    (cl-tui:append-line 'chat "~A: ~A" (lc:id g) (lc:name g))))

(define-command c (id)
  (let ((id (parse-integer id :junk-allowed t)))
    (setf (current-channel) (lc::getcache-id id :channel))))

(define-command g (id)
  (let ((id (parse-integer id :junk-allowed t)))
    (setf (current-guild) (lc::getcache-id id :guild))
    (setf (current-channel) (elt (dc:channels (current-guild) :type 'lc:text-channel) 0))
    ))

(define-command connect ()
  (if (user-token)
      (dithcord:start-bot 'dithcord-tui)
      (cl-tui:append-line 'chat "*** Not authenticated. Please, user /auth <username> <password>")))

(define-command disconnect ()
  (dithcord:stop-bot))

(define-command auth (username password)
  (handler-bind ((dithcord:invalid-login-data
                  (lambda (e)
                    (cl-tui:append-line 'chat "*** Login error: ~A~%" (dithcord:message e)))))
    (setf (user-token) (dithcord:get-user-token username password))
    (setf (dc:token 'dithcord-tui) (user-token))))

(define-command show-auth ()
  (if (and (user-email) (user-token))
      (cl-tui:append-line 'chat "Email: ~A; Token: ~A" (user-email) (user-token))
      (cl-tui:append-line 'chat "Not authenticated. Use /auth <username> <password>")))

(define-command quit ()
  (stop-dithcord))
