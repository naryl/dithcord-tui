
(in-package dithcord-tui)

(v:define-pipe ()
  (v:level-filter :level :debug)
  (v:rotating-file-faucet :template "debug.log"))

(setf (v:repl-categories) nil)

(dithcord:define-bot dithcord-tui (tui)
  :selfbot t)

;;;; Tokens

(defun get-new-token ()
  (setf (user-email) nil
        (user-token) nil)
  (let ((success nil))
    (while (not success)
      (handler-bind ((dithcord:invalid-login-data
                      (lambda (e)
                        (format t "Login error: ~A~%" (dithcord:message e))
                        nil)))
        (format t "Please, enter username (that's your email): ")
        (finish-output)
        (let ((username (read-line)))
          (format t "Please, enter password (it won't be stored): ")
          (finish-output)
          (let* ((password (read-line))
                 (token (dithcord:get-user-token username password)))
            (setf (user-email) username
                  (user-token) token
                  success t)))))
    (user-token)))

(defun get-token ()
  (let ((token (user-token)))
    (cond (token
           (format t "Login as ~A(Y/n)?~%" (user-email))
           (if (member (read-line) (list "" "y" "Y")
                       :test #'equal)
               token
               (get-new-token)))
        (t (get-new-token)))))

(defun start ()
  (ubiquitous:restore 'config)
  (setf (dithcord:token 'dithcord-tui) (get-token))
  (dithcord:start-bot 'dithcord-tui)
  (run-ui)
  (dithcord:stop-bot))
