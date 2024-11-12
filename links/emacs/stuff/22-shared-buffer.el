(defun yank-to-clipboard ()
  "Use ANSI OSC 52 escape sequence to attempt clipboard copy"
  ;; https://sunaku.github.io/tmux-yank-osc52.html
  (interactive)
  (let* ((tmx_tty-command "ps l | grep 'tmux attach' | grep -v grep | awk '{print $11}'")
         (tmx_tty (string-trim (shell-command-to-string tmx_tty-command)))
         (base64_text (base64-encode-string (encode-coding-string (substring-no-properties (nth 0 kill-ring)) 'utf-8) t)))
    ;; Check if inside TMUX and if tmx_tty is not empty
    (if (and (getenv "TMUX") (not (string-empty-p tmx_tty)))
        (shell-command
         (format "printf \"\033]52;c;%s\a\" > /dev/%s" base64_text tmx_tty))
      ;; Check if inside SSH
      (if (getenv "SSH_TTY")
          (shell-command (format "printf \"\033]52;c;%s\a\" > %s" base64_text (getenv "SSH_TTY")))
        ;; Send to current TTY
        (send-string-to-terminal (format "\033]52;c;%s\a" base64_text))))))

