;;; 23-treesit.el --- Tree-sitter major modes (Emacs 30) -*- lexical-binding: t; -*-
;;; Commentary:
;; Auto-install tree-sitter grammars and remap built-in modes to their
;; tree-sitter variants (python-ts-mode, go-ts-mode, ...).  Falls back to the
;; classic mode gracefully when a grammar isn't installed yet.

;;; Code:

(use-package treesit-auto
  :ensure t
  :custom
  ;; Prompt before downloading a missing grammar rather than erroring.
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(provide '23-treesit)
;;; 23-treesit.el ends here
