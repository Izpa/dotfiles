;;; package --- Summary
;;; Commentary:
;;; Настройки для работы в терминале (emacs -nw) через SSH/tmux

;;; Code:

;; Включить мышь в терминале
(unless (display-graphic-p)
  (xterm-mouse-mode 1)
  ;; Прокрутка мышью
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line))

;; Сохранение сессии (открытые буферы, позиции курсора)
(desktop-save-mode 1)
(setq desktop-restore-eager 5)  ; загружать первые 5 буферов сразу, остальные лениво

;; Сохранять историю минибуфера между сессиями
(savehist-mode 1)

;; Запоминать позицию курсора в файлах
(save-place-mode 1)

;; Автосохранение при потере фокуса (полезно при обрыве связи)
(add-hook 'focus-out-hook (lambda () (save-some-buffers t)))

;; OSC 52 clipboard support for terminal (works over SSH/mosh/tmux)
;; This sends clipboard data directly to the terminal emulator
(unless (display-graphic-p)
  ;; Disable default clipboard (doesn't work over SSH)
  (setq select-enable-clipboard nil)
  (setq select-enable-primary nil)

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

(provide '29-terminal)
;;; 29-terminal.el ends here
