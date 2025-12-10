;;; package --- Summary
;;; Commentary:

;;; Code:

(use-package magit
  :ensure t
  :bind
  (("C-c g" . magit-status)))

(use-package forge
  :ensure t
  :after magit)

(provide '02-magit)
;;; 02-magit.el ends here
