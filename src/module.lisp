(in-package dithcord-tui)

(dc:define-module tui (dcm:client dcm:state-tracker))

(dc:define-handler tui :on-ready (payload)
  (declare (ignore payload))
  (cl-tui:append-line 'chat "*** Connected!")
  (cl-tui:refresh))

(dc:define-handler tui :on-guild-create (guild)
  (cl-tui:refresh)
  (when (eq guild (dcm:current-guild))
    (fetch-messages)))

(dc:define-handler tui :on-message-create (msg)
  (when (eq (lc:channel msg) (dcm:current-channel))
    (put-message msg)))
