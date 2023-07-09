;;; package --- Summary
;;; Commentary:

;;; Code:

(use-package which-key
  :ensure t
  :init
  (setq which-key-add-column-padding 2)
  (setq which-key-separator " : " )
  (setq which-key-allow-evil-operators t)
  (setq which-key-show-operator-state-maps t)
  :config
  (which-key-mode))

(provide '05-which-key)
;;; 05-which-key.el ends here
