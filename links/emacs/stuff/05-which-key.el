;;; package --- Summary
;;; Commentary:

;;; Code:

(use-package which-key
  :ensure t
  :init
  (setq which-key-add-column-padding 2)
  (setq which-key-separator " : " )
  :config
  (which-key-mode))

(provide '05-which-key)
;;; 05-which-key.el ends here
