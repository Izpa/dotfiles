;;; package --- Summary
;;; Commentary:

;;; Code:

(use-package flycheck
  :ensure t
  :hook ((emacs-lisp-mode clojure-mode) . flycheck-mode))
;;; 10-flycheck.el ends here
