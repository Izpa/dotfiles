;;; package --- Summary
;;; Commentary:
;;; DevOps tools: yaml, dockerfile, docker, kubernetes

;;; Code:

(use-package yaml-mode
  :ensure t
  :mode ("\\.ya?ml\\'" . yaml-mode))

(use-package dockerfile-mode
  :ensure t
  :mode ("Dockerfile\\'" . dockerfile-mode))

(use-package docker
  :ensure t
  :commands docker)

(use-package kubernetes
  :ensure t
  :commands kubernetes-overview)

(use-package kubernetes-evil
  :ensure t
  :after kubernetes)

;;; 27-devops.el ends here
