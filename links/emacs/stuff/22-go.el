;;; package --- Summary
;;; Commentary:

;;; Code:

(use-package go-mode
  :ensure t
  :config
  (add-hook 'go-mode-hook 'subword-mode)
  (add-hook 'before-save-hook 'gofmt-before-save))

(use-package go-eldoc
  :ensure t
  :hook (go-mode . go-eldoc-setup))

(setq-default tab-width 4)

;;; 22-go.el ends here
