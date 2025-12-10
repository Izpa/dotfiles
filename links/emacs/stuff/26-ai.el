;;; package --- Summary
;;; Commentary:

;;; Code:

(use-package transient
  :ensure t)

(use-package aidermacs
  :ensure t
  :custom
  (aidermacs-default-chat-mode 'architect)
  (aidermacs-backend 'vterm)
  (aidermacs-extra-args '("--thinking-tokens" "30k"))
  (aidermacs-default-model "openai/gpt-4o-mini"))

(use-package eat
  :ensure t)

(use-package claude-code
  :ensure t
  :vc (:url "https://github.com/stevemolitor/claude-code.el" :rev :newest)
  :custom
  (claude-code-terminal-backend 'eat))

(provide '26-ai)
;;; 26-ai.el ends here
