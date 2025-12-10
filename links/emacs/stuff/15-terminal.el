;;; package --- Summary
;;; Commentary:
;;; Terminal emulator (eat) and terminal-mode settings for emacs -nw over SSH/tmux

;;; Code:

;; Eat - Emulate A Terminal (pure elisp, no native compilation needed)
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

;; Enable mouse in terminal
(unless (display-graphic-p)
  (xterm-mouse-mode 1)
  ;; Mouse scroll
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line))

;; Save minibuffer history between sessions
(savehist-mode 1)

;; Remember cursor position in files
(save-place-mode 1)

;; Auto-save on focus loss (useful for connection drops)
(add-function :after after-focus-change-function
              (lambda () (unless (frame-focus-state) (save-some-buffers t))))

;; OSC 52 clipboard support for terminal (works over SSH/mosh/tmux)
;; This sends clipboard data directly to the terminal emulator
(unless (display-graphic-p)
  ;; Disable default clipboard completely (doesn't work over SSH)
  (setq select-enable-clipboard nil)
  (setq select-enable-primary nil)
  (setq interprogram-cut-function nil)
  (setq interprogram-paste-function nil)

  ;; OSC 52 - works in iTerm2, Blink, tmux, etc.
  (defun osc52-copy (text)
    "Copy TEXT to clipboard using OSC 52 escape sequence."
    (let ((encoded (base64-encode-string text t)))
      (send-string-to-terminal (format "\e]52;c;%s\a" encoded))))

  ;; Hook into evil's yank
  (defun osc52-copy-region (beg end)
    "Copy region to clipboard using OSC 52."
    (interactive "r")
    (osc52-copy (buffer-substring-no-properties beg end)))

  ;; Advice evil-yank to also copy via OSC 52
  (with-eval-after-load 'evil
    (advice-add 'evil-yank :after
                (lambda (beg end &rest _)
                  (osc52-copy (buffer-substring-no-properties beg end))))))

(provide '15-terminal)
;;; 15-terminal.el ends here
