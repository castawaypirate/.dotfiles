;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; ------------------------------------------------------------------
;; --- USER & BASIC UI ---
;; ------------------------------------------------------------------
;;(setq user-full-name "Your Name"
;;      user-mail-address "you@email.com")

;; Fonts are defined here (optional, kept commented out as per your original)
;; (setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))

(setq doom-theme 'doom-one)
(setq display-line-numbers-type t)


;; ------------------------------------------------------------------
;; --- ORG MODE & ROAM ---
;; ------------------------------------------------------------------
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Notes/org/"
      org-roam-directory "~/Notes/org/7_roam/") ;; <--- VERIFY THIS PATH IS CORRECT

;; Keybindings
(after! org
  (map! :map org-mode-map
        :n "M-j" #'org-metadown
        :n "M-k" #'org-metaup))

;; Org-Roam-UI configuration
(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start nil))


;; ------------------------------------------------------------------
;; --- WEB DEVELOPMENT ---
;; ------------------------------------------------------------------
;; Set indentation to 2 spaces for all web technologies
(setq js-indent-level 2)
(setq typescript-indent-level 2)
(setq css-indent-offset 2)
(setq web-mode-code-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-markup-indent-offset 2)

;; Enable Emmet mode for HTML, CSS, and React/JSX
(use-package! emmet-mode
  :hook ((web-mode css-mode js-mode js2-mode rjsx-mode) . emmet-mode)
  :config
  ;; Allow emmet to work in JSX/TSX
  (add-to-list 'emmet-jsx-major-modes 'js2-mode)
  (add-to-list 'emmet-jsx-major-modes 'typescript-mode)
  (add-to-list 'emmet-jsx-major-modes 'rjsx-mode))

;; Disable LSP formatting for web modes so 'format-all' (Prettier) handles it
(setq-hook! 'web-mode-hook +format-with-lsp nil)
(setq-hook! 'js2-mode-hook +format-with-lsp nil)
(setq-hook! 'typescript-mode-hook +format-with-lsp nil)
(setq-hook! 'css-mode-hook +format-with-lsp nil)

;; Colorize color strings (e.g. #ff0000) in CSS and HTML
(add-hook! '(css-mode-hook web-mode-hook) #'rainbow-mode)
