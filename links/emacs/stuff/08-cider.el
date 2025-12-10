;;; package --- Summary
;;; Commentary:

;;; Code:

(use-package cider
  :ensure t)

(use-package clojure-mode
  :ensure t)

(use-package clj-refactor
  :ensure t
  :hook (clojure-mode . clj-refactor-mode)
  :config
  (cljr-add-keybindings-with-prefix "C-c C-r"))

(provide '08-cider)
;;; 08-cider.el ends here
