;;; package --- Summary
;;; Commentary:

;;; Code:

;; Import Emacs package manager
(require 'package)
;; Add largest package repository (Melpa)
(add-to-list 'package-archives
	     ;; '("melpa-stable" . "https://stable.melpa.org/packages")
             '("melpa" . "https://melpa.org/packages/")
	     t)
;; Initialize Emacs package manager
(package-initialize)

(add-to-list 'image-types 'svg)

;; Pull package list on first Emacs start
(unless package-archive-contents
  (package-refresh-contents))

;; Install use-package -- convenient wrapper for managing packages
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; Read and execute all .el files in .emacs.d/stuff
(let* ((stuff-dir (concat (file-name-directory load-file-name) "/stuff"))
       (load-it (lambda (f) (load-file (concat (file-name-as-directory stuff-dir) f)))))
  (mapc load-it (directory-files stuff-dir nil "\\.el$")))

(provide 'init)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(winum golden-ratio vterm lsp-treemacs treemacs-perspective treemacs-magit treemacs-icons-dired treemacs-projectile treemacs-evil treemacs perspective all-the-icons lsp-mode company flycheck counsel cider solarized-theme ivy evil-collection use-package)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;;; init.el ends here
