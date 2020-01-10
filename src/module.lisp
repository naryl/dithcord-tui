
(in-package dithcord-tui)

#.dithcord::declaim-optimize

(dithcord:define-module tui ())

(dithcord:define-handler tui :on-module-load ()
  (format nil "Bot ready.~%"))

(dithcord:define-handler tui :on-ready (msg)
  (format nil "Connected!~%")
  (format nil "Push Return to terminate~%"))

(dithcord:define-handler tui :on-message-create (msg)
  (let ((sender (lc:author msg)))
    (let ((text (lc:content msg))
          (timestamp (timestamp-time (lc:timestamp msg)))
          (sender-name (lc:name sender)))
      (format nil "~A ~20@A | ~A~%" timestamp sender-name text))))

;;; MISC

(defun timestamp-time (timestamp)
  (let* ((time+tz (elt (split-sequence:split-sequence #\T timestamp) 1))
         (time (elt (split-sequence:split-sequence #\. time+tz) 0)))
    time))
