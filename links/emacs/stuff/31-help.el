;;; 31-help.el --- Better help buffers -*- lexical-binding: t; -*-
;;; Commentary:
;; helpful replaces the built-in describe-* commands with richer buffers
;; (source, references, edebug/trace state, key bindings).

;;; Code:

(use-package helpful
  :ensure t
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h x" . helpful-command)))

(provide '31-help)
;;; 31-help.el ends here
