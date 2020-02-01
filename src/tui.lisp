
(in-package dithcord-tui)

(defvar *running* nil)
(defun runningp ()
  *running*)
(defun stop-dithcord ()
  (setf *running* nil))

(cl-tui:define-children :root ()
  (top (cl-tui:container-frame :split-type :horizontal))
  (input (cl-tui:edit-frame :prompt 'render-prompt) :h 1))

(cl-tui:define-children top ()
  (channels (cl-tui:simple-frame :render 'render-channels) :w 15)
  (chat (cl-tui:log-frame))
  (users (cl-tui:simple-frame :render 'render-users) :w 15))

(defun render-channels (&key frame h w)
  (when (and (connectedp) (current-guild) (current-channel) (dc:me))
    (let ((channels (dc:channels (current-guild) :type 'lc:text-channel)))
      (loop for channel in channels
         for line from 0 below (1- h)
         do (if (eq channel (current-channel))
                (cl-tui:with-attributes (:reverse) frame
                  (cl-tui:put-text frame line 0 (lc:name channel)))
                (cl-tui:put-text frame line 0 (lc:name channel))))))
  (loop for y from 0 below (1- h)
     do (cl-tui:put-char frame y 14 #\|))
  (loop for x from 0 below (1- w)
       do (cl-tui:put-char frame (1- h) x #\-)))

(defun render-users (&key frame)
  nil)

(defun render-prompt ()
  (if (and (connectedp) (current-guild) (current-channel))
      (format nil "~A #~A > " (lc:name (current-guild)) (lc:name (current-channel)))
      (format nil "NOT CONNECTED > ")))

(defun finish-input ()
  (with-simple-restart (abort "Ignore user input")
    (let ((text (cl-tui:get-text 'input)))
      (when (string/= "" (cl-tui:get-text 'input))
        (if (and (> (length text) 0) (eql #\/ (elt text 0)))
            (handle-tui-command text)
            (send-message text)))))
  (cl-tui:clear-text 'input))

(defun send-message (text)
  nil)

(defun switch-channel (num)
  (let ((channels (dc:channels (current-guild) :type 'lc:text-channel)))
    (let ((channel-pos (position (current-channel) channels)))
      ;; Get the new channel in
      (unless channel-pos
        (setf channel-pos -1))
      (incf channel-pos num)
      (setf channel-pos (alexandria:clamp channel-pos 0 (length channels)))
      (setf (current-channel) (nth channel-pos channels))
      ;; Update the text on the chat panel
      (cl-tui:clear 'chat)
      (handler-case
          (map nil 'put-message (reverse (dc:get-messages (current-channel) :limit 50)))
        (error () (switch-channel num))))))

(defun put-message (msg)
  (let ((sender (lc:author msg)))
    (let ((text (lispcord:render-msg msg))
          (sender-name (lc:nick-or-name sender msg)))
      (when (> (length sender-name) 20)
        (setf sender-name (format nil "~A..." (subseq sender-name 0 17))))
      (cl-tui:append-line 'chat "~20@A | ~A~%" sender-name text)
      (cl-tui:refresh))))

(defun handle-input ()
  (let ((key (cl-tui:read-key)))
    (case key
      (#\Newline (finish-input))
      (#\So (switch-channel 1))
      (#\Dle (switch-channel -1))
      (:key-up (cl-tui:scroll-log 'chat 1))
      (:key-down (cl-tui:scroll-log 'chat -1))
      (t (cl-tui:handle-key 'input key)))))

(defun init-ui ()
  (when (and (user-token) (user-email))
    (cl-tui:append-line 'chat "*** Current user: ~A" (user-email))))

(defun run-ui ()
  (cl-tui:with-screen ()
    (cl-tui:set-split-type :root :vertical)
    (setf *running* t)
    (init-ui)
    (loop
       (cl-tui:refresh)
       (handle-input)
       (unless (runningp)
         (return)))))
