;;; .doom.d/config.el -*- lexical-binding: t; -*-

;;(server-start)
(setq-default user-full-name    "Peter Strzyzewski"
              user-mail-address "peters2222@gmail.com"
              ;; fill-column 100

              doom-localleader-key ","
              ;; evil-shift-width 4
              ;; tab-width 4

              +workspaces-switch-project-function #'ignore
              +pretty-code-enabled-modes '(emacs-lisp-mode org-mode)
              +format-on-save-enabled-modes '(not emacs-lisp-mode))

;; Place your private configuration here
(setq doom-font (font-spec :family "Source Code Pro" :size 15)
      doom-big-font (font-spec :family "Source Code Pro" :size 18)
      doom-localleader-key ","
      dired-dwim-target t
      projectile-indexing-method 'hybrid
      projectile-enable-caching nil
      projectile-project-search-path '("~/dev")
      company-idle-delay nil
      display-line-numbers-type nil
      lsp-ui-flycheck-live-reporting nil
      lsp-enable-symbol-highlighting nil
      doom-themes-enable-bold nil
      doom-modeline-buffer-encoding nil
      doom-modeline-vcs-max-length 12
      doom-modeline-env-version nil)

(add-hook 'terraform-mode-hook #'terraform-format-on-save-mode)

;; Use bar cursor when in insert mode in terminal
(unless (display-graphic-p)
  (require 'evil-terminal-cursor-changer)
  (evil-terminal-cursor-changer-activate))


;; Terraform mode
(require 'terraform-mode)
(add-to-list 'auto-mode-alist '("\\.tf\\'" . terraform-mode))

;; Org-roam
;;
;; ~/.doom.d/config.el
(use-package! org-roam
  :commands (org-roam-insert org-roam-find-file org-roam)
  :init
  (setq org-directory "~/org"
        org-roam-directory "~/org/roam"
        org-roam-graph-viewer "/usr/bin/open"
        org-roam-index-file "~/org/roam/index.org"
        org-roam-buffer-width 0.4
        org-roam-completion-system 'helm
        )
  (map! :leader
        :prefix "r"
        :desc "Org-Roam-Dailies-Today" "d" #'org-roam-dailies-today
        :desc "Org-Roam-Insert" "i" #'org-roam-insert
        :desc "Org-Roam-Find"   "/" #'org-roam-find-file
        :desc "Org-Roam-Switch-Buffer" "b" #'org-roam-switch-to-buffer
        :desc "Org-Roam-Buffer" "r" #'org-roam
        :desc "Org-Roam jump to Index" "I" #'org-roam-jump-to-index
        )
  :config
  (org-roam-mode +1))

(use-package org-journal
  :ensure t
  :defer t
  :after org
  :config
  (setq org-journal-dir "~/org/roam")
  :bind
  ("C-c n j" . org-journal-new-entry)
  :custom
  (org-journal-date-prefix "#+TITLE: ")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-date-format "%A, %d %B %Y")
  (org-journal-enable-agenda-integration t)
  )

;; in ~/.doom.d/+bindings.el
(map! :leader
      (:prefix ("j" . "journal") ;; org-journal bindings
        :desc "Create new journal entry" "j" #'org-journal-new-entry
        :desc "Open previous entry" "p" #'org-journal-open-previous-entry
        :desc "Open next entry" "n" #'org-journal-open-next-entry
        :desc "Search journal" "s" #'org-journal-search-forever))

;; The built-in calendar mode mappings for org-journal
;; conflict with evil bindings
(map!
 (:map calendar-mode-map
   :n "o" #'org-journal-display-entry
   :n "p" #'org-journal-previous-entry
   :n "n" #'org-journal-next-entry
   :n "O" #'org-journal-new-date-entry))

;; Local leader (<SPC m>) bindings for org-journal in calendar-mode
;; I was running out of bindings, and these are used less frequently
;; so it is convenient to have them under the local leader prefix
(map!
 :map (calendar-mode-map)
 :localleader
 "w" #'org-journal-search-calendar-week
 "m" #'org-journal-search-calendar-month
 "y" #'org-journal-search-calendar-year)

(require 'company-org-roam)
(push 'company-org-roam company-backends)

;;(add-hook 'org-mode-hook #'org-roam-mode)
;;(add-hook 'after-init-hook 'org-roam-mode)


;; Org-roam cache
;;
(defun org-roam--make-file (file-path &optional title)
  "Create an org-roam file at FILE-PATH, optionally setting the TITLE attribute."
  (if (file-exists-p file-path)
      (error (format "Aborting, file already exists at %s" file-path))
    (if org-roam-autopopulate-title
        (org-roam--populate-title file-path title)
      (make-empty-file file-path))
    (save-window-excursion
      (with-current-buffer (find-file file-path)
        (org-roam--update-cache)
        ))))



(after! org-roam
  (setq +org-roam-graph--html-template (replace-regexp-in-string "%\\([^s]\\)" "%%\\1" (f-read-text (concat doom-private-dir "misc/org-roam-template.html"))))

  (defadvice! +org-roam-graph--build-html (&optional node-query)
    "Generate a graph showing the relations between nodes in NODE-QUERY. HTML style."
    :override #'org-roam-graph--build
    (unless org-roam-graph-executable
      (user-error "Can't find %s executable.  Please check if it is in your path"
                  org-roam-graph-executable))
    (let* ((node-query (or node-query
                           `[:select [file titles]
                                     :from titles
                                     ,@(org-roam-graph--expand-matcher 'file t)]))
           (graph      (org-roam-graph--dot node-query))
           (temp-dot   (make-temp-file "graph." nil ".dot" graph))
           (temp-graph (make-temp-file "graph." nil ".svg"))
           (temp-html  (make-temp-file "graph." nil ".html")))
      (call-process org-roam-graph-executable nil 0 nil
                    temp-dot "-Tsvg" "-o" temp-graph)
      (sleep-for 0.1)
      (write-region (format +org-roam-graph--html-template (f-read-text temp-graph)) nil temp-html)
      temp-html)))
;; Graph Behaviour:2 ends here

;; End Org-roam

;; Add yasnippet support for all company backends
;; https://github.com/syl20bnr/spacemacs/pull/179
(defvar company-mode/enable-yas t
  "Enable yasnippet for all backends.")

(defun company-mode/backend-with-yas (backend)
  (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
      backend
    (append (if (consp backend) backend (list backend))
            '(:with company-yasnippet))))

(setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))
(require 'company)
(setq company-idle-delay 0.2
      company-minimum-prefix-length 3)


(use-package! org-super-agenda
  :after org-agenda
  :init
  (setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil
      org-agenda-compact-blocks t
      org-agenda-start-day nil ;; i.e. today
      org-agenda-span 1
      org-agenda-start-on-weekday nil)
  (setq org-agenda-custom-commands
        '(("c" "Super view"
           ((agenda "" ((org-agenda-overriding-header "")
                        (org-super-agenda-groups
                         '((:name "Today"
                                  :time-grid t
                                  :date today
                                  :order 1)))))
            (alltodo "" ((org-agenda-overriding-header "")
                         (org-super-agenda-groups
                          '((:log t)
                            (:name "To refile"
                                   :file-path "ref\\.org")
                            (:name "Next to do"
                                   :todo "NEXT"
                                   :order 1)
                            (:name "Important"
                                   :priority "A"
                                   :order 6)
                            (:name "Today's tasks"
                                   :file-path "journal/")
                            (:name "Due Today"
                                   :deadline today
                                   :order 2)
                            (:name "Scheduled Soon"
                                   :scheduled future
                                   :order 8)
                            (:name "Overdue"
                                   :deadline past
                                   :order 7)
                            (:name "Meetings"
                                   :and (:todo "MEET" :scheduled future)
                                   :order 10)
                            (:discard (:not (:todo "TODO")))))))))))
  :config
  (org-super-agenda-mode))

;; in ~/.doom.d/+bindings.el
(map! :leader
      (:prefix ("j" . "journal") ;; org-journal bindings
        :desc "Create new journal entry" "j" #'org-journal-new-entry
        :desc "Open previous entry" "p" #'org-journal-open-previous-entry
        :desc "Open next entry" "n" #'org-journal-open-next-entry
        :desc "Search journal" "s" #'org-journal-search-forever))

;; The built-in calendar mode mappings for org-journal
;; conflict with evil bindings
(map!
 (:map calendar-mode-map
   :n "o" #'org-journal-display-entry
   :n "p" #'org-journal-previous-entry
   :n "n" #'org-journal-next-entry
   :n "O" #'org-journal-new-date-entry))

;; Local leader (<SPC m>) bindings for org-journal in calendar-mode
;; I was running out of bindings, and these are used less frequently
;; so it is convenient to have them under the local leader prefix
(map!
 :map (calendar-mode-map)
 :localleader
 "w" #'org-journal-search-calendar-week
 "m" #'org-journal-search-calendar-month
 "y" #'org-journal-search-calendar-year)

;; Format org-mode clocktables the way we want to include Effort
;; In the clocktable header:
;; :formatter my/clocktable-write
(defun my/clocktable-write (&rest args)
  "Custom clocktable writer.
Uses the default writer but shifts the first column right 3 columns,
and names the estimation error column."
  (apply #'org-clocktable-write-default args)
  (save-excursion
    (forward-char) ;; move into the first table field
    (org-table-move-column-right)
    (org-table-move-column-right)
    (org-table-move-column-right)
    (org-table-next-field)
    (insert "Est. error")
    (org-table-previous-field)))

(use-package deft
  :after org
  :bind
  ("C-c n d" . deft)
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory "~/org/")
  (deft-ignore-file-regexp "\\(?:.sync\\)")
  )


;; Start Emacs maximized
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; <gs SPC> works across all visible windows
(setq avy-all-windows t)

(setq global-org-pretty-table-mode t)


(setq ob-mermaid-cli-path "/usr/local/bin/mmdc")


(use-package org-download
  :after org
  :bind
  (:map org-mode-map
        (("s-Y" . org-download-screenshot)
         ("s-y" . org-download-yank)))
  :custom
  org-download-image-dir "~/org/roam/img/"
  )


(use-package! org-re-reveal
  :init
  (setq org-reveal-external-plugins '(
                                      "{src: '%splugin/menu/menu.js'}"
                                      "{ src: '%splugin/quiz/js/quiz.js', async: true, callback: function() { prepareQuizzes({preventUnanswered: true, skipStartButton: true}); } }"
                                      ))
  )
