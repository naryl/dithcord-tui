
(in-package dithcord-tui)

#.dithcord::declaim-optimize

(dithcord:define-module tui ())

(dithcord:define-handler tui :on-message-create (msg)
  (let ((sender (lc:author msg)))
    (let ((text (lispcord:render-msg msg))
          (timestamp (timestamp-time (lc:timestamp msg)))
          (sender-name (lc:name sender)))
      (cl-tui:append-line 'chat "~20@A | ~A~%" sender-name text)
      (cl-tui:refresh))))

;;; MISC

(defun timestamp-time (timestamp)
  (let* ((time+tz (elt (split-sequence:split-sequence #\T timestamp) 1))
         (time (elt (split-sequence:split-sequence #\. time+tz) 0)))
    time))
