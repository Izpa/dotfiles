;;; package --- Summary
;;; Commentary:

;;; Code:

(use-package go-mode
  :ensure t
  :config
  (add-hook 'go-mode-hook 'subword-mode)
  (add-hook 'go-mode-hook (lambda () (setq-local tab-width 4)))
  (add-hook 'before-save-hook 'gofmt-before-save))

(use-package go-eldoc
  :ensure t
  :hook (go-mode . go-eldoc-setup))

(provide '22-go)
;;; 22-go.el ends here
