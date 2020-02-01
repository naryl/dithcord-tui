
(in-package dithcord-tui)

(dc:define-module tui (dc:state-tracker))

(dc:define-handler tui :on-ready (payload)
  (declare (ignore payload))
  (cl-tui:append-line 'chat "*** Connected! Guilds: ~A" (length (dc:guilds)))
  (unless (zerop (length (dc:guilds)))
    (initialize-guild))
  (cl-tui:refresh))

(dc:define-handler tui :on-guild-create (guild)
  (declare (ignore guild))
  ;; Got our first guild
  (when (= 1 (length (dc:guilds)))
    (initialize-guild))
  (cl-tui:refresh))

(dc:define-handler tui :on-message-create (msg)
  (when (eq (lc:channel msg) (current-channel))
    (put-message msg)))

;;; MISC

(defun initialize-guild ()
  (unless (and (current-guild-id) (current-guild))
    (setf (current-guild) (first (dc:guilds))))
  (when (current-guild)
    (alexandria:when-let ((channels (dc:channels (current-guild) :type 'lc:text-channel)))
      (unless (and (current-guild-id) (current-channel-id (current-guild-id)) (current-channel))
        (setf (current-channel) (elt channels 0)))))
  (fetch-messages)
  (cl-tui:refresh))

(defun current-guild ()
  (lc::getcache-id (current-guild-id) :guild))
(defun current-channel ()
  (lc::getcache-id (current-channel-id (current-guild-id)) :channel))

(defun (setf current-guild) (g)
  (setf (current-guild-id) (lc:id g)))
(defun (setf current-channel) (c)
  (let ((gid (current-guild-id)))
    (setf (current-channel-id gid) (lc:id c))))

(defun timestamp-time (timestamp)
  (let* ((time+tz (elt (split-sequence:split-sequence #\T timestamp) 1))
         (time (elt (split-sequence:split-sequence #\. time+tz) 0)))
    time))
