;;; 14-treemacs --- File tree sidebar
;;; Commentary:
;; Simplified treemacs config

;;; Code:

(use-package treemacs
  :ensure t
  :defer t
  :config
  (setq treemacs-collapse-dirs 0
        treemacs-deferred-git-apply-delay 0.5
        treemacs-display-in-side-window t
        treemacs-follow-after-init t
        treemacs-expand-after-init t
        treemacs-hide-dot-git-directory t
        treemacs-indentation 2
        treemacs-litter-directories '("/node_modules" "/.venv")
        treemacs-position 'left
        treemacs-width 35
        treemacs-no-delete-other-windows t)

  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode 'always)
  (treemacs-hide-gitignored-files-mode t)

  (when (executable-find "git")
    (treemacs-git-mode 'deferred)))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package treemacs-perspective
  :after (treemacs perspective)
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

(provide '14-treemacs)
;;; 14-treemacs.el ends here
