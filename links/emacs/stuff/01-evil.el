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

(use-package avy
  :ensure t
  :commands (avy-goto-char avy-goto-char-2 avy-goto-line avy-goto-word-1))

(use-package evil-mc
  :ensure t
  :after evil
  :config
  (global-evil-mc-mode 1))

(provide '01-evil)
;;; 01-evil.el ends here
