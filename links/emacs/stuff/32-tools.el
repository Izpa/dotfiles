;;; 32-tools.el --- Small editing helpers -*- lexical-binding: t; -*-
;;; Commentary:
;; rainbow-mode: colorize CSS/hex color codes in place.
;; vundo: visualize the undo tree (terminal-friendly).
;; combobulate: structural editing on top of tree-sitter modes.

;;; Code:

(use-package rainbow-mode
  :ensure t
  :hook ((web-mode . rainbow-mode)
         (css-mode . rainbow-mode)))

(use-package vundo
  :ensure t
  :commands vundo)

(use-package combobulate
  :vc (:url "https://github.com/mickeynp/combobulate" :rev :newest)
  :hook ((python-ts-mode . combobulate-mode)
         (go-ts-mode . combobulate-mode)
         (js-ts-mode . combobulate-mode)
         (typescript-ts-mode . combobulate-mode)
         (json-ts-mode . combobulate-mode)))

(provide '32-tools)
;;; 32-tools.el ends here
