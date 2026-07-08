;;; package --- Summary
;;; Commentary:

;;; Code:

;;; Invaluable UI stuff
;; Toolbar/menubar/scrollbar are suppressed in early-init.el (before the first
;; frame) to avoid a flash on startup.
(setq inhibit-startup-screen t)
(setq scroll-step 1)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)
(global-display-line-numbers-mode t)

;;; Setup

;; nerd-icons works in the terminal (needs a Nerd Font in your terminal
;; emulator), unlike all-the-icons which is GUI-only.
(use-package nerd-icons
  :ensure t)

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
  ;; GC threshold is managed centrally (early-init.el + init.el startup hook)
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
