;;; 12-lsp --- lsp mode for emacs
;;; Commentary:
;; Set up lsp for Emacs
;;; Code:

(use-package lsp-mode
  :ensure t
  :hook ((clojure-mode . lsp)
         (go-mode . lsp-deferred))
  :commands (lsp lsp-deferred))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode))

(use-package lsp-treemacs
  :ensure t
  :after lsp-mode)

(provide '12-lsp)
;;; 12-lsp.el ends here
