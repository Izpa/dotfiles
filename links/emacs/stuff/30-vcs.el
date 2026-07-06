;;; 30-vcs.el --- VCS gutter and TODO highlighting -*- lexical-binding: t; -*-
;;; Commentary:
;; diff-hl shows uncommitted changes in the fringe (GUI) or margin (terminal).
;; hl-todo highlights TODO/FIXME/HACK keywords in comments.

;;; Code:

(use-package diff-hl
  :ensure t
  :hook ((prog-mode . diff-hl-mode)
         (magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  ;; The fringe is GUI-only; use the margin so it also works in emacs -nw.
  (unless (display-graphic-p)
    (diff-hl-margin-mode 1))
  (diff-hl-flydiff-mode 1))

(use-package hl-todo
  :ensure t
  :hook (prog-mode . hl-todo-mode))

(provide '30-vcs)
;;; 30-vcs.el ends here
