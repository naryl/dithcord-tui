
(defsystem dithcord-tui
  :depends-on (:alexandria :uiop ; General utilities
               :cl-containers :verbose :ubiquitous :trivial-types ; Utilities
               :cl-tui ; UI
               :dithcord :lispcord ; Discord
               )
  :pathname "src/"
  :serial t
  :components ((:file "defpackage")
               (:file "util")
               (:file "tui")
               (:file "tui-commands")
               (:file "module")
               (:file "main")
               )
  :build-operation "program-op"
  :build-pathname "../dithcord-tui"
  :entry-point "dithcord-tui:start"
  )

