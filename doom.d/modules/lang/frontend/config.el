;;; lang/frontend/config.el -*- lexical-binding: t; -*-

(use-package! prettier-js-mode
  :commands prettier-js-mode)

(use-package! add-node-modules-path
  :commands add-node-modules-path)

(use-package! web-mode
  :mode "\\.tsx\\'"

  :config
  (setq web-mode-enable-auto-quoting nil))

(use-package! typescript-mode
  :mode "\\.ts\\'")

(setq lsp-eslint-server-command `("node" ,(car (doom-glob "~/.vscode/extensions/dbaeumer.vscode-eslint-*/server/out/eslintServer.js")) "--stdio"))

(add-hook! '(web-mode-hook typescript-mode-hook)
  (defun setup-ts ()
    (interactive)
    (add-node-modules-path)
    (lsp)
    (prettier-js-mode)))
