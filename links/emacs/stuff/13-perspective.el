;;; package --- Summary
;;; Commentary:

;;; Code:

(use-package perspective
  :ensure t
  :init
  (setq persp-suppress-no-prefix-key-warning t)
  (setq persp-state-default-file "~/.emacs-perspective-state-autosaved")
  (persp-mode)
  (add-hook 'kill-emacs-hook #'persp-state-save)
  ;;(add-hook 'emacs-startup-hook #'persp-state-restore)
  :hook
  ;;(kill-emacs-hook . persp-state-save)
  (emacs-startup-hook . persp-state-load)
  )
;;; 13-perspective.el ends here
