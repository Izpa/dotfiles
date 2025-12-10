;;; package --- Summary
;;; Commentary:

;;; Code:

(use-package transient
  :ensure t)

(use-package eat
  :ensure t
  :config
  ;; Kill process when buffer is killed
  (setq eat-kill-buffer-on-exit t)

  ;; Evil integration - use insert mode to type, ESC to exit
  (with-eval-after-load 'evil
    (evil-set-initial-state 'eat-mode 'insert)

    ;; In insert mode, send keys to terminal
    (evil-define-key 'insert eat-mode-map
      (kbd "<escape>") #'evil-normal-state
      (kbd "C-c") #'eat-self-input)

    ;; In normal mode, standard evil navigation
    (evil-define-key 'normal eat-mode-map
      (kbd "i") #'evil-insert-state
      (kbd "a") #'evil-append
      (kbd "A") #'evil-append-line
      (kbd "p") #'eat-yank))

  ;; Send input in insert mode
  (add-hook 'eat-mode-hook
            (lambda ()
              (setq-local eat-term-name "xterm-256color")
              (eat-emacs-mode))))

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
  (claude-code-terminal-backend 'eat))

(provide '26-ai)
;;; 26-ai.el ends here
