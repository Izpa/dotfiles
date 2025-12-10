;;; package --- Summary
;;; Commentary:
;;; AI coding assistants: aider, claude-code

;;; Code:

(use-package transient
  :ensure t)

(use-package aidermacs
  :ensure t
  :custom
  (aidermacs-default-chat-mode 'architect)
  (aidermacs-backend 'eat)
  (aidermacs-extra-args '("--thinking-tokens" "30k"))
  (aidermacs-default-model "openai/gpt-4o-mini"))

(use-package claude-code
  :ensure t
  :vc (:url "https://github.com/stevemolitor/claude-code.el" :rev :newest)
  :custom
  (claude-code-terminal-backend 'eat)
  :config
  ;; Delete .elc if it causes issues (docstring bug in byte-compilation)
  (let ((elc (locate-library "claude-code.elc")))
    (when elc (delete-file elc))))

(provide '26-ai)
;;; 26-ai.el ends here
