;;; 03-completion.el --- Minibuffer completion: vertico + consult + friends -*- lexical-binding: t; -*-
;;; Commentary:
;; Modern completion stack (replaces ivy/counsel).  Everything here works in
;; emacs -nw: vertico is a minibuffer UI (no child frames), and consult /
;; embark / orderless / marginalia are all terminal-safe.

;;; Code:

(use-package vertico
  :ensure t
  :init
  (vertico-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(use-package consult
  :ensure t
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)))

(use-package embark
  :ensure t
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)))

(use-package embark-consult
  :ensure t
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; Icons in the minibuffer (nerd-icons is installed in 00-ui.el).
(use-package nerd-icons-completion
  :ensure t
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(provide '03-completion)
;;; 03-completion.el ends here
