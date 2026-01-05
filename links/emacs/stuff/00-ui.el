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

;; Terminal/SSH optimizations
(unless (display-graphic-p)
  ;; Reduce font-lock decoration for better performance over slow connections
  (setq font-lock-maximum-decoration 2)
  ;; Reduce GC pressure
  (setq gc-cons-threshold (* 50 1024 1024))
  ;; Faster cursor blinking
  (setq blink-cursor-interval 0.4)
  ;; Disable expensive UI elements
  (setq-default cursor-in-non-selected-windows nil)
  (setq highlight-nonselected-windows nil)
  ;; Faster scrolling
  (setq fast-but-imprecise-scrolling t)
  (setq redisplay-skip-fontification-on-input t))

(provide '00-ui)
;;; 00-ui.el ends here
