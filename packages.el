;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; org-mode stuff
(unpin! org)
(package! visual-fill-column)
(package! mixed-pitch)
(package! org-appear
  :recipe (:host github :repo "awth13/org-appear"))
(package! org-real)
(package! boxy)
(package! boxy-headings)
(package! company-org-block)
(package! writeroom-mode)
(package! org-pandoc-import
  :recipe (:host github
           :repo "tecosaur/org-pandoc-import"
           :files ("*.el" "filters" "preprocessors")))

;;themes
;;
;; ancient dark one
(package! ancient-one-dark-theme)

;; all other
;;
;; emojis in completion
(package! company-emoji)

;; web bookmark manager
(package! ebuku)

;; making music
(package! alda-mode)

;; keep track of the cursor
(package! beacon)

;; childframes
(package! vertico-posframe)

;; tree sitter syntax support
(package! tree-sitter)
(package! tree-sitter-langs)

;; add paths to consult
(package! consult-dir)

;; using svg images for tags
(package! svg-lib)

;; colorize color names in the buffer
(package! rainbow-mode)

;; Emacs in discord rich presence
(package! elcord)

;; This is a satisfactory package
(package! powerthesaurus)

;; quicklisp support for sly
(package! sly-quicklisp
  :recipe (:host github :repo "joaotavora/sly-quicklisp"))

;; nxyt and Emacs sitting in a tree
(package! emacs-with-nyxt
  :recipe (:host github :repo "ag91/emacs-with-nyxt"))

;; vterm fixed branch
(package! :recipe (:host github :repo "blahgeek/emacs-libvterm" :branch "fix-visibility"))

;; don't allow native compilation
(package! with-editor :recipe (:build (:not native-compile)))
;;(package! vterm :recipe (:build (:not native-compile)))
(package! evil-collection :recipe (:build (:not native-compile)))
