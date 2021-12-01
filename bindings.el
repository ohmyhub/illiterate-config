;;; ~/.doom.d/bindings.el -*- lexical-binding: t; -*-

(map! :leader
      :desc "Open config.org" :n                        "f k"   #'org-open-config-file
      :desc "Ace window" :n                             "w a"   #'ace-window
      (:prefix ("k" . "Grab Bag")
       :desc "Export pdf" :n                            "e"      #'org-latex-export-to-pdf
       :desc "File from Deft dir" :n                    "d"      #'deft-find-file
       :desc "New empty ORG buffer" :n                  "g"      #'evil-buffer-org-new
       :desc "Paste as a subtree heading" :n            "o"      #'org-paste-subtree
       :desc "Paste from clipboard" :n                  "p"      #'clipboard-yank
       :desc "Ranger in emacs" :n                       "r"      #'ranger
       :desc "Insert today's date" :n                   "t"      #'today
       :desc "Evaluate buffer and reload fonts" :n      "v"      #'evig))
