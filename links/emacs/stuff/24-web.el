;;; package --- Summary
;;; Commentary:
;;; Web development: HTML, CSS, JS, JSX, Vue, TypeScript

;;; Code:

(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.css\\'" . web-mode)
         ("\\.jsx?\\'" . web-mode)
         ("\\.tsx\\'" . web-mode)
         ("\\.vue\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-css-colorization t))

(use-package typescript-mode
  :ensure t
  :mode ("\\.ts\\'" . typescript-mode)
  :config
  (setq typescript-indent-level 2))

(use-package json-mode
  :ensure t
  :mode ("\\.json\\'" . json-mode))

;;; 24-web.el ends here
