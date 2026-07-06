;;; 33-dape.el --- Debug Adapter Protocol client -*- lexical-binding: t; -*-
;;; Commentary:
;; dape is a modern DAP client (successor to dap-mode).  Needs adapters on
;; PATH: delve (dlv) for Go and debugpy for Python -- both provided via nix.

;;; Code:

(use-package dape
  :ensure t
  :commands dape
  :custom
  (dape-buffer-window-arrangement 'right))

(provide '33-dape)
;;; 33-dape.el ends here
