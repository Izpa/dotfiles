;;; package --- Summary
;;; Commentary:

;;; Code:

(use-package vterm
  :ensure t
  :config
  (evil-collection-vterm-setup)
  (setq vterm-shell "zsh")
  :custom
  (vterm-environment '("TYPEWRITTEN_CURSOR=terminal"))
  (vterm-ignore-blink-cursor t))

;;; 15-vterm.el ends here
