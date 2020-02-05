(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp/"))

(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

(unless (package-installed-p 'use-package)
  (progn
    (package-refresh-contents)
    (package-install 'use-package)))

(use-package dash :ensure t)

(defun ensure-in-path (newpath)
  "Ensures that newpath is present in PATH and exec-path, but only if it exists"
  (if (file-directory-p newpath)
    (progn
      (when (not (-contains? (parse-colon-path (getenv "PATH")) newpath))
	(setenv "PATH" (concat newpath ":" (getenv "PATH"))))
      (when (not (-contains? exec-path newpath))
	(setq exec-path (cons newpath exec-path))))

    (display-warning
     "init"
     (format "Path '%s' either doesn't exist or isn't a dir; not adding to PATH" newpath))))

(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize)

  (ensure-in-path "/usr/local/texlive/2018/bin/x86_64-darwin") ;; Necessary for latex in orgmode
  (ensure-in-path "/Users/treed/.nix-profile/bin") ;; Nix

  :ensure t)

(use-package paradox
  :ensure t)

(eval-when-compile
  (require 'use-package))

(use-package delight
  :ensure t)

(use-package undo-tree
  :ensure t
  :delight
  :config
  (setq undo-tree-enable-undo-in-region t)
  (global-undo-tree-mode))

(use-package solarized-theme
  :config
  (setq solarized-height-minus-1 1.0)
  (setq solarized-height-plus-1 1.0)
  (setq solarized-height-plus-2 1.0)
  (setq solarized-height-plus-3 1.0)
  (setq solarized-height-plus-4 1.0)
  :init
  (load-theme 'solarized-light t)
  :ensure t)

;; Get rid of the toolbar
(tool-bar-mode -1)

;; Correctly set modifiers
(setq mac-option-modifier 'meta
      mac-command-modfier 'super)

(use-package general
  :init
  (setq general-override-states '(insert emacs hybrid normal visual motion operator replace))
  :ensure t)

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package spaceline
  :config
  (require 'spaceline-config)
  (setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state)
  (spaceline-emacs-theme)
 (spaceline-compile
  ; left side
  '((evil-state
     :priority 100)
    (anzu :priority 95)
    auto-compile
    (projectile-root :when active)
    ((buffer-modified buffer-size buffer-id remote-host)
     :priority 98)
    (major-mode :priority 79)
    (process :when active)
    ((flycheck-error flycheck-warning flycheck-info)
     :when active
     :priority 89)
    (minor-modes :when active
     :separator ","
                 :priority 9)
    (mu4e-alert-segment :when active)
    (version-control :when active
                     :priority 78))
  ; right side
  '(which-function
    (python-pyvenv :fallback python-pyenv)
    (purpose :priority 94)
    (selection-info :priority 95)
    input-method
    ((buffer-encoding-abbrev
      point-position
      line-column)
     :separator " | "
     :priority 96)
    (global :when active)
    (buffer-position :priority 99)
    (hud :priority 99)))
  :ensure t)

(use-package spacebar
  :config
  (spacebar-mode)
  :ensure t)


(use-package ivy
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-height 20)
  (ivy-mode 1)
  :delight
  :ensure t)

(use-package swiper
  :ensure t)

(use-package counsel
  :ensure t)

(use-package counsel-projectile
  :ensure t)


(use-package gnuplot
  :ensure t)

(use-package org
  :config
  (plist-put org-format-latex-options :scale 2.0)
  (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '(
     (gnuplot . t)
     (dot . t)
     (abc . t)
     ))
  (setq org-directory "/Users/treed/Dropbox/Org")
  (setq org-agenda-files '("/Users/treed/Dropbox/Org"))
  (setq org-refile-targets '((nil :maxlevel . 9) (org-agenda-files :maxlevel . 9)))
  (setq org-refile-use-outline-path 'file)
  (setq org-outline-path-complete-in-steps nil)
  (setq org-clock-persist 'history)
  (org-clock-persistence-insinuate)
  (setq org-clock-report-include-clocking-task t)
  (setq org-refile-allow-creating-parent-nodes 'confirm)

  (setq org-hide-emphasis-markers t
        org-startup-indented t
        org-bullets-bullet-list '(" ")
        org-pretty-entities t)

  (setq org-capture-templates
	'(("t" "Todo" entry (file "inbox.org")
	   "* TODO %?\n")
	  ("w" "Work")
	  ("wc" "Conversation" entry (file+headline "work.org" "Conversations")
	   "*** Conversation With %^{Whom} At %U\n%?\n" :clock-in t :clock-resume t)
	  ("wr" "Review" entry (file+headline "work.org" "Reviews")
	   "*** Review %^{What} At %U\n%?\n" :clock-in t :clock-resume t)))

  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
  (let* ((variable-tuple
          (cond ((x-list-fonts "ETBembo")         '(:font "ETBembo"))
                ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
                ((x-list-fonts "Verdana")         '(:font "Verdana"))
                ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
                (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
         (base-font-color     (face-foreground 'default nil 'default))
         (headline           `(:inherit default :weight bold :foreground ,base-font-color)))

    (custom-theme-set-faces
     'user
     `(org-level-8 ((t (,@headline ,@variable-tuple))))
     `(org-level-7 ((t (,@headline ,@variable-tuple))))
     `(org-level-6 ((t (,@headline ,@variable-tuple))))
     `(org-level-5 ((t (,@headline ,@variable-tuple :height 1.1))))
     `(org-level-4 ((t (,@headline ,@variable-tuple :height 1.25))))
     `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.5))))
     `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.75))))
     `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.9))))
     `(org-document-title ((t (,@headline ,@variable-tuple :height 2.0 :underline nil)))))
     '(org-block                 ((t (:inherit fixed-pitch))))
     '(org-table                 ((t (:inherit fixed-pitch))))
     '(org-document-info         ((t (:foreground "dark orange"))))
     '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
     '(org-link                  ((t (:foreground "royal blue" :underline t))))
     '(org-meta-line             ((t (:inherit (font-lock-comment-face fixed-pitch)))))
     '(org-property-value        ((t (:inherit fixed-pitch))) t)
     '(org-special-keyword       ((t (:inherit (font-lock-comment-face fixed-pitch)))))
     '(org-tag                   ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
     '(org-verbatim              ((t (:inherit (shadow fixed-pitch)))))
     '(org-indent                ((t (:inherit (org-hide fixed-pitch))))))

  (custom-theme-set-faces
   'user
   '(variable-pitch ((t (:family "ETBembo" :height 180 :weight light))))
   '(fixed-pitch ((t (:family "Menlo" :slant normal :weight normal :height 1.0 :width normal)))))

  (add-hook 'org-mode-hook 'variable-pitch-mode)
  (add-hook 'org-mode-hook 'visual-line-mode))

(use-package org-bullets
  :after org
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  :ensure t)

(use-package org-mru-clock
  :ensure t
  :bind* (("C-c C-x i" . org-mru-clock-in)
          ("C-c C-x C-j" . org-mru-clock-select-recent-task))
  :init
  (setq org-mru-clock-how-many 100
        org-mru-clock-completing-read #'ivy-completing-read))

(use-package evil-org
  :ensure t
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(setq evil-motion-state-modes nil)
(setq evil-emacs-state-modes nil)

(use-package deadgrep
  :commands deadgrep
  :init
  (setq deadgrep-project-root-function 'projectile-project-root)
  :ensure t)

(use-package dumb-jump
  :bind (("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g b" . dumb-jump-back)
         ("M-g i" . dumb-jump-go-prompt)
         ("M-g x" . dumb-jump-go-prefer-external)
         ("M-g z" . dumb-jump-go-prefer-external-other-window))
  :config (setq dumb-jump-selector 'ivy) ;; (setq dumb-jump-selector 'helm)
  :ensure)

(use-package string-inflection
  :ensure t)

(use-package expand-region
  :bind ("C-=" . er/expand-region)
  :ensure t)

(use-package ace-jump-mode
  :bind ("C-." . ace-jump-mode)
  :ensure t)

(use-package jump-char
  :bind (("M-m" . jump-char-forward)
	 ("M-M" . jump-char-backward))
  :ensure t)

(use-package which-key
  :delight
  :config
  (which-key-mode)
  :ensure t)

(use-package ace-window
  :bind ("M-o" . ace-window)
  :init
  (setq aw-ignore-on t)
  :ensure t)

(winner-mode)
(require 'windmove)

(setq my-tabs-map (make-sparse-keymap))
(general-define-key
 :keymaps 'my-tabs-map
  "c" 'spacebar-open
  "q" 'spacebar-close
  "a" 'spacebar-switch-last
  "0" 'spacebar-switch-0
  "1" 'spacebar-switch-1
  "2" 'spacebar-switch-2
  "3" 'spacebar-switch-3
  "4" 'spacebar-switch-4
  "5" 'spacebar-switch-5
  "6" 'spacebar-switch-6
  "7" 'spacebar-switch-7
  "8" 'spacebar-switch-8
  "9" 'spacebar-switch-9
  "p" 'spacebar-switch-prev
  "n" 'spacebar-switch-next
  "r" 'spacebar-rename)

(setq my-files-map (make-sparse-keymap))
(general-define-key
 :keymaps 'my-files-map
  "f" 'counsel-find-file
  "r" 'counsel-recentf
  "o" 'counsel-projectile-find-file
  "s" 'deadgrep)

(setq my-buffers-map (make-sparse-keymap))
(general-define-key
 :keymaps 'my-buffers-map
  "d" 'kill-this-buffer
  "n" 'next-buffer
  "p" 'previous-buffer
  "b" 'ivy-switch-buffer
  "c" 'clean-buffer-list
  "S" 'swiper
  "s" 'swiper-thing-at-point)

(setq my-strings-map (make-sparse-keymap))
(general-define-key
 :keymaps 'my-strings-map
  "u" 'string-inflection-underscore
  "c" 'string-inflection-lower-camelcase
  "C" 'string-inflection-camelcase)

(setq my-windows-map (make-sparse-keymap))
(general-define-key
 :keymaps 'my-windows-map
  "w" 'ace-window
  "c" 'delete-window
  "s" 'split-window-below
  "v" 'split-window-right
  "k" 'windmove-up
  "j" 'windmove-down
  "h" 'windmove-left
  "l" 'windmove-right
  "u" 'winner-undo
  "r" 'winner-redo)

(setq my-org-clock-map (make-sparse-keymap))
(general-define-key
 :keymaps 'my-org-clock-map
 "i" 'org-mru-clock-in
 "o" 'org-clock-out)

(setq my-global-org-map (make-sparse-keymap))
(general-define-key
 :keymaps 'my-global-org-map
 "c" '(:keymap my-org-clock-map :wk "Clock")
 "o" 'org-capture)

(setq my-leader-map (make-sparse-keymap))
(general-define-key
 :keymaps 'my-leader-map
  "a" '(:keymap my-tabs-map :wk "Tabs")
  "f" '(:keymap my-files-map :wk "Files")
  "b" '(:keymap my-buffers-map :wk "Buffers")
  "o" '(:keymap my-global-org-map :wk "Org")
  "s" '(:keymap my-strings-map :wk "String Manipulation")
  "w" '(:keymap my-windows-map :wk "Windows")
  "x"  'counsel-M-x)

(general-define-key
 :states '(normal visual motion) :keymaps 'override
 "SPC" '(:keymap my-leader-map :wk "Leader"))

(general-define-key "M-SPC" '(:keymap my-leader-map :wk "Leader"))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

(use-package w3m :ensure t)

(use-package projectile
  :ensure t
  :delight
  :config
  (projectile-mode +1))

(use-package company
  :hook python
  :ensure t)

(use-package flycheck
  :ensure t)

(use-package lsp-mode
  :commands lsp
  :hook (python-mode . lsp)
  :config
  (setq lsp-prefer-flymake nil)

  (defun lsp-set-cfg ()
    (let ((lsp-cfg `(:pyls (:configurationSources ("flake8")))))
      ;; TODO: check lsp--cur-workspace here to decide per server / project
      (lsp--set-configuration lsp-cfg)))

  (add-hook 'lsp-after-initialize-hook 'lsp-set-cfg)

  :ensure t)

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-sideline-ignore-duplicate t)
  (setq lsp-ui-doc-position 'top)
  (setq lsp-ui-doc-alignment 'window)
  :ensure t)

(use-package company-lsp
  :after company lsp-mode
  :config (push 'company-lsp company-backends)
  :ensure t)

(use-package pipenv
  :hook (python-mode . pipenv-mode)
  :init
  (setq
   pipenv-projectile-after-switch-function
   #'pipenv-projectile-after-switch-extended))

(use-package toml-mode
  :ensure t)

(use-package rust-mode
  :hook (rust-mode . lsp)
  :ensure t)

(use-package cargo
  :hook (rust-mode . cargo-minor-mode)
  :delight cargo-minor-mode
  :ensure t)

(use-package flycheck-rust
  :hook (rust-mode . flycheck-rust-setup)
  :ensure t)

(use-package go-mode
  :init
  (setenv "GO111MODULE" "on")
  :config
  (add-hook 'go-mode-hook #'flycheck-mode)
  (add-hook 'go-mode-hook #'lsp)
  :mode "\\.go$"
  :ensure t)

(use-package add-node-modules-path
  :ensure t)

(use-package prettier-js
  :ensure t)

(use-package web-mode
  :after (flycheck)
  :mode "\\.tsx?$"
  :config
  (setq web-mode-enable-auto-quoting nil)
  (flycheck-add-mode 'typescript-tslint 'web-mode)
  :ensure t)

(use-package js2-mode
  :mode "\\.jsx?$"
  :ensure t)

(defun setup-tide-mode ()
  "Set up Tide mode."
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (when (and (projectile-project-p) (file-exists-p (concat ( projectile-project-root ) "tsconfig.json")))
    (setq flycheck-typescript-tsconfig . ( (concat projectile-project-root "tsconfig.json" ))))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1)
  (display-line-numbers-mode)
  (add-node-modules-path)
  (prettier-js-mode))

(use-package tide
  :ensure t
  :after (js2-mode web-mode company flycheck add-node-modules-path prettier-js)
  :commands tide-setup
  :init
  (add-hook 'web-mode-hook #'setup-tide-mode)
  (add-hook 'js2-mode-hook #'setup-tide-mode))

(use-package groovy-mode
  :mode "\\.groovy$"
  :ensure t)

(use-package yaml-mode
  :mode "\\.ya?ml$"
  :ensure t)

(use-package jinja2-mode
  :mode "\\.j2$"
  :ensure t)

(use-package poly-ansible
  :ensure t)

(use-package json-mode
  :ensure t)

(use-package nix-mode
  :after json-mode
  :mode "\\.nix\\'"
  :ensure t)

(use-package magit
  :config
  (add-hook 'after-save-hook 'magit-after-save-refresh-status)
  :ensure t)

(use-package evil-magit
  :after magit
  :ensure t)

(let ((default-directory "/usr/local/share/emacs/site-lisp"))
  (normal-top-level-add-subdirs-to-load-path))

(use-package mu4e
  :config
  (setq
   mu4e-view-show-images t
   mu4e-maildir "~/Maildir"
   mu4e-drafts-folder "/gmail[Gmail].Drafts"
   mu4e-trash-folder "/gmail[Gmail].Trash"
   mu4e-sent-folder "/gmail[Gmail].Sent Mail"))

(use-package graphviz-dot-mode
  :mode "\\.dot$"
  :ensure t)

;; Auto toggle embedded latex
;(require 'org-latex-cursor-toggle)
; this is buggy as hell, might be interactions with evil?


;; Auto refresh buffers
(global-auto-revert-mode 1)

;; Also auto refresh dired, but be quiet about it
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

;; Answering just 'y' or 'n' will do
(defalias 'yes-or-no-p 'y-or-n-p)

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; UTF-8 please
(setq locale-coding-system 'utf-8) ; pretty
(set-terminal-coding-system 'utf-8) ; pretty
(set-keyboard-coding-system 'utf-8) ; pretty
(set-selection-coding-system 'utf-8) ; please
(prefer-coding-system 'utf-8) ; with sugar on top

;; Show active region
(transient-mark-mode 1)
(make-variable-buffer-local 'transient-mark-mode)
(put 'transient-mark-mode 'permanent-local t)
(setq-default transient-mark-mode t)

;; Remove text in active region if inserting text
(delete-selection-mode 1)

;; Don't highlight matches with jump-char - it's distracting
(setq jump-char-lazy-highlight-face nil)

;; Always display line and column numbers
(setq line-number-mode t)
(setq column-number-mode t)

;; Save a list of recent files visited. (open recent file with C-x f)
(recentf-mode 1)
(setq recentf-max-saved-items 100) ;; just 20 is too recent

;; Save minibuffer history
(savehist-mode 1)
(setq history-length 1000)

;; Sentences do not need double spaces to end. Period.
(set-default 'sentence-end-double-space nil)

(set-default 'fill-column 120)

;; Add parts of each file's directory to the buffer name if not unique
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; Tidy up backups
(setq
  ; Don't litter the filesystem with backup files
  backup-directory-alist `((".*" . ,temporary-file-directory))
  auto-save-file-name-transforms `((".*" ,temporary-file-directory t))
  ; Use versioned backups
  delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t
  ; get rid of lockfiles too
  create-lockfiles nil)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fixed-pitch ((t (:family "Menlo" :slant normal :weight normal :height 1.0 :width normal))))
 '(lsp-ui-doc-background ((t (:background "#EEEEEE"))))
 '(org-block ((t (:inherit fixed-pitch))))
 '(org-document-info ((t (:foreground "dark orange"))))
 '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
 '(org-document-title ((t (:inherit default :weight bold :foreground "#657b83" :font "ETBembo" :height 2.0 :underline nil))))
 '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
 '(org-level-1 ((t (:inherit default :weight bold :foreground "#657b83" :font "ETBembo" :height 1.9))))
 '(org-level-2 ((t (:inherit default :weight bold :foreground "#657b83" :font "ETBembo" :height 1.75))))
 '(org-level-3 ((t (:inherit default :weight bold :foreground "#657b83" :font "ETBembo" :height 1.5))))
 '(org-level-4 ((t (:inherit default :weight bold :foreground "#657b83" :font "ETBembo" :height 1.25))))
 '(org-level-5 ((t (:inherit default :weight bold :foreground "#657b83" :font "ETBembo" :height 1.1))))
 '(org-level-6 ((t (:inherit default :weight bold :foreground "#657b83" :font "ETBembo"))))
 '(org-level-7 ((t (:inherit default :weight bold :foreground "#657b83" :font "ETBembo"))))
 '(org-level-8 ((t (:inherit default :weight bold :foreground "#657b83" :font "ETBembo"))))
 '(org-link ((t (:foreground "royal blue" :underline t))))
 '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-property-value ((t (:inherit fixed-pitch))) t)
 '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-table ((t (:inherit fixed-pitch))))
 '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
 '(org-verbatim ((t (:inherit (shadow fixed-pitch)))))
 '(variable-pitch ((t (:family "ETBembo" :height 180 :weight light)))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default)))
 '(lsp-ui-doc-include-signature t)
 '(package-selected-packages
   (quote
    (groovy-mode nix-mode json-mode dumb-jump expand-region ace-window jump-char ace-jump-mode paradox flycheck-rust toml-mode counsel-projectile counsel swiper ivy org-mru-clock hercules origami sublimity emacs-w3m helm-dash string-inflection company-lsp company-anaconda anaconda-mode company-go spacebar delight mu4e poly-ansible yaml prettier-js add-node-modules-path js2-mode helm-ag helm-projectile org-bullets spaceline-all-the-icons evil-visual-mark-mode)))
 '(paradox-github-token t))
