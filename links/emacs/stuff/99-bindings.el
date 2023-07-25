;;; package --- Summary
;;; Commentary:

;;; Code:

(general-create-definer leader-def
  :states '(normal visual emacs motion)
  :keymaps 'override
  :prefix "SPC"
  :non-normal-prefix "M-SPC")

(leader-def
  "f" '(:ignore t :which-key "file")
  "f f" '(counsel-find-file :which-key "find file")
  "f s" '(save-buffer :which-key "save file"))

(leader-def
  "/" 'counsel-rg)

(leader-def
  "k" '(:ignore t :which-key "sexp")
  "k w" '(sp-wrap-round :which-key "wrap ()")
  "k [" '(sp-wrap-square :which-key "wrap []")
  "k {" '(sp-wrap-square :which-key "wrap {}")
  "k ," '(sp-forward-barf-sexp :which-key "<-)")
  "k ." '(sp-forward-slurp-sexp :which-key ")->")
  "k <" '(sp-backward-barf-sexp :which-key "<-(")
  "k >" '(sp-forward-barf-sexp :which-key "(->")
  "k d" '(sp-kill-sexp :which-key "delete sexp")
  "k r" '(sp-raise-sexp :which-key "raise sexp")
  "k y" '(sp-copy-sexp :which-key "copy sexp"))

(leader-def
  "w" '(:ignore t :which-key "window")
  "w v" '(evil-window-vsplit :which-key "split vertically")
  "w s" '(evil-window-split :which-key "split horizontally")
  "w k" '(evil-window-up :which-key "focus ↑")
  "w h" '(evil-window-left :which-key "focus ←")
  "w j" '(evil-window-down :which-key "focus ↓")
  "w l" '(evil-window-right :which-key "focus →")
  "w d" '(delete-window :which-key "delete window")
  "w g" '(winum-select-window-by-number :which-key "focus by number"))

(general-define-key
 :keymaps 'ivy-mode-map
 "C-j" 'ivy-next-line
 "C-k" 'ivy-previous-line)

(leader-def
  :keymaps 'emacs-lisp-mode-map
  "m" '(:ignore t :which-key "emacs lisp")
  "m e" '(:ignore t :which-key "eval")
  "m e e" 'eval-last-sexp
  "m e b" 'eval-buffer)

(leader-def
  :keymaps 'clojure-mode-map
  "m" '(:ignore t :which-key "clojure")
  "m c" 'cider-connect-clj
  "m e" '(:ignore t :which-key "eval")
  "m e e" 'cider-eval-last-sexp
  "m e b" 'cider-eval-buffer
  "m e d" '(cider-eval-defun-at-point :which-key "deinstrument")
  "m e i" '(cider-debug-defun-at-point :which-key "instrument")
  "m e l" '(cider-browse-instrumented-defs :which-key "instrument-list")
  "m g" '(:ignore t :which-key "goto")
  "m g d" '(lsp-find-definition :which-key "defn")
  "m g r" '(lsp-find-references :which-key "ref")
  "m t" '(:ignore t :which-key "try")
  "m t c" 'lsp-clojure-clean-ns
  "m t d" 'lsp-clojure-move-coll-entry-down
  "m t e" 'lsp-clojure-expand-let
  "m t t" 'lsp-clojure-create-test
  "m t f" 'lsp-clojure-create-function
  "m t m" 'lsp-clojure-move-form
  "m t l" 'lsp-clojure-move-to-let
  "m t u" 'lsp-clojure-move-coll-entry-up
  "m t p" 'lsp-clojure-cycle-privacy
  "m t r" 'lsp-clojure-add-import-to-namespace
  "m t s" 'lsp-clojure-sort-map
  "m t x" 'lsp-clojure-extract-function)

(leader-def
  "b" '(:ignore t :which-key "buffer")
  "b b" '(persp-ivy-switch-buffer :which-key "switch buffer")
  "b a" '(ivy-switch-buffer :which-key "all buffers")
  "b l" '(evil-switch-to-windows-last-buffer :which-key "last buffer")
  "b p" '(previous-buffer :wich-key "previous buffer")
  "b n" '(next-buffer :which-key "next buffer")
  "b d" '(kill-buffer :which-key "kill buffer")
  "b c" '(evil-buffer-new :which-key "create buffer")
  "b s" '(save-buffer :which-key "save buffer"))

(leader-def
  "g" '(:ignore t :which-key "magit")
  "g s" '(magit-status :which-key "magit-status"))

(leader-def
  "t" '(:ignore t :which-key "themes")
  "t d" '((lambda () (interactive) (load-theme 'solarized-dark t)) :which-key "dark theme")
  "t l" '((lambda () (interactive) (load-theme 'solarized-light t)) :which-key "light theme")
  "t n" '(global-display-line-numbers-mode :which-key "line numbers")
  "t f" '(text-scale-adjust :which-key "font size"))

(general-define-key
 "<escape>" 'keyboard-escape-quit)

(leader-def
  ;;"p" 'projectile-command-map
  "p" '(:ignore t :which-key "project")
  "p f" '(projectile-find-file :which-key "find file in project")
  "p a" '(projectile-toggle-between-implementation-and-test :which-key "impl <-> test")
  "p p" '(projectile-switch-project :which-key "switch project")
  "p s" '(persp-switch :which-key "switch persp")
  "p t" '(treemacs :which-key "treemacs")
  "p c" '(persp-state-save :which-key "persp save")
  "p l" '(persp-state-load :which-key "persp load")
  "p k" '(persp-kill :which-key "persp kill"))

(leader-def
  "e" '(:ignore t :which-key "emacs")
  "e l" '(view-lossage :which-key "commands log")
  "e k" '(:ignore t :which-key "kill")
  "e k k" '(save-buffers-kill-emacs :which-key "save buffers")
  "e k b" '(kill-emacs :which-key "kill with buffers"))

(leader-def
  "d" '(:ignore t :which-key "db")
  "d c" '(sql-connect :which-key "connect")
  "d l" '(sql-list-all :which-key "list tables")
  "d t" '(sql-list-table :which-key "table")
  "d b" '(sql-show-sqli-buffer :which-key "buffer"))

(leader-def
  "r" '(:ignore t :which-key "rest client")
  "r r" '(restclient-http-send-current :which-key "send")
  "r n" '(restclient-jump-next :which-key "next query")
  "r p" '(restclient-jump-prev :which-key "previous query")
  "r c" '(restclient-copy-curl-command :which-key "copy as curl"))

(leader-def
  "h" '(:ignore t :which-key "hideshow")
  "h h" '(hs-hide-block :which-key "hide block")
  "h s" '(hs-show-block :which-key "show block")
  "h c" '(hs-hide-all :which-key "hide all")
  "h a" '(hs-show-all :which-key "show all"))

(leader-def
  "s" '(projectile-run-vterm :which-key "terminal"))

(leader-def
  "SPC" '(execute-extended-command :which-key "M-x"))

(setq which-key-idle-delay 0.5)
(setq which-key-idle-secondary-delay 0)

(provide '99-bindings)
;;; 99-bindings.el ends here
