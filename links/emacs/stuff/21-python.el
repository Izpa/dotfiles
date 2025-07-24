;;; 21-python.el --- Python config
;;; Code:

(use-package eglot
  :ensure t
  :hook (python-mode . eglot-ensure))

(use-package reformatter
  :ensure t)

(reformatter-define black-format
  :program "black"
  :args '("-"))

(add-hook 'python-mode-hook 'black-format-on-save-mode)

(use-package pyvenv
  :ensure t
  :config
  (pyvenv-mode 1))

(use-package direnv
  :ensure t
  :config
  (direnv-mode))

;;; 21-python.el ends here
