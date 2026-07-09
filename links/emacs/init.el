;;; package --- Summary
;;; Commentary:

;;; Code:

;; Import Emacs package manager
(require 'package)
;; Add largest package repository (Melpa)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
;; Initialize Emacs package manager
(package-initialize)

;; Enable package quickstart for faster loading
(setq package-quickstart t)

(setq byte-compile-warnings nil)
(setq warning-suppress-types '((comp)))

;; Pull package list on first Emacs start
(defvar my/package-refreshed-p nil
  "Non-nil once `package-refresh-contents' has run in this session.")

(defun my/package-refresh-once ()
  "Refresh the archive contents at most once per session."
  (unless my/package-refreshed-p
    (setq my/package-refreshed-p t)
    (package-refresh-contents)))

(unless package-archive-contents
  (my/package-refresh-once))

;; MELPA rebuilds its tarballs continuously and drops the old ones, so a cached
;; archive index eventually points at files that 404.  When that happens every
;; `:ensure' fails and leaves half-unpacked directories behind.  Refresh the
;; index and retry once instead.
(defun my/package-install-retry-after-refresh (orig-fun &rest args)
  "Call ORIG-FUN with ARGS, retrying once after a fresh archive download."
  (condition-case err
      (apply orig-fun args)
    (error
     (if my/package-refreshed-p
         (signal (car err) (cdr err))
       (my/package-refresh-once)
       (apply orig-fun args)))))

(advice-add 'package-install :around #'my/package-install-retry-after-refresh)

;; Install use-package -- convenient wrapper for managing packages
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; Read and execute all .el files in .emacs.d/stuff
(let* ((stuff-dir (concat (file-name-directory load-file-name) "/stuff"))
       (load-it (lambda (f) (load-file (concat (file-name-as-directory stuff-dir) f)))))
  (mapc load-it (directory-files stuff-dir nil "\\.el$")))

;; Restore a sane GC threshold after startup (early-init.el raised it to
;; most-positive-fixnum to speed up loading).
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 100 1024 1024)
                  gc-cons-percentage 0.1)))

;; Local variable values we trust (cider + shadow-cljs nrepl middleware).
(setq safe-local-variable-values
      '((eval progn
              (make-variable-buffer-local
               'cider-jack-in-nrepl-middlewares)
              (add-to-list 'cider-jack-in-nrepl-middlewares
                           "shadow.cljs.devtools.server.nrepl/middleware"))))

;; Keep Custom's writes out of init.el.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

(provide 'init)
;;; init.el ends here
