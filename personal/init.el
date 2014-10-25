;;; init.el --- My customisations for prelude
;;; Commentary:

;; add melpa stable to our package archives
(add-to-list 'package-archives
             '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/") t)

;; disable prelude guru mode
(setq prelude-guru nil)

(when (eq system-type 'windows-nt)
    (set-face-font 'default "-outline-Consolas-bold-r-normal-normal-15-112-96-96-c-*-iso8859-1")
  ;; use cygwin find on windows with grep and windows cmd console.
  ;;(setq grep-find-template "c:\\cygwin\\bin\\find . <X> -type f <F> -exec grep <C> -n <R> {} NUL \";\"")
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mac OS X customisations

(when (eq system-type 'darwin)
  ;; enable cmd key to be used as emacs meta key
  (setq mac-command-modifier 'meta)
  ;;(set-face-font 'default "-unknown-Consolas-bold-normal-normal-*-16-*-*-*-m-0-iso10646-1")
  (set-face-font 'default "-unknown-Inconsolata-bold-normal-normal-*-17-*-*-*-m-0-iso10646-1")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; general editing preferences

;; reindent automatically when return is pressed
(define-key global-map (kbd "RET") 'newline-and-indent)

;; enable window numbering mode
(window-numbering-mode)

;; don't show scroll bars
(scroll-bar-mode 0)

;; for now let's use the default theme with a different background colour
(set-background-color "#211e1e")

(disable-theme 'zenburn)
(load-theme 'twilight t)

;; and make comment italic for the twilight theme
(custom-theme-set-faces
 'twilight
 '(font-lock-comment-face ((t (:italic t :foreground "#5F5A60")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-mode config

(setq org-agenda-files (list "~/Dropbox/home/org/personal.org"
                             "~/Dropbox/home/org/goals.org"
                             "~/Dropbox/home/org/journal.org"))

;; set org mode wrap at 80 cols
(add-hook 'org-mode-hook 'turn-on-auto-fill)
(add-hook 'org-mode-hook
          '(lambda() (set-fill-column 80)))

(setq org-log-done 'time)
(custom-set-variables
 ;; hide stars and indent note items automatically
 '(org-startup-indented t)
 '(org-agenda-ndays 7)
 '(org-deadline-warning-days 14)
 ;;'(org-agenda-show-all-dates t)
 '(org-agenda-skip-deadline-if-done t)
 '(org-agenda-skip-scheduled-if-done t)
 '(org-blank-before-new-entry nil)
 '(org-agenda-start-on-weekday nil)
 '(org-completion-use-ido t)
 '(org-agenda-window-setup 'current-window))

;; widen category field a little
(setq org-agenda-prefix-format "  %-17:c%?-12t% s")

;; return key follow hyperlink
(setq org-return-follows-link t)

(define-key global-map "\C-cr" 'org-remember)

;; refile targets
(setq org-refile-targets (quote (("personal.org" :level . 1))))

(defun wicked/remember-review-file ()
  "Open `remember-data-file'."
  (interactive)
  (find-file "~/Dropbox/home/org/newgtd.org"))
(global-set-key (kbd "C-c R") 'wicked/remember-review-file)

(global-set-key (kbd "C-c j") 'org-capture)
(setq org-capture-templates
      '(
        ("t" "Todo" entry
         (file+headline "~/Dropbox/home/org/journal.org" "Journal")
         "\n\n** TODO %?\nSCHEDULED: %t\n%i%a\n\n\n"
         :empty-lines 1)

        ("n" "Note" entry
         (file+headline "~/Dropbox/home/org/journal.org" "Journal")
         "\n\n** %?\n%U\n%i%a\n\n\n"
         :empty-lines 1)

        ("j" "Journal" entry (file+datetree
                              "~/Dropbox/home/org/journal.org")
         "** %^{Heading}\n%?")
        )
      )

;; our org-remember templates
;; we can set our default org notes file - but we'll specify a template for todo items
;;(setq org-default-notes-file (concat org-directory "/notes.org"))
(setq org-remember-templates
      '(("Todo" ?t "* TODO %?\n  %i\n  %a" "~/Dropbox/home/org/newgtd.org" "Tasks")
	("Articles" ?a "* %?\n  %i\n  %a" "~/Dropbox/home/org/newgtd.org" "Articles")
        ("Journal" ?j "\n* %^{topic} %T \n%i%?\n" "~/Dropbox/home/org/journal.org")
	("Someday" ?s "* %?\n  %i\n  %a" "~/Dropbox/home/org/newgtd.org" "Someday")))


;; erc customisations - remove join, leave quit messages
(setq erc-hide-list '("JOIN" "PART" "QUIT"))

;; our custom twlight colour theme
;;(require 'color-theme-twilight-ds)
;;(color-theme-twilight-ds)


;; Cider/Clojure customisation


(add-hook 'cider-repl-mode-hook 'paredit-mode)
(add-hook 'cider-mode-hook 'paredit-mode)

;; these should be enabled by prelude by default - but might be useful
;; for other scheme and lisp modes.
;;(add-hook 'cider-repl-mode-hook 'subword-mode)
;;(add-hook 'cider-repl-mode-hook 'company-mode)
;;(add-hook 'cider-mode-hook 'company-mode)

(defun cider-repl-command (cmd)
  "Execute commands on the cider repl"
  (cider-switch-to-repl-buffer)
  (goto-char (point-max))
  (insert cmd)
  (cider-repl-return)
  (cider-switch-to-last-clojure-buffer))

(defun cider-repl-reset ()
  "Assumes reloaded + tools.namespace is used to reload everything"
  (interactive)
  (save-some-buffers)
  (cider-repl-command "(user/reset)"))

(defun cider-reset-test-run-tests ()
  (interactive)
  (cider-repl-reset)
  (cider-test-run-tests))

;; (define-key cider-mode-map (kbd "C-c r") 'cider-repl-reset)
;; (define-key cider-mode-map (kbd "C-c .") 'cider-reset-test-run-tests)


;; Racket/Geiser customisation

;; allow C-c C-c to eval current definition - same as M-C-x
(add-hook 'geiser-mode-hook
          '(lambda ()
             (define-key geiser-mode-map (kbd "C-c C-c") 'geiser-eval-definition)))
