;;; 21-python.el --- Python config -*- lexical-binding: t; -*-
;;; Commentary:
;; Python support: eglot (12-lsp.el) for LSP, apheleia (29-apheleia.el) for
;; format-on-save, pyvenv for virtualenvs.

;;; Code:

(use-package pyvenv
  :ensure t
  :hook ((python-mode . pyvenv-mode)
         (python-ts-mode . pyvenv-mode)))

(provide '21-python)
;;; 21-python.el ends here
