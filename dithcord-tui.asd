
(defsystem dithcord-tui
  :depends-on (:alexandria ; General utilities
               :cl-containers :verbose :ubiquitous ; Utilities
               :cl-tui :cl-charms :vedit ; UI
               :dithcord :lispcord ; Discord
               )
  :pathname "src/"
  :serial t
  :components ((:file "defpackage")
               (:file "macro")
               (:file "settings")
               (:file "cli")
               (:file "module")
               (:file "bot")
               ))
