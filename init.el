;; custom.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;;
;; Package
;;

;; package.el
(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)


;;
;; General
;;

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(save-place-mode t)

(global-auto-revert-mode t)
(global-display-line-numbers-mode t)
(global-set-key (kbd "C-h") 'backward-delete-char)
(global-set-key (kbd "C-;") 'undo)
(global-set-key (kbd "M-i") 'indent-region)

(setq auto-save-default nil)
(setq backup-inhibited t)
(setq create-lockfiles nil)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq mode-require-final-newline nil)
(setq recentf-max-saved-items 999)
(setq split-height-threshold nil)
(setq split-width-threshold 0)
(setq use-short-answers t)
(setq vc-handled-backends ())

(setq-default abbrev-mode nil)
(setq-default indent-tabs-mode nil)

(put 'upcase-region 'disabled nil) ; C-x C-u -> upcase
(put 'downcase-region 'disabled nil) ; C-x C-l -> downcase

;;
;; Font
;;

(create-fontset-from-ascii-font
 "Menlo-12:weight=normal:slant=normal"
 nil
 "menlokakugo")

(set-fontset-font
 "fontset-menlokakugo"
 'unicode
 (font-spec :family "Hiragino Kaku Gothic ProN")
 nil
 'append)

(add-to-list 'default-frame-alist '(font . "fontset-menlokakugo"))
(setq face-font-rescale-alist '(("Hiragino.*" . 1.2)))


;;
;; Dired
;;

(with-eval-after-load "dired"
  (define-key dired-mode-map (kbd "u") 'dired-up-directory))


;;
;; Theme
;;

(use-package modus-themes
  :ensure t
  :init
  (load-theme 'modus-vivendi t))


;;
;; Helm
;;

(use-package helm
  :ensure t
  :init
  (setq helm-move-to-line-cycle-in-source nil)
  (setq helm-ff-file-name-history-use-recentf t)
  (setq helm-display-function #'display-buffer)
  :bind
  (("M-x" . 'helm-M-x)
   ("C-x C-f" . helm-find-files)
   ("C-x C-r" . helm-for-files)
   ("C-x C-y" . helm-show-kill-ring)
   ("C-x C-b" . helm-buffers-list)
   ("C-x b" . helm-buffers-list)
   :map helm-map
   ("C-h" . delete-backward-char)
   :map helm-find-files-map
   ("C-h" . delete-backward-char)
   ("TAB" . helm-execute-persistent-action)
   :map helm-read-file-map
   ("TAB" . helm-execute-persistent-action))
  :config
  (helm-mode t))


;;
;; Org mode
;;

(setq org-use-speed-commands t) ; move n or p
(setq org-startup-indented t)
(setq org-startup-folded nil)
(setq org-startup-truncated nil)
(setq org-hide-leading-stars t)

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(add-to-list 'auto-mode-alist '("\\.txt$" . org-mode))

;; org-fold
(load "~/.emacs.d/elisp/org-fold.el")

;; org-roam
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/org/org-roam/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (org-roam-db-autosync-mode))


;;
;; Command
;;

(use-package sequential-command
  :ensure t
  :init
  (require 'sequential-command-config)
  (sequential-command-setup-keys))


;;
;; Programming
;;

(use-package php-mode
  :ensure t
  :hook (php-mode . (lambda () (abbrev-mode -1))))

(use-package rust-mode
  :ensure t
  :hook (rust-mode . lsp)
  :custom rust-format-on-save t)

(use-package lsp-mode
  :ensure t
  :commands lsp
  :config
  (setq lsp-rust-server 'rust-analyzer))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package yaml-mode
  :ensure t)

;;
;; Other
;;

(use-package ag
  :ensure t)

(use-package dumb-jump
  :ensure t
  :commands (dumb-jump-xref-activate)
  :init (progn
          (setq dumb-jump-selector 'helm)
          (setq dumb-jump-force-searcher 'ag)
          (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)))

(use-package web-mode
  :ensure t
  :mode (("\\.ctp\\'" . web-mode))
  :config
  (setq
   web-mode-enable-auto-indentation nil
   ))

(defun my-after-save-hook ()
  (when (file-exists-p "~/after_save_hook.sh")
    (shell-command "sh ~/after_save_hook.sh")))
(add-hook 'after-save-hook 'my-after-save-hook)

;; whitespace
