;;; package --- Summary
;;; Commentary:

;;; Code:

(use-package perspective
  :ensure t
  :init
  (setq persp-suppress-no-prefix-key-warning t)
  (persp-mode)
  ;;:config
  ;;(persp-mode)
  :hook (kill-emacs-hook persp-state-save))
;;; 13-perspective.el ends here
