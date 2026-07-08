;;; 26-ai.el --- AI coding assistants: gptel, claude-code -*- lexical-binding: t; -*-
;;; Commentary:
;; Two complementary tools:
;;  - gptel: lightweight in-buffer LLM chat / region rewrite (Anthropic backend).
;;  - claude-code: agentic Claude Code CLI running in an eat terminal.
;; (aidermacs was removed -- claude-code covers the agentic-editor niche, and
;; it was pinned to a weak model.)

;;; Code:

(use-package transient
  :ensure t)

;; gptel: quick chat / rewrite, using Claude directly.  API key comes from the
;; ANTHROPIC_API_KEY env var, falling back to ~/.authinfo(.gpg).
(use-package gptel
  :ensure t
  :config
  (setq gptel-default-mode 'markdown-mode)
  (setq gptel-model 'claude-opus-4-8)
  (setq gptel-backend
        (gptel-make-anthropic "Claude"
          :stream t
          :key (lambda ()
                 (or (getenv "ANTHROPIC_API_KEY")
                     (auth-source-pick-first-password
                      :host "api.anthropic.com"))))))

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
