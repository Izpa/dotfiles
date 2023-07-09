;;; package --- Summary
;;; Commentary:

;;; Code:

;;; Invaluable UI stuff
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(setq inhibit-startup-screen t)
(setq scroll-step 1)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)

;;; Setup

(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package solarized-theme
  :ensure t
  :config
  (load-theme 'solarized-dark t)
  (set-face-attribute 'default nil :family "Source Code Pro" :height 120)
  (toggle-frame-fullscreen))

(provide '00-ui)
;;; 00-ui.el ends here
