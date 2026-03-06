;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; =============================================================================
;; ### PERFORMANCE OPTIMIZATION
;; =============================================================================

;; Add cargo/bin to PATH for emacs-lsp-booster
(add-to-list 'exec-path (expand-file-name "~/.cargo/bin"))

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

;; (setq user-full-name "Your Name"
;;       user-mail-address "you@email.com")

;; Fonts are defined here (optional)
;; (setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))

(setq doom-theme 'doom-one)
(setq display-line-numbers-type t)


;; =============================================================================
;; ### ORG MODE & ROAM
;; =============================================================================

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Notes/org/"
      org-roam-directory "~/Notes/org/7_roam/")

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


;; =============================================================================
;; ### LSP CONFIGURATION
;; =============================================================================

;; lsp-booster - Zero-latency LSP
;; Uses emacs-lsp-booster as a proxy for all LSP servers
(defadvice! lsp-booster--advice-lsp-resolve-ipc-method (orig-fun &rest args)
  "Advice lsp-resolve-ipc-method to use emacs-lsp-booster if available."
  :around #'lsp-resolve-ipc-method
  (let ((res (apply orig-fun args)))
    (if (and (listp res)
             (not (file-remote-p default-directory))
             (executable-find "emacs-lsp-booster"))
        (progn
          (message "Using emacs-lsp-booster for %s" (car res))
          (append (list "emacs-lsp-booster") res))
      res)))

;; Disable JSON-RPC logging for performance
(fset #'jsonrpc--log-event #'ignore)


;; =============================================================================
;; ### WEB DEVELOPMENT
;; =============================================================================

;; -----------------------------------------------------------------------------
;; Web Indentation - 2 spaces standard
;; -----------------------------------------------------------------------------
(setq js-indent-level 2)
(setq typescript-indent-level 2)
(setq css-indent-offset 2)
(setq web-mode-code-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-markup-indent-offset 2)

;; Prevent web-mode from auto-guessing indentation (strict adherence to 2 spaces)
(setq web-mode-enable-auto-indentation nil)

;; Prevent web-mode from auto-quoting attributes (reduces friction)
(setq web-mode-enable-auto-quoting nil)

;; Ensure evil respects 2-space indentation in web-mode
(setq evil-shift-width 2)

;; -----------------------------------------------------------------------------
;; Node.js REPL - Interactive vanilla JS development
;; -----------------------------------------------------------------------------
(use-package! nodejs-repl
  :commands nodejs-repl
  :config
  (setq nodejs-repl-command "node"))

;; -----------------------------------------------------------------------------
;; Emmet Mode - Expand CSS-like selectors to HTML
;; -----------------------------------------------------------------------------
(use-package! emmet-mode
  :hook ((web-mode css-mode js-mode js2-mode rjsx-mode) . emmet-mode)
  :config
  ;; Allow emmet to work in JSX/TSX
  (add-to-list 'emmet-jsx-major-modes 'js2-mode)
  (add-to-list 'emmet-jsx-major-modes 'typescript-mode)
  (add-to-list 'emmet-jsx-major-modes 'rjsx-mode))

;; -----------------------------------------------------------------------------
;; Apheleia - Async Formatter (non-blocking)
;; -----------------------------------------------------------------------------
;; Apheleia formats code asynchronously without blocking the editor
;; Uses dynamic patching to preserve cursor position
(use-package! apheleia
  :config
  ;; Enable apheleia globally for all buffers
  (apheleia-global-mode 1)

  ;; Configure formatters for different modes
  ;; Prettier handles JS, TS, CSS, JSON, HTML, YAML
  (setf (alist-get 'prettier apheleia-formatters) '("prettier" "--stdin-filepath" filepath))

  ;; Map modes to formatters
  (setq apheleia-mode-alist
        (append '((js-mode . prettier)
                  (js2-mode . prettier)
                  (js-ts-mode . prettier)
                  (rjsx-mode . prettier)
                  (typescript-mode . prettier)
                  (typescript-ts-mode . prettier)
                  (css-mode . prettier)
                  (css-ts-mode . prettier)
                  (scss-mode . prettier)
                  (json-mode . prettier)
                  (web-mode . prettier)
                  (html-mode . prettier)
                  (yaml-mode . prettier)
                  (js-json-mode . prettier))
                apheleia-mode-alist))

  ;; Disable LSP formatting hooks - let apheleia handle it
  (setq-hook! 'web-mode-hook +format-with-lsp nil)
  (setq-hook! 'js2-mode-hook +format-with-lsp nil)
  (setq-hook! 'js-ts-mode-hook +format-with-lsp nil)
  (setq-hook! 'typescript-mode-hook +format-with-lsp nil)
  (setq-hook! 'typescript-ts-mode-hook +format-with-lsp nil)
  (setq-hook! 'css-mode-hook +format-with-lsp nil))

;; -----------------------------------------------------------------------------
;; Rainbow Mode - Colorize color codes
;; -----------------------------------------------------------------------------
(use-package! rainbow-mode
  :hook (css-mode-hook web-mode-hook html-mode-hook sass-mode-hook)
  :config
  (setq rainbow-html-colors t)
  (setq rainbow-x-colors t))


;; =============================================================================
;; ### TREE-SITTER CONFIGURATION
;; =============================================================================

;; Force Doom to use the ABI 14 compatible grammars for C and C++
(set-tree-sitter! 'c-mode 'c-ts-mode 
  `((c :url "https://github.com/tree-sitter/tree-sitter-c" :rev "v0.20.6")))

(set-tree-sitter! 'c++-mode 'c++-ts-mode 
  `((cpp :url "https://github.com/tree-sitter/tree-sitter-cpp" :rev "v0.20.5")))

;; Enable tree-sitter for web modes (if not already done by module)
(after! web-mode
  (when (fboundp 'treesit-available-p)
    (add-to-list 'major-mode-remap-alist '(js-mode . js-ts-mode))
    (add-to-list 'major-mode-remap-alist '(js-jsx-mode . jsx-ts-mode))))

(after! css-mode
  (when (fboundp 'treesit-available-p)
    (add-to-list 'major-mode-remap-alist '(css-mode . css-ts-mode))))


;; =============================================================================
;; ### SNIPPETS (YASNSIPPETS)
;; =============================================================================

;; Custom vanilla JS snippets can be added here
;; Example:
;; (after! yasnippet
;;   (setq yas-snippet-dirs '("~/.doom.d/snippets")))


;; =============================================================================
;; ### KEYBINDINGS
;; =============================================================================

;; Web development keybindings
;; Use SPC c f for format (doom's default), or C-c C-f for apheleia
(after! web-mode
  (map! :map web-mode-map
        "C-c C-e" #'emmet-expand-line))     ; Expand emmet


;; =============================================================================
;; ### FUTURE: DAP DEBUGGING (not yet configured)
;; =============================================================================
;; To enable browser debugging:
;; 1. Install Firefox/Chrome debugger extension
;; 2. Configure dap-firefox-debug-program
;; 3. Add dap-mode configuration
;; See: https://emacs-lsp.github.io/dap-mode/
