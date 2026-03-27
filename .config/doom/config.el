;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; =============================================================================
;; ### PERFORMANCE OPTIMIZATION
;; =============================================================================

;; GC optimization - boost threshold during startup for faster load times
(defadvice! +my-reduce-gc-delay-a ()
  "Reduce GC delay during startup."
  :before-while #'doom-initialize
  (setq gc-cons-threshold most-positive-fixnum)
  (setq gc-cons-percentage 0.6))

(add-hook! 'emacs-startup-hook
  (setq gc-cons-threshold (* 16 1024 1024))  ; 16MB after startup
  (setq gc-cons-percentage 0.1))


;; =============================================================================
;; ### USER & BASIC UI
;; =============================================================================

(setq doom-theme 'doom-one)
(setq display-line-numbers-type t)

;; Typography for better writing
;; (setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14)
;;       doom-variable-pitch-font (font-spec :family "Fira Sans" :size 15))


;; =============================================================================
;; ### ORG MODE & ROAM
;; =============================================================================

;; Set the base directory for all your notes
(setq org-directory "~/Notes/org/"
      org-roam-directory "~/Notes/org/7_roam/")

;; Ensure directories exist
(make-directory org-directory t)
(make-directory org-roam-directory t)

;; Keybindings for moving headings easily
(after! org
  (map! :map org-mode-map
        :n "M-j" #'org-metadown
        :n "M-k" #'org-metaup))

;; Org-Roam-UI configuration for visual knowledge graphs
(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start nil))

;; Enable rainbow-mode only for Org and writing modes to see color codes in notes
(add-hook! '(org-mode-hook markdown-mode-hook) #'rainbow-mode)


;; =============================================================================
;; ### WRITING STUDIO ENHANCEMENTS
;; =============================================================================

;; Automatically enable spell checking in Org and Markdown
;;(add-hook! '(org-mode-hook markdown-mode-hook) #'flyspell-mode)

;; Org-modern: Makes Org-mode look like a clean document
(use-package! org-modern
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-star '("◉" "○" "◈" "◇" "✳")
        org-modern-list '((?+ . "•") (?- . "–"))))

;; Capture Templates for Quick Notes
(after! org
  (setq org-capture-templates
        '(("t" "Personal todo" entry
           (file+headline +org-capture-todo-file "Inbox")
           "* TODO %?\n%i\n%a" :prepend t)
          ("n" "Personal notes" entry
           (file+headline +org-capture-notes-file "Inbox")
           "* %u %?\n%i\n%a" :prepend t)
          ("j" "Journal" entry
           (file+olp+datetree +org-capture-journal-file)
           "* %U %?\n%i\n%a" :prepend t))))
