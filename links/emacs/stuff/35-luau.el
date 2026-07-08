;;; 35-luau.el --- Roblox / Luau development -*- lexical-binding: t; -*-
;;; Commentary:
;; Luau (Roblox) editing: lua-mode for .lua/.luau, eglot driving luau-lsp with
;; Roblox API type definitions + docs, apheleia -> StyLua on save, and helper
;; commands for selene (lint) and rojo sourcemap.
;;
;; Toolchain is managed by Rokit (per-project rokit.toml); binaries live in
;; ~/.rokit/bin.  Roblox API definitions live in ~/.config/luau-lsp/ (shared
;; across projects) -- download with:
;;   curl -sSfL -o ~/.config/luau-lsp/globalTypes.None.d.luau \
;;     https://luau-lsp.pages.dev/type-definitions/globalTypes.None.d.luau
;;   curl -sSfL -o ~/.config/luau-lsp/en-us.json \
;;     https://luau-lsp.pages.dev/api-docs/en-us.json

;;; Code:

;; Make sure Emacs can find the Rokit-managed tools even if the GUI didn't
;; inherit the shell PATH.
(let ((rokit-bin (expand-file-name "~/.rokit/bin")))
  (when (file-directory-p rokit-bin)
    (add-to-list 'exec-path rokit-bin)
    (setenv "PATH" (concat rokit-bin path-separator (getenv "PATH")))))

(use-package lua-mode
  :ensure t
  :mode (("\\.lua\\'" . lua-mode)
         ("\\.luau\\'" . lua-mode))
  :custom
  (lua-indent-level 4))

(defun my/luau-lsp-command (&optional _interactive _project)
  "Return the eglot command for luau-lsp, adding Roblox defs/docs if present."
  (let* ((cfg (expand-file-name "luau-lsp"
                                (or (getenv "XDG_CONFIG_HOME")
                                    (expand-file-name "~/.config"))))
         (defs (expand-file-name "globalTypes.None.d.luau" cfg))
         (docs (expand-file-name "en-us.json" cfg))
         (cmd (list "luau-lsp" "lsp")))
    (when (file-exists-p defs)
      (setq cmd (append cmd (list (concat "--definitions:@roblox=" defs)))))
    (when (file-exists-p docs)
      (setq cmd (append cmd (list (concat "--docs=" docs)))))
    cmd))

(with-eval-after-load 'eglot
  ;; luau-lsp auto-detects sourcemap.json in the project root.
  (add-to-list 'eglot-server-programs '(lua-mode . my/luau-lsp-command))
  ;; Only auto-start when luau-lsp is actually installed.
  (when (executable-find "luau-lsp")
    (add-hook 'lua-mode-hook #'eglot-ensure)))

;; Format on save with StyLua (apheleia is configured in 29-apheleia.el).
(with-eval-after-load 'apheleia
  (add-to-list 'apheleia-mode-alist '(lua-mode . stylua)))

(defun my/luau-project-root ()
  "Directory of the nearest Rojo project."
  (or (locate-dominating-file default-directory "default.project.json")
      default-directory))

(defun my/luau-selene ()
  "Run selene over the project's src/ directory."
  (interactive)
  (let ((default-directory (my/luau-project-root)))
    (compile "selene src")))

(defun my/luau-sourcemap ()
  "Regenerate sourcemap.json so luau-lsp resolves requires/instances."
  (interactive)
  (let ((default-directory (my/luau-project-root)))
    (call-process "rojo" nil "*rojo-sourcemap*" nil
                  "sourcemap" "default.project.json" "--output" "sourcemap.json")
    (message "Regenerated sourcemap.json in %s" default-directory)))

(defun my/luau-serve ()
  "Start `rojo serve' in a compile buffer to sync with Roblox Studio."
  (interactive)
  (let ((default-directory (my/luau-project-root)))
    (compile "rojo serve" t)))

(provide '35-luau)
;;; 35-luau.el ends here
