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

;; Лучшая работа с clipboard в терминале через tmux
(unless (display-graphic-p)
  (setq select-enable-clipboard t)
  (setq select-enable-primary t))

(provide '29-terminal)
;;; 29-terminal.el ends here
