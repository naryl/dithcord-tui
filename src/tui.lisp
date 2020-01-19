
(in-package dithcord-tui)

(cl-tui:define-frame top (cl-tui:container-frame :split-type :horizontal) :on :root)
(cl-tui:define-frame channels (cl-tui:callback-frame :render 'render-channels) :on top :w 20)
(cl-tui:define-frame chat (cl-tui:log-frame) :on top)
(cl-tui:define-frame users (cl-tui:callback-frame :render 'render-users) :on top :w 25)
(cl-tui:define-frame input (cl-tui:edit-frame :prompt "> ") :on :root :h 1)

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
