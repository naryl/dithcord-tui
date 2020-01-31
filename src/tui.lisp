
(in-package dithcord-tui)

(cl-tui:define-children :root ()
  (top (cl-tui:container-frame :split-type :horizontal))
  (input (cl-tui:edit-frame :prompt 'render-prompt) :h 1))

(cl-tui:define-children top ()
  (channels (cl-tui:simple-frame :render 'render-channels) :w 15)
  (chat (cl-tui:log-frame))
  (users (cl-tui:simple-frame :render 'render-users) :w 15))

(defun render-channels (&key frame)
  nil)

(defun render-users (&key frame)
  nil)

(defun render-prompt ()
  (when (and *guild* *channel*)
    (format nil "~A #~A> " (lc:name *guild*) (lc:name *channel*))))

(defun finish-input ()
  (with-simple-restart (abort "Ignore user input")
    (let ((text (cl-tui:get-text 'input)))
      (if (and (> (length text) 0) (eql #\\ (elt text 0)))
          (handle-tui-command text)
          (cl-tui:append-line 'chat text))))
  (cl-tui:clear-text 'input))

(defun run-ui ()
  (cl-tui:with-screen ()
    (cl-tui:set-split-type :root :vertical)
    (loop
       (cl-tui:refresh)
       (let ((key (cl-tui:read-key)))
         (case key
           (#\Newline (finish-input))
           (#\Esc (return))
           (t (cl-tui:handle-key 'input key)))))))
