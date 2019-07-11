(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default)))
 '(package-selected-packages
   (quote
    (evil-collection mu4e poly-ansible yaml-mode yaml prettier-js add-node-modules-path solarized-theme spacemacs-theme evil-magit magit exec-path-from-shell tide flycheck company web-mode js2-mode typescript-mode helm-rg helm-ag helm-projectile dashboard general spaceline evil gnuplot evil-org org-bullets helm spaceline-all-the-icons use-package evil-visual-mark-mode))))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp/"))

(custom-theme-set-faces
 'user
 '(variable-pitch ((t (:family "ETBembo" :height 180 :weight light))))
 '(fixed-pitch ((t (:family "Menlo" :slant normal :weight normal :height 1.0 :width normal)))))

(add-hook 'org-mode-hook 'variable-pitch-mode)
(add-hook 'org-mode-hook 'visual-line-mode)
(custom-theme-set-faces
 'user
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

(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

(package-refresh-contents)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

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

(use-package helm
  :config
  (setq helm-mode-fuzzy-match t
	helm-completion-in-region-fuzzy-match t)
  (helm-mode 1)
  :ensure t)

(setq org-hide-emphasis-markers t
      org-startup-indented t
      org-bullets-bullet-list '(" ")
      org-pretty-entities t)

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
   `(org-document-title ((t (,@headline ,@variable-tuple :height 2.0 :underline nil))))))

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
     )))

(use-package org-bullets
  :after org
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  :ensure t)

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
(general-create-definer space-def :prefix "SPC" :states '(normal visual motion) :keymaps 'override)

(require 'windmove)
(space-def
  "ff" 'helm-find-files
  "fr" 'helm-mini
  "fs" 'save-buffer
  "bd" 'kill-this-buffer
  "bn" 'next-buffer
  "bp" 'previous-buffer
  "bb" 'helm-buffers-list
  "bc" 'clean-buffer-list
  "wc" 'delete-window
  "ws" 'split-window-below
  "wv" 'split-window-right
  "wk" 'windmove-up
  "wj" 'windmove-down
  "wh" 'windmove-left
  "wl" 'windmove-right
  "x"  'helm-M-x)

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

(use-package projectile
  :ensure t
  :config
  (projectile-mode +1))

(use-package helm-projectile
  :after helm projectile
  :config (space-def "fo" 'helm-projectile-find-file)
  :config (space-def "fs" 'helm-projectile-rg)
  :ensure t)

(use-package company
  :ensure t)

(use-package flycheck
  :ensure t)

(use-package add-node-modules-path
  :ensure t)

(use-package prettier-js
  :ensure t)

(use-package web-mode
  :after (flycheck)
  :mode "\\.tsx?$"
  :config
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
  :hook ((js2-mode . setup-tide-mode)
	 (web-mode . setup-tide-mode)))

(use-package yaml-mode
  :mode "\\.ya?ml$"
  :ensure t)

(use-package jinja2-mode
  :mode "\\.j2$"
  :ensure t)

(use-package poly-ansible
  :ensure t)

(use-package magit
  :ensure t)

(use-package evil-magit
  :after magit
  :ensure t)

(use-package exec-path-from-shell

  :config
  (exec-path-from-shell-initialize)
  ;; Necessary for latex in orgmode
  (setenv "PATH" (concat "/usr/local/texlive/2018/bin/x86_64-darwin:" (getenv "PATH")))
  (setq exec-path (append exec-path '("/usr/local/texlive/2018/bin/x86_64-darwin")))

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

;; Get rid of the toolbar
(tool-bar-mode -1)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fixed-pitch ((t (:family "Menlo" :slant normal :weight normal :height 1.0 :width normal))))
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
