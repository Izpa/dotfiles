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
  :config
  (add-hook 'emacs-startup-hook
            (lambda ()
              (when (file-exists-p persp-state-default-file)
                (persp-state-load persp-state-default-file))
              (switch-to-buffer "*scratch*")
              (evil-normal-state))))

(provide '13-perspective)
;;; 13-perspective.el ends here
