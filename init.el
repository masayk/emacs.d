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

(global-display-line-numbers-mode t)
(global-set-key (kbd "C-h") 'backward-delete-char)
(global-set-key (kbd "C-;") 'undo)
(global-set-key (kbd "M-i") 'indent-region)

(setq auto-save-default nil)
(setq backup-inhibited t)
(setq create-lockfiles nil)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq recentf-max-saved-items 999)
(setq use-short-answers t)

(put 'upcase-region 'disabled nil) ; C-x C-u -> upcase
(put 'downcase-region 'disabled nil) ; C-x C-l -> downcase


;;
;; Dired
;;

(with-eval-after-load "dired"
  (define-key dired-mode-map (kbd "u") 'dired-up-directory))


;;
;; Helm
;;

(use-package helm
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
(setq org-hide-leading-stars t)

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(add-to-list 'auto-mode-alist '("\\.txt$" . org-mode))

;; org-fold
(load "~/.emacs.d/elisp/org-fold.el")


;;
;; Command
;;

(use-package sequential-command
  :init
  (require 'sequential-command-config)
  (sequential-command-setup-keys))

;;
;; Other
;;

;; dumb-jump
;; whitespace
