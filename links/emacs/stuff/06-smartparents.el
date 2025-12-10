;;; package --- Summary
;;; Commentary:

;;; Code:

(use-package smartparens
  :ensure t
  :hook ((clojure-mode . smartparens-mode)
         (emacs-lisp-mode . smartparens-mode))
  :config
  (require 'smartparens-config))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(provide '06-smartparens)
;;; 06-smartparens.el ends here
