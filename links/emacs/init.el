;;; package --- Summary
;;; Commentary:

;;; Code:

;; Import Emacs package manager
(require 'package)
;; Add largest package repository (Melpa)
(setq package-archives '(("melpa-stable" . "https://stable.melpa.org/packages")
                         ("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
;; Initialize Emacs package manager
(package-initialize)

(setq byte-compile-warnings '(not docstrings))

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
   '(vterm go-mode treemacs-magit treemacs-projectile projectile cider magit with-editor winum which-key treemacs-perspective treemacs-icons-dired treemacs-evil solarized-theme smartparens restclient realgud lsp-mode golden-ratio general flycheck evil-escape evil-collection elpy counsel all-the-icons)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;;; init.el ends here
