
(pushnew :verbose-no-init *features*)

(asdf:initialize-source-registry
 `(:source-registry
   :ignore-inherited-configuration
   (:tree (:here ".qlot/dists/"))
   (:directory (:here "."))))

(asdf:make :dithcord-tui)
(uiop:quit)
