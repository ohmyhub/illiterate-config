;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; org-mode stuff
(unpin! org)
(package! visual-fill-column)
(package! mixed-pitch)
(package! org-appear
  :recipe (:host github :repo "awth13/org-appear"))

;; childframes
(package! mini-frame)
(package! vertico-posframe)

;; tree sitter syntax support
(package! tree-sitter)
(package! tree-sitter-langs)

;; add paths to consult
(package! consult-dir)

;; using svg images for tags
(package! svg-lib)

;;themes
;;
;; bespoke theme
(package! bespoke-themes
  :recipe (:host github :repo "mclear-tools/bespoke-themes"))
(package! bespoke-modeline
  :recipe (:host github :repo "mclear-tools/bespoke-modeline"))

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

;; don't allow native compilation
(package! with-editor :recipe (:build (:not native-compile)))
(package! vterm :recipe (:build (:not native-compile)))
(package! evil-collection :recipe (:build (:not native-compile)))