(setq org-directory "~/Dropbox/Org")
(setq org-refile-targets '((nil :maxlevel . 9) (org-agenda-files :maxlevel . 9)))
(setq org-capture-templates
	'(("t" "Todo" entry (file "inbox.org")
	   "* TODO %?\n")
	  ("w" "Work")
	  ("wc" "Conversation" entry (file+headline "work.org" "Conversations")
	   "*** Conversation With %^{Whom} At %U\n%?\n\n" :clock-in t :clock-resume t)
	  ("wr" "Review" entry (file+headline "work.org" "Reviews")
	   "*** Review %^{What} At %U\n%?\n\n" :clock-in t :clock-resume t)))

(after! org
  (plist-put org-format-latex-options :scale 2.0)
  (setq org-todo-keywords '((sequence "TODO" "DONE"))))

(add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)

(setq org-refile-allow-creating-parent-nodes 'confirm)

(use-package! org-clock)
(setq org-clock-mode-line-total 'today)
(setq org-clock-report-include-clocking-task t)

(use-package! org-mru-clock)
(setq org-mru-clock-how-many 100)
(setq org-mru-clock-completing-read #'ivy-completing-read)

(use-package! org-duration)
(setq org-duration-format '(("h" . t) (special . 1)))

(let* ((base-font-color     (face-foreground 'default nil 'default))
       (headline           `(:inherit variable-pitch :weight bold :foreground ,base-font-color)))

  (custom-theme-set-faces
   'user
   `(org-level-8 ((t (,@headline))))
   `(org-level-7 ((t (,@headline))))
   `(org-level-6 ((t (,@headline :height 1.05))))
   `(org-level-5 ((t (,@headline :height 1.15))))
   `(org-level-4 ((t (,@headline :height 1.25))))
   `(org-level-3 ((t (,@headline :height 1.3))))
   `(org-level-2 ((t (,@headline :height 1.4))))
   `(org-level-1 ((t (,@headline :height 1.5))))
   `(org-document-title ((t (,@headline :height 2.0 :underline nil))))
   '(org-block                 ((t (:inherit fixed-pitch))))
   '(org-table                 ((t (:inherit fixed-pitch))))
   '(org-headline-done         ((t (:foreground "#A6A6A6"))))
   '(org-agenda-done           ((t (:foreground "black"))))
   '(org-document-info         ((t (:foreground "dark orange"))))
   '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
   '(org-link                  ((t (:foreground "royal blue" :underline t))))
   '(org-meta-line             ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-property-value        ((t (:inherit fixed-pitch))) t)
   '(org-special-keyword       ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-tag                   ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
   '(org-verbatim              ((t (:inherit (shadow fixed-pitch)))))
   '(org-indent                ((t (:inherit (org-hide fixed-pitch)))))))

(add-hook! 'org-mode-hook
           #'variable-pitch-mode
           #'visual-line-mode
           (lambda () (display-line-numbers-mode -1))
           #'org-display-inline-images)

(doom-init-extra-fonts-h)

(defun treed/first-non-empty (list)
  "Get the first non-empty string from LIST."
  (seq-some (lambda (elem) (when (> (length elem) 0) elem)) list))

(ert-deftest treed/first-non-empty ()
  (should (equal (treed/first-non-empty '("" "0.5h")) "0.5h")))

(defconst treed/hours-re
  (rx (submatch (and (one-or-more digit) (zero-or-one (and "." (one-or-more digit))))) "h")
  "A regex to parse 'org-mode' decimal hours.")

(defun treed/hours-to-number (hours-str)
  "Take an 'org-mode' decimal hours string in HOURS-STR and convert it to a number."
  (save-match-data
    (when (string-match treed/hours-re hours-str)
      (string-to-number (match-string 1 hours-str)))))

(ert-deftest treed/hours-to-number ()
  (should (equal (treed/hours-to-number "1.5h") 1.5))
  (should (equal (treed/hours-to-number "*2.5h*") 2.5))
  (should (equal (treed/hours-to-number "aoeu77.8h") 77.8))
  (should (equal (treed/hours-to-number "no-number") nil)))

(defun treed/normalize-hours (hours-in days)
  "Normalize HOURS-IN as hours per day in DAYS."
  (let ((hours (treed/hours-to-number (if (consp hours-in) (treed/first-non-empty hours-in) hours-in))))
    (when hours (format "%.1fh" (/ hours days)))))

(ert-deftest treed/normalize-hours ()
  (should (equal (treed/normalize-hours "10.0h" 10) "1.0h"))
  (should (equal (treed/normalize-hours '("" "5.5h") 5) "1.1h"))
  (should (equal (treed/normalize-hours '("7.0h" "") 2) "3.5h")))

(defun treed/percentage-hours (hours-str total-hours-str)
  "Get the percentage hours that HOURS-STR represents as a part of TOTAL-HOURS-STR."
  (let ((hours (treed/hours-to-number hours-str))
	(total-hours (treed/hours-to-number total-hours-str)))
    (format "%.1f%%" (* (/ hours total-hours) 100))))

(ert-deftest treed/percentage-hours ()
  (should (equal (treed/percentage-hours "1.0h" "8.0h") "12.5%")))
