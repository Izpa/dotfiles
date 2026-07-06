;;; 22-go.el --- Go config -*- lexical-binding: t; -*-
;;; Commentary:
;; Go support: eglot (12-lsp.el) for LSP, apheleia (29-apheleia.el) for
;; format-on-save (gofmt).  go-mode/go-ts-mode hooks set subword + tab-width.

;;; Code:

(defun my/go-setup ()
  "Buffer-local settings shared by go-mode and go-ts-mode."
  (subword-mode 1)
  (setq-local tab-width 4))

(use-package go-mode
  :ensure t
  :hook ((go-mode . my/go-setup)
         (go-ts-mode . my/go-setup)))

(use-package go-eldoc
  :ensure t
  :hook (go-mode . go-eldoc-setup))

(provide '22-go)
;;; 22-go.el ends here
