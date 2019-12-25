
(in-package dithcord-cli)

#.dithcord::declaim-optimize

(dithcord:define-module cli ())

(dithcord:define-handler cli :on-module-load ()
  (format t "Bot ready.~%"))

(dithcord:define-handler cli :on-ready (msg)
  (format t "Connected!~%")
  (format t "Push Return to terminate~%"))

(dithcord:define-handler cli :on-message-create (msg)
  (let ((sender (lc:author msg)))
    (let ((text (lc:content msg))
          (timestamp (timestamp-time (lc:timestamp msg)))
          (sender-name (lc:name sender)))
      (format t "~A ~20@A | ~A~%" timestamp sender-name text))))

;;; MISC

(defun timestamp-time (timestamp)
  (let* ((time+tz (elt (split-sequence:split-sequence #\T timestamp) 1))
         (time (elt (split-sequence:split-sequence #\. time+tz) 0)))
    time))
