;;; 21-python.el --- Python config
;;; Commentary:
;; Python support with eglot (configured in 12-lsp.el)

;;; Code:

(use-package reformatter
  :ensure t)

(reformatter-define black-format
  :program "black"
  :args '("-"))

(add-hook 'python-mode-hook 'black-format-on-save-mode)

(use-package pyvenv
  :ensure t
  :hook (python-mode . pyvenv-mode))

(provide '21-python)
;;; 21-python.el ends here
