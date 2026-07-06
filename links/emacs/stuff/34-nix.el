;;; 34-nix.el --- Nix editing -*- lexical-binding: t; -*-
;;; Commentary:
;; nix-mode for editing home.nix / flakes.  Uses the nixd LSP when it's on
;; PATH (via nix on the Linux boxes); on machines without nixd (e.g. the Mac)
;; you still get syntax highlighting, just no LSP.

;;; Code:

(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'"
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs '(nix-mode . ("nixd")))
    (when (executable-find "nixd")
      (add-hook 'nix-mode-hook #'eglot-ensure))))

(provide '34-nix)
;;; 34-nix.el ends here
