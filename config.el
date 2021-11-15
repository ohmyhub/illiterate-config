;;; config.el -*- lexical-binding: t; -*-

;; user info
(setq user-full-name "Kevin Ward"
      user-mail-address "k.warden.89@gmail.com")

;; where the org at?
(setq org-directory "~/Dropbox/Org/")

;; I don't care about line numbers
(setq display-line-numbers-type nil)

;; better defaults
(setq-default
 delete-by-moving-to-trash t                      ; Delete files to trash
 window-combination-resize t                      ; take new window space from all other windows (not just current)
 x-stretch-cursor t                               ; Stretch cursor to the glyph width
 uniquify-buffer-name-style 'forward)

;; mash jk without thinking
(setq evil-escape-unordered-key-sequence t)

(setq evil-move-beyond-eol t)           ; let me go where I want to go!
(setq evil-move-cursor-back nil)        ; don't move my cursor around!

;; more better defaults
(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      truncate-string-ellipsis "…"               ; Unicode ellispis are nicer than "...", and also save /precious/ space
      scroll-margin 2                             ; It's nice to maintain a little margin
      inhibit-compacting-font-caches t)

;; what time is it?
(display-time-mode 1)

;; which key? this one.
(setq which-key-idle-delay 0.05)
(setq which-key-allow-multiple-replacements t)
(after! which-key
  (pushnew!
   which-key-replacement-alist
   '(("" . "\\`+?evil[-:]?\\(?:a-\\)?\\(.*\\)") . (nil . "◂\\1"))
   '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . "◃\\1"))
   ))

;; tell which-key to behave
(setq which-key-use-C-h-commands t
      prefix-help-command #'which-key-C-h-dispatch)

(defadvice! fix-which-key-dispatcher-a (fn &rest args)
  :around #'which-key-C-h-dispatch
  (let ((keys (this-command-keys-vector)))
    (if (equal (elt keys (1- (length keys))) ?\?)
        (let ((keys (which-key--this-command-keys)))
          (embark-bindings (seq-take keys (1- (length keys)))))
      (apply fn args))))

;; all of them!
(setq avy-all-windows t)

;; do the splits
(setq evil-vsplit-window-right t
      evil-split-window-below t)

(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (consult-buffer))

;; deft config
(use-package! deft
  :after org
  :init
  (setq deft-file-naming-rules
        '((noslash . "-")
          (nospace . "-")
          (case-fn . downcase)))
  :custom
  (deft-recursive t)
  (deft-use-filename-as-title nil)
  (deft-use-filter-string-for-filename t)
  (deft-extensions '("md" "txt" "org"))
  (deft-default-extension "org")
  (deft-directory (expand-file-name "~/Dropbox/Org/")))

;; whips persp-mode into shape
(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "main"))

;; what the fuck does this do? I'll leave it alone for now
(setq tab-bar-format '(tab-bar-format-global)
      tab-bar-mode t)

;; where are my projects?
(setq projectile-project-search-path
      '("~/.config/" "~/.config/fish/" "~/.config/kitty/" "~/.config/mpv/" "~/.config/sway/" "~/.config/ranger/" "~/.config/waybar/"))

;; I like prompt prompts
(setq company-idle-delay 0.01)

;; supposedly this helps native-comp and vterm play well together
(setq vterm-always-compile-module t)

;; a function to see my font tweaks quickly
(defun evig ()
  "Evaluate the current buffer and reload fonts."
  (interactive)
  (eval-buffer)
  (doom/reload-font))

;; what day is it?
(defun today ()
  "Insert string for today's date nicely formatted as yyyy-MM-dd, Day of the Week"
  (interactive)                 ; permit invocation in minibuffer
  (insert (format-time-string "%Y-%m-%d, %A")))

;; this is terrible
(defun select-line ()
  "select from point to end of line"
  (interactive)
  (evil-visual-state)
  (end-of-line))

;; create new empty org-mode buffer
(evil-define-command evil-buffer-org-new (count file)
  "Creates a new ORG buffer replacing the current window, optionally
   editing a certain FILE"
  :repeat nil
  (interactive "P<f>")
  (if file
      (evil-edit file)
    (let ((buffer (generate-new-buffer "*new org*")))
      (set-window-buffer nil buffer)
      (with-current-buffer buffer
        (org-mode)))))

;; tangle literate config on save
(defun org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/.doom.d/config.org"))
    (let ((org-config-babel-evaluate nil))
      (org-babel-tangle))))

  (add-hook 'org-mode-hook
        (lambda ()
          (add-hook 'after-save-hook #'org-babel-tangle-config)))

;; keybinds
(load! "bindings")

;; abbrev mode definitions
(load! "abbrev")

;; solarized me
(setq doom-theme 'doom-solarized-dark)

(custom-set-faces! '(region :background "#094959"))

;; choose your fonts!
(setq doom-font (font-spec :family "Bespoke Iosevka Mono" :size 20 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "Overpass Nerd Font" :size 22 :weight 'medium)
      doom-unicode-font (font-spec :family "Noto Color Emoji")
      doom-serif-font (font-spec :family "BlexMono Nerd Font" :weight 'light))

;; emojis
(use-package emojify
  :config
  (when (member "Segoe UI Emoji" (font-family-list))
    (set-fontset-font
     t 'symbol (font-spec :family "Segoe UI Emoji") nil 'prepend))
  (setq emojify-display-style 'unicode)
  (setq emojify-emoji-styles '(unicode)))

;; emojis in my backend
(setq company-backends '(company-emoji company-capf))

;; my pitches getting all mixed up
(defvar mixed-pitch-modes '(org-mode LaTeX-mode markdown-mode gfm-mode Info-mode)
  "Modes that `mixed-pitch-mode' should be enabled in, but only after UI initialisation.")
(defun init-mixed-pitch-h ()
  "Hook `mixed-pitch-mode' into each mode in `mixed-pitch-modes'.
Also immediately enables `mixed-pitch-modes' if currently in one of the modes."
  (when (memq major-mode mixed-pitch-modes)
    (mixed-pitch-mode 1))
  (dolist (hook mixed-pitch-modes)
    (add-hook (intern (concat (symbol-name hook) "-hook")) #'mixed-pitch-mode)))
(add-hook 'doom-init-ui-hook #'init-mixed-pitch-h)

;; fancy start up buffer splash image
(setq fancy-splash-image "~/Pictures/smaller-cute-demon.png")

;; I don't need to see this
(defun doom-modeline-conditional-buffer-encoding ()
  (setq-local doom-modeline-buffer-encoding
              (unless (or (eq buffer-file-coding-system 'utf-8-unix)
                          (eq buffer-file-coding-system 'utf-8)))))

  (add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)

;; red is too aggressive, so let's make it orange
(custom-set-faces!
  '(doom-modeline-buffer-modified :foreground "orange"))

;; gimme some space!
(after! doom-modeline
  (doom-modeline-def-modeline 'main
    '(bar matches buffer-info remote-host buffer-position parrot selection-info)
    '(misc-info minor-modes checker input-method buffer-encoding major-mode process vcs "  ")))

;; children of vertico
(require 'vertico-posframe)
(vertico-posframe-mode 1)

(setq vertico-posframe-border-width 4)

(custom-set-faces!
  '(vertico-posframe-border :inherit default :background "#00212B"))

;; I know what line I'm on
(remove-hook 'doom-first-buffer-hook #'global-hl-line-mode)

;; this helps if I lose what line I'm on
(beacon-mode 1)

;; stay out of my personal space
(setq org-cycle-separator-lines -1)

;; I should use org-capture
(after! org
  (setq org-capture-templates
        '(("t" "Task" checkitem
           (file+headline +org-capture-todo-file "Inbox")
           "- [ ] %?\n%i\n%a" :prepend t)
          ("n" "Notes" entry
           (file+headline +org-capture-notes-file "Unsorted")
           "* %u %?\n%i\n%a" :prepend t)
          ("j" "Journal" entry
           (file+olp+datetree +org-capture-journal-file)
           "* %U %?\n%i\n%a" :prepend t))))

;; god damn it teco I should really learn more elisp before copying and pasting shit
(defadvice! shut-up-org-problematic-hooks (orig-fn &rest args)
  :around #'org-fancy-priorities-mode
  (ignore-errors (apply orig-fn args)))

;; go deep!
(setq org-export-headline-levels 5)

;; this is a priorities
(after! org
  (setq org-priority-faces
        '((65 :foreground "red" :weight bold)
          (66 :foreground "orange" :weight bold)
          (67 :foreground "yellow" :weight bold)
          (68 :foreground "blue" :weight normal))
        org-fancy-priorities-list '("HIGH" "MID" "LOW" "OPTIONAL")
        org-todo-keywords '((sequence "TODO(t)" "INPROGRESS(i)" "WAIT(w)" "|" "DONE(d)" "CANCELLED(c)" "REMINDER(r)"))
        org-todo-keyword-faces
        '(("TODO" :foreground "#34f455" :weight bold :underline t)
          ("INPROGRESS" :foreground "#f4f434" :weight normal :underline t)
          ("WAIT" :foreground "#83cec8" :weight normal :underline nil)
          ("DONE" :foreground "#a98bf4" :weight normal :strike-through t)
          ("CANCELLED" :foreground "#818178" :weight normal :strike-through t)
          ("REMINDER" :foreground "#8DDFF3" :weight normal :underline nil))))

;; you got custom on my face
(custom-set-faces!
  '(outline-1 :weight extra-bold :height 1.4)
  '(outline-2 :weight bold :height 1.2)
  '(outline-3 :weight bold :height 1.15)
  '(outline-4 :weight semi-bold :height 1.10)
  '(outline-5 :weight semi-bold :height 1.08)
  '(outline-6 :weight semi-bold :height 1.05)
  '(outline-8 :weight semi-bold)
  '(outline-9 :weight semi-bold))

(custom-set-faces!
  '(org-document-title :height 1.5))

;; so pretty
(add-hook 'org-mode-hook #'+org-pretty-mode)

;; you're a superstar!
(after! org-superstar
  (setq org-superstar-headline-bullets-list '("◉" "○" "✸" "✿" "✤" "✜" "◆" "▶")
        org-superstar-prettify-item-bullets t ))

;; more fancy please
(setq org-ellipsis " ▾ "
      org-hide-leading-stars t
      org-priority-highest ?A
      org-priority-lowest ?E
      org-priority-faces
      '((?A . 'all-the-icons-red)
        (?B . 'all-the-icons-orange)
        (?C . 'all-the-icons-yellow)
        (?D . 'all-the-icons-green)
        (?E . 'all-the-icons-blue)))

;; why use words when have pictures?
(after! org
  (appendq! +ligatures-extra-symbols
            `(:checkbox      ""
              :pending       "◼"
              :checkedbox    "☑"
              :list_property "∷"
              :em_dash       "—"
              :ellipses      "…"
              :arrow_right   "→"
              :arrow_left    "←"
              :title         "τ"
              :subtitle      "ʈ"
              :author        "α"
              :date          "δ"
              :property      "☸"
              :options       "⌥"
              :startup       "⏻"
              :macro         "μ"
              :html_head     "Ԋ"
              :html          "Ԋ"
              :latex_class   "Ł"
              :latex_header  "Ł"
              :beamer_header "β"
              :latex         "Ł"
              :attr_latex    "Ł"
              :attr_html     "Ԋ"
              :attr_org      "⒪"
              :begin_quote   "❝"
              :end_quote     "❞"
              :caption       "☰"
              :header        "›"
              :results       "⮯"
              :begin_export  "⏩"
              :end_export    "⏪"
              :properties    "⚙"
              :drawer        "▬"
              :end           "∎"
              :log           "⬓"
              :email         "📧"
              :priority_a   ,(propertize "⚑" 'face 'all-the-icons-red)
              :priority_b   ,(propertize "⬆" 'face 'all-the-icons-orange)
              :priority_c   ,(propertize "■" 'face 'all-the-icons-yellow)
              :priority_d   ,(propertize "⬇" 'face 'all-the-icons-green)
              :priority_e   ,(propertize "❓" 'face 'all-the-icons-blue)))
  (set-ligatures! 'org-mode
    :merge t
    :checkbox      "[ ]"
    :pending       "[-]"
    :checkedbox    "[X]"
    :list_property "::"
    :em_dash       "---"
    :ellipsis      "..."
    :arrow_right   "->"
    :arrow_left    "<-"
    :title         "#+title:"
    :subtitle      "#+subtitle:"
    :author        "#+author:"
    :date          "#+date:"
    :property      "#+property:"
    :options       "#+options:"
    :startup       "#+startup:"
    :macro         "#+macro:"
    :html_head     "#+html_head:"
    :html          "#+html:"
    :latex_class   "#+latex_class:"
    :latex_header  "#+latex_header:"
    :beamer_header "#+beamer_header:"
    :latex         "#+latex:"
    :attr_latex    "#+attr_latex:"
    :attr_html     "#+attr_html:"
    :attr_org      "#+attr_org:"
    :begin_quote   "#+begin_quote"
    :end_quote     "#+end_quote"
    :caption       "#+caption:"
    :header        "#+header:"
    :begin_export  "#+begin_export"
    :end_export    "#+end_export"
    :results       "#+RESULTS:"
    :property      ":properties:"
    :end           ":end:"
    :drawer        ":drawer:"
    :log           ":log:"
    :email         "#+email:"
    :priority_a    "[#A]"
    :priority_b    "[#B]"
    :priority_c    "[#C]"
    :priority_d    "[#D]"
    :priority_e    "[#E]")
  (plist-put +ligatures-extra-symbols :name "⁍"))

;; More. Fancy.
(add-hook! org-mode 'org-fancy-priorities-mode)

;; get out of my face stars
(setq org-hide-leading-stars t)

;; you will stay hidden until I summon you
(use-package! org-appear
  :after org
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t
        org-appear-autosubmarkers t))

;; where the email client at?
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")

;; this is how I do the emails
(after! mu4e
  (setq user-mail-address "k.warden.89@gmail.com")
  (setq user-full-name "Kevin Ward")
  (setq mu4e-change-filenames-when-moving t)    ;; Avoid mail syncing issues
  (setq mu4e-update-interval (* 15 60))         ;; Sync with isync every 15 minutes
  (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-index-update-in-background t)
  (setq mu4e-use-fancy-chars t)
  (setq mu4e-view-show-images t)
  (setq message-kill-buffer-on-exit t)
  (setq mu4e-drafts-folder "/[Gmail]/Drafts")
  (setq mu4e-sent-folder "/[Gmail]/Sent Mail")
  (setq mu4e-refile-folder "/[Gmail]/All Mail")
  (setq mu4e-trash-folder "/[Gmail]/Trash")
  (setq smtpmail-smtp-user "k.warden.89@gmail.com")
  (setq smtpmail-default-smtp-server "smtp.gmail.com")
  (setq smtpmail-smtp-server "smtp.gmail.com")
  (setq smtpmail-smtp-service 587)
  (setq message-send-mail-function 'smtpmail-send-it)
  (setq mu4e-compose-signature "---\nKevin Ward")
  (setq mu4e-maildir-shortcuts
    '((:maildir "/Inbox"    :key ?i)
      (:maildir "/[Gmail]/Sent Mail" :key ?s)
      (:maildir "/[Gmail]/Trash"     :key ?t)
      (:maildir "/[Gmail]/Drafts"    :key ?d)
      (:maildir "/[Gmail]/All Mail"  :key ?a))))

;; let gmail do it
(after! mu4e
  (setq mu4e-index-cleanup nil
        mu4e-index-lazy-check t))

;; another place to dump my web browser bookmarks
(setq ebuku-results-limit 0)

;; some configs for a package I'm not using right now
(custom-set-variables
 '(mini-frame-show-parameters
   '((top . 500)
     (width . 0.7)
     (left . 0.5))))

(setq mini-frame-detach-on-hide nil)

;; nothing but a common lisp
(after! sly
  (setq sly-lisp-implementations
        '((sbcl ("/usr/local/bin/sbcl") :coding-system utf-8-unix))))
