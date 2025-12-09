;;; package --- Summary
;;; Commentary:

;;; Code:

(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns x))
  :config
  (exec-path-from-shell-initialize))

(add-hook 'window-setup-hook
          (lambda (&optional frame)
            "Re-enable menu-bar-lines in GUI frames."
            (when-let (frame (or frame (selected-frame)))
              (when (display-graphic-p frame)
                (set-frame-parameter frame 'menu-bar-lines 1)))))

(provide '04-macos)
;;; 04-macos.el ends here
