;;; package --- Summary
;;; Commentary:

;;; Code:

(use-package transient
  :ensure t)

(use-package aidermacs
  :config
  :custom
  (aidermacs-default-chat-mode 'architect)
  (aidermacs-default-model "openai/gpt-5"))

;;; 26-ai.el ends here
