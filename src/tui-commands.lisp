
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
  (let ((channels (dcm:channels (dcm:current-guild) :type 'lc:text-channel)))
    (cl-tui:append-line 'chat "Channels:")
    (dc:mapf channels (c)
      (cl-tui:append-line 'chat "~A: ~A" (lc:id c) (lc:name c)))))

(define-command lg ()
  (cl-tui:append-line 'chat "Guilds:")
  (dc:mapf (dcm:guilds) (g)
    (cl-tui:append-line 'chat "~A: ~A" (lc:id g) (lc:name g))))

(define-command c (id)
  (let ((id (parse-integer id :junk-allowed t)))
    (setf (dcm:current-channel) (lc::getcache-id id :channel))
    (fetch-messages)))

(define-command g (id)
  (let ((id (parse-integer id :junk-allowed t)))
    (setf (dcm:current-guild) (lc::getcache-id id :guild))
    (dcm:initialize-guild)
    (fetch-messages)))

(define-command connect ()
  (if (user-token)
      (dithcord:start-bot 'dithcord-tui)
      (cl-tui:append-line 'chat "*** Not authenticated. Please, user /auth <email> <password>")))

(define-command disconnect ()
  (dithcord:stop-bot))

(define-command auth (username password)
  (handler-bind ((dithcord:invalid-login-data
                  (lambda (e)
                    (cl-tui:append-line 'chat "*** Login error: ~A~%" (dithcord:message e)))))
    (setf (user-email) username)
    (setf (user-token) (dithcord:get-user-token username password))
    (setf (dc:token 'dithcord-tui) (user-token))
    (setf (dc:selfbot 'dithcord-tui) nil)))

(define-command auth-bot (token)
  (setf (user-email) "Bot")
  (setf (user-token) token)
  (setf (dc:token 'dithcord-tui) (format nil "Bot ~A" (user-token)))
  (setf (dc:selfbot 'dithcord-tui) t))

(define-command show-auth ()
  (if (and (user-email) (user-token))
      (if (string= (user-email) "Bot")
          (cl-tui:append-line 'chat "Bot; Token: ~A" (user-token))
          (cl-tui:append-line 'chat "Email: ~A; Token: ~A" (user-email) (user-token)))
      (cl-tui:append-line 'chat "Not authenticated. Use /auth <email> <password> or /auth-bot <token>")))

(define-command quit ()
  (stop-dithcord))
