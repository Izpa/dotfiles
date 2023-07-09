;;;; package --- Summary
;;; Commentary:

;;; Code:

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package evil-escape
  :ensure t
  :config (evil-escape-mode))

(provide '01-evil)
;;; 01-evil.el ends here
