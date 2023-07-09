;;; package --- Summary
;;; Commentary:

;;; Code:

(use-package smartparens
  :ensure t
  :config
  (require 'smartparens-config)
  :hook ((clojure-mode emacs-lisp-mode) . smartparens-mode))
;;; 06-smartparens.el ends here
