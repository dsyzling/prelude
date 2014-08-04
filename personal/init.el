;;; init.el --- My customisations for prelude
;;; Commentary:

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
  (set-face-font 'default "-unknown-Consolas-bold-normal-normal-*-16-*-*-*-m-0-iso10646-1")
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-mode config

(setq org-agenda-files (list "~/Dropbox/home/org/personal.org"
                             "~/Dropbox/home/org/goals.org"
                             "~/Dropbox/home/org/journal.org"))
(setq org-log-done 'time)
(custom-set-variables
 '(org-agenda-ndays 7)
 '(org-deadline-warning-days 14)
                                        ;'(org-agenda-show-all-dates t)
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
