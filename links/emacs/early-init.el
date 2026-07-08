;;; early-init.el --- Loaded before init.el and GUI creation -*- lexical-binding: t; -*-
;;; Commentary:
;; Runs before the package system and the first frame.  Suppressing UI chrome
;; here avoids a momentary flash of the toolbar/menubar; raising the GC
;; threshold speeds up startup (restored in init.el via emacs-startup-hook).

;;; Code:

;; Raise GC threshold for the duration of startup; restored after init.
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Suppress UI chrome before the first frame is drawn (avoids flash + reflow).
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq tool-bar-mode nil
      scroll-bar-mode nil)
;; menu-bar is re-enabled per-frame for GUI in 04-macos.el.

;; init.el calls (package-initialize) explicitly; don't double-initialise.
(setq package-enable-at-startup nil)

;; Quieter native compilation.
(setq native-comp-async-report-warnings-errors 'silent)

(provide 'early-init)
;;; early-init.el ends here
