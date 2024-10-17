(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(use-package exec-path-from-shell
  :straight t
  :commands exec-path-from-shell-initialize
  :config
  (exec-path-from-shell-initialize))

(use-package nix-mode
  :straight t
  :mode "\\.nix\\'")

(use-package crystal-mode
  :straight t)

(use-package all-the-icons
  :straight t)

(use-package treemacs
  :straight t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config)
(treemacs-start-on-boot)

(use-package doom-themes
  :straight t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-palenight t)
  (setq doom-themes-treemacs-theme "doom-palenight")
  (doom-themes-treemacs-config))

(use-package terraform-mode
  :straight t)

(use-package company
  :straight t)

(add-hook 'after-init-hook 'global-company-mode)

(use-package lsp-mode
  :straight t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (
	 (terraform-mode . lsp)
	 (crystal-mode . lsp))
  :commands lsp)

(setq lsp-disabled-clients '(tfls))

(setq lsp-terraform-ls-server "@tfls@/bin/terraform-ls")
; (setq lsp-clients-crystal-executable '("@crystalls@/bin/crystalline" "--stdio"))

(use-package magit
  :straight t)

(if window-system
    (tool-bar-mode -1))

(setq cursor-type 'bar)

(global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#")))

(add-to-list 'auto-mode-alist '("\\.json.tpl\\'" . js-mode))

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
