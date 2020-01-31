
(defsystem dithcord-tui
  :depends-on (:alexandria ; General utilities
               :cl-containers :verbose :ubiquitous :trivial-types ; Utilities
               :cl-tui ; UI
               :dithcord :lispcord ; Discord
               )
  :pathname "src/"
  :serial t
  :components ((:file "defpackage")
               (:file "macro")
               (:file "settings")
               (:file "module")
               (:file "tui")
               (:file "tui-commands")
               (:file "main")
               ))
