;;; 12-lsp --- Unified LSP with eglot
;;; Commentary:
;; Using eglot (built-in in Emacs 29+) for all languages

;;; Code:

(use-package eglot
  :ensure t
  :hook ((clojure-mode . eglot-ensure)
         (go-mode . eglot-ensure)
         (python-mode . eglot-ensure))
  :custom
  (eglot-autoshutdown t)
  (eglot-events-buffer-size 0)
  :config
  (add-to-list 'eglot-server-programs
               '(clojure-mode . ("clojure-lsp")))
  (add-to-list 'eglot-server-programs
               '(go-mode . ("gopls"))))

(provide '12-lsp)
;;; 12-lsp.el ends here
