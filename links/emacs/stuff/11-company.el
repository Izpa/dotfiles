;;; 11-company --- Unified completion
;;; Commentary:
;; Company-mode for all programming modes

;;; Code:

(use-package company
  :ensure t
  :hook (prog-mode . company-mode)
  :custom
  (company-minimum-prefix-length 2)
  (company-idle-delay 0.2)
  (company-tooltip-align-annotations t))

(provide '11-company)
;;; 11-company.el ends here
