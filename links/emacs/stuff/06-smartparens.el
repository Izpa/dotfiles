;;; package --- Summary
;;; Commentary:

;;; Code:

(use-package smartparens-mode
  :ensure smartparens
  :config
  (require 'smartparens-config)
  :hook ((clojure-mode emacs-lisp-mode) . smartparens-mode))
;;; 06-smartparens.el ends here
