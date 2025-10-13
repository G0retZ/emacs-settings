(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(setq
 frame-title-format "emacs – %b"        ; Put something useful in the status bar.
 column-number-indicator-zero-based nil ; start column numeration from 1
;; completion-auto-select t               ; Completion convenience
 )

;; Any Customize-based settings should live in custom.el, not here.
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)

;; Speedbar
(use-package sr-speedbar
  :load-path "manual/")
(global-set-key (kbd "s-s") 'sr-speedbar-toggle)

;; Window and Frame management
(global-set-key (kbd "M-o") 'other-window)
;;(windmove-default-keybindings)
(advice-add 'other-window :before
            (defun other-window-split-if-single (&rest _)
              "Split the frame if there is a single window."
              (when (one-window-p) (split-window-sensibly))))

;; Imenu
(global-set-key (kbd "M-i") #'imenu-anywhere)

;; Hippie
(global-set-key [remap dabbrev-expand] 'hippie-expand)

;; Slurp environment variables from the shell.
;; a.k.a. The Most Asked Question On r/emacs
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; Diminish some minor modes
(use-package diminish)

;; Magit
(use-package magit
  :diminish magit-auto-revert-mode
  :diminish auto-revert-mode
  :custom
  (magit-remote-set-if-missing t)
  (magit-diff-refine-hunk t)
  :config
  (magit-auto-revert-mode t)
  (add-to-list 'magit-no-confirm 'stage-all-changes))

;;(which-key-setup-minibuffer)

;; LLM
(use-package ellama
  :init
  (setopt ellama-auto-scroll t)
  (require 'llm-github)
  (setq llm-warn-on-nonfree nil))


;; Font
(ignore-errors
  (set-frame-font "JuliaMono 12"))

;; buffers arrangement management
(use-package zoom
  :diminish
  :config
  (zoom-mode t))

;; Dislog help/docs
(use-package eldoc-box
  :diminish
  :ensure t)

;; Persist history over Emacs restarts. Vertico sorts by history position.
;;(use-package savehist
;;  :ensure t
;;  :init
;;  (savehist-mode))

;; Emacs minibuffer configurations.
(use-package emacs
  :custom
  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (tab-always-indent 'complete)
  ;; Support opening new minibuffers from inside existing minibuffers.
  ;;(enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

;; A bunch of great search and navigation commands
;;(use-package consult
;;  :ensure t
;;   :hook (completion-list-mode . consult-preview-at-point-mode)
;;   :custom
;;   (consult-preview-key nil)
;;   (consult-narrow-key nil)
;;   :config
;;   (consult-customize consult-theme consult-line consult-line-at-point :preview-key '(:debounce 0.2 any))
;; )

;; Annotations in the minibuffer, i.e a description of the function next to the name in M-x
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

;; Completion style and fuzzy matching
;;(use-package orderless
;;  :custom
;;  (completion-styles '(orderless basic))
;;  (completion-category-defaults nil)
;;  (completion-category-overrides '((file (styles partial-completion)))))

;; Nice icons
;;(use-package kind-icon
;;  :ensure t
;;  :after corfu
;;  :config
;;  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;; More nice icons
;;(use-package nerd-icons
;;   :custom
;;   The Nerd Font you want to use in GUI
;;   "Symbols Nerd Font Mono" is the default and is recommended
;;   but you can use any other Nerd Font if you want
;;   (nerd-icons-font-family "Symbols Nerd Font Mono")
;;  )


(defun setup-init()
  "Open this very file."
  (interactive)
  (find-file user-init-file))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Startup screen
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 'logo
        dashboard-center-content t
        dashboard-items '((recents  . 5)
                          (projects . 10))
        dashboard-set-footer nil))
(setq initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name)))

;; More nice icons
;;(use-package all-the-icons)
;;(use-package all-the-icons-dired)
;;(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
;;(add-hook 'dired-mode-hook (lambda() 'dired-hide-details-mode 1))

;; Uncommitted changes
(use-package diff-hl
  :ensure t
  :demand t
  :config
  (global-diff-hl-mode)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode-unless-remote))

;; Colorful parentheses
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

;; Groovy
;(use-package groovy-mode)

;; YAML
(use-package yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

;; Kotlin
(use-package kotlin-mode)

;; Dart
(use-package dart-mode)
;;(reformatter-define dart-format
;;  :program "dart"
;;  :args '("format"))

;; Godot
(require 'gdscript-mode)
(use-package gdscript-mode
  :hook (gdscript-mode . eglot-ensure))

;;(with-eval-after-load "dart-mode"
;;  (define-key dart-mode-map (kbd "C-c C-o") 'dart-format-buffer))

;; (with-eval-after-load "dart-mode"
;;   (bind-key "C-c C-o" 'dart-format-buffer dart-mode-map))

;; Flutter
(use-package flutter)

;; Help/docs
(defun consult-line-at-point ()
  (interactive)
    (consult-line (word-at-point)))

(add-hook 'magit-status-mode-hook
          (lambda()
            (local-unset-key (kbd "SPC"))))

(add-hook 'magit-diff-mode-hook
          (lambda()
            (local-unset-key (kbd "SPC"))))

(require 'dired)
(add-hook 'dired-mode-hook
          (lambda()
            (local-unset-key (kbd "<normal-state> SPC"))))

(add-hook 'diff-hl-dired-mode-hook
          (lambda()
            (local-unset-key (kbd "SPC"))))

;; Formatter
(use-package format-all)
(add-hook 'go-mode-hook 'format-all-mode)
(add-hook 'typescript-mode-hook 'format-all-mode)
(add-hook 'dart-mode-hook 'format-all-mode)
(add-hook 'tsx-mode-hook 'format-all-mode)
(add-hook 'format-all-mode-hook 'format-all-ensure-formatter)

;; (require 'tree-sitter)
;; (require 'tree-sitter-hl)
;; (require 'tree-sitter-langs)
;; (require 'tree-sitter-debug)
;; (require 'tree-sitter-query)

(setq treesit-language-source-alist
      '(
	(bash "https://github.com/tree-sitter/tree-sitter-bash")
	(c "https://github.com/tree-sitter/tree-sitter-c")
	(cpp "https://github.com/tree-sitter/tree-sitter-cpp")
	(css "https://github.com/tree-sitter/tree-sitter-css")
	(csv "https://github.com/tree-sitter-grammars/tree-sitter-csv" "master" "csv/src")
	(dart "https://github.com/UserNobody14/tree-sitter-dart")
	(elisp "https://github.com/Wilfred/tree-sitter-elisp")
	(gitignore "https://github.com/shunsambongi/tree-sitter-gitignore")
	(gdscript "https://github.com/PrestonKnopp/tree-sitter-gdscript")
	(go "https://github.com/tree-sitter/tree-sitter-go")
	(groovy "https://github.com/murtaza64/tree-sitter-groovy")
	(html "https://github.com/tree-sitter/tree-sitter-html")
	(java "https://github.com/tree-sitter/tree-sitter-java")
	(javascript "https://github.com/tree-sitter/tree-sitter-javascript")
	(json "https://github.com/tree-sitter/tree-sitter-json")
	(kotlin "https://github.com/fwcd/tree-sitter-kotlin")
	(psv "https://github.com/tree-sitter-grammars/tree-sitter-csv" "master" "psv/src")
	(python "https://github.com/tree-sitter/tree-sitter-python")
	(toml "https://github.com/tree-sitter/tree-sitter-toml")
	(tsv "https://github.com/tree-sitter-grammars/tree-sitter-csv" "master" "tsv/src")
	(tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
	(typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
	(xml "https://github.com/tree-sitter-grammars/tree-sitter-xml" "master" "xml/src")
	(yaml "https://github.com/ikatyang/tree-sitter-yaml")))
;; (mapc #'treesit-install-language-grammar (mapcar #'car treesit-language-source-alist))

(use-package yasnippet
  :ensure t
  :init
  ;; Enable YASnippet globally
  (yas-global-mode 1)
  :config
  ;; Set snippet directories
  (setq yas-snippet-dirs '("~/.emacs.d/snippets"))
  (define-key yas-minor-mode-map (kbd "<tab>") nil)
  (define-key yas-minor-mode-map (kbd "TAB") nil)
  (define-key yas-minor-mode-map (kbd "C-c y") 'yas-expand)

  ;; Integrate YASnippet with completion-at-point-functions
  (defun my/yas-capf ()
    "Add YASnippet completion to completion-at-point-functions with orderless support."
    (when (bound-and-true-p yas-minor-mode)
      (let ((completions (yas--get-snippets-as-capf)))
        (when completions
          (nconc completions '(:company-match #'orderless-try-completion))
          completions))))

  ;; Add YASnippet to completion-at-point-functions
  (add-hook 'completion-at-point-functions #'my/yas-capf nil t))

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet
  :config
  (yasnippet-snippets-initialize))

(diminish 'which-key-mode)
(diminish 'eldoc-mode)
(diminish 'dired-mode)
(diminish 'all-the-icons-dired-mode)
(diminish 'diff-hl-dired-mode)
