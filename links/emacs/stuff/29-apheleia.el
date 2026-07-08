;;; 29-apheleia.el --- Async format-on-save -*- lexical-binding: t; -*-
;;; Commentary:
;; Unified asynchronous formatter, replacing the per-mode format-on-save hooks
;; (black for python, gofmt for go).  Runs off the main thread and preserves
;; point, so it doesn't block or jump the cursor on save.  Defaults: python ->
;; black, go -> gofmt (both provided via nix).

;;; Code:

(use-package apheleia
  :ensure t
  :config
  (apheleia-global-mode +1))

(provide '29-apheleia)
;;; 29-apheleia.el ends here
