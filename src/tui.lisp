
(in-package dithcord-tui)

(cl-tui:define-children :root ()
  (top (cl-tui:container-frame :split-type :horizontal))
  (input (cl-tui:edit-frame :prompt "> ") :h 1))

(cl-tui:define-children top ()
  (channels (cl-tui:simple-frame :render 'render-channels) :w 15)
  (chat (cl-tui:log-frame))
  (users (cl-tui:simple-frame :render 'render-users) :w 15))

(defun render-channels (&key frame)
  nil)

(defun render-users (&key frame)
  nil)

(defun finish-input ()
  (let ((text (cl-tui:get-text 'input)))
    (cl-tui:append-line 'chat text)
    (cl-tui:clear-text 'input)))

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
