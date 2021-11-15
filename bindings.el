;;; ~/.doom.d/bindings.el -*- lexical-binding: t; -*-

(map! :leader
      (:prefix ("k" . "Custom")
       :desc "Switch Frame" :n "f" #'select-frame-by-name
       :desc "Insert today's date" :n "t" #'today
       :desc "Paste from clipboard" :n "p" #'clipboard-yank
       :desc "Paste as a subtree heading" :n "o" #'org-paste-subtree
       :desc "File from Deft dir" :n "d" #'deft-find-file
       :desc "Select line" :n "l" #'select-line
       :desc "Export pdf" :n "e" #'org-latex-export-to-pdf
       :desc "Ace window" :n "w" #'ace-window
       :desc "org-capture frame" :n "c" #'+org-capture/open-frame
       :desc "New empty ORG buffer" :n "g" #'evil-buffer-org-new
       :desc "Add directory as project" :n "a" #'doom/add-directory-as-project
       :desc "Evaluate buffer and reload fonts" :n "v" #'evig
       :desc "Open config.org" :n "k" #'org-open-config-file))
