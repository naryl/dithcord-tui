
(in-package dithcord-tui)

(dc:define-module tui (dc:state-tracker))

(dc:define-handler tui :on-ready (payload)
  (declare (ignore payload))
  (setf *guild* (first (dc:guilds)))
  (setf *channel* (elt (dc:channels *guild*) 0))
  (cl-tui:refresh))

(dc:define-handler tui :on-message-create (msg)
  (when (eq (lc:channel msg) *channel*)
    (let ((sender (lc:author msg)))
      (let ((text (lispcord:render-msg msg))
            (sender-name (lc:nick-or-name sender msg)))
        (when (> (length sender-name) 20)
          (setf sender-name (format nil "~A..." (subseq sender-name 0 17))))
        (cl-tui:append-line 'chat "~20@A | ~A~%" sender-name text)
        (cl-tui:refresh)))))

;;; MISC

(defvar *guild* nil)
(defvar *channel* nil)

(defun timestamp-time (timestamp)
  (let* ((time+tz (elt (split-sequence:split-sequence #\T timestamp) 1))
         (time (elt (split-sequence:split-sequence #\. time+tz) 0)))
    time))
