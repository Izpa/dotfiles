;;; package --- Summary
;;; Commentary:

;;; Code:

;;; Invaluable UI stuff
(when (and (display-graphic-p) (fboundp 'scroll-bar-mode))
  (scroll-bar-mode -1))
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))
(setq inhibit-startup-screen t)
(setq scroll-step 1)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)
(global-display-line-numbers-mode t)

;;; Setup

(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package solarized-theme
  :ensure t
  :config
  (load-theme 'solarized-dark t)
  (when (display-graphic-p)
    (set-face-attribute 'default nil :family "Source Code Pro" :height 120)
    (toggle-frame-fullscreen)))

(provide '00-ui)
;;; 00-ui.el ends here
