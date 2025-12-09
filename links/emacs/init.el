;; package --- Summary
;;; Commentary:

;;; Code:

;; Import Emacs package manager
(require 'package)
;; Add largest package repository (Melpa)
(setq package-archives '(("melpa-stable" . "https://stable.melpa.org/packages")
                         ("melpa" . "https://melpa.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
;; Initialize Emacs package manager
(package-initialize)

;; (setq byte-compile-warnings '(not docstrings multiple-docstrings suspicious free-vars unresolved redefine obsolete))
(setq byte-compile-warnings 'nil)
(setq warning-suppress-types '((comp)))

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
 '(package-selected-packages nil)
 '(safe-local-variable-values
   '((sql-connection-alist
	  (dev-db (sql-product 'postgres)
			  (sql-database
			   (concat "postgresql://" "flexiana" ":" "dev"
					   "@localhost" ":5433" "/frankie"))))
	 (sql-postgres-login-params)
	 (eval progn
		   (make-variable-buffer-local
			'cider-jack-in-nrepl-middlewares)
		   (add-to-list 'cider-jack-in-nrepl-middlewares
						"shadow.cljs.devtools.server.nrepl/middleware")))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;;; init.el ends here
