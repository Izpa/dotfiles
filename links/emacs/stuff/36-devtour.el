;;; 36-devtour.el --- graphden's developer code-tour -*- lexical-binding: t; -*-
;;; Commentary:
;; The tour ships INSIDE the graphden checkout: `bb devtour' bakes tour.eld next
;; to devtour.el, so there is nothing to install from MELPA — point at the
;; checkout and load the file when it is there (a machine without the checkout
;; just skips this).
;;
;; devtour.el itself claims evil MOTION state for its pane, so hjkl/gg keep
;; working and its own verbs (n/p/b/s/i//) sit on top.  Leader bindings live in
;; 99-bindings.el under SPC T.

;;; Code:

(defvar my/graphden-root (expand-file-name "~/projects/graphden/")
  "Graphden checkout the developer tour reads its anchors from.")

(defvar my/graphden-i18n-root (expand-file-name "~/projects/graphden-internal/i18n/")
  "Checkout holding the translated bakes of the tour.")

(defvar my/devtour-bakes
  (list (cons "en" (expand-file-name "docs/devtour/tour.eld" my/graphden-root))
        (cons "ru" (expand-file-name "ru/devtour/tour.eld" my/graphden-i18n-root)))
  "Language -> baked tour data.  The anchors are the same checkout either way.")

(defvar my/devtour-file (expand-file-name "docs/devtour/devtour.el" my/graphden-root))

(when (file-readable-p my/devtour-file)
  (load my/devtour-file nil t)
  (setq devtour-repo-root my/graphden-root)
  ;; The reverse direction: eldoc names the tour step for the form at point in
  ;; ordinary source buffers.  Costs nothing until you visit a toured file.
  (devtour-annotate-mode 1))

(defun my/devtour-language (lang)
  "Read the tour in LANG (see `my/devtour-bakes') and reload it."
  (interactive (list (completing-read "Tour language: "
                                      (mapcar #'car my/devtour-bakes) nil t)))
  (let ((file (cdr (assoc lang my/devtour-bakes))))
    (unless (and file (file-readable-p file))
      (user-error "No %s bake at %s (run `bb devtour' / `bb bake')" lang file))
    (setq devtour-data-file file)
    (devtour-reload)))

(defun my/devtour-org ()
  "Open the org form of the tour — same steps, read as an outline."
  (interactive)
  (find-file (expand-file-name "docs/devtour/org/index.org" my/graphden-root)))

(defun my/devtour-page ()
  "Open the baked tour page in a browser."
  (interactive)
  (browse-url (concat "file://"
                      (expand-file-name "docs/devtour/index.html" my/graphden-root))))

(provide '36-devtour)
;;; 36-devtour.el ends here
