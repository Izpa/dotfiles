;;; package --- Summary
;;; Commentary:

;;; Code:

(use-package go-mode
  :ensure t)

(use-package lsp-mode
  :ensure t
  :hook ((go-mode . lsp-deferred))
  :commands lsp)

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package go-eldoc
  :ensure t
  :hook (go-mode . go-eldoc-setup))

(use-package lsp-treemacs
  :ensure t
  :after lsp)

(add-hook 'go-mode-hook 'subword-mode)
(add-hook 'go-mode-hook 'lsp-ui-mode)
(add-hook 'before-save-hook 'gofmt-before-save)

(setq tab-width 4)

;;; 22-go.el ends here
